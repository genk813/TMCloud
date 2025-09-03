#!/usr/bin/env python3
"""
TMCloud PostgreSQL インポートシステム V2
237テーブル対応版（3-3b.xlsx + 5-1.xlsx統合）
"""

import sys
import os
import json
import csv
import re
import traceback
import logging
from pathlib import Path
from datetime import datetime
from typing import Dict, List, Optional, Any, Tuple
import platform

# psycopg2のインポート
try:
    import psycopg2
    from psycopg2.extras import RealDictCursor
except ImportError:
    print("エラー: psycopg2がインストールされていません")
    print("実行: pip install psycopg2-binary")
    sys.exit(1)

# chardetのインポート
try:
    import chardet
except ImportError:
    print("エラー: chardetがインストールされていません")
    print("実行: pip install chardet")
    sys.exit(1)

# ========== 設定 ==========

# PostgreSQL接続情報
DB_CONFIG = {
    'host': 'localhost',
    'port': 5432,
    'database': 'tmcloud_db',
    'user': 'ygenk',
    'password': 'tmcloud'
}

# ログ設定
LOG_DIR = Path('logs')
LOG_DIR.mkdir(exist_ok=True)

# ========== ユーティリティ関数 ==========

def setup_logging():
    """ロギングのセットアップ"""
    timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
    log_file = LOG_DIR / f'import_{timestamp}.log'
    
    logging.basicConfig(
        level=logging.INFO,
        format='%(asctime)s [%(levelname)s] %(message)s',
        handlers=[
            logging.FileHandler(log_file, encoding='utf-8'),
            logging.StreamHandler()
        ]
    )
    
    return logging.getLogger(__name__)

def detect_encoding(file_path):
    """ファイルのエンコーディングを検出"""
    with open(file_path, 'rb') as f:
        raw = f.read(100000)
        result = chardet.detect(raw)
        
    # 一般的なエンコーディングの優先順位
    encoding = result['encoding']
    if encoding and 'SHIFT' in encoding.upper():
        return 'shift_jis'
    elif encoding and 'CP932' in encoding.upper():
        return 'cp932'
    elif encoding == 'ascii':
        return 'utf-8'  # ASCIIならUTF-8として扱う
    
    return encoding or 'utf-8'

def clean_value(value, column_name=''):
    """値のクレンジング処理"""
    if value is None or value == '':
        return None
    
    # 文字列の場合
    if isinstance(value, str):
        value = value.strip()
        
        # 空文字列
        if value == '':
            return None
        
        # 7桁以上の0のみの文字列はNULL（31桁の0など）
        if re.match(r'^0+$', value) and len(value) >= 7:
            return None
        
        # ハイフン除去（日付カラムの場合）
        if any(date_word in column_name.lower() for date_word in ['date', '_dt', 'day', '日付']):
            value = value.replace('-', '')
            # 8桁の日付形式チェック
            if re.match(r'^\d{8}$', value):
                # 00000000は NULLに
                if value == '00000000':
                    return None
                # 有効な日付範囲チェック（1900-2099年）
                year = int(value[:4])
                if year < 1900 or year > 2099:
                    return None
        
        # 不要な制御文字を削除
        value = re.sub(r'[\x00-\x1f\x7f]', '', value)
        
        # 全角スペースを半角に統一
        value = value.replace('　', ' ')
        
        # 連続するスペースを1つに
        value = re.sub(r'\s+', ' ', value)
        
        return value.strip()
    
    return value

def get_db_connection():
    """データベース接続を取得"""
    try:
        conn = psycopg2.connect(
            **DB_CONFIG,
            client_encoding='UTF8'
        )
        conn.autocommit = False  # 明示的にトランザクション管理
        return conn
    except psycopg2.Error as e:
        logging.error(f"DB接続エラー: {e}")
        raise

def check_table_exists(conn, table_name):
    """テーブルの存在確認"""
    with conn.cursor() as cur:
        cur.execute("""
            SELECT EXISTS (
                SELECT FROM information_schema.tables 
                WHERE table_schema = 'public' 
                AND table_name = %s
            )
        """, (table_name,))
        return cur.fetchone()[0]

def get_table_columns(conn, table_name):
    """テーブルのカラム情報を取得"""
    with conn.cursor() as cur:
        cur.execute("""
            SELECT column_name 
            FROM information_schema.columns 
            WHERE table_schema = 'public' 
            AND table_name = %s
            ORDER BY ordinal_position
        """, (table_name,))
        return [row[0] for row in cur.fetchall()]

def match_columns(tsv_columns, db_columns, logger):
    """TSVカラムとDBカラムのマッチング"""
    # 完全一致を試みる
    if set(tsv_columns) == set(db_columns):
        return {col: col for col in tsv_columns}
    
    # 部分一致の場合
    mapping = {}
    unmatched_tsv = []
    unmatched_db = set(db_columns)
    
    for tsv_col in tsv_columns:
        if tsv_col in db_columns:
            mapping[tsv_col] = tsv_col
            unmatched_db.discard(tsv_col)
        else:
            unmatched_tsv.append(tsv_col)
    
    if unmatched_tsv:
        logger.warning(f"  TSVにのみ存在: {unmatched_tsv[:5]}")  # 最初の5個
    if unmatched_db:
        logger.warning(f"  DBにのみ存在: {list(unmatched_db)[:5]}")
    
    return mapping

# ========== メイン処理 ==========

def import_single_table(conn, table_name, tsv_file, spec, logger):
    """単一テーブルのインポート処理（1行ずつ）"""
    
    # エンコーディング検出
    encoding = detect_encoding(tsv_file)
    logger.info(f"  エンコーディング: {encoding}")
    
    # テーブルのカラム情報取得
    db_columns = get_table_columns(conn, table_name)
    if not db_columns:
        logger.error(f"  テーブル {table_name} のカラム情報が取得できません")
        return {'success': 0, 'errors': 0, 'skipped': 1}
    
    success_count = 0
    error_count = 0
    
    # TSVファイルを読み込み
    with open(tsv_file, 'r', encoding=encoding, errors='replace') as f:
        reader = csv.DictReader(f, delimiter='\t')
        
        # カラムマッチング
        if not reader.fieldnames:
            logger.error(f"  TSVファイルのヘッダーが読み取れません")
            return {'success': 0, 'errors': 0, 'skipped': 1}
        
        column_mapping = match_columns(list(reader.fieldnames), db_columns, logger)
        
        if not column_mapping:
            logger.error(f"  マッピング可能なカラムがありません")
            return {'success': 0, 'errors': 0, 'skipped': 1}
        
        # 使用するカラム
        use_columns = list(column_mapping.values())
        logger.info(f"  使用カラム数: {len(use_columns)}/{len(db_columns)}")
        
        # 1行ずつ処理
        for row_num, row in enumerate(reader, start=1):
            try:
                # 値をクレンジング
                values = []
                for tsv_col, db_col in column_mapping.items():
                    value = clean_value(row.get(tsv_col), db_col)
                    values.append(value)
                
                # NULL以外の値がある場合のみインサート
                if any(v is not None for v in values):
                    # INSERT文を構築
                    placeholders = ', '.join(['%s'] * len(values))
                    columns_str = ', '.join(use_columns)
                    
                    insert_sql = f"""
                        INSERT INTO {table_name} ({columns_str})
                        VALUES ({placeholders})
                        ON CONFLICT DO NOTHING
                    """
                    
                    with conn.cursor() as cur:
                        cur.execute(insert_sql, values)
                    
                    success_count += 1
                    
                    # 進捗表示（1000行ごと）
                    if row_num % 1000 == 0:
                        logger.info(f"    {row_num}行処理済み...")
                
            except Exception as e:
                error_count += 1
                if error_count <= 5:  # 最初の5エラーのみログ
                    logger.error(f"    行{row_num}エラー: {e}")
                
                # エラーが多すぎる場合は中断
                if error_count > 1000:
                    logger.error(f"  エラーが多すぎるため中断")
                    break
    
    # コミット
    conn.commit()
    
    return {
        'success': success_count,
        'errors': error_count,
        'skipped': 0
    }

def main(tsv_date):
    """メイン処理"""
    logger = setup_logging()
    
    logger.info("="*60)
    logger.info("TMCloud PostgreSQL インポート開始 V2")
    logger.info("="*60)
    
    # 統合仕様JSON読み込み
    json_file = Path('/mnt/c/Users/ygenk/Desktop/TMCloud/all_specs_merged.json')
    if not json_file.exists():
        logger.error(f"仕様ファイルが見つかりません: {json_file}")
        sys.exit(1)
    
    with open(json_file, 'r', encoding='utf-8') as f:
        all_specs = json.load(f)
    
    logger.info(f"テーブル定義数: {len(all_specs)}")
    
    # TSVディレクトリ
    tsv_base = Path('tsv_data/tsv') / tsv_date
    if not tsv_base.exists():
        logger.error(f"TSVディレクトリが見つかりません: {tsv_base}")
        sys.exit(1)
    
    # データベース接続
    conn = None
    try:
        conn = get_db_connection()
        logger.info("DB接続成功")
        
        # 統計情報
        total_stats = {
            'total_success': 0,
            'total_errors': 0,
            'total_skipped': 0,
            'table_stats': {}
        }
        
        # 各テーブルを処理
        for i, (table_name, spec) in enumerate(all_specs.items(), 1):
            # TSVファイルを探す
            tsv_patterns = [
                f"{table_name}.tsv",
                f"upd_{table_name}.tsv",
                f"del_{table_name}.tsv"
            ]
            
            tsv_file = None
            for pattern in tsv_patterns:
                candidate = tsv_base / pattern
                if candidate.exists():
                    tsv_file = candidate
                    break
            
            logger.info(f"\n[{i}/{len(all_specs)}] {table_name}")
            
            # テーブル存在確認
            if not check_table_exists(conn, table_name):
                logger.warning(f"  テーブル {table_name} が存在しません（スキップ）")
                total_stats['table_stats'][table_name] = {'success': 0, 'errors': 0, 'skipped': 1}
                total_stats['total_skipped'] += 1
                continue
            
            # TSVファイルがない場合
            if not tsv_file:
                logger.info(f"  TSVファイルなし（スキップ）")
                total_stats['table_stats'][table_name] = {'success': 0, 'errors': 0, 'skipped': 1}
                total_stats['total_skipped'] += 1
                continue
            
            logger.info(f"  TSVファイル: {tsv_file.name}")
            
            # インポート実行
            result = import_single_table(conn, table_name, tsv_file, spec, logger)
            
            # 統計更新
            total_stats['table_stats'][table_name] = result
            total_stats['total_success'] += result['success']
            total_stats['total_errors'] += result['errors']
            total_stats['total_skipped'] += result['skipped']
            
            logger.info(f"  結果: 成功={result['success']}, エラー={result['errors']}")
        
        # 最終結果
        logger.info("\n" + "="*60)
        logger.info("インポート完了")
        logger.info("="*60)
        logger.info(f"成功: {total_stats['total_success']}行")
        logger.info(f"エラー: {total_stats['total_errors']}行")
        logger.info(f"スキップ: {total_stats['total_skipped']}テーブル")
        
        # 結果をJSON保存
        result_file = LOG_DIR / f'import_result_{datetime.now().strftime("%Y%m%d_%H%M%S")}.json'
        with open(result_file, 'w', encoding='utf-8') as f:
            json.dump(total_stats, f, ensure_ascii=False, indent=2)
        
        logger.info(f"\n結果ファイル: {result_file}")
        
    except Exception as e:
        logger.error(f"エラー: {e}")
        logger.error(traceback.format_exc())
        if conn:
            conn.rollback()
        sys.exit(1)
    
    finally:
        if conn:
            conn.close()

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("使用方法: python tmcloud_import_postgresql_v2.py [TSV日付]")
        print("例: python tmcloud_import_postgresql_v2.py 20250618")
        sys.exit(1)
    
    tsv_date = sys.argv[1]
    main(tsv_date)
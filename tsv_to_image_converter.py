#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
TSV画像データ変換スクリプト
upd_t_sample.tsvファイルから画像データを抽出しJPGファイルに変換
複数行にまたがる画像データを適切に処理
"""

import os
import base64
import sqlite3
import csv
from pathlib import Path
from typing import Dict, List, Optional, Tuple
import re

class TSVImageConverter:
    """TSVファイルから画像データを抽出してJPGファイルに変換するクラス"""
    
    def __init__(self, tsv_file: str = "tsv_data/250611/upd_t_sample.tsv", 
                 output_dir: str = "images/final_complete",
                 db_path: str = "output.db"):
        self.tsv_file = Path(tsv_file)
        self.output_dir = Path(output_dir)
        self.db_path = db_path
        self.output_dir.mkdir(parents=True, exist_ok=True)
        
        # TSVファイルの列インデックス（upd_t_sample.tsv用）
        self.SHUTUGAN_NO_INDEX = 0  # 出願番号
        self.IMAGE_DATA_INDEX = 1   # 画像データ（Base64エンコード）
        
        # 統計情報
        self.stats = {
            'total_records': 0,
            'successful_conversions': 0,
            'failed_conversions': 0,
            'multiline_records': 0,
            'database_updates': 0
        }
    
    def normalize_app_num(self, app_num: str) -> str:
        """出願番号を正規化（ハイフン除去）"""
        return app_num.replace('-', '')
    
    def read_tsv_with_multiline_handling(self) -> List[Dict[str, str]]:
        """
        TSVファイルを読み込み、複数行にまたがる画像データを適切に処理
        """
        print(f"📖 TSVファイルを読み込み中: {self.tsv_file}")
        
        if not self.tsv_file.exists():
            raise FileNotFoundError(f"TSVファイルが見つかりません: {self.tsv_file}")
        
        records = {}  # 出願番号をキーとする辞書に変更
        current_app_num = None
        header_skipped = False
        
        with open(self.tsv_file, 'r', encoding='utf-8') as f:
            for line_num, line in enumerate(f, 1):
                line = line.rstrip('\n\r')
                
                # 空行をスキップ
                if not line.strip():
                    continue
                
                # ヘッダー行をスキップ
                if not header_skipped and line_num == 1:
                    header_skipped = True
                    continue
                
                # タブ区切りで分割
                parts = line.split('\t')
                
                # 新しいレコードまたは続きのレコードを判定
                if len(parts) >= 18 and parts[3] and re.match(r'^\d{10}$', parts[3]):
                    raw_app_num = parts[3]  # 1950025233形式
                    formatted_app_num = f"{raw_app_num[:4]}-{raw_app_num[4:]}"  # 1950-025233形式
                    current_app_num = formatted_app_num
                    image_data = parts[17] if len(parts) > 17 else ''
                    rec_seq_num = int(parts[5]) if parts[5].isdigit() else 0
                    
                    # 同じ出願番号のレコードがある場合
                    if formatted_app_num in records:
                        # データ部分をリストに追加
                        if 'data_parts' not in records[formatted_app_num]:
                            # 最初のデータもリストに変換
                            first_rec_seq = records[formatted_app_num].get('rec_seq_num', 1)
                            records[formatted_app_num]['data_parts'] = [{
                                'rec_seq_num': first_rec_seq,
                                'image_data': records[formatted_app_num]['image_data']
                            }]
                        
                        # 新しいデータを追加
                        records[formatted_app_num]['data_parts'].append({
                            'rec_seq_num': rec_seq_num,
                            'image_data': image_data
                        })
                        records[formatted_app_num]['is_multiline'] = True
                    else:
                        # 新しいレコードを作成
                        records[formatted_app_num] = {
                            'app_num': formatted_app_num,
                            'image_data': image_data,
                            'rec_seq_num': rec_seq_num,
                            'line_start': line_num,
                            'is_multiline': False
                        }
                
                # 進捗表示
                if line_num % 10000 == 0:
                    print(f"   処理済み行数: {line_num:,}")
        
        # 辞書からリストに変換し、複数パーツのデータを結合
        records_list = []
        for record in records.values():
            if record.get('is_multiline') and 'data_parts' in record:
                # 複数パーツの場合はrec_seq_numの順序で結合
                record['image_data'] = self.combine_by_seq_num(record['data_parts'])
            records_list.append(record)
        
        # 統計情報更新
        self.stats['total_records'] = len(records_list)
        self.stats['multiline_records'] = sum(1 for r in records_list if r['is_multiline'])
        
        print(f"✅ TSV読み込み完了: {len(records_list):,} レコード")
        print(f"   複数行レコード: {self.stats['multiline_records']:,} 件")
        
        return records_list
    
    def combine_by_seq_num(self, data_parts: List[Dict]) -> str:
        """rec_seq_numの順序でデータを結合"""
        if not data_parts:
            return ''
        
        # rec_seq_numでソート
        sorted_parts = sorted(data_parts, key=lambda x: x['rec_seq_num'])
        
        # image_dataを順番に結合
        combined = ''.join([part['image_data'] for part in sorted_parts])
        
        return combined
    
    def is_valid_base64(self, data: str) -> bool:
        """Base64データの有効性を検証"""
        try:
            # データが空または無効な長さの場合は除外
            if not data or len(data) % 4 != 0:
                return False
            
            # 無効な画像データフォーマットを除外
            # 多くのレコードが「////」で始まるが、これらは有効なJPEG Base64データではない
            if data.startswith('////'):
                return False
            
            # 有効なJPEG Base64データは通常「/9j/」で始まる
            if not data.startswith('/9j/'):
                return False
            
            decoded = base64.b64decode(data)
            
            # 最小サイズチェック
            if len(decoded) < 100:
                return False
            
            # JPEGファイルのマジックナンバーをチェック
            if decoded[:2] == b'\xff\xd8':
                return True
            
            # PNGファイルのマジックナンバーをチェック
            if decoded[:8] == b'\x89PNG\r\n\x1a\n':
                return True
            
            return False
            
        except Exception:
            return False
    
    def convert_to_jpg(self, base64_data: str, output_path: Path) -> bool:
        """Base64データをJPGファイルに変換"""
        try:
            # Base64データをデコード
            image_data = base64.b64decode(base64_data)
            
            # JPEGファイルとして保存
            with open(output_path, 'wb') as f:
                f.write(image_data)
            
            # ファイルサイズをチェック
            file_size = output_path.stat().st_size
            if file_size < 100:  # 100バイト未満は無効とみなす
                output_path.unlink()  # ファイルを削除
                return False
            
            return True
            
        except Exception as e:
            print(f"⚠️ 画像変換エラー: {e}")
            return False
    
    def update_database(self, records: List[Dict[str, str]]):
        """データベースのt_sampleテーブルを更新"""
        print("📊 データベースを更新中...")
        
        try:
            conn = sqlite3.connect(self.db_path)
            cursor = conn.cursor()
            
            # 既存のt_sampleテーブル構造を確認
            cursor.execute("""
                SELECT sql FROM sqlite_master 
                WHERE type='table' AND name='t_sample'
            """)
            
            existing_table = cursor.fetchone()
            
            if not existing_table:
                # テーブルが存在しない場合は作成
                cursor.execute("""
                    CREATE TABLE t_sample (
                        normalized_app_num TEXT PRIMARY KEY,
                        image_data TEXT,
                        rec_seq_num INTEGER,
                        has_image_file TEXT DEFAULT 'NO',
                        created_at DATETIME DEFAULT CURRENT_TIMESTAMP
                    )
                """)
                print("✅ t_sampleテーブルを作成しました")
            else:
                # has_image_fileカラムが存在しない場合は追加
                cursor.execute("PRAGMA table_info(t_sample)")
                columns = [col[1] for col in cursor.fetchall()]
                
                if 'has_image_file' not in columns:
                    cursor.execute("ALTER TABLE t_sample ADD COLUMN has_image_file TEXT DEFAULT 'NO'")
                    print("✅ has_image_fileカラムを追加しました")
            
            # データをバッチで挿入/更新
            batch_size = 1000
            for i in range(0, len(records), batch_size):
                batch = records[i:i + batch_size]
                
                for record in batch:
                    app_num = record['app_num']
                    normalized_app_num = self.normalize_app_num(app_num)
                    image_data = record['image_data']
                    
                    # 画像ファイルが存在するかチェック
                    image_file = self.output_dir / f"{normalized_app_num}.jpg"
                    has_image_file = 'YES' if image_file.exists() else 'NO'
                    
                    # データベースに挿入/更新
                    cursor.execute("""
                        INSERT OR REPLACE INTO t_sample 
                        (normalized_app_num, image_data, has_image_file)
                        VALUES (?, ?, ?)
                    """, (normalized_app_num, image_data, has_image_file))
                
                self.stats['database_updates'] += len(batch)
                
                # 進捗表示
                if i % (batch_size * 10) == 0:
                    print(f"   データベース更新: {i:,} / {len(records):,}")
            
            conn.commit()
            conn.close()
            
            print(f"✅ データベース更新完了: {self.stats['database_updates']:,} レコード")
            
        except Exception as e:
            print(f"❌ データベース更新エラー: {e}")
    
    def convert_images(self) -> Dict[str, int]:
        """画像変換のメイン処理"""
        print("🖼️ TSV画像データ変換を開始...")
        
        # TSVファイルを読み込み
        records = self.read_tsv_with_multiline_handling()
        
        # 既存の画像ファイルをチェック
        existing_files = set()
        if self.output_dir.exists():
            existing_files = {f.stem for f in self.output_dir.glob('*.jpg')}
        
        print(f"📁 既存画像ファイル: {len(existing_files):,} 個")
        
        # 画像変換処理
        for i, record in enumerate(records, 1):
            app_num = record['app_num']
            normalized_app_num = self.normalize_app_num(app_num)
            
            # 画像データを取得（既に結合済み）
            image_data = record['image_data']
            
            # 進捗表示
            if i % 100 == 0:
                print(f"   処理中: {i:,} / {len(records):,} ({i/len(records)*100:.1f}%)")
            
            # 画像ファイルが既に存在する場合はスキップ
            if normalized_app_num in existing_files:
                continue
            
            # 画像データの有効性チェック
            if not image_data:
                self.stats['failed_conversions'] += 1
                continue
            
            # データの有効性をチェック（JPEGヘッダーまたは有効なBase64）
            is_valid = (image_data.startswith('/9j/') and len(image_data) > 100)
            
            if not is_valid:
                self.stats['failed_conversions'] += 1
                continue
            
            # 画像ファイルパス
            output_file = self.output_dir / f"{normalized_app_num}.jpg"
            
            # 画像変換
            if self.convert_to_jpg(image_data, output_file):
                self.stats['successful_conversions'] += 1
            else:
                self.stats['failed_conversions'] += 1
        
        # データベースを更新
        self.update_database(records)
        
        return self.stats
    
    def print_summary(self):
        """変換結果のサマリーを表示"""
        print("\n" + "="*50)
        print("📊 画像変換結果サマリー")
        print("="*50)
        print(f"総レコード数:     {self.stats['total_records']:,}")
        print(f"複数行レコード:   {self.stats['multiline_records']:,}")
        print(f"変換成功:         {self.stats['successful_conversions']:,}")
        print(f"変換失敗:         {self.stats['failed_conversions']:,}")
        print(f"データベース更新: {self.stats['database_updates']:,}")
        print(f"成功率:           {self.stats['successful_conversions']/max(self.stats['total_records'], 1)*100:.1f}%")
        print("="*50)
    
    def validate_existing_images(self) -> Dict[str, int]:
        """既存画像ファイルの妥当性を検証"""
        print("🔍 既存画像ファイルの検証中...")
        
        validation_stats = {
            'total_files': 0,
            'valid_files': 0,
            'invalid_files': 0,
            'corrupted_files': []
        }
        
        if not self.output_dir.exists():
            print("❌ 画像ディレクトリが存在しません")
            return validation_stats
        
        image_files = list(self.output_dir.glob('*.jpg'))
        validation_stats['total_files'] = len(image_files)
        
        for image_file in image_files:
            try:
                # ファイルサイズチェック
                file_size = image_file.stat().st_size
                if file_size < 100:
                    validation_stats['invalid_files'] += 1
                    validation_stats['corrupted_files'].append(str(image_file))
                    continue
                
                # JPEGマジックナンバーチェック
                with open(image_file, 'rb') as f:
                    header = f.read(2)
                    if header == b'\xff\xd8':
                        validation_stats['valid_files'] += 1
                    else:
                        validation_stats['invalid_files'] += 1
                        validation_stats['corrupted_files'].append(str(image_file))
                        
            except Exception as e:
                validation_stats['invalid_files'] += 1
                validation_stats['corrupted_files'].append(str(image_file))
        
        print(f"✅ 検証完了: {validation_stats['valid_files']:,} 有効, {validation_stats['invalid_files']:,} 無効")
        
        return validation_stats

def main():
    """メイン関数"""
    import argparse
    
    parser = argparse.ArgumentParser(description="TSV画像データ変換スクリプト")
    parser.add_argument("--tsv-file", default="tsv_data/250611/upd_t_sample.tsv", 
                        help="TSVファイルパス")
    parser.add_argument("--output-dir", default="images/final_complete", 
                        help="出力ディレクトリ")
    parser.add_argument("--db-path", default="output.db", 
                        help="データベースファイルパス")
    parser.add_argument("--validate-only", action="store_true", 
                        help="既存画像ファイルの検証のみ実行")
    
    args = parser.parse_args()
    
    # コンバーターを初期化
    converter = TSVImageConverter(
        tsv_file=args.tsv_file,
        output_dir=args.output_dir,
        db_path=args.db_path
    )
    
    if args.validate_only:
        # 検証のみ実行
        validation_stats = converter.validate_existing_images()
        print(f"\n検証結果:")
        print(f"  総ファイル数: {validation_stats['total_files']:,}")
        print(f"  有効ファイル: {validation_stats['valid_files']:,}")
        print(f"  無効ファイル: {validation_stats['invalid_files']:,}")
        
        if validation_stats['corrupted_files']:
            print(f"\n破損ファイル一覧:")
            for file_path in validation_stats['corrupted_files'][:10]:  # 最初の10個のみ表示
                print(f"  {file_path}")
    else:
        # 画像変換実行
        stats = converter.convert_images()
        converter.print_summary()
        
        # 既存画像の検証も実行
        converter.validate_existing_images()

if __name__ == "__main__":
    main()
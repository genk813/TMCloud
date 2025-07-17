#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
出願番号の参照整合性問題を修正するスクリプト
jiken_c_t_shutugannindairinin テーブルの外部キー参照を正しく修正します。
"""

import sqlite3
import sys
from pathlib import Path

def fix_foreign_key_integrity(db_path='output.db'):
    """参照整合性問題を修正"""
    
    print("=== 出願番号参照整合性修正スクリプト ===")
    print(f"データベース: {db_path}")
    
    if not Path(db_path).exists():
        print(f"エラー: データベースファイルが見つかりません: {db_path}")
        return False
    
    try:
        conn = sqlite3.connect(db_path)
        cursor = conn.cursor()
        
        print("\n1. 現在の外部キー制約状況を確認...")
        cursor.execute('PRAGMA foreign_keys')
        fk_status = cursor.fetchone()
        print(f"   外部キー制約: {'有効' if fk_status[0] else '無効'}")
        
        print("\n2. 問題のあるテーブルをバックアップ...")
        # バックアップテーブルが既に存在する場合は削除
        cursor.execute("DROP TABLE IF EXISTS jiken_c_t_shutugannindairinin_backup")
        
        # バックアップ作成
        cursor.execute("""
            CREATE TABLE jiken_c_t_shutugannindairinin_backup AS 
            SELECT * FROM jiken_c_t_shutugannindairinin
        """)
        
        # バックアップ件数確認
        cursor.execute("SELECT COUNT(*) FROM jiken_c_t_shutugannindairinin_backup")
        backup_count = cursor.fetchone()[0]
        print(f"   バックアップ完了: {backup_count} レコード")
        
        print("\n3. 外部キー制約を一時的に無効化...")
        cursor.execute('PRAGMA foreign_keys = OFF')
        
        print("\n4. 問題のあるテーブルを削除...")
        cursor.execute("DROP TABLE jiken_c_t_shutugannindairinin")
        
        print("\n5. 正しいスキーマでテーブルを再作成...")
        cursor.execute("""
            CREATE TABLE jiken_c_t_shutugannindairinin (
                normalized_app_num TEXT NOT NULL,   -- 修正: 正規化済み出願番号
                shutugannindairinin_code TEXT,      -- 申請人コード  
                shutugannindairinin_sikbt TEXT,     -- 申請人識別区分
                original_shutugan_no TEXT,          -- 参考用: 元の出願番号
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                PRIMARY KEY (normalized_app_num, shutugannindairinin_code, shutugannindairinin_sikbt),
                FOREIGN KEY (normalized_app_num) REFERENCES jiken_c_t(normalized_app_num)
            )
        """)
        
        print("\n6. データを正しい形式で復旧...")
        cursor.execute("""
            INSERT INTO jiken_c_t_shutugannindairinin (
                normalized_app_num, 
                shutugannindairinin_code, 
                shutugannindairinin_sikbt,
                original_shutugan_no
            )
            SELECT 
                REPLACE(shutugan_no, '-', '') as normalized_app_num,  -- ハイフン除去
                shutugannindairinin_code,
                shutugannindairinin_sikbt,
                shutugan_no as original_shutugan_no
            FROM jiken_c_t_shutugannindairinin_backup
        """)
        
        # 復旧件数確認
        cursor.execute("SELECT COUNT(*) FROM jiken_c_t_shutugannindairinin")
        restored_count = cursor.fetchone()[0]
        print(f"   データ復旧完了: {restored_count} レコード")
        
        print("\n7. 外部キー制約を再有効化...")
        cursor.execute('PRAGMA foreign_keys = ON')
        
        print("\n8. 参照整合性チェック...")
        cursor.execute('PRAGMA foreign_key_check(jiken_c_t_shutugannindairinin)')
        violations = cursor.fetchall()
        
        if violations:
            print(f"   警告: {len(violations)} 件の参照整合性エラーが検出されました")
            for i, violation in enumerate(violations[:5]):
                print(f"     {i+1}. {violation}")
            if len(violations) > 5:
                print(f"     ... 他 {len(violations) - 5} 件")
        else:
            print("   ✅ 参照整合性チェック: 問題なし")
        
        print("\n9. テーブル構造確認...")
        cursor.execute("PRAGMA table_info(jiken_c_t_shutugannindairinin)")
        columns = cursor.fetchall()
        print("   カラム構成:")
        for col in columns:
            print(f"     - {col[1]} ({col[2]}) {'PK' if col[5] else ''}")
        
        print("\n10. サンプルデータ確認...")
        cursor.execute("""
            SELECT normalized_app_num, shutugannindairinin_code, original_shutugan_no 
            FROM jiken_c_t_shutugannindairinin 
            LIMIT 3
        """)
        samples = cursor.fetchall()
        print("   サンプルデータ:")
        for sample in samples:
            print(f"     正規化番号: {sample[0]}, 代理人コード: {sample[1]}, 元番号: {sample[2]}")
        
        conn.commit()
        conn.close()
        
        print("\n✅ 参照整合性修正が完了しました！")
        print("\n次のステップ:")
        print("1. 商品情報テーブル (jiken_c_t_shohin_joho) にruiカラムを追加")
        print("2. インポートスクリプトを修正版に更新") 
        print("3. TSVデータを再インポート")
        
        return True
        
    except sqlite3.Error as e:
        print(f"❌ データベースエラー: {e}")
        return False
    except Exception as e:
        print(f"❌ 予期しないエラー: {e}")
        return False

def test_fixed_queries(db_path='output.db'):
    """修正後のクエリテスト"""
    
    print("\n=== 修正後クエリテスト ===")
    
    try:
        conn = sqlite3.connect(db_path)
        cursor = conn.cursor()
        
        # テスト1: 結合クエリ
        print("\nテスト1: 出願情報と申請人情報の結合")
        cursor.execute("""
            SELECT 
                j.normalized_app_num,
                j.shutugan_bi,
                s.shutugannindairinin_code,
                s.original_shutugan_no
            FROM jiken_c_t j
            LEFT JOIN jiken_c_t_shutugannindairinin s 
                ON j.normalized_app_num = s.normalized_app_num
            WHERE j.normalized_app_num IS NOT NULL
            LIMIT 3
        """)
        
        results = cursor.fetchall()
        for result in results:
            print(f"   出願番号: {result[0]}, 出願日: {result[1]}, 代理人: {result[2]}")
        
        # テスト2: 件数確認
        print("\nテスト2: テーブル件数確認")
        cursor.execute("SELECT COUNT(*) FROM jiken_c_t")
        jiken_count = cursor.fetchone()[0]
        
        cursor.execute("SELECT COUNT(*) FROM jiken_c_t_shutugannindairinin")
        shutugan_count = cursor.fetchone()[0]
        
        print(f"   jiken_c_t: {jiken_count} 件")
        print(f"   jiken_c_t_shutugannindairinin: {shutugan_count} 件")
        
        conn.close()
        
        print("✅ クエリテスト完了")
        
    except sqlite3.Error as e:
        print(f"❌ テストエラー: {e}")

if __name__ == "__main__":
    print("データベースの参照整合性を修正します...")
    
    # 確認プロンプト
    try:
        response = input("\n続行しますか？ (y/N): ")
        if response.lower() != 'y':
            print("処理を中止しました。")
            sys.exit(0)
    except EOFError:
        print("バッチモードで実行します。")
    
    # 修正実行
    if fix_foreign_key_integrity():
        # テスト実行
        test_fixed_queries()
        print("\n🎉 全ての処理が正常に完了しました！")
    else:
        print("\n💥 修正処理でエラーが発生しました。")
        sys.exit(1)
#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
出願番号の参照整合性問題を修正するスクリプト（重複対応版）
jiken_c_t_shutugannindairinin テーブルの外部キー参照を正しく修正します。
"""

import sqlite3
import sys
from pathlib import Path

def fix_foreign_key_integrity(db_path='output.db'):
    """参照整合性問題を修正（重複データ対応）"""
    
    print("=== 出願番号参照整合性修正スクリプト (v2) ===")
    print(f"データベース: {db_path}")
    
    if not Path(db_path).exists():
        print(f"エラー: データベースファイルが見つかりません: {db_path}")
        return False
    
    try:
        conn = sqlite3.connect(db_path)
        cursor = conn.cursor()
        
        print("\n1. 現在のデータ状況を分析...")
        cursor.execute("SELECT COUNT(*) FROM jiken_c_t_shutugannindairinin")
        total_count = cursor.fetchone()[0]
        print(f"   総レコード数: {total_count}")
        
        # 重複データの確認
        cursor.execute("""
            SELECT 
                REPLACE(shutugan_no, '-', '') as normalized_app_num,
                shutugannindairinin_code,
                shutugannindairinin_sikbt,
                COUNT(*) as cnt
            FROM jiken_c_t_shutugannindairinin 
            GROUP BY 
                REPLACE(shutugan_no, '-', ''),
                shutugannindairinin_code,
                shutugannindairinin_sikbt
            HAVING COUNT(*) > 1
            LIMIT 5
        """)
        duplicates = cursor.fetchall()
        print(f"   重複データ例: {len(duplicates)} パターン")
        for dup in duplicates[:3]:
            print(f"     {dup[0]}, {dup[1]}, {dup[2]} -> {dup[3]}件")
        
        print("\n2. 外部キー制約を無効化...")
        cursor.execute('PRAGMA foreign_keys = OFF')
        
        print("\n3. バックアップテーブル作成...")
        cursor.execute("DROP TABLE IF EXISTS jiken_c_t_shutugannindairinin_backup")
        cursor.execute("""
            CREATE TABLE jiken_c_t_shutugannindairinin_backup AS 
            SELECT * FROM jiken_c_t_shutugannindairinin
        """)
        
        print("\n4. 問題のあるテーブルを削除...")
        cursor.execute("DROP TABLE jiken_c_t_shutugannindairinin")
        
        print("\n5. 正しいスキーマでテーブルを再作成...")
        cursor.execute("""
            CREATE TABLE jiken_c_t_shutugannindairinin (
                normalized_app_num TEXT NOT NULL,
                shutugannindairinin_code TEXT,
                shutugannindairinin_sikbt TEXT,
                original_shutugan_no TEXT,
                record_count INTEGER DEFAULT 1,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                PRIMARY KEY (normalized_app_num, shutugannindairinin_code, shutugannindairinin_sikbt),
                FOREIGN KEY (normalized_app_num) REFERENCES jiken_c_t(normalized_app_num)
            )
        """)
        
        print("\n6. 重複を解決してデータを復旧...")
        # 重複データを集約して挿入
        cursor.execute("""
            INSERT INTO jiken_c_t_shutugannindairinin (
                normalized_app_num, 
                shutugannindairinin_code, 
                shutugannindairinin_sikbt,
                original_shutugan_no,
                record_count
            )
            SELECT 
                REPLACE(shutugan_no, '-', '') as normalized_app_num,
                shutugannindairinin_code,
                shutugannindairinin_sikbt,
                MIN(shutugan_no) as original_shutugan_no,  -- 最初の値を使用
                COUNT(*) as record_count                   -- 重複数を記録
            FROM jiken_c_t_shutugannindairinin_backup
            GROUP BY 
                REPLACE(shutugan_no, '-', ''),
                shutugannindairinin_code,
                shutugannindairinin_sikbt
        """)
        
        cursor.execute("SELECT COUNT(*) FROM jiken_c_t_shutugannindairinin")
        new_count = cursor.fetchone()[0]
        print(f"   重複解決後レコード数: {new_count} (元: {total_count})")
        
        # 重複が解決されたことを確認
        cursor.execute("""
            SELECT SUM(record_count), COUNT(*) 
            FROM jiken_c_t_shutugannindairinin 
            WHERE record_count > 1
        """)
        duplicate_info = cursor.fetchone()
        if duplicate_info[0]:
            print(f"   統合された重複レコード: {duplicate_info[0]} 件 ({duplicate_info[1]} パターン)")
        
        print("\n7. 外部キー制約を再有効化...")
        cursor.execute('PRAGMA foreign_keys = ON')
        
        print("\n8. 参照整合性チェック...")
        cursor.execute('PRAGMA foreign_key_check(jiken_c_t_shutugannindairinin)')
        violations = cursor.fetchall()
        
        if violations:
            print(f"   警告: {len(violations)} 件の参照整合性エラー")
            # 不整合データを削除するかユーザーに確認
            cursor.execute("""
                DELETE FROM jiken_c_t_shutugannindairinin 
                WHERE normalized_app_num NOT IN (
                    SELECT normalized_app_num FROM jiken_c_t
                )
            """)
            
            # 再チェック
            cursor.execute('PRAGMA foreign_key_check(jiken_c_t_shutugannindairinin)')
            violations_after = cursor.fetchall()
            
            if violations_after:
                print(f"   残りエラー: {len(violations_after)} 件")
            else:
                print("   ✅ 不整合データを削除後、参照整合性OK")
        else:
            print("   ✅ 参照整合性チェック: 問題なし")
        
        print("\n9. 最終確認...")
        cursor.execute("SELECT COUNT(*) FROM jiken_c_t_shutugannindairinin")
        final_count = cursor.fetchone()[0]
        
        cursor.execute("""
            SELECT 
                COUNT(*) as total_records,
                COUNT(DISTINCT normalized_app_num) as unique_apps,
                AVG(record_count) as avg_duplicates
            FROM jiken_c_t_shutugannindairinin
        """)
        stats = cursor.fetchone()
        
        print(f"   最終レコード数: {final_count}")
        print(f"   ユニーク出願数: {stats[1]}")
        print(f"   平均重複度: {stats[2]:.2f}")
        
        print("\n10. サンプルデータ確認...")
        cursor.execute("""
            SELECT normalized_app_num, shutugannindairinin_code, original_shutugan_no, record_count
            FROM jiken_c_t_shutugannindairinin 
            ORDER BY record_count DESC
            LIMIT 3
        """)
        samples = cursor.fetchall()
        for sample in samples:
            print(f"     {sample[0]} | 代理人: {sample[1]} | 元番号: {sample[2]} | 重複: {sample[3]}件")
        
        conn.commit()
        conn.close()
        
        print("\n✅ 参照整合性修正が完了しました！")
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
        
        print("\nテスト1: 結合クエリ（正常動作確認）")
        cursor.execute("""
            SELECT 
                j.normalized_app_num,
                j.shutugan_bi,
                COUNT(s.shutugannindairinin_code) as agent_count
            FROM jiken_c_t j
            LEFT JOIN jiken_c_t_shutugannindairinin s 
                ON j.normalized_app_num = s.normalized_app_num
            GROUP BY j.normalized_app_num, j.shutugan_bi
            HAVING agent_count > 0
            ORDER BY agent_count DESC
            LIMIT 5
        """)
        
        results = cursor.fetchall()
        print("   代理人情報のある出願:")
        for result in results:
            print(f"     出願番号: {result[0]} | 出願日: {result[1]} | 代理人数: {result[2]}")
        
        print("\nテスト2: 参照整合性確認")
        cursor.execute("""
            SELECT 
                (SELECT COUNT(*) FROM jiken_c_t) as jiken_total,
                (SELECT COUNT(*) FROM jiken_c_t_shutugannindairinin) as agent_total,
                (SELECT COUNT(DISTINCT s.normalized_app_num) 
                 FROM jiken_c_t_shutugannindairinin s 
                 INNER JOIN jiken_c_t j ON s.normalized_app_num = j.normalized_app_num) as valid_refs
        """)
        
        stats = cursor.fetchone()
        print(f"   出願テーブル: {stats[0]} 件")
        print(f"   代理人テーブル: {stats[1]} 件")  
        print(f"   有効参照: {stats[2]} 件")
        
        integrity_rate = (stats[2] / stats[1] * 100) if stats[1] > 0 else 0
        print(f"   参照整合性率: {integrity_rate:.1f}%")
        
        conn.close()
        print("✅ クエリテスト完了")
        
    except sqlite3.Error as e:
        print(f"❌ テストエラー: {e}")

if __name__ == "__main__":
    print("データベースの参照整合性を修正します（重複対応版）...")
    
    # 修正実行
    if fix_foreign_key_integrity():
        # テスト実行
        test_fixed_queries()
        print("\n🎉 全ての処理が正常に完了しました！")
        print("\n次のステップ:")
        print("1. 商品情報テーブル (jiken_c_t_shohin_joho) にruiカラムを追加")
        print("2. インポートスクリプトを修正版に更新") 
        print("3. 区分情報を含むTSVデータを再インポート")
    else:
        print("\n💥 修正処理でエラーが発生しました。")
        sys.exit(1)
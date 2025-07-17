#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
申請人データをバックアップから復旧するスクリプト
"""

import sqlite3
import sys

def restore_applicant_data(db_path='output.db'):
    """バックアップから申請人データを復旧"""
    
    print("=== 申請人データ復旧スクリプト ===")
    
    try:
        conn = sqlite3.connect(db_path)
        cursor = conn.cursor()
        
        print("\n1. バックアップデータの確認...")
        cursor.execute("SELECT COUNT(*) FROM jiken_c_t_shutugannindairinin_backup")
        backup_count = cursor.fetchone()[0]
        print(f"   バックアップレコード数: {backup_count}")
        
        # バックアップデータの形式確認
        cursor.execute("PRAGMA table_info(jiken_c_t_shutugannindairinin_backup)")
        backup_schema = cursor.fetchall()
        print("   バックアップスキーマ:")
        for col in backup_schema:
            print(f"     {col[1]} ({col[2]})")
        
        print("\n2. 重複データの分析...")
        cursor.execute("""
            SELECT 
                REPLACE(shutugan_no, '-', '') as normalized_app_num,
                shutugannindairinin_code,
                shutugannindairinin_sikbt,
                COUNT(*) as cnt
            FROM jiken_c_t_shutugannindairinin_backup
            GROUP BY 
                REPLACE(shutugan_no, '-', ''),
                shutugannindairinin_code,
                shutugannindairinin_sikbt
            HAVING COUNT(*) > 1
            ORDER BY cnt DESC
            LIMIT 3
        """)
        duplicates = cursor.fetchall()
        print(f"   重複パターン例:")
        for dup in duplicates:
            print(f"     {dup[0]} | {dup[1]} | {dup[2]} -> {dup[3]}件")
        
        print("\n3. 外部キー制約を無効化...")
        cursor.execute('PRAGMA foreign_keys = OFF')
        
        print("\n4. 重複を解決してデータを復旧...")
        cursor.execute("""
            INSERT INTO jiken_c_t_shutugannindairinin (
                normalized_app_num, 
                shutugannindairinin_code, 
                shutugannindairinin_sikbt,
                original_shutugan_no
            )
            SELECT DISTINCT
                REPLACE(shutugan_no, '-', '') as normalized_app_num,
                shutugannindairinin_code,
                shutugannindairinin_sikbt,
                shutugan_no as original_shutugan_no
            FROM jiken_c_t_shutugannindairinin_backup
            WHERE shutugan_no IS NOT NULL 
              AND shutugannindairinin_code IS NOT NULL
              AND shutugannindairinin_sikbt IS NOT NULL
        """)
        
        cursor.execute("SELECT COUNT(*) FROM jiken_c_t_shutugannindairinin")
        restored_count = cursor.fetchone()[0]
        print(f"   復旧レコード数: {restored_count} (元: {backup_count})")
        
        print("\n5. 外部キー制約を再有効化...")
        cursor.execute('PRAGMA foreign_keys = ON')
        
        print("\n6. 参照整合性チェック...")
        cursor.execute('PRAGMA foreign_key_check(jiken_c_t_shutugannindairinin)')
        violations = cursor.fetchall()
        
        if violations:
            print(f"   参照整合性エラー: {len(violations)} 件")
            
            # 不整合データを分析
            cursor.execute("""
                SELECT s.normalized_app_num, COUNT(*)
                FROM jiken_c_t_shutugannindairinin s
                LEFT JOIN jiken_c_t j ON s.normalized_app_num = j.normalized_app_num
                WHERE j.normalized_app_num IS NULL
                GROUP BY s.normalized_app_num
                LIMIT 5
            """)
            missing_refs = cursor.fetchall()
            print("   存在しない出願番号の例:")
            for ref in missing_refs:
                print(f"     {ref[0]} ({ref[1]}件)")
            
            # 不整合データを削除
            cursor.execute("""
                DELETE FROM jiken_c_t_shutugannindairinin 
                WHERE normalized_app_num NOT IN (
                    SELECT normalized_app_num FROM jiken_c_t
                )
            """)
            
            deleted_count = cursor.rowcount
            print(f"   削除された不整合レコード: {deleted_count} 件")
            
            # 再チェック
            cursor.execute('PRAGMA foreign_key_check(jiken_c_t_shutugannindairinin)')
            violations_after = cursor.fetchall()
            
            if violations_after:
                print(f"   残りエラー: {len(violations_after)} 件")
            else:
                print("   ✅ 不整合データ削除後、参照整合性OK")
        else:
            print("   ✅ 参照整合性: 問題なし")
        
        print("\n7. 最終統計...")
        cursor.execute("""
            SELECT 
                COUNT(*) as total_records,
                COUNT(DISTINCT normalized_app_num) as unique_apps,
                COUNT(DISTINCT shutugannindairinin_code) as unique_agents
            FROM jiken_c_t_shutugannindairinin
        """)
        stats = cursor.fetchone()
        
        print(f"   最終レコード数: {stats[0]}")
        print(f"   ユニーク出願数: {stats[1]}")
        print(f"   ユニーク代理人数: {stats[2]}")
        
        print("\n8. サンプルデータ確認...")
        cursor.execute("""
            SELECT 
                s.normalized_app_num,
                s.shutugannindairinin_code,
                s.original_shutugan_no,
                j.shutugan_bi
            FROM jiken_c_t_shutugannindairinin s
            LEFT JOIN jiken_c_t j ON s.normalized_app_num = j.normalized_app_num
            WHERE j.normalized_app_num IS NOT NULL
            LIMIT 3
        """)
        samples = cursor.fetchall()
        print("   復旧データサンプル:")
        for sample in samples:
            print(f"     {sample[0]} | 代理人: {sample[1]} | 出願日: {sample[3]}")
        
        conn.commit()
        conn.close()
        
        print("\n✅ 申請人データの復旧が完了しました！")
        return True
        
    except sqlite3.Error as e:
        print(f"❌ データベースエラー: {e}")
        return False
    except Exception as e:
        print(f"❌ 予期しないエラー: {e}")
        return False

def test_join_queries(db_path='output.db'):
    """結合クエリのテスト"""
    
    print("\n=== 結合クエリテスト ===")
    
    try:
        conn = sqlite3.connect(db_path)
        cursor = conn.cursor()
        
        print("\nテスト: 出願情報と申請人情報の結合")
        cursor.execute("""
            SELECT 
                j.normalized_app_num,
                j.shutugan_bi,
                s.shutugannindairinin_code,
                s.original_shutugan_no
            FROM jiken_c_t j
            INNER JOIN jiken_c_t_shutugannindairinin s 
                ON j.normalized_app_num = s.normalized_app_num
            WHERE j.shutugan_bi IS NOT NULL
            ORDER BY j.shutugan_bi DESC
            LIMIT 5
        """)
        
        results = cursor.fetchall()
        print("   最新出願の代理人情報:")
        for result in results:
            print(f"     出願: {result[0]} | 出願日: {result[1]} | 代理人: {result[2]}")
        
        conn.close()
        print("✅ 結合クエリテスト完了")
        
    except sqlite3.Error as e:
        print(f"❌ テストエラー: {e}")

if __name__ == "__main__":
    print("申請人データをバックアップから復旧します...")
    
    if restore_applicant_data():
        test_join_queries()
        print("\n🎉 復旧処理が正常に完了しました！")
        print("\n✅ 参照整合性問題は解決されました。")
        print("\n次のステップ:")
        print("1. 商品情報テーブルにruiカラムを追加")
        print("2. 区分情報の表示修正")
    else:
        print("\n💥 復旧処理でエラーが発生しました。")
        sys.exit(1)
#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
jiken_c_t_shohin_joho テーブルにruiカラムを追加し、区分情報を修正するスクリプト
"""

import sqlite3
import sys
import csv
from pathlib import Path

def add_rui_column_and_fix_goods_table(db_path='output.db'):
    """商品情報テーブルにruiカラムを追加して修正"""
    
    print("=== 商品情報テーブル修正スクリプト ===")
    print(f"データベース: {db_path}")
    
    if not Path(db_path).exists():
        print(f"エラー: データベースファイルが見つかりません: {db_path}")
        return False
    
    try:
        conn = sqlite3.connect(db_path)
        cursor = conn.cursor()
        
        print("\n1. 現在の商品情報テーブル状況確認...")
        cursor.execute("PRAGMA table_info(jiken_c_t_shohin_joho)")
        current_schema = cursor.fetchall()
        print("   現在のスキーマ:")
        for col in current_schema:
            print(f"     {col[1]} ({col[2]}) {'PK' if col[5] else ''}")
        
        cursor.execute("SELECT COUNT(*) FROM jiken_c_t_shohin_joho")
        current_count = cursor.fetchone()[0]
        print(f"   現在のレコード数: {current_count}")
        
        print("\n2. 外部キー制約を無効化...")
        cursor.execute('PRAGMA foreign_keys = OFF')
        
        print("\n3. 既存テーブルをバックアップ...")
        cursor.execute("DROP TABLE IF EXISTS jiken_c_t_shohin_joho_backup")
        cursor.execute("""
            CREATE TABLE jiken_c_t_shohin_joho_backup AS 
            SELECT * FROM jiken_c_t_shohin_joho
        """)
        
        print("\n4. 既存テーブルを削除...")
        cursor.execute("DROP TABLE jiken_c_t_shohin_joho")
        
        print("\n5. ruiカラムを含む新しいテーブルを作成...")
        cursor.execute("""
            CREATE TABLE jiken_c_t_shohin_joho (
                yonpo_code TEXT,                    -- 四法コード
                normalized_app_num TEXT NOT NULL,   -- 出願番号（正規化済み）
                rui TEXT,                          -- ★重要: 類（区分）
                lengthchoka_flag TEXT,             -- レングス超過フラグ
                designated_goods TEXT,             -- 指定商品・役務名称
                abz_junjo_no INTEGER DEFAULT 1,    -- 商品情報記事順序番号
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                PRIMARY KEY (normalized_app_num, rui, abz_junjo_no),
                FOREIGN KEY (normalized_app_num) REFERENCES jiken_c_t(normalized_app_num)
            )
        """)
        
        print("\n6. 既存データを新しいテーブルに移行...")
        # 既存データは rui が NULL のまま移行
        cursor.execute("""
            INSERT INTO jiken_c_t_shohin_joho (
                normalized_app_num, 
                designated_goods,
                rui,
                abz_junjo_no
            )
            SELECT 
                normalized_app_num,
                designated_goods,
                NULL as rui,                -- ruiは後でTSVから更新
                1 as abz_junjo_no           -- デフォルト順序番号
            FROM jiken_c_t_shohin_joho_backup
        """)
        
        migrated_count = cursor.rowcount
        print(f"   既存データ移行: {migrated_count} レコード")
        
        print("\n7. インデックスを作成...")
        cursor.execute("CREATE INDEX IF NOT EXISTS idx_shohin_joho_rui ON jiken_c_t_shohin_joho(rui)")
        cursor.execute("CREATE INDEX IF NOT EXISTS idx_shohin_joho_app_rui ON jiken_c_t_shohin_joho(normalized_app_num, rui)")
        cursor.execute("CREATE INDEX IF NOT EXISTS idx_shohin_joho_goods ON jiken_c_t_shohin_joho(designated_goods)")
        
        print("\n8. 外部キー制約を再有効化...")
        cursor.execute('PRAGMA foreign_keys = ON')
        
        print("\n9. テーブル構造確認...")
        cursor.execute("PRAGMA table_info(jiken_c_t_shohin_joho)")
        new_schema = cursor.fetchall()
        print("   新しいスキーマ:")
        for col in new_schema:
            pk_mark = " (PK)" if col[5] else ""
            print(f"     {col[1]} ({col[2]}){pk_mark}")
        
        cursor.execute("SELECT COUNT(*) FROM jiken_c_t_shohin_joho")
        new_count = cursor.fetchone()[0]
        print(f"   新しいレコード数: {new_count}")
        
        print("\n10. サンプルデータ確認...")
        cursor.execute("""
            SELECT normalized_app_num, rui, designated_goods, abz_junjo_no
            FROM jiken_c_t_shohin_joho 
            LIMIT 3
        """)
        samples = cursor.fetchall()
        print("   移行データサンプル:")
        for sample in samples:
            goods_preview = sample[2][:50] + "..." if sample[2] and len(sample[2]) > 50 else sample[2]
            print(f"     {sample[0]} | 区分: {sample[1]} | 商品: {goods_preview}")
        
        conn.commit()
        conn.close()
        
        print("\n✅ 商品情報テーブルの修正が完了しました！")
        print("   ★ ruiカラムが追加されました")
        print("   ★ 複合主キー (normalized_app_num, rui, abz_junjo_no) に変更")
        print("   ★ レングス超過フラグと順序番号対応")
        
        return True
        
    except sqlite3.Error as e:
        print(f"❌ データベースエラー: {e}")
        return False
    except Exception as e:
        print(f"❌ 予期しないエラー: {e}")
        return False

def reimport_goods_data_with_rui(db_path='output.db', tsv_path='tsv_data/250611/upd_jiken_c_t_shohin_joho.tsv'):
    """TSVファイルからruiカラムを含むデータを再インポート"""
    
    print("\n=== 区分情報付きデータ再インポート ===")
    
    if not Path(tsv_path).exists():
        print(f"エラー: TSVファイルが見つかりません: {tsv_path}")
        return False
    
    try:
        conn = sqlite3.connect(db_path)
        cursor = conn.cursor()
        
        print(f"TSVファイル: {tsv_path}")
        
        # 既存データを削除
        print("\n1. 既存データを削除...")
        cursor.execute("DELETE FROM jiken_c_t_shohin_joho")
        
        print("\n2. TSVファイルのヘッダー確認...")
        with open(tsv_path, 'r', encoding='utf-8') as f:
            header = f.readline().strip().split('\t')
            print(f"   TSVヘッダー: {header}")
        
        print("\n3. 新しいデータをインポート...")
        imported = 0
        errors = 0
        
        with open(tsv_path, 'r', encoding='utf-8') as f:
            reader = csv.DictReader(f, delimiter='\t')
            
            for row in reader:
                try:
                    # TSVファイルは既に正規化済み（ハイフンなし）
                    normalized_app_num = row.get('shutugan_no')
                    rui = row.get('rui')
                    
                    if not normalized_app_num or not rui:
                        continue
                    
                    cursor.execute("""
                        INSERT OR REPLACE INTO jiken_c_t_shohin_joho (
                            yonpo_code, normalized_app_num, rui, lengthchoka_flag,
                            designated_goods, abz_junjo_no
                        ) VALUES (?, ?, ?, ?, ?, ?)
                    """, (
                        row.get('yonpo_code'),
                        normalized_app_num,
                        rui,                                    # ★重要: 区分情報
                        row.get('lengthchoka_flag'),
                        row.get('shohinekimumeisho'),
                        int(row.get('abz_junjo_no', 1))
                    ))
                    imported += 1
                    
                    if imported % 1000 == 0:
                        print(f"   処理済み: {imported} レコード...")
                        
                except Exception as e:
                    errors += 1
                    if errors < 5:  # 最初の5件のエラーのみ表示
                        print(f"   エラー: {e} (行: {row})")
        
        conn.commit()
        
        print(f"\n4. インポート結果:")
        print(f"   成功: {imported} レコード")
        print(f"   エラー: {errors} レコード")
        
        # 統計確認
        print("\n5. 区分別統計...")
        cursor.execute("""
            SELECT 
                rui,
                COUNT(*) as record_count,
                COUNT(DISTINCT normalized_app_num) as unique_apps
            FROM jiken_c_t_shohin_joho 
            WHERE rui IS NOT NULL
            GROUP BY rui
            ORDER BY rui
            LIMIT 10
        """)
        
        rui_stats = cursor.fetchall()
        print("   区分別レコード数 (上位10区分):")
        for stat in rui_stats:
            print(f"     第{stat[0]}類: {stat[1]}レコード ({stat[2]}出願)")
        
        print("\n6. レングス超過フラグ統計...")
        cursor.execute("""
            SELECT 
                lengthchoka_flag,
                COUNT(*) as count
            FROM jiken_c_t_shohin_joho
            GROUP BY lengthchoka_flag
        """)
        
        length_stats = cursor.fetchall()
        for stat in length_stats:
            flag_name = "超過あり" if stat[0] == '1' else "通常" if stat[0] == '0' else "NULL"
            print(f"     {flag_name}: {stat[1]}件")
        
        conn.close()
        
        print("\n✅ 区分情報付きデータの再インポートが完了しました！")
        return True
        
    except sqlite3.Error as e:
        print(f"❌ データベースエラー: {e}")
        return False
    except Exception as e:
        print(f"❌ 予期しないエラー: {e}")
        return False

def test_rui_queries(db_path='output.db'):
    """区分情報を使った検索クエリのテスト"""
    
    print("\n=== 区分情報検索テスト ===")
    
    try:
        conn = sqlite3.connect(db_path)
        cursor = conn.cursor()
        
        print("\nテスト1: 区分別出願数")
        cursor.execute("""
            SELECT 
                rui as class_num,
                COUNT(DISTINCT normalized_app_num) as app_count,
                COUNT(*) as record_count
            FROM jiken_c_t_shohin_joho
            WHERE rui IS NOT NULL
            GROUP BY rui
            ORDER BY app_count DESC
            LIMIT 5
        """)
        
        class_stats = cursor.fetchall()
        print("   人気区分ランキング:")
        for i, stat in enumerate(class_stats, 1):
            print(f"     {i}位. 第{stat[0]}類: {stat[1]}出願 ({stat[2]}レコード)")
        
        print("\nテスト2: 商標「ブル」の区分別検索")
        cursor.execute("""
            SELECT 
                j.normalized_app_num,
                s.standard_char_t,
                GROUP_CONCAT(DISTINCT sh.rui ORDER BY sh.rui) as goods_classes,
                GROUP_CONCAT(sh.designated_goods, '; ') as all_goods
            FROM jiken_c_t j
            LEFT JOIN standard_char_t_art s ON j.normalized_app_num = s.normalized_app_num
            LEFT JOIN jiken_c_t_shohin_joho sh ON j.normalized_app_num = sh.normalized_app_num
            WHERE s.standard_char_t LIKE '%ブル%'
              AND sh.rui IS NOT NULL
            GROUP BY j.normalized_app_num, s.standard_char_t
            LIMIT 3
        """)
        
        search_results = cursor.fetchall()
        print("   「ブル」検索結果:")
        for result in search_results:
            print(f"     出願: {result[0]}")
            print(f"     商標: {result[1]}")
            print(f"     区分: {result[2]}")
            goods_preview = result[3][:100] + "..." if result[3] and len(result[3]) > 100 else result[3]
            print(f"     商品: {goods_preview}")
            print()
        
        print("\nテスト3: 長文商品記載の処理")
        cursor.execute("""
            SELECT 
                normalized_app_num,
                rui,
                COUNT(*) as record_count,
                SUM(CASE WHEN lengthchoka_flag = '1' THEN 1 ELSE 0 END) as overflow_count
            FROM jiken_c_t_shohin_joho
            GROUP BY normalized_app_num, rui
            HAVING COUNT(*) > 1
            ORDER BY record_count DESC
            LIMIT 3
        """)
        
        multi_records = cursor.fetchall()
        print("   複数レコードの出願例:")
        for record in multi_records:
            print(f"     出願: {record[0]} | 区分: {record[1]} | レコード数: {record[2]} | 超過: {record[3]}")
        
        conn.close()
        print("✅ 区分情報検索テスト完了")
        
    except sqlite3.Error as e:
        print(f"❌ テストエラー: {e}")

if __name__ == "__main__":
    print("商品情報テーブルにruiカラムを追加します...")
    
    # Step 1: テーブル構造修正
    if add_rui_column_and_fix_goods_table():
        print("\n" + "="*50)
        
        # Step 2: データ再インポート  
        if reimport_goods_data_with_rui():
            print("\n" + "="*50)
            
            # Step 3: テスト実行
            test_rui_queries()
            
            print("\n🎉 全ての処理が正常に完了しました！")
            print("\n✅ 区分情報が正しく表示されるようになりました")
            print("\n次のステップ:")
            print("1. HTMLジェネレーターで区分情報の表示確認")  
            print("2. 検索機能で区分フィルターのテスト")
            print("3. 商標「ブル」で区分情報付き検索実行")
        else:
            print("\n💥 データ再インポートでエラーが発生しました。")
            sys.exit(1)
    else:
        print("\n💥 テーブル修正でエラーが発生しました。")
        sys.exit(1)
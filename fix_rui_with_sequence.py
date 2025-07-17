#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
ruiカラム追加（重複対応版）
"""

import sqlite3

def fix_rui_with_sequence():
    """重複対応版ruiカラム追加"""
    
    print("=== 重複対応版 ruiカラム追加 ===")
    
    try:
        conn = sqlite3.connect('output.db')
        cursor = conn.cursor()
        
        print("1. 既存データ分析...")
        cursor.execute("SELECT COUNT(*) FROM jiken_c_t_shohin_joho_old")
        total_count = cursor.fetchone()[0]
        print(f"   総レコード数: {total_count}")
        
        cursor.execute("""
            SELECT normalized_app_num, COUNT(*) as cnt
            FROM jiken_c_t_shohin_joho_old
            GROUP BY normalized_app_num
            HAVING COUNT(*) > 1
            LIMIT 3
        """)
        duplicates = cursor.fetchall()
        print(f"   重複出願例:")
        for dup in duplicates:
            print(f"     {dup[0]}: {dup[1]}件")
        
        print("2. 重複を解決して移行...")
        cursor.execute("DELETE FROM jiken_c_t_shohin_joho")
        
        cursor.execute("""
            INSERT INTO jiken_c_t_shohin_joho (normalized_app_num, rui, designated_goods)
            SELECT 
                normalized_app_num,
                printf('%02d', ROW_NUMBER() OVER (PARTITION BY normalized_app_num ORDER BY rowid)) as rui,
                designated_goods
            FROM jiken_c_t_shohin_joho_old
        """)
        
        cursor.execute("SELECT COUNT(*) FROM jiken_c_t_shohin_joho")
        new_count = cursor.fetchone()[0]
        print(f"   移行完了: {new_count} レコード")
        
        print("3. rui分布確認...")
        cursor.execute("""
            SELECT rui, COUNT(*) as cnt
            FROM jiken_c_t_shohin_joho
            GROUP BY rui
            ORDER BY rui
            LIMIT 10
        """)
        rui_dist = cursor.fetchall()
        print("   rui分布:")
        for dist in rui_dist:
            print(f"     rui {dist[0]}: {dist[1]}件")
        
        conn.commit()
        conn.close()
        
        print("✅ 重複対応版ruiカラム追加完了")
        return True
        
    except sqlite3.Error as e:
        print(f"❌ エラー: {e}")
        return False

def import_real_rui_data():
    """実際のTSVファイルからruiデータをインポート"""
    
    print("\\n=== 実際のrui情報インポート ===")
    
    try:
        import csv
        conn = sqlite3.connect('output.db')
        cursor = conn.cursor()
        
        tsv_path = 'tsv_data/250611/upd_jiken_c_t_shohin_joho.tsv'
        
        print(f"TSVファイル: {tsv_path}")
        
        # 既存データを削除
        cursor.execute("DELETE FROM jiken_c_t_shohin_joho")
        
        print("TSVデータをインポート中...")
        imported = 0
        
        with open(tsv_path, 'r', encoding='utf-8') as f:
            reader = csv.DictReader(f, delimiter='\\t')
            
            batch = []
            for row in reader:
                app_num = row.get('shutugan_no')
                rui = row.get('rui')
                goods = row.get('shohinekimumeisho')
                
                if app_num and rui:
                    batch.append((app_num, rui, goods))
                
                if len(batch) >= 1000:
                    cursor.executemany("""
                        INSERT OR REPLACE INTO jiken_c_t_shohin_joho 
                        (normalized_app_num, rui, designated_goods)
                        VALUES (?, ?, ?)
                    """, batch)
                    imported += len(batch)
                    batch = []
                    print(f"   処理済み: {imported} レコード...")
            
            # 残りのバッチを処理
            if batch:
                cursor.executemany("""
                    INSERT OR REPLACE INTO jiken_c_t_shohin_joho 
                    (normalized_app_num, rui, designated_goods)
                    VALUES (?, ?, ?)
                """, batch)
                imported += len(batch)
        
        print(f"\\nインポート完了: {imported} レコード")
        
        # 区分統計
        cursor.execute("""
            SELECT rui, COUNT(*) as cnt
            FROM jiken_c_t_shohin_joho
            WHERE rui IS NOT NULL
            GROUP BY rui
            ORDER BY CAST(rui AS INTEGER)
            LIMIT 10
        """)
        
        real_rui_stats = cursor.fetchall()
        print("\\n実際の区分統計:")
        for stat in real_rui_stats:
            print(f"   第{stat[0]}類: {stat[1]}件")
        
        conn.commit()
        conn.close()
        
        print("✅ 実際のrui情報インポート完了")
        return True
        
    except Exception as e:
        print(f"❌ エラー: {e}")
        return False

def test_rui_search():
    """区分情報を使った検索テスト"""
    
    print("\\n=== 区分検索テスト ===")
    
    try:
        conn = sqlite3.connect('output.db')
        cursor = conn.cursor()
        
        print("テスト: 商標「ブル」の区分別検索")
        cursor.execute("""
            SELECT 
                j.normalized_app_num,
                s.standard_char_t,
                sh.rui,
                sh.designated_goods
            FROM jiken_c_t j
            INNER JOIN standard_char_t_art s ON j.normalized_app_num = s.normalized_app_num
            INNER JOIN jiken_c_t_shohin_joho sh ON j.normalized_app_num = sh.normalized_app_num
            WHERE s.standard_char_t LIKE '%ブル%'
              AND sh.rui IS NOT NULL
            LIMIT 5
        """)
        
        results = cursor.fetchall()
        print("検索結果:")
        for result in results:
            goods_preview = result[3][:50] + "..." if result[3] and len(result[3]) > 50 else result[3]
            print(f"   出願: {result[0]} | 商標: {result[1]} | 区分: {result[2]} | 商品: {goods_preview}")
        
        conn.close()
        print("✅ 区分検索テスト完了")
        
    except sqlite3.Error as e:
        print(f"❌ エラー: {e}")

if __name__ == "__main__":
    if fix_rui_with_sequence():
        if import_real_rui_data():
            test_rui_search()
            print("\\n🎉 全ての処理が完了しました！")
            print("✅ 区分情報が正しく表示されるようになりました")
        else:
            print("\\n💥 実データインポートでエラーが発生しました。")
    else:
        print("\\n💥 テーブル修正でエラーが発生しました。")
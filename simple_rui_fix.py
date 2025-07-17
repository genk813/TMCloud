#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
簡易版: ruiカラム追加スクリプト
"""

import sqlite3

def simple_add_rui_column():
    """シンプルなruiカラム追加"""
    
    print("=== 簡易版 ruiカラム追加 ===")
    
    try:
        conn = sqlite3.connect('output.db')
        cursor = conn.cursor()
        
        print("1. 既存データ確認...")
        cursor.execute("SELECT COUNT(*) FROM jiken_c_t_shohin_joho")
        count = cursor.fetchone()[0]
        print(f"   既存レコード数: {count}")
        
        print("2. 新しいテーブルを直接作成...")
        cursor.execute("ALTER TABLE jiken_c_t_shohin_joho RENAME TO jiken_c_t_shohin_joho_old")
        
        cursor.execute("""
            CREATE TABLE jiken_c_t_shohin_joho (
                normalized_app_num TEXT,
                rui TEXT,
                designated_goods TEXT,
                PRIMARY KEY (normalized_app_num, rui)
            )
        """)
        
        print("3. 既存データを移行（ruiはNULL）...")
        cursor.execute("""
            INSERT INTO jiken_c_t_shohin_joho (normalized_app_num, rui, designated_goods)
            SELECT normalized_app_num, '00' as rui, designated_goods
            FROM jiken_c_t_shohin_joho_old
        """)
        
        cursor.execute("SELECT COUNT(*) FROM jiken_c_t_shohin_joho")
        new_count = cursor.fetchone()[0]
        print(f"   移行レコード数: {new_count}")
        
        print("4. インデックス作成...")
        cursor.execute("CREATE INDEX idx_shohin_rui ON jiken_c_t_shohin_joho(rui)")
        
        conn.commit()
        conn.close()
        
        print("✅ ruiカラム追加完了")
        return True
        
    except sqlite3.Error as e:
        print(f"❌ エラー: {e}")
        return False

if __name__ == "__main__":
    simple_add_rui_column()
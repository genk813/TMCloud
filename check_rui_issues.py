#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
区分情報の問題を調査するスクリプト
"""

import sqlite3

def check_rui_issues():
    """区分情報の問題を詳細に調査"""
    
    print("=== 区分情報問題調査 ===")
    
    try:
        conn = sqlite3.connect('output.db')
        cursor = conn.cursor()
        
        print("\n1. jiken_c_t_shohin_joho テーブルの状況...")
        cursor.execute('SELECT COUNT(*) FROM jiken_c_t_shohin_joho')
        total_count = cursor.fetchone()[0]
        print(f"   総レコード数: {total_count}")
        
        cursor.execute("SELECT COUNT(*) FROM jiken_c_t_shohin_joho WHERE rui IS NOT NULL AND rui != ''")
        rui_count = cursor.fetchone()[0]
        print(f"   rui有効レコード数: {rui_count}")
        
        cursor.execute("SELECT COUNT(*) FROM jiken_c_t_shohin_joho WHERE rui IS NULL OR rui = ''")
        rui_null_count = cursor.fetchone()[0]
        print(f"   rui無効レコード数: {rui_null_count}")
        
        print("\n2. 問題のある出願番号の確認...")
        # メディプル (2001090692) をチェック
        cursor.execute("""
            SELECT sh.normalized_app_num, sh.rui, sh.designated_goods
            FROM jiken_c_t_shohin_joho sh
            WHERE sh.normalized_app_num = '2001090692'
        """)
        medipuru = cursor.fetchall()
        print(f"   メディプル (2001090692) の区分情報:")
        if medipuru:
            for record in medipuru:
                print(f"     出願: {record[0]} | 区分: '{record[1]}' | 商品: {record[2]}")
        else:
            print("     データベースに見つかりません")
        
        print("\n3. TSVに存在するがDBで区分なしの確認...")
        # 新しい出願番号をチェック
        cursor.execute("""
            SELECT sh.normalized_app_num, sh.rui, sh.designated_goods
            FROM jiken_c_t_shohin_joho sh
            WHERE sh.normalized_app_num = '2024138305'
            LIMIT 1
        """)
        new_app = cursor.fetchall()
        print(f"   2024138305 (TSVの最初の出願) の区分情報:")
        if new_app:
            for record in new_app:
                goods_preview = record[2][:50] + "..." if record[2] and len(record[2]) > 50 else record[2]
                print(f"     出願: {record[0]} | 区分: '{record[1]}' | 商品: {goods_preview}")
        else:
            print("     データベースに見つかりません")
        
        print("\n4. HTMLで「調査中」になる理由の調査...")
        # メディプルの検索クエリをテスト
        cursor.execute("""
            SELECT 
                j.normalized_app_num,
                s.standard_char_t,
                sh.rui,
                sh.designated_goods
            FROM jiken_c_t j
            LEFT JOIN standard_char_t_art s ON j.normalized_app_num = s.normalized_app_num
            LEFT JOIN jiken_c_t_shohin_joho sh ON j.normalized_app_num = sh.normalized_app_num
            WHERE s.standard_char_t LIKE '%メディプル%'
        """)
        medipuru_search = cursor.fetchall()
        print("   HTMLジェネレーターでのメディプル検索結果:")
        for result in medipuru_search:
            print(f"     出願: {result[0]} | 商標: {result[1]} | 区分: '{result[2]}' | 商品: {result[3]}")
        
        print("\n5. jiken_c_t と jiken_c_t_shohin_joho の結合確認...")
        cursor.execute("""
            SELECT 
                COUNT(*) as total_jiken,
                COUNT(sh.normalized_app_num) as with_goods_info
            FROM jiken_c_t j
            LEFT JOIN jiken_c_t_shohin_joho sh ON j.normalized_app_num = sh.normalized_app_num
            WHERE j.normalized_app_num IN (
                SELECT normalized_app_num FROM standard_char_t_art 
                WHERE standard_char_t LIKE '%プル%'
            )
        """)
        join_stats = cursor.fetchone()
        print(f"   プル検索対象の出願数: {join_stats[0]}")
        print(f"   そのうち商品情報があるもの: {join_stats[1]}")
        
        print("\n6. 具体的な「調査中」出願の分析...")
        cursor.execute("""
            SELECT 
                j.normalized_app_num,
                s.standard_char_t,
                j.shutugan_bi,
                sh.rui
            FROM jiken_c_t j
            LEFT JOIN standard_char_t_art s ON j.normalized_app_num = s.normalized_app_num
            LEFT JOIN jiken_c_t_shohin_joho sh ON j.normalized_app_num = sh.normalized_app_num
            WHERE s.standard_char_t LIKE '%プル%'
              AND (sh.rui IS NULL OR sh.rui = '')
            LIMIT 5
        """)
        missing_rui = cursor.fetchall()
        print("   区分情報なしの出願例:")
        for result in missing_rui:
            print(f"     出願: {result[0]} | 商標: {result[1]} | 出願日: {result[2]} | 区分: '{result[3]}'")
        
        conn.close()
        
        print("\n✅ 区分情報問題調査完了")
        return True
        
    except sqlite3.Error as e:
        print(f"❌ エラー: {e}")
        return False

if __name__ == "__main__":
    check_rui_issues()
#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
正しい商標検索実装
検索用商標テーブルを基準とした段階的検索アプローチ
"""

import sqlite3
from typing import List, Dict, Any, Tuple

class CorrectTrademarkSearch:
    """正しい商標検索クラス"""
    
    def __init__(self, db_path: str = "output.db"):
        self.db_path = db_path
    
    def search_by_mark_text(self, mark_text: str, limit: int = 100) -> List[Dict[str, Any]]:
        """
        商標文字による正しい検索
        
        手順:
        1. 検索用商標テーブルで検索
        2. 出願番号リストを取得
        3. 出願番号を主キーとして各テーブルから情報取得
        """
        
        if not mark_text:
            return []
        
        try:
            conn = sqlite3.connect(self.db_path)
            cursor = conn.cursor()
            
            print(f"=== 商標「{mark_text}」の正しい検索 ===")
            
            # ステップ1: 検索用商標テーブルで出願番号を取得
            print("1. 検索用商標テーブルで出願番号を取得...")
            cursor.execute("""
                SELECT DISTINCT normalized_app_num
                FROM search_use_t_art_table
                WHERE search_use_t LIKE ?
                ORDER BY normalized_app_num DESC
                LIMIT ?
            """, (f"%{mark_text}%", limit))
            
            app_nums = [row[0] for row in cursor.fetchall()]
            print(f"   検索用商標「{mark_text}」の出願番号: {len(app_nums)}件")
            
            if not app_nums:
                print("   該当する出願番号がありません")
                return []
            
            # ステップ2: 出願番号を主キーとして各テーブルから情報取得
            print("2. 出願番号を主キーとして各テーブルから情報取得...")
            results = []
            
            for app_num in app_nums:
                result = self._get_trademark_info_by_app_num(cursor, app_num)
                if result:
                    results.append(result)
            
            conn.close()
            
            print(f"✅ 検索完了: {len(results)}件の結果")
            return results
            
        except sqlite3.Error as e:
            print(f"❌ データベースエラー: {e}")
            return []
    
    def _get_trademark_info_by_app_num(self, cursor, app_num: str) -> Dict[str, Any]:
        """出願番号を主キーとして商標情報を取得"""
        
        result = {
            'normalized_app_num': app_num,
            'app_num': None,
            'mark_text': None,
            'search_use_t': None,
            'standard_char_t': None,
            'indct_use_t': None,
            'goods_classes': None,
            'designated_goods': None,
            'similar_group_codes': None,
            'shutugan_bi': None,
            'reg_num': None,
            'applicant_name': None,
            'rights_holder': None,
            'has_image': 'NO'
        }
        
        # 基本情報（jiken_c_t）
        cursor.execute("""
            SELECT shutugan_bi 
            FROM jiken_c_t 
            WHERE normalized_app_num = ?
        """, (app_num,))
        basic_info = cursor.fetchone()
        if basic_info:
            result['shutugan_bi'] = basic_info[0]
            result['app_num'] = self._format_app_num(app_num)
        
        # 登録番号（reg_mappingから取得）
        cursor.execute("""
            SELECT reg_num 
            FROM reg_mapping 
            WHERE app_num = ?
        """, (app_num,))
        reg_info = cursor.fetchone()
        if reg_info:
            result['reg_num'] = reg_info[0]
        
        # 標準文字商標（standard_char_t_art）
        cursor.execute("""
            SELECT standard_char_t 
            FROM standard_char_t_art 
            WHERE normalized_app_num = ?
        """, (app_num,))
        standard = cursor.fetchone()
        if standard:
            result['standard_char_t'] = standard[0]
            result['mark_text'] = standard[0]  # 表示用
        
        # 検索用商標（search_use_t_art_table）
        cursor.execute("""
            SELECT search_use_t 
            FROM search_use_t_art_table 
            WHERE normalized_app_num = ?
            LIMIT 1
        """, (app_num,))
        search = cursor.fetchone()
        if search:
            result['search_use_t'] = search[0]
            # 標準文字がない場合は検索用商標を使用
            if not result['mark_text']:
                result['mark_text'] = search[0]
        
        # 指定商標（indct_use_t_art）
        cursor.execute("""
            SELECT indct_use_t 
            FROM indct_use_t_art 
            WHERE normalized_app_num = ?
            LIMIT 1
        """, (app_num,))
        indct = cursor.fetchone()
        if indct:
            result['indct_use_t'] = indct[0]
            # 他に商標情報がない場合は指定商標を使用
            if not result['mark_text']:
                result['mark_text'] = indct[0]
        
        # 商品区分・指定商品（jiken_c_t_shohin_joho）
        cursor.execute("""
            SELECT 
                GROUP_CONCAT(DISTINCT rui ORDER BY rui) as goods_classes,
                MAX(designated_goods) as designated_goods
            FROM jiken_c_t_shohin_joho 
            WHERE normalized_app_num = ?
        """, (app_num,))
        goods_info = cursor.fetchone()
        if goods_info:
            result['goods_classes'] = goods_info[0]
            result['designated_goods'] = goods_info[1]
        
        # 類似群コード（t_knd_info_art_table）
        cursor.execute("""
            SELECT GROUP_CONCAT(DISTINCT smlr_dsgn_group_cd) as similar_codes
            FROM t_knd_info_art_table 
            WHERE normalized_app_num = ?
        """, (app_num,))
        similar = cursor.fetchone()
        if similar:
            result['similar_group_codes'] = similar[0]
        
        # 申請人情報（jiken_c_t_shutugannindairinin + applicant_master）
        cursor.execute("""
            SELECT am.appl_name
            FROM jiken_c_t_shutugannindairinin ap
            LEFT JOIN applicant_master am ON ap.shutugannindairinin_code = am.appl_cd
            WHERE ap.normalized_app_num = ? AND ap.shutugannindairinin_sikbt = '1'
            LIMIT 1
        """, (app_num,))
        applicant = cursor.fetchone()
        if applicant:
            result['applicant_name'] = applicant[0]
        
        # 権利者情報（reg_mapping + right_person_art_t）
        cursor.execute("""
            SELECT rp.right_person_name
            FROM reg_mapping rm
            LEFT JOIN right_person_art_t rp ON rm.reg_num = rp.reg_num
            WHERE rm.app_num = ?
            LIMIT 1
        """, (app_num,))
        rights = cursor.fetchone()
        if rights:
            result['rights_holder'] = rights[0]
        
        # 画像データ（t_sample）
        cursor.execute("""
            SELECT image_data
            FROM t_sample
            WHERE normalized_app_num = ?
            LIMIT 1
        """, (app_num,))
        image = cursor.fetchone()
        if image and image[0]:
            result['has_image'] = 'YES'
        
        # 表示用商標名が設定されていない場合のフォールバック
        if not result['mark_text']:
            result['mark_text'] = f"[出願番号: {result['app_num']}]"
        
        return result
    
    def _format_app_num(self, normalized_app_num: str) -> str:
        """出願番号の表示形式変換"""
        if not normalized_app_num or len(normalized_app_num) < 10:
            return normalized_app_num
        
        # 2025047539 -> 2025-047539
        return f"{normalized_app_num[:4]}-{normalized_app_num[4:]}"
    
    def display_search_results(self, results: List[Dict[str, Any]]):
        """検索結果の表示"""
        
        if not results:
            print("検索結果がありません。")
            return
        
        print(f"\\n=== 検索結果: {len(results)}件 ===")
        
        for i, result in enumerate(results, 1):
            print(f"{i:2d}. {result['mark_text']}")
            print(f"    出願番号: {result['app_num']} | 出願日: {self._format_date(result['shutugan_bi'])}")
            print(f"    区分: {result['goods_classes'] if result['goods_classes'] else '調査中'}")
            
            goods = result['designated_goods']
            if goods:
                goods_display = goods[:80] + "..." if len(goods) > 80 else goods
                print(f"    商品: {goods_display}")
            
            if result['applicant_name']:
                print(f"    出願人: {result['applicant_name']}")
            
            if result['rights_holder']:
                print(f"    権利者: {result['rights_holder']}")
            
            print()
    
    def _format_date(self, date_str: str) -> str:
        """日付の表示形式変換"""
        if not date_str or len(date_str) != 8:
            return date_str if date_str else "不明"
        
        return f"{date_str[:4]}/{date_str[4:6]}/{date_str[6:8]}"

def main():
    """メイン関数"""
    
    import argparse
    
    parser = argparse.ArgumentParser(description="正しい商標検索")
    parser.add_argument("--mark-text", help="商標文字")
    parser.add_argument("--limit", type=int, default=20, help="検索結果件数")
    
    args = parser.parse_args()
    
    if not args.mark_text:
        print("商標文字を指定してください: --mark-text '検索文字'")
        return
    
    searcher = CorrectTrademarkSearch()
    results = searcher.search_by_mark_text(args.mark_text, args.limit)
    searcher.display_search_results(results)

if __name__ == "__main__":
    main()
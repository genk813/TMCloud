#!/usr/bin/env python3
"""
拡張商標検索CLI
既存機能を保持しつつ、TM-SONAR水準の正規化機能を追加
"""

import sqlite3
import argparse
import json
from typing import Dict, List, Tuple, Optional
from pathlib import Path
from text_normalizer import TextNormalizer

class EnhancedTrademarkSearchCLI:
    def __init__(self, db_path: str = "output.db"):
        self.db_path = db_path
        self.conn = self._get_connection()
        self.normalizer = TextNormalizer()
    
    def _get_connection(self):
        """データベース接続を取得"""
        if not Path(self.db_path).exists():
            raise FileNotFoundError(f"データベースファイルが見つかりません: {self.db_path}")
        
        conn = sqlite3.connect(self.db_path)
        conn.row_factory = sqlite3.Row
        return conn
    
    def query_db(self, query: str, params: tuple = ()) -> List[Dict]:
        """データベースクエリ実行"""
        cursor = self.conn.cursor()
        cursor.execute(query, params)
        return [dict(row) for row in cursor.fetchall()]
    
    def query_db_one(self, query: str, params: tuple = ()) -> Optional[Dict]:
        """単一レコード取得"""
        results = self.query_db(query, params)
        return results[0] if results else None
    
    def get_optimized_results(self, app_nums: List[str]) -> List[Dict]:
        """最適化された単一クエリで全情報を取得（既存機能保持）"""
        if not app_nums:
            return []
        
        placeholders = ','.join(['?' for _ in app_nums])
        
        # 最適化済みクエリ（パフォーマンス改善済み）
        optimized_sql = f"""
            SELECT DISTINCT
                j.normalized_app_num AS app_num,
                COALESCE(je.shutugan_bi, j.shutugan_bi) AS app_date,
                COALESCE(je.toroku_bi, j.reg_reg_ymd) AS reg_date,
                
                -- 登録番号（拡張データから取得）
                COALESCE(je.raz_toroku_no, tbi.reg_num, rm.reg_num, h.reg_num) AS registration_number,
                
                -- 基本項目
                je.raz_kohohakko_bi AS reg_gazette_date,
                je.pcz_kokaikohohakko_bi AS publication_date,
                tbi.prior_app_right_occr_dt AS prior_right_date,
                tbi.conti_prd_expire_dt AS expiry_date,
                tbi.rjct_finl_dcsn_dsptch_dt AS rejection_dispatch_date,
                tbi.rec_latest_updt_dt AS renewal_application_date,
                tbi.set_reg_dt AS renewal_registration_date,
                
                -- 管理情報項目
                mgi.trial_dcsn_year_month_day AS trial_request_date,
                mgi.processing_type AS trial_type,
                
                -- 付加情報項目  
                ai.right_request AS additional_info,
                
                -- 商標文字（優先順位: 標準文字 → 表示用 → 検索用）
                COALESCE(s.standard_char_t, iu.indct_use_t, su.search_use_t) AS mark_text,
                
                -- 権利者情報
                h.right_person_name AS right_person_name,
                h.right_person_addr AS right_person_addr,
                
                -- 申請人情報（Phase 1新マスター優先、フォールバック付き）
                CASE 
                    WHEN amf.appl_name IS NOT NULL AND amf.appl_name != '' AND amf.appl_name NOT LIKE '%省略%'
                    THEN amf.appl_name
                    WHEN am.appl_name IS NOT NULL AND am.appl_name != '' AND am.appl_name NOT LIKE '%省略%'
                    THEN am.appl_name
                    WHEN apm.applicant_name IS NOT NULL
                    THEN apm.applicant_name || ' (推定)'
                    ELSE 'コード:' || ap.shutugannindairinin_code
                END as applicant_name,
                COALESCE(amf.appl_addr, am.appl_addr, apm.applicant_addr) as applicant_addr,
                
                -- 商品・役務区分（最適化済み）
                GROUP_CONCAT(DISTINCT gca.goods_classes) AS goods_classes,
                
                -- 類似群コード
                GROUP_CONCAT(DISTINCT tknd.smlr_dsgn_group_cd) AS similar_group_codes,
                
                -- 指定商品・役務
                GROUP_CONCAT(DISTINCT jcs.designated_goods) AS designated_goods,
                
                -- 称呼
                GROUP_CONCAT(DISTINCT td.dsgnt) AS call_name,
                
                -- 画像データの有無
                CASE WHEN ts.image_data IS NOT NULL THEN 'YES' ELSE 'NO' END AS has_image
                
            FROM jiken_c_t AS j
            LEFT JOIN jiken_c_t_enhanced AS je ON j.normalized_app_num = je.normalized_app_num
            LEFT JOIN t_basic_item_enhanced AS tbi ON j.normalized_app_num = tbi.normalized_app_num
            LEFT JOIN mgt_info_enhanced AS mgi ON j.normalized_app_num = mgi.normalized_app_num
            LEFT JOIN add_info_enhanced AS ai ON j.normalized_app_num = ai.normalized_app_num
            LEFT JOIN standard_char_t_art AS s ON j.normalized_app_num = s.normalized_app_num
            LEFT JOIN indct_use_t_art AS iu ON j.normalized_app_num = iu.normalized_app_num
            LEFT JOIN search_use_t_art_table AS su ON j.normalized_app_num = su.normalized_app_num
            -- 権利者情報: reg_mapping経由で正確にマッチング
            LEFT JOIN reg_mapping rm ON j.normalized_app_num = rm.app_num
            LEFT JOIN right_person_art_t AS h ON rm.reg_num = h.reg_num
            -- 申請人情報
            LEFT JOIN jiken_c_t_shutugannindairinin ap ON j.normalized_app_num = ap.shutugan_no 
                                                       AND ap.shutugannindairinin_sikbt = '1'
            -- Phase 1: 新申請人マスターファイル（最優先）
            LEFT JOIN applicant_master_full amf ON ap.shutugannindairinin_code = amf.appl_cd
            -- 従来申請人マスターファイル（フォールバック1）
            LEFT JOIN applicant_master am ON ap.shutugannindairinin_code = am.appl_cd
            -- 部分的申請人マッピング（フォールバック2）
            LEFT JOIN (
                SELECT applicant_code, applicant_name, applicant_addr,
                       ROW_NUMBER() OVER (PARTITION BY applicant_code ORDER BY trademark_count DESC) as rn
                FROM applicant_mapping
            ) apm ON ap.shutugannindairinin_code = apm.applicant_code AND apm.rn = 1
            -- 商品区分: 出願番号ベースのみ（最適化済み）
            LEFT JOIN goods_class_art AS gca ON j.normalized_app_num = gca.normalized_app_num
            LEFT JOIN t_knd_info_art_table AS tknd ON j.normalized_app_num = tknd.normalized_app_num
            LEFT JOIN jiken_c_t_shohin_joho AS jcs ON j.normalized_app_num = jcs.normalized_app_num
            LEFT JOIN t_dsgnt_art AS td ON j.normalized_app_num = td.normalized_app_num
            LEFT JOIN t_sample AS ts ON j.normalized_app_num = ts.normalized_app_num
            
            WHERE j.normalized_app_num IN ({placeholders})
            GROUP BY j.normalized_app_num
            ORDER BY j.normalized_app_num
        """
        
        return self.query_db(optimized_sql, tuple(app_nums))
    
    def search_trademarks(self, 
                         app_num: str = None,
                         mark_text: str = None,
                         applicant_name: str = None,
                         goods_classes: str = None,
                         designated_goods: str = None,
                         similar_group_codes: str = None,
                         limit: int = 200,
                         offset: int = 0,
                         enhanced_search: bool = False,
                         pronunciation_search: bool = False,
                         fuzzy_search: bool = False,
                         tm_sonar_search: bool = False) -> Tuple[List[Dict], int]:
        """
        商標検索実行（拡張機能付き）
        
        Args:
            enhanced_search: P1基礎正規化を使用
            pronunciation_search: 称呼（発音同一）検索を使用
            fuzzy_search: 曖昧検索（部分一致・文字分割）を使用
            tm_sonar_search: TM-SONAR準拠商標検索を使用
        """
        
        # 検索条件の正規化（新機能）
        if mark_text:
            if tm_sonar_search:
                # TM-SONAR検索：複数指定・二段併記・クエスチョンマーク対応
                search_terms = self.normalizer.normalize_search_terms(mark_text, "trademark")
                if search_terms == ["*"]:
                    # 全指定の場合は検索条件をクリア
                    mark_text = None
                else:
                    # 複数項目をOR検索として扱う
                    mark_text = search_terms
            elif enhanced_search:
                if pronunciation_search:
                    mark_text = self.normalizer.normalize_pronunciation(mark_text)
                else:
                    mark_text = self.normalizer.normalize_basic(mark_text)
        
        # P2-14: 申請人名の正規化（元の入力値も保持）
        original_applicant_name = applicant_name
        if enhanced_search and applicant_name:
            applicant_name = self.normalizer.normalize_applicant_name(applicant_name)
        
        # 動的WHERE句の構築（既存ロジック保持）
        where_parts = ["1=1"]
        params = []
        from_parts = ["FROM jiken_c_t j"]
        
        # 出願番号
        if app_num:
            where_parts.append("j.normalized_app_num = ?")
            params.append(app_num.replace("-", ""))
        
        # 商標文字検索（既存＋拡張）
        if mark_text:
            from_parts.append("LEFT JOIN standard_char_t_art s ON j.normalized_app_num = s.normalized_app_num")
            from_parts.append("LEFT JOIN indct_use_t_art iu ON j.normalized_app_num = iu.normalized_app_num")
            from_parts.append("LEFT JOIN search_use_t_art_table su ON j.normalized_app_num = su.normalized_app_num")
            
            # 曖昧検索の場合、称呼データも加える
            if fuzzy_search:
                from_parts.append("LEFT JOIN t_dsgnt_art td ON j.normalized_app_num = td.normalized_app_num")
            
            if tm_sonar_search:
                # TM-SONAR準拠検索：複数用語のOR検索
                if isinstance(mark_text, list):
                    # 複数検索用語をOR条件で結合
                    or_conditions = []
                    for term in mark_text:
                        pattern = f"%{term}%"
                        or_conditions.extend([
                            "s.standard_char_t LIKE ?",
                            "iu.indct_use_t LIKE ?", 
                            "su.search_use_t LIKE ?"
                        ])
                        params.extend([pattern, pattern, pattern])
                    
                    where_parts.append(f"({' OR '.join(or_conditions)})")
                else:
                    # 単一検索用語（TM-SONAR正規化済み）
                    normalized_pattern = f"%{mark_text}%"
                    where_parts.append("""(
                        s.standard_char_t LIKE ? OR
                        iu.indct_use_t LIKE ? OR
                        su.search_use_t LIKE ?
                    )""")
                    params.extend([normalized_pattern, normalized_pattern, normalized_pattern])
            elif enhanced_search:
                # 拡張検索：双方向正規化で検索精度向上
                if pronunciation_search:
                    # 称呼検索：簡潔で効果的な発音ゆらぎ対応
                    normalized_basic = self.normalizer.normalize_basic(mark_text)
                    normalized_pronunciation = self.normalizer.normalize_pronunciation(mark_text)
                    
                    # 3つのメインパターンで検索
                    pattern1 = f"%{normalized_pronunciation}%"
                    pattern2 = f"%{normalized_basic}%"
                    pattern3 = f"%{mark_text}%"
                    
                    # 簡潔な発音類似検索SQL
                    where_parts.append("""(
                        -- 完全発音正規化マッチング
                        UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
                            s.standard_char_t, 'ー', ''), ' ', ''), 'ヂ', 'ジ'), 'ヅ', 'ズ'), 'ヴェ', 'ベ'), 
                            'ヴァ', 'バ'), 'ヴィ', 'ビ'), 'ヴォ', 'ボ'), 'ヴ', 'ブ'), 'ティ', 'チ')) LIKE ? OR
                        UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
                            iu.indct_use_t, 'ー', ''), ' ', ''), 'ヂ', 'ジ'), 'ヅ', 'ズ'), 'ヴェ', 'ベ'), 
                            'ヴァ', 'バ'), 'ヴィ', 'ビ'), 'ヴォ', 'ボ'), 'ヴ', 'ブ'), 'ティ', 'チ')) LIKE ? OR
                        UPPER(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
                            su.search_use_t, 'ー', ''), ' ', ''), 'ヂ', 'ジ'), 'ヅ', 'ズ'), 'ヴェ', 'ベ'), 
                            'ヴァ', 'バ'), 'ヴィ', 'ビ'), 'ヴォ', 'ボ'), 'ヴ', 'ブ'), 'ティ', 'チ')) LIKE ? OR
                        -- 基本正規化マッチング  
                        UPPER(REPLACE(REPLACE(s.standard_char_t, 'ー', ''), ' ', '')) LIKE ? OR
                        UPPER(REPLACE(REPLACE(iu.indct_use_t, 'ー', ''), ' ', '')) LIKE ? OR
                        UPPER(REPLACE(REPLACE(su.search_use_t, 'ー', ''), ' ', '')) LIKE ? OR
                        -- 元の文字列マッチング
                        s.standard_char_t LIKE ? OR iu.indct_use_t LIKE ? OR su.search_use_t LIKE ?
                    )""")
                    
                    # 9つのパラメータ
                    params.extend([
                        pattern1, pattern1, pattern1,  # 完全正規化
                        pattern2, pattern2, pattern2,  # 基本正規化
                        pattern3, pattern3, pattern3   # 元の文字列
                    ])
                else:
                    # 基礎正規化検索：ひらがな・カタカナ統一
                    normalized_pattern = f"%{mark_text.replace('-', '')}%"
                    original_pattern = f"%{mark_text}%"
                    
                    where_parts.append("""(
                        UPPER(REPLACE(REPLACE(s.standard_char_t, 'ー', ''), ' ', '')) LIKE ? OR
                        UPPER(REPLACE(REPLACE(iu.indct_use_t, 'ー', ''), ' ', '')) LIKE ? OR
                        UPPER(REPLACE(REPLACE(su.search_use_t, 'ー', ''), ' ', '')) LIKE ? OR
                        s.standard_char_t LIKE ? OR iu.indct_use_t LIKE ? OR su.search_use_t LIKE ?
                    )""")
                    params.extend([normalized_pattern, normalized_pattern, normalized_pattern,
                                 original_pattern, original_pattern, original_pattern])
            else:
                # 既存検索：そのまま検索（変更なし）
                where_parts.append("(s.standard_char_t LIKE ? OR iu.indct_use_t LIKE ? OR su.search_use_t LIKE ?)")
                params.extend([f"%{mark_text}%", f"%{mark_text}%", f"%{mark_text}%"])
            
            # 曖昧検索機能の追加
            if fuzzy_search and mark_text:
                # 入力文字列を1文字ずつ分割して個別検索
                fuzzy_conditions = []
                fuzzy_params = []
                
                # 文字列を分割（2文字以上の場合）
                if len(mark_text) >= 2:
                    for i in range(len(mark_text) - 1):
                        char_pair = mark_text[i:i+2]
                        if char_pair.strip():
                            fuzzy_conditions.extend([
                                "s.standard_char_t LIKE ?",
                                "iu.indct_use_t LIKE ?", 
                                "su.search_use_t LIKE ?",
                                "td.dsgnt LIKE ?"
                            ])
                            fuzzy_params.extend([f"%{char_pair}%"] * 4)
                
                # 単独文字検索（3文字以上の場合）
                for char in mark_text:
                    if char.strip() and char not in [' ', '-', 'ー']:
                        fuzzy_conditions.extend([
                            "s.standard_char_t LIKE ?",
                            "iu.indct_use_t LIKE ?",
                            "su.search_use_t LIKE ?", 
                            "td.dsgnt LIKE ?"
                        ])
                        fuzzy_params.extend([f"%{char}%"] * 4)
                
                if fuzzy_conditions:
                    # OR条件で追加（既存の条件との組み合わせ）
                    fuzzy_clause = " OR ".join(fuzzy_conditions)
                    # 既存の商標文字検索条件に追加
                    last_where = where_parts[-1]
                    if "standard_char_t LIKE" in last_where:
                        # 最後の商標文字検索条件を拡張
                        expanded_where = last_where[:-1] + " OR " + fuzzy_clause + ")"
                        where_parts[-1] = expanded_where
                        params.extend(fuzzy_params)
        
        # 申請人名検索（Phase 1強化版：申請人マスターデータ対応）
        if original_applicant_name:
            from_parts.append("LEFT JOIN jiken_c_t_shutugannindairinin ap ON j.normalized_app_num = ap.shutugan_no AND ap.shutugannindairinin_sikbt = '1'")
            # Phase 1: 新しい申請人マスターテーブルを優先使用
            from_parts.append("LEFT JOIN applicant_master_full amf ON ap.shutugannindairinin_code = amf.appl_cd")
            # 従来のテーブルをフォールバック
            from_parts.append("LEFT JOIN applicant_master am ON ap.shutugannindairinin_code = am.appl_cd")
            from_parts.append("LEFT JOIN applicant_mapping apm ON ap.shutugannindairinin_code = apm.applicant_code")
            
            if enhanced_search:
                # Phase 1拡張検索：新申請人マスター + 従来システム + 正規化検索
                where_parts.append("""(
                    amf.appl_name LIKE ? OR amf.appl_cana_name LIKE ? OR amf.wes_join_name LIKE ? OR
                    am.appl_name LIKE ? OR apm.applicant_name LIKE ? OR
                    amf.appl_name LIKE ? OR amf.appl_cana_name LIKE ? OR amf.wes_join_name LIKE ? OR
                    am.appl_name LIKE ? OR apm.applicant_name LIKE ?
                )""")
                normalized_pattern = f"%{applicant_name}%"
                original_pattern = f"%{original_applicant_name}%"
                # 新申請人マスター（正規化） + 従来（正規化） + 新申請人マスター（元） + 従来（元）
                params.extend([
                    normalized_pattern, normalized_pattern, normalized_pattern,  # 新マスター正規化
                    normalized_pattern, normalized_pattern,                     # 従来正規化
                    original_pattern, original_pattern, original_pattern,       # 新マスター元
                    original_pattern, original_pattern                          # 従来元
                ])
            else:
                # Phase 1基本検索：新申請人マスター優先
                where_parts.append("""(
                    amf.appl_name LIKE ? OR amf.appl_cana_name LIKE ? OR amf.wes_join_name LIKE ? OR
                    am.appl_name LIKE ? OR apm.applicant_name LIKE ?
                )""")
                original_pattern = f"%{original_applicant_name}%"
                params.extend([original_pattern, original_pattern, original_pattern, original_pattern, original_pattern])
        
        # 商品・役務区分（最適化済み）
        if goods_classes:
            from_parts.append("LEFT JOIN goods_class_art AS gca ON j.normalized_app_num = gca.normalized_app_num")
            terms = goods_classes.split()
            for term in terms:
                where_parts.append("gca.goods_classes LIKE ?")
                params.append(f"%{term}%")
        
        # 指定商品・役務名
        if designated_goods:
            from_parts.append("LEFT JOIN jiken_c_t_shohin_joho AS jcs ON j.normalized_app_num = jcs.normalized_app_num")
            terms = designated_goods.split()
            for term in terms:
                where_parts.append("jcs.designated_goods LIKE ?")
                params.append(f"%{term}%")
        
        # 類似群コード
        if similar_group_codes:
            from_parts.append("LEFT JOIN t_knd_info_art_table AS tknd ON j.normalized_app_num = tknd.normalized_app_num")
            terms = similar_group_codes.split()
            for term in terms:
                where_parts.append("tknd.smlr_dsgn_group_cd LIKE ?")
                params.append(f"%{term}%")
        
        sub_query_from = " ".join(from_parts)
        sub_query_where = " AND ".join(where_parts)
        
        # 総件数取得
        count_sql = f"SELECT COUNT(DISTINCT j.normalized_app_num) AS total {sub_query_from} WHERE {sub_query_where}"
        count_result = self.query_db_one(count_sql, tuple(params))
        total_count = count_result['total'] if count_result else 0
        
        if total_count == 0:
            return [], 0
        
        # 対象の出願番号を取得
        app_num_sql = f"SELECT DISTINCT j.normalized_app_num {sub_query_from} WHERE {sub_query_where} ORDER BY j.normalized_app_num LIMIT ? OFFSET ?"
        app_num_rows = self.query_db(app_num_sql, tuple(params + [limit, offset]))
        app_nums = [row['normalized_app_num'] for row in app_num_rows]
        
        if not app_nums:
            return [], total_count
        
        # 最適化された単一クエリで全データを取得
        results = self.get_optimized_results(app_nums)
        
        return results, total_count
    
    def format_result(self, result: Dict, format_type: str = "text") -> str:
        """結果のフォーマット（既存機能保持）"""
        if format_type == "json":
            return json.dumps(result, ensure_ascii=False, indent=2)
        
        # テキスト形式
        output = []
        output.append(f"出願番号: {result.get('app_num', 'N/A')}")
        output.append(f"商標: {result.get('mark_text', 'N/A')}")
        output.append(f"出願日: {self.format_date(result.get('app_date', ''))}")
        output.append(f"登録日: {self.format_date(result.get('reg_date', '')) if result.get('reg_date') else '未登録'}")
        
        if result.get('registration_number'):
            output.append(f"登録番号: {result.get('registration_number')}")
        
        if result.get('reg_gazette_date'):
            output.append(f"登録公報発行日: {self.format_date(result.get('reg_gazette_date'))}")
            
        if result.get('publication_date'):
            output.append(f"公開日: {self.format_date(result.get('publication_date'))}")
            
        if result.get('prior_right_date'):
            output.append(f"先願権発生日: {self.format_date(result.get('prior_right_date'))}")
            
        if result.get('expiry_date'):
            output.append(f"存続期間満了日: {self.format_date(result.get('expiry_date'))}")
            
        if result.get('rejection_dispatch_date'):
            output.append(f"拒絶査定発送日: {self.format_date(result.get('rejection_dispatch_date'))}")
            
        if result.get('renewal_application_date'):
            output.append(f"更新申請日: {self.format_date(result.get('renewal_application_date'))}")
            
        if result.get('renewal_registration_date'):
            output.append(f"更新登録日: {self.format_date(result.get('renewal_registration_date'))}")
            
        if result.get('trial_request_date'):
            output.append(f"審判請求日: {self.format_date(result.get('trial_request_date'))}")
            
        if result.get('trial_type'):
            output.append(f"審判種別: {result.get('trial_type')}")
            
        if result.get('additional_info'):
            output.append(f"付加情報: {result.get('additional_info')}")
        
        if result.get('applicant_name'):
            output.append(f"申請人: {result.get('applicant_name')}")
        
        if result.get('right_person_name'):
            output.append(f"権利者: {result.get('right_person_name')}")
            if result.get('right_person_addr'):
                output.append(f"権利者住所: {result.get('right_person_addr')}")
        
        if result.get('goods_classes'):
            goods_classes = result.get('goods_classes')
            class_count = len([cls.strip() for cls in goods_classes.split(',') if cls.strip()])
            output.append(f"商品区分: {goods_classes}")
            output.append(f"区分数: {class_count}区分")
        
        if result.get('designated_goods'):
            goods = result.get('designated_goods')
            if len(goods) > 100:
                goods = goods[:100] + "..."
            output.append(f"指定商品・役務: {goods}")
        
        if result.get('similar_group_codes'):
            output.append(f"類似群コード: {result.get('similar_group_codes')}")
        
        if result.get('call_name'):
            output.append(f"称呼: {result.get('call_name')}")
        
        output.append(f"画像: {result.get('has_image', 'NO')}")
        
        return "\n".join(output)
    
    def format_date(self, date_str: str) -> str:
        """日付のフォーマット（既存機能）"""
        if not date_str or len(date_str) != 8:
            return date_str or "N/A"
        try:
            year = date_str[0:4]
            month = date_str[4:6]
            day = date_str[6:8]
            return f"{year}年{month}月{day}日"
        except (ValueError, IndexError):
            return date_str
    
    def close(self):
        """リソースのクリーンアップ"""
        if self.conn:
            self.conn.close()


def main():
    """CLI エントリーポイント"""
    parser = argparse.ArgumentParser(description="拡張商標検索CLI（TM-SONAR水準の正規化機能付き）")
    parser.add_argument("--app-num", help="出願番号")
    parser.add_argument("--mark-text", help="商標文字")
    parser.add_argument("--applicant-name", help="申請人名")
    parser.add_argument("--goods-classes", help="商品・役務区分")
    parser.add_argument("--designated-goods", help="指定商品・役務名")
    parser.add_argument("--similar-group-codes", help="類似群コード")
    parser.add_argument("--limit", type=int, default=10, help="取得件数上限（デフォルト: 10）")
    parser.add_argument("--offset", type=int, default=0, help="オフセット（デフォルト: 0）")
    parser.add_argument("--format", choices=["text", "json"], default="text", help="出力形式")
    parser.add_argument("--db", help="データベースファイルパス")
    
    # 新機能オプション
    parser.add_argument("--enhanced", action="store_true", 
                       help="拡張検索を使用（P1基礎正規化適用）")
    parser.add_argument("--pronunciation", action="store_true", 
                       help="称呼検索を使用（発音同一判定）")
    parser.add_argument("--fuzzy", action="store_true",
                       help="曖昧検索を使用（部分一致・文字分割）")
    parser.add_argument("--tm-sonar", action="store_true",
                       help="TM-SONAR準拠検索を使用（複数指定・クエスチョンマーク対応）")
    
    args = parser.parse_args()
    
    # 検索条件のチェック
    search_conditions = [args.app_num, args.mark_text, args.applicant_name, args.goods_classes, 
                        args.designated_goods, args.similar_group_codes]
    if not any(search_conditions):
        parser.error("少なくとも1つの検索条件を指定してください")
    
    try:
        # CLIインスタンス作成
        cli = EnhancedTrademarkSearchCLI(args.db or "output.db")
        
        # 検索モードの表示
        mode_descriptions = []
        tm_sonar_enabled = getattr(args, 'tm_sonar', False)
        if tm_sonar_enabled:
            mode_descriptions.append("TM-SONAR準拠検索")
        elif args.enhanced:
            if args.pronunciation:
                mode_descriptions.append("称呼検索（発音同一判定）")
            else:
                mode_descriptions.append("拡張検索（基礎正規化）")
        else:
            mode_descriptions.append("標準検索")
            
        if args.fuzzy:
            mode_descriptions.append("曖昧検索（部分一致）")
            
        print(f"🔍 {' + '.join(mode_descriptions)}モードを使用")
        
        # 検索実行
        results, total_count = cli.search_trademarks(
            app_num=args.app_num,
            mark_text=args.mark_text,
            applicant_name=args.applicant_name,
            goods_classes=args.goods_classes,
            designated_goods=args.designated_goods,
            similar_group_codes=args.similar_group_codes,
            limit=args.limit,
            offset=args.offset,
            enhanced_search=args.enhanced,
            pronunciation_search=args.pronunciation,
            fuzzy_search=args.fuzzy,
            tm_sonar_search=tm_sonar_enabled
        )
        
        print(f"検索結果: {len(results)}件 / 総件数: {total_count}件")
        print("=" * 80)
        
        if not results:
            return
        
        # 結果出力
        for i, result in enumerate(results, 1):
            print(f"\n--- 結果 {i} ---")
            print(cli.format_result(result, args.format))
        
        cli.close()
        
    except Exception as e:
        print(f"エラーが発生しました: {str(e)}")
        return 1

if __name__ == "__main__":
    exit(main())
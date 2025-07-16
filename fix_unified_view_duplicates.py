#!/usr/bin/env python3
"""
統合ビューの重複問題を修正
申請人名検索で異常な重複が発生している問題を解決
"""
import sqlite3
from datetime import datetime

def fix_unified_view_duplicates():
    """統合ビューの重複問題を修正"""
    
    conn = sqlite3.connect("output.db")
    cursor = conn.cursor()
    
    print("🔧 統合ビューの重複問題修正")
    print("=" * 50)
    print(f"修正時間: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print("=" * 50)
    
    # 1. 現在の統合ビューの問題を確認
    print("\n1. 現在の統合ビューの問題を確認")
    
    # パナソニックの重複を確認
    cursor.execute("""
        SELECT COUNT(*) as total_rows, COUNT(DISTINCT app_num) as unique_apps
        FROM unified_trademark_search_view 
        WHERE applicant_name LIKE '%パナソニック%'
        LIMIT 1
    """)
    
    try:
        result = cursor.fetchone()
        if result:
            total_rows, unique_apps = result
            print(f"パナソニックの統合ビュー結果: {total_rows}行 / {unique_apps}ユニーク")
        else:
            print("パナソニックの統合ビュー結果: 取得できませんでした")
    except Exception as e:
        print(f"統合ビューの検索でエラー: {e}")
    
    # 2. 統合ビューを修正（重複排除を強化）
    print("\n2. 統合ビューの修正")
    
    cursor.execute("DROP VIEW IF EXISTS unified_trademark_search_view")
    
    # 修正された統合ビュー（重複を完全に排除）
    cursor.execute("""
        CREATE VIEW unified_trademark_search_view AS
        -- 国内商標（申請人名を含む、重複排除）
        SELECT DISTINCT
            'domestic' as source_type,
            j.normalized_app_num as app_num,
            COALESCE(rm.reg_num, j.normalized_app_num) as reg_num,
            j.shutugan_bi as app_date,
            j.reg_reg_ymd as reg_date,
            COALESCE(s.standard_char_t, iu.indct_use_t, su.search_use_t, td.dsgnt) as trademark_text,
            td.dsgnt as pronunciation,
            gca.goods_classes as nice_classes,
            jcs.designated_goods as goods_services,
            tknd.smlr_dsgn_group_cd as similar_groups,
            rp.right_person_name as holder_name,
            rp.right_person_addr as holder_addr,
            am.applicant_name as applicant_name,
            NULL as holder_country,
            CASE WHEN ts.image_data IS NOT NULL THEN 1 ELSE 0 END as has_image,
            j.normalized_app_num as unified_id,
            CASE 
                WHEN s.standard_char_t IS NOT NULL THEN s.standard_char_t
                WHEN iu.indct_use_t IS NOT NULL THEN iu.indct_use_t
                WHEN su.search_use_t IS NOT NULL THEN su.search_use_t
                WHEN td.dsgnt IS NOT NULL THEN td.dsgnt
                ELSE 'テキストなし'
            END as display_text,
            CASE 
                WHEN j.reg_reg_ymd IS NOT NULL AND j.reg_reg_ymd != '' THEN '登録済'
                ELSE '未登録'
            END as registration_status
        FROM jiken_c_t j
        LEFT JOIN standard_char_t_art s ON j.normalized_app_num = s.normalized_app_num
        LEFT JOIN indct_use_t_art iu ON j.normalized_app_num = iu.normalized_app_num
        LEFT JOIN search_use_t_art_table su ON j.normalized_app_num = su.normalized_app_num
        LEFT JOIN t_dsgnt_art td ON j.normalized_app_num = td.normalized_app_num
        LEFT JOIN reg_mapping rm ON j.normalized_app_num = rm.app_num
        LEFT JOIN right_person_art_t rp ON rm.reg_num = rp.reg_num
        LEFT JOIN (
            SELECT normalized_app_num, MIN(goods_classes) as goods_classes
            FROM goods_class_art 
            GROUP BY normalized_app_num
        ) gca ON j.normalized_app_num = gca.normalized_app_num
        LEFT JOIN (
            SELECT normalized_app_num, MIN(designated_goods) as designated_goods
            FROM jiken_c_t_shohin_joho 
            GROUP BY normalized_app_num
        ) jcs ON j.normalized_app_num = jcs.normalized_app_num
        LEFT JOIN (
            SELECT normalized_app_num, MIN(smlr_dsgn_group_cd) as smlr_dsgn_group_cd
            FROM t_knd_info_art_table 
            GROUP BY normalized_app_num
        ) tknd ON j.normalized_app_num = tknd.normalized_app_num
        LEFT JOIN t_sample ts ON j.normalized_app_num = ts.normalized_app_num
        LEFT JOIN (
            SELECT shutugan_no, MIN(shutugannindairinin_code) as shutugannindairinin_code
            FROM jiken_c_t_shutugannindairinin 
            WHERE shutugannindairinin_sikbt = '1'
            GROUP BY shutugan_no
        ) ap ON j.normalized_app_num = ap.shutugan_no
        LEFT JOIN applicant_mapping am ON ap.shutugannindairinin_code = am.applicant_code
        WHERE (s.standard_char_t IS NOT NULL OR iu.indct_use_t IS NOT NULL OR su.search_use_t IS NOT NULL OR td.dsgnt IS NOT NULL)

        UNION ALL

        -- 国際商標（申請人名は権利者名を使用、重複排除）
        SELECT DISTINCT
            'international' as source_type,
            ir.app_num,
            ir.intl_reg_num as reg_num,
            ir.app_date,
            ir.intl_reg_date as reg_date,
            it.t_dtl_explntn as trademark_text,
            NULL as pronunciation,
            ig.goods_class as nice_classes,
            ig.goods_content as goods_services,
            NULL as similar_groups,
            COALESCE(ih.holder_name_japanese, ih.holder_name) as holder_name,
            COALESCE(ih.holder_addr_japanese, ih.holder_addr) as holder_addr,
            COALESCE(ih.holder_name_japanese, ih.holder_name) as applicant_name,
            ih.holder_ctry_cd as holder_country,
            0 as has_image,
            ir.intl_reg_num as unified_id,
            COALESCE(it.t_dtl_explntn, ir.intl_reg_num, 'テキストなし') as display_text,
            CASE 
                WHEN ir.intl_reg_date IS NOT NULL AND ir.intl_reg_date != '' THEN '登録済'
                ELSE '未登録'
            END as registration_status
        FROM intl_trademark_registration ir
        LEFT JOIN intl_trademark_text it ON ir.intl_reg_num = it.intl_reg_num
        LEFT JOIN (
            SELECT intl_reg_num, MIN(goods_class) as goods_class, MIN(goods_content) as goods_content
            FROM intl_trademark_goods_services 
            GROUP BY intl_reg_num
        ) ig ON ir.intl_reg_num = ig.intl_reg_num
        LEFT JOIN (
            SELECT intl_reg_num, MIN(holder_name_japanese) as holder_name_japanese, MIN(holder_name) as holder_name, MIN(holder_addr_japanese) as holder_addr_japanese, MIN(holder_addr) as holder_addr, MIN(holder_ctry_cd) as holder_ctry_cd
            FROM intl_trademark_holder 
            GROUP BY intl_reg_num
        ) ih ON ir.intl_reg_num = ih.intl_reg_num
        WHERE (ir.define_flg = '1' OR ir.define_flg IS NULL)
    """)
    
    conn.commit()
    print("✅ 統合ビューを重複排除版に修正完了")
    
    # 3. 修正後の確認
    print("\n3. 修正後の確認")
    
    # パナソニックの確認
    cursor.execute("""
        SELECT COUNT(*) as count
        FROM unified_trademark_search_view 
        WHERE applicant_name LIKE '%パナソニック%'
    """)
    
    panasonic_count = cursor.fetchone()[0]
    print(f"パナソニック修正後: {panasonic_count}件")
    
    # 他の主要企業も確認
    test_companies = [
        "ソニー", "資生堂", "花王", "Apple", "コーセー"
    ]
    
    for company in test_companies:
        cursor.execute(f"""
            SELECT COUNT(*) as count
            FROM unified_trademark_search_view 
            WHERE applicant_name LIKE '%{company}%'
        """)
        
        count = cursor.fetchone()[0]
        print(f"{company}: {count}件")
    
    # 4. 全体の統計
    print("\n4. 全体の統計")
    
    cursor.execute("SELECT COUNT(*) FROM unified_trademark_search_view")
    total_count = cursor.fetchone()[0]
    print(f"統合ビュー総件数: {total_count:,}件")
    
    cursor.execute("SELECT COUNT(*) FROM unified_trademark_search_view WHERE applicant_name IS NOT NULL")
    with_applicant = cursor.fetchone()[0]
    
    applicant_coverage = with_applicant / total_count * 100 if total_count > 0 else 0
    print(f"申請人名カバレッジ: {applicant_coverage:.1f}%")
    
    conn.close()
    
    return {
        'total_count': total_count,
        'panasonic_count': panasonic_count,
        'applicant_coverage': applicant_coverage
    }

if __name__ == "__main__":
    result = fix_unified_view_duplicates()
    print(f"\n✅ 修正完了: 総件数 {result['total_count']:,}件、申請人名カバレッジ {result['applicant_coverage']:.1f}%")
-- 統合商標検索ビュー v2 - 重複問題解決版
-- 性能を重視し、重複を完全に排除

-- 既存ビューを削除
DROP VIEW IF EXISTS unified_trademark_search_view;

-- 最適化された統合商標検索ビュー作成（重複排除版）
CREATE VIEW unified_trademark_search_view AS
-- 国内商標（重複排除のためDISTINCT使用）
SELECT DISTINCT
    'domestic' as source_type,
    j.normalized_app_num as app_num,
    COALESCE(rm.reg_num, j.normalized_app_num) as reg_num,
    j.shutugan_bi as app_date,
    j.reg_reg_ymd as reg_date,
    COALESCE(s.standard_char_t, iu.indct_use_t, su.search_use_t, td.dsgnt) as trademark_text,
    td.dsgnt as pronunciation,
    GROUP_CONCAT(DISTINCT gca.goods_classes) as nice_classes,
    GROUP_CONCAT(DISTINCT jcs.designated_goods) as goods_services,
    GROUP_CONCAT(DISTINCT tknd.smlr_dsgn_group_cd) as similar_groups,
    rp.right_person_name as holder_name,
    rp.right_person_addr as holder_addr,
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
LEFT JOIN goods_class_art gca ON j.normalized_app_num = gca.normalized_app_num
LEFT JOIN jiken_c_t_shohin_joho jcs ON j.normalized_app_num = jcs.normalized_app_num
LEFT JOIN t_knd_info_art_table tknd ON j.normalized_app_num = tknd.normalized_app_num
LEFT JOIN t_sample ts ON j.normalized_app_num = ts.normalized_app_num
WHERE (s.standard_char_t IS NOT NULL OR iu.indct_use_t IS NOT NULL OR su.search_use_t IS NOT NULL OR td.dsgnt IS NOT NULL)
GROUP BY j.normalized_app_num, j.shutugan_bi, j.reg_reg_ymd, s.standard_char_t, iu.indct_use_t, su.search_use_t, td.dsgnt, rm.reg_num, rp.right_person_name, rp.right_person_addr, ts.image_data

UNION ALL

-- 国際商標（事前集約で重複排除）
SELECT DISTINCT
    'international' as source_type,
    ir.app_num,
    ir.intl_reg_num as reg_num,
    ir.app_date,
    ir.intl_reg_date as reg_date,
    it.t_dtl_explntn as trademark_text,
    NULL as pronunciation,
    GROUP_CONCAT(DISTINCT ig.goods_class) as nice_classes,
    GROUP_CONCAT(DISTINCT ig.goods_content) as goods_services,
    NULL as similar_groups,
    COALESCE(ih.holder_name_japanese, ih.holder_name) as holder_name,
    COALESCE(ih.holder_addr_japanese, ih.holder_addr) as holder_addr,
    ih.holder_ctry_cd as holder_country,
    0 as has_image,
    ir.intl_reg_num as unified_id,
    COALESCE(it.t_dtl_explntn, ir.intl_reg_num) as display_text,
    CASE 
        WHEN ir.intl_reg_date IS NOT NULL AND ir.intl_reg_date != '' THEN '登録済'
        ELSE '未登録'
    END as registration_status
FROM intl_trademark_registration ir
LEFT JOIN intl_trademark_text it ON ir.intl_reg_num = it.intl_reg_num
LEFT JOIN intl_trademark_goods_services ig ON ir.intl_reg_num = ig.intl_reg_num
LEFT JOIN intl_trademark_holder ih ON ir.intl_reg_num = ih.intl_reg_num
WHERE (ir.define_flg = '1' OR ir.define_flg IS NULL)
  AND (it.t_dtl_explntn IS NOT NULL OR ir.intl_reg_num IS NOT NULL)
GROUP BY ir.intl_reg_num, ir.app_num, ir.app_date, ir.intl_reg_date, it.t_dtl_explntn, ih.holder_name_japanese, ih.holder_name, ih.holder_addr_japanese, ih.holder_addr, ih.holder_ctry_cd;
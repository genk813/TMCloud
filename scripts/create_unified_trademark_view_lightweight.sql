-- 統合商標検索ビュー軽量版
-- 性能を最優先し、複雑な結合を避ける

-- 既存ビューを削除
DROP VIEW IF EXISTS unified_trademark_search_view;

-- 軽量版統合商標検索ビュー作成
CREATE VIEW unified_trademark_search_view AS
-- 国内商標（最小限の結合のみ）
SELECT 
    'domestic' as source_type,
    j.normalized_app_num as app_num,
    j.normalized_app_num as reg_num,
    j.shutugan_bi as app_date,
    j.reg_reg_ymd as reg_date,
    COALESCE(s.standard_char_t, iu.indct_use_t, su.search_use_t) as trademark_text,
    td.dsgnt as pronunciation,
    NULL as nice_classes,
    NULL as goods_services,
    NULL as similar_groups,
    NULL as holder_name,
    NULL as holder_addr,
    NULL as holder_country,
    0 as has_image,
    j.normalized_app_num as unified_id,
    COALESCE(s.standard_char_t, iu.indct_use_t, su.search_use_t, td.dsgnt, 'テキストなし') as display_text,
    CASE 
        WHEN j.reg_reg_ymd IS NOT NULL AND j.reg_reg_ymd != '' THEN '登録済'
        ELSE '未登録'
    END as registration_status
FROM jiken_c_t j
LEFT JOIN standard_char_t_art s ON j.normalized_app_num = s.normalized_app_num
LEFT JOIN indct_use_t_art iu ON j.normalized_app_num = iu.normalized_app_num
LEFT JOIN search_use_t_art_table su ON j.normalized_app_num = su.normalized_app_num
LEFT JOIN t_dsgnt_art td ON j.normalized_app_num = td.normalized_app_num
WHERE (s.standard_char_t IS NOT NULL OR iu.indct_use_t IS NOT NULL OR su.search_use_t IS NOT NULL OR td.dsgnt IS NOT NULL)

UNION ALL

-- 国際商標（最小限の結合のみ）
SELECT 
    'international' as source_type,
    ir.app_num,
    ir.intl_reg_num as reg_num,
    ir.app_date,
    ir.intl_reg_date as reg_date,
    it.t_dtl_explntn as trademark_text,
    NULL as pronunciation,
    NULL as nice_classes,
    NULL as goods_services,
    NULL as similar_groups,
    NULL as holder_name,
    NULL as holder_addr,
    NULL as holder_country,
    0 as has_image,
    ir.intl_reg_num as unified_id,
    COALESCE(it.t_dtl_explntn, ir.intl_reg_num, 'テキストなし') as display_text,
    CASE 
        WHEN ir.intl_reg_date IS NOT NULL AND ir.intl_reg_date != '' THEN '登録済'
        ELSE '未登録'
    END as registration_status
FROM intl_trademark_registration ir
LEFT JOIN intl_trademark_text it ON ir.intl_reg_num = it.intl_reg_num
WHERE (ir.define_flg = '1' OR ir.define_flg IS NULL);
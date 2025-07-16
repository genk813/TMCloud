-- 統合商標検索ビュー最適化版
-- 性能問題を解決するために簡略化とインデックス活用を重視

-- 既存ビューを削除
DROP VIEW IF EXISTS unified_trademark_search_view;

-- 最適化された統合商標検索ビュー作成
CREATE VIEW unified_trademark_search_view AS
-- 国内商標（シンプルな結合のみ）
SELECT 
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

UNION ALL

-- 国際商標（事前に集約されたデータのみ使用）
SELECT 
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
  AND (it.t_dtl_explntn IS NOT NULL OR ir.intl_reg_num IS NOT NULL);

-- 性能向上用のインデックス作成（実際のテーブルに対して）
-- 国内商標用
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_app_num ON jiken_c_t(normalized_app_num);
CREATE INDEX IF NOT EXISTS idx_standard_char_t_app_num ON standard_char_t_art(normalized_app_num);
CREATE INDEX IF NOT EXISTS idx_indct_use_t_app_num ON indct_use_t_art(normalized_app_num);
CREATE INDEX IF NOT EXISTS idx_search_use_t_app_num ON search_use_t_art_table(normalized_app_num);
CREATE INDEX IF NOT EXISTS idx_t_dsgnt_app_num ON t_dsgnt_art(normalized_app_num);
CREATE INDEX IF NOT EXISTS idx_reg_mapping_app_num ON reg_mapping(app_num);
CREATE INDEX IF NOT EXISTS idx_goods_class_art_app_num ON goods_class_art(normalized_app_num);

-- 国際商標用
CREATE INDEX IF NOT EXISTS idx_intl_trademark_registration_reg_num ON intl_trademark_registration(intl_reg_num);
CREATE INDEX IF NOT EXISTS idx_intl_trademark_text_reg_num ON intl_trademark_text(intl_reg_num);
CREATE INDEX IF NOT EXISTS idx_intl_trademark_goods_reg_num ON intl_trademark_goods_services(intl_reg_num);
CREATE INDEX IF NOT EXISTS idx_intl_trademark_holder_reg_num ON intl_trademark_holder(intl_reg_num);

-- 検索性能向上用のインデックス
CREATE INDEX IF NOT EXISTS idx_standard_char_t_text ON standard_char_t_art(standard_char_t);
CREATE INDEX IF NOT EXISTS idx_indct_use_t_text ON indct_use_t_art(indct_use_t);
CREATE INDEX IF NOT EXISTS idx_search_use_t_text ON search_use_t_art_table(search_use_t);
CREATE INDEX IF NOT EXISTS idx_t_dsgnt_text ON t_dsgnt_art(dsgnt);
CREATE INDEX IF NOT EXISTS idx_intl_trademark_text_content ON intl_trademark_text(t_dtl_explntn);
CREATE INDEX IF NOT EXISTS idx_goods_class_art_classes ON goods_class_art(goods_classes);
CREATE INDEX IF NOT EXISTS idx_intl_trademark_goods_class ON intl_trademark_goods_services(goods_class);
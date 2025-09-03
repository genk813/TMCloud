-- TMCloud Complete PostgreSQL Schema
-- Generated from 3-3b.xlsx and 5-1.xlsx

-- Create database
-- CREATE DATABASE tmcloud_db;

-- ABC情報ファイル (出願マスタ（特実）)
CREATE TABLE IF NOT EXISTS abc_cd_info (
    appl_atty_class TEXT,
    appl_atty_cd TEXT,
    change_num TEXT,
    valid_flg TEXT,
    req_typ TEXT,
    pref_cd TEXT,
    appl_addr TEXT,
    appl_name TEXT,
    atty_addr TEXT,
    atty_name TEXT,
    erasure_reason TEXT
);

CREATE INDEX IF NOT EXISTS idx_abc_cd_info_appl_atty_class ON abc_cd_info(appl_atty_class);
CREATE INDEX IF NOT EXISTS idx_abc_cd_info_appl_atty_cd ON abc_cd_info(appl_atty_cd);
CREATE INDEX IF NOT EXISTS idx_abc_cd_info_change_num ON abc_cd_info(change_num);
CREATE INDEX IF NOT EXISTS idx_abc_cd_info_appl_atty_class_code ON abc_cd_info(appl_atty_class);
CREATE INDEX IF NOT EXISTS idx_abc_cd_info_appl_atty_cd_code ON abc_cd_info(appl_atty_cd);
CREATE INDEX IF NOT EXISTS idx_abc_cd_info_valid_flg_code ON abc_cd_info(valid_flg);
CREATE INDEX IF NOT EXISTS idx_abc_cd_info_req_typ_code ON abc_cd_info(req_typ);
CREATE INDEX IF NOT EXISTS idx_abc_cd_info_pref_cd_code ON abc_cd_info(pref_cd);
CREATE INDEX IF NOT EXISTS idx_abc_cd_info_erasure_reason_code ON abc_cd_info(erasure_reason);

-- 追加特許記事ファイル (登録マスタ)
CREATE TABLE IF NOT EXISTS add_p_art (
    processing_type TEXT,
    law_cd TEXT,
    reg_num TEXT,
    split_num TEXT,
    app_num TEXT,
    add_p_art_upd_ymd TEXT,
    mu_num TEXT,
    add_patent_num TEXT
);

CREATE INDEX IF NOT EXISTS idx_add_p_art_law_cd ON add_p_art(law_cd);
CREATE INDEX IF NOT EXISTS idx_add_p_art_reg_num ON add_p_art(reg_num);
CREATE INDEX IF NOT EXISTS idx_add_p_art_split_num ON add_p_art(split_num);
CREATE INDEX IF NOT EXISTS idx_add_p_art_app_num ON add_p_art(app_num);
CREATE INDEX IF NOT EXISTS idx_add_p_art_mu_num ON add_p_art(mu_num);
CREATE INDEX IF NOT EXISTS idx_add_p_art_processing_type_code ON add_p_art(processing_type);
CREATE INDEX IF NOT EXISTS idx_add_p_art_law_cd_code ON add_p_art(law_cd);
CREATE INDEX IF NOT EXISTS idx_add_p_art_reg_num_code ON add_p_art(reg_num);
CREATE INDEX IF NOT EXISTS idx_add_p_art_split_num_code ON add_p_art(split_num);
CREATE INDEX IF NOT EXISTS idx_add_p_art_app_num_code ON add_p_art(app_num);
CREATE INDEX IF NOT EXISTS idx_add_p_art_mu_num_code ON add_p_art(mu_num);
CREATE INDEX IF NOT EXISTS idx_add_p_art_add_patent_num_code ON add_p_art(add_patent_num);

-- A系受付書類（書類データ有）ファイル (共有データベース（審判）)
CREATE TABLE IF NOT EXISTS aki_uktk_syri_syri_dt_ar (
    skbt_flg TEXT,
    uktk_syri_bngu TEXT,
    snpn_bngu TEXT,
    tyukn_cd TEXT,
    syri_ssds_dt TEXT,
    syri_uktk_dt TEXT,
    sri_kykr_kbn TEXT,
    husk_sybn_stat TEXT,
    hssu_syri_bngu TEXT,
    sir_bngu TEXT,
    syri_sybt_cd TEXT,
    syri_bnri_cd TEXT,
    yuku_flg TEXT,
    tiou_mk TEXT,
    etrn_kns_flg TEXT,
    hnku_tisyu_sytgnnn_dirnn_cd TEXT,
    yusnkn_tisytkk_cd TEXT,
    syri_ztti_rrk_bngu INTEGER,
    misisy_ver TEXT,
    mkug_syri_um TEXT,
    syri_fomt_sybt TEXT,
    tksk_bngu TEXT,
    dna_hirthyu_um TEXT,
    yuyksy_tnp_syri_sikyu_hni_um TEXT,
    tnp_syri_pagesu INTEGER,
    syri_siz INTEGER,
    kusn_ntz_bat TEXT
);

CREATE INDEX IF NOT EXISTS idx_aki_uktk_syri_syri_dt_ar_uktk_syri_bngu ON aki_uktk_syri_syri_dt_ar(uktk_syri_bngu);
CREATE INDEX IF NOT EXISTS idx_aki_uktk_syri_syri_dt_ar_skbt_flg_code ON aki_uktk_syri_syri_dt_ar(skbt_flg);
CREATE INDEX IF NOT EXISTS idx_aki_uktk_syri_syri_dt_ar_uktk_syri_bngu_code ON aki_uktk_syri_syri_dt_ar(uktk_syri_bngu);
CREATE INDEX IF NOT EXISTS idx_aki_uktk_syri_syri_dt_ar_snpn_bngu_code ON aki_uktk_syri_syri_dt_ar(snpn_bngu);
CREATE INDEX IF NOT EXISTS idx_aki_uktk_syri_syri_dt_ar_tyukn_cd_code ON aki_uktk_syri_syri_dt_ar(tyukn_cd);
CREATE INDEX IF NOT EXISTS idx_aki_uktk_syri_syri_dt_ar_sri_kykr_kbn_code ON aki_uktk_syri_syri_dt_ar(sri_kykr_kbn);
CREATE INDEX IF NOT EXISTS idx_aki_uktk_syri_syri_dt_ar_husk_sybn_stat_code ON aki_uktk_syri_syri_dt_ar(husk_sybn_stat);
CREATE INDEX IF NOT EXISTS idx_aki_uktk_syri_syri_dt_ar_hssu_syri_bngu_code ON aki_uktk_syri_syri_dt_ar(hssu_syri_bngu);
CREATE INDEX IF NOT EXISTS idx_aki_uktk_syri_syri_dt_ar_syri_sybt_cd_code ON aki_uktk_syri_syri_dt_ar(syri_sybt_cd);
CREATE INDEX IF NOT EXISTS idx_aki_uktk_syri_syri_dt_ar_yuku_flg_code ON aki_uktk_syri_syri_dt_ar(yuku_flg);
CREATE INDEX IF NOT EXISTS idx_aki_uktk_syri_syri_dt_ar_tiou_mk_code ON aki_uktk_syri_syri_dt_ar(tiou_mk);
CREATE INDEX IF NOT EXISTS idx_aki_uktk_syri_syri_dt_ar_etrn_kns_flg_code ON aki_uktk_syri_syri_dt_ar(etrn_kns_flg);
CREATE INDEX IF NOT EXISTS idx_aki_uktk_syri_syri_dt_ar_mkug_syri_um_code ON aki_uktk_syri_syri_dt_ar(mkug_syri_um);
CREATE INDEX IF NOT EXISTS idx_aki_uktk_syri_syri_dt_ar_syri_fomt_sybt_code ON aki_uktk_syri_syri_dt_ar(syri_fomt_sybt);
CREATE INDEX IF NOT EXISTS idx_aki_uktk_syri_syri_dt_ar_dna_hirthyu_um_code ON aki_uktk_syri_syri_dt_ar(dna_hirthyu_um);
CREATE INDEX IF NOT EXISTS idx_aki_uktk_syri_syri_dt_ar_yuyksy_tnp_syri_sikyu_hni_um_code ON aki_uktk_syri_syri_dt_ar(yuyksy_tnp_syri_sikyu_hni_um);

-- 出願公告記事ファイル (審判マスタ)
CREATE TABLE IF NOT EXISTS app_exam_pub_art (
    processing_type VARCHAR(1),
    appl_num VARCHAR(10),
    exam_pub_num VARCHAR(10),
    exam_pub_dt VARCHAR(8),
    updt_dttm VARCHAR(12)
);

CREATE INDEX IF NOT EXISTS idx_app_exam_pub_art_appl_num ON app_exam_pub_art(appl_num);
CREATE INDEX IF NOT EXISTS idx_app_exam_pub_art_exam_pub_num ON app_exam_pub_art(exam_pub_num);

-- 出願種別ファイル (審判マスタ)
CREATE TABLE IF NOT EXISTS app_typ (
    processing_type VARCHAR(1),
    appl_num VARCHAR(10),
    sequence_num SMALLINT,
    app_typ VARCHAR(2),
    updt_dttm VARCHAR(12)
);

CREATE INDEX IF NOT EXISTS idx_app_typ_appl_num ON app_typ(appl_num);
CREATE INDEX IF NOT EXISTS idx_app_typ_sequence_num ON app_typ(sequence_num);

-- 審判事件ファイル (審判マスタ)
CREATE TABLE IF NOT EXISTS appl_case (
    processing_type VARCHAR(1),
    appl_num VARCHAR(10),
    app_num VARCHAR(10),
    law_cd_class VARCHAR(1),
    reg_num VARCHAR(7),
    split_num VARCHAR(32),
    smlr_dsgn_num VARCHAR(3),
    sec_num VARCHAR(3),
    reg_bul_pub_dt VARCHAR(8),
    set_reg_dt VARCHAR(8),
    appeal_prog_stts VARCHAR(1),
    merge_appeal_flg VARCHAR(2),
    instance_typ VARCHAR(1),
    appl_typ VARCHAR(3),
    appl_clim_dt VARCHAR(8),
    final_dspst_cd VARCHAR(2),
    final_dspst_define_dt VARCHAR(8),
    early_priority_appeal_flg VARCHAR(1),
    pub_num VARCHAR(10),
    updt_dttm VARCHAR(12)
);

CREATE INDEX IF NOT EXISTS idx_appl_case_appl_num ON appl_case(appl_num);

-- 審判当事者ファイル (審判マスタ)
CREATE TABLE IF NOT EXISTS appl_concerned_person (
    processing_type VARCHAR(1),
    appl_num VARCHAR(10),
    opp_join_num VARCHAR(3),
    sequence_num SMALLINT,
    concerned_person_typ VARCHAR(2),
    appl_id VARCHAR(9),
    requestor_typ VARCHAR(1),
    pref_cd VARCHAR(2),
    atty_typ VARCHAR(1),
    atty_qualify_typ VARCHAR(1),
    addr VARCHAR(200),
    name VARCHAR(200),
    atty_cd VARCHAR(4),
    updt_dttm VARCHAR(12)
);

CREATE INDEX IF NOT EXISTS idx_appl_concerned_person_appl_num ON appl_concerned_person(appl_num);
CREATE INDEX IF NOT EXISTS idx_appl_concerned_person_opp_join_num ON appl_concerned_person(opp_join_num);
CREATE INDEX IF NOT EXISTS idx_appl_concerned_person_sequence_num ON appl_concerned_person(sequence_num);
CREATE INDEX IF NOT EXISTS idx_appl_concerned_person_concerned_person_typ ON appl_concerned_person(concerned_person_typ);

-- 申請人登録情報ファイル (申請人登録マスタ)
CREATE TABLE IF NOT EXISTS appl_reg_info (
    data_id_cd TEXT,
    appl_cd TEXT,
    appl_name TEXT,
    appl_cana_name TEXT,
    appl_postcode TEXT,
    appl_addr TEXT,
    wes_join_name TEXT,
    wes_join_addr TEXT,
    integ_appl_cd TEXT,
    dbl_reg_integ_mgt_srl_num INTEGER
);

CREATE INDEX IF NOT EXISTS idx_appl_reg_info_appl_cd ON appl_reg_info(appl_cd);
CREATE INDEX IF NOT EXISTS idx_appl_reg_info_data_id_cd_code ON appl_reg_info(data_id_cd);
CREATE INDEX IF NOT EXISTS idx_appl_reg_info_dbl_reg_integ_mgt_srl_num_code ON appl_reg_info(dbl_reg_integ_mgt_srl_num);

-- 代理人記事ファイル(意匠) (登録マスタ)
CREATE TABLE IF NOT EXISTS atty_art_d (
    processing_type TEXT,
    law_cd TEXT,
    reg_num TEXT,
    split_num TEXT,
    app_num TEXT,
    rec_num TEXT,
    pe_num TEXT,
    atty_art_upd_ymd TEXT,
    atty_appl_id TEXT,
    atty_typ TEXT,
    atty_name_len TEXT,
    atty_name TEXT
);

CREATE INDEX IF NOT EXISTS idx_atty_art_d_law_cd ON atty_art_d(law_cd);
CREATE INDEX IF NOT EXISTS idx_atty_art_d_reg_num ON atty_art_d(reg_num);
CREATE INDEX IF NOT EXISTS idx_atty_art_d_split_num ON atty_art_d(split_num);
CREATE INDEX IF NOT EXISTS idx_atty_art_d_app_num ON atty_art_d(app_num);
CREATE INDEX IF NOT EXISTS idx_atty_art_d_rec_num ON atty_art_d(rec_num);
CREATE INDEX IF NOT EXISTS idx_atty_art_d_pe_num ON atty_art_d(pe_num);
CREATE INDEX IF NOT EXISTS idx_atty_art_d_processing_type_code ON atty_art_d(processing_type);
CREATE INDEX IF NOT EXISTS idx_atty_art_d_law_cd_code ON atty_art_d(law_cd);
CREATE INDEX IF NOT EXISTS idx_atty_art_d_reg_num_code ON atty_art_d(reg_num);
CREATE INDEX IF NOT EXISTS idx_atty_art_d_split_num_code ON atty_art_d(split_num);
CREATE INDEX IF NOT EXISTS idx_atty_art_d_app_num_code ON atty_art_d(app_num);
CREATE INDEX IF NOT EXISTS idx_atty_art_d_pe_num_code ON atty_art_d(pe_num);
CREATE INDEX IF NOT EXISTS idx_atty_art_d_atty_appl_id_code ON atty_art_d(atty_appl_id);
CREATE INDEX IF NOT EXISTS idx_atty_art_d_atty_typ_code ON atty_art_d(atty_typ);

-- 代理人記事ファイル(ハーグ) (登録マスタ)
CREATE TABLE IF NOT EXISTS atty_art_hague (
    processing_type TEXT,
    law_cd TEXT,
    reg_num TEXT,
    split_num TEXT,
    app_num TEXT,
    rec_num TEXT,
    pe_num TEXT,
    atty_art_upd_ymd TEXT,
    atty_appl_id TEXT,
    atty_typ TEXT,
    atty_name_len TEXT,
    atty_name TEXT
);

CREATE INDEX IF NOT EXISTS idx_atty_art_hague_law_cd ON atty_art_hague(law_cd);
CREATE INDEX IF NOT EXISTS idx_atty_art_hague_reg_num ON atty_art_hague(reg_num);
CREATE INDEX IF NOT EXISTS idx_atty_art_hague_split_num ON atty_art_hague(split_num);
CREATE INDEX IF NOT EXISTS idx_atty_art_hague_app_num ON atty_art_hague(app_num);
CREATE INDEX IF NOT EXISTS idx_atty_art_hague_rec_num ON atty_art_hague(rec_num);
CREATE INDEX IF NOT EXISTS idx_atty_art_hague_pe_num ON atty_art_hague(pe_num);
CREATE INDEX IF NOT EXISTS idx_atty_art_hague_processing_type_code ON atty_art_hague(processing_type);
CREATE INDEX IF NOT EXISTS idx_atty_art_hague_law_cd_code ON atty_art_hague(law_cd);
CREATE INDEX IF NOT EXISTS idx_atty_art_hague_reg_num_code ON atty_art_hague(reg_num);
CREATE INDEX IF NOT EXISTS idx_atty_art_hague_split_num_code ON atty_art_hague(split_num);
CREATE INDEX IF NOT EXISTS idx_atty_art_hague_app_num_code ON atty_art_hague(app_num);
CREATE INDEX IF NOT EXISTS idx_atty_art_hague_pe_num_code ON atty_art_hague(pe_num);
CREATE INDEX IF NOT EXISTS idx_atty_art_hague_atty_appl_id_code ON atty_art_hague(atty_appl_id);
CREATE INDEX IF NOT EXISTS idx_atty_art_hague_atty_typ_code ON atty_art_hague(atty_typ);

-- 代理人記事ファイル(特許) (登録マスタ)
CREATE TABLE IF NOT EXISTS atty_art_p (
    processing_type TEXT,
    law_cd TEXT,
    reg_num TEXT,
    split_num TEXT,
    app_num TEXT,
    rec_num TEXT,
    pe_num TEXT,
    atty_art_upd_ymd TEXT,
    atty_appl_id TEXT,
    atty_typ TEXT,
    atty_name_len TEXT,
    atty_name TEXT
);

CREATE INDEX IF NOT EXISTS idx_atty_art_p_law_cd ON atty_art_p(law_cd);
CREATE INDEX IF NOT EXISTS idx_atty_art_p_reg_num ON atty_art_p(reg_num);
CREATE INDEX IF NOT EXISTS idx_atty_art_p_split_num ON atty_art_p(split_num);
CREATE INDEX IF NOT EXISTS idx_atty_art_p_app_num ON atty_art_p(app_num);
CREATE INDEX IF NOT EXISTS idx_atty_art_p_rec_num ON atty_art_p(rec_num);
CREATE INDEX IF NOT EXISTS idx_atty_art_p_pe_num ON atty_art_p(pe_num);
CREATE INDEX IF NOT EXISTS idx_atty_art_p_processing_type_code ON atty_art_p(processing_type);
CREATE INDEX IF NOT EXISTS idx_atty_art_p_law_cd_code ON atty_art_p(law_cd);
CREATE INDEX IF NOT EXISTS idx_atty_art_p_reg_num_code ON atty_art_p(reg_num);
CREATE INDEX IF NOT EXISTS idx_atty_art_p_split_num_code ON atty_art_p(split_num);
CREATE INDEX IF NOT EXISTS idx_atty_art_p_app_num_code ON atty_art_p(app_num);
CREATE INDEX IF NOT EXISTS idx_atty_art_p_pe_num_code ON atty_art_p(pe_num);
CREATE INDEX IF NOT EXISTS idx_atty_art_p_atty_appl_id_code ON atty_art_p(atty_appl_id);
CREATE INDEX IF NOT EXISTS idx_atty_art_p_atty_typ_code ON atty_art_p(atty_typ);

-- 代理人記事ファイル(商標) (登録マスタ)
CREATE TABLE IF NOT EXISTS atty_art_t (
    processing_type TEXT,
    law_cd TEXT,
    reg_num TEXT,
    split_num TEXT,
    app_num TEXT,
    rec_num TEXT,
    pe_num TEXT,
    atty_art_upd_ymd TEXT,
    atty_appl_id TEXT,
    atty_typ TEXT,
    atty_name_len TEXT,
    atty_name TEXT
);

CREATE INDEX IF NOT EXISTS idx_atty_art_t_law_cd ON atty_art_t(law_cd);
CREATE INDEX IF NOT EXISTS idx_atty_art_t_reg_num ON atty_art_t(reg_num);
CREATE INDEX IF NOT EXISTS idx_atty_art_t_split_num ON atty_art_t(split_num);
CREATE INDEX IF NOT EXISTS idx_atty_art_t_app_num ON atty_art_t(app_num);
CREATE INDEX IF NOT EXISTS idx_atty_art_t_rec_num ON atty_art_t(rec_num);
CREATE INDEX IF NOT EXISTS idx_atty_art_t_pe_num ON atty_art_t(pe_num);
CREATE INDEX IF NOT EXISTS idx_atty_art_t_processing_type_code ON atty_art_t(processing_type);
CREATE INDEX IF NOT EXISTS idx_atty_art_t_law_cd_code ON atty_art_t(law_cd);
CREATE INDEX IF NOT EXISTS idx_atty_art_t_reg_num_code ON atty_art_t(reg_num);
CREATE INDEX IF NOT EXISTS idx_atty_art_t_split_num_code ON atty_art_t(split_num);
CREATE INDEX IF NOT EXISTS idx_atty_art_t_app_num_code ON atty_art_t(app_num);
CREATE INDEX IF NOT EXISTS idx_atty_art_t_pe_num_code ON atty_art_t(pe_num);
CREATE INDEX IF NOT EXISTS idx_atty_art_t_atty_appl_id_code ON atty_art_t(atty_appl_id);
CREATE INDEX IF NOT EXISTS idx_atty_art_t_atty_typ_code ON atty_art_t(atty_typ);

-- 代理人記事ファイル(実用) (登録マスタ)
CREATE TABLE IF NOT EXISTS atty_art_u (
    processing_type TEXT,
    law_cd TEXT,
    reg_num TEXT,
    split_num TEXT,
    app_num TEXT,
    rec_num TEXT,
    pe_num TEXT,
    atty_art_upd_ymd TEXT,
    atty_appl_id TEXT,
    atty_typ TEXT,
    atty_name_len TEXT,
    atty_name TEXT
);

CREATE INDEX IF NOT EXISTS idx_atty_art_u_law_cd ON atty_art_u(law_cd);
CREATE INDEX IF NOT EXISTS idx_atty_art_u_reg_num ON atty_art_u(reg_num);
CREATE INDEX IF NOT EXISTS idx_atty_art_u_split_num ON atty_art_u(split_num);
CREATE INDEX IF NOT EXISTS idx_atty_art_u_app_num ON atty_art_u(app_num);
CREATE INDEX IF NOT EXISTS idx_atty_art_u_rec_num ON atty_art_u(rec_num);
CREATE INDEX IF NOT EXISTS idx_atty_art_u_pe_num ON atty_art_u(pe_num);
CREATE INDEX IF NOT EXISTS idx_atty_art_u_processing_type_code ON atty_art_u(processing_type);
CREATE INDEX IF NOT EXISTS idx_atty_art_u_law_cd_code ON atty_art_u(law_cd);
CREATE INDEX IF NOT EXISTS idx_atty_art_u_reg_num_code ON atty_art_u(reg_num);
CREATE INDEX IF NOT EXISTS idx_atty_art_u_split_num_code ON atty_art_u(split_num);
CREATE INDEX IF NOT EXISTS idx_atty_art_u_app_num_code ON atty_art_u(app_num);
CREATE INDEX IF NOT EXISTS idx_atty_art_u_pe_num_code ON atty_art_u(pe_num);
CREATE INDEX IF NOT EXISTS idx_atty_art_u_atty_appl_id_code ON atty_art_u(atty_appl_id);
CREATE INDEX IF NOT EXISTS idx_atty_art_u_atty_typ_code ON atty_art_u(atty_typ);

-- 部門移管ファイル (共有データベース（審判）)
CREATE TABLE IF NOT EXISTS bmn_ikn (
    skbt_flg TEXT,
    tyuni_syri_bngu TEXT,
    bmn_ikn_dt TEXT,
    kusn_ntz_bat TEXT
);

CREATE INDEX IF NOT EXISTS idx_bmn_ikn_tyuni_syri_bngu ON bmn_ikn(tyuni_syri_bngu);
CREATE INDEX IF NOT EXISTS idx_bmn_ikn_skbt_flg_code ON bmn_ikn(skbt_flg);
CREATE INDEX IF NOT EXISTS idx_bmn_ikn_tyuni_syri_bngu_code ON bmn_ikn(tyuni_syri_bngu);

-- 取消す請求項ファイル (審判マスタ)
CREATE TABLE IF NOT EXISTS cancel_claim (
    processing_type VARCHAR(1),
    appl_num VARCHAR(10),
    apply_class VARCHAR(1),
    opp_num VARCHAR(3),
    sequence_num SMALLINT,
    claim_cd VARCHAR(3),
    updt_dttm VARCHAR(12)
);

CREATE INDEX IF NOT EXISTS idx_cancel_claim_appl_num ON cancel_claim(appl_num);
CREATE INDEX IF NOT EXISTS idx_cancel_claim_apply_class ON cancel_claim(apply_class);
CREATE INDEX IF NOT EXISTS idx_cancel_claim_opp_num ON cancel_claim(opp_num);
CREATE INDEX IF NOT EXISTS idx_cancel_claim_sequence_num ON cancel_claim(sequence_num);

-- 取消す指定商品名ファイル (審判マスタ)
CREATE TABLE IF NOT EXISTS cancel_desig_goods_name (
    processing_type VARCHAR(1),
    appl_num VARCHAR(10),
    opp_num VARCHAR(3),
    goods_class VARCHAR(2),
    desig_goods_name TEXT,
    updt_dttm VARCHAR(12)
);

CREATE INDEX IF NOT EXISTS idx_cancel_desig_goods_name_appl_num ON cancel_desig_goods_name(appl_num);
CREATE INDEX IF NOT EXISTS idx_cancel_desig_goods_name_opp_num ON cancel_desig_goods_name(opp_num);
CREATE INDEX IF NOT EXISTS idx_cancel_desig_goods_name_goods_class ON cancel_desig_goods_name(goods_class);

-- 請求公告記事ファイル (審判マスタ)
CREATE TABLE IF NOT EXISTS clim_exam_pub_art (
    processing_type VARCHAR(1),
    appl_num VARCHAR(10),
    exam_pub_num VARCHAR(10),
    exam_pub_dt VARCHAR(8),
    updt_dttm VARCHAR(12)
);

CREATE INDEX IF NOT EXISTS idx_clim_exam_pub_art_appl_num ON clim_exam_pub_art(appl_num);
CREATE INDEX IF NOT EXISTS idx_clim_exam_pub_art_exam_pub_num ON clim_exam_pub_art(exam_pub_num);

-- 公報関連情報ファイル (出願マスタ（特実）)
CREATE TABLE IF NOT EXISTS cmbi_g_bul_info (
    law_cd TEXT,
    app_num TEXT,
    bi_delete_flg TEXT,
    bi_update_dttm TEXT,
    biub_delete_flg TEXT,
    biub_total_vol_num INTEGER,
    biub_annual_vol_num INTEGER,
    biub_each_fld_vol_num INTEGER,
    biub_each_fld_annual_vol_num INTEGER,
    biub_publish_class TEXT,
    bipb_delete_flg TEXT,
    bipb_total_vol_num INTEGER,
    bipb_annual_vol_num INTEGER,
    bipb_each_fld_vol_num INTEGER,
    bipb_each_fld_annual_vol_num INTEGER,
    bipb_publish_class TEXT,
    birw_delete_flg TEXT,
    birw_total_vol_num INTEGER,
    birw_annual_vol_num INTEGER,
    birw_each_law_vol_num INTEGER,
    birw_each_law_annual_vol_num INTEGER,
    biab_delete_flg TEXT,
    biab_total_vol_num INTEGER,
    biab_annual_vol_num INTEGER,
    biab_each_fld_vol_num INTEGER,
    biab_each_fld_annual_vol_num INTEGER,
    biab_publish_class TEXT,
    biab_bul_publish_dt TEXT,
    biab_crrct_id TEXT,
    biau_delete_flg TEXT,
    biau_total_vol_num INTEGER,
    biau_annual_vol_num INTEGER,
    biau_each_fld_vol_num INTEGER,
    biau_each_fld_annual_vol_num INTEGER,
    biau_publish_class TEXT,
    biau_bul_publish_dt TEXT,
    biau_crrct_id TEXT,
    bipe_delete_flg TEXT,
    bipe_total_vol_num INTEGER,
    bipe_annual_vol_num INTEGER,
    bipe_each_fld_vol_num INTEGER,
    bipe_each_fld_annual_vol_num INTEGER,
    bipe_publish_class TEXT,
    bipe_bul_publish_dt TEXT,
    bipe_crrct_id TEXT,
    bire_delete_flg TEXT,
    bire_total_vol_num INTEGER,
    bire_annual_vol_num INTEGER,
    bire_each_fld_vol_num INTEGER,
    bire_each_fld_annual_vol_num INTEGER,
    bire_publish_class TEXT,
    bire_bul_publish_dt TEXT,
    bire_crrct_id TEXT
);

CREATE INDEX IF NOT EXISTS idx_cmbi_g_bul_info_law_cd ON cmbi_g_bul_info(law_cd);
CREATE INDEX IF NOT EXISTS idx_cmbi_g_bul_info_app_num ON cmbi_g_bul_info(app_num);
CREATE INDEX IF NOT EXISTS idx_cmbi_g_bul_info_law_cd_code ON cmbi_g_bul_info(law_cd);
CREATE INDEX IF NOT EXISTS idx_cmbi_g_bul_info_app_num_code ON cmbi_g_bul_info(app_num);
CREATE INDEX IF NOT EXISTS idx_cmbi_g_bul_info_bi_delete_flg_code ON cmbi_g_bul_info(bi_delete_flg);
CREATE INDEX IF NOT EXISTS idx_cmbi_g_bul_info_biub_delete_flg_code ON cmbi_g_bul_info(biub_delete_flg);
CREATE INDEX IF NOT EXISTS idx_cmbi_g_bul_info_biub_publish_class_code ON cmbi_g_bul_info(biub_publish_class);
CREATE INDEX IF NOT EXISTS idx_cmbi_g_bul_info_bipb_delete_flg_code ON cmbi_g_bul_info(bipb_delete_flg);
CREATE INDEX IF NOT EXISTS idx_cmbi_g_bul_info_bipb_publish_class_code ON cmbi_g_bul_info(bipb_publish_class);
CREATE INDEX IF NOT EXISTS idx_cmbi_g_bul_info_birw_delete_flg_code ON cmbi_g_bul_info(birw_delete_flg);
CREATE INDEX IF NOT EXISTS idx_cmbi_g_bul_info_biab_delete_flg_code ON cmbi_g_bul_info(biab_delete_flg);
CREATE INDEX IF NOT EXISTS idx_cmbi_g_bul_info_biab_publish_class_code ON cmbi_g_bul_info(biab_publish_class);
CREATE INDEX IF NOT EXISTS idx_cmbi_g_bul_info_biab_crrct_id_code ON cmbi_g_bul_info(biab_crrct_id);
CREATE INDEX IF NOT EXISTS idx_cmbi_g_bul_info_biau_delete_flg_code ON cmbi_g_bul_info(biau_delete_flg);
CREATE INDEX IF NOT EXISTS idx_cmbi_g_bul_info_biau_publish_class_code ON cmbi_g_bul_info(biau_publish_class);
CREATE INDEX IF NOT EXISTS idx_cmbi_g_bul_info_biau_crrct_id_code ON cmbi_g_bul_info(biau_crrct_id);
CREATE INDEX IF NOT EXISTS idx_cmbi_g_bul_info_bipe_delete_flg_code ON cmbi_g_bul_info(bipe_delete_flg);
CREATE INDEX IF NOT EXISTS idx_cmbi_g_bul_info_bipe_publish_class_code ON cmbi_g_bul_info(bipe_publish_class);
CREATE INDEX IF NOT EXISTS idx_cmbi_g_bul_info_bipe_crrct_id_code ON cmbi_g_bul_info(bipe_crrct_id);
CREATE INDEX IF NOT EXISTS idx_cmbi_g_bul_info_bire_delete_flg_code ON cmbi_g_bul_info(bire_delete_flg);
CREATE INDEX IF NOT EXISTS idx_cmbi_g_bul_info_bire_publish_class_code ON cmbi_g_bul_info(bire_publish_class);
CREATE INDEX IF NOT EXISTS idx_cmbi_g_bul_info_bire_crrct_id_code ON cmbi_g_bul_info(bire_crrct_id);

-- IB中間記録ファイル (出願マスタ（特実）)
CREATE TABLE IF NOT EXISTS cmdo_ib_intermed_rec (
    irir_intnl_app_law_cd TEXT,
    irir_intnl_app_num TEXT,
    irir_ib_intrmd_serial_num INTEGER,
    irir_input_dt TEXT,
    irir_valid_flg TEXT,
    irir_typ_cd TEXT,
    irir_rcpt_dt TEXT,
    irir_flg_1 TEXT,
    irir_flg_2 TEXT,
    irir_flg_3 TEXT,
    irir_flg_4 TEXT,
    irir_flg_5 TEXT
);

CREATE INDEX IF NOT EXISTS idx_cmdo_ib_intermed_rec_irir_intnl_app_law_cd ON cmdo_ib_intermed_rec(irir_intnl_app_law_cd);
CREATE INDEX IF NOT EXISTS idx_cmdo_ib_intermed_rec_irir_intnl_app_num ON cmdo_ib_intermed_rec(irir_intnl_app_num);
CREATE INDEX IF NOT EXISTS idx_cmdo_ib_intermed_rec_irir_ib_intrmd_serial_num ON cmdo_ib_intermed_rec(irir_ib_intrmd_serial_num);
CREATE INDEX IF NOT EXISTS idx_cmdo_ib_intermed_rec_irir_intnl_app_law_cd_code ON cmdo_ib_intermed_rec(irir_intnl_app_law_cd);
CREATE INDEX IF NOT EXISTS idx_cmdo_ib_intermed_rec_irir_intnl_app_num_code ON cmdo_ib_intermed_rec(irir_intnl_app_num);
CREATE INDEX IF NOT EXISTS idx_cmdo_ib_intermed_rec_irir_valid_flg_code ON cmdo_ib_intermed_rec(irir_valid_flg);

-- 国際出願書類ファイル (出願マスタ（特実）)
CREATE TABLE IF NOT EXISTS cmia_g_intl_app_doc (
    intl_app_num TEXT,
    storing_seq_num INTEGER,
    article_id TEXT,
    ia_delete_flg TEXT,
    ia_update_dttm TEXT,
    iaba_delete_flg TEXT,
    iaba_create_dt TEXT,
    iaba_valid_flg TEXT,
    iaba_intrmd_doc_cd TEXT,
    iaba_rcpt_dt TEXT,
    iaba_checked_flg TEXT,
    iaba_dspst_dt TEXT,
    iaba_crrspnd_doc_num TEXT,
    iaba_rcpt_num TEXT,
    iaba_doc_typ_cd TEXT,
    iaba_ver_num TEXT,
    iaba_descript_ver_num TEXT,
    iaba_dna_flg TEXT,
    iaba_description_page INTEGER,
    iaba_descript_flg TEXT,
    iaba_drawing_page INTEGER,
    iaba_drawing_flg TEXT,
    iaba_abstrct_doc_page INTEGER,
    iaba_abstrct_flg TEXT,
    iaba_attchd_doc_page INTEGER,
    iaba_doc_size INTEGER,
    iabd_delete_flg TEXT,
    iabd_valid_flg TEXT,
    iabd_intrmd_doc_cd TEXT,
    iabd_dsptch_dt TEXT,
    iabd_crrspnd_doc_num TEXT,
    iabd_dsptch_doc_num TEXT,
    iabd_doc_typ_cd TEXT,
    iabd_ver_num TEXT,
    iabd_invalid_doc_flg TEXT,
    iabd_doc_frmt_typ TEXT,
    iabd_dsptch_doc_image_page INTEGER,
    iabd_doc_size INTEGER,
    iabj_delete_flg TEXT,
    iabj_create_dt TEXT,
    iabj_valid_flg TEXT,
    iabj_intrmd_doc_cd TEXT,
    iabj_dspst_dt TEXT,
    iabj_crrspnd_doc_num TEXT,
    iabj_jpo_doc_num TEXT,
    iabj_doc_typ_cd TEXT,
    iabj_doc_frmt_typ TEXT,
    iabj_jpo_doc_image_page INTEGER,
    iabj_doc_size INTEGER
);

CREATE INDEX IF NOT EXISTS idx_cmia_g_intl_app_doc_intl_app_num ON cmia_g_intl_app_doc(intl_app_num);
CREATE INDEX IF NOT EXISTS idx_cmia_g_intl_app_doc_storing_seq_num ON cmia_g_intl_app_doc(storing_seq_num);
CREATE INDEX IF NOT EXISTS idx_cmia_g_intl_app_doc_intl_app_num_code ON cmia_g_intl_app_doc(intl_app_num);
CREATE INDEX IF NOT EXISTS idx_cmia_g_intl_app_doc_article_id_code ON cmia_g_intl_app_doc(article_id);
CREATE INDEX IF NOT EXISTS idx_cmia_g_intl_app_doc_ia_delete_flg_code ON cmia_g_intl_app_doc(ia_delete_flg);
CREATE INDEX IF NOT EXISTS idx_cmia_g_intl_app_doc_iaba_delete_flg_code ON cmia_g_intl_app_doc(iaba_delete_flg);
CREATE INDEX IF NOT EXISTS idx_cmia_g_intl_app_doc_iaba_valid_flg_code ON cmia_g_intl_app_doc(iaba_valid_flg);
CREATE INDEX IF NOT EXISTS idx_cmia_g_intl_app_doc_iaba_intrmd_doc_cd_code ON cmia_g_intl_app_doc(iaba_intrmd_doc_cd);
CREATE INDEX IF NOT EXISTS idx_cmia_g_intl_app_doc_iaba_checked_flg_code ON cmia_g_intl_app_doc(iaba_checked_flg);
CREATE INDEX IF NOT EXISTS idx_cmia_g_intl_app_doc_iaba_crrspnd_doc_num_code ON cmia_g_intl_app_doc(iaba_crrspnd_doc_num);
CREATE INDEX IF NOT EXISTS idx_cmia_g_intl_app_doc_iaba_rcpt_num_code ON cmia_g_intl_app_doc(iaba_rcpt_num);
CREATE INDEX IF NOT EXISTS idx_cmia_g_intl_app_doc_iaba_doc_typ_cd_code ON cmia_g_intl_app_doc(iaba_doc_typ_cd);
CREATE INDEX IF NOT EXISTS idx_cmia_g_intl_app_doc_iaba_ver_num_code ON cmia_g_intl_app_doc(iaba_ver_num);
CREATE INDEX IF NOT EXISTS idx_cmia_g_intl_app_doc_iabd_delete_flg_code ON cmia_g_intl_app_doc(iabd_delete_flg);
CREATE INDEX IF NOT EXISTS idx_cmia_g_intl_app_doc_iabd_valid_flg_code ON cmia_g_intl_app_doc(iabd_valid_flg);
CREATE INDEX IF NOT EXISTS idx_cmia_g_intl_app_doc_iabd_intrmd_doc_cd_code ON cmia_g_intl_app_doc(iabd_intrmd_doc_cd);
CREATE INDEX IF NOT EXISTS idx_cmia_g_intl_app_doc_iabd_crrspnd_doc_num_code ON cmia_g_intl_app_doc(iabd_crrspnd_doc_num);
CREATE INDEX IF NOT EXISTS idx_cmia_g_intl_app_doc_iabd_dsptch_doc_num_code ON cmia_g_intl_app_doc(iabd_dsptch_doc_num);
CREATE INDEX IF NOT EXISTS idx_cmia_g_intl_app_doc_iabd_doc_typ_cd_code ON cmia_g_intl_app_doc(iabd_doc_typ_cd);
CREATE INDEX IF NOT EXISTS idx_cmia_g_intl_app_doc_iabd_ver_num_code ON cmia_g_intl_app_doc(iabd_ver_num);
CREATE INDEX IF NOT EXISTS idx_cmia_g_intl_app_doc_iabd_invalid_doc_flg_code ON cmia_g_intl_app_doc(iabd_invalid_doc_flg);
CREATE INDEX IF NOT EXISTS idx_cmia_g_intl_app_doc_iabd_doc_frmt_typ_code ON cmia_g_intl_app_doc(iabd_doc_frmt_typ);
CREATE INDEX IF NOT EXISTS idx_cmia_g_intl_app_doc_iabj_delete_flg_code ON cmia_g_intl_app_doc(iabj_delete_flg);
CREATE INDEX IF NOT EXISTS idx_cmia_g_intl_app_doc_iabj_valid_flg_code ON cmia_g_intl_app_doc(iabj_valid_flg);
CREATE INDEX IF NOT EXISTS idx_cmia_g_intl_app_doc_iabj_intrmd_doc_cd_code ON cmia_g_intl_app_doc(iabj_intrmd_doc_cd);
CREATE INDEX IF NOT EXISTS idx_cmia_g_intl_app_doc_iabj_crrspnd_doc_num_code ON cmia_g_intl_app_doc(iabj_crrspnd_doc_num);
CREATE INDEX IF NOT EXISTS idx_cmia_g_intl_app_doc_iabj_jpo_doc_num_code ON cmia_g_intl_app_doc(iabj_jpo_doc_num);
CREATE INDEX IF NOT EXISTS idx_cmia_g_intl_app_doc_iabj_doc_typ_cd_code ON cmia_g_intl_app_doc(iabj_doc_typ_cd);

-- 国際出願の事件ステータスファイル (出願マスタ（特実）)
CREATE TABLE IF NOT EXISTS cmis_g_intl_app_case_stat (
    intl_app_num TEXT,
    is_delete_flg TEXT,
    is_update_dttm TEXT,
    isic_delete_flg TEXT,
    isic_isr_uncreated_flg TEXT,
    isic_inspect_prhbt_flg TEXT,
    isic_dmy_flg TEXT,
    isic_prlmnry_exam_mk TEXT
);

CREATE INDEX IF NOT EXISTS idx_cmis_g_intl_app_case_stat_intl_app_num ON cmis_g_intl_app_case_stat(intl_app_num);
CREATE INDEX IF NOT EXISTS idx_cmis_g_intl_app_case_stat_intl_app_num_code ON cmis_g_intl_app_case_stat(intl_app_num);
CREATE INDEX IF NOT EXISTS idx_cmis_g_intl_app_case_stat_is_delete_flg_code ON cmis_g_intl_app_case_stat(is_delete_flg);
CREATE INDEX IF NOT EXISTS idx_cmis_g_intl_app_case_stat_isic_delete_flg_code ON cmis_g_intl_app_case_stat(isic_delete_flg);
CREATE INDEX IF NOT EXISTS idx_cmis_g_intl_app_case_stat_isic_isr_uncreated_flg_code ON cmis_g_intl_app_case_stat(isic_isr_uncreated_flg);
CREATE INDEX IF NOT EXISTS idx_cmis_g_intl_app_case_stat_isic_inspect_prhbt_flg_code ON cmis_g_intl_app_case_stat(isic_inspect_prhbt_flg);
CREATE INDEX IF NOT EXISTS idx_cmis_g_intl_app_case_stat_isic_dmy_flg_code ON cmis_g_intl_app_case_stat(isic_dmy_flg);
CREATE INDEX IF NOT EXISTS idx_cmis_g_intl_app_case_stat_isic_prlmnry_exam_mk_code ON cmis_g_intl_app_case_stat(isic_prlmnry_exam_mk);

-- 合議官ファイル (審判マスタ)
CREATE TABLE IF NOT EXISTS consultation_authorities (
    processing_type VARCHAR(1),
    appl_num VARCHAR(10),
    history_num SMALLINT,
    sequence_num SMALLINT,
    consultation_authorities_cd VARCHAR(4),
    updt_dttm VARCHAR(12)
);

CREATE INDEX IF NOT EXISTS idx_consultation_authorities_appl_num ON consultation_authorities(appl_num);
CREATE INDEX IF NOT EXISTS idx_consultation_authorities_history_num ON consultation_authorities(history_num);
CREATE INDEX IF NOT EXISTS idx_consultation_authorities_sequence_num ON consultation_authorities(sequence_num);

-- 意匠参考文献情報ファイル (出願資料検索マスタ)
CREATE TABLE IF NOT EXISTS d_citd_others_info_table (
    app_num TEXT,
    repeat_num INTEGER,
    citd_others TEXT
);

CREATE INDEX IF NOT EXISTS idx_d_citd_others_info_table_app_num ON d_citd_others_info_table(app_num);
CREATE INDEX IF NOT EXISTS idx_d_citd_others_info_table_repeat_num ON d_citd_others_info_table(repeat_num);

-- 補正却下の決定ファイル (審判マスタ)
CREATE TABLE IF NOT EXISTS dcln_amnd_dcsn (
    processing_type VARCHAR(1),
    appl_num VARCHAR(10),
    dcln_amnd_dcsn_num VARCHAR(2),
    amnd_doc_submit_dt VARCHAR(8),
    dcln_amnd_define_dt VARCHAR(8),
    final_dspst_cd VARCHAR(1),
    updt_dttm VARCHAR(12)
);

CREATE INDEX IF NOT EXISTS idx_dcln_amnd_dcsn_appl_num ON dcln_amnd_dcsn(appl_num);
CREATE INDEX IF NOT EXISTS idx_dcln_amnd_dcsn_dcln_amnd_dcsn_num ON dcln_amnd_dcsn(dcln_amnd_dcsn_num);

-- 補正却下の決定分類コードファイル (審判マスタ)
CREATE TABLE IF NOT EXISTS dcln_amnd_dcsn_class_cd (
    processing_type VARCHAR(1),
    appl_num VARCHAR(10),
    dcsn_num VARCHAR(2),
    sequence_num SMALLINT,
    law_cd_class VARCHAR(1),
    apply_law_id VARCHAR(1),
    instance_typ VARCHAR(1),
    appl_typ VARCHAR(3),
    jdgmnt_item_cd VARCHAR(3),
    conclusion_cd VARCHAR(3),
    complement_sub_class_id VARCHAR(13),
    litigation_id VARCHAR(1),
    updt_dttm VARCHAR(12)
);

CREATE INDEX IF NOT EXISTS idx_dcln_amnd_dcsn_class_cd_appl_num ON dcln_amnd_dcsn_class_cd(appl_num);
CREATE INDEX IF NOT EXISTS idx_dcln_amnd_dcsn_class_cd_dcsn_num ON dcln_amnd_dcsn_class_cd(dcsn_num);
CREATE INDEX IF NOT EXISTS idx_dcln_amnd_dcsn_class_cd_sequence_num ON dcln_amnd_dcsn_class_cd(sequence_num);

-- 菌寄託ファイル (審判マスタ)
CREATE TABLE IF NOT EXISTS deposit (
    processing_type VARCHAR(1),
    appl_num VARCHAR(10),
    sequence_num SMALLINT,
    depository_instt_cd VARCHAR(15),
    depository_num VARCHAR(100),
    updt_dttm VARCHAR(12)
);

CREATE INDEX IF NOT EXISTS idx_deposit_appl_num ON deposit(appl_num);
CREATE INDEX IF NOT EXISTS idx_deposit_sequence_num ON deposit(sequence_num);

-- 指定代理人ファイル (審判マスタ)
CREATE TABLE IF NOT EXISTS desig_atty (
    processing_type VARCHAR(1),
    litigate_case_num_year_issu VARCHAR(2),
    litigate_case_num_year VARCHAR(2),
    litigate_case_num_num VARCHAR(5),
    litigate_class VARCHAR(1),
    desig_atty_cd VARCHAR(4),
    history_num VARCHAR(2),
    desig_dt VARCHAR(8),
    cheaf_mk VARCHAR(1),
    dismissal_dt VARCHAR(8),
    dismissal_stts VARCHAR(1),
    updt_dttm VARCHAR(12)
);

CREATE INDEX IF NOT EXISTS idx_desig_atty_litigate_case_num_year_issu ON desig_atty(litigate_case_num_year_issu);
CREATE INDEX IF NOT EXISTS idx_desig_atty_litigate_case_num_year ON desig_atty(litigate_case_num_year);
CREATE INDEX IF NOT EXISTS idx_desig_atty_litigate_case_num_num ON desig_atty(litigate_case_num_num);
CREATE INDEX IF NOT EXISTS idx_desig_atty_litigate_class ON desig_atty(litigate_class);
CREATE INDEX IF NOT EXISTS idx_desig_atty_desig_atty_cd ON desig_atty(desig_atty_cd);
CREATE INDEX IF NOT EXISTS idx_desig_atty_history_num ON desig_atty(history_num);

-- 指定国官庁マスタ_マークファイル (マドプロ出願/原簿マスタ)
CREATE TABLE IF NOT EXISTS design_state_gvrnmnt_mstr_mk (
    add_del_id TEXT,
    jpo_rfr_num TEXT,
    jpo_rfr_num_split_sign_cd TEXT,
    history_num TEXT,
    standard_char_declarat_flg TEXT,
    color_clim_detail TEXT,
    color_clim_detail_japanese TEXT,
    emblem_transliterat_detail TEXT,
    three_dmns_emblem_flg TEXT,
    sound_t_flg TEXT,
    group_cert_warranty_flg TEXT,
    emblem_doc_detail TEXT,
    emblem_doc_detail_japanese TEXT,
    vienna_class TEXT,
    exam_art_03_prgrph_02_flg TEXT,
    exam_color_proviso_apply_flg TEXT,
    exam_art_09_prgrph_01_flg TEXT,
    acclrtd_exam_class TEXT,
    define_flg TEXT,
    updt_year_month_day TEXT,
    batch_updt_year_month_day TEXT,
    special_t_typ TEXT,
    t_dtl_explntn TEXT,
    t_dtl_explntn_japanese TEXT,
    dtl_explntn_doc_submt_dt TEXT,
    color_chk_box TEXT,
    disclaimer TEXT,
    opt_emblem_doc_detail TEXT,
    opt_emblem_doc_detail_jp TEXT
);

CREATE INDEX IF NOT EXISTS idx_design_state_gvrnmnt_mstr_mk_jpo_rfr_num ON design_state_gvrnmnt_mstr_mk(jpo_rfr_num);
CREATE INDEX IF NOT EXISTS idx_design_state_gvrnmnt_mstr_mk_jpo_rfr_num_split_sign_cd ON design_state_gvrnmnt_mstr_mk(jpo_rfr_num_split_sign_cd);
CREATE INDEX IF NOT EXISTS idx_design_state_gvrnmnt_mstr_mk_history_num ON design_state_gvrnmnt_mstr_mk(history_num);
CREATE INDEX IF NOT EXISTS idx_design_state_gvrnmnt_mstr_mk_define_flg ON design_state_gvrnmnt_mstr_mk(define_flg);
CREATE INDEX IF NOT EXISTS idx_design_state_gvrnmnt_mstr_mk_add_del_id_code ON design_state_gvrnmnt_mstr_mk(add_del_id);
CREATE INDEX IF NOT EXISTS idx_design_state_gvrnmnt_mstr_mk_jpo_rfr_num_code ON design_state_gvrnmnt_mstr_mk(jpo_rfr_num);
CREATE INDEX IF NOT EXISTS idx_design_state_gvrnmnt_mstr_mk_jpo_rfr_num_split_sign_cd_code ON design_state_gvrnmnt_mstr_mk(jpo_rfr_num_split_sign_cd);
CREATE INDEX IF NOT EXISTS idx_design_state_gvrnmnt_mstr_mk_history_num_code ON design_state_gvrnmnt_mstr_mk(history_num);
CREATE INDEX IF NOT EXISTS idx_design_state_gvrnmnt_mstr_mk_standard_char_declarat_flg_code ON design_state_gvrnmnt_mstr_mk(standard_char_declarat_flg);
CREATE INDEX IF NOT EXISTS idx_design_state_gvrnmnt_mstr_mk_three_dmns_emblem_flg_code ON design_state_gvrnmnt_mstr_mk(three_dmns_emblem_flg);
CREATE INDEX IF NOT EXISTS idx_design_state_gvrnmnt_mstr_mk_sound_t_flg_code ON design_state_gvrnmnt_mstr_mk(sound_t_flg);
CREATE INDEX IF NOT EXISTS idx_design_state_gvrnmnt_mstr_mk_group_cert_warranty_flg_code ON design_state_gvrnmnt_mstr_mk(group_cert_warranty_flg);
CREATE INDEX IF NOT EXISTS idx_design_state_gvrnmnt_mstr_mk_vienna_class_code ON design_state_gvrnmnt_mstr_mk(vienna_class);
CREATE INDEX IF NOT EXISTS idx_design_state_gvrnmnt_mstr_mk_exam_art_03_prgrph_02_flg_code ON design_state_gvrnmnt_mstr_mk(exam_art_03_prgrph_02_flg);
CREATE INDEX IF NOT EXISTS idx_design_state_gvrnmnt_mstr_mk_exam_color_proviso_apply_flg_code ON design_state_gvrnmnt_mstr_mk(exam_color_proviso_apply_flg);
CREATE INDEX IF NOT EXISTS idx_design_state_gvrnmnt_mstr_mk_exam_art_09_prgrph_01_flg_code ON design_state_gvrnmnt_mstr_mk(exam_art_09_prgrph_01_flg);
CREATE INDEX IF NOT EXISTS idx_design_state_gvrnmnt_mstr_mk_acclrtd_exam_class_code ON design_state_gvrnmnt_mstr_mk(acclrtd_exam_class);
CREATE INDEX IF NOT EXISTS idx_design_state_gvrnmnt_mstr_mk_define_flg_code ON design_state_gvrnmnt_mstr_mk(define_flg);
CREATE INDEX IF NOT EXISTS idx_design_state_gvrnmnt_mstr_mk_special_t_typ_code ON design_state_gvrnmnt_mstr_mk(special_t_typ);
CREATE INDEX IF NOT EXISTS idx_design_state_gvrnmnt_mstr_mk_color_chk_box_code ON design_state_gvrnmnt_mstr_mk(color_chk_box);

-- 指定国官庁マスタ_優先権ファイル (マドプロ出願/原簿マスタ)
CREATE TABLE IF NOT EXISTS design_state_gvrnmnt_mstr_pri (
    add_del_id TEXT,
    jpo_rfr_num TEXT,
    jpo_rfr_num_split_sign_cd TEXT,
    history_num TEXT,
    pri_clim_id INTEGER,
    pri_finding_flg TEXT,
    pri_app_gvrn_cntrcntry_cd TEXT,
    pri_app_num TEXT,
    pri_app_year_month_day TEXT,
    define_flg TEXT,
    updt_year_month_day TEXT,
    batch_updt_year_month_day TEXT
);

CREATE INDEX IF NOT EXISTS idx_design_state_gvrnmnt_mstr_pri_jpo_rfr_num ON design_state_gvrnmnt_mstr_pri(jpo_rfr_num);
CREATE INDEX IF NOT EXISTS idx_design_state_gvrnmnt_mstr_pri_jpo_rfr_num_split_sign_cd ON design_state_gvrnmnt_mstr_pri(jpo_rfr_num_split_sign_cd);
CREATE INDEX IF NOT EXISTS idx_design_state_gvrnmnt_mstr_pri_history_num ON design_state_gvrnmnt_mstr_pri(history_num);
CREATE INDEX IF NOT EXISTS idx_design_state_gvrnmnt_mstr_pri_pri_clim_id ON design_state_gvrnmnt_mstr_pri(pri_clim_id);
CREATE INDEX IF NOT EXISTS idx_design_state_gvrnmnt_mstr_pri_define_flg ON design_state_gvrnmnt_mstr_pri(define_flg);
CREATE INDEX IF NOT EXISTS idx_design_state_gvrnmnt_mstr_pri_add_del_id_code ON design_state_gvrnmnt_mstr_pri(add_del_id);
CREATE INDEX IF NOT EXISTS idx_design_state_gvrnmnt_mstr_pri_jpo_rfr_num_code ON design_state_gvrnmnt_mstr_pri(jpo_rfr_num);
CREATE INDEX IF NOT EXISTS idx_design_state_gvrnmnt_mstr_pri_jpo_rfr_num_split_sign_cd_code ON design_state_gvrnmnt_mstr_pri(jpo_rfr_num_split_sign_cd);
CREATE INDEX IF NOT EXISTS idx_design_state_gvrnmnt_mstr_pri_history_num_code ON design_state_gvrnmnt_mstr_pri(history_num);
CREATE INDEX IF NOT EXISTS idx_design_state_gvrnmnt_mstr_pri_pri_clim_id_code ON design_state_gvrnmnt_mstr_pri(pri_clim_id);
CREATE INDEX IF NOT EXISTS idx_design_state_gvrnmnt_mstr_pri_pri_finding_flg_code ON design_state_gvrnmnt_mstr_pri(pri_finding_flg);
CREATE INDEX IF NOT EXISTS idx_design_state_gvrnmnt_mstr_pri_pri_app_gvrn_cntrcntry_cd_code ON design_state_gvrnmnt_mstr_pri(pri_app_gvrn_cntrcntry_cd);
CREATE INDEX IF NOT EXISTS idx_design_state_gvrnmnt_mstr_pri_pri_app_num_code ON design_state_gvrnmnt_mstr_pri(pri_app_num);
CREATE INDEX IF NOT EXISTS idx_design_state_gvrnmnt_mstr_pri_define_flg_code ON design_state_gvrnmnt_mstr_pri(define_flg);

-- 指定国官庁マスタ_審判情報ファイル (マドプロ出願/原簿マスタ)
CREATE TABLE IF NOT EXISTS dsgn_gvrnmnt_appl_info (
    add_del_id TEXT,
    jpo_rfr_num TEXT,
    jpo_rfr_num_split_sign_cd TEXT,
    appl_info_id INTEGER,
    appl_typ TEXT,
    appl_num TEXT,
    appl_clim_year_month_day TEXT,
    appl_final_dspst TEXT,
    trial_dcsn_year_month_day TEXT,
    trial_dcsn_define_ymd TEXT,
    define_flg TEXT,
    updt_year_month_day TEXT,
    batch_updt_year_month_day TEXT
);

CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_appl_info_jpo_rfr_num ON dsgn_gvrnmnt_appl_info(jpo_rfr_num);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_appl_info_jpo_rfr_num_split_sign_cd ON dsgn_gvrnmnt_appl_info(jpo_rfr_num_split_sign_cd);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_appl_info_appl_info_id ON dsgn_gvrnmnt_appl_info(appl_info_id);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_appl_info_define_flg ON dsgn_gvrnmnt_appl_info(define_flg);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_appl_info_add_del_id_code ON dsgn_gvrnmnt_appl_info(add_del_id);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_appl_info_jpo_rfr_num_code ON dsgn_gvrnmnt_appl_info(jpo_rfr_num);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_appl_info_jpo_rfr_num_split_sign_cd_code ON dsgn_gvrnmnt_appl_info(jpo_rfr_num_split_sign_cd);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_appl_info_appl_typ_code ON dsgn_gvrnmnt_appl_info(appl_typ);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_appl_info_appl_num_code ON dsgn_gvrnmnt_appl_info(appl_num);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_appl_info_appl_final_dspst_code ON dsgn_gvrnmnt_appl_info(appl_final_dspst);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_appl_info_define_flg_code ON dsgn_gvrnmnt_appl_info(define_flg);

-- 指定国官庁マスタ_公報情報ファイル (マドプロ出願/原簿マスタ)
CREATE TABLE IF NOT EXISTS dsgn_gvrnmnt_bul_info (
    add_del_id TEXT,
    jpo_rfr_num TEXT,
    jpo_rfr_num_split_sign_cd TEXT,
    bul_info_id INTEGER,
    bul_pub_year_month_day TEXT,
    year_vol_num TEXT,
    total_vol_num TEXT,
    define_flg TEXT,
    updt_year_month_day TEXT,
    batch_updt_year_month_day TEXT
);

CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_bul_info_jpo_rfr_num ON dsgn_gvrnmnt_bul_info(jpo_rfr_num);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_bul_info_jpo_rfr_num_split_sign_cd ON dsgn_gvrnmnt_bul_info(jpo_rfr_num_split_sign_cd);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_bul_info_bul_info_id ON dsgn_gvrnmnt_bul_info(bul_info_id);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_bul_info_define_flg ON dsgn_gvrnmnt_bul_info(define_flg);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_bul_info_add_del_id_code ON dsgn_gvrnmnt_bul_info(add_del_id);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_bul_info_jpo_rfr_num_code ON dsgn_gvrnmnt_bul_info(jpo_rfr_num);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_bul_info_jpo_rfr_num_split_sign_cd_code ON dsgn_gvrnmnt_bul_info(jpo_rfr_num_split_sign_cd);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_bul_info_bul_info_id_code ON dsgn_gvrnmnt_bul_info(bul_info_id);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_bul_info_define_flg_code ON dsgn_gvrnmnt_bul_info(define_flg);

-- 指定国官庁マスタ_指定国商品・サービスファイル（出願） (マドプロ出願マスタ)
CREATE TABLE IF NOT EXISTS dsgn_gvrnmnt_dsgn_st_gds_srvc_app (
    add_del_id TEXT,
    jpo_rfr_num TEXT,
    jpo_rfr_num_split_sign_cd TEXT,
    history_num TEXT,
    seq_num INTEGER,
    madopro_class TEXT,
    goods_service_name TEXT,
    goods_service_japanese_name TEXT,
    force_occur_dt TEXT,
    define_flg TEXT,
    updt_year_month_day TEXT,
    batch_updt_year_month_day TEXT
);

CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_dsgn_st_gds_srvc_app_jpo_rfr_num ON dsgn_gvrnmnt_dsgn_st_gds_srvc_app(jpo_rfr_num);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_dsgn_st_gds_srvc_app_jpo_rfr_num_split_sign_cd ON dsgn_gvrnmnt_dsgn_st_gds_srvc_app(jpo_rfr_num_split_sign_cd);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_dsgn_st_gds_srvc_app_history_num ON dsgn_gvrnmnt_dsgn_st_gds_srvc_app(history_num);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_dsgn_st_gds_srvc_app_seq_num ON dsgn_gvrnmnt_dsgn_st_gds_srvc_app(seq_num);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_dsgn_st_gds_srvc_app_define_flg ON dsgn_gvrnmnt_dsgn_st_gds_srvc_app(define_flg);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_dsgn_st_gds_srvc_app_add_del_id_code ON dsgn_gvrnmnt_dsgn_st_gds_srvc_app(add_del_id);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_dsgn_st_gds_srvc_app_jpo_rfr_num_code ON dsgn_gvrnmnt_dsgn_st_gds_srvc_app(jpo_rfr_num);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_dsgn_st_gds_srvc_app_jpo_rfr_num_split_sign_cd_code ON dsgn_gvrnmnt_dsgn_st_gds_srvc_app(jpo_rfr_num_split_sign_cd);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_dsgn_st_gds_srvc_app_history_num_code ON dsgn_gvrnmnt_dsgn_st_gds_srvc_app(history_num);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_dsgn_st_gds_srvc_app_seq_num_code ON dsgn_gvrnmnt_dsgn_st_gds_srvc_app(seq_num);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_dsgn_st_gds_srvc_app_define_flg_code ON dsgn_gvrnmnt_dsgn_st_gds_srvc_app(define_flg);

-- 指定国官庁マスタ_指定国商品・サービスファイル（原簿） (マドプロ原簿マスタ)
CREATE TABLE IF NOT EXISTS dsgn_gvrnmnt_dsgn_st_gds_srvc_reg (
    add_del_id TEXT,
    jpo_rfr_num TEXT,
    jpo_rfr_num_split_sign_cd TEXT,
    history_num TEXT,
    seq_num INTEGER,
    madopro_class TEXT,
    goods_service_name TEXT,
    define_flg TEXT,
    updt_year_month_day TEXT,
    batch_updt_year_month_day TEXT
);

CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_dsgn_st_gds_srvc_reg_jpo_rfr_num ON dsgn_gvrnmnt_dsgn_st_gds_srvc_reg(jpo_rfr_num);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_dsgn_st_gds_srvc_reg_jpo_rfr_num_split_sign_cd ON dsgn_gvrnmnt_dsgn_st_gds_srvc_reg(jpo_rfr_num_split_sign_cd);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_dsgn_st_gds_srvc_reg_history_num ON dsgn_gvrnmnt_dsgn_st_gds_srvc_reg(history_num);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_dsgn_st_gds_srvc_reg_seq_num ON dsgn_gvrnmnt_dsgn_st_gds_srvc_reg(seq_num);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_dsgn_st_gds_srvc_reg_define_flg ON dsgn_gvrnmnt_dsgn_st_gds_srvc_reg(define_flg);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_dsgn_st_gds_srvc_reg_add_del_id_code ON dsgn_gvrnmnt_dsgn_st_gds_srvc_reg(add_del_id);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_dsgn_st_gds_srvc_reg_jpo_rfr_num_code ON dsgn_gvrnmnt_dsgn_st_gds_srvc_reg(jpo_rfr_num);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_dsgn_st_gds_srvc_reg_jpo_rfr_num_split_sign_cd_code ON dsgn_gvrnmnt_dsgn_st_gds_srvc_reg(jpo_rfr_num_split_sign_cd);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_dsgn_st_gds_srvc_reg_history_num_code ON dsgn_gvrnmnt_dsgn_st_gds_srvc_reg(history_num);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_dsgn_st_gds_srvc_reg_seq_num_code ON dsgn_gvrnmnt_dsgn_st_gds_srvc_reg(seq_num);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_dsgn_st_gds_srvc_reg_madopro_class_code ON dsgn_gvrnmnt_dsgn_st_gds_srvc_reg(madopro_class);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_dsgn_st_gds_srvc_reg_define_flg_code ON dsgn_gvrnmnt_dsgn_st_gds_srvc_reg(define_flg);

-- 指定国官庁マスタ_基礎番号ファイル (マドプロ出願/原簿マスタ)
CREATE TABLE IF NOT EXISTS dsgn_gvrnmnt_fundamental_num (
    add_del_id TEXT,
    jpo_rfr_num TEXT,
    jpo_rfr_num_split_sign_cd TEXT,
    history_num TEXT,
    fundamental_num_id INTEGER,
    fundamental_app_num TEXT,
    fundamental_app_year_month_day TEXT,
    fundamental_reg_num TEXT,
    fundamental_reg_year_month_day TEXT,
    define_flg TEXT,
    updt_year_month_day TEXT,
    batch_updt_year_month_day TEXT
);

CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_fundamental_num_jpo_rfr_num ON dsgn_gvrnmnt_fundamental_num(jpo_rfr_num);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_fundamental_num_jpo_rfr_num_split_sign_cd ON dsgn_gvrnmnt_fundamental_num(jpo_rfr_num_split_sign_cd);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_fundamental_num_history_num ON dsgn_gvrnmnt_fundamental_num(history_num);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_fundamental_num_fundamental_num_id ON dsgn_gvrnmnt_fundamental_num(fundamental_num_id);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_fundamental_num_define_flg ON dsgn_gvrnmnt_fundamental_num(define_flg);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_fundamental_num_add_del_id_code ON dsgn_gvrnmnt_fundamental_num(add_del_id);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_fundamental_num_jpo_rfr_num_code ON dsgn_gvrnmnt_fundamental_num(jpo_rfr_num);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_fundamental_num_jpo_rfr_num_split_sign_cd_code ON dsgn_gvrnmnt_fundamental_num(jpo_rfr_num_split_sign_cd);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_fundamental_num_history_num_code ON dsgn_gvrnmnt_fundamental_num(history_num);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_fundamental_num_fundamental_num_id_code ON dsgn_gvrnmnt_fundamental_num(fundamental_num_id);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_fundamental_num_fundamental_app_num_code ON dsgn_gvrnmnt_fundamental_num(fundamental_app_num);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_fundamental_num_fundamental_reg_num_code ON dsgn_gvrnmnt_fundamental_num(fundamental_reg_num);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_fundamental_num_define_flg_code ON dsgn_gvrnmnt_fundamental_num(define_flg);

-- 指定国官庁マスタ_国内代理人ファイル (マドプロ出願/原簿マスタ)
CREATE TABLE IF NOT EXISTS dsgn_gvrnmnt_intnl_atty (
    add_del_id TEXT,
    jpo_rfr_num TEXT,
    jpo_rfr_num_split_sign_cd TEXT,
    history_num TEXT,
    intnl_atty_seq_id INTEGER,
    atty_typ_flg TEXT,
    atty_qualify_flg TEXT,
    appl_id TEXT,
    intnl_atty_title TEXT,
    intnl_atty_addr TEXT,
    define_flg TEXT,
    updt_year_month_day TEXT,
    batch_updt_year_month_day TEXT
);

CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_intnl_atty_jpo_rfr_num ON dsgn_gvrnmnt_intnl_atty(jpo_rfr_num);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_intnl_atty_jpo_rfr_num_split_sign_cd ON dsgn_gvrnmnt_intnl_atty(jpo_rfr_num_split_sign_cd);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_intnl_atty_history_num ON dsgn_gvrnmnt_intnl_atty(history_num);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_intnl_atty_intnl_atty_seq_id ON dsgn_gvrnmnt_intnl_atty(intnl_atty_seq_id);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_intnl_atty_define_flg ON dsgn_gvrnmnt_intnl_atty(define_flg);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_intnl_atty_add_del_id_code ON dsgn_gvrnmnt_intnl_atty(add_del_id);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_intnl_atty_jpo_rfr_num_code ON dsgn_gvrnmnt_intnl_atty(jpo_rfr_num);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_intnl_atty_jpo_rfr_num_split_sign_cd_code ON dsgn_gvrnmnt_intnl_atty(jpo_rfr_num_split_sign_cd);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_intnl_atty_history_num_code ON dsgn_gvrnmnt_intnl_atty(history_num);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_intnl_atty_intnl_atty_seq_id_code ON dsgn_gvrnmnt_intnl_atty(intnl_atty_seq_id);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_intnl_atty_atty_typ_flg_code ON dsgn_gvrnmnt_intnl_atty(atty_typ_flg);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_intnl_atty_atty_qualify_flg_code ON dsgn_gvrnmnt_intnl_atty(atty_qualify_flg);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_intnl_atty_appl_id_code ON dsgn_gvrnmnt_intnl_atty(appl_id);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_intnl_atty_define_flg_code ON dsgn_gvrnmnt_intnl_atty(define_flg);

-- 指定国官庁マスタ_中間記録ファイル (マドプロ出願/原簿マスタ)
CREATE TABLE IF NOT EXISTS dsgn_gvrnmnt_intrmd_rec (
    add_del_id TEXT,
    jpo_rfr_num TEXT,
    jpo_rfr_num_split_sign_cd TEXT,
    history_num TEXT,
    intrmd_cd TEXT,
    intrmd_dfn_1_dt TEXT,
    intrmd_dfn_2_dt TEXT,
    intrmd_dfn_3_dt TEXT,
    intrmd_dfn_4_dt TEXT,
    art_cd TEXT,
    examiner_cd TEXT,
    define_flg TEXT,
    updt_year_month_day TEXT,
    batch_updt_year_month_day TEXT
);

CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_intrmd_rec_jpo_rfr_num ON dsgn_gvrnmnt_intrmd_rec(jpo_rfr_num);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_intrmd_rec_jpo_rfr_num_split_sign_cd ON dsgn_gvrnmnt_intrmd_rec(jpo_rfr_num_split_sign_cd);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_intrmd_rec_history_num ON dsgn_gvrnmnt_intrmd_rec(history_num);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_intrmd_rec_define_flg ON dsgn_gvrnmnt_intrmd_rec(define_flg);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_intrmd_rec_add_del_id_code ON dsgn_gvrnmnt_intrmd_rec(add_del_id);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_intrmd_rec_jpo_rfr_num_code ON dsgn_gvrnmnt_intrmd_rec(jpo_rfr_num);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_intrmd_rec_jpo_rfr_num_split_sign_cd_code ON dsgn_gvrnmnt_intrmd_rec(jpo_rfr_num_split_sign_cd);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_intrmd_rec_history_num_code ON dsgn_gvrnmnt_intrmd_rec(history_num);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_intrmd_rec_intrmd_cd_code ON dsgn_gvrnmnt_intrmd_rec(intrmd_cd);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_intrmd_rec_art_cd_code ON dsgn_gvrnmnt_intrmd_rec(art_cd);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_intrmd_rec_examiner_cd_code ON dsgn_gvrnmnt_intrmd_rec(examiner_cd);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_intrmd_rec_define_flg_code ON dsgn_gvrnmnt_intrmd_rec(define_flg);

-- 指定国官庁マスタ_最新商品・サービスファイル (マドプロ出願/原簿マスタ)
CREATE TABLE IF NOT EXISTS dsgn_gvrnmnt_latest_gds_srvc (
    add_del_id TEXT,
    jpo_rfr_num TEXT,
    jpo_rfr_num_split_sign_cd TEXT,
    madopro_class TEXT,
    goods_service_name TEXT,
    force_occur_dt TEXT,
    define_flg TEXT,
    updt_year_month_day TEXT,
    batch_updt_year_month_day TEXT
);

CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_latest_gds_srvc_jpo_rfr_num ON dsgn_gvrnmnt_latest_gds_srvc(jpo_rfr_num);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_latest_gds_srvc_jpo_rfr_num_split_sign_cd ON dsgn_gvrnmnt_latest_gds_srvc(jpo_rfr_num_split_sign_cd);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_latest_gds_srvc_madopro_class ON dsgn_gvrnmnt_latest_gds_srvc(madopro_class);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_latest_gds_srvc_define_flg ON dsgn_gvrnmnt_latest_gds_srvc(define_flg);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_latest_gds_srvc_add_del_id_code ON dsgn_gvrnmnt_latest_gds_srvc(add_del_id);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_latest_gds_srvc_jpo_rfr_num_code ON dsgn_gvrnmnt_latest_gds_srvc(jpo_rfr_num);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_latest_gds_srvc_jpo_rfr_num_split_sign_cd_code ON dsgn_gvrnmnt_latest_gds_srvc(jpo_rfr_num_split_sign_cd);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_latest_gds_srvc_madopro_class_code ON dsgn_gvrnmnt_latest_gds_srvc(madopro_class);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_latest_gds_srvc_define_flg_code ON dsgn_gvrnmnt_latest_gds_srvc(define_flg);

-- 指定国官庁マスタ_主管理ファイル（出願） (マドプロ出願マスタ)
CREATE TABLE IF NOT EXISTS dsgn_gvrnmnt_main_mgt_app (
    add_del_id TEXT,
    jpo_rfr_num TEXT,
    jpo_rfr_num_split_sign_cd TEXT,
    intl_reg_num_updt_cnt_sign_cd TEXT,
    intl_reg_num TEXT,
    intl_num_split_sign_cd TEXT,
    formal_ntc_year_month_day TEXT,
    intl_reg_year_month_day TEXT,
    aft_desig_year_month_day TEXT,
    exam_final_dspst_cd TEXT,
    exam_final_dspst_ymd TEXT,
    reg_final_dspst_cd TEXT,
    reg_final_dspst_year_month_day TEXT,
    home_cntry_gvrnmnt_cd TEXT,
    chan_dstnt_app_num TEXT,
    design_state_cd TEXT,
    examiner_cd TEXT,
    define_flg TEXT,
    updt_year_month_day TEXT,
    batch_updt_year_month_day TEXT
);

CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_main_mgt_app_jpo_rfr_num ON dsgn_gvrnmnt_main_mgt_app(jpo_rfr_num);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_main_mgt_app_jpo_rfr_num_split_sign_cd ON dsgn_gvrnmnt_main_mgt_app(jpo_rfr_num_split_sign_cd);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_main_mgt_app_define_flg ON dsgn_gvrnmnt_main_mgt_app(define_flg);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_main_mgt_app_add_del_id_code ON dsgn_gvrnmnt_main_mgt_app(add_del_id);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_main_mgt_app_jpo_rfr_num_code ON dsgn_gvrnmnt_main_mgt_app(jpo_rfr_num);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_main_mgt_app_jpo_rfr_num_split_sign_cd_code ON dsgn_gvrnmnt_main_mgt_app(jpo_rfr_num_split_sign_cd);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_main_mgt_app_intl_reg_num_updt_cnt_sign_cd_code ON dsgn_gvrnmnt_main_mgt_app(intl_reg_num_updt_cnt_sign_cd);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_main_mgt_app_intl_reg_num_code ON dsgn_gvrnmnt_main_mgt_app(intl_reg_num);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_main_mgt_app_intl_num_split_sign_cd_code ON dsgn_gvrnmnt_main_mgt_app(intl_num_split_sign_cd);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_main_mgt_app_exam_final_dspst_cd_code ON dsgn_gvrnmnt_main_mgt_app(exam_final_dspst_cd);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_main_mgt_app_reg_final_dspst_cd_code ON dsgn_gvrnmnt_main_mgt_app(reg_final_dspst_cd);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_main_mgt_app_home_cntry_gvrnmnt_cd_code ON dsgn_gvrnmnt_main_mgt_app(home_cntry_gvrnmnt_cd);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_main_mgt_app_chan_dstnt_app_num_code ON dsgn_gvrnmnt_main_mgt_app(chan_dstnt_app_num);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_main_mgt_app_design_state_cd_code ON dsgn_gvrnmnt_main_mgt_app(design_state_cd);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_main_mgt_app_examiner_cd_code ON dsgn_gvrnmnt_main_mgt_app(examiner_cd);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_main_mgt_app_define_flg_code ON dsgn_gvrnmnt_main_mgt_app(define_flg);

-- 指定国官庁マスタ_主管理ファイル（原簿） (マドプロ原簿マスタ)
CREATE TABLE IF NOT EXISTS dsgn_gvrnmnt_main_mgt_reg (
    add_del_id TEXT,
    jpo_rfr_num TEXT,
    jpo_rfr_num_split_sign_cd TEXT,
    intl_reg_year_month_day TEXT,
    exam_final_dspst_ymd TEXT,
    reg_final_dspst_cd TEXT,
    reg_final_dspst_year_month_day TEXT,
    define_flg TEXT,
    updt_year_month_day TEXT,
    batch_updt_year_month_day TEXT
);

CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_main_mgt_reg_jpo_rfr_num ON dsgn_gvrnmnt_main_mgt_reg(jpo_rfr_num);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_main_mgt_reg_jpo_rfr_num_split_sign_cd ON dsgn_gvrnmnt_main_mgt_reg(jpo_rfr_num_split_sign_cd);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_main_mgt_reg_define_flg ON dsgn_gvrnmnt_main_mgt_reg(define_flg);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_main_mgt_reg_add_del_id_code ON dsgn_gvrnmnt_main_mgt_reg(add_del_id);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_main_mgt_reg_jpo_rfr_num_code ON dsgn_gvrnmnt_main_mgt_reg(jpo_rfr_num);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_main_mgt_reg_jpo_rfr_num_split_sign_cd_code ON dsgn_gvrnmnt_main_mgt_reg(jpo_rfr_num_split_sign_cd);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_main_mgt_reg_reg_final_dspst_cd_code ON dsgn_gvrnmnt_main_mgt_reg(reg_final_dspst_cd);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_main_mgt_reg_define_flg_code ON dsgn_gvrnmnt_main_mgt_reg(define_flg);

-- 指定国官庁マスタ_氏名・住所ファイル（出願） (マドプロ出願マスタ)
CREATE TABLE IF NOT EXISTS dsgn_gvrnmnt_name_addr_app (
    add_del_id TEXT,
    jpo_rfr_num TEXT,
    jpo_rfr_num_split_sign_cd TEXT,
    history_num TEXT,
    appl_atty_input_seq_num INTEGER,
    appl_atty_class_cd TEXT,
    appl_atty_title TEXT,
    appl_atty_addr TEXT,
    define_flg TEXT,
    updt_year_month_day TEXT,
    batch_updt_year_month_day TEXT
);

CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_name_addr_app_jpo_rfr_num ON dsgn_gvrnmnt_name_addr_app(jpo_rfr_num);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_name_addr_app_jpo_rfr_num_split_sign_cd ON dsgn_gvrnmnt_name_addr_app(jpo_rfr_num_split_sign_cd);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_name_addr_app_history_num ON dsgn_gvrnmnt_name_addr_app(history_num);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_name_addr_app_appl_atty_input_seq_num ON dsgn_gvrnmnt_name_addr_app(appl_atty_input_seq_num);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_name_addr_app_appl_atty_class_cd ON dsgn_gvrnmnt_name_addr_app(appl_atty_class_cd);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_name_addr_app_define_flg ON dsgn_gvrnmnt_name_addr_app(define_flg);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_name_addr_app_add_del_id_code ON dsgn_gvrnmnt_name_addr_app(add_del_id);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_name_addr_app_jpo_rfr_num_code ON dsgn_gvrnmnt_name_addr_app(jpo_rfr_num);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_name_addr_app_jpo_rfr_num_split_sign_cd_code ON dsgn_gvrnmnt_name_addr_app(jpo_rfr_num_split_sign_cd);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_name_addr_app_history_num_code ON dsgn_gvrnmnt_name_addr_app(history_num);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_name_addr_app_appl_atty_class_cd_code ON dsgn_gvrnmnt_name_addr_app(appl_atty_class_cd);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_name_addr_app_define_flg_code ON dsgn_gvrnmnt_name_addr_app(define_flg);

-- 指定国官庁マスタ_氏名・住所ファイル（原簿） (マドプロ原簿マスタ)
CREATE TABLE IF NOT EXISTS dsgn_gvrnmnt_name_addr_reg (
    add_del_id TEXT,
    jpo_rfr_num TEXT,
    jpo_rfr_num_split_sign_cd TEXT,
    history_num TEXT,
    appl_atty_input_seq_num INTEGER,
    appl_atty_class_cd TEXT,
    appl_atty_title TEXT,
    appl_atty_addr TEXT,
    define_flg TEXT,
    updt_year_month_day TEXT,
    batch_updt_year_month_day TEXT
);

CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_name_addr_reg_jpo_rfr_num ON dsgn_gvrnmnt_name_addr_reg(jpo_rfr_num);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_name_addr_reg_jpo_rfr_num_split_sign_cd ON dsgn_gvrnmnt_name_addr_reg(jpo_rfr_num_split_sign_cd);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_name_addr_reg_history_num ON dsgn_gvrnmnt_name_addr_reg(history_num);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_name_addr_reg_appl_atty_input_seq_num ON dsgn_gvrnmnt_name_addr_reg(appl_atty_input_seq_num);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_name_addr_reg_appl_atty_class_cd ON dsgn_gvrnmnt_name_addr_reg(appl_atty_class_cd);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_name_addr_reg_define_flg ON dsgn_gvrnmnt_name_addr_reg(define_flg);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_name_addr_reg_add_del_id_code ON dsgn_gvrnmnt_name_addr_reg(add_del_id);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_name_addr_reg_jpo_rfr_num_code ON dsgn_gvrnmnt_name_addr_reg(jpo_rfr_num);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_name_addr_reg_jpo_rfr_num_split_sign_cd_code ON dsgn_gvrnmnt_name_addr_reg(jpo_rfr_num_split_sign_cd);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_name_addr_reg_history_num_code ON dsgn_gvrnmnt_name_addr_reg(history_num);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_name_addr_reg_appl_atty_class_cd_code ON dsgn_gvrnmnt_name_addr_reg(appl_atty_class_cd);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_name_addr_reg_define_flg_code ON dsgn_gvrnmnt_name_addr_reg(define_flg);

-- 指定国官庁マスタ_代替に係る国内登録番号ファイル (マドプロ出願/原簿マスタ)
CREATE TABLE IF NOT EXISTS dsgn_gvrnmnt_sbstt_reg_num (
    add_del_id TEXT,
    jpo_rfr_num TEXT,
    jpo_rfr_num_split_sign_cd TEXT,
    substitute_pattern TEXT,
    substitute_intnl_reg_num TEXT,
    substitute_intnl_reg_split_num TEXT,
    define_flg TEXT,
    updt_year_month_day TEXT,
    batch_updt_year_month_day TEXT
);

CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_sbstt_reg_num_jpo_rfr_num ON dsgn_gvrnmnt_sbstt_reg_num(jpo_rfr_num);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_sbstt_reg_num_jpo_rfr_num_split_sign_cd ON dsgn_gvrnmnt_sbstt_reg_num(jpo_rfr_num_split_sign_cd);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_sbstt_reg_num_substitute_pattern ON dsgn_gvrnmnt_sbstt_reg_num(substitute_pattern);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_sbstt_reg_num_substitute_intnl_reg_num ON dsgn_gvrnmnt_sbstt_reg_num(substitute_intnl_reg_num);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_sbstt_reg_num_substitute_intnl_reg_split_num ON dsgn_gvrnmnt_sbstt_reg_num(substitute_intnl_reg_split_num);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_sbstt_reg_num_define_flg ON dsgn_gvrnmnt_sbstt_reg_num(define_flg);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_sbstt_reg_num_add_del_id_code ON dsgn_gvrnmnt_sbstt_reg_num(add_del_id);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_sbstt_reg_num_jpo_rfr_num_code ON dsgn_gvrnmnt_sbstt_reg_num(jpo_rfr_num);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_sbstt_reg_num_jpo_rfr_num_split_sign_cd_code ON dsgn_gvrnmnt_sbstt_reg_num(jpo_rfr_num_split_sign_cd);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_sbstt_reg_num_substitute_pattern_code ON dsgn_gvrnmnt_sbstt_reg_num(substitute_pattern);
CREATE INDEX IF NOT EXISTS idx_dsgn_gvrnmnt_sbstt_reg_num_define_flg_code ON dsgn_gvrnmnt_sbstt_reg_num(define_flg);

-- 発送書類ファイル (審判マスタ)
CREATE TABLE IF NOT EXISTS dsptch_doc (
    processing_type VARCHAR(1),
    appl_num VARCHAR(10),
    intrmd_cd VARCHAR(7),
    dsptch_doc_num VARCHAR(11),
    doc_dsptch_dt VARCHAR(8),
    addr_typ VARCHAR(1),
    addr_num VARCHAR(3),
    rjct_rsn_art_cd VARCHAR(4),
    transmittal_dt VARCHAR(8),
    gztt_exam_pub_dspst_dt VARCHAR(8),
    crrspnd_rcpt_doc_num VARCHAR(11),
    draft_dt VARCHAR(8),
    crrspnd_num VARCHAR(2),
    updt_dttm VARCHAR(12)
);

CREATE INDEX IF NOT EXISTS idx_dsptch_doc_appl_num ON dsptch_doc(appl_num);
CREATE INDEX IF NOT EXISTS idx_dsptch_doc_intrmd_cd ON dsptch_doc(intrmd_cd);
CREATE INDEX IF NOT EXISTS idx_dsptch_doc_dsptch_doc_num ON dsptch_doc(dsptch_doc_num);

-- 送付済ＩＰＣファイル (IPCマスタ)
CREATE TABLE IF NOT EXISTS dsptch_fin_ipc (
    del_flg TEXT,
    doc_key_num TEXT,
    ipc_pub_dt TEXT,
    class_class TEXT,
    ipc TEXT,
    first_class_flg TEXT,
    invent_add_flg TEXT,
    class_assgn_dt TEXT,
    class_assgn_office TEXT,
    assgn_cause TEXT,
    assgn_method TEXT,
    updt_dt TEXT,
    dsptch_dt TEXT,
    del_dt TEXT
);

CREATE INDEX IF NOT EXISTS idx_dsptch_fin_ipc_doc_key_num ON dsptch_fin_ipc(doc_key_num);
CREATE INDEX IF NOT EXISTS idx_dsptch_fin_ipc_ipc_pub_dt ON dsptch_fin_ipc(ipc_pub_dt);
CREATE INDEX IF NOT EXISTS idx_dsptch_fin_ipc_class_class ON dsptch_fin_ipc(class_class);
CREATE INDEX IF NOT EXISTS idx_dsptch_fin_ipc_ipc ON dsptch_fin_ipc(ipc);
CREATE INDEX IF NOT EXISTS idx_dsptch_fin_ipc_doc_key_num_code ON dsptch_fin_ipc(doc_key_num);
CREATE INDEX IF NOT EXISTS idx_dsptch_fin_ipc_first_class_flg_code ON dsptch_fin_ipc(first_class_flg);
CREATE INDEX IF NOT EXISTS idx_dsptch_fin_ipc_invent_add_flg_code ON dsptch_fin_ipc(invent_add_flg);
CREATE INDEX IF NOT EXISTS idx_dsptch_fin_ipc_assgn_cause_code ON dsptch_fin_ipc(assgn_cause);

-- 重複情報部ファイル (登録マスタ)
CREATE TABLE IF NOT EXISTS duplicate_info (
    processing_type TEXT,
    law_cd TEXT,
    reg_num TEXT,
    app_num TEXT,
    pe_num TEXT,
    duplicate_reg_num TEXT,
    duplicate_app_num TEXT,
    duplicate_jpo_rfr_num TEXT,
    duplicate_intl_reg_num TEXT,
    crt_updt_year_month_day TEXT
);

CREATE INDEX IF NOT EXISTS idx_duplicate_info_law_cd ON duplicate_info(law_cd);
CREATE INDEX IF NOT EXISTS idx_duplicate_info_reg_num ON duplicate_info(reg_num);
CREATE INDEX IF NOT EXISTS idx_duplicate_info_app_num ON duplicate_info(app_num);
CREATE INDEX IF NOT EXISTS idx_duplicate_info_pe_num ON duplicate_info(pe_num);
CREATE INDEX IF NOT EXISTS idx_duplicate_info_processing_type_code ON duplicate_info(processing_type);
CREATE INDEX IF NOT EXISTS idx_duplicate_info_law_cd_code ON duplicate_info(law_cd);
CREATE INDEX IF NOT EXISTS idx_duplicate_info_reg_num_code ON duplicate_info(reg_num);
CREATE INDEX IF NOT EXISTS idx_duplicate_info_app_num_code ON duplicate_info(app_num);
CREATE INDEX IF NOT EXISTS idx_duplicate_info_pe_num_code ON duplicate_info(pe_num);
CREATE INDEX IF NOT EXISTS idx_duplicate_info_duplicate_reg_num_code ON duplicate_info(duplicate_reg_num);
CREATE INDEX IF NOT EXISTS idx_duplicate_info_duplicate_app_num_code ON duplicate_info(duplicate_app_num);
CREATE INDEX IF NOT EXISTS idx_duplicate_info_duplicate_intl_reg_num_code ON duplicate_info(duplicate_intl_reg_num);

-- 重複商標番号記事ファイル (登録マスタ)
CREATE TABLE IF NOT EXISTS duplicate_t_doni (
    processing_type TEXT,
    law_cd TEXT,
    reg_num TEXT,
    split_num TEXT,
    app_num TEXT,
    dpl_t_doni_upd_ymd TEXT,
    mu_num TEXT,
    duplicate_t_reg_split_num TEXT
);

CREATE INDEX IF NOT EXISTS idx_duplicate_t_doni_law_cd ON duplicate_t_doni(law_cd);
CREATE INDEX IF NOT EXISTS idx_duplicate_t_doni_reg_num ON duplicate_t_doni(reg_num);
CREATE INDEX IF NOT EXISTS idx_duplicate_t_doni_split_num ON duplicate_t_doni(split_num);
CREATE INDEX IF NOT EXISTS idx_duplicate_t_doni_app_num ON duplicate_t_doni(app_num);
CREATE INDEX IF NOT EXISTS idx_duplicate_t_doni_mu_num ON duplicate_t_doni(mu_num);
CREATE INDEX IF NOT EXISTS idx_duplicate_t_doni_processing_type_code ON duplicate_t_doni(processing_type);
CREATE INDEX IF NOT EXISTS idx_duplicate_t_doni_law_cd_code ON duplicate_t_doni(law_cd);
CREATE INDEX IF NOT EXISTS idx_duplicate_t_doni_reg_num_code ON duplicate_t_doni(reg_num);
CREATE INDEX IF NOT EXISTS idx_duplicate_t_doni_split_num_code ON duplicate_t_doni(split_num);
CREATE INDEX IF NOT EXISTS idx_duplicate_t_doni_app_num_code ON duplicate_t_doni(app_num);
CREATE INDEX IF NOT EXISTS idx_duplicate_t_doni_mu_num_code ON duplicate_t_doni(mu_num);
CREATE INDEX IF NOT EXISTS idx_duplicate_t_doni_duplicate_t_reg_split_num_code ON duplicate_t_doni(duplicate_t_reg_split_num);

-- 早期・優先審理情報ファイル (審判マスタ)
CREATE TABLE IF NOT EXISTS early_precede_appeal_info (
    processing_type VARCHAR(1),
    appl_num VARCHAR(10),
    early_precede_appeal_id VARCHAR(1),
    appeal_appoint_stts VARCHAR(1),
    updt_dttm VARCHAR(12)
);

CREATE INDEX IF NOT EXISTS idx_early_precede_appeal_info_appl_num ON early_precede_appeal_info(appl_num);
CREATE INDEX IF NOT EXISTS idx_early_precede_appeal_info_early_precede_appeal_id ON early_precede_appeal_info(early_precede_appeal_id);

-- 外国資料情報ファイル (外国意匠公報資料マスタ)
CREATE TABLE IF NOT EXISTS foreign_doc_info (
    del_flg TEXT,
    known_doc_num TEXT,
    search_use_known_dt TEXT,
    pub_dt TEXT,
    acpt_dt TEXT,
    known_dt TEXT,
    pub_cntry_cd TEXT,
    doc_title TEXT,
    publisher_name TEXT,
    publisher_addr TEXT,
    org_lang_goods_name TEXT,
    issu TEXT,
    book TEXT,
    pages TEXT,
    reg_num TEXT,
    pub_num TEXT,
    app_num TEXT,
    every_cntry_class TEXT,
    locarno_class TEXT,
    pub_media_cereal_num TEXT,
    updt_dt TEXT
);

CREATE INDEX IF NOT EXISTS idx_foreign_doc_info_known_doc_num ON foreign_doc_info(known_doc_num);
CREATE INDEX IF NOT EXISTS idx_foreign_doc_info_known_doc_num_code ON foreign_doc_info(known_doc_num);
CREATE INDEX IF NOT EXISTS idx_foreign_doc_info_pub_cntry_cd_code ON foreign_doc_info(pub_cntry_cd);

-- 外国資料意匠分類Dターム情報ファイル (外国意匠公報資料マスタ)
CREATE TABLE IF NOT EXISTS frign_doc_d_class_d_term_info (
    known_doc_num TEXT,
    repeat_num INTEGER,
    main_class_d_term TEXT
);

CREATE INDEX IF NOT EXISTS idx_frign_doc_d_class_d_term_info_known_doc_num ON frign_doc_d_class_d_term_info(known_doc_num);
CREATE INDEX IF NOT EXISTS idx_frign_doc_d_class_d_term_info_repeat_num ON frign_doc_d_class_d_term_info(repeat_num);
CREATE INDEX IF NOT EXISTS idx_frign_doc_d_class_d_term_info_known_doc_num_code ON frign_doc_d_class_d_term_info(known_doc_num);

-- 原新審判事件ファイル (共有データベース（審判）)
CREATE TABLE IF NOT EXISTS gnsn_snpn_zkn (
    skbt_flg TEXT,
    snpn_bngu TEXT,
    krkes_bngu INTEGER,
    knrn_snpn_bngu TEXT,
    gnsn_snpn_zkn_sybt TEXT,
    kusn_ntz_bat TEXT
);

CREATE INDEX IF NOT EXISTS idx_gnsn_snpn_zkn_snpn_bngu ON gnsn_snpn_zkn(snpn_bngu);
CREATE INDEX IF NOT EXISTS idx_gnsn_snpn_zkn_krkes_bngu ON gnsn_snpn_zkn(krkes_bngu);
CREATE INDEX IF NOT EXISTS idx_gnsn_snpn_zkn_skbt_flg_code ON gnsn_snpn_zkn(skbt_flg);
CREATE INDEX IF NOT EXISTS idx_gnsn_snpn_zkn_snpn_bngu_code ON gnsn_snpn_zkn(snpn_bngu);
CREATE INDEX IF NOT EXISTS idx_gnsn_snpn_zkn_knrn_snpn_bngu_code ON gnsn_snpn_zkn(knrn_snpn_bngu);
CREATE INDEX IF NOT EXISTS idx_gnsn_snpn_zkn_gnsn_snpn_zkn_sybt_code ON gnsn_snpn_zkn(gnsn_snpn_zkn_sybt);

-- 商品区分記事ファイル (登録マスタ)
CREATE TABLE IF NOT EXISTS goods_class_art (
    processing_type TEXT,
    law_cd TEXT,
    reg_num TEXT,
    split_num TEXT,
    app_num TEXT,
    goods_cls_art_upd_ymd TEXT,
    mu_num TEXT,
    desig_goods_or_desig_wrk_class TEXT
);

CREATE INDEX IF NOT EXISTS idx_goods_class_art_law_cd ON goods_class_art(law_cd);
CREATE INDEX IF NOT EXISTS idx_goods_class_art_reg_num ON goods_class_art(reg_num);
CREATE INDEX IF NOT EXISTS idx_goods_class_art_split_num ON goods_class_art(split_num);
CREATE INDEX IF NOT EXISTS idx_goods_class_art_app_num ON goods_class_art(app_num);
CREATE INDEX IF NOT EXISTS idx_goods_class_art_mu_num ON goods_class_art(mu_num);
CREATE INDEX IF NOT EXISTS idx_goods_class_art_processing_type_code ON goods_class_art(processing_type);
CREATE INDEX IF NOT EXISTS idx_goods_class_art_law_cd_code ON goods_class_art(law_cd);
CREATE INDEX IF NOT EXISTS idx_goods_class_art_reg_num_code ON goods_class_art(reg_num);
CREATE INDEX IF NOT EXISTS idx_goods_class_art_split_num_code ON goods_class_art(split_num);
CREATE INDEX IF NOT EXISTS idx_goods_class_art_app_num_code ON goods_class_art(app_num);
CREATE INDEX IF NOT EXISTS idx_goods_class_art_mu_num_code ON goods_class_art(mu_num);
CREATE INDEX IF NOT EXISTS idx_goods_class_art_desig_goods_or_desig_wrk_class_code ON goods_class_art(desig_goods_or_desig_wrk_class);

-- 合議官ファイル (共有データベース（審判）)
CREATE TABLE IF NOT EXISTS gugkn (
    skbt_flg TEXT,
    snpn_bngu TEXT,
    krkes_bngu INTEGER,
    gugkn_cd TEXT,
    kusn_ntz_bat TEXT
);

CREATE INDEX IF NOT EXISTS idx_gugkn_snpn_bngu ON gugkn(snpn_bngu);
CREATE INDEX IF NOT EXISTS idx_gugkn_krkes_bngu ON gugkn(krkes_bngu);
CREATE INDEX IF NOT EXISTS idx_gugkn_skbt_flg_code ON gugkn(skbt_flg);
CREATE INDEX IF NOT EXISTS idx_gugkn_snpn_bngu_code ON gugkn(snpn_bngu);

-- 行政不服申立ファイル (共有データベース（審判）)
CREATE TABLE IF NOT EXISTS gyusi_hhk_mustt (
    skbt_flg TEXT,
    tyuni_syri_bngu TEXT,
    hssu_syri_bngu TEXT,
    ssds_dt TEXT,
    uktk_dt TEXT,
    kusn_ntz_bat TEXT
);

CREATE INDEX IF NOT EXISTS idx_gyusi_hhk_mustt_tyuni_syri_bngu ON gyusi_hhk_mustt(tyuni_syri_bngu);
CREATE INDEX IF NOT EXISTS idx_gyusi_hhk_mustt_skbt_flg_code ON gyusi_hhk_mustt(skbt_flg);
CREATE INDEX IF NOT EXISTS idx_gyusi_hhk_mustt_tyuni_syri_bngu_code ON gyusi_hhk_mustt(tyuni_syri_bngu);
CREATE INDEX IF NOT EXISTS idx_gyusi_hhk_mustt_hssu_syri_bngu_code ON gyusi_hhk_mustt(hssu_syri_bngu);

-- 行政不服最終処分ファイル (共有データベース（審判）)
CREATE TABLE IF NOT EXISTS gyusi_hhk_sisyu_sybn (
    skbt_flg TEXT,
    tyuni_syri_bngu TEXT,
    gyusi_hhk_mstt_tn_sr_bngu TEXT,
    ktti_dt_uktk_dt TEXT,
    kusn_ntz_bat TEXT
);

CREATE INDEX IF NOT EXISTS idx_gyusi_hhk_sisyu_sybn_tyuni_syri_bngu ON gyusi_hhk_sisyu_sybn(tyuni_syri_bngu);
CREATE INDEX IF NOT EXISTS idx_gyusi_hhk_sisyu_sybn_skbt_flg_code ON gyusi_hhk_sisyu_sybn(skbt_flg);
CREATE INDEX IF NOT EXISTS idx_gyusi_hhk_sisyu_sybn_tyuni_syri_bngu_code ON gyusi_hhk_sisyu_sybn(tyuni_syri_bngu);
CREATE INDEX IF NOT EXISTS idx_gyusi_hhk_sisyu_sybn_gyusi_hhk_mstt_tn_sr_bngu_code ON gyusi_hhk_sisyu_sybn(gyusi_hhk_mstt_tn_sr_bngu);

-- 非特許文献送付ファイル (共有データベース（審判）)
CREATE TABLE IF NOT EXISTS h_tkky_bnkn_suh (
    skbt_flg TEXT,
    hssu_syri_bngu TEXT,
    suh_tisyu_hssu_syri_bngu TEXT,
    kusn_ntz_bat TEXT
);

CREATE INDEX IF NOT EXISTS idx_h_tkky_bnkn_suh_hssu_syri_bngu ON h_tkky_bnkn_suh(hssu_syri_bngu);
CREATE INDEX IF NOT EXISTS idx_h_tkky_bnkn_suh_skbt_flg_code ON h_tkky_bnkn_suh(skbt_flg);
CREATE INDEX IF NOT EXISTS idx_h_tkky_bnkn_suh_hssu_syri_bngu_code ON h_tkky_bnkn_suh(hssu_syri_bngu);
CREATE INDEX IF NOT EXISTS idx_h_tkky_bnkn_suh_suh_tisyu_hssu_syri_bngu_code ON h_tkky_bnkn_suh(suh_tisyu_hssu_syri_bngu);

-- 非特許参考文献ファイル (共有データベース（審判）)
CREATE TABLE IF NOT EXISTS h_tkky_snku_bnkn (
    skbt_flg TEXT,
    snpn_bngu TEXT,
    krkes_bngu INTEGER,
    h_tkky_snku_bnknmi TEXT,
    kusn_ntz_bat TEXT
);

CREATE INDEX IF NOT EXISTS idx_h_tkky_snku_bnkn_snpn_bngu ON h_tkky_snku_bnkn(snpn_bngu);
CREATE INDEX IF NOT EXISTS idx_h_tkky_snku_bnkn_krkes_bngu ON h_tkky_snku_bnkn(krkes_bngu);
CREATE INDEX IF NOT EXISTS idx_h_tkky_snku_bnkn_skbt_flg_code ON h_tkky_snku_bnkn(skbt_flg);
CREATE INDEX IF NOT EXISTS idx_h_tkky_snku_bnkn_snpn_bngu_code ON h_tkky_snku_bnkn(snpn_bngu);

-- ハーグ管理情報ファイル (登録マスタ)
CREATE TABLE IF NOT EXISTS hague_mgt_info (
    processing_type TEXT,
    law_cd TEXT,
    reg_num TEXT,
    split_num TEXT,
    app_num TEXT,
    intl_reg_num TEXT,
    d_num TEXT,
    mu_num TEXT
);

CREATE INDEX IF NOT EXISTS idx_hague_mgt_info_law_cd ON hague_mgt_info(law_cd);
CREATE INDEX IF NOT EXISTS idx_hague_mgt_info_reg_num ON hague_mgt_info(reg_num);
CREATE INDEX IF NOT EXISTS idx_hague_mgt_info_split_num ON hague_mgt_info(split_num);
CREATE INDEX IF NOT EXISTS idx_hague_mgt_info_app_num ON hague_mgt_info(app_num);
CREATE INDEX IF NOT EXISTS idx_hague_mgt_info_mu_num ON hague_mgt_info(mu_num);
CREATE INDEX IF NOT EXISTS idx_hague_mgt_info_processing_type_code ON hague_mgt_info(processing_type);
CREATE INDEX IF NOT EXISTS idx_hague_mgt_info_law_cd_code ON hague_mgt_info(law_cd);
CREATE INDEX IF NOT EXISTS idx_hague_mgt_info_reg_num_code ON hague_mgt_info(reg_num);
CREATE INDEX IF NOT EXISTS idx_hague_mgt_info_split_num_code ON hague_mgt_info(split_num);
CREATE INDEX IF NOT EXISTS idx_hague_mgt_info_app_num_code ON hague_mgt_info(app_num);
CREATE INDEX IF NOT EXISTS idx_hague_mgt_info_intl_reg_num_code ON hague_mgt_info(intl_reg_num);
CREATE INDEX IF NOT EXISTS idx_hague_mgt_info_mu_num_code ON hague_mgt_info(mu_num);

-- 併合審判事件ファイル (共有データベース（審判）)
CREATE TABLE IF NOT EXISTS higu_snpn_zkn (
    skbt_flg TEXT,
    snpn_bngu TEXT,
    krkes_bngu INTEGER,
    knrn_snpn_bngu TEXT,
    higu_kij_flg TEXT,
    kusn_ntz_bat TEXT
);

CREATE INDEX IF NOT EXISTS idx_higu_snpn_zkn_snpn_bngu ON higu_snpn_zkn(snpn_bngu);
CREATE INDEX IF NOT EXISTS idx_higu_snpn_zkn_krkes_bngu ON higu_snpn_zkn(krkes_bngu);
CREATE INDEX IF NOT EXISTS idx_higu_snpn_zkn_skbt_flg_code ON higu_snpn_zkn(skbt_flg);
CREATE INDEX IF NOT EXISTS idx_higu_snpn_zkn_snpn_bngu_code ON higu_snpn_zkn(snpn_bngu);
CREATE INDEX IF NOT EXISTS idx_higu_snpn_zkn_knrn_snpn_bngu_code ON higu_snpn_zkn(knrn_snpn_bngu);
CREATE INDEX IF NOT EXISTS idx_higu_snpn_zkn_higu_kij_flg_code ON higu_snpn_zkn(higu_kij_flg);

-- 判決分類ファイル (共有データベース（審判）)
CREATE TABLE IF NOT EXISTS hnkt_bnri (
    skbt_flg TEXT,
    sibnsy_cd TEXT,
    zkn_krk_hgu_cd TEXT,
    zkn_bngu TEXT,
    ssyu_kbn TEXT,
    krkes_bngu INTEGER,
    ynpu_kbn TEXT,
    snkyu_sybt TEXT,
    snpn_sybt TEXT,
    hnz_zku_cd TEXT,
    hnkt_bnri_ktrn_cd TEXT,
    hj_bnri_skbt TEXT,
    syum_skbt TEXT,
    kusn_ntz_bat TEXT
);

CREATE INDEX IF NOT EXISTS idx_hnkt_bnri_sibnsy_cd ON hnkt_bnri(sibnsy_cd);
CREATE INDEX IF NOT EXISTS idx_hnkt_bnri_zkn_krk_hgu_cd ON hnkt_bnri(zkn_krk_hgu_cd);
CREATE INDEX IF NOT EXISTS idx_hnkt_bnri_zkn_bngu ON hnkt_bnri(zkn_bngu);
CREATE INDEX IF NOT EXISTS idx_hnkt_bnri_ssyu_kbn ON hnkt_bnri(ssyu_kbn);
CREATE INDEX IF NOT EXISTS idx_hnkt_bnri_krkes_bngu ON hnkt_bnri(krkes_bngu);
CREATE INDEX IF NOT EXISTS idx_hnkt_bnri_skbt_flg_code ON hnkt_bnri(skbt_flg);
CREATE INDEX IF NOT EXISTS idx_hnkt_bnri_sibnsy_cd_code ON hnkt_bnri(sibnsy_cd);
CREATE INDEX IF NOT EXISTS idx_hnkt_bnri_zkn_krk_hgu_cd_code ON hnkt_bnri(zkn_krk_hgu_cd);
CREATE INDEX IF NOT EXISTS idx_hnkt_bnri_ssyu_kbn_code ON hnkt_bnri(ssyu_kbn);
CREATE INDEX IF NOT EXISTS idx_hnkt_bnri_ynpu_kbn_code ON hnkt_bnri(ynpu_kbn);
CREATE INDEX IF NOT EXISTS idx_hnkt_bnri_snkyu_sybt_code ON hnkt_bnri(snkyu_sybt);
CREATE INDEX IF NOT EXISTS idx_hnkt_bnri_snpn_sybt_code ON hnkt_bnri(snpn_sybt);
CREATE INDEX IF NOT EXISTS idx_hnkt_bnri_hnz_zku_cd_code ON hnkt_bnri(hnz_zku_cd);
CREATE INDEX IF NOT EXISTS idx_hnkt_bnri_hnkt_bnri_ktrn_cd_code ON hnkt_bnri(hnkt_bnri_ktrn_cd);
CREATE INDEX IF NOT EXISTS idx_hnkt_bnri_syum_skbt_code ON hnkt_bnri(syum_skbt);

-- 発送書類ファイル (共有データベース（審判）)
CREATE TABLE IF NOT EXISTS hssu_syri (
    skbt_flg TEXT,
    hssu_syri_bngu TEXT,
    snpn_bngu TEXT,
    tyukn_cd TEXT,
    gnsyri_bngu TEXT,
    syri_hssu_dt TEXT,
    atsk_sybt TEXT,
    ig_tuzsy_bngu TEXT,
    snk_snsi_bngu TEXT,
    uktk_syri_bngu TEXT,
    kan_dt TEXT,
    yuku_flg TEXT,
    tiou_mk TEXT,
    etrn_kns_flg TEXT,
    syri_ztti_rrk_bngu INTEGER,
    syri_fomt_sybt TEXT,
    kusn_ntz_bat TEXT
);

CREATE INDEX IF NOT EXISTS idx_hssu_syri_hssu_syri_bngu ON hssu_syri(hssu_syri_bngu);
CREATE INDEX IF NOT EXISTS idx_hssu_syri_skbt_flg_code ON hssu_syri(skbt_flg);
CREATE INDEX IF NOT EXISTS idx_hssu_syri_hssu_syri_bngu_code ON hssu_syri(hssu_syri_bngu);
CREATE INDEX IF NOT EXISTS idx_hssu_syri_snpn_bngu_code ON hssu_syri(snpn_bngu);
CREATE INDEX IF NOT EXISTS idx_hssu_syri_tyukn_cd_code ON hssu_syri(tyukn_cd);
CREATE INDEX IF NOT EXISTS idx_hssu_syri_gnsyri_bngu_code ON hssu_syri(gnsyri_bngu);
CREATE INDEX IF NOT EXISTS idx_hssu_syri_atsk_sybt_code ON hssu_syri(atsk_sybt);
CREATE INDEX IF NOT EXISTS idx_hssu_syri_ig_tuzsy_bngu_code ON hssu_syri(ig_tuzsy_bngu);
CREATE INDEX IF NOT EXISTS idx_hssu_syri_uktk_syri_bngu_code ON hssu_syri(uktk_syri_bngu);
CREATE INDEX IF NOT EXISTS idx_hssu_syri_yuku_flg_code ON hssu_syri(yuku_flg);
CREATE INDEX IF NOT EXISTS idx_hssu_syri_tiou_mk_code ON hssu_syri(tiou_mk);
CREATE INDEX IF NOT EXISTS idx_hssu_syri_etrn_kns_flg_code ON hssu_syri(etrn_kns_flg);
CREATE INDEX IF NOT EXISTS idx_hssu_syri_syri_fomt_sybt_code ON hssu_syri(syri_fomt_sybt);

-- 異議決定ファイル (共有データベース（審判）)
CREATE TABLE IF NOT EXISTS ig_ktti (
    skbt_flg TEXT,
    snpn_bngu TEXT,
    mustt_bngu TEXT,
    ig_ktti_bngu TEXT,
    hssu_syri_bngu TEXT,
    ig_ktti_kkti_stat TEXT,
    kusn_ntz_bat TEXT
);

CREATE INDEX IF NOT EXISTS idx_ig_ktti_snpn_bngu ON ig_ktti(snpn_bngu);
CREATE INDEX IF NOT EXISTS idx_ig_ktti_mustt_bngu ON ig_ktti(mustt_bngu);
CREATE INDEX IF NOT EXISTS idx_ig_ktti_ig_ktti_bngu ON ig_ktti(ig_ktti_bngu);
CREATE INDEX IF NOT EXISTS idx_ig_ktti_skbt_flg_code ON ig_ktti(skbt_flg);
CREATE INDEX IF NOT EXISTS idx_ig_ktti_snpn_bngu_code ON ig_ktti(snpn_bngu);
CREATE INDEX IF NOT EXISTS idx_ig_ktti_hssu_syri_bngu_code ON ig_ktti(hssu_syri_bngu);
CREATE INDEX IF NOT EXISTS idx_ig_ktti_ig_ktti_kkti_stat_code ON ig_ktti(ig_ktti_kkti_stat);

-- 異議決定分類ファイル (共有データベース（審判）)
CREATE TABLE IF NOT EXISTS ig_ktti_bnri (
    skbt_flg TEXT,
    snpn_bngu TEXT,
    mustt_bngu TEXT,
    ig_ktti_bngu TEXT,
    krkes_bngu INTEGER,
    ynpu_kbn TEXT,
    tkyu_huk_skbt TEXT,
    snkyu_sybt TEXT,
    snpn_sybt TEXT,
    hnz_zku_cd TEXT,
    ig_ktti_bnri_ktrn_cd TEXT,
    hj_bnri_skbt TEXT,
    kusn_ntz_bat TEXT
);

CREATE INDEX IF NOT EXISTS idx_ig_ktti_bnri_snpn_bngu ON ig_ktti_bnri(snpn_bngu);
CREATE INDEX IF NOT EXISTS idx_ig_ktti_bnri_mustt_bngu ON ig_ktti_bnri(mustt_bngu);
CREATE INDEX IF NOT EXISTS idx_ig_ktti_bnri_ig_ktti_bngu ON ig_ktti_bnri(ig_ktti_bngu);
CREATE INDEX IF NOT EXISTS idx_ig_ktti_bnri_krkes_bngu ON ig_ktti_bnri(krkes_bngu);
CREATE INDEX IF NOT EXISTS idx_ig_ktti_bnri_skbt_flg_code ON ig_ktti_bnri(skbt_flg);
CREATE INDEX IF NOT EXISTS idx_ig_ktti_bnri_snpn_bngu_code ON ig_ktti_bnri(snpn_bngu);
CREATE INDEX IF NOT EXISTS idx_ig_ktti_bnri_ynpu_kbn_code ON ig_ktti_bnri(ynpu_kbn);
CREATE INDEX IF NOT EXISTS idx_ig_ktti_bnri_tkyu_huk_skbt_code ON ig_ktti_bnri(tkyu_huk_skbt);
CREATE INDEX IF NOT EXISTS idx_ig_ktti_bnri_snkyu_sybt_code ON ig_ktti_bnri(snkyu_sybt);
CREATE INDEX IF NOT EXISTS idx_ig_ktti_bnri_snpn_sybt_code ON ig_ktti_bnri(snpn_sybt);
CREATE INDEX IF NOT EXISTS idx_ig_ktti_bnri_hnz_zku_cd_code ON ig_ktti_bnri(hnz_zku_cd);
CREATE INDEX IF NOT EXISTS idx_ig_ktti_bnri_ig_ktti_bnri_ktrn_cd_code ON ig_ktti_bnri(ig_ktti_bnri_ktrn_cd);

-- 異議申立ファイル (共有データベース（審判）)
CREATE TABLE IF NOT EXISTS ig_mustt (
    skbt_flg TEXT,
    snpn_bngu TEXT,
    mustt_bngu TEXT,
    ig_mustt_dt TEXT,
    ig_mustt_sisyu_sybn_cd TEXT,
    sisyu_sybn_kkti_dt TEXT,
    kusn_ntz_bat TEXT
);

CREATE INDEX IF NOT EXISTS idx_ig_mustt_snpn_bngu ON ig_mustt(snpn_bngu);
CREATE INDEX IF NOT EXISTS idx_ig_mustt_mustt_bngu ON ig_mustt(mustt_bngu);
CREATE INDEX IF NOT EXISTS idx_ig_mustt_skbt_flg_code ON ig_mustt(skbt_flg);
CREATE INDEX IF NOT EXISTS idx_ig_mustt_snpn_bngu_code ON ig_mustt(snpn_bngu);
CREATE INDEX IF NOT EXISTS idx_ig_mustt_ig_mustt_sisyu_sybn_cd_code ON ig_mustt(ig_mustt_sisyu_sybn_cd);

-- 表示用商標記事ファイル (商標基本マスタ)
CREATE TABLE IF NOT EXISTS indct_use_t_art (
    add_del_id TEXT,
    app_num TEXT,
    split_num TEXT,
    sub_data_num TEXT,
    indct_use_t TEXT
);

CREATE INDEX IF NOT EXISTS idx_indct_use_t_art_app_num ON indct_use_t_art(app_num);
CREATE INDEX IF NOT EXISTS idx_indct_use_t_art_split_num ON indct_use_t_art(split_num);
CREATE INDEX IF NOT EXISTS idx_indct_use_t_art_sub_data_num ON indct_use_t_art(sub_data_num);
CREATE INDEX IF NOT EXISTS idx_indct_use_t_art_add_del_id_code ON indct_use_t_art(add_del_id);
CREATE INDEX IF NOT EXISTS idx_indct_use_t_art_app_num_code ON indct_use_t_art(app_num);
CREATE INDEX IF NOT EXISTS idx_indct_use_t_art_split_num_code ON indct_use_t_art(split_num);

-- 侵害訴訟ファイル (審判マスタ)
CREATE TABLE IF NOT EXISTS infringement_litigate (
    processing_type VARCHAR(1),
    infringement_litigate_case_num VARCHAR(8),
    case_rec_code_cd VARCHAR(3),
    court_office_name_id_cd VARCHAR(3),
    court_branch_etc VARCHAR(20),
    close_dt VARCHAR(8),
    close_rsn_cd VARCHAR(2),
    updt_dttm VARCHAR(12)
);

CREATE INDEX IF NOT EXISTS idx_infringement_litigate_infringement_litigate_case_num ON infringement_litigate(infringement_litigate_case_num);
CREATE INDEX IF NOT EXISTS idx_infringement_litigate_case_rec_code_cd ON infringement_litigate(case_rec_code_cd);
CREATE INDEX IF NOT EXISTS idx_infringement_litigate_court_office_name_id_cd ON infringement_litigate(court_office_name_id_cd);

-- 侵害登録番号ファイル (審判マスタ)
CREATE TABLE IF NOT EXISTS infringement_reg_num (
    processing_type VARCHAR(1),
    infringement_litigate_case_num VARCHAR(8),
    case_rec_code_cd VARCHAR(3),
    law_cd_class VARCHAR(1),
    reg_num VARCHAR(7),
    split_num VARCHAR(32),
    smlr_dsgn_num VARCHAR(3),
    sec_num VARCHAR(3),
    updt_dttm VARCHAR(12),
    court_office_name_id_cd VARCHAR(3)
);

CREATE INDEX IF NOT EXISTS idx_infringement_reg_num_infringement_litigate_case_num ON infringement_reg_num(infringement_litigate_case_num);
CREATE INDEX IF NOT EXISTS idx_infringement_reg_num_case_rec_code_cd ON infringement_reg_num(case_rec_code_cd);
CREATE INDEX IF NOT EXISTS idx_infringement_reg_num_law_cd_class ON infringement_reg_num(law_cd_class);
CREATE INDEX IF NOT EXISTS idx_infringement_reg_num_reg_num ON infringement_reg_num(reg_num);
CREATE INDEX IF NOT EXISTS idx_infringement_reg_num_split_num ON infringement_reg_num(split_num);
CREATE INDEX IF NOT EXISTS idx_infringement_reg_num_smlr_dsgn_num ON infringement_reg_num(smlr_dsgn_num);
CREATE INDEX IF NOT EXISTS idx_infringement_reg_num_sec_num ON infringement_reg_num(sec_num);
CREATE INDEX IF NOT EXISTS idx_infringement_reg_num_court_office_name_id_cd ON infringement_reg_num(court_office_name_id_cd);

-- 国際商標登録原簿マスタ_名義人氏名・住所ファイル (マドプロ出願/原簿マスタ)
CREATE TABLE IF NOT EXISTS intl_t_org_crr_nm_addr (
    add_del_id TEXT,
    intl_reg_num TEXT,
    intl_reg_num_updt_cnt_sign_cd TEXT,
    intl_reg_num_split_sign_cd TEXT,
    aft_desig_year_month_day TEXT,
    indct_seq TEXT,
    temp_principal_reg_id_flg TEXT,
    crrcter_input_seq_num INTEGER,
    crrcter_name TEXT,
    crrcter_addr TEXT,
    define_flg TEXT,
    updt_year_month_day TEXT,
    batch_updt_year_month_day TEXT
);

CREATE INDEX IF NOT EXISTS idx_intl_t_org_crr_nm_addr_intl_reg_num ON intl_t_org_crr_nm_addr(intl_reg_num);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_crr_nm_addr_intl_reg_num_updt_cnt_sign_cd ON intl_t_org_crr_nm_addr(intl_reg_num_updt_cnt_sign_cd);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_crr_nm_addr_intl_reg_num_split_sign_cd ON intl_t_org_crr_nm_addr(intl_reg_num_split_sign_cd);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_crr_nm_addr_aft_desig_year_month_day ON intl_t_org_crr_nm_addr(aft_desig_year_month_day);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_crr_nm_addr_indct_seq ON intl_t_org_crr_nm_addr(indct_seq);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_crr_nm_addr_temp_principal_reg_id_flg ON intl_t_org_crr_nm_addr(temp_principal_reg_id_flg);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_crr_nm_addr_crrcter_input_seq_num ON intl_t_org_crr_nm_addr(crrcter_input_seq_num);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_crr_nm_addr_define_flg ON intl_t_org_crr_nm_addr(define_flg);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_crr_nm_addr_add_del_id_code ON intl_t_org_crr_nm_addr(add_del_id);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_crr_nm_addr_intl_reg_num_code ON intl_t_org_crr_nm_addr(intl_reg_num);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_crr_nm_addr_intl_reg_num_updt_cnt_sign_cd_code ON intl_t_org_crr_nm_addr(intl_reg_num_updt_cnt_sign_cd);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_crr_nm_addr_intl_reg_num_split_sign_cd_code ON intl_t_org_crr_nm_addr(intl_reg_num_split_sign_cd);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_crr_nm_addr_indct_seq_code ON intl_t_org_crr_nm_addr(indct_seq);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_crr_nm_addr_temp_principal_reg_id_flg_code ON intl_t_org_crr_nm_addr(temp_principal_reg_id_flg);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_crr_nm_addr_crrcter_input_seq_num_code ON intl_t_org_crr_nm_addr(crrcter_input_seq_num);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_crr_nm_addr_define_flg_code ON intl_t_org_crr_nm_addr(define_flg);

-- 国際商標登録原簿マスタ_重複番号情報ファイル (マドプロ出願/原簿マスタ)
CREATE TABLE IF NOT EXISTS intl_t_org_dplct_num_info (
    add_del_id TEXT,
    intl_reg_num TEXT,
    intl_reg_num_updt_cnt_sign_cd TEXT,
    intl_reg_num_split_sign_cd TEXT,
    aft_desig_year_month_day TEXT,
    temp_principal_reg_id_flg TEXT,
    indct_seq TEXT,
    duplicate_num_id INTEGER,
    duplicate_jpo_rfr_num TEXT,
    dpl_jpo_rfr_no_spl_sign_cd TEXT,
    dpl_intl_reg_no_updt_cnt_cd TEXT,
    duplicate_intl_reg_num TEXT,
    dpl_intl_no_split_sign_cd TEXT,
    duplicate_aft_desig_dt TEXT,
    duplicate_app_num TEXT,
    duplicate_reg_num TEXT,
    duplicate_reg_split_num TEXT,
    define_flg TEXT,
    updt_year_month_day TEXT,
    batch_updt_year_month_day TEXT
);

CREATE INDEX IF NOT EXISTS idx_intl_t_org_dplct_num_info_intl_reg_num ON intl_t_org_dplct_num_info(intl_reg_num);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_dplct_num_info_intl_reg_num_updt_cnt_sign_cd ON intl_t_org_dplct_num_info(intl_reg_num_updt_cnt_sign_cd);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_dplct_num_info_intl_reg_num_split_sign_cd ON intl_t_org_dplct_num_info(intl_reg_num_split_sign_cd);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_dplct_num_info_aft_desig_year_month_day ON intl_t_org_dplct_num_info(aft_desig_year_month_day);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_dplct_num_info_temp_principal_reg_id_flg ON intl_t_org_dplct_num_info(temp_principal_reg_id_flg);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_dplct_num_info_indct_seq ON intl_t_org_dplct_num_info(indct_seq);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_dplct_num_info_duplicate_num_id ON intl_t_org_dplct_num_info(duplicate_num_id);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_dplct_num_info_define_flg ON intl_t_org_dplct_num_info(define_flg);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_dplct_num_info_add_del_id_code ON intl_t_org_dplct_num_info(add_del_id);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_dplct_num_info_intl_reg_num_code ON intl_t_org_dplct_num_info(intl_reg_num);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_dplct_num_info_intl_reg_num_updt_cnt_sign_cd_code ON intl_t_org_dplct_num_info(intl_reg_num_updt_cnt_sign_cd);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_dplct_num_info_intl_reg_num_split_sign_cd_code ON intl_t_org_dplct_num_info(intl_reg_num_split_sign_cd);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_dplct_num_info_temp_principal_reg_id_flg_code ON intl_t_org_dplct_num_info(temp_principal_reg_id_flg);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_dplct_num_info_indct_seq_code ON intl_t_org_dplct_num_info(indct_seq);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_dplct_num_info_duplicate_num_id_code ON intl_t_org_dplct_num_info(duplicate_num_id);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_dplct_num_info_duplicate_jpo_rfr_num_code ON intl_t_org_dplct_num_info(duplicate_jpo_rfr_num);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_dplct_num_info_dpl_jpo_rfr_no_spl_sign_cd_code ON intl_t_org_dplct_num_info(dpl_jpo_rfr_no_spl_sign_cd);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_dplct_num_info_dpl_intl_reg_no_updt_cnt_cd_code ON intl_t_org_dplct_num_info(dpl_intl_reg_no_updt_cnt_cd);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_dplct_num_info_duplicate_intl_reg_num_code ON intl_t_org_dplct_num_info(duplicate_intl_reg_num);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_dplct_num_info_dpl_intl_no_split_sign_cd_code ON intl_t_org_dplct_num_info(dpl_intl_no_split_sign_cd);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_dplct_num_info_duplicate_app_num_code ON intl_t_org_dplct_num_info(duplicate_app_num);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_dplct_num_info_duplicate_reg_num_code ON intl_t_org_dplct_num_info(duplicate_reg_num);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_dplct_num_info_duplicate_reg_split_num_code ON intl_t_org_dplct_num_info(duplicate_reg_split_num);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_dplct_num_info_define_flg_code ON intl_t_org_dplct_num_info(define_flg);

-- 国際商標登録原簿マスタ_指定国商品・サービスファイル (マドプロ出願/原簿マスタ)
CREATE TABLE IF NOT EXISTS intl_t_org_dsgn_gds_srvc (
    add_del_id TEXT,
    intl_reg_num TEXT,
    intl_reg_num_updt_cnt_sign_cd TEXT,
    intl_reg_num_split_sign_cd TEXT,
    aft_desig_year_month_day TEXT,
    indct_seq TEXT,
    seq_num INTEGER,
    temp_principal_reg_id_flg TEXT,
    madopro_class TEXT,
    goods_service_name TEXT,
    intl_reg_rec_dt TEXT,
    define_flg TEXT,
    updt_year_month_day TEXT,
    batch_updt_year_month_day TEXT
);

CREATE INDEX IF NOT EXISTS idx_intl_t_org_dsgn_gds_srvc_intl_reg_num ON intl_t_org_dsgn_gds_srvc(intl_reg_num);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_dsgn_gds_srvc_intl_reg_num_updt_cnt_sign_cd ON intl_t_org_dsgn_gds_srvc(intl_reg_num_updt_cnt_sign_cd);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_dsgn_gds_srvc_intl_reg_num_split_sign_cd ON intl_t_org_dsgn_gds_srvc(intl_reg_num_split_sign_cd);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_dsgn_gds_srvc_aft_desig_year_month_day ON intl_t_org_dsgn_gds_srvc(aft_desig_year_month_day);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_dsgn_gds_srvc_indct_seq ON intl_t_org_dsgn_gds_srvc(indct_seq);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_dsgn_gds_srvc_seq_num ON intl_t_org_dsgn_gds_srvc(seq_num);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_dsgn_gds_srvc_temp_principal_reg_id_flg ON intl_t_org_dsgn_gds_srvc(temp_principal_reg_id_flg);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_dsgn_gds_srvc_define_flg ON intl_t_org_dsgn_gds_srvc(define_flg);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_dsgn_gds_srvc_add_del_id_code ON intl_t_org_dsgn_gds_srvc(add_del_id);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_dsgn_gds_srvc_intl_reg_num_code ON intl_t_org_dsgn_gds_srvc(intl_reg_num);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_dsgn_gds_srvc_intl_reg_num_updt_cnt_sign_cd_code ON intl_t_org_dsgn_gds_srvc(intl_reg_num_updt_cnt_sign_cd);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_dsgn_gds_srvc_intl_reg_num_split_sign_cd_code ON intl_t_org_dsgn_gds_srvc(intl_reg_num_split_sign_cd);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_dsgn_gds_srvc_indct_seq_code ON intl_t_org_dsgn_gds_srvc(indct_seq);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_dsgn_gds_srvc_seq_num_code ON intl_t_org_dsgn_gds_srvc(seq_num);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_dsgn_gds_srvc_temp_principal_reg_id_flg_code ON intl_t_org_dsgn_gds_srvc(temp_principal_reg_id_flg);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_dsgn_gds_srvc_madopro_class_code ON intl_t_org_dsgn_gds_srvc(madopro_class);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_dsgn_gds_srvc_define_flg_code ON intl_t_org_dsgn_gds_srvc(define_flg);

-- 国際商標登録原簿マスタ_原簿管理情報ファイル (マドプロ出願/原簿マスタ)
CREATE TABLE IF NOT EXISTS intl_t_org_org_reg_mgt_info (
    add_del_id TEXT,
    intl_reg_num TEXT,
    intl_reg_num_updt_cnt_sign_cd TEXT,
    intl_reg_num_split_sign_cd TEXT,
    aft_desig_year_month_day TEXT,
    intl_reg_year_month_day TEXT,
    jpo_rfr_num TEXT,
    jpo_rfr_num_split_sign_cd TEXT,
    set_reg_year_month_day TEXT,
    right_ersr_id TEXT,
    right_disppr_year_month_day TEXT,
    close_reg_year_month_day TEXT,
    inspct_prhbt_flg TEXT,
    define_flg TEXT,
    updt_year_month_day TEXT,
    batch_updt_year_month_day TEXT
);

CREATE INDEX IF NOT EXISTS idx_intl_t_org_org_reg_mgt_info_intl_reg_num ON intl_t_org_org_reg_mgt_info(intl_reg_num);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_org_reg_mgt_info_intl_reg_num_updt_cnt_sign_cd ON intl_t_org_org_reg_mgt_info(intl_reg_num_updt_cnt_sign_cd);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_org_reg_mgt_info_intl_reg_num_split_sign_cd ON intl_t_org_org_reg_mgt_info(intl_reg_num_split_sign_cd);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_org_reg_mgt_info_aft_desig_year_month_day ON intl_t_org_org_reg_mgt_info(aft_desig_year_month_day);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_org_reg_mgt_info_define_flg ON intl_t_org_org_reg_mgt_info(define_flg);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_org_reg_mgt_info_add_del_id_code ON intl_t_org_org_reg_mgt_info(add_del_id);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_org_reg_mgt_info_intl_reg_num_code ON intl_t_org_org_reg_mgt_info(intl_reg_num);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_org_reg_mgt_info_intl_reg_num_updt_cnt_sign_cd_code ON intl_t_org_org_reg_mgt_info(intl_reg_num_updt_cnt_sign_cd);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_org_reg_mgt_info_intl_reg_num_split_sign_cd_code ON intl_t_org_org_reg_mgt_info(intl_reg_num_split_sign_cd);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_org_reg_mgt_info_jpo_rfr_num_code ON intl_t_org_org_reg_mgt_info(jpo_rfr_num);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_org_reg_mgt_info_jpo_rfr_num_split_sign_cd_code ON intl_t_org_org_reg_mgt_info(jpo_rfr_num_split_sign_cd);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_org_reg_mgt_info_right_ersr_id_code ON intl_t_org_org_reg_mgt_info(right_ersr_id);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_org_reg_mgt_info_inspct_prhbt_flg_code ON intl_t_org_org_reg_mgt_info(inspct_prhbt_flg);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_org_reg_mgt_info_define_flg_code ON intl_t_org_org_reg_mgt_info(define_flg);

-- 国際商標登録原簿マスタ_経過情報ファイル (マドプロ出願/原簿マスタ)
CREATE TABLE IF NOT EXISTS intl_t_org_prog_info (
    add_del_id TEXT,
    intl_reg_num TEXT,
    intl_reg_num_updt_cnt_sign_cd TEXT,
    intl_reg_num_split_sign_cd TEXT,
    aft_desig_year_month_day TEXT,
    intrmd_cd TEXT,
    string_num TEXT,
    intrmd_dfn_1_dt TEXT,
    intrmd_dfn_2_dt TEXT,
    intrmd_dfn_3_dt TEXT,
    intrmd_dfn_4_dt TEXT,
    intrmd_dfn_5_dt TEXT,
    crrspnd_mk TEXT,
    define_flg TEXT,
    stts TEXT,
    updt_year_month_day TEXT,
    batch_updt_year_month_day TEXT
);

CREATE INDEX IF NOT EXISTS idx_intl_t_org_prog_info_intl_reg_num ON intl_t_org_prog_info(intl_reg_num);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_prog_info_intl_reg_num_updt_cnt_sign_cd ON intl_t_org_prog_info(intl_reg_num_updt_cnt_sign_cd);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_prog_info_intl_reg_num_split_sign_cd ON intl_t_org_prog_info(intl_reg_num_split_sign_cd);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_prog_info_aft_desig_year_month_day ON intl_t_org_prog_info(aft_desig_year_month_day);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_prog_info_intrmd_cd ON intl_t_org_prog_info(intrmd_cd);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_prog_info_string_num ON intl_t_org_prog_info(string_num);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_prog_info_define_flg ON intl_t_org_prog_info(define_flg);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_prog_info_stts ON intl_t_org_prog_info(stts);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_prog_info_add_del_id_code ON intl_t_org_prog_info(add_del_id);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_prog_info_intl_reg_num_code ON intl_t_org_prog_info(intl_reg_num);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_prog_info_intl_reg_num_updt_cnt_sign_cd_code ON intl_t_org_prog_info(intl_reg_num_updt_cnt_sign_cd);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_prog_info_intl_reg_num_split_sign_cd_code ON intl_t_org_prog_info(intl_reg_num_split_sign_cd);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_prog_info_intrmd_cd_code ON intl_t_org_prog_info(intrmd_cd);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_prog_info_string_num_code ON intl_t_org_prog_info(string_num);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_prog_info_define_flg_code ON intl_t_org_prog_info(define_flg);

-- 国際商標登録原簿マスタ_防護商品・サービスファイル (マドプロ出願/原簿マスタ)
CREATE TABLE IF NOT EXISTS intl_t_org_sec_gds_srvc (
    add_del_id TEXT,
    intl_reg_num TEXT,
    intl_reg_num_updt_cnt_sign_cd TEXT,
    intl_reg_num_split_sign_cd TEXT,
    aft_desig_year_month_day TEXT,
    indct_seq TEXT,
    seq_num INTEGER,
    temp_principal_reg_id_flg TEXT,
    sec_desig_goods_desig_wrk_cls TEXT,
    sec_desig_goods_desig_wrk_name TEXT,
    define_flg TEXT,
    updt_year_month_day TEXT,
    batch_updt_year_month_day TEXT
);

CREATE INDEX IF NOT EXISTS idx_intl_t_org_sec_gds_srvc_intl_reg_num ON intl_t_org_sec_gds_srvc(intl_reg_num);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_sec_gds_srvc_intl_reg_num_updt_cnt_sign_cd ON intl_t_org_sec_gds_srvc(intl_reg_num_updt_cnt_sign_cd);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_sec_gds_srvc_intl_reg_num_split_sign_cd ON intl_t_org_sec_gds_srvc(intl_reg_num_split_sign_cd);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_sec_gds_srvc_aft_desig_year_month_day ON intl_t_org_sec_gds_srvc(aft_desig_year_month_day);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_sec_gds_srvc_indct_seq ON intl_t_org_sec_gds_srvc(indct_seq);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_sec_gds_srvc_seq_num ON intl_t_org_sec_gds_srvc(seq_num);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_sec_gds_srvc_temp_principal_reg_id_flg ON intl_t_org_sec_gds_srvc(temp_principal_reg_id_flg);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_sec_gds_srvc_define_flg ON intl_t_org_sec_gds_srvc(define_flg);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_sec_gds_srvc_add_del_id_code ON intl_t_org_sec_gds_srvc(add_del_id);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_sec_gds_srvc_intl_reg_num_code ON intl_t_org_sec_gds_srvc(intl_reg_num);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_sec_gds_srvc_intl_reg_num_updt_cnt_sign_cd_code ON intl_t_org_sec_gds_srvc(intl_reg_num_updt_cnt_sign_cd);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_sec_gds_srvc_intl_reg_num_split_sign_cd_code ON intl_t_org_sec_gds_srvc(intl_reg_num_split_sign_cd);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_sec_gds_srvc_indct_seq_code ON intl_t_org_sec_gds_srvc(indct_seq);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_sec_gds_srvc_seq_num_code ON intl_t_org_sec_gds_srvc(seq_num);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_sec_gds_srvc_temp_principal_reg_id_flg_code ON intl_t_org_sec_gds_srvc(temp_principal_reg_id_flg);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_sec_gds_srvc_sec_desig_goods_desig_wrk_cls_code ON intl_t_org_sec_gds_srvc(sec_desig_goods_desig_wrk_cls);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_sec_gds_srvc_define_flg_code ON intl_t_org_sec_gds_srvc(define_flg);

-- 国際商標登録原簿マスタ_第二表示部ファイル (マドプロ出願/原簿マスタ)
CREATE TABLE IF NOT EXISTS intl_t_org_secnd_indct_div (
    add_del_id TEXT,
    intl_reg_num TEXT,
    intl_reg_num_updt_cnt_sign_cd TEXT,
    intl_reg_num_split_sign_cd TEXT,
    aft_desig_year_month_day TEXT,
    temp_principal_reg_id_flg TEXT,
    indct_seq TEXT,
    sec_app_num TEXT,
    sec_num TEXT,
    sec_exist_prd_expirat_ymd TEXT,
    sec_updt_id TEXT,
    sec_app_year_month_day TEXT,
    sec_finl_dcsn_year_month_day TEXT,
    sec_reg_year_month_day TEXT,
    define_flg TEXT,
    updt_year_month_day TEXT,
    batch_updt_year_month_day TEXT
);

CREATE INDEX IF NOT EXISTS idx_intl_t_org_secnd_indct_div_intl_reg_num ON intl_t_org_secnd_indct_div(intl_reg_num);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_secnd_indct_div_intl_reg_num_updt_cnt_sign_cd ON intl_t_org_secnd_indct_div(intl_reg_num_updt_cnt_sign_cd);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_secnd_indct_div_intl_reg_num_split_sign_cd ON intl_t_org_secnd_indct_div(intl_reg_num_split_sign_cd);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_secnd_indct_div_aft_desig_year_month_day ON intl_t_org_secnd_indct_div(aft_desig_year_month_day);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_secnd_indct_div_temp_principal_reg_id_flg ON intl_t_org_secnd_indct_div(temp_principal_reg_id_flg);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_secnd_indct_div_indct_seq ON intl_t_org_secnd_indct_div(indct_seq);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_secnd_indct_div_define_flg ON intl_t_org_secnd_indct_div(define_flg);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_secnd_indct_div_add_del_id_code ON intl_t_org_secnd_indct_div(add_del_id);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_secnd_indct_div_intl_reg_num_code ON intl_t_org_secnd_indct_div(intl_reg_num);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_secnd_indct_div_intl_reg_num_updt_cnt_sign_cd_code ON intl_t_org_secnd_indct_div(intl_reg_num_updt_cnt_sign_cd);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_secnd_indct_div_intl_reg_num_split_sign_cd_code ON intl_t_org_secnd_indct_div(intl_reg_num_split_sign_cd);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_secnd_indct_div_temp_principal_reg_id_flg_code ON intl_t_org_secnd_indct_div(temp_principal_reg_id_flg);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_secnd_indct_div_indct_seq_code ON intl_t_org_secnd_indct_div(indct_seq);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_secnd_indct_div_sec_updt_id_code ON intl_t_org_secnd_indct_div(sec_updt_id);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_secnd_indct_div_define_flg_code ON intl_t_org_secnd_indct_div(define_flg);

-- 国際商標登録原簿マスタ_設定時名義人氏名・住所ファイル (マドプロ出願/原簿マスタ)
CREATE TABLE IF NOT EXISTS intl_t_org_set_crr_nm_addr (
    add_del_id TEXT,
    intl_reg_num TEXT,
    intl_reg_num_updt_cnt_sign_cd TEXT,
    intl_reg_num_split_sign_cd TEXT,
    aft_desig_year_month_day TEXT,
    temp_principal_reg_id_flg TEXT,
    indct_seq TEXT,
    crrcter_input_seq_num INTEGER,
    crrcter_name TEXT,
    crrcter_addr TEXT,
    define_flg TEXT,
    updt_year_month_day TEXT,
    batch_updt_year_month_day TEXT
);

CREATE INDEX IF NOT EXISTS idx_intl_t_org_set_crr_nm_addr_intl_reg_num ON intl_t_org_set_crr_nm_addr(intl_reg_num);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_set_crr_nm_addr_intl_reg_num_updt_cnt_sign_cd ON intl_t_org_set_crr_nm_addr(intl_reg_num_updt_cnt_sign_cd);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_set_crr_nm_addr_intl_reg_num_split_sign_cd ON intl_t_org_set_crr_nm_addr(intl_reg_num_split_sign_cd);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_set_crr_nm_addr_aft_desig_year_month_day ON intl_t_org_set_crr_nm_addr(aft_desig_year_month_day);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_set_crr_nm_addr_temp_principal_reg_id_flg ON intl_t_org_set_crr_nm_addr(temp_principal_reg_id_flg);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_set_crr_nm_addr_indct_seq ON intl_t_org_set_crr_nm_addr(indct_seq);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_set_crr_nm_addr_crrcter_input_seq_num ON intl_t_org_set_crr_nm_addr(crrcter_input_seq_num);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_set_crr_nm_addr_define_flg ON intl_t_org_set_crr_nm_addr(define_flg);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_set_crr_nm_addr_add_del_id_code ON intl_t_org_set_crr_nm_addr(add_del_id);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_set_crr_nm_addr_intl_reg_num_code ON intl_t_org_set_crr_nm_addr(intl_reg_num);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_set_crr_nm_addr_intl_reg_num_updt_cnt_sign_cd_code ON intl_t_org_set_crr_nm_addr(intl_reg_num_updt_cnt_sign_cd);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_set_crr_nm_addr_intl_reg_num_split_sign_cd_code ON intl_t_org_set_crr_nm_addr(intl_reg_num_split_sign_cd);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_set_crr_nm_addr_temp_principal_reg_id_flg_code ON intl_t_org_set_crr_nm_addr(temp_principal_reg_id_flg);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_set_crr_nm_addr_indct_seq_code ON intl_t_org_set_crr_nm_addr(indct_seq);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_set_crr_nm_addr_crrcter_input_seq_num_code ON intl_t_org_set_crr_nm_addr(crrcter_input_seq_num);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_set_crr_nm_addr_define_flg_code ON intl_t_org_set_crr_nm_addr(define_flg);

-- 国際商標登録原簿マスタ_設定時指定国商品・サービスファイル (マドプロ出願/原簿マスタ)
CREATE TABLE IF NOT EXISTS intl_t_org_set_dsgn_gds_srvc (
    add_del_id TEXT,
    intl_reg_num TEXT,
    intl_reg_num_updt_cnt_sign_cd TEXT,
    intl_reg_num_split_sign_cd TEXT,
    aft_desig_year_month_day TEXT,
    temp_principal_reg_id_flg TEXT,
    indct_seq TEXT,
    seq_num INTEGER,
    madopro_class TEXT,
    goods_service_name TEXT,
    intl_reg_rec_dt TEXT,
    define_flg TEXT,
    updt_year_month_day TEXT,
    batch_updt_year_month_day TEXT
);

CREATE INDEX IF NOT EXISTS idx_intl_t_org_set_dsgn_gds_srvc_intl_reg_num ON intl_t_org_set_dsgn_gds_srvc(intl_reg_num);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_set_dsgn_gds_srvc_intl_reg_num_updt_cnt_sign_cd ON intl_t_org_set_dsgn_gds_srvc(intl_reg_num_updt_cnt_sign_cd);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_set_dsgn_gds_srvc_intl_reg_num_split_sign_cd ON intl_t_org_set_dsgn_gds_srvc(intl_reg_num_split_sign_cd);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_set_dsgn_gds_srvc_aft_desig_year_month_day ON intl_t_org_set_dsgn_gds_srvc(aft_desig_year_month_day);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_set_dsgn_gds_srvc_temp_principal_reg_id_flg ON intl_t_org_set_dsgn_gds_srvc(temp_principal_reg_id_flg);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_set_dsgn_gds_srvc_indct_seq ON intl_t_org_set_dsgn_gds_srvc(indct_seq);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_set_dsgn_gds_srvc_seq_num ON intl_t_org_set_dsgn_gds_srvc(seq_num);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_set_dsgn_gds_srvc_define_flg ON intl_t_org_set_dsgn_gds_srvc(define_flg);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_set_dsgn_gds_srvc_add_del_id_code ON intl_t_org_set_dsgn_gds_srvc(add_del_id);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_set_dsgn_gds_srvc_intl_reg_num_code ON intl_t_org_set_dsgn_gds_srvc(intl_reg_num);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_set_dsgn_gds_srvc_intl_reg_num_updt_cnt_sign_cd_code ON intl_t_org_set_dsgn_gds_srvc(intl_reg_num_updt_cnt_sign_cd);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_set_dsgn_gds_srvc_intl_reg_num_split_sign_cd_code ON intl_t_org_set_dsgn_gds_srvc(intl_reg_num_split_sign_cd);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_set_dsgn_gds_srvc_temp_principal_reg_id_flg_code ON intl_t_org_set_dsgn_gds_srvc(temp_principal_reg_id_flg);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_set_dsgn_gds_srvc_indct_seq_code ON intl_t_org_set_dsgn_gds_srvc(indct_seq);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_set_dsgn_gds_srvc_seq_num_code ON intl_t_org_set_dsgn_gds_srvc(seq_num);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_set_dsgn_gds_srvc_madopro_class_code ON intl_t_org_set_dsgn_gds_srvc(madopro_class);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_set_dsgn_gds_srvc_define_flg_code ON intl_t_org_set_dsgn_gds_srvc(define_flg);

-- 国際商標登録原簿マスタ_設定時第一表示部ファイル (マドプロ出願/原簿マスタ)
CREATE TABLE IF NOT EXISTS intl_t_org_set_frst_indct (
    add_del_id TEXT,
    intl_reg_num TEXT,
    intl_reg_num_updt_cnt_sign_cd TEXT,
    intl_reg_num_split_sign_cd TEXT,
    aft_desig_year_month_day TEXT,
    temp_principal_reg_id_flg TEXT,
    indct_seq TEXT,
    finl_dcsn_year_month_day TEXT,
    trial_dcsn_year_month_day TEXT,
    pri_app_gvrn_cntrcntry_cd TEXT,
    pri_app_year_month_day TEXT,
    pri_clim_cnt TEXT,
    special_t_typ_flg TEXT,
    group_cert_warranty_flg TEXT,
    define_flg TEXT,
    updt_year_month_day TEXT,
    batch_updt_year_month_day TEXT,
    t_dtl_explntn TEXT
);

CREATE INDEX IF NOT EXISTS idx_intl_t_org_set_frst_indct_intl_reg_num ON intl_t_org_set_frst_indct(intl_reg_num);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_set_frst_indct_intl_reg_num_updt_cnt_sign_cd ON intl_t_org_set_frst_indct(intl_reg_num_updt_cnt_sign_cd);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_set_frst_indct_intl_reg_num_split_sign_cd ON intl_t_org_set_frst_indct(intl_reg_num_split_sign_cd);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_set_frst_indct_aft_desig_year_month_day ON intl_t_org_set_frst_indct(aft_desig_year_month_day);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_set_frst_indct_temp_principal_reg_id_flg ON intl_t_org_set_frst_indct(temp_principal_reg_id_flg);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_set_frst_indct_indct_seq ON intl_t_org_set_frst_indct(indct_seq);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_set_frst_indct_define_flg ON intl_t_org_set_frst_indct(define_flg);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_set_frst_indct_add_del_id_code ON intl_t_org_set_frst_indct(add_del_id);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_set_frst_indct_intl_reg_num_code ON intl_t_org_set_frst_indct(intl_reg_num);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_set_frst_indct_intl_reg_num_updt_cnt_sign_cd_code ON intl_t_org_set_frst_indct(intl_reg_num_updt_cnt_sign_cd);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_set_frst_indct_intl_reg_num_split_sign_cd_code ON intl_t_org_set_frst_indct(intl_reg_num_split_sign_cd);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_set_frst_indct_temp_principal_reg_id_flg_code ON intl_t_org_set_frst_indct(temp_principal_reg_id_flg);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_set_frst_indct_indct_seq_code ON intl_t_org_set_frst_indct(indct_seq);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_set_frst_indct_pri_app_gvrn_cntrcntry_cd_code ON intl_t_org_set_frst_indct(pri_app_gvrn_cntrcntry_cd);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_set_frst_indct_pri_clim_cnt_code ON intl_t_org_set_frst_indct(pri_clim_cnt);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_set_frst_indct_special_t_typ_flg_code ON intl_t_org_set_frst_indct(special_t_typ_flg);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_set_frst_indct_group_cert_warranty_flg_code ON intl_t_org_set_frst_indct(group_cert_warranty_flg);
CREATE INDEX IF NOT EXISTS idx_intl_t_org_set_frst_indct_define_flg_code ON intl_t_org_set_frst_indct(define_flg);

-- 国内引用文献詳細マスタファイル (引用文献マスタ)
CREATE TABLE IF NOT EXISTS intnl_citation_doc_det_mstr (
    del_flg TEXT,
    isn TEXT,
    reg_srl_num TEXT,
    reg_srl_num_br_num TEXT,
    rlt_place TEXT,
    category TEXT,
    claim TEXT
);

CREATE INDEX IF NOT EXISTS idx_intnl_citation_doc_det_mstr_isn ON intnl_citation_doc_det_mstr(isn);
CREATE INDEX IF NOT EXISTS idx_intnl_citation_doc_det_mstr_reg_srl_num ON intnl_citation_doc_det_mstr(reg_srl_num);

-- 国内引用文献マスタファイル (引用文献マスタ)
CREATE TABLE IF NOT EXISTS intnl_citation_doc_mstr (
    del_flg TEXT,
    isn TEXT,
    app_num TEXT,
    citation_typ TEXT,
    draft_dt TEXT
);

CREATE INDEX IF NOT EXISTS idx_intnl_citation_doc_mstr_isn ON intnl_citation_doc_mstr(isn);
CREATE INDEX IF NOT EXISTS idx_intnl_citation_doc_mstr_app_num ON intnl_citation_doc_mstr(app_num);
CREATE INDEX IF NOT EXISTS idx_intnl_citation_doc_mstr_citation_typ ON intnl_citation_doc_mstr(citation_typ);
CREATE INDEX IF NOT EXISTS idx_intnl_citation_doc_mstr_draft_dt ON intnl_citation_doc_mstr(draft_dt);
CREATE INDEX IF NOT EXISTS idx_intnl_citation_doc_mstr_citation_typ_code ON intnl_citation_doc_mstr(citation_typ);

-- 国内引用文献マスタ_引用調査データファイル (引用文献マスタ)
CREATE TABLE IF NOT EXISTS intnl_citation_doc_mstr_data (
    isn TEXT,
    app_num TEXT,
    citation_typ TEXT,
    draft_dt TEXT,
    repeat_num INTEGER,
    reg_srl_num TEXT,
    doc_num TEXT
);

CREATE INDEX IF NOT EXISTS idx_intnl_citation_doc_mstr_data_isn ON intnl_citation_doc_mstr_data(isn);
CREATE INDEX IF NOT EXISTS idx_intnl_citation_doc_mstr_data_app_num ON intnl_citation_doc_mstr_data(app_num);
CREATE INDEX IF NOT EXISTS idx_intnl_citation_doc_mstr_data_citation_typ ON intnl_citation_doc_mstr_data(citation_typ);
CREATE INDEX IF NOT EXISTS idx_intnl_citation_doc_mstr_data_draft_dt ON intnl_citation_doc_mstr_data(draft_dt);
CREATE INDEX IF NOT EXISTS idx_intnl_citation_doc_mstr_data_repeat_num ON intnl_citation_doc_mstr_data(repeat_num);
CREATE INDEX IF NOT EXISTS idx_intnl_citation_doc_mstr_data_app_num_code ON intnl_citation_doc_mstr_data(app_num);
CREATE INDEX IF NOT EXISTS idx_intnl_citation_doc_mstr_data_citation_typ_code ON intnl_citation_doc_mstr_data(citation_typ);
CREATE INDEX IF NOT EXISTS idx_intnl_citation_doc_mstr_data_doc_num_code ON intnl_citation_doc_mstr_data(doc_num);

-- 中間記録_起案書類ファイル (ハーグ指定官庁マスタ)
CREATE TABLE IF NOT EXISTS intrmd_rec_draft_doc (
    doc_num TEXT,
    history_num TEXT,
    app_num TEXT,
    intrmd_doc_cd TEXT,
    draft_dt TEXT,
    dsptch_dt TEXT,
    create_dttm TEXT,
    update_dttm TEXT
);

CREATE INDEX IF NOT EXISTS idx_intrmd_rec_draft_doc_doc_num ON intrmd_rec_draft_doc(doc_num);
CREATE INDEX IF NOT EXISTS idx_intrmd_rec_draft_doc_history_num ON intrmd_rec_draft_doc(history_num);
CREATE INDEX IF NOT EXISTS idx_intrmd_rec_draft_doc_intrmd_doc_cd_code ON intrmd_rec_draft_doc(intrmd_doc_cd);
CREATE INDEX IF NOT EXISTS idx_intrmd_rec_draft_doc_draft_dt_code ON intrmd_rec_draft_doc(draft_dt);
CREATE INDEX IF NOT EXISTS idx_intrmd_rec_draft_doc_dsptch_dt_code ON intrmd_rec_draft_doc(dsptch_dt);
CREATE INDEX IF NOT EXISTS idx_intrmd_rec_draft_doc_create_dttm_code ON intrmd_rec_draft_doc(create_dttm);
CREATE INDEX IF NOT EXISTS idx_intrmd_rec_draft_doc_update_dttm_code ON intrmd_rec_draft_doc(update_dttm);

-- 中間記録_国際意匠公報_意匠単位ファイル (ハーグ指定官庁マスタ)
CREATE TABLE IF NOT EXISTS intrmd_rec_intl_d_bul_d (
    doc_num TEXT,
    history_num TEXT,
    app_num TEXT,
    bul_publish_dt TEXT,
    intrmd_doc_cd TEXT,
    rcpt_dt TEXT,
    create_dttm TEXT,
    update_dttm TEXT
);

CREATE INDEX IF NOT EXISTS idx_intrmd_rec_intl_d_bul_d_doc_num ON intrmd_rec_intl_d_bul_d(doc_num);
CREATE INDEX IF NOT EXISTS idx_intrmd_rec_intl_d_bul_d_history_num ON intrmd_rec_intl_d_bul_d(history_num);
CREATE INDEX IF NOT EXISTS idx_intrmd_rec_intl_d_bul_d_bul_publish_dt_code ON intrmd_rec_intl_d_bul_d(bul_publish_dt);
CREATE INDEX IF NOT EXISTS idx_intrmd_rec_intl_d_bul_d_intrmd_doc_cd_code ON intrmd_rec_intl_d_bul_d(intrmd_doc_cd);
CREATE INDEX IF NOT EXISTS idx_intrmd_rec_intl_d_bul_d_rcpt_dt_code ON intrmd_rec_intl_d_bul_d(rcpt_dt);
CREATE INDEX IF NOT EXISTS idx_intrmd_rec_intl_d_bul_d_create_dttm_code ON intrmd_rec_intl_d_bul_d(create_dttm);
CREATE INDEX IF NOT EXISTS idx_intrmd_rec_intl_d_bul_d_update_dttm_code ON intrmd_rec_intl_d_bul_d(update_dttm);

-- 発明等の名称ファイル (審判マスタ)
CREATE TABLE IF NOT EXISTS invent_etc_title (
    processing_type VARCHAR(1),
    appl_num VARCHAR(10),
    goods_class VARCHAR(2),
    invent_etc_title TEXT,
    updt_dttm VARCHAR(12)
);

CREATE INDEX IF NOT EXISTS idx_invent_etc_title_appl_num ON invent_etc_title(appl_num);
CREATE INDEX IF NOT EXISTS idx_invent_etc_title_goods_class ON invent_etc_title(goods_class);

-- 判決ファイル (審判マスタ)
CREATE TABLE IF NOT EXISTS jdgmnt (
    processing_type VARCHAR(1),
    litigate_case_num_year_issu VARCHAR(2),
    litigate_case_num_year VARCHAR(2),
    litigate_case_num_num VARCHAR(5),
    litigate_class VARCHAR(1),
    give_jdgmnt_dt VARCHAR(8),
    jdgmnt_main_clause_typ VARCHAR(2),
    updt_dttm VARCHAR(12)
);

CREATE INDEX IF NOT EXISTS idx_jdgmnt_litigate_case_num_year_issu ON jdgmnt(litigate_case_num_year_issu);
CREATE INDEX IF NOT EXISTS idx_jdgmnt_litigate_case_num_year ON jdgmnt(litigate_case_num_year);
CREATE INDEX IF NOT EXISTS idx_jdgmnt_litigate_case_num_num ON jdgmnt(litigate_case_num_num);
CREATE INDEX IF NOT EXISTS idx_jdgmnt_litigate_class ON jdgmnt(litigate_class);

-- 判決分類コードファイル (審判マスタ)
CREATE TABLE IF NOT EXISTS jdgmnt_class_cd (
    processing_type VARCHAR(1),
    litigate_case_num_year_issu VARCHAR(2),
    litigate_case_num_year VARCHAR(2),
    litigate_case_num_num VARCHAR(5),
    litigate_class VARCHAR(1),
    sequence_num SMALLINT,
    law_cd_class VARCHAR(1),
    apply_law_id VARCHAR(1),
    instance_typ VARCHAR(1),
    appl_typ VARCHAR(3),
    jdgmnt_item_cd VARCHAR(3),
    conclusion_cd VARCHAR(4),
    complement_sub_class_id VARCHAR(13),
    litigation_id VARCHAR(1),
    updt_dttm VARCHAR(12)
);

CREATE INDEX IF NOT EXISTS idx_jdgmnt_class_cd_litigate_case_num_year_issu ON jdgmnt_class_cd(litigate_case_num_year_issu);
CREATE INDEX IF NOT EXISTS idx_jdgmnt_class_cd_litigate_case_num_year ON jdgmnt_class_cd(litigate_case_num_year);
CREATE INDEX IF NOT EXISTS idx_jdgmnt_class_cd_litigate_case_num_num ON jdgmnt_class_cd(litigate_case_num_num);
CREATE INDEX IF NOT EXISTS idx_jdgmnt_class_cd_litigate_class ON jdgmnt_class_cd(litigate_class);
CREATE INDEX IF NOT EXISTS idx_jdgmnt_class_cd_sequence_num ON jdgmnt_class_cd(sequence_num);

-- 事件フォルダ_意匠ファイル (出願マスタ（意商）)
CREATE TABLE IF NOT EXISTS jiken_c_d (
    masterkosin_nitiji TEXT,
    yonpo_code TEXT,
    shutugan_no TEXT,
    shutugan_bi TEXT,
    shutugan_shubetu1 TEXT,
    shutugan_shubetu2 TEXT,
    shutugan_shubetu3 TEXT,
    shutugan_shubetu4 TEXT,
    shutugan_shubetu5 TEXT,
    seiri_no TEXT,
    saishushobun_shubetu TEXT,
    saishushobun_bi TEXT,
    raz_toroku_no TEXT,
    ruiji_no TEXT,
    toroku_bi TEXT,
    raz_sotugo_su TEXT,
    raz_nenkantugo_su TEXT,
    raz_kohohakko_bi TEXT,
    daz_ishosin_bunrui TEXT,
    tantokan_code TEXT,
    bubunisho_sikibetu TEXT,
    kumimono_sikibetu TEXT,
    xbz_knrjtjskyodaku_shubetu TEXT,
    genshutugan_shubetu TEXT,
    genshutuganyonpo_code TEXT,
    genshutugan_no TEXT,
    sokyu_bi TEXT,
    rbz_shutugan_no TEXT,
    rbz_toroku_no TEXT,
    honishoshutugan_no TEXT,
    honishotoroku_no TEXT,
    ishonikakarubuppin TEXT,
    ishono_setumei TEXT,
    ishonikakarubuppnn_setme TEXT,
    sokisinsa_mark TEXT,
    tekiyohoki_kubun TEXT,
    sosho_code TEXT,
    satei_shubetu TEXT,
    hinagatamihon_flag TEXT
);

CREATE INDEX IF NOT EXISTS idx_jiken_c_d_yonpo_code ON jiken_c_d(yonpo_code);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_shutugan_no ON jiken_c_d(shutugan_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_yonpo_code_code ON jiken_c_d(yonpo_code);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_shutugan_no_code ON jiken_c_d(shutugan_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_shutugan_shubetu1_code ON jiken_c_d(shutugan_shubetu1);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_shutugan_shubetu2_code ON jiken_c_d(shutugan_shubetu2);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_shutugan_shubetu3_code ON jiken_c_d(shutugan_shubetu3);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_shutugan_shubetu4_code ON jiken_c_d(shutugan_shubetu4);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_shutugan_shubetu5_code ON jiken_c_d(shutugan_shubetu5);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_seiri_no_code ON jiken_c_d(seiri_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_saishushobun_shubetu_code ON jiken_c_d(saishushobun_shubetu);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_raz_toroku_no_code ON jiken_c_d(raz_toroku_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_ruiji_no_code ON jiken_c_d(ruiji_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_daz_ishosin_bunrui_code ON jiken_c_d(daz_ishosin_bunrui);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_bubunisho_sikibetu_code ON jiken_c_d(bubunisho_sikibetu);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_kumimono_sikibetu_code ON jiken_c_d(kumimono_sikibetu);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_xbz_knrjtjskyodaku_shubetu_code ON jiken_c_d(xbz_knrjtjskyodaku_shubetu);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_genshutugan_shubetu_code ON jiken_c_d(genshutugan_shubetu);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_genshutuganyonpo_code_code ON jiken_c_d(genshutuganyonpo_code);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_genshutugan_no_code ON jiken_c_d(genshutugan_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_rbz_shutugan_no_code ON jiken_c_d(rbz_shutugan_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_rbz_toroku_no_code ON jiken_c_d(rbz_toroku_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_honishoshutugan_no_code ON jiken_c_d(honishoshutugan_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_honishotoroku_no_code ON jiken_c_d(honishotoroku_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_sokisinsa_mark_code ON jiken_c_d(sokisinsa_mark);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_tekiyohoki_kubun_code ON jiken_c_d(tekiyohoki_kubun);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_sosho_code_code ON jiken_c_d(sosho_code);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_satei_shubetu_code ON jiken_c_d(satei_shubetu);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_hinagatamihon_flag_code ON jiken_c_d(hinagatamihon_flag);

-- 事件フォルダ_意匠_庁内中間記録ファイル (出願マスタ（意商）)
CREATE TABLE IF NOT EXISTS jiken_c_d_chonai_dv (
    yonpo_code TEXT,
    shutugan_no TEXT,
    folderbetusakusejnj_no TEXT,
    sakusei_bi TEXT,
    chukanshorui_code TEXT,
    taio_mark TEXT,
    chonaishoruisakusei_bi TEXT,
    gyohuku_no TEXT,
    shusso_no TEXT,
    shorui_no TEXT,
    shorui_shubetu TEXT,
    teiseitaishoshorui_no TEXT,
    version_no TEXT
);

CREATE INDEX IF NOT EXISTS idx_jiken_c_d_chonai_dv_yonpo_code ON jiken_c_d_chonai_dv(yonpo_code);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_chonai_dv_shutugan_no ON jiken_c_d_chonai_dv(shutugan_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_chonai_dv_folderbetusakusejnj_no ON jiken_c_d_chonai_dv(folderbetusakusejnj_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_chonai_dv_yonpo_code_code ON jiken_c_d_chonai_dv(yonpo_code);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_chonai_dv_shutugan_no_code ON jiken_c_d_chonai_dv(shutugan_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_chonai_dv_chukanshorui_code_code ON jiken_c_d_chonai_dv(chukanshorui_code);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_chonai_dv_taio_mark_code ON jiken_c_d_chonai_dv(taio_mark);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_chonai_dv_gyohuku_no_code ON jiken_c_d_chonai_dv(gyohuku_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_chonai_dv_shusso_no_code ON jiken_c_d_chonai_dv(shusso_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_chonai_dv_shorui_no_code ON jiken_c_d_chonai_dv(shorui_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_chonai_dv_shorui_shubetu_code ON jiken_c_d_chonai_dv(shorui_shubetu);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_chonai_dv_teiseitaishoshorui_no_code ON jiken_c_d_chonai_dv(teiseitaishoshorui_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_chonai_dv_version_no_code ON jiken_c_d_chonai_dv(version_no);

-- 事件フォルダ_意匠_起案中間記録ファイル (出願マスタ（意商）)
CREATE TABLE IF NOT EXISTS jiken_c_d_kian_dv (
    yonpo_code TEXT,
    shutugan_no TEXT,
    folderbetusakusejnj_no TEXT,
    sakusei_bi TEXT,
    chukanshorui_code TEXT,
    taio_mark TEXT,
    kian_bi TEXT,
    hasso_bi TEXT,
    shorui_no TEXT,
    kyozeturiyujobun_code TEXT,
    taioshorui_no TEXT,
    shorui_shubetu TEXT,
    version_no TEXT
);

CREATE INDEX IF NOT EXISTS idx_jiken_c_d_kian_dv_yonpo_code ON jiken_c_d_kian_dv(yonpo_code);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_kian_dv_shutugan_no ON jiken_c_d_kian_dv(shutugan_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_kian_dv_folderbetusakusejnj_no ON jiken_c_d_kian_dv(folderbetusakusejnj_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_kian_dv_yonpo_code_code ON jiken_c_d_kian_dv(yonpo_code);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_kian_dv_shutugan_no_code ON jiken_c_d_kian_dv(shutugan_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_kian_dv_chukanshorui_code_code ON jiken_c_d_kian_dv(chukanshorui_code);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_kian_dv_taio_mark_code ON jiken_c_d_kian_dv(taio_mark);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_kian_dv_shorui_no_code ON jiken_c_d_kian_dv(shorui_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_kian_dv_kyozeturiyujobun_code_code ON jiken_c_d_kian_dv(kyozeturiyujobun_code);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_kian_dv_taioshorui_no_code ON jiken_c_d_kian_dv(taioshorui_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_kian_dv_shorui_shubetu_code ON jiken_c_d_kian_dv(shorui_shubetu);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_kian_dv_version_no_code ON jiken_c_d_kian_dv(version_no);

-- 事件フォルダ_意匠凍結ファイル (出願マスタ（意商）)
CREATE TABLE IF NOT EXISTS jiken_c_d_old (
    yonpo_code TEXT,
    shutugan_no TEXT,
    tokuchokisaikohokeisai_flg TEXT,
    ishosikisai_umu TEXT
);

CREATE INDEX IF NOT EXISTS idx_jiken_c_d_old_yonpo_code ON jiken_c_d_old(yonpo_code);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_old_shutugan_no ON jiken_c_d_old(shutugan_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_old_yonpo_code_code ON jiken_c_d_old(yonpo_code);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_old_shutugan_no_code ON jiken_c_d_old(shutugan_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_old_tokuchokisaikohokeisai_flg_code ON jiken_c_d_old(tokuchokisaikohokeisai_flg);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_old_ishosikisai_umu_code ON jiken_c_d_old(ishosikisai_umu);

-- 事件フォルダ_意匠_出願人代理人情報ファイル (出願マスタ（意商）)
CREATE TABLE IF NOT EXISTS jiken_c_d_shutugannindairinin (
    yonpo_code TEXT,
    shutugan_no TEXT,
    shutugannindairinin_sikbt TEXT,
    shutugannindairinin_code TEXT,
    gez_henko_no TEXT,
    gez_kohokan_kubun TEXT,
    gez_kokken_code TEXT,
    daihyoshutugannin_sikibetu TEXT,
    jokishutugannin_nanmei TEXT,
    dairininhoka_nanmei TEXT,
    dairinin_shubetu TEXT,
    dairininsikaku_shubetu TEXT,
    shutugannindairinin_jusho TEXT,
    shutugannindairinin_simei TEXT,
    gez_junjo_no INTEGER
);

CREATE INDEX IF NOT EXISTS idx_jiken_c_d_shutugannindairinin_yonpo_code ON jiken_c_d_shutugannindairinin(yonpo_code);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_shutugannindairinin_shutugan_no ON jiken_c_d_shutugannindairinin(shutugan_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_shutugannindairinin_gez_junjo_no ON jiken_c_d_shutugannindairinin(gez_junjo_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_shutugannindairinin_yonpo_code_code ON jiken_c_d_shutugannindairinin(yonpo_code);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_shutugannindairinin_shutugan_no_code ON jiken_c_d_shutugannindairinin(shutugan_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_shutugannindairinin_shutugannindairinin_sikbt_code ON jiken_c_d_shutugannindairinin(shutugannindairinin_sikbt);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_shutugannindairinin_shutugannindairinin_code_code ON jiken_c_d_shutugannindairinin(shutugannindairinin_code);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_shutugannindairinin_gez_kohokan_kubun_code ON jiken_c_d_shutugannindairinin(gez_kohokan_kubun);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_shutugannindairinin_gez_kokken_code_code ON jiken_c_d_shutugannindairinin(gez_kokken_code);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_shutugannindairinin_daihyoshutugannin_sikibetu_code ON jiken_c_d_shutugannindairinin(daihyoshutugannin_sikibetu);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_shutugannindairinin_dairinin_shubetu_code ON jiken_c_d_shutugannindairinin(dairinin_shubetu);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_shutugannindairinin_dairininsikaku_shubetu_code ON jiken_c_d_shutugannindairinin(dairininsikaku_shubetu);

-- 事件フォルダ_意匠_申請中間記録ファイル (出願マスタ（意商）)
CREATE TABLE IF NOT EXISTS jiken_c_d_sinsei_dv (
    yonpo_code TEXT,
    shutugan_no TEXT,
    folderbetusakusejnj_no TEXT,
    sakusei_bi TEXT,
    chukanshorui_code TEXT,
    taio_mark TEXT,
    sasidasi_bi TEXT,
    uketuke_bi TEXT,
    shorui_no TEXT,
    hosikikan_mark TEXT,
    sireikan_flag TEXT,
    taioshorui_no TEXT,
    shorui_shubetu TEXT,
    version_no TEXT,
    eturankinsi_flag TEXT
);

CREATE INDEX IF NOT EXISTS idx_jiken_c_d_sinsei_dv_yonpo_code ON jiken_c_d_sinsei_dv(yonpo_code);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_sinsei_dv_shutugan_no ON jiken_c_d_sinsei_dv(shutugan_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_sinsei_dv_folderbetusakusejnj_no ON jiken_c_d_sinsei_dv(folderbetusakusejnj_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_sinsei_dv_yonpo_code_code ON jiken_c_d_sinsei_dv(yonpo_code);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_sinsei_dv_shutugan_no_code ON jiken_c_d_sinsei_dv(shutugan_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_sinsei_dv_chukanshorui_code_code ON jiken_c_d_sinsei_dv(chukanshorui_code);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_sinsei_dv_taio_mark_code ON jiken_c_d_sinsei_dv(taio_mark);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_sinsei_dv_shorui_no_code ON jiken_c_d_sinsei_dv(shorui_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_sinsei_dv_hosikikan_mark_code ON jiken_c_d_sinsei_dv(hosikikan_mark);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_sinsei_dv_sireikan_flag_code ON jiken_c_d_sinsei_dv(sireikan_flag);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_sinsei_dv_taioshorui_no_code ON jiken_c_d_sinsei_dv(taioshorui_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_sinsei_dv_shorui_shubetu_code ON jiken_c_d_sinsei_dv(shorui_shubetu);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_sinsei_dv_version_no_code ON jiken_c_d_sinsei_dv(version_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_sinsei_dv_eturankinsi_flag_code ON jiken_c_d_sinsei_dv(eturankinsi_flag);

-- 事件フォルダ_意匠_創作者情報ファイル (出願マスタ（意商）)
CREATE TABLE IF NOT EXISTS jiken_c_d_sosakusha_joho (
    yonpo_code TEXT,
    shutugan_no TEXT,
    simei TEXT,
    jusho TEXT,
    cmz_junjo_no INTEGER
);

CREATE INDEX IF NOT EXISTS idx_jiken_c_d_sosakusha_joho_yonpo_code ON jiken_c_d_sosakusha_joho(yonpo_code);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_sosakusha_joho_shutugan_no ON jiken_c_d_sosakusha_joho(shutugan_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_sosakusha_joho_cmz_junjo_no ON jiken_c_d_sosakusha_joho(cmz_junjo_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_sosakusha_joho_yonpo_code_code ON jiken_c_d_sosakusha_joho(yonpo_code);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_sosakusha_joho_shutugan_no_code ON jiken_c_d_sosakusha_joho(shutugan_no);

-- 事件フォルダ_意匠_優先権情報ファイル (出願マスタ（意商）)
CREATE TABLE IF NOT EXISTS jiken_c_d_yusenken_joho (
    yonpo_code TEXT,
    shutugan_no TEXT,
    yusenkenshutugan_no TEXT,
    yusenkenshucho_bi TEXT,
    yusenkenkuni_code TEXT,
    bmz_junjo_no INTEGER
);

CREATE INDEX IF NOT EXISTS idx_jiken_c_d_yusenken_joho_yonpo_code ON jiken_c_d_yusenken_joho(yonpo_code);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_yusenken_joho_shutugan_no ON jiken_c_d_yusenken_joho(shutugan_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_yusenken_joho_bmz_junjo_no ON jiken_c_d_yusenken_joho(bmz_junjo_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_yusenken_joho_yonpo_code_code ON jiken_c_d_yusenken_joho(yonpo_code);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_yusenken_joho_shutugan_no_code ON jiken_c_d_yusenken_joho(shutugan_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_yusenken_joho_yusenkenshutugan_no_code ON jiken_c_d_yusenken_joho(yusenkenshutugan_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_d_yusenken_joho_yusenkenkuni_code_code ON jiken_c_d_yusenken_joho(yusenkenkuni_code);

-- 事件フォルダ_商標ファイル (出願マスタ（意商）)
CREATE TABLE IF NOT EXISTS jiken_c_t (
    masterkosin_nitiji TEXT,
    yonpo_code TEXT,
    shutugan_no TEXT,
    shutugan_bi TEXT,
    shutugan_shubetu1 TEXT,
    shutugan_shubetu2 TEXT,
    shutugan_shubetu3 TEXT,
    shutugan_shubetu4 TEXT,
    shutugan_shubetu5 TEXT,
    seiri_no TEXT,
    saishushobun_shubetu TEXT,
    saishushobun_bi TEXT,
    raz_toroku_no TEXT,
    raz_bunkatu_no TEXT,
    bogo_no TEXT,
    toroku_bi TEXT,
    raz_sotugo_su TEXT,
    raz_nenkantugo_su TEXT,
    raz_kohohakko_bi TEXT,
    tantokan_code TEXT,
    pcz_kokaikohohakko_bi TEXT,
    kubun_su TEXT,
    torokusateijikubun_su TEXT,
    hyojunmoji_umu TEXT,
    rittaishohyo_umu TEXT,
    hyoshosikisai_umu TEXT,
    shohyoho3jo2ko_flag TEXT,
    shohyoho5jo4ko_flag TEXT,
    genshutugan_shubetu TEXT,
    genshutuganyonpo_code TEXT,
    genshutugan_no TEXT,
    sokyu_bi TEXT,
    obz_shutugan_no TEXT,
    obz_toroku_no TEXT,
    obz_bunkatu_no TEXT,
    kosintoroku_no TEXT,
    pez_bunkatu_no TEXT,
    pez_bogo_no TEXT,
    kakikaetoroku_no TEXT,
    ktz_bunkatu_no TEXT,
    ktz_bogo_no TEXT,
    krz_kojoryozokuihan_flag TEXT,
    sokisinsa_mark TEXT,
    tekiyohoki_kubun TEXT,
    sinsa_shubetu TEXT,
    sosho_code TEXT,
    satei_shubetu TEXT,
    igiken_su TEXT,
    igiyuko_su TEXT
);

CREATE INDEX IF NOT EXISTS idx_jiken_c_t_yonpo_code ON jiken_c_t(yonpo_code);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_shutugan_no ON jiken_c_t(shutugan_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_yonpo_code_code ON jiken_c_t(yonpo_code);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_shutugan_no_code ON jiken_c_t(shutugan_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_shutugan_shubetu1_code ON jiken_c_t(shutugan_shubetu1);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_shutugan_shubetu2_code ON jiken_c_t(shutugan_shubetu2);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_shutugan_shubetu3_code ON jiken_c_t(shutugan_shubetu3);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_shutugan_shubetu4_code ON jiken_c_t(shutugan_shubetu4);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_shutugan_shubetu5_code ON jiken_c_t(shutugan_shubetu5);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_seiri_no_code ON jiken_c_t(seiri_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_saishushobun_shubetu_code ON jiken_c_t(saishushobun_shubetu);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_raz_toroku_no_code ON jiken_c_t(raz_toroku_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_raz_bunkatu_no_code ON jiken_c_t(raz_bunkatu_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_bogo_no_code ON jiken_c_t(bogo_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_hyojunmoji_umu_code ON jiken_c_t(hyojunmoji_umu);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_rittaishohyo_umu_code ON jiken_c_t(rittaishohyo_umu);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_hyoshosikisai_umu_code ON jiken_c_t(hyoshosikisai_umu);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_shohyoho3jo2ko_flag_code ON jiken_c_t(shohyoho3jo2ko_flag);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_shohyoho5jo4ko_flag_code ON jiken_c_t(shohyoho5jo4ko_flag);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_genshutugan_shubetu_code ON jiken_c_t(genshutugan_shubetu);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_genshutuganyonpo_code_code ON jiken_c_t(genshutuganyonpo_code);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_genshutugan_no_code ON jiken_c_t(genshutugan_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_obz_shutugan_no_code ON jiken_c_t(obz_shutugan_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_obz_toroku_no_code ON jiken_c_t(obz_toroku_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_obz_bunkatu_no_code ON jiken_c_t(obz_bunkatu_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_kosintoroku_no_code ON jiken_c_t(kosintoroku_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_pez_bunkatu_no_code ON jiken_c_t(pez_bunkatu_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_pez_bogo_no_code ON jiken_c_t(pez_bogo_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_kakikaetoroku_no_code ON jiken_c_t(kakikaetoroku_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_ktz_bunkatu_no_code ON jiken_c_t(ktz_bunkatu_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_ktz_bogo_no_code ON jiken_c_t(ktz_bogo_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_krz_kojoryozokuihan_flag_code ON jiken_c_t(krz_kojoryozokuihan_flag);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_sokisinsa_mark_code ON jiken_c_t(sokisinsa_mark);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_tekiyohoki_kubun_code ON jiken_c_t(tekiyohoki_kubun);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_sinsa_shubetu_code ON jiken_c_t(sinsa_shubetu);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_sosho_code_code ON jiken_c_t(sosho_code);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_satei_shubetu_code ON jiken_c_t(satei_shubetu);

-- 事件フォルダ_商標_庁内中間記録ファイル (出願マスタ（意商）)
CREATE TABLE IF NOT EXISTS jiken_c_t_chonai_dv (
    yonpo_code TEXT,
    shutugan_no TEXT,
    folderbetusakusejnj_no TEXT,
    sakusei_bi TEXT,
    chukanshorui_code TEXT,
    taio_mark TEXT,
    chonaishoruisakusei_bi TEXT,
    gyohuku_no TEXT,
    shusso_no TEXT,
    shorui_no TEXT,
    shorui_shubetu TEXT,
    teiseitaishoshorui_no TEXT,
    version_no TEXT
);

CREATE INDEX IF NOT EXISTS idx_jiken_c_t_chonai_dv_yonpo_code ON jiken_c_t_chonai_dv(yonpo_code);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_chonai_dv_shutugan_no ON jiken_c_t_chonai_dv(shutugan_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_chonai_dv_folderbetusakusejnj_no ON jiken_c_t_chonai_dv(folderbetusakusejnj_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_chonai_dv_yonpo_code_code ON jiken_c_t_chonai_dv(yonpo_code);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_chonai_dv_shutugan_no_code ON jiken_c_t_chonai_dv(shutugan_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_chonai_dv_chukanshorui_code_code ON jiken_c_t_chonai_dv(chukanshorui_code);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_chonai_dv_taio_mark_code ON jiken_c_t_chonai_dv(taio_mark);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_chonai_dv_gyohuku_no_code ON jiken_c_t_chonai_dv(gyohuku_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_chonai_dv_shusso_no_code ON jiken_c_t_chonai_dv(shusso_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_chonai_dv_shorui_no_code ON jiken_c_t_chonai_dv(shorui_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_chonai_dv_shorui_shubetu_code ON jiken_c_t_chonai_dv(shorui_shubetu);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_chonai_dv_teiseitaishoshorui_no_code ON jiken_c_t_chonai_dv(teiseitaishoshorui_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_chonai_dv_version_no_code ON jiken_c_t_chonai_dv(version_no);

-- 事件フォルダ_商標_異議情報ファイル (出願マスタ（意商）)
CREATE TABLE IF NOT EXISTS jiken_c_t_igi_joho (
    yonpo_code TEXT,
    shutugan_no TEXT,
    ejz_igi_no TEXT,
    igimositate_bi TEXT,
    igikettei_flag TEXT,
    ejz_junjo_no INTEGER
);

CREATE INDEX IF NOT EXISTS idx_jiken_c_t_igi_joho_yonpo_code ON jiken_c_t_igi_joho(yonpo_code);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_igi_joho_shutugan_no ON jiken_c_t_igi_joho(shutugan_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_igi_joho_ejz_junjo_no ON jiken_c_t_igi_joho(ejz_junjo_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_igi_joho_yonpo_code_code ON jiken_c_t_igi_joho(yonpo_code);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_igi_joho_shutugan_no_code ON jiken_c_t_igi_joho(shutugan_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_igi_joho_ejz_igi_no_code ON jiken_c_t_igi_joho(ejz_igi_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_igi_joho_igikettei_flag_code ON jiken_c_t_igi_joho(igikettei_flag);

-- 事件フォルダ_商標_異議申立人申立代理人情報ファイル (出願マスタ（意商）)
CREATE TABLE IF NOT EXISTS jiken_c_t_igimositatnnmsttdrnn (
    yonpo_code TEXT,
    shutugan_no TEXT,
    igi_no TEXT,
    igimositatnnmsttdrnn_sikbt TEXT,
    igimositatennmsttdrnn_code TEXT,
    giz_kohokan_kubun TEXT,
    giz_kokken_code TEXT,
    jokiigimositatenin_nanmei TEXT,
    igimositatedairinnhk_nanme TEXT,
    igimositatedairinin_shubt TEXT,
    igimositatedairnnskk_shubt TEXT,
    igimositatnnmsttdrnn_jusho TEXT,
    igimositatnnmsttdrnn_simei TEXT,
    giz_junjo_no INTEGER
);

CREATE INDEX IF NOT EXISTS idx_jiken_c_t_igimositatnnmsttdrnn_yonpo_code ON jiken_c_t_igimositatnnmsttdrnn(yonpo_code);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_igimositatnnmsttdrnn_shutugan_no ON jiken_c_t_igimositatnnmsttdrnn(shutugan_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_igimositatnnmsttdrnn_giz_junjo_no ON jiken_c_t_igimositatnnmsttdrnn(giz_junjo_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_igimositatnnmsttdrnn_yonpo_code_code ON jiken_c_t_igimositatnnmsttdrnn(yonpo_code);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_igimositatnnmsttdrnn_shutugan_no_code ON jiken_c_t_igimositatnnmsttdrnn(shutugan_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_igimositatnnmsttdrnn_igi_no_code ON jiken_c_t_igimositatnnmsttdrnn(igi_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_igimositatnnmsttdrnn_igimositatnnmsttdrnn_sikbt_code ON jiken_c_t_igimositatnnmsttdrnn(igimositatnnmsttdrnn_sikbt);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_igimositatnnmsttdrnn_igimositatennmsttdrnn_code_code ON jiken_c_t_igimositatnnmsttdrnn(igimositatennmsttdrnn_code);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_igimositatnnmsttdrnn_giz_kohokan_kubun_code ON jiken_c_t_igimositatnnmsttdrnn(giz_kohokan_kubun);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_igimositatnnmsttdrnn_giz_kokken_code_code ON jiken_c_t_igimositatnnmsttdrnn(giz_kokken_code);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_igimositatnnmsttdrnn_igimositatedairinin_shubt_code ON jiken_c_t_igimositatnnmsttdrnn(igimositatedairinin_shubt);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_igimositatnnmsttdrnn_igimositatedairnnskk_shubt_code ON jiken_c_t_igimositatnnmsttdrnn(igimositatedairnnskk_shubt);

-- 事件フォルダ_商標_起案中間記録ファイル (出願マスタ（意商）)
CREATE TABLE IF NOT EXISTS jiken_c_t_kian_dv (
    yonpo_code TEXT,
    shutugan_no TEXT,
    folderbetusakusejnj_no TEXT,
    sakusei_bi TEXT,
    chukanshorui_code TEXT,
    taio_mark TEXT,
    kian_bi TEXT,
    hasso_bi TEXT,
    aaz_igi_no TEXT,
    shorui_no TEXT,
    kyozeturiyujobun_code TEXT,
    taioshorui_no TEXT,
    shorui_shubetu TEXT,
    version_no TEXT
);

CREATE INDEX IF NOT EXISTS idx_jiken_c_t_kian_dv_yonpo_code ON jiken_c_t_kian_dv(yonpo_code);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_kian_dv_shutugan_no ON jiken_c_t_kian_dv(shutugan_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_kian_dv_folderbetusakusejnj_no ON jiken_c_t_kian_dv(folderbetusakusejnj_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_kian_dv_yonpo_code_code ON jiken_c_t_kian_dv(yonpo_code);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_kian_dv_shutugan_no_code ON jiken_c_t_kian_dv(shutugan_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_kian_dv_chukanshorui_code_code ON jiken_c_t_kian_dv(chukanshorui_code);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_kian_dv_taio_mark_code ON jiken_c_t_kian_dv(taio_mark);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_kian_dv_aaz_igi_no_code ON jiken_c_t_kian_dv(aaz_igi_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_kian_dv_shorui_no_code ON jiken_c_t_kian_dv(shorui_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_kian_dv_kyozeturiyujobun_code_code ON jiken_c_t_kian_dv(kyozeturiyujobun_code);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_kian_dv_taioshorui_no_code ON jiken_c_t_kian_dv(taioshorui_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_kian_dv_shorui_shubetu_code ON jiken_c_t_kian_dv(shorui_shubetu);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_kian_dv_version_no_code ON jiken_c_t_kian_dv(version_no);

-- 事件フォルダ_商標_公報発行情報ファイル (出願マスタ（意商）)
CREATE TABLE IF NOT EXISTS jiken_c_t_kohohako_joho (
    yonpo_code TEXT,
    shutugan_no TEXT,
    jaz_sotugo_su TEXT,
    jaz_nenkantugo_su TEXT,
    jaz_bumonbetutugo_su TEXT,
    jaz_bumonbetunenkantugo_su TEXT,
    jaz_kohohakko_bi TEXT,
    jaz_seigo_sikibetu TEXT,
    jaz_koho_sikibetu TEXT,
    jaz_junjo_no INTEGER
);

CREATE INDEX IF NOT EXISTS idx_jiken_c_t_kohohako_joho_yonpo_code ON jiken_c_t_kohohako_joho(yonpo_code);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_kohohako_joho_shutugan_no ON jiken_c_t_kohohako_joho(shutugan_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_kohohako_joho_jaz_junjo_no ON jiken_c_t_kohohako_joho(jaz_junjo_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_kohohako_joho_yonpo_code_code ON jiken_c_t_kohohako_joho(yonpo_code);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_kohohako_joho_shutugan_no_code ON jiken_c_t_kohohako_joho(shutugan_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_kohohako_joho_jaz_seigo_sikibetu_code ON jiken_c_t_kohohako_joho(jaz_seigo_sikibetu);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_kohohako_joho_jaz_koho_sikibetu_code ON jiken_c_t_kohohako_joho(jaz_koho_sikibetu);

-- 事件フォルダ_商標凍結ファイル (出願マスタ（意商）)
CREATE TABLE IF NOT EXISTS jiken_c_t_old (
    yonpo_code TEXT,
    shutugan_no TEXT,
    kokoku_no TEXT,
    kokoku_bi TEXT,
    paz_sotugo_su TEXT,
    paz_nenkantugo_su TEXT,
    oaz_sotugo_su TEXT,
    oaz_nenkantugo_su TEXT,
    oaz_bumonbetutugo_su TEXT,
    oaz_bumonbetunenkantugo_su TEXT,
    oaz_kohohakko_bi TEXT,
    oaz_seigo_sikibetu TEXT
);

CREATE INDEX IF NOT EXISTS idx_jiken_c_t_old_yonpo_code ON jiken_c_t_old(yonpo_code);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_old_shutugan_no ON jiken_c_t_old(shutugan_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_old_yonpo_code_code ON jiken_c_t_old(yonpo_code);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_old_shutugan_no_code ON jiken_c_t_old(shutugan_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_old_kokoku_no_code ON jiken_c_t_old(kokoku_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_old_oaz_seigo_sikibetu_code ON jiken_c_t_old(oaz_seigo_sikibetu);

-- 事件フォルダ_商標_連合商願情報ファイル (出願マスタ（意商）)
CREATE TABLE IF NOT EXISTS jiken_c_t_rengoshogan_joho (
    yonpo_code TEXT,
    shutugan_no TEXT,
    rengoshutugan_no TEXT,
    tez_junjo_no INTEGER
);

CREATE INDEX IF NOT EXISTS idx_jiken_c_t_rengoshogan_joho_yonpo_code ON jiken_c_t_rengoshogan_joho(yonpo_code);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_rengoshogan_joho_shutugan_no ON jiken_c_t_rengoshogan_joho(shutugan_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_rengoshogan_joho_tez_junjo_no ON jiken_c_t_rengoshogan_joho(tez_junjo_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_rengoshogan_joho_yonpo_code_code ON jiken_c_t_rengoshogan_joho(yonpo_code);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_rengoshogan_joho_shutugan_no_code ON jiken_c_t_rengoshogan_joho(shutugan_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_rengoshogan_joho_rengoshutugan_no_code ON jiken_c_t_rengoshogan_joho(rengoshutugan_no);

-- 事件フォルダ_商標_連合登録番号情報ファイル (出願マスタ（意商）)
CREATE TABLE IF NOT EXISTS jiken_c_t_rengotoroku_joho (
    yonpo_code TEXT,
    shutugan_no TEXT,
    rengotoroku_no TEXT,
    rengotorokubunkatu_no TEXT,
    tbz_junjo_no INTEGER
);

CREATE INDEX IF NOT EXISTS idx_jiken_c_t_rengotoroku_joho_yonpo_code ON jiken_c_t_rengotoroku_joho(yonpo_code);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_rengotoroku_joho_shutugan_no ON jiken_c_t_rengotoroku_joho(shutugan_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_rengotoroku_joho_tbz_junjo_no ON jiken_c_t_rengotoroku_joho(tbz_junjo_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_rengotoroku_joho_yonpo_code_code ON jiken_c_t_rengotoroku_joho(yonpo_code);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_rengotoroku_joho_shutugan_no_code ON jiken_c_t_rengotoroku_joho(shutugan_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_rengotoroku_joho_rengotoroku_no_code ON jiken_c_t_rengotoroku_joho(rengotoroku_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_rengotoroku_joho_rengotorokubunkatu_no_code ON jiken_c_t_rengotoroku_joho(rengotorokubunkatu_no);

-- 事件フォルダ_商標_商品情報ファイル (出願マスタ（意商）)
CREATE TABLE IF NOT EXISTS jiken_c_t_shohin_joho (
    yonpo_code TEXT,
    shutugan_no TEXT,
    rui TEXT,
    lengthchoka_flag TEXT,
    shohinekimumeisho TEXT,
    abz_junjo_no INTEGER
);

CREATE INDEX IF NOT EXISTS idx_jiken_c_t_shohin_joho_yonpo_code ON jiken_c_t_shohin_joho(yonpo_code);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_shohin_joho_shutugan_no ON jiken_c_t_shohin_joho(shutugan_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_shohin_joho_abz_junjo_no ON jiken_c_t_shohin_joho(abz_junjo_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_shohin_joho_yonpo_code_code ON jiken_c_t_shohin_joho(yonpo_code);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_shohin_joho_shutugan_no_code ON jiken_c_t_shohin_joho(shutugan_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_shohin_joho_rui_code ON jiken_c_t_shohin_joho(rui);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_shohin_joho_lengthchoka_flag_code ON jiken_c_t_shohin_joho(lengthchoka_flag);

-- 事件フォルダ_商標_商標の詳細な説明情報ファイル (出願マスタ（意商）)
CREATE TABLE IF NOT EXISTS jiken_c_t_shousaina_setumei (
    yonpo_code TEXT,
    shutugan_no TEXT,
    dtz_rireki_no INTEGER,
    dtz_sakusei_bi TEXT,
    lengthchoka_flag TEXT,
    shohyonoshousaina_setumei TEXT
);

CREATE INDEX IF NOT EXISTS idx_jiken_c_t_shousaina_setumei_yonpo_code ON jiken_c_t_shousaina_setumei(yonpo_code);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_shousaina_setumei_shutugan_no ON jiken_c_t_shousaina_setumei(shutugan_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_shousaina_setumei_dtz_rireki_no ON jiken_c_t_shousaina_setumei(dtz_rireki_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_shousaina_setumei_yonpo_code_code ON jiken_c_t_shousaina_setumei(yonpo_code);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_shousaina_setumei_shutugan_no_code ON jiken_c_t_shousaina_setumei(shutugan_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_shousaina_setumei_lengthchoka_flag_code ON jiken_c_t_shousaina_setumei(lengthchoka_flag);

-- 事件フォルダ_商標_出願人代理人情報ファイル (出願マスタ（意商）)
CREATE TABLE IF NOT EXISTS jiken_c_t_shutugannindairinin (
    yonpo_code TEXT,
    shutugan_no TEXT,
    shutugannindairinin_sikbt TEXT,
    shutugannindairinin_code TEXT,
    gez_henko_no TEXT,
    gez_kohokan_kubun TEXT,
    gez_kokken_code TEXT,
    daihyoshutugannin_sikibetu TEXT,
    jokishutugannin_nanmei TEXT,
    dairininhoka_nanmei TEXT,
    dairinin_shubetu TEXT,
    dairininsikaku_shubetu TEXT,
    shutugannindairinin_jusho TEXT,
    shutugannindairinin_simei TEXT,
    gez_junjo_no INTEGER
);

CREATE INDEX IF NOT EXISTS idx_jiken_c_t_shutugannindairinin_yonpo_code ON jiken_c_t_shutugannindairinin(yonpo_code);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_shutugannindairinin_shutugan_no ON jiken_c_t_shutugannindairinin(shutugan_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_shutugannindairinin_gez_junjo_no ON jiken_c_t_shutugannindairinin(gez_junjo_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_shutugannindairinin_yonpo_code_code ON jiken_c_t_shutugannindairinin(yonpo_code);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_shutugannindairinin_shutugan_no_code ON jiken_c_t_shutugannindairinin(shutugan_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_shutugannindairinin_shutugannindairinin_sikbt_code ON jiken_c_t_shutugannindairinin(shutugannindairinin_sikbt);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_shutugannindairinin_shutugannindairinin_code_code ON jiken_c_t_shutugannindairinin(shutugannindairinin_code);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_shutugannindairinin_gez_kohokan_kubun_code ON jiken_c_t_shutugannindairinin(gez_kohokan_kubun);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_shutugannindairinin_gez_kokken_code_code ON jiken_c_t_shutugannindairinin(gez_kokken_code);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_shutugannindairinin_daihyoshutugannin_sikibetu_code ON jiken_c_t_shutugannindairinin(daihyoshutugannin_sikibetu);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_shutugannindairinin_dairinin_shubetu_code ON jiken_c_t_shutugannindairinin(dairinin_shubetu);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_shutugannindairinin_dairininsikaku_shubetu_code ON jiken_c_t_shutugannindairinin(dairininsikaku_shubetu);

-- 事件フォルダ_商標_申請中間記録ファイル (出願マスタ（意商）)
CREATE TABLE IF NOT EXISTS jiken_c_t_sinsei_dv (
    yonpo_code TEXT,
    shutugan_no TEXT,
    folderbetusakusejnj_no TEXT,
    sakusei_bi TEXT,
    chukanshorui_code TEXT,
    taio_mark TEXT,
    sasidasi_bi TEXT,
    uketuke_bi TEXT,
    aaz_igi_no TEXT,
    shorui_no TEXT,
    hosikikan_mark TEXT,
    sireikan_flag TEXT,
    taioshorui_no TEXT,
    shorui_shubetu TEXT,
    version_no TEXT,
    eturankinsi_flag TEXT
);

CREATE INDEX IF NOT EXISTS idx_jiken_c_t_sinsei_dv_yonpo_code ON jiken_c_t_sinsei_dv(yonpo_code);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_sinsei_dv_shutugan_no ON jiken_c_t_sinsei_dv(shutugan_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_sinsei_dv_folderbetusakusejnj_no ON jiken_c_t_sinsei_dv(folderbetusakusejnj_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_sinsei_dv_yonpo_code_code ON jiken_c_t_sinsei_dv(yonpo_code);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_sinsei_dv_shutugan_no_code ON jiken_c_t_sinsei_dv(shutugan_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_sinsei_dv_chukanshorui_code_code ON jiken_c_t_sinsei_dv(chukanshorui_code);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_sinsei_dv_taio_mark_code ON jiken_c_t_sinsei_dv(taio_mark);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_sinsei_dv_aaz_igi_no_code ON jiken_c_t_sinsei_dv(aaz_igi_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_sinsei_dv_shorui_no_code ON jiken_c_t_sinsei_dv(shorui_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_sinsei_dv_hosikikan_mark_code ON jiken_c_t_sinsei_dv(hosikikan_mark);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_sinsei_dv_sireikan_flag_code ON jiken_c_t_sinsei_dv(sireikan_flag);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_sinsei_dv_taioshorui_no_code ON jiken_c_t_sinsei_dv(taioshorui_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_sinsei_dv_shorui_shubetu_code ON jiken_c_t_sinsei_dv(shorui_shubetu);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_sinsei_dv_version_no_code ON jiken_c_t_sinsei_dv(version_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_sinsei_dv_eturankinsi_flag_code ON jiken_c_t_sinsei_dv(eturankinsi_flag);

-- 事件フォルダ_商標_優先権情報ファイル (出願マスタ（意商）)
CREATE TABLE IF NOT EXISTS jiken_c_t_yusenken_joho (
    yonpo_code TEXT,
    shutugan_no TEXT,
    yusenkenshutugan_no TEXT,
    yusenkenshucho_bi TEXT,
    yusenkenkuni_code TEXT,
    bmz_junjo_no INTEGER
);

CREATE INDEX IF NOT EXISTS idx_jiken_c_t_yusenken_joho_yonpo_code ON jiken_c_t_yusenken_joho(yonpo_code);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_yusenken_joho_shutugan_no ON jiken_c_t_yusenken_joho(shutugan_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_yusenken_joho_bmz_junjo_no ON jiken_c_t_yusenken_joho(bmz_junjo_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_yusenken_joho_yonpo_code_code ON jiken_c_t_yusenken_joho(yonpo_code);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_yusenken_joho_shutugan_no_code ON jiken_c_t_yusenken_joho(shutugan_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_yusenken_joho_yusenkenshutugan_no_code ON jiken_c_t_yusenken_joho(yusenkenshutugan_no);
CREATE INDEX IF NOT EXISTS idx_jiken_c_t_yusenken_joho_yusenkenkuni_code_code ON jiken_c_t_yusenken_joho(yusenkenkuni_code);

-- 参加申請ファイル (審判マスタ)
CREATE TABLE IF NOT EXISTS join_app (
    processing_type VARCHAR(1),
    appl_num VARCHAR(10),
    app_num VARCHAR(2),
    app_dt VARCHAR(8),
    aspect_id VARCHAR(1),
    final_dspst_typ VARCHAR(2),
    updt_dttm VARCHAR(12)
);

CREATE INDEX IF NOT EXISTS idx_join_app_appl_num ON join_app(appl_num);
CREATE INDEX IF NOT EXISTS idx_join_app_app_num ON join_app(app_num);

-- 参加決定分類コードファイル (審判マスタ)
CREATE TABLE IF NOT EXISTS join_app_class_cd (
    processing_type VARCHAR(1),
    appl_num VARCHAR(10),
    join_app_num VARCHAR(2),
    sequence_num SMALLINT,
    law_cd_class VARCHAR(1),
    apply_law_id VARCHAR(1),
    instance_typ VARCHAR(1),
    appl_typ VARCHAR(3),
    jdgmnt_item_cd VARCHAR(3),
    conclusion_cd VARCHAR(3),
    sub_class_id VARCHAR(13),
    litigation_id VARCHAR(1),
    updt_dttm VARCHAR(12)
);

CREATE INDEX IF NOT EXISTS idx_join_app_class_cd_appl_num ON join_app_class_cd(appl_num);
CREATE INDEX IF NOT EXISTS idx_join_app_class_cd_join_app_num ON join_app_class_cd(join_app_num);
CREATE INDEX IF NOT EXISTS idx_join_app_class_cd_sequence_num ON join_app_class_cd(sequence_num);

-- 庁内書類ファイル (審判マスタ)
CREATE TABLE IF NOT EXISTS jpo_doc (
    processing_type VARCHAR(1),
    appl_num VARCHAR(10),
    intrmd_cd VARCHAR(7),
    jpo_doc_num VARCHAR(11),
    dspst_dt VARCHAR(8),
    addr_typ VARCHAR(1),
    addr_num VARCHAR(3),
    crrspnd_rcpt_doc_num VARCHAR(11),
    updt_dttm VARCHAR(12)
);

CREATE INDEX IF NOT EXISTS idx_jpo_doc_appl_num ON jpo_doc(appl_num);
CREATE INDEX IF NOT EXISTS idx_jpo_doc_intrmd_cd ON jpo_doc(intrmd_cd);
CREATE INDEX IF NOT EXISTS idx_jpo_doc_jpo_doc_num ON jpo_doc(jpo_doc_num);

-- 期間延長許可ファイル (共有データベース（審判）)
CREATE TABLE IF NOT EXISTS kkn_entyu_kyk (
    skbt_flg TEXT,
    tyuni_syri_bngu TEXT,
    hssu_syri_bngu TEXT,
    tuhn_hssu_dt TEXT,
    kusn_ntz_bat TEXT
);

CREATE INDEX IF NOT EXISTS idx_kkn_entyu_kyk_tyuni_syri_bngu ON kkn_entyu_kyk(tyuni_syri_bngu);
CREATE INDEX IF NOT EXISTS idx_kkn_entyu_kyk_skbt_flg_code ON kkn_entyu_kyk(skbt_flg);
CREATE INDEX IF NOT EXISTS idx_kkn_entyu_kyk_tyuni_syri_bngu_code ON kkn_entyu_kyk(tyuni_syri_bngu);
CREATE INDEX IF NOT EXISTS idx_kkn_entyu_kyk_hssu_syri_bngu_code ON kkn_entyu_kyk(hssu_syri_bngu);

-- 菌寄託ファイル (共有データベース（審判）)
CREATE TABLE IF NOT EXISTS knktk (
    skbt_flg TEXT,
    snpn_bngu TEXT,
    krkes_bngu INTEGER,
    jtk_kkn_cd TEXT,
    jtk_bngu TEXT,
    kusn_ntz_bat TEXT
);

CREATE INDEX IF NOT EXISTS idx_knktk_snpn_bngu ON knktk(snpn_bngu);
CREATE INDEX IF NOT EXISTS idx_knktk_krkes_bngu ON knktk(krkes_bngu);
CREATE INDEX IF NOT EXISTS idx_knktk_skbt_flg_code ON knktk(skbt_flg);
CREATE INDEX IF NOT EXISTS idx_knktk_snpn_bngu_code ON knktk(snpn_bngu);

-- 公知資料意匠分類Dターム情報ファイル (意匠公知資料マスタ)
CREATE TABLE IF NOT EXISTS known_do_d_class_d_term_info (
    known_doc_num TEXT,
    repeat_num INTEGER,
    main_class_d_term TEXT
);

CREATE INDEX IF NOT EXISTS idx_known_do_d_class_d_term_info_known_doc_num ON known_do_d_class_d_term_info(known_doc_num);
CREATE INDEX IF NOT EXISTS idx_known_do_d_class_d_term_info_repeat_num ON known_do_d_class_d_term_info(repeat_num);
CREATE INDEX IF NOT EXISTS idx_known_do_d_class_d_term_info_known_doc_num_code ON known_do_d_class_d_term_info(known_doc_num);

-- 公知資料書誌ファイル (意匠公知資料マスタ)
CREATE TABLE IF NOT EXISTS known_doc_biblog (
    del_flg TEXT,
    known_doc_num TEXT,
    pub_dt TEXT,
    acpt_dt TEXT,
    known_dt TEXT,
    issu TEXT,
    book TEXT,
    pages TEXT,
    pub_cntry_cd TEXT,
    doc_title TEXT,
    publisher TEXT,
    publisher_addr TEXT,
    goods_name TEXT,
    product_num TEXT,
    catalog_file_name TEXT,
    updt_dt TEXT
);

CREATE INDEX IF NOT EXISTS idx_known_doc_biblog_known_doc_num ON known_doc_biblog(known_doc_num);
CREATE INDEX IF NOT EXISTS idx_known_doc_biblog_known_doc_num_code ON known_doc_biblog(known_doc_num);
CREATE INDEX IF NOT EXISTS idx_known_doc_biblog_pub_cntry_cd_code ON known_doc_biblog(pub_cntry_cd);

-- 公知資料情報ファイル (意匠公知資料マスタ)
CREATE TABLE IF NOT EXISTS known_doc_info (
    del_flg TEXT,
    known_doc_num TEXT,
    search_use_known_dt TEXT,
    updt_dt TEXT
);

CREATE INDEX IF NOT EXISTS idx_known_doc_info_known_doc_num ON known_doc_info(known_doc_num);
CREATE INDEX IF NOT EXISTS idx_known_doc_info_known_doc_num_code ON known_doc_info(known_doc_num);

-- 官報公告ファイル (共有データベース（審判）)
CREATE TABLE IF NOT EXISTS knpu_kukk (
    skbt_flg TEXT,
    tyuni_syri_bngu TEXT,
    hssu_syri_bngu TEXT,
    knpu_kukk_sybn_dt TEXT,
    kusn_ntz_bat TEXT
);

CREATE INDEX IF NOT EXISTS idx_knpu_kukk_tyuni_syri_bngu ON knpu_kukk(tyuni_syri_bngu);
CREATE INDEX IF NOT EXISTS idx_knpu_kukk_skbt_flg_code ON knpu_kukk(skbt_flg);
CREATE INDEX IF NOT EXISTS idx_knpu_kukk_tyuni_syri_bngu_code ON knpu_kukk(tyuni_syri_bngu);
CREATE INDEX IF NOT EXISTS idx_knpu_kukk_hssu_syri_bngu_code ON knpu_kukk(hssu_syri_bngu);

-- 更正決定ファイル (共有データベース（審判）)
CREATE TABLE IF NOT EXISTS kusi_ktti (
    skbt_flg TEXT,
    hssu_syri_bngu TEXT,
    kusi_tisyu_hssu_syri_bngu TEXT,
    kusn_ntz_bat TEXT
);

CREATE INDEX IF NOT EXISTS idx_kusi_ktti_hssu_syri_bngu ON kusi_ktti(hssu_syri_bngu);
CREATE INDEX IF NOT EXISTS idx_kusi_ktti_skbt_flg_code ON kusi_ktti(skbt_flg);
CREATE INDEX IF NOT EXISTS idx_kusi_ktti_hssu_syri_bngu_code ON kusi_ktti(hssu_syri_bngu);
CREATE INDEX IF NOT EXISTS idx_kusi_ktti_kusi_tisyu_hssu_syri_bngu_code ON kusi_ktti(kusi_tisyu_hssu_syri_bngu);

-- 出訴ファイル (審判マスタ)
CREATE TABLE IF NOT EXISTS litigate (
    processing_type VARCHAR(1),
    litigate_case_num_year_issu VARCHAR(2),
    litigate_case_num_year VARCHAR(2),
    litigate_case_num_num VARCHAR(5),
    appl_num VARCHAR(10),
    fnl_appeal_case_no_year_issu VARCHAR(2),
    final_appeal_case_num_year VARCHAR(2),
    final_appeal_case_num_num VARCHAR(5),
    final_appeal_num_year_issu VARCHAR(2),
    final_appeal_num_year VARCHAR(2),
    final_appeal_num_num VARCHAR(5),
    fnl_appeal_acpt_opp_cs_no_yrcd VARCHAR(2),
    fnl_appeal_acpt_opp_cs_no_year VARCHAR(2),
    fnl_appeal_acpt_opp_cse_no_no VARCHAR(5),
    fnl_appeal_acpt_no_year_issu VARCHAR(2),
    final_appeal_accpt_num_year VARCHAR(2),
    final_appeal_accpt_num_num VARCHAR(5),
    litigate_dt VARCHAR(8),
    final_appeal_dt VARCHAR(8),
    div_civil_div_cd VARCHAR(2),
    opp_num VARCHAR(3),
    final_appeal_accpt_opp_dt VARCHAR(8),
    updt_dttm VARCHAR(12)
);

CREATE INDEX IF NOT EXISTS idx_litigate_litigate_case_num_year_issu ON litigate(litigate_case_num_year_issu);
CREATE INDEX IF NOT EXISTS idx_litigate_litigate_case_num_year ON litigate(litigate_case_num_year);
CREATE INDEX IF NOT EXISTS idx_litigate_litigate_case_num_num ON litigate(litigate_case_num_num);
CREATE INDEX IF NOT EXISTS idx_litigate_appl_num ON litigate(appl_num);
CREATE INDEX IF NOT EXISTS idx_litigate_opp_num ON litigate(opp_num);

-- 出訴CNT情報ファイル (審判マスタ)
CREATE TABLE IF NOT EXISTS litigate_cnt (
    processing_type VARCHAR(1),
    litigate_case_num_year_issu VARCHAR(2),
    litigate_case_num_year VARCHAR(2),
    litigate_case_num_num VARCHAR(5),
    litigate_class VARCHAR(1),
    updt_dttm VARCHAR(12)
);

CREATE INDEX IF NOT EXISTS idx_litigate_cnt_litigate_case_num_year_issu ON litigate_cnt(litigate_case_num_year_issu);
CREATE INDEX IF NOT EXISTS idx_litigate_cnt_litigate_case_num_year ON litigate_cnt(litigate_case_num_year);
CREATE INDEX IF NOT EXISTS idx_litigate_cnt_litigate_case_num_num ON litigate_cnt(litigate_case_num_num);
CREATE INDEX IF NOT EXISTS idx_litigate_cnt_litigate_class ON litigate_cnt(litigate_class);

-- マドプロ審判事件固有ファイル (共有データベース（審判）)
CREATE TABLE IF NOT EXISTS madpro_snpn_zkn_kyu (
    skbt_flg TEXT,
    snpn_bngu TEXT,
    tyuni_sir_bngu TEXT,
    bnkt_kgu_cd TEXT,
    kksi_trk_bg_ks_ks_kg_cd TEXT,
    kksi_turk_bngu TEXT,
    kusn_ntz_bat TEXT
);

CREATE INDEX IF NOT EXISTS idx_madpro_snpn_zkn_kyu_snpn_bngu ON madpro_snpn_zkn_kyu(snpn_bngu);
CREATE INDEX IF NOT EXISTS idx_madpro_snpn_zkn_kyu_skbt_flg_code ON madpro_snpn_zkn_kyu(skbt_flg);
CREATE INDEX IF NOT EXISTS idx_madpro_snpn_zkn_kyu_snpn_bngu_code ON madpro_snpn_zkn_kyu(snpn_bngu);
CREATE INDEX IF NOT EXISTS idx_madpro_snpn_zkn_kyu_bnkt_kgu_cd_code ON madpro_snpn_zkn_kyu(bnkt_kgu_cd);
CREATE INDEX IF NOT EXISTS idx_madpro_snpn_zkn_kyu_kksi_trk_bg_ks_ks_kg_cd_code ON madpro_snpn_zkn_kyu(kksi_trk_bg_ks_ks_kg_cd);

-- マドプロ審判事件ファイル (審判マスタ)
CREATE TABLE IF NOT EXISTS madrid_protocol_appl_case (
    processing_type VARCHAR(1),
    appl_num VARCHAR(10),
    app_num VARCHAR(10),
    law_cd_class VARCHAR(1),
    reg_num VARCHAR(7),
    split_num VARCHAR(32),
    smlr_dsgn_num VARCHAR(3),
    sec_num VARCHAR(3),
    appeal_prog_stts VARCHAR(1),
    instance_typ VARCHAR(1),
    appl_typ VARCHAR(3),
    appl_clim_dt VARCHAR(8),
    final_dspst_cd VARCHAR(2),
    final_dspst_define_dt VARCHAR(8),
    updt_dttm VARCHAR(12)
);

CREATE INDEX IF NOT EXISTS idx_madrid_protocol_appl_case_appl_num ON madrid_protocol_appl_case(appl_num);

-- 維持する請求項ファイル (審判マスタ)
CREATE TABLE IF NOT EXISTS maintain_claim (
    processing_type VARCHAR(1),
    appl_num VARCHAR(10),
    apply_class VARCHAR(1),
    opp_num VARCHAR(3),
    sequence_num SMALLINT,
    claim_cd VARCHAR(3),
    updt_dttm VARCHAR(12)
);

CREATE INDEX IF NOT EXISTS idx_maintain_claim_appl_num ON maintain_claim(appl_num);
CREATE INDEX IF NOT EXISTS idx_maintain_claim_apply_class ON maintain_claim(apply_class);
CREATE INDEX IF NOT EXISTS idx_maintain_claim_opp_num ON maintain_claim(opp_num);
CREATE INDEX IF NOT EXISTS idx_maintain_claim_sequence_num ON maintain_claim(sequence_num);

-- マドプロ審判事件固有ファイル (審判マスタ)
CREATE TABLE IF NOT EXISTS md_appl_case_unique_table (
    processing_type VARCHAR(1),
    appl_num VARCHAR(10),
    jpo_rfr_num VARCHAR(10),
    jpo_rfr_num_split_sign_cd VARCHAR(1),
    intl_reg_num_updt_cnt_sign_cd VARCHAR(2),
    intl_reg_num VARCHAR(7),
    intl_num_split_sign_cd VARCHAR(1),
    intl_reg_dt VARCHAR(8),
    aft_desig_dt VARCHAR(8),
    rjct_info_prd_expire_dt VARCHAR(8),
    madopro_class VARCHAR(150),
    litigate_case_num_year_issu VARCHAR(2),
    litigate_case_num_year VARCHAR(2),
    litigate_case_num_num VARCHAR(5),
    litigate_dt VARCHAR(8),
    jdgmnt_give_dt VARCHAR(8),
    Wipo_rlt_doc_flg VARCHAR(1),
    updt_dttm VARCHAR(12)
);

CREATE INDEX IF NOT EXISTS idx_md_appl_case_unique_table_appl_num ON md_appl_case_unique_table(appl_num);

-- 管理情報ファイル(意匠) (登録マスタ)
CREATE TABLE IF NOT EXISTS mgt_info_d (
    processing_type TEXT,
    law_cd TEXT,
    reg_num TEXT,
    split_num TEXT,
    mstr_updt_year_month_day TEXT,
    tscript_inspct_prhbt_flg TEXT,
    conti_prd_expire_ymd TEXT,
    next_pen_pymnt_tm_lmt_ymd TEXT,
    last_pymnt_yearly TEXT,
    share_rate TEXT,
    pblc_prvt_trnsfr_reg_ymd TEXT,
    right_ersr_id TEXT,
    right_disppr_year_month_day TEXT,
    close_orgnl_reg_trnsfr_rec_flg TEXT,
    close_reg_year_month_day TEXT,
    gvrnmnt_relation_id_flg TEXT,
    pen_suppl_flg TEXT,
    prncpl_d_sect_prd TEXT,
    rlt_d_id TEXT,
    div_mn_d_flg TEXT,
    trust_reg_flg TEXT,
    app_num TEXT,
    recvry_num TEXT,
    app_year_month_day TEXT,
    finl_dcsn_year_month_day TEXT,
    trial_dcsn_year_month_day TEXT,
    set_reg_year_month_day TEXT,
    invent_title_etc_len TEXT,
    invent_title_etc TEXT,
    pri_cntry_name_cd TEXT,
    pri_clim_year_month_day TEXT,
    pri_clim_cnt TEXT,
    prnt_app_patent_no_prncpl_d_no TEXT,
    prnt_p_app_ymd__d_reg_ymd TEXT,
    prnt_p_app_exam_pub_d_del_ymd TEXT,
    prncpl_d_app_num TEXT
);

CREATE INDEX IF NOT EXISTS idx_mgt_info_d_law_cd ON mgt_info_d(law_cd);
CREATE INDEX IF NOT EXISTS idx_mgt_info_d_reg_num ON mgt_info_d(reg_num);
CREATE INDEX IF NOT EXISTS idx_mgt_info_d_split_num ON mgt_info_d(split_num);
CREATE INDEX IF NOT EXISTS idx_mgt_info_d_app_num ON mgt_info_d(app_num);
CREATE INDEX IF NOT EXISTS idx_mgt_info_d_processing_type_code ON mgt_info_d(processing_type);
CREATE INDEX IF NOT EXISTS idx_mgt_info_d_law_cd_code ON mgt_info_d(law_cd);
CREATE INDEX IF NOT EXISTS idx_mgt_info_d_reg_num_code ON mgt_info_d(reg_num);
CREATE INDEX IF NOT EXISTS idx_mgt_info_d_split_num_code ON mgt_info_d(split_num);
CREATE INDEX IF NOT EXISTS idx_mgt_info_d_tscript_inspct_prhbt_flg_code ON mgt_info_d(tscript_inspct_prhbt_flg);
CREATE INDEX IF NOT EXISTS idx_mgt_info_d_share_rate_code ON mgt_info_d(share_rate);
CREATE INDEX IF NOT EXISTS idx_mgt_info_d_right_ersr_id_code ON mgt_info_d(right_ersr_id);
CREATE INDEX IF NOT EXISTS idx_mgt_info_d_close_orgnl_reg_trnsfr_rec_flg_code ON mgt_info_d(close_orgnl_reg_trnsfr_rec_flg);
CREATE INDEX IF NOT EXISTS idx_mgt_info_d_gvrnmnt_relation_id_flg_code ON mgt_info_d(gvrnmnt_relation_id_flg);
CREATE INDEX IF NOT EXISTS idx_mgt_info_d_pen_suppl_flg_code ON mgt_info_d(pen_suppl_flg);
CREATE INDEX IF NOT EXISTS idx_mgt_info_d_rlt_d_id_code ON mgt_info_d(rlt_d_id);
CREATE INDEX IF NOT EXISTS idx_mgt_info_d_div_mn_d_flg_code ON mgt_info_d(div_mn_d_flg);
CREATE INDEX IF NOT EXISTS idx_mgt_info_d_trust_reg_flg_code ON mgt_info_d(trust_reg_flg);
CREATE INDEX IF NOT EXISTS idx_mgt_info_d_app_num_code ON mgt_info_d(app_num);
CREATE INDEX IF NOT EXISTS idx_mgt_info_d_recvry_num_code ON mgt_info_d(recvry_num);
CREATE INDEX IF NOT EXISTS idx_mgt_info_d_pri_cntry_name_cd_code ON mgt_info_d(pri_cntry_name_cd);
CREATE INDEX IF NOT EXISTS idx_mgt_info_d_prnt_app_patent_no_prncpl_d_no_code ON mgt_info_d(prnt_app_patent_no_prncpl_d_no);
CREATE INDEX IF NOT EXISTS idx_mgt_info_d_prncpl_d_app_num_code ON mgt_info_d(prncpl_d_app_num);

-- 管理情報ファイル(ハーグ) (登録マスタ)
CREATE TABLE IF NOT EXISTS mgt_info_hague (
    processing_type TEXT,
    law_cd TEXT,
    reg_num TEXT,
    split_num TEXT,
    mstr_updt_year_month_day TEXT,
    tscript_inspct_prhbt_flg TEXT,
    conti_prd_expire_ymd TEXT,
    next_pen_pymnt_tm_lmt_ymd TEXT,
    last_pymnt_yearly TEXT,
    share_rate TEXT,
    pblc_prvt_trnsfr_reg_ymd TEXT,
    right_ersr_id TEXT,
    right_disppr_year_month_day TEXT,
    close_orgnl_reg_trnsfr_rec_flg TEXT,
    close_reg_year_month_day TEXT,
    gvrnmnt_relation_id_flg TEXT,
    pen_suppl_flg TEXT,
    prncpl_d_sect_prd TEXT,
    rlt_d_id TEXT,
    div_mn_d_flg TEXT,
    trust_reg_flg TEXT,
    app_num TEXT,
    recvry_num TEXT,
    app_year_month_day TEXT,
    finl_dcsn_year_month_day TEXT,
    trial_dcsn_year_month_day TEXT,
    set_reg_year_month_day TEXT,
    invent_title_etc_len TEXT,
    invent_title_etc TEXT,
    pri_cntry_name_cd TEXT,
    pri_clim_year_month_day TEXT,
    pri_clim_cnt TEXT,
    prnt_app_patent_no_prncpl_d_no TEXT,
    prnt_p_app_ymd__d_reg_ymd TEXT,
    prnt_p_app_exam_pub_d_del_ymd TEXT,
    prncpl_d_app_num TEXT
);

CREATE INDEX IF NOT EXISTS idx_mgt_info_hague_law_cd ON mgt_info_hague(law_cd);
CREATE INDEX IF NOT EXISTS idx_mgt_info_hague_reg_num ON mgt_info_hague(reg_num);
CREATE INDEX IF NOT EXISTS idx_mgt_info_hague_split_num ON mgt_info_hague(split_num);
CREATE INDEX IF NOT EXISTS idx_mgt_info_hague_app_num ON mgt_info_hague(app_num);
CREATE INDEX IF NOT EXISTS idx_mgt_info_hague_processing_type_code ON mgt_info_hague(processing_type);
CREATE INDEX IF NOT EXISTS idx_mgt_info_hague_law_cd_code ON mgt_info_hague(law_cd);
CREATE INDEX IF NOT EXISTS idx_mgt_info_hague_reg_num_code ON mgt_info_hague(reg_num);
CREATE INDEX IF NOT EXISTS idx_mgt_info_hague_split_num_code ON mgt_info_hague(split_num);
CREATE INDEX IF NOT EXISTS idx_mgt_info_hague_tscript_inspct_prhbt_flg_code ON mgt_info_hague(tscript_inspct_prhbt_flg);
CREATE INDEX IF NOT EXISTS idx_mgt_info_hague_share_rate_code ON mgt_info_hague(share_rate);
CREATE INDEX IF NOT EXISTS idx_mgt_info_hague_right_ersr_id_code ON mgt_info_hague(right_ersr_id);
CREATE INDEX IF NOT EXISTS idx_mgt_info_hague_close_orgnl_reg_trnsfr_rec_flg_code ON mgt_info_hague(close_orgnl_reg_trnsfr_rec_flg);
CREATE INDEX IF NOT EXISTS idx_mgt_info_hague_gvrnmnt_relation_id_flg_code ON mgt_info_hague(gvrnmnt_relation_id_flg);
CREATE INDEX IF NOT EXISTS idx_mgt_info_hague_pen_suppl_flg_code ON mgt_info_hague(pen_suppl_flg);
CREATE INDEX IF NOT EXISTS idx_mgt_info_hague_rlt_d_id_code ON mgt_info_hague(rlt_d_id);
CREATE INDEX IF NOT EXISTS idx_mgt_info_hague_div_mn_d_flg_code ON mgt_info_hague(div_mn_d_flg);
CREATE INDEX IF NOT EXISTS idx_mgt_info_hague_trust_reg_flg_code ON mgt_info_hague(trust_reg_flg);
CREATE INDEX IF NOT EXISTS idx_mgt_info_hague_app_num_code ON mgt_info_hague(app_num);
CREATE INDEX IF NOT EXISTS idx_mgt_info_hague_recvry_num_code ON mgt_info_hague(recvry_num);
CREATE INDEX IF NOT EXISTS idx_mgt_info_hague_pri_cntry_name_cd_code ON mgt_info_hague(pri_cntry_name_cd);
CREATE INDEX IF NOT EXISTS idx_mgt_info_hague_prnt_app_patent_no_prncpl_d_no_code ON mgt_info_hague(prnt_app_patent_no_prncpl_d_no);
CREATE INDEX IF NOT EXISTS idx_mgt_info_hague_prncpl_d_app_num_code ON mgt_info_hague(prncpl_d_app_num);

-- 管理情報ファイル(特許) (登録マスタ)
CREATE TABLE IF NOT EXISTS mgt_info_p (
    processing_type TEXT,
    law_cd TEXT,
    reg_num TEXT,
    split_num TEXT,
    mstr_updt_year_month_day TEXT,
    tscript_inspct_prhbt_flg TEXT,
    conti_prd_expire_ymd TEXT,
    next_pen_pymnt_tm_lmt_ymd TEXT,
    last_pymnt_yearly TEXT,
    share_rate TEXT,
    pblc_prvt_trnsfr_reg_ymd TEXT,
    right_ersr_id TEXT,
    right_disppr_year_month_day TEXT,
    close_orgnl_reg_trnsfr_rec_flg TEXT,
    close_reg_year_month_day TEXT,
    gvrnmnt_relation_id_flg TEXT,
    pen_suppl_flg TEXT,
    trust_reg_flg TEXT,
    app_num TEXT,
    recvry_num TEXT,
    app_year_month_day TEXT,
    app_exam_pub_num TEXT,
    app_exam_pub_year_month_day TEXT,
    finl_dcsn_year_month_day TEXT,
    trial_dcsn_year_month_day TEXT,
    set_reg_year_month_day TEXT,
    invent_cnt_claim_cnt_cls_cnt TEXT,
    invent_title_etc_len TEXT,
    invent_title_etc TEXT,
    pri_cntry_name_cd TEXT,
    pri_clim_year_month_day TEXT,
    pri_clim_cnt TEXT,
    prnt_app_patent_no_prncpl_d_no TEXT,
    prnt_p_app_ymd__d_reg_ymd TEXT,
    prnt_p_app_exam_pub_d_del_ymd TEXT
);

CREATE INDEX IF NOT EXISTS idx_mgt_info_p_law_cd ON mgt_info_p(law_cd);
CREATE INDEX IF NOT EXISTS idx_mgt_info_p_reg_num ON mgt_info_p(reg_num);
CREATE INDEX IF NOT EXISTS idx_mgt_info_p_split_num ON mgt_info_p(split_num);
CREATE INDEX IF NOT EXISTS idx_mgt_info_p_app_num ON mgt_info_p(app_num);
CREATE INDEX IF NOT EXISTS idx_mgt_info_p_processing_type_code ON mgt_info_p(processing_type);
CREATE INDEX IF NOT EXISTS idx_mgt_info_p_law_cd_code ON mgt_info_p(law_cd);
CREATE INDEX IF NOT EXISTS idx_mgt_info_p_reg_num_code ON mgt_info_p(reg_num);
CREATE INDEX IF NOT EXISTS idx_mgt_info_p_split_num_code ON mgt_info_p(split_num);
CREATE INDEX IF NOT EXISTS idx_mgt_info_p_tscript_inspct_prhbt_flg_code ON mgt_info_p(tscript_inspct_prhbt_flg);
CREATE INDEX IF NOT EXISTS idx_mgt_info_p_share_rate_code ON mgt_info_p(share_rate);
CREATE INDEX IF NOT EXISTS idx_mgt_info_p_right_ersr_id_code ON mgt_info_p(right_ersr_id);
CREATE INDEX IF NOT EXISTS idx_mgt_info_p_close_orgnl_reg_trnsfr_rec_flg_code ON mgt_info_p(close_orgnl_reg_trnsfr_rec_flg);
CREATE INDEX IF NOT EXISTS idx_mgt_info_p_gvrnmnt_relation_id_flg_code ON mgt_info_p(gvrnmnt_relation_id_flg);
CREATE INDEX IF NOT EXISTS idx_mgt_info_p_pen_suppl_flg_code ON mgt_info_p(pen_suppl_flg);
CREATE INDEX IF NOT EXISTS idx_mgt_info_p_trust_reg_flg_code ON mgt_info_p(trust_reg_flg);
CREATE INDEX IF NOT EXISTS idx_mgt_info_p_app_num_code ON mgt_info_p(app_num);
CREATE INDEX IF NOT EXISTS idx_mgt_info_p_recvry_num_code ON mgt_info_p(recvry_num);
CREATE INDEX IF NOT EXISTS idx_mgt_info_p_app_exam_pub_num_code ON mgt_info_p(app_exam_pub_num);
CREATE INDEX IF NOT EXISTS idx_mgt_info_p_pri_cntry_name_cd_code ON mgt_info_p(pri_cntry_name_cd);
CREATE INDEX IF NOT EXISTS idx_mgt_info_p_prnt_app_patent_no_prncpl_d_no_code ON mgt_info_p(prnt_app_patent_no_prncpl_d_no);

-- 管理情報ファイル(商標) (登録マスタ)
CREATE TABLE IF NOT EXISTS mgt_info_t (
    processing_type TEXT,
    law_cd TEXT,
    reg_num TEXT,
    split_num TEXT,
    mstr_updt_year_month_day TEXT,
    tscript_inspct_prhbt_flg TEXT,
    conti_prd_expire_ymd TEXT,
    next_pen_pymnt_tm_lmt_ymd TEXT,
    last_pymnt_yearly TEXT,
    share_rate TEXT,
    pblc_prvt_trnsfr_reg_ymd TEXT,
    right_ersr_id TEXT,
    right_disppr_year_month_day TEXT,
    close_orgnl_reg_trnsfr_rec_flg TEXT,
    close_reg_year_month_day TEXT,
    gvrnmnt_relation_id_flg TEXT,
    pen_suppl_flg TEXT,
    apply_law TEXT,
    group_t_flg TEXT,
    special_t_id TEXT,
    standard_char_t_flg TEXT,
    area_group_t_flg TEXT,
    trust_reg_flg TEXT,
    app_num TEXT,
    recvry_num TEXT,
    app_year_month_day TEXT,
    app_exam_pub_num TEXT,
    app_exam_pub_year_month_day TEXT,
    finl_dcsn_year_month_day TEXT,
    trial_dcsn_year_month_day TEXT,
    set_reg_year_month_day TEXT,
    t_rwrt_app_num TEXT,
    t_rwrt_app_year_month_day TEXT,
    t_rwrt_finl_dcsn_ymd TEXT,
    t_rwrt_trial_dcsn_ymd TEXT,
    t_rwrt_reg_year_month_day TEXT,
    invent_title_etc_len TEXT,
    pri_cntry_name_cd TEXT,
    pri_clim_year_month_day TEXT,
    pri_clim_cnt TEXT
);

CREATE INDEX IF NOT EXISTS idx_mgt_info_t_law_cd ON mgt_info_t(law_cd);
CREATE INDEX IF NOT EXISTS idx_mgt_info_t_reg_num ON mgt_info_t(reg_num);
CREATE INDEX IF NOT EXISTS idx_mgt_info_t_split_num ON mgt_info_t(split_num);
CREATE INDEX IF NOT EXISTS idx_mgt_info_t_app_num ON mgt_info_t(app_num);
CREATE INDEX IF NOT EXISTS idx_mgt_info_t_processing_type_code ON mgt_info_t(processing_type);
CREATE INDEX IF NOT EXISTS idx_mgt_info_t_law_cd_code ON mgt_info_t(law_cd);
CREATE INDEX IF NOT EXISTS idx_mgt_info_t_reg_num_code ON mgt_info_t(reg_num);
CREATE INDEX IF NOT EXISTS idx_mgt_info_t_split_num_code ON mgt_info_t(split_num);
CREATE INDEX IF NOT EXISTS idx_mgt_info_t_tscript_inspct_prhbt_flg_code ON mgt_info_t(tscript_inspct_prhbt_flg);
CREATE INDEX IF NOT EXISTS idx_mgt_info_t_share_rate_code ON mgt_info_t(share_rate);
CREATE INDEX IF NOT EXISTS idx_mgt_info_t_right_ersr_id_code ON mgt_info_t(right_ersr_id);
CREATE INDEX IF NOT EXISTS idx_mgt_info_t_close_orgnl_reg_trnsfr_rec_flg_code ON mgt_info_t(close_orgnl_reg_trnsfr_rec_flg);
CREATE INDEX IF NOT EXISTS idx_mgt_info_t_gvrnmnt_relation_id_flg_code ON mgt_info_t(gvrnmnt_relation_id_flg);
CREATE INDEX IF NOT EXISTS idx_mgt_info_t_pen_suppl_flg_code ON mgt_info_t(pen_suppl_flg);
CREATE INDEX IF NOT EXISTS idx_mgt_info_t_apply_law_code ON mgt_info_t(apply_law);
CREATE INDEX IF NOT EXISTS idx_mgt_info_t_group_t_flg_code ON mgt_info_t(group_t_flg);
CREATE INDEX IF NOT EXISTS idx_mgt_info_t_special_t_id_code ON mgt_info_t(special_t_id);
CREATE INDEX IF NOT EXISTS idx_mgt_info_t_standard_char_t_flg_code ON mgt_info_t(standard_char_t_flg);
CREATE INDEX IF NOT EXISTS idx_mgt_info_t_area_group_t_flg_code ON mgt_info_t(area_group_t_flg);
CREATE INDEX IF NOT EXISTS idx_mgt_info_t_trust_reg_flg_code ON mgt_info_t(trust_reg_flg);
CREATE INDEX IF NOT EXISTS idx_mgt_info_t_app_num_code ON mgt_info_t(app_num);
CREATE INDEX IF NOT EXISTS idx_mgt_info_t_recvry_num_code ON mgt_info_t(recvry_num);
CREATE INDEX IF NOT EXISTS idx_mgt_info_t_app_exam_pub_num_code ON mgt_info_t(app_exam_pub_num);
CREATE INDEX IF NOT EXISTS idx_mgt_info_t_t_rwrt_app_num_code ON mgt_info_t(t_rwrt_app_num);
CREATE INDEX IF NOT EXISTS idx_mgt_info_t_pri_cntry_name_cd_code ON mgt_info_t(pri_cntry_name_cd);

-- 管理情報ファイル(実用) (登録マスタ)
CREATE TABLE IF NOT EXISTS mgt_info_u (
    processing_type TEXT,
    law_cd TEXT,
    reg_num TEXT,
    split_num TEXT,
    mstr_updt_year_month_day TEXT,
    tscript_inspct_prhbt_flg TEXT,
    conti_prd_expire_ymd TEXT,
    next_pen_pymnt_tm_lmt_ymd TEXT,
    last_pymnt_yearly TEXT,
    share_rate TEXT,
    pblc_prvt_trnsfr_reg_ymd TEXT,
    right_ersr_id TEXT,
    right_disppr_year_month_day TEXT,
    close_orgnl_reg_trnsfr_rec_flg TEXT,
    close_reg_year_month_day TEXT,
    gvrnmnt_relation_id_flg TEXT,
    pen_suppl_flg TEXT,
    trust_reg_flg TEXT,
    app_num TEXT,
    recvry_num TEXT,
    app_year_month_day TEXT,
    app_exam_pub_num TEXT,
    app_exam_pub_year_month_day TEXT,
    finl_dcsn_year_month_day TEXT,
    trial_dcsn_year_month_day TEXT,
    set_reg_year_month_day TEXT,
    invent_cnt_claim_cnt_cls_cnt TEXT,
    invent_title_etc_len TEXT,
    invent_title_etc TEXT,
    pri_cntry_name_cd TEXT,
    pri_clim_year_month_day TEXT,
    pri_clim_cnt TEXT
);

CREATE INDEX IF NOT EXISTS idx_mgt_info_u_law_cd ON mgt_info_u(law_cd);
CREATE INDEX IF NOT EXISTS idx_mgt_info_u_reg_num ON mgt_info_u(reg_num);
CREATE INDEX IF NOT EXISTS idx_mgt_info_u_split_num ON mgt_info_u(split_num);
CREATE INDEX IF NOT EXISTS idx_mgt_info_u_app_num ON mgt_info_u(app_num);
CREATE INDEX IF NOT EXISTS idx_mgt_info_u_processing_type_code ON mgt_info_u(processing_type);
CREATE INDEX IF NOT EXISTS idx_mgt_info_u_law_cd_code ON mgt_info_u(law_cd);
CREATE INDEX IF NOT EXISTS idx_mgt_info_u_reg_num_code ON mgt_info_u(reg_num);
CREATE INDEX IF NOT EXISTS idx_mgt_info_u_split_num_code ON mgt_info_u(split_num);
CREATE INDEX IF NOT EXISTS idx_mgt_info_u_tscript_inspct_prhbt_flg_code ON mgt_info_u(tscript_inspct_prhbt_flg);
CREATE INDEX IF NOT EXISTS idx_mgt_info_u_share_rate_code ON mgt_info_u(share_rate);
CREATE INDEX IF NOT EXISTS idx_mgt_info_u_right_ersr_id_code ON mgt_info_u(right_ersr_id);
CREATE INDEX IF NOT EXISTS idx_mgt_info_u_close_orgnl_reg_trnsfr_rec_flg_code ON mgt_info_u(close_orgnl_reg_trnsfr_rec_flg);
CREATE INDEX IF NOT EXISTS idx_mgt_info_u_gvrnmnt_relation_id_flg_code ON mgt_info_u(gvrnmnt_relation_id_flg);
CREATE INDEX IF NOT EXISTS idx_mgt_info_u_pen_suppl_flg_code ON mgt_info_u(pen_suppl_flg);
CREATE INDEX IF NOT EXISTS idx_mgt_info_u_trust_reg_flg_code ON mgt_info_u(trust_reg_flg);
CREATE INDEX IF NOT EXISTS idx_mgt_info_u_app_num_code ON mgt_info_u(app_num);
CREATE INDEX IF NOT EXISTS idx_mgt_info_u_recvry_num_code ON mgt_info_u(recvry_num);
CREATE INDEX IF NOT EXISTS idx_mgt_info_u_app_exam_pub_num_code ON mgt_info_u(app_exam_pub_num);
CREATE INDEX IF NOT EXISTS idx_mgt_info_u_pri_cntry_name_cd_code ON mgt_info_u(pri_cntry_name_cd);

-- 欄外延長出願番号ファイル(特許) (登録マスタ)
CREATE TABLE IF NOT EXISTS mrgn_ext_app_num_p (
    processing_type TEXT,
    law_cd TEXT,
    reg_num TEXT,
    split_num TEXT,
    app_num TEXT,
    mrgn_info_upd_ymd TEXT,
    mu_num TEXT,
    mrgn_ext_app_num TEXT
);

CREATE INDEX IF NOT EXISTS idx_mrgn_ext_app_num_p_law_cd ON mrgn_ext_app_num_p(law_cd);
CREATE INDEX IF NOT EXISTS idx_mrgn_ext_app_num_p_reg_num ON mrgn_ext_app_num_p(reg_num);
CREATE INDEX IF NOT EXISTS idx_mrgn_ext_app_num_p_split_num ON mrgn_ext_app_num_p(split_num);
CREATE INDEX IF NOT EXISTS idx_mrgn_ext_app_num_p_app_num ON mrgn_ext_app_num_p(app_num);
CREATE INDEX IF NOT EXISTS idx_mrgn_ext_app_num_p_mu_num ON mrgn_ext_app_num_p(mu_num);
CREATE INDEX IF NOT EXISTS idx_mrgn_ext_app_num_p_processing_type_code ON mrgn_ext_app_num_p(processing_type);
CREATE INDEX IF NOT EXISTS idx_mrgn_ext_app_num_p_law_cd_code ON mrgn_ext_app_num_p(law_cd);
CREATE INDEX IF NOT EXISTS idx_mrgn_ext_app_num_p_reg_num_code ON mrgn_ext_app_num_p(reg_num);
CREATE INDEX IF NOT EXISTS idx_mrgn_ext_app_num_p_split_num_code ON mrgn_ext_app_num_p(split_num);
CREATE INDEX IF NOT EXISTS idx_mrgn_ext_app_num_p_app_num_code ON mrgn_ext_app_num_p(app_num);
CREATE INDEX IF NOT EXISTS idx_mrgn_ext_app_num_p_mu_num_code ON mrgn_ext_app_num_p(mu_num);
CREATE INDEX IF NOT EXISTS idx_mrgn_ext_app_num_p_mrgn_ext_app_num_code ON mrgn_ext_app_num_p(mrgn_ext_app_num);

-- 欄外防護書換情報ファイル (登録マスタ)
CREATE TABLE IF NOT EXISTS mrgn_sec_rwrt_info (
    processing_type TEXT,
    law_cd TEXT,
    reg_num TEXT,
    split_num TEXT,
    app_num TEXT,
    pe_num TEXT,
    mrgn_sec_rwrt_info_upd_ymd TEXT,
    mrgn_sec_rwrt_app_num TEXT,
    mrgn_sec_rwrt_sec_num TEXT
);

CREATE INDEX IF NOT EXISTS idx_mrgn_sec_rwrt_info_law_cd ON mrgn_sec_rwrt_info(law_cd);
CREATE INDEX IF NOT EXISTS idx_mrgn_sec_rwrt_info_reg_num ON mrgn_sec_rwrt_info(reg_num);
CREATE INDEX IF NOT EXISTS idx_mrgn_sec_rwrt_info_split_num ON mrgn_sec_rwrt_info(split_num);
CREATE INDEX IF NOT EXISTS idx_mrgn_sec_rwrt_info_app_num ON mrgn_sec_rwrt_info(app_num);
CREATE INDEX IF NOT EXISTS idx_mrgn_sec_rwrt_info_pe_num ON mrgn_sec_rwrt_info(pe_num);
CREATE INDEX IF NOT EXISTS idx_mrgn_sec_rwrt_info_processing_type_code ON mrgn_sec_rwrt_info(processing_type);
CREATE INDEX IF NOT EXISTS idx_mrgn_sec_rwrt_info_law_cd_code ON mrgn_sec_rwrt_info(law_cd);
CREATE INDEX IF NOT EXISTS idx_mrgn_sec_rwrt_info_reg_num_code ON mrgn_sec_rwrt_info(reg_num);
CREATE INDEX IF NOT EXISTS idx_mrgn_sec_rwrt_info_split_num_code ON mrgn_sec_rwrt_info(split_num);
CREATE INDEX IF NOT EXISTS idx_mrgn_sec_rwrt_info_app_num_code ON mrgn_sec_rwrt_info(app_num);
CREATE INDEX IF NOT EXISTS idx_mrgn_sec_rwrt_info_pe_num_code ON mrgn_sec_rwrt_info(pe_num);
CREATE INDEX IF NOT EXISTS idx_mrgn_sec_rwrt_info_mrgn_sec_rwrt_app_num_code ON mrgn_sec_rwrt_info(mrgn_sec_rwrt_app_num);
CREATE INDEX IF NOT EXISTS idx_mrgn_sec_rwrt_info_mrgn_sec_rwrt_sec_num_code ON mrgn_sec_rwrt_info(mrgn_sec_rwrt_sec_num);

-- 欄外商標書換申請番号ファイル (登録マスタ)
CREATE TABLE IF NOT EXISTS mrgn_t_rwrt_app_num (
    processing_type TEXT,
    law_cd TEXT,
    reg_num TEXT,
    split_num TEXT,
    app_num TEXT,
    mrgn_info_upd_ymd TEXT,
    mu_num TEXT,
    mrgn_t_rwrt_app_num TEXT
);

CREATE INDEX IF NOT EXISTS idx_mrgn_t_rwrt_app_num_law_cd ON mrgn_t_rwrt_app_num(law_cd);
CREATE INDEX IF NOT EXISTS idx_mrgn_t_rwrt_app_num_reg_num ON mrgn_t_rwrt_app_num(reg_num);
CREATE INDEX IF NOT EXISTS idx_mrgn_t_rwrt_app_num_split_num ON mrgn_t_rwrt_app_num(split_num);
CREATE INDEX IF NOT EXISTS idx_mrgn_t_rwrt_app_num_app_num ON mrgn_t_rwrt_app_num(app_num);
CREATE INDEX IF NOT EXISTS idx_mrgn_t_rwrt_app_num_mu_num ON mrgn_t_rwrt_app_num(mu_num);
CREATE INDEX IF NOT EXISTS idx_mrgn_t_rwrt_app_num_processing_type_code ON mrgn_t_rwrt_app_num(processing_type);
CREATE INDEX IF NOT EXISTS idx_mrgn_t_rwrt_app_num_law_cd_code ON mrgn_t_rwrt_app_num(law_cd);
CREATE INDEX IF NOT EXISTS idx_mrgn_t_rwrt_app_num_reg_num_code ON mrgn_t_rwrt_app_num(reg_num);
CREATE INDEX IF NOT EXISTS idx_mrgn_t_rwrt_app_num_split_num_code ON mrgn_t_rwrt_app_num(split_num);
CREATE INDEX IF NOT EXISTS idx_mrgn_t_rwrt_app_num_app_num_code ON mrgn_t_rwrt_app_num(app_num);
CREATE INDEX IF NOT EXISTS idx_mrgn_t_rwrt_app_num_mu_num_code ON mrgn_t_rwrt_app_num(mu_num);
CREATE INDEX IF NOT EXISTS idx_mrgn_t_rwrt_app_num_mrgn_t_rwrt_app_num_code ON mrgn_t_rwrt_app_num(mrgn_t_rwrt_app_num);

-- 申立に係る請求項ファイル (共有データベース（審判）)
CREATE TABLE IF NOT EXISTS mustt_kkr_sikyuku (
    skbt_flg TEXT,
    snpn_bngu TEXT,
    mustt_bngu TEXT,
    krkes_bngu INTEGER,
    sikyuku_bngu INTEGER,
    kusn_ntz_bat TEXT
);

CREATE INDEX IF NOT EXISTS idx_mustt_kkr_sikyuku_snpn_bngu ON mustt_kkr_sikyuku(snpn_bngu);
CREATE INDEX IF NOT EXISTS idx_mustt_kkr_sikyuku_mustt_bngu ON mustt_kkr_sikyuku(mustt_bngu);
CREATE INDEX IF NOT EXISTS idx_mustt_kkr_sikyuku_krkes_bngu ON mustt_kkr_sikyuku(krkes_bngu);
CREATE INDEX IF NOT EXISTS idx_mustt_kkr_sikyuku_skbt_flg_code ON mustt_kkr_sikyuku(skbt_flg);
CREATE INDEX IF NOT EXISTS idx_mustt_kkr_sikyuku_snpn_bngu_code ON mustt_kkr_sikyuku(snpn_bngu);

-- 申立に係る指定商品・役務名ファイル (共有データベース（審判）)
CREATE TABLE IF NOT EXISTS mustt_kkr_sti_syuhn_ekmmi (
    skbt_flg TEXT,
    snpn_bngu TEXT,
    mustt_bngu TEXT,
    mustt_tisyu_syuhn_kbn TEXT,
    mustt_tisyu_sti_syuhn_ekmmi TEXT,
    kusn_ntz_bat TEXT
);

CREATE INDEX IF NOT EXISTS idx_mustt_kkr_sti_syuhn_ekmmi_snpn_bngu ON mustt_kkr_sti_syuhn_ekmmi(snpn_bngu);
CREATE INDEX IF NOT EXISTS idx_mustt_kkr_sti_syuhn_ekmmi_mustt_bngu ON mustt_kkr_sti_syuhn_ekmmi(mustt_bngu);
CREATE INDEX IF NOT EXISTS idx_mustt_kkr_sti_syuhn_ekmmi_mustt_tisyu_syuhn_kbn ON mustt_kkr_sti_syuhn_ekmmi(mustt_tisyu_syuhn_kbn);
CREATE INDEX IF NOT EXISTS idx_mustt_kkr_sti_syuhn_ekmmi_skbt_flg_code ON mustt_kkr_sti_syuhn_ekmmi(skbt_flg);
CREATE INDEX IF NOT EXISTS idx_mustt_kkr_sti_syuhn_ekmmi_snpn_bngu_code ON mustt_kkr_sti_syuhn_ekmmi(snpn_bngu);
CREATE INDEX IF NOT EXISTS idx_mustt_kkr_sti_syuhn_ekmmi_mustt_tisyu_syuhn_kbn_code ON mustt_kkr_sti_syuhn_ekmmi(mustt_tisyu_syuhn_kbn);

-- 非特許書誌ファイル (引用文献マスタ)
CREATE TABLE IF NOT EXISTS non_p_bib (
    del_flg TEXT,
    isn TEXT,
    reg_srl_num TEXT,
    doc_num TEXT,
    doc_class TEXT,
    author_translator_name TEXT,
    monograph_name_title TEXT,
    publication_name TEXT,
    pub_cntry_cd TEXT,
    pub_office_publisher TEXT,
    pub_acpt_year_month_day TEXT,
    year_month_day_flg TEXT,
    ver_num_vol_issu_cnt TEXT,
    citation_page TEXT,
    cd_class TEXT,
    cs_num_business_num_url TEXT
);

CREATE INDEX IF NOT EXISTS idx_non_p_bib_isn ON non_p_bib(isn);
CREATE INDEX IF NOT EXISTS idx_non_p_bib_reg_srl_num ON non_p_bib(reg_srl_num);
CREATE INDEX IF NOT EXISTS idx_non_p_bib_doc_num_code ON non_p_bib(doc_num);
CREATE INDEX IF NOT EXISTS idx_non_p_bib_doc_class_code ON non_p_bib(doc_class);
CREATE INDEX IF NOT EXISTS idx_non_p_bib_pub_cntry_cd_code ON non_p_bib(pub_cntry_cd);
CREATE INDEX IF NOT EXISTS idx_non_p_bib_year_month_day_flg_code ON non_p_bib(year_month_day_flg);

-- 非特許参考文献ファイル (審判マスタ)
CREATE TABLE IF NOT EXISTS non_p_citd_others (
    processing_type VARCHAR(1),
    appl_num VARCHAR(10),
    sequence_num SMALLINT,
    doc_title TEXT,
    updt_dttm VARCHAR(12)
);

CREATE INDEX IF NOT EXISTS idx_non_p_citd_others_appl_num ON non_p_citd_others(appl_num);
CREATE INDEX IF NOT EXISTS idx_non_p_citd_others_sequence_num ON non_p_citd_others(sequence_num);

-- 非特許マスタファイル (引用文献マスタ)
CREATE TABLE IF NOT EXISTS non_p_mstr (
    del_flg TEXT,
    isn TEXT,
    rep_doc_num_pub_exam_pub_num_1 TEXT,
    rep_doc_num_pub_exam_pub_num_2 TEXT,
    rep_doc_num_pub_exam_pub_num_3 TEXT,
    rep_doc_num_pub_exam_pub_num_4 TEXT,
    well_known_dt TEXT
);

CREATE INDEX IF NOT EXISTS idx_non_p_mstr_isn ON non_p_mstr(isn);
CREATE INDEX IF NOT EXISTS idx_non_p_mstr_rep_doc_num_pub_exam_pub_num_1 ON non_p_mstr(rep_doc_num_pub_exam_pub_num_1);
CREATE INDEX IF NOT EXISTS idx_non_p_mstr_rep_doc_num_pub_exam_pub_num_2 ON non_p_mstr(rep_doc_num_pub_exam_pub_num_2);
CREATE INDEX IF NOT EXISTS idx_non_p_mstr_rep_doc_num_pub_exam_pub_num_3 ON non_p_mstr(rep_doc_num_pub_exam_pub_num_3);
CREATE INDEX IF NOT EXISTS idx_non_p_mstr_rep_doc_num_pub_exam_pub_num_4 ON non_p_mstr(rep_doc_num_pub_exam_pub_num_4);
CREATE INDEX IF NOT EXISTS idx_non_p_mstr_rep_doc_num_pub_exam_pub_num_1_code ON non_p_mstr(rep_doc_num_pub_exam_pub_num_1);
CREATE INDEX IF NOT EXISTS idx_non_p_mstr_rep_doc_num_pub_exam_pub_num_2_code ON non_p_mstr(rep_doc_num_pub_exam_pub_num_2);
CREATE INDEX IF NOT EXISTS idx_non_p_mstr_rep_doc_num_pub_exam_pub_num_3_code ON non_p_mstr(rep_doc_num_pub_exam_pub_num_3);
CREATE INDEX IF NOT EXISTS idx_non_p_mstr_rep_doc_num_pub_exam_pub_num_4_code ON non_p_mstr(rep_doc_num_pub_exam_pub_num_4);

-- 非特許マスタ_ファセットファイル (引用文献マスタ)
CREATE TABLE IF NOT EXISTS non_p_mstr_facet (
    isn TEXT,
    app_num TEXT,
    rep_doc_num_pub_exam_pub_num_1 TEXT,
    rep_doc_num_pub_exam_pub_num_2 TEXT,
    rep_doc_num_pub_exam_pub_num_3 TEXT,
    rep_doc_num_pub_exam_pub_num_4 TEXT,
    repeat_num INTEGER,
    facet TEXT
);

CREATE INDEX IF NOT EXISTS idx_non_p_mstr_facet_isn ON non_p_mstr_facet(isn);
CREATE INDEX IF NOT EXISTS idx_non_p_mstr_facet_app_num ON non_p_mstr_facet(app_num);
CREATE INDEX IF NOT EXISTS idx_non_p_mstr_facet_rep_doc_num_pub_exam_pub_num_1 ON non_p_mstr_facet(rep_doc_num_pub_exam_pub_num_1);
CREATE INDEX IF NOT EXISTS idx_non_p_mstr_facet_rep_doc_num_pub_exam_pub_num_2 ON non_p_mstr_facet(rep_doc_num_pub_exam_pub_num_2);
CREATE INDEX IF NOT EXISTS idx_non_p_mstr_facet_rep_doc_num_pub_exam_pub_num_3 ON non_p_mstr_facet(rep_doc_num_pub_exam_pub_num_3);
CREATE INDEX IF NOT EXISTS idx_non_p_mstr_facet_rep_doc_num_pub_exam_pub_num_4 ON non_p_mstr_facet(rep_doc_num_pub_exam_pub_num_4);
CREATE INDEX IF NOT EXISTS idx_non_p_mstr_facet_repeat_num ON non_p_mstr_facet(repeat_num);
CREATE INDEX IF NOT EXISTS idx_non_p_mstr_facet_app_num_code ON non_p_mstr_facet(app_num);
CREATE INDEX IF NOT EXISTS idx_non_p_mstr_facet_rep_doc_num_pub_exam_pub_num_1_code ON non_p_mstr_facet(rep_doc_num_pub_exam_pub_num_1);
CREATE INDEX IF NOT EXISTS idx_non_p_mstr_facet_rep_doc_num_pub_exam_pub_num_2_code ON non_p_mstr_facet(rep_doc_num_pub_exam_pub_num_2);
CREATE INDEX IF NOT EXISTS idx_non_p_mstr_facet_rep_doc_num_pub_exam_pub_num_3_code ON non_p_mstr_facet(rep_doc_num_pub_exam_pub_num_3);
CREATE INDEX IF NOT EXISTS idx_non_p_mstr_facet_rep_doc_num_pub_exam_pub_num_4_code ON non_p_mstr_facet(rep_doc_num_pub_exam_pub_num_4);

-- 新規性喪失例外ファイル (審判マスタ)
CREATE TABLE IF NOT EXISTS novelty_lack (
    processing_type VARCHAR(1),
    appl_num VARCHAR(10),
    sequence_num SMALLINT,
    art_cd VARCHAR(1),
    detail TEXT,
    updt_dttm VARCHAR(12)
);

CREATE INDEX IF NOT EXISTS idx_novelty_lack_appl_num ON novelty_lack(appl_num);
CREATE INDEX IF NOT EXISTS idx_novelty_lack_sequence_num ON novelty_lack(sequence_num);

-- 異議申立ファイル (審判マスタ)
CREATE TABLE IF NOT EXISTS opp (
    processing_type VARCHAR(1),
    appl_num VARCHAR(10),
    opp_num VARCHAR(3),
    opp_dt VARCHAR(8),
    final_dspst_cd VARCHAR(2),
    final_dspst_define_dt VARCHAR(8),
    updt_dttm VARCHAR(12)
);

CREATE INDEX IF NOT EXISTS idx_opp_appl_num ON opp(appl_num);
CREATE INDEX IF NOT EXISTS idx_opp_opp_num ON opp(opp_num);

-- 異議申立分類コードファイル (審判マスタ)
CREATE TABLE IF NOT EXISTS opp_class_cd (
    processing_type VARCHAR(1),
    appl_num VARCHAR(10),
    opp_num VARCHAR(3),
    sequence_num SMALLINT,
    law_cd_class VARCHAR(1),
    apply_law_id VARCHAR(1),
    instance_typ VARCHAR(1),
    appl_typ VARCHAR(3),
    jdgmn_item_cd VARCHAR(3),
    conclusion_cd VARCHAR(3),
    sub_class_id VARCHAR(13),
    litigation_id VARCHAR(1),
    updt_dttm VARCHAR(12)
);

CREATE INDEX IF NOT EXISTS idx_opp_class_cd_appl_num ON opp_class_cd(appl_num);
CREATE INDEX IF NOT EXISTS idx_opp_class_cd_opp_num ON opp_class_cd(opp_num);
CREATE INDEX IF NOT EXISTS idx_opp_class_cd_sequence_num ON opp_class_cd(sequence_num);

-- 申立に係る指定商品名ファイル (審判マスタ)
CREATE TABLE IF NOT EXISTS opp_desig_goods_name (
    processing_type VARCHAR(1),
    appl_num VARCHAR(10),
    opp_num VARCHAR(3),
    goods_class VARCHAR(2),
    desig_goods_name TEXT,
    updt_dttm VARCHAR(12)
);

CREATE INDEX IF NOT EXISTS idx_opp_desig_goods_name_appl_num ON opp_desig_goods_name(appl_num);
CREATE INDEX IF NOT EXISTS idx_opp_desig_goods_name_opp_num ON opp_desig_goods_name(opp_num);
CREATE INDEX IF NOT EXISTS idx_opp_desig_goods_name_goods_class ON opp_desig_goods_name(goods_class);

-- 特許参考文献ファイル (審判マスタ)
CREATE TABLE IF NOT EXISTS p_citd_others (
    processing_type VARCHAR(1),
    appl_num VARCHAR(10),
    sequence_num SMALLINT,
    doc_title VARCHAR(126),
    updt_dttm VARCHAR(12)
);

CREATE INDEX IF NOT EXISTS idx_p_citd_others_appl_num ON p_citd_others(appl_num);
CREATE INDEX IF NOT EXISTS idx_p_citd_others_sequence_num ON p_citd_others(sequence_num);

-- 特許出願人発の事件書誌ファイル (出願マスタ（特実）)
CREATE TABLE IF NOT EXISTS pmab_g_appl_case_biblog (
    law_cd TEXT,
    app_num TEXT,
    ab_delete_flg TEXT,
    ab_update_dttm TEXT,
    abcn_delete_flg TEXT,
    abcn_app_claim_cnt INTEGER,
    abcn_exam_pub_claim_cnt INTEGER,
    abcn_reg_claim_cnt INTEGER,
    abrt_delete_flg TEXT,
    abrt_right_trf TEXT,
    abrt_license_permission TEXT,
    abpp_delete_flg TEXT,
    abip_delete_flg TEXT,
    abna_delete_flg TEXT,
    abpa_delete_flg TEXT,
    abpa_parent_app_typ TEXT,
    abpa_parent_app_law_cd TEXT,
    abpa_parent_app_num TEXT,
    abpa_retroacted_dt TEXT,
    abin_delete_flg TEXT,
    abin_invent_title TEXT,
    abaa_delete_flg TEXT,
    abii_delete_flg TEXT,
    abti_delete_flg TEXT,
    abds_delete_flg TEXT,
    abpl_delete_flg TEXT,
    abpl_dspst_content TEXT,
    abpl_patent_num TEXT,
    abpl_dspst_dt TEXT,
    abpl_ext_period TEXT,
    abli_delete_flg TEXT,
    abdp_delete_flg TEXT,
    abnl_delete_flg TEXT,
    abnl_novelty_lack_class TEXT,
    abae_delete_flg TEXT,
    abct_delete_flg TEXT,
    aban_delete_flg TEXT
);

CREATE INDEX IF NOT EXISTS idx_pmab_g_appl_case_biblog_law_cd ON pmab_g_appl_case_biblog(law_cd);
CREATE INDEX IF NOT EXISTS idx_pmab_g_appl_case_biblog_app_num ON pmab_g_appl_case_biblog(app_num);
CREATE INDEX IF NOT EXISTS idx_pmab_g_appl_case_biblog_law_cd_code ON pmab_g_appl_case_biblog(law_cd);
CREATE INDEX IF NOT EXISTS idx_pmab_g_appl_case_biblog_app_num_code ON pmab_g_appl_case_biblog(app_num);
CREATE INDEX IF NOT EXISTS idx_pmab_g_appl_case_biblog_ab_delete_flg_code ON pmab_g_appl_case_biblog(ab_delete_flg);
CREATE INDEX IF NOT EXISTS idx_pmab_g_appl_case_biblog_abcn_delete_flg_code ON pmab_g_appl_case_biblog(abcn_delete_flg);
CREATE INDEX IF NOT EXISTS idx_pmab_g_appl_case_biblog_abrt_delete_flg_code ON pmab_g_appl_case_biblog(abrt_delete_flg);
CREATE INDEX IF NOT EXISTS idx_pmab_g_appl_case_biblog_abrt_right_trf_code ON pmab_g_appl_case_biblog(abrt_right_trf);
CREATE INDEX IF NOT EXISTS idx_pmab_g_appl_case_biblog_abrt_license_permission_code ON pmab_g_appl_case_biblog(abrt_license_permission);
CREATE INDEX IF NOT EXISTS idx_pmab_g_appl_case_biblog_abpp_delete_flg_code ON pmab_g_appl_case_biblog(abpp_delete_flg);
CREATE INDEX IF NOT EXISTS idx_pmab_g_appl_case_biblog_abip_delete_flg_code ON pmab_g_appl_case_biblog(abip_delete_flg);
CREATE INDEX IF NOT EXISTS idx_pmab_g_appl_case_biblog_abna_delete_flg_code ON pmab_g_appl_case_biblog(abna_delete_flg);
CREATE INDEX IF NOT EXISTS idx_pmab_g_appl_case_biblog_abpa_delete_flg_code ON pmab_g_appl_case_biblog(abpa_delete_flg);
CREATE INDEX IF NOT EXISTS idx_pmab_g_appl_case_biblog_abpa_parent_app_typ_code ON pmab_g_appl_case_biblog(abpa_parent_app_typ);
CREATE INDEX IF NOT EXISTS idx_pmab_g_appl_case_biblog_abpa_parent_app_law_cd_code ON pmab_g_appl_case_biblog(abpa_parent_app_law_cd);
CREATE INDEX IF NOT EXISTS idx_pmab_g_appl_case_biblog_abpa_parent_app_num_code ON pmab_g_appl_case_biblog(abpa_parent_app_num);
CREATE INDEX IF NOT EXISTS idx_pmab_g_appl_case_biblog_abin_delete_flg_code ON pmab_g_appl_case_biblog(abin_delete_flg);
CREATE INDEX IF NOT EXISTS idx_pmab_g_appl_case_biblog_abaa_delete_flg_code ON pmab_g_appl_case_biblog(abaa_delete_flg);
CREATE INDEX IF NOT EXISTS idx_pmab_g_appl_case_biblog_abii_delete_flg_code ON pmab_g_appl_case_biblog(abii_delete_flg);
CREATE INDEX IF NOT EXISTS idx_pmab_g_appl_case_biblog_abti_delete_flg_code ON pmab_g_appl_case_biblog(abti_delete_flg);
CREATE INDEX IF NOT EXISTS idx_pmab_g_appl_case_biblog_abds_delete_flg_code ON pmab_g_appl_case_biblog(abds_delete_flg);
CREATE INDEX IF NOT EXISTS idx_pmab_g_appl_case_biblog_abpl_delete_flg_code ON pmab_g_appl_case_biblog(abpl_delete_flg);
CREATE INDEX IF NOT EXISTS idx_pmab_g_appl_case_biblog_abpl_patent_num_code ON pmab_g_appl_case_biblog(abpl_patent_num);
CREATE INDEX IF NOT EXISTS idx_pmab_g_appl_case_biblog_abli_delete_flg_code ON pmab_g_appl_case_biblog(abli_delete_flg);
CREATE INDEX IF NOT EXISTS idx_pmab_g_appl_case_biblog_abdp_delete_flg_code ON pmab_g_appl_case_biblog(abdp_delete_flg);
CREATE INDEX IF NOT EXISTS idx_pmab_g_appl_case_biblog_abnl_delete_flg_code ON pmab_g_appl_case_biblog(abnl_delete_flg);
CREATE INDEX IF NOT EXISTS idx_pmab_g_appl_case_biblog_abnl_novelty_lack_class_code ON pmab_g_appl_case_biblog(abnl_novelty_lack_class);
CREATE INDEX IF NOT EXISTS idx_pmab_g_appl_case_biblog_abae_delete_flg_code ON pmab_g_appl_case_biblog(abae_delete_flg);
CREATE INDEX IF NOT EXISTS idx_pmab_g_appl_case_biblog_abct_delete_flg_code ON pmab_g_appl_case_biblog(abct_delete_flg);
CREATE INDEX IF NOT EXISTS idx_pmab_g_appl_case_biblog_aban_delete_flg_code ON pmab_g_appl_case_biblog(aban_delete_flg);

-- 特許出願人発の事件書誌繰返データファイル (出願マスタ（特実）)
CREATE TABLE IF NOT EXISTS pmab_gr_appl_case_biblog (
    law_cd TEXT,
    app_num TEXT,
    article_id TEXT,
    repeat_num INTEGER,
    abpp_pri_app_num TEXT,
    abpp_pri_claim_dt TEXT,
    abpp_pri_cntry_cd TEXT,
    abip_intnl_pri_law_cd TEXT,
    abip_intnl_pri_app_num TEXT,
    abip_intl_app_num TEXT,
    abip_claim_dt TEXT,
    abna_newapp_app_typ TEXT,
    abna_newapp_law_cd TEXT,
    abna_newapp_app_num TEXT,
    abaa_appl_atty_class TEXT,
    abaa_appl_atty_id TEXT,
    abaa_change_num TEXT,
    abaa_req_typ TEXT,
    abaa_nationality_cd TEXT,
    abaa_pref_cd TEXT,
    abaa_rep_appl_id TEXT,
    abaa_above_appl_cnt INTEGER,
    abaa_atty_other_cnt INTEGER,
    abaa_atty_typ_cd TEXT,
    abaa_atty_qualify_cd TEXT,
    abaa_crrspnd_num TEXT,
    abii_inventor_name TEXT,
    abii_inventor_addr TEXT,
    abti_trust_typ TEXT,
    abti_nationality_cd TEXT,
    abti_name TEXT,
    abti_addr TEXT,
    abds_design_state_cd TEXT,
    abds_regional_patent_mk TEXT,
    abli_later_pri_law_cd TEXT,
    abli_later_pri_app_num TEXT,
    abli_later_pri_app_dt TEXT,
    abdp_mcrb_dpst_instt_id TEXT,
    abdp_mcrb_dpst_num TEXT,
    abnl_novelty_lack_art_cd TEXT,
    abnl_novelty_lack_content TEXT,
    abae_crrspnd_num TEXT,
    abae_appl_atty_addr TEXT,
    abae_appl_atty_name TEXT,
    abct_clmt_atty_class TEXT,
    abct_clmt_atty_id TEXT,
    abct_change_num TEXT,
    abct_req_typ TEXT,
    abct_pref_cd TEXT,
    abct_rep_clmt_id TEXT,
    abct_atty_typ_cd TEXT,
    abct_crrspnd_num TEXT,
    aban_crrspnd_num TEXT,
    aban_clmt_atty_addr TEXT,
    aban_clmt_atty_name TEXT
);

CREATE INDEX IF NOT EXISTS idx_pmab_gr_appl_case_biblog_law_cd ON pmab_gr_appl_case_biblog(law_cd);
CREATE INDEX IF NOT EXISTS idx_pmab_gr_appl_case_biblog_app_num ON pmab_gr_appl_case_biblog(app_num);
CREATE INDEX IF NOT EXISTS idx_pmab_gr_appl_case_biblog_article_id ON pmab_gr_appl_case_biblog(article_id);
CREATE INDEX IF NOT EXISTS idx_pmab_gr_appl_case_biblog_repeat_num ON pmab_gr_appl_case_biblog(repeat_num);
CREATE INDEX IF NOT EXISTS idx_pmab_gr_appl_case_biblog_law_cd_code ON pmab_gr_appl_case_biblog(law_cd);
CREATE INDEX IF NOT EXISTS idx_pmab_gr_appl_case_biblog_app_num_code ON pmab_gr_appl_case_biblog(app_num);
CREATE INDEX IF NOT EXISTS idx_pmab_gr_appl_case_biblog_article_id_code ON pmab_gr_appl_case_biblog(article_id);
CREATE INDEX IF NOT EXISTS idx_pmab_gr_appl_case_biblog_abpp_pri_app_num_code ON pmab_gr_appl_case_biblog(abpp_pri_app_num);
CREATE INDEX IF NOT EXISTS idx_pmab_gr_appl_case_biblog_abpp_pri_cntry_cd_code ON pmab_gr_appl_case_biblog(abpp_pri_cntry_cd);
CREATE INDEX IF NOT EXISTS idx_pmab_gr_appl_case_biblog_abip_intnl_pri_law_cd_code ON pmab_gr_appl_case_biblog(abip_intnl_pri_law_cd);
CREATE INDEX IF NOT EXISTS idx_pmab_gr_appl_case_biblog_abip_intnl_pri_app_num_code ON pmab_gr_appl_case_biblog(abip_intnl_pri_app_num);
CREATE INDEX IF NOT EXISTS idx_pmab_gr_appl_case_biblog_abip_intl_app_num_code ON pmab_gr_appl_case_biblog(abip_intl_app_num);
CREATE INDEX IF NOT EXISTS idx_pmab_gr_appl_case_biblog_abna_newapp_app_typ_code ON pmab_gr_appl_case_biblog(abna_newapp_app_typ);
CREATE INDEX IF NOT EXISTS idx_pmab_gr_appl_case_biblog_abna_newapp_law_cd_code ON pmab_gr_appl_case_biblog(abna_newapp_law_cd);
CREATE INDEX IF NOT EXISTS idx_pmab_gr_appl_case_biblog_abna_newapp_app_num_code ON pmab_gr_appl_case_biblog(abna_newapp_app_num);
CREATE INDEX IF NOT EXISTS idx_pmab_gr_appl_case_biblog_abaa_appl_atty_class_code ON pmab_gr_appl_case_biblog(abaa_appl_atty_class);
CREATE INDEX IF NOT EXISTS idx_pmab_gr_appl_case_biblog_abaa_appl_atty_id_code ON pmab_gr_appl_case_biblog(abaa_appl_atty_id);
CREATE INDEX IF NOT EXISTS idx_pmab_gr_appl_case_biblog_abaa_req_typ_code ON pmab_gr_appl_case_biblog(abaa_req_typ);
CREATE INDEX IF NOT EXISTS idx_pmab_gr_appl_case_biblog_abaa_nationality_cd_code ON pmab_gr_appl_case_biblog(abaa_nationality_cd);
CREATE INDEX IF NOT EXISTS idx_pmab_gr_appl_case_biblog_abaa_pref_cd_code ON pmab_gr_appl_case_biblog(abaa_pref_cd);
CREATE INDEX IF NOT EXISTS idx_pmab_gr_appl_case_biblog_abaa_rep_appl_id_code ON pmab_gr_appl_case_biblog(abaa_rep_appl_id);
CREATE INDEX IF NOT EXISTS idx_pmab_gr_appl_case_biblog_abaa_atty_typ_cd_code ON pmab_gr_appl_case_biblog(abaa_atty_typ_cd);
CREATE INDEX IF NOT EXISTS idx_pmab_gr_appl_case_biblog_abaa_atty_qualify_cd_code ON pmab_gr_appl_case_biblog(abaa_atty_qualify_cd);
CREATE INDEX IF NOT EXISTS idx_pmab_gr_appl_case_biblog_abaa_crrspnd_num_code ON pmab_gr_appl_case_biblog(abaa_crrspnd_num);
CREATE INDEX IF NOT EXISTS idx_pmab_gr_appl_case_biblog_abti_trust_typ_code ON pmab_gr_appl_case_biblog(abti_trust_typ);
CREATE INDEX IF NOT EXISTS idx_pmab_gr_appl_case_biblog_abti_nationality_cd_code ON pmab_gr_appl_case_biblog(abti_nationality_cd);
CREATE INDEX IF NOT EXISTS idx_pmab_gr_appl_case_biblog_abds_design_state_cd_code ON pmab_gr_appl_case_biblog(abds_design_state_cd);
CREATE INDEX IF NOT EXISTS idx_pmab_gr_appl_case_biblog_abds_regional_patent_mk_code ON pmab_gr_appl_case_biblog(abds_regional_patent_mk);
CREATE INDEX IF NOT EXISTS idx_pmab_gr_appl_case_biblog_abli_later_pri_law_cd_code ON pmab_gr_appl_case_biblog(abli_later_pri_law_cd);
CREATE INDEX IF NOT EXISTS idx_pmab_gr_appl_case_biblog_abli_later_pri_app_num_code ON pmab_gr_appl_case_biblog(abli_later_pri_app_num);
CREATE INDEX IF NOT EXISTS idx_pmab_gr_appl_case_biblog_abdp_mcrb_dpst_instt_id_code ON pmab_gr_appl_case_biblog(abdp_mcrb_dpst_instt_id);
CREATE INDEX IF NOT EXISTS idx_pmab_gr_appl_case_biblog_abdp_mcrb_dpst_num_code ON pmab_gr_appl_case_biblog(abdp_mcrb_dpst_num);
CREATE INDEX IF NOT EXISTS idx_pmab_gr_appl_case_biblog_abnl_novelty_lack_art_cd_code ON pmab_gr_appl_case_biblog(abnl_novelty_lack_art_cd);
CREATE INDEX IF NOT EXISTS idx_pmab_gr_appl_case_biblog_abae_crrspnd_num_code ON pmab_gr_appl_case_biblog(abae_crrspnd_num);
CREATE INDEX IF NOT EXISTS idx_pmab_gr_appl_case_biblog_abct_clmt_atty_class_code ON pmab_gr_appl_case_biblog(abct_clmt_atty_class);
CREATE INDEX IF NOT EXISTS idx_pmab_gr_appl_case_biblog_abct_clmt_atty_id_code ON pmab_gr_appl_case_biblog(abct_clmt_atty_id);
CREATE INDEX IF NOT EXISTS idx_pmab_gr_appl_case_biblog_abct_req_typ_code ON pmab_gr_appl_case_biblog(abct_req_typ);
CREATE INDEX IF NOT EXISTS idx_pmab_gr_appl_case_biblog_abct_pref_cd_code ON pmab_gr_appl_case_biblog(abct_pref_cd);
CREATE INDEX IF NOT EXISTS idx_pmab_gr_appl_case_biblog_abct_rep_clmt_id_code ON pmab_gr_appl_case_biblog(abct_rep_clmt_id);
CREATE INDEX IF NOT EXISTS idx_pmab_gr_appl_case_biblog_abct_atty_typ_cd_code ON pmab_gr_appl_case_biblog(abct_atty_typ_cd);
CREATE INDEX IF NOT EXISTS idx_pmab_gr_appl_case_biblog_abct_crrspnd_num_code ON pmab_gr_appl_case_biblog(abct_crrspnd_num);
CREATE INDEX IF NOT EXISTS idx_pmab_gr_appl_case_biblog_aban_crrspnd_num_code ON pmab_gr_appl_case_biblog(aban_crrspnd_num);

-- 特許出願事件ファイル (出願マスタ（特実）)
CREATE TABLE IF NOT EXISTS pmac_g_app_case (
    law_cd TEXT,
    app_num TEXT,
    ac_delete_flg TEXT,
    ac_update_dttm TEXT,
    acai_delete_flg TEXT,
    acai_app_dt TEXT,
    acai_app_typ_1 TEXT,
    acai_app_typ_2 TEXT,
    acai_app_typ_3 TEXT,
    acai_app_typ_4 TEXT,
    acai_app_typ_5 TEXT,
    acai_refer_num TEXT,
    acai_org_lang_app_flg TEXT,
    acup_delete_flg TEXT,
    acup_pub_num TEXT,
    acup_pub_dt TEXT,
    actp_delete_flg TEXT,
    actp_trnsl_pub_num TEXT,
    actp_trnsl_pub_dt TEXT,
    actp_trnsl_repub_dt TEXT,
    acap_delete_flg TEXT,
    acld_delete_flg TEXT,
    acld_final_dspst_typ TEXT,
    acld_final_dspst_dt TEXT,
    acrg_delete_flg TEXT,
    acrg_reg_num TEXT,
    acrg_reg_dt TEXT,
    acrb_delete_flg TEXT,
    acrb_reg_bul_publish_dt TEXT,
    acia_delete_flg TEXT,
    acia_intl_app_num TEXT,
    acia_intl_pub_num TEXT,
    acia_intl_pub_dt TEXT,
    acia_trnsl_submit_dt TEXT,
    acia_lang_flg TEXT
);

CREATE INDEX IF NOT EXISTS idx_pmac_g_app_case_law_cd ON pmac_g_app_case(law_cd);
CREATE INDEX IF NOT EXISTS idx_pmac_g_app_case_app_num ON pmac_g_app_case(app_num);
CREATE INDEX IF NOT EXISTS idx_pmac_g_app_case_law_cd_code ON pmac_g_app_case(law_cd);
CREATE INDEX IF NOT EXISTS idx_pmac_g_app_case_app_num_code ON pmac_g_app_case(app_num);
CREATE INDEX IF NOT EXISTS idx_pmac_g_app_case_ac_delete_flg_code ON pmac_g_app_case(ac_delete_flg);
CREATE INDEX IF NOT EXISTS idx_pmac_g_app_case_acai_delete_flg_code ON pmac_g_app_case(acai_delete_flg);
CREATE INDEX IF NOT EXISTS idx_pmac_g_app_case_acai_app_typ_1_code ON pmac_g_app_case(acai_app_typ_1);
CREATE INDEX IF NOT EXISTS idx_pmac_g_app_case_acai_app_typ_2_code ON pmac_g_app_case(acai_app_typ_2);
CREATE INDEX IF NOT EXISTS idx_pmac_g_app_case_acai_app_typ_3_code ON pmac_g_app_case(acai_app_typ_3);
CREATE INDEX IF NOT EXISTS idx_pmac_g_app_case_acai_app_typ_4_code ON pmac_g_app_case(acai_app_typ_4);
CREATE INDEX IF NOT EXISTS idx_pmac_g_app_case_acai_app_typ_5_code ON pmac_g_app_case(acai_app_typ_5);
CREATE INDEX IF NOT EXISTS idx_pmac_g_app_case_acai_refer_num_code ON pmac_g_app_case(acai_refer_num);
CREATE INDEX IF NOT EXISTS idx_pmac_g_app_case_acai_org_lang_app_flg_code ON pmac_g_app_case(acai_org_lang_app_flg);
CREATE INDEX IF NOT EXISTS idx_pmac_g_app_case_acup_delete_flg_code ON pmac_g_app_case(acup_delete_flg);
CREATE INDEX IF NOT EXISTS idx_pmac_g_app_case_acup_pub_num_code ON pmac_g_app_case(acup_pub_num);
CREATE INDEX IF NOT EXISTS idx_pmac_g_app_case_actp_delete_flg_code ON pmac_g_app_case(actp_delete_flg);
CREATE INDEX IF NOT EXISTS idx_pmac_g_app_case_actp_trnsl_pub_num_code ON pmac_g_app_case(actp_trnsl_pub_num);
CREATE INDEX IF NOT EXISTS idx_pmac_g_app_case_acap_delete_flg_code ON pmac_g_app_case(acap_delete_flg);
CREATE INDEX IF NOT EXISTS idx_pmac_g_app_case_acld_delete_flg_code ON pmac_g_app_case(acld_delete_flg);
CREATE INDEX IF NOT EXISTS idx_pmac_g_app_case_acld_final_dspst_typ_code ON pmac_g_app_case(acld_final_dspst_typ);
CREATE INDEX IF NOT EXISTS idx_pmac_g_app_case_acrg_delete_flg_code ON pmac_g_app_case(acrg_delete_flg);
CREATE INDEX IF NOT EXISTS idx_pmac_g_app_case_acrg_reg_num_code ON pmac_g_app_case(acrg_reg_num);
CREATE INDEX IF NOT EXISTS idx_pmac_g_app_case_acrb_delete_flg_code ON pmac_g_app_case(acrb_delete_flg);
CREATE INDEX IF NOT EXISTS idx_pmac_g_app_case_acia_delete_flg_code ON pmac_g_app_case(acia_delete_flg);
CREATE INDEX IF NOT EXISTS idx_pmac_g_app_case_acia_intl_app_num_code ON pmac_g_app_case(acia_intl_app_num);
CREATE INDEX IF NOT EXISTS idx_pmac_g_app_case_acia_intl_pub_num_code ON pmac_g_app_case(acia_intl_pub_num);
CREATE INDEX IF NOT EXISTS idx_pmac_g_app_case_acia_lang_flg_code ON pmac_g_app_case(acia_lang_flg);

-- 特許出願事件繰返データファイル (出願マスタ（特実）)
CREATE TABLE IF NOT EXISTS pmac_gr_app_case_repeat_data (
    law_cd TEXT,
    app_num TEXT,
    article_id TEXT,
    repeat_num INTEGER,
    acap_appeal_num TEXT
);

CREATE INDEX IF NOT EXISTS idx_pmac_gr_app_case_repeat_data_law_cd ON pmac_gr_app_case_repeat_data(law_cd);
CREATE INDEX IF NOT EXISTS idx_pmac_gr_app_case_repeat_data_app_num ON pmac_gr_app_case_repeat_data(app_num);
CREATE INDEX IF NOT EXISTS idx_pmac_gr_app_case_repeat_data_article_id ON pmac_gr_app_case_repeat_data(article_id);
CREATE INDEX IF NOT EXISTS idx_pmac_gr_app_case_repeat_data_repeat_num ON pmac_gr_app_case_repeat_data(repeat_num);
CREATE INDEX IF NOT EXISTS idx_pmac_gr_app_case_repeat_data_law_cd_code ON pmac_gr_app_case_repeat_data(law_cd);
CREATE INDEX IF NOT EXISTS idx_pmac_gr_app_case_repeat_data_app_num_code ON pmac_gr_app_case_repeat_data(app_num);
CREATE INDEX IF NOT EXISTS idx_pmac_gr_app_case_repeat_data_article_id_code ON pmac_gr_app_case_repeat_data(article_id);
CREATE INDEX IF NOT EXISTS idx_pmac_gr_app_case_repeat_data_acap_appeal_num_code ON pmac_gr_app_case_repeat_data(acap_appeal_num);

-- 特許出願書類ファイル (出願マスタ（特実）)
CREATE TABLE IF NOT EXISTS pmap_g_app_doc (
    law_cd TEXT,
    app_num TEXT,
    storing_seq_num INTEGER,
    article_id TEXT,
    ap_delete_flg TEXT,
    ap_update_dttm TEXT,
    apad_delete_flg TEXT,
    apad_update_dttm TEXT,
    apad_create_dt TEXT,
    apad_valid_flg TEXT,
    apad_intrmd_doc_cd TEXT,
    apad_crrspnd_mk TEXT,
    apad_submit_dt TEXT,
    apad_rcpt_dt TEXT,
    apad_inspect_prhbt_flg TEXT,
    apad_opp_num TEXT,
    apad_rcpt_num TEXT,
    apad_frml_chked_mk TEXT,
    apad_instructed_flg TEXT,
    apad_dspst_dt TEXT,
    apad_change_appl_atty_id TEXT,
    apad_pri_submit_cntry_cd TEXT,
    apad_ver_num TEXT,
    apad_descript_ver_num TEXT,
    apad_invalid_doc_flg TEXT,
    apad_doc_frmt_typ TEXT,
    apad_crrspnd_doc_num TEXT,
    apad_doc_typ_cd TEXT,
    apad_amend_doc_rcpt_num TEXT,
    apad_store_num TEXT,
    apad_dna_flg TEXT,
    apad_description_page INTEGER,
    apad_descript_flg TEXT,
    apad_drawing_page INTEGER,
    apad_drawing_flg TEXT,
    apad_abstrct_doc_page INTEGER,
    apad_abstrct_flg TEXT,
    apad_attchd_doc_page INTEGER,
    apad_doc_size INTEGER,
    apdd_delete_flg TEXT,
    apdd_create_dt TEXT,
    apdd_valid_flg TEXT,
    apdd_intrmd_doc_cd TEXT,
    apdd_crrspnd_mk TEXT,
    apdd_draft_dt TEXT,
    apdd_dsptch_dt TEXT,
    apdd_inspect_prhbt_flg TEXT,
    apdd_opp_num TEXT,
    apdd_dsptch_doc_num TEXT,
    apdd_rjct_reason_art_cd TEXT,
    apdd_ver_num TEXT,
    apdd_invalid_doc_flg TEXT,
    apdd_doc_frmt_typ TEXT,
    apdd_crrspnd_doc_num TEXT,
    apdd_doc_typ_cd TEXT,
    apdd_dsptch_doc_image_page INTEGER,
    apdd_doc_size INTEGER,
    apjd_delete_flg TEXT,
    apjd_create_dt TEXT,
    apjd_valid_flg TEXT,
    apjd_intrmd_doc_cd TEXT,
    apjd_crrspnd_mk TEXT,
    apjd_jpo_doc_create_dt TEXT,
    apjd_inspect_prhbt_flg TEXT,
    apjd_admnst_appeal_num TEXT,
    apjd_litigate_num TEXT,
    apjd_jpo_doc_num TEXT,
    apjd_goodmoral_violate_cd TEXT,
    apjd_ver_num TEXT,
    apjd_invalid_doc_flg TEXT,
    apjd_doc_frmt_typ TEXT,
    apjd_crrspnd_doc_num TEXT,
    apjd_doc_typ_cd TEXT,
    apjd_jpo_doc_image_page INTEGER,
    apjd_doc_size INTEGER
);

CREATE INDEX IF NOT EXISTS idx_pmap_g_app_doc_law_cd ON pmap_g_app_doc(law_cd);
CREATE INDEX IF NOT EXISTS idx_pmap_g_app_doc_app_num ON pmap_g_app_doc(app_num);
CREATE INDEX IF NOT EXISTS idx_pmap_g_app_doc_storing_seq_num ON pmap_g_app_doc(storing_seq_num);
CREATE INDEX IF NOT EXISTS idx_pmap_g_app_doc_law_cd_code ON pmap_g_app_doc(law_cd);
CREATE INDEX IF NOT EXISTS idx_pmap_g_app_doc_app_num_code ON pmap_g_app_doc(app_num);
CREATE INDEX IF NOT EXISTS idx_pmap_g_app_doc_article_id_code ON pmap_g_app_doc(article_id);
CREATE INDEX IF NOT EXISTS idx_pmap_g_app_doc_ap_delete_flg_code ON pmap_g_app_doc(ap_delete_flg);
CREATE INDEX IF NOT EXISTS idx_pmap_g_app_doc_apad_delete_flg_code ON pmap_g_app_doc(apad_delete_flg);
CREATE INDEX IF NOT EXISTS idx_pmap_g_app_doc_apad_valid_flg_code ON pmap_g_app_doc(apad_valid_flg);
CREATE INDEX IF NOT EXISTS idx_pmap_g_app_doc_apad_intrmd_doc_cd_code ON pmap_g_app_doc(apad_intrmd_doc_cd);
CREATE INDEX IF NOT EXISTS idx_pmap_g_app_doc_apad_crrspnd_mk_code ON pmap_g_app_doc(apad_crrspnd_mk);
CREATE INDEX IF NOT EXISTS idx_pmap_g_app_doc_apad_inspect_prhbt_flg_code ON pmap_g_app_doc(apad_inspect_prhbt_flg);
CREATE INDEX IF NOT EXISTS idx_pmap_g_app_doc_apad_opp_num_code ON pmap_g_app_doc(apad_opp_num);
CREATE INDEX IF NOT EXISTS idx_pmap_g_app_doc_apad_rcpt_num_code ON pmap_g_app_doc(apad_rcpt_num);
CREATE INDEX IF NOT EXISTS idx_pmap_g_app_doc_apad_frml_chked_mk_code ON pmap_g_app_doc(apad_frml_chked_mk);
CREATE INDEX IF NOT EXISTS idx_pmap_g_app_doc_apad_instructed_flg_code ON pmap_g_app_doc(apad_instructed_flg);
CREATE INDEX IF NOT EXISTS idx_pmap_g_app_doc_apad_change_appl_atty_id_code ON pmap_g_app_doc(apad_change_appl_atty_id);
CREATE INDEX IF NOT EXISTS idx_pmap_g_app_doc_apad_pri_submit_cntry_cd_code ON pmap_g_app_doc(apad_pri_submit_cntry_cd);
CREATE INDEX IF NOT EXISTS idx_pmap_g_app_doc_apad_ver_num_code ON pmap_g_app_doc(apad_ver_num);
CREATE INDEX IF NOT EXISTS idx_pmap_g_app_doc_apad_invalid_doc_flg_code ON pmap_g_app_doc(apad_invalid_doc_flg);
CREATE INDEX IF NOT EXISTS idx_pmap_g_app_doc_apad_doc_frmt_typ_code ON pmap_g_app_doc(apad_doc_frmt_typ);
CREATE INDEX IF NOT EXISTS idx_pmap_g_app_doc_apad_crrspnd_doc_num_code ON pmap_g_app_doc(apad_crrspnd_doc_num);
CREATE INDEX IF NOT EXISTS idx_pmap_g_app_doc_apad_doc_typ_cd_code ON pmap_g_app_doc(apad_doc_typ_cd);
CREATE INDEX IF NOT EXISTS idx_pmap_g_app_doc_apad_amend_doc_rcpt_num_code ON pmap_g_app_doc(apad_amend_doc_rcpt_num);
CREATE INDEX IF NOT EXISTS idx_pmap_g_app_doc_apdd_delete_flg_code ON pmap_g_app_doc(apdd_delete_flg);
CREATE INDEX IF NOT EXISTS idx_pmap_g_app_doc_apdd_valid_flg_code ON pmap_g_app_doc(apdd_valid_flg);
CREATE INDEX IF NOT EXISTS idx_pmap_g_app_doc_apdd_intrmd_doc_cd_code ON pmap_g_app_doc(apdd_intrmd_doc_cd);
CREATE INDEX IF NOT EXISTS idx_pmap_g_app_doc_apdd_crrspnd_mk_code ON pmap_g_app_doc(apdd_crrspnd_mk);
CREATE INDEX IF NOT EXISTS idx_pmap_g_app_doc_apdd_inspect_prhbt_flg_code ON pmap_g_app_doc(apdd_inspect_prhbt_flg);
CREATE INDEX IF NOT EXISTS idx_pmap_g_app_doc_apdd_opp_num_code ON pmap_g_app_doc(apdd_opp_num);
CREATE INDEX IF NOT EXISTS idx_pmap_g_app_doc_apdd_dsptch_doc_num_code ON pmap_g_app_doc(apdd_dsptch_doc_num);
CREATE INDEX IF NOT EXISTS idx_pmap_g_app_doc_apdd_rjct_reason_art_cd_code ON pmap_g_app_doc(apdd_rjct_reason_art_cd);
CREATE INDEX IF NOT EXISTS idx_pmap_g_app_doc_apdd_ver_num_code ON pmap_g_app_doc(apdd_ver_num);
CREATE INDEX IF NOT EXISTS idx_pmap_g_app_doc_apdd_invalid_doc_flg_code ON pmap_g_app_doc(apdd_invalid_doc_flg);
CREATE INDEX IF NOT EXISTS idx_pmap_g_app_doc_apdd_doc_frmt_typ_code ON pmap_g_app_doc(apdd_doc_frmt_typ);
CREATE INDEX IF NOT EXISTS idx_pmap_g_app_doc_apdd_crrspnd_doc_num_code ON pmap_g_app_doc(apdd_crrspnd_doc_num);
CREATE INDEX IF NOT EXISTS idx_pmap_g_app_doc_apdd_doc_typ_cd_code ON pmap_g_app_doc(apdd_doc_typ_cd);
CREATE INDEX IF NOT EXISTS idx_pmap_g_app_doc_apjd_delete_flg_code ON pmap_g_app_doc(apjd_delete_flg);
CREATE INDEX IF NOT EXISTS idx_pmap_g_app_doc_apjd_valid_flg_code ON pmap_g_app_doc(apjd_valid_flg);
CREATE INDEX IF NOT EXISTS idx_pmap_g_app_doc_apjd_intrmd_doc_cd_code ON pmap_g_app_doc(apjd_intrmd_doc_cd);
CREATE INDEX IF NOT EXISTS idx_pmap_g_app_doc_apjd_crrspnd_mk_code ON pmap_g_app_doc(apjd_crrspnd_mk);
CREATE INDEX IF NOT EXISTS idx_pmap_g_app_doc_apjd_inspect_prhbt_flg_code ON pmap_g_app_doc(apjd_inspect_prhbt_flg);
CREATE INDEX IF NOT EXISTS idx_pmap_g_app_doc_apjd_admnst_appeal_num_code ON pmap_g_app_doc(apjd_admnst_appeal_num);
CREATE INDEX IF NOT EXISTS idx_pmap_g_app_doc_apjd_litigate_num_code ON pmap_g_app_doc(apjd_litigate_num);
CREATE INDEX IF NOT EXISTS idx_pmap_g_app_doc_apjd_jpo_doc_num_code ON pmap_g_app_doc(apjd_jpo_doc_num);
CREATE INDEX IF NOT EXISTS idx_pmap_g_app_doc_apjd_goodmoral_violate_cd_code ON pmap_g_app_doc(apjd_goodmoral_violate_cd);
CREATE INDEX IF NOT EXISTS idx_pmap_g_app_doc_apjd_ver_num_code ON pmap_g_app_doc(apjd_ver_num);
CREATE INDEX IF NOT EXISTS idx_pmap_g_app_doc_apjd_invalid_doc_flg_code ON pmap_g_app_doc(apjd_invalid_doc_flg);
CREATE INDEX IF NOT EXISTS idx_pmap_g_app_doc_apjd_doc_frmt_typ_code ON pmap_g_app_doc(apjd_doc_frmt_typ);
CREATE INDEX IF NOT EXISTS idx_pmap_g_app_doc_apjd_crrspnd_doc_num_code ON pmap_g_app_doc(apjd_crrspnd_doc_num);
CREATE INDEX IF NOT EXISTS idx_pmap_g_app_doc_apjd_doc_typ_cd_code ON pmap_g_app_doc(apjd_doc_typ_cd);

-- 特許事件ステータスファイル (出願マスタ（特実）)
CREATE TABLE IF NOT EXISTS pmcs_g_case_stat (
    law_cd TEXT,
    app_num TEXT,
    cs_delete_flg TEXT,
    cs_update_dttm TEXT,
    cscs_delete_flg TEXT,
    cscs_exam_claim_list_mk TEXT,
    cscs_final_dspst_dt TEXT,
    cscs_acclrtd_exam_mk TEXT,
    cscs_pub_prep_flg TEXT,
    cscs_applicable_law_class TEXT,
    cscs_exam_typ TEXT,
    cscs_litigate_cd TEXT,
    cscs_final_decision_typ_cd TEXT,
    cscs_exam_claim_cnt INTEGER,
    cscs_newapp_flg TEXT,
    cscs_later_intnl_pri_flg TEXT,
    cscs_citd_others_mk TEXT
);

CREATE INDEX IF NOT EXISTS idx_pmcs_g_case_stat_law_cd ON pmcs_g_case_stat(law_cd);
CREATE INDEX IF NOT EXISTS idx_pmcs_g_case_stat_app_num ON pmcs_g_case_stat(app_num);
CREATE INDEX IF NOT EXISTS idx_pmcs_g_case_stat_law_cd_code ON pmcs_g_case_stat(law_cd);
CREATE INDEX IF NOT EXISTS idx_pmcs_g_case_stat_app_num_code ON pmcs_g_case_stat(app_num);
CREATE INDEX IF NOT EXISTS idx_pmcs_g_case_stat_cs_delete_flg_code ON pmcs_g_case_stat(cs_delete_flg);
CREATE INDEX IF NOT EXISTS idx_pmcs_g_case_stat_cscs_delete_flg_code ON pmcs_g_case_stat(cscs_delete_flg);
CREATE INDEX IF NOT EXISTS idx_pmcs_g_case_stat_cscs_exam_claim_list_mk_code ON pmcs_g_case_stat(cscs_exam_claim_list_mk);
CREATE INDEX IF NOT EXISTS idx_pmcs_g_case_stat_cscs_acclrtd_exam_mk_code ON pmcs_g_case_stat(cscs_acclrtd_exam_mk);
CREATE INDEX IF NOT EXISTS idx_pmcs_g_case_stat_cscs_pub_prep_flg_code ON pmcs_g_case_stat(cscs_pub_prep_flg);
CREATE INDEX IF NOT EXISTS idx_pmcs_g_case_stat_cscs_applicable_law_class_code ON pmcs_g_case_stat(cscs_applicable_law_class);
CREATE INDEX IF NOT EXISTS idx_pmcs_g_case_stat_cscs_exam_typ_code ON pmcs_g_case_stat(cscs_exam_typ);
CREATE INDEX IF NOT EXISTS idx_pmcs_g_case_stat_cscs_litigate_cd_code ON pmcs_g_case_stat(cscs_litigate_cd);
CREATE INDEX IF NOT EXISTS idx_pmcs_g_case_stat_cscs_final_decision_typ_cd_code ON pmcs_g_case_stat(cscs_final_decision_typ_cd);
CREATE INDEX IF NOT EXISTS idx_pmcs_g_case_stat_cscs_newapp_flg_code ON pmcs_g_case_stat(cscs_newapp_flg);

-- 特許特許庁発の事件書誌ファイル (出願マスタ（特実）)
CREATE TABLE IF NOT EXISTS pmjb_g_jpo_case_biblog (
    law_cd TEXT,
    app_num TEXT,
    jb_delete_flg TEXT,
    jb_update_dttm TEXT,
    jbui_delete_flg TEXT,
    jbri_delete_flg TEXT,
    jbdc_delete_flg TEXT,
    jbdc_desig_class_ipc TEXT,
    jboi_delete_flg TEXT,
    jboi_staff_id TEXT,
    jboi_div_cd TEXT,
    jbpo_delete_flg TEXT,
    jbpo_goodmoral_mk TEXT,
    jbuf_delete_flg TEXT,
    jbrf_delete_flg TEXT,
    jbdf_delete_flg TEXT,
    jbdf_fi_section TEXT,
    jbdf_fi_class TEXT,
    jbdf_fi_subclass TEXT,
    jbdf_fi_main_grp TEXT,
    jbdf_fi_separator TEXT,
    jbdf_fi_sub_grp TEXT,
    jbdf_fi_subdiv_sign TEXT,
    jbdf_fi_separate_vol_class TEXT,
    jbdf_fi_facet TEXT
);

CREATE INDEX IF NOT EXISTS idx_pmjb_g_jpo_case_biblog_law_cd ON pmjb_g_jpo_case_biblog(law_cd);
CREATE INDEX IF NOT EXISTS idx_pmjb_g_jpo_case_biblog_app_num ON pmjb_g_jpo_case_biblog(app_num);
CREATE INDEX IF NOT EXISTS idx_pmjb_g_jpo_case_biblog_law_cd_code ON pmjb_g_jpo_case_biblog(law_cd);
CREATE INDEX IF NOT EXISTS idx_pmjb_g_jpo_case_biblog_app_num_code ON pmjb_g_jpo_case_biblog(app_num);
CREATE INDEX IF NOT EXISTS idx_pmjb_g_jpo_case_biblog_jb_delete_flg_code ON pmjb_g_jpo_case_biblog(jb_delete_flg);
CREATE INDEX IF NOT EXISTS idx_pmjb_g_jpo_case_biblog_jbui_delete_flg_code ON pmjb_g_jpo_case_biblog(jbui_delete_flg);
CREATE INDEX IF NOT EXISTS idx_pmjb_g_jpo_case_biblog_jbri_delete_flg_code ON pmjb_g_jpo_case_biblog(jbri_delete_flg);
CREATE INDEX IF NOT EXISTS idx_pmjb_g_jpo_case_biblog_jbdc_delete_flg_code ON pmjb_g_jpo_case_biblog(jbdc_delete_flg);
CREATE INDEX IF NOT EXISTS idx_pmjb_g_jpo_case_biblog_jbdc_desig_class_ipc_code ON pmjb_g_jpo_case_biblog(jbdc_desig_class_ipc);
CREATE INDEX IF NOT EXISTS idx_pmjb_g_jpo_case_biblog_jboi_delete_flg_code ON pmjb_g_jpo_case_biblog(jboi_delete_flg);
CREATE INDEX IF NOT EXISTS idx_pmjb_g_jpo_case_biblog_jboi_staff_id_code ON pmjb_g_jpo_case_biblog(jboi_staff_id);
CREATE INDEX IF NOT EXISTS idx_pmjb_g_jpo_case_biblog_jboi_div_cd_code ON pmjb_g_jpo_case_biblog(jboi_div_cd);
CREATE INDEX IF NOT EXISTS idx_pmjb_g_jpo_case_biblog_jbpo_delete_flg_code ON pmjb_g_jpo_case_biblog(jbpo_delete_flg);
CREATE INDEX IF NOT EXISTS idx_pmjb_g_jpo_case_biblog_jbpo_goodmoral_mk_code ON pmjb_g_jpo_case_biblog(jbpo_goodmoral_mk);
CREATE INDEX IF NOT EXISTS idx_pmjb_g_jpo_case_biblog_jbuf_delete_flg_code ON pmjb_g_jpo_case_biblog(jbuf_delete_flg);
CREATE INDEX IF NOT EXISTS idx_pmjb_g_jpo_case_biblog_jbrf_delete_flg_code ON pmjb_g_jpo_case_biblog(jbrf_delete_flg);
CREATE INDEX IF NOT EXISTS idx_pmjb_g_jpo_case_biblog_jbdf_delete_flg_code ON pmjb_g_jpo_case_biblog(jbdf_delete_flg);
CREATE INDEX IF NOT EXISTS idx_pmjb_g_jpo_case_biblog_jbdf_fi_section_code ON pmjb_g_jpo_case_biblog(jbdf_fi_section);
CREATE INDEX IF NOT EXISTS idx_pmjb_g_jpo_case_biblog_jbdf_fi_class_code ON pmjb_g_jpo_case_biblog(jbdf_fi_class);
CREATE INDEX IF NOT EXISTS idx_pmjb_g_jpo_case_biblog_jbdf_fi_subclass_code ON pmjb_g_jpo_case_biblog(jbdf_fi_subclass);
CREATE INDEX IF NOT EXISTS idx_pmjb_g_jpo_case_biblog_jbdf_fi_main_grp_code ON pmjb_g_jpo_case_biblog(jbdf_fi_main_grp);
CREATE INDEX IF NOT EXISTS idx_pmjb_g_jpo_case_biblog_jbdf_fi_separator_code ON pmjb_g_jpo_case_biblog(jbdf_fi_separator);
CREATE INDEX IF NOT EXISTS idx_pmjb_g_jpo_case_biblog_jbdf_fi_sub_grp_code ON pmjb_g_jpo_case_biblog(jbdf_fi_sub_grp);
CREATE INDEX IF NOT EXISTS idx_pmjb_g_jpo_case_biblog_jbdf_fi_subdiv_sign_code ON pmjb_g_jpo_case_biblog(jbdf_fi_subdiv_sign);
CREATE INDEX IF NOT EXISTS idx_pmjb_g_jpo_case_biblog_jbdf_fi_separate_vol_class_code ON pmjb_g_jpo_case_biblog(jbdf_fi_separate_vol_class);
CREATE INDEX IF NOT EXISTS idx_pmjb_g_jpo_case_biblog_jbdf_fi_facet_code ON pmjb_g_jpo_case_biblog(jbdf_fi_facet);

-- 特許特許庁発の事件書誌繰返データファイル (出願マスタ（特実）)
CREATE TABLE IF NOT EXISTS pmjb_gr_jpo_case_biblog (
    law_cd TEXT,
    app_num TEXT,
    article_id TEXT,
    repeat_num INTEGER,
    jbui_amend_mk TEXT,
    jbui_ver_num TEXT,
    jbui_seq_num INTEGER,
    jbui_pub_ipc TEXT,
    jbri_amend_mk TEXT,
    jbri_ver_num TEXT,
    jbri_seq_num INTEGER,
    jbri_reg_ipc TEXT,
    jbuf_fi_class_typ TEXT,
    jbuf_fi_left_sign TEXT,
    jbuf_fi_section TEXT,
    jbuf_fi_class TEXT,
    jbuf_fi_subclass TEXT,
    jbuf_fi_main_grp TEXT,
    jbuf_fi_separator TEXT,
    jbuf_fi_sub_grp TEXT,
    jbuf_fi_subdiv_sign TEXT,
    jbuf_fi_separate_vol_class TEXT,
    jbuf_fi_facet TEXT,
    jbuf_fi_right_sign TEXT,
    jbuf_fi_jpo_refer_num TEXT,
    jbuf_fi_amend_mk TEXT,
    jbuf_fi_prlmnry TEXT,
    jbrf_fi_class_typ TEXT,
    jbrf_fi_left_sign TEXT,
    jbrf_fi_section TEXT,
    jbrf_fi_class TEXT,
    jbrf_fi_subclass TEXT,
    jbrf_fi_main_grp TEXT,
    jbrf_fi_separator TEXT,
    jbrf_fi_sub_grp TEXT,
    jbrf_fi_subdiv_sign TEXT,
    jbrf_fi_separate_vol_class TEXT,
    jbrf_fi_facet TEXT,
    jbrf_fi_right_sign TEXT,
    jbrf_fi_jpo_refer_num TEXT,
    jbrf_fi_amend_mk TEXT,
    jbrf_fi_prlmnry TEXT
);

CREATE INDEX IF NOT EXISTS idx_pmjb_gr_jpo_case_biblog_law_cd ON pmjb_gr_jpo_case_biblog(law_cd);
CREATE INDEX IF NOT EXISTS idx_pmjb_gr_jpo_case_biblog_app_num ON pmjb_gr_jpo_case_biblog(app_num);
CREATE INDEX IF NOT EXISTS idx_pmjb_gr_jpo_case_biblog_article_id ON pmjb_gr_jpo_case_biblog(article_id);
CREATE INDEX IF NOT EXISTS idx_pmjb_gr_jpo_case_biblog_repeat_num ON pmjb_gr_jpo_case_biblog(repeat_num);
CREATE INDEX IF NOT EXISTS idx_pmjb_gr_jpo_case_biblog_law_cd_code ON pmjb_gr_jpo_case_biblog(law_cd);
CREATE INDEX IF NOT EXISTS idx_pmjb_gr_jpo_case_biblog_app_num_code ON pmjb_gr_jpo_case_biblog(app_num);
CREATE INDEX IF NOT EXISTS idx_pmjb_gr_jpo_case_biblog_article_id_code ON pmjb_gr_jpo_case_biblog(article_id);
CREATE INDEX IF NOT EXISTS idx_pmjb_gr_jpo_case_biblog_jbui_amend_mk_code ON pmjb_gr_jpo_case_biblog(jbui_amend_mk);
CREATE INDEX IF NOT EXISTS idx_pmjb_gr_jpo_case_biblog_jbui_ver_num_code ON pmjb_gr_jpo_case_biblog(jbui_ver_num);
CREATE INDEX IF NOT EXISTS idx_pmjb_gr_jpo_case_biblog_jbui_seq_num_code ON pmjb_gr_jpo_case_biblog(jbui_seq_num);
CREATE INDEX IF NOT EXISTS idx_pmjb_gr_jpo_case_biblog_jbui_pub_ipc_code ON pmjb_gr_jpo_case_biblog(jbui_pub_ipc);
CREATE INDEX IF NOT EXISTS idx_pmjb_gr_jpo_case_biblog_jbri_amend_mk_code ON pmjb_gr_jpo_case_biblog(jbri_amend_mk);
CREATE INDEX IF NOT EXISTS idx_pmjb_gr_jpo_case_biblog_jbri_ver_num_code ON pmjb_gr_jpo_case_biblog(jbri_ver_num);
CREATE INDEX IF NOT EXISTS idx_pmjb_gr_jpo_case_biblog_jbri_seq_num_code ON pmjb_gr_jpo_case_biblog(jbri_seq_num);
CREATE INDEX IF NOT EXISTS idx_pmjb_gr_jpo_case_biblog_jbuf_fi_class_typ_code ON pmjb_gr_jpo_case_biblog(jbuf_fi_class_typ);
CREATE INDEX IF NOT EXISTS idx_pmjb_gr_jpo_case_biblog_jbuf_fi_left_sign_code ON pmjb_gr_jpo_case_biblog(jbuf_fi_left_sign);
CREATE INDEX IF NOT EXISTS idx_pmjb_gr_jpo_case_biblog_jbuf_fi_section_code ON pmjb_gr_jpo_case_biblog(jbuf_fi_section);
CREATE INDEX IF NOT EXISTS idx_pmjb_gr_jpo_case_biblog_jbuf_fi_class_code ON pmjb_gr_jpo_case_biblog(jbuf_fi_class);
CREATE INDEX IF NOT EXISTS idx_pmjb_gr_jpo_case_biblog_jbuf_fi_subclass_code ON pmjb_gr_jpo_case_biblog(jbuf_fi_subclass);
CREATE INDEX IF NOT EXISTS idx_pmjb_gr_jpo_case_biblog_jbuf_fi_main_grp_code ON pmjb_gr_jpo_case_biblog(jbuf_fi_main_grp);
CREATE INDEX IF NOT EXISTS idx_pmjb_gr_jpo_case_biblog_jbuf_fi_separator_code ON pmjb_gr_jpo_case_biblog(jbuf_fi_separator);
CREATE INDEX IF NOT EXISTS idx_pmjb_gr_jpo_case_biblog_jbuf_fi_sub_grp_code ON pmjb_gr_jpo_case_biblog(jbuf_fi_sub_grp);
CREATE INDEX IF NOT EXISTS idx_pmjb_gr_jpo_case_biblog_jbuf_fi_subdiv_sign_code ON pmjb_gr_jpo_case_biblog(jbuf_fi_subdiv_sign);
CREATE INDEX IF NOT EXISTS idx_pmjb_gr_jpo_case_biblog_jbuf_fi_separate_vol_class_code ON pmjb_gr_jpo_case_biblog(jbuf_fi_separate_vol_class);
CREATE INDEX IF NOT EXISTS idx_pmjb_gr_jpo_case_biblog_jbuf_fi_facet_code ON pmjb_gr_jpo_case_biblog(jbuf_fi_facet);
CREATE INDEX IF NOT EXISTS idx_pmjb_gr_jpo_case_biblog_jbuf_fi_right_sign_code ON pmjb_gr_jpo_case_biblog(jbuf_fi_right_sign);
CREATE INDEX IF NOT EXISTS idx_pmjb_gr_jpo_case_biblog_jbuf_fi_jpo_refer_num_code ON pmjb_gr_jpo_case_biblog(jbuf_fi_jpo_refer_num);
CREATE INDEX IF NOT EXISTS idx_pmjb_gr_jpo_case_biblog_jbuf_fi_amend_mk_code ON pmjb_gr_jpo_case_biblog(jbuf_fi_amend_mk);
CREATE INDEX IF NOT EXISTS idx_pmjb_gr_jpo_case_biblog_jbuf_fi_prlmnry_code ON pmjb_gr_jpo_case_biblog(jbuf_fi_prlmnry);
CREATE INDEX IF NOT EXISTS idx_pmjb_gr_jpo_case_biblog_jbrf_fi_class_typ_code ON pmjb_gr_jpo_case_biblog(jbrf_fi_class_typ);
CREATE INDEX IF NOT EXISTS idx_pmjb_gr_jpo_case_biblog_jbrf_fi_subdiv_sign_code ON pmjb_gr_jpo_case_biblog(jbrf_fi_subdiv_sign);
CREATE INDEX IF NOT EXISTS idx_pmjb_gr_jpo_case_biblog_jbrf_fi_separate_vol_class_code ON pmjb_gr_jpo_case_biblog(jbrf_fi_separate_vol_class);
CREATE INDEX IF NOT EXISTS idx_pmjb_gr_jpo_case_biblog_jbrf_fi_facet_code ON pmjb_gr_jpo_case_biblog(jbrf_fi_facet);
CREATE INDEX IF NOT EXISTS idx_pmjb_gr_jpo_case_biblog_jbrf_fi_jpo_refer_num_code ON pmjb_gr_jpo_case_biblog(jbrf_fi_jpo_refer_num);
CREATE INDEX IF NOT EXISTS idx_pmjb_gr_jpo_case_biblog_jbrf_fi_amend_mk_code ON pmjb_gr_jpo_case_biblog(jbrf_fi_amend_mk);

-- 特許旧出願事件ファイル (出願マスタ（特実）)
CREATE TABLE IF NOT EXISTS pmoa_g_old_app_case (
    law_cd TEXT,
    app_num TEXT,
    oa_delete_flg TEXT,
    oa_update_dttm TEXT,
    oaep_delete_flg TEXT,
    oaep_exam_pub_num TEXT,
    oaep_exam_pub_dt TEXT
);

CREATE INDEX IF NOT EXISTS idx_pmoa_g_old_app_case_law_cd ON pmoa_g_old_app_case(law_cd);
CREATE INDEX IF NOT EXISTS idx_pmoa_g_old_app_case_app_num ON pmoa_g_old_app_case(app_num);
CREATE INDEX IF NOT EXISTS idx_pmoa_g_old_app_case_law_cd_code ON pmoa_g_old_app_case(law_cd);
CREATE INDEX IF NOT EXISTS idx_pmoa_g_old_app_case_app_num_code ON pmoa_g_old_app_case(app_num);
CREATE INDEX IF NOT EXISTS idx_pmoa_g_old_app_case_oa_delete_flg_code ON pmoa_g_old_app_case(oa_delete_flg);
CREATE INDEX IF NOT EXISTS idx_pmoa_g_old_app_case_oaep_delete_flg_code ON pmoa_g_old_app_case(oaep_delete_flg);
CREATE INDEX IF NOT EXISTS idx_pmoa_g_old_app_case_oaep_exam_pub_num_code ON pmoa_g_old_app_case(oaep_exam_pub_num);

-- 特許旧事件書誌ファイル (出願マスタ（特実）)
CREATE TABLE IF NOT EXISTS pmob_g_old_case_biblog (
    law_cd TEXT,
    app_num TEXT,
    ob_delete_flg TEXT,
    ob_update_dttm TEXT,
    obpr_delete_flg TEXT,
    obpr_pllt_ctrl_relate_tech_mk TEXT,
    obao_delete_flg TEXT,
    obao_num_typ_cd TEXT,
    obao_parent_app_num TEXT,
    obao_reg_num TEXT,
    obpt_delete_flg TEXT,
    obpt_past_law_cd TEXT,
    obpt_past_app_num TEXT,
    obei_delete_flg TEXT,
    obpd_delete_flg TEXT,
    obnp_delete_flg TEXT
);

CREATE INDEX IF NOT EXISTS idx_pmob_g_old_case_biblog_law_cd ON pmob_g_old_case_biblog(law_cd);
CREATE INDEX IF NOT EXISTS idx_pmob_g_old_case_biblog_app_num ON pmob_g_old_case_biblog(app_num);
CREATE INDEX IF NOT EXISTS idx_pmob_g_old_case_biblog_law_cd_code ON pmob_g_old_case_biblog(law_cd);
CREATE INDEX IF NOT EXISTS idx_pmob_g_old_case_biblog_app_num_code ON pmob_g_old_case_biblog(app_num);
CREATE INDEX IF NOT EXISTS idx_pmob_g_old_case_biblog_ob_delete_flg_code ON pmob_g_old_case_biblog(ob_delete_flg);
CREATE INDEX IF NOT EXISTS idx_pmob_g_old_case_biblog_obpr_delete_flg_code ON pmob_g_old_case_biblog(obpr_delete_flg);
CREATE INDEX IF NOT EXISTS idx_pmob_g_old_case_biblog_obpr_pllt_ctrl_relate_tech_mk_code ON pmob_g_old_case_biblog(obpr_pllt_ctrl_relate_tech_mk);
CREATE INDEX IF NOT EXISTS idx_pmob_g_old_case_biblog_obao_delete_flg_code ON pmob_g_old_case_biblog(obao_delete_flg);
CREATE INDEX IF NOT EXISTS idx_pmob_g_old_case_biblog_obao_num_typ_cd_code ON pmob_g_old_case_biblog(obao_num_typ_cd);
CREATE INDEX IF NOT EXISTS idx_pmob_g_old_case_biblog_obao_parent_app_num_code ON pmob_g_old_case_biblog(obao_parent_app_num);
CREATE INDEX IF NOT EXISTS idx_pmob_g_old_case_biblog_obao_reg_num_code ON pmob_g_old_case_biblog(obao_reg_num);
CREATE INDEX IF NOT EXISTS idx_pmob_g_old_case_biblog_obpt_delete_flg_code ON pmob_g_old_case_biblog(obpt_delete_flg);
CREATE INDEX IF NOT EXISTS idx_pmob_g_old_case_biblog_obpt_past_law_cd_code ON pmob_g_old_case_biblog(obpt_past_law_cd);
CREATE INDEX IF NOT EXISTS idx_pmob_g_old_case_biblog_obpt_past_app_num_code ON pmob_g_old_case_biblog(obpt_past_app_num);
CREATE INDEX IF NOT EXISTS idx_pmob_g_old_case_biblog_obei_delete_flg_code ON pmob_g_old_case_biblog(obei_delete_flg);
CREATE INDEX IF NOT EXISTS idx_pmob_g_old_case_biblog_obpd_delete_flg_code ON pmob_g_old_case_biblog(obpd_delete_flg);
CREATE INDEX IF NOT EXISTS idx_pmob_g_old_case_biblog_obnp_delete_flg_code ON pmob_g_old_case_biblog(obnp_delete_flg);

-- 特許旧事件書誌繰返データファイル (出願マスタ（特実）)
CREATE TABLE IF NOT EXISTS pmob_gr_old_case_biblog (
    law_cd TEXT,
    app_num TEXT,
    article_id TEXT,
    repeat_num INTEGER,
    obei_examiner_typ TEXT,
    obei_examiner_id TEXT,
    obei_name TEXT,
    obpd_patent_doc_title TEXT,
    obnp_non_patent_doc_title TEXT
);

CREATE INDEX IF NOT EXISTS idx_pmob_gr_old_case_biblog_law_cd ON pmob_gr_old_case_biblog(law_cd);
CREATE INDEX IF NOT EXISTS idx_pmob_gr_old_case_biblog_app_num ON pmob_gr_old_case_biblog(app_num);
CREATE INDEX IF NOT EXISTS idx_pmob_gr_old_case_biblog_article_id ON pmob_gr_old_case_biblog(article_id);
CREATE INDEX IF NOT EXISTS idx_pmob_gr_old_case_biblog_repeat_num ON pmob_gr_old_case_biblog(repeat_num);
CREATE INDEX IF NOT EXISTS idx_pmob_gr_old_case_biblog_law_cd_code ON pmob_gr_old_case_biblog(law_cd);
CREATE INDEX IF NOT EXISTS idx_pmob_gr_old_case_biblog_app_num_code ON pmob_gr_old_case_biblog(app_num);
CREATE INDEX IF NOT EXISTS idx_pmob_gr_old_case_biblog_article_id_code ON pmob_gr_old_case_biblog(article_id);
CREATE INDEX IF NOT EXISTS idx_pmob_gr_old_case_biblog_obei_examiner_typ_code ON pmob_gr_old_case_biblog(obei_examiner_typ);
CREATE INDEX IF NOT EXISTS idx_pmob_gr_old_case_biblog_obei_examiner_id_code ON pmob_gr_old_case_biblog(obei_examiner_id);

-- 特許異議情報ファイル (出願マスタ（特実）)
CREATE TABLE IF NOT EXISTS pmoi_g_opposition_info (
    law_cd TEXT,
    app_num TEXT,
    opp_num TEXT,
    oi_delete_flg TEXT,
    oi_create_dttm TEXT,
    oici_delete_flg TEXT,
    oici_opp_dt TEXT,
    oiop_delete_flg TEXT,
    oiop_opp_decision_content TEXT,
    oioa_delete_flg TEXT,
    oion_delete_flg TEXT
);

CREATE INDEX IF NOT EXISTS idx_pmoi_g_opposition_info_law_cd ON pmoi_g_opposition_info(law_cd);
CREATE INDEX IF NOT EXISTS idx_pmoi_g_opposition_info_app_num ON pmoi_g_opposition_info(app_num);
CREATE INDEX IF NOT EXISTS idx_pmoi_g_opposition_info_opp_num ON pmoi_g_opposition_info(opp_num);
CREATE INDEX IF NOT EXISTS idx_pmoi_g_opposition_info_law_cd_code ON pmoi_g_opposition_info(law_cd);
CREATE INDEX IF NOT EXISTS idx_pmoi_g_opposition_info_app_num_code ON pmoi_g_opposition_info(app_num);
CREATE INDEX IF NOT EXISTS idx_pmoi_g_opposition_info_opp_num_code ON pmoi_g_opposition_info(opp_num);
CREATE INDEX IF NOT EXISTS idx_pmoi_g_opposition_info_oi_delete_flg_code ON pmoi_g_opposition_info(oi_delete_flg);
CREATE INDEX IF NOT EXISTS idx_pmoi_g_opposition_info_oici_delete_flg_code ON pmoi_g_opposition_info(oici_delete_flg);
CREATE INDEX IF NOT EXISTS idx_pmoi_g_opposition_info_oiop_delete_flg_code ON pmoi_g_opposition_info(oiop_delete_flg);
CREATE INDEX IF NOT EXISTS idx_pmoi_g_opposition_info_oiop_opp_decision_content_code ON pmoi_g_opposition_info(oiop_opp_decision_content);
CREATE INDEX IF NOT EXISTS idx_pmoi_g_opposition_info_oioa_delete_flg_code ON pmoi_g_opposition_info(oioa_delete_flg);
CREATE INDEX IF NOT EXISTS idx_pmoi_g_opposition_info_oion_delete_flg_code ON pmoi_g_opposition_info(oion_delete_flg);

-- 特許異議情報繰返データファイル (出願マスタ（特実）)
CREATE TABLE IF NOT EXISTS pmoi_gr_opposition_info (
    law_cd TEXT,
    app_num TEXT,
    opp_num TEXT,
    article_id TEXT,
    repeat_num INTEGER,
    oioa_oppn_atty_class TEXT,
    oioa_oppn_atty_id TEXT,
    oioa_change_num TEXT,
    oioa_req_typ TEXT,
    oioa_pref_cd TEXT,
    oioa_above_oppn_cnt TEXT,
    oioa_opp_atty_other_cnt TEXT,
    oioa_opp_atty_typ_cd TEXT,
    oioa_opp_atty_qualify_cd TEXT,
    oioa_crrspnd_num TEXT,
    oion_crrspnd_num TEXT,
    oion_clmt_atty_addr TEXT,
    oion_clmt_atty_name TEXT,
    oion_representative_name TEXT,
    oion_office_addr TEXT,
    oion_wrk_place_addr TEXT
);

CREATE INDEX IF NOT EXISTS idx_pmoi_gr_opposition_info_law_cd ON pmoi_gr_opposition_info(law_cd);
CREATE INDEX IF NOT EXISTS idx_pmoi_gr_opposition_info_app_num ON pmoi_gr_opposition_info(app_num);
CREATE INDEX IF NOT EXISTS idx_pmoi_gr_opposition_info_opp_num ON pmoi_gr_opposition_info(opp_num);
CREATE INDEX IF NOT EXISTS idx_pmoi_gr_opposition_info_article_id ON pmoi_gr_opposition_info(article_id);
CREATE INDEX IF NOT EXISTS idx_pmoi_gr_opposition_info_repeat_num ON pmoi_gr_opposition_info(repeat_num);
CREATE INDEX IF NOT EXISTS idx_pmoi_gr_opposition_info_law_cd_code ON pmoi_gr_opposition_info(law_cd);
CREATE INDEX IF NOT EXISTS idx_pmoi_gr_opposition_info_app_num_code ON pmoi_gr_opposition_info(app_num);
CREATE INDEX IF NOT EXISTS idx_pmoi_gr_opposition_info_opp_num_code ON pmoi_gr_opposition_info(opp_num);
CREATE INDEX IF NOT EXISTS idx_pmoi_gr_opposition_info_article_id_code ON pmoi_gr_opposition_info(article_id);
CREATE INDEX IF NOT EXISTS idx_pmoi_gr_opposition_info_oioa_oppn_atty_class_code ON pmoi_gr_opposition_info(oioa_oppn_atty_class);
CREATE INDEX IF NOT EXISTS idx_pmoi_gr_opposition_info_oioa_oppn_atty_id_code ON pmoi_gr_opposition_info(oioa_oppn_atty_id);
CREATE INDEX IF NOT EXISTS idx_pmoi_gr_opposition_info_oioa_req_typ_code ON pmoi_gr_opposition_info(oioa_req_typ);
CREATE INDEX IF NOT EXISTS idx_pmoi_gr_opposition_info_oioa_pref_cd_code ON pmoi_gr_opposition_info(oioa_pref_cd);
CREATE INDEX IF NOT EXISTS idx_pmoi_gr_opposition_info_oioa_opp_atty_typ_cd_code ON pmoi_gr_opposition_info(oioa_opp_atty_typ_cd);
CREATE INDEX IF NOT EXISTS idx_pmoi_gr_opposition_info_oioa_opp_atty_qualify_cd_code ON pmoi_gr_opposition_info(oioa_opp_atty_qualify_cd);
CREATE INDEX IF NOT EXISTS idx_pmoi_gr_opposition_info_oioa_crrspnd_num_code ON pmoi_gr_opposition_info(oioa_crrspnd_num);
CREATE INDEX IF NOT EXISTS idx_pmoi_gr_opposition_info_oion_crrspnd_num_code ON pmoi_gr_opposition_info(oion_crrspnd_num);

-- 特許旧事件ステータスファイル (出願マスタ（特実）)
CREATE TABLE IF NOT EXISTS pmos_g_old_case_stat (
    law_cd TEXT,
    app_num TEXT,
    os_delete_flg TEXT,
    osos_delete_flg TEXT,
    osos_opp_cnt INTEGER,
    osos_opp_valid_cnt INTEGER
);

CREATE INDEX IF NOT EXISTS idx_pmos_g_old_case_stat_law_cd ON pmos_g_old_case_stat(law_cd);
CREATE INDEX IF NOT EXISTS idx_pmos_g_old_case_stat_app_num ON pmos_g_old_case_stat(app_num);
CREATE INDEX IF NOT EXISTS idx_pmos_g_old_case_stat_law_cd_code ON pmos_g_old_case_stat(law_cd);
CREATE INDEX IF NOT EXISTS idx_pmos_g_old_case_stat_app_num_code ON pmos_g_old_case_stat(app_num);
CREATE INDEX IF NOT EXISTS idx_pmos_g_old_case_stat_os_delete_flg_code ON pmos_g_old_case_stat(os_delete_flg);
CREATE INDEX IF NOT EXISTS idx_pmos_g_old_case_stat_osos_delete_flg_code ON pmos_g_old_case_stat(osos_delete_flg);

-- 経過情報部ファイル(意匠) (登録マスタ)
CREATE TABLE IF NOT EXISTS prog_info_div_d (
    processing_type TEXT,
    law_cd TEXT,
    reg_num TEXT,
    split_num TEXT,
    app_num TEXT,
    rec_num TEXT,
    pe_num TEXT,
    prog_info_upd_ymd TEXT,
    reg_intrmd_cd TEXT,
    crrspnd_mk TEXT,
    rcpt_pymnt_dsptch_ymd TEXT,
    rcpt_num_common_use TEXT
);

CREATE INDEX IF NOT EXISTS idx_prog_info_div_d_law_cd ON prog_info_div_d(law_cd);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_d_reg_num ON prog_info_div_d(reg_num);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_d_split_num ON prog_info_div_d(split_num);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_d_app_num ON prog_info_div_d(app_num);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_d_rec_num ON prog_info_div_d(rec_num);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_d_pe_num ON prog_info_div_d(pe_num);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_d_processing_type_code ON prog_info_div_d(processing_type);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_d_law_cd_code ON prog_info_div_d(law_cd);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_d_reg_num_code ON prog_info_div_d(reg_num);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_d_split_num_code ON prog_info_div_d(split_num);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_d_app_num_code ON prog_info_div_d(app_num);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_d_pe_num_code ON prog_info_div_d(pe_num);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_d_reg_intrmd_cd_code ON prog_info_div_d(reg_intrmd_cd);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_d_crrspnd_mk_code ON prog_info_div_d(crrspnd_mk);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_d_rcpt_num_common_use_code ON prog_info_div_d(rcpt_num_common_use);

-- 経過情報部ファイル(ハーグ) (登録マスタ)
CREATE TABLE IF NOT EXISTS prog_info_div_hague (
    processing_type TEXT,
    law_cd TEXT,
    reg_num TEXT,
    split_num TEXT,
    app_num TEXT,
    rec_num TEXT,
    pe_num TEXT,
    prog_info_upd_ymd TEXT,
    reg_intrmd_cd TEXT,
    crrspnd_mk TEXT,
    rcpt_pymnt_dsptch_ymd TEXT,
    rcpt_num_common_use TEXT
);

CREATE INDEX IF NOT EXISTS idx_prog_info_div_hague_law_cd ON prog_info_div_hague(law_cd);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_hague_reg_num ON prog_info_div_hague(reg_num);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_hague_split_num ON prog_info_div_hague(split_num);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_hague_app_num ON prog_info_div_hague(app_num);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_hague_rec_num ON prog_info_div_hague(rec_num);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_hague_pe_num ON prog_info_div_hague(pe_num);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_hague_processing_type_code ON prog_info_div_hague(processing_type);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_hague_law_cd_code ON prog_info_div_hague(law_cd);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_hague_reg_num_code ON prog_info_div_hague(reg_num);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_hague_split_num_code ON prog_info_div_hague(split_num);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_hague_app_num_code ON prog_info_div_hague(app_num);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_hague_pe_num_code ON prog_info_div_hague(pe_num);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_hague_reg_intrmd_cd_code ON prog_info_div_hague(reg_intrmd_cd);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_hague_crrspnd_mk_code ON prog_info_div_hague(crrspnd_mk);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_hague_rcpt_num_common_use_code ON prog_info_div_hague(rcpt_num_common_use);

-- 経過情報部ファイル(特許) (登録マスタ)
CREATE TABLE IF NOT EXISTS prog_info_div_p (
    processing_type TEXT,
    law_cd TEXT,
    reg_num TEXT,
    split_num TEXT,
    app_num TEXT,
    rec_num TEXT,
    pe_num TEXT,
    prog_info_upd_ymd TEXT,
    reg_intrmd_cd TEXT,
    crrspnd_mk TEXT,
    rcpt_pymnt_dsptch_ymd TEXT,
    rcpt_num_common_use TEXT
);

CREATE INDEX IF NOT EXISTS idx_prog_info_div_p_law_cd ON prog_info_div_p(law_cd);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_p_reg_num ON prog_info_div_p(reg_num);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_p_split_num ON prog_info_div_p(split_num);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_p_app_num ON prog_info_div_p(app_num);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_p_rec_num ON prog_info_div_p(rec_num);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_p_pe_num ON prog_info_div_p(pe_num);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_p_processing_type_code ON prog_info_div_p(processing_type);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_p_law_cd_code ON prog_info_div_p(law_cd);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_p_reg_num_code ON prog_info_div_p(reg_num);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_p_split_num_code ON prog_info_div_p(split_num);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_p_app_num_code ON prog_info_div_p(app_num);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_p_pe_num_code ON prog_info_div_p(pe_num);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_p_reg_intrmd_cd_code ON prog_info_div_p(reg_intrmd_cd);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_p_crrspnd_mk_code ON prog_info_div_p(crrspnd_mk);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_p_rcpt_num_common_use_code ON prog_info_div_p(rcpt_num_common_use);

-- 経過情報部ファイル(商標) (登録マスタ)
CREATE TABLE IF NOT EXISTS prog_info_div_t (
    processing_type TEXT,
    law_cd TEXT,
    reg_num TEXT,
    split_num TEXT,
    app_num TEXT,
    rec_num TEXT,
    pe_num TEXT,
    prog_info_upd_ymd TEXT,
    reg_intrmd_cd TEXT,
    crrspnd_mk TEXT,
    rcpt_pymnt_dsptch_ymd TEXT,
    prog_info_div_app_num TEXT,
    rcpt_num_common_use TEXT
);

CREATE INDEX IF NOT EXISTS idx_prog_info_div_t_law_cd ON prog_info_div_t(law_cd);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_t_reg_num ON prog_info_div_t(reg_num);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_t_split_num ON prog_info_div_t(split_num);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_t_app_num ON prog_info_div_t(app_num);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_t_rec_num ON prog_info_div_t(rec_num);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_t_pe_num ON prog_info_div_t(pe_num);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_t_processing_type_code ON prog_info_div_t(processing_type);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_t_law_cd_code ON prog_info_div_t(law_cd);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_t_reg_num_code ON prog_info_div_t(reg_num);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_t_split_num_code ON prog_info_div_t(split_num);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_t_app_num_code ON prog_info_div_t(app_num);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_t_pe_num_code ON prog_info_div_t(pe_num);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_t_reg_intrmd_cd_code ON prog_info_div_t(reg_intrmd_cd);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_t_crrspnd_mk_code ON prog_info_div_t(crrspnd_mk);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_t_prog_info_div_app_num_code ON prog_info_div_t(prog_info_div_app_num);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_t_rcpt_num_common_use_code ON prog_info_div_t(rcpt_num_common_use);

-- 経過情報部ファイル(実用) (登録マスタ)
CREATE TABLE IF NOT EXISTS prog_info_div_u (
    processing_type TEXT,
    law_cd TEXT,
    reg_num TEXT,
    split_num TEXT,
    app_num TEXT,
    rec_num TEXT,
    pe_num TEXT,
    prog_info_upd_ymd TEXT,
    reg_intrmd_cd TEXT,
    crrspnd_mk TEXT,
    rcpt_pymnt_dsptch_ymd TEXT,
    rcpt_num_common_use TEXT
);

CREATE INDEX IF NOT EXISTS idx_prog_info_div_u_law_cd ON prog_info_div_u(law_cd);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_u_reg_num ON prog_info_div_u(reg_num);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_u_split_num ON prog_info_div_u(split_num);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_u_app_num ON prog_info_div_u(app_num);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_u_rec_num ON prog_info_div_u(rec_num);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_u_pe_num ON prog_info_div_u(pe_num);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_u_processing_type_code ON prog_info_div_u(processing_type);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_u_law_cd_code ON prog_info_div_u(law_cd);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_u_reg_num_code ON prog_info_div_u(reg_num);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_u_split_num_code ON prog_info_div_u(split_num);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_u_app_num_code ON prog_info_div_u(app_num);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_u_pe_num_code ON prog_info_div_u(pe_num);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_u_reg_intrmd_cd_code ON prog_info_div_u(reg_intrmd_cd);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_u_crrspnd_mk_code ON prog_info_div_u(crrspnd_mk);
CREATE INDEX IF NOT EXISTS idx_prog_info_div_u_rcpt_num_common_use_code ON prog_info_div_u(rcpt_num_common_use);

-- 受付書類ファイル (審判マスタ)
CREATE TABLE IF NOT EXISTS rcpt_doc (
    processing_type VARCHAR(1),
    appl_num VARCHAR(10),
    intrmd_cd VARCHAR(7),
    rcpt_doc_num VARCHAR(11),
    doc_submit_dt VARCHAR(8),
    doc_rcpt_dt VARCHAR(8),
    doc_dspst_cd VARCHAR(2),
    crrspnd_dsptch_doc_num VARCHAR(11),
    rfr_num VARCHAR(10),
    doc_typ_cd VARCHAR(1),
    updt_dttm VARCHAR(12)
);

CREATE INDEX IF NOT EXISTS idx_rcpt_doc_appl_num ON rcpt_doc(appl_num);
CREATE INDEX IF NOT EXISTS idx_rcpt_doc_intrmd_cd ON rcpt_doc(intrmd_cd);
CREATE INDEX IF NOT EXISTS idx_rcpt_doc_rcpt_doc_num ON rcpt_doc(rcpt_doc_num);

-- 本権商品名ファイル (登録マスタ)
CREATE TABLE IF NOT EXISTS right_goods_name (
    processing_type TEXT,
    law_cd TEXT,
    reg_num TEXT,
    split_num TEXT,
    app_num TEXT,
    desig_goods_or_desig_wrk_class TEXT,
    mstr_updt_year_month_day TEXT,
    desg_gds_desg_wrk_name_len TEXT,
    desg_gds_name_desg_wrk_name TEXT,
    rec_num TEXT
);

CREATE INDEX IF NOT EXISTS idx_right_goods_name_law_cd ON right_goods_name(law_cd);
CREATE INDEX IF NOT EXISTS idx_right_goods_name_reg_num ON right_goods_name(reg_num);
CREATE INDEX IF NOT EXISTS idx_right_goods_name_split_num ON right_goods_name(split_num);
CREATE INDEX IF NOT EXISTS idx_right_goods_name_app_num ON right_goods_name(app_num);
CREATE INDEX IF NOT EXISTS idx_right_goods_name_desig_goods_or_desig_wrk_class ON right_goods_name(desig_goods_or_desig_wrk_class);
CREATE INDEX IF NOT EXISTS idx_right_goods_name_rec_num ON right_goods_name(rec_num);
CREATE INDEX IF NOT EXISTS idx_right_goods_name_processing_type_code ON right_goods_name(processing_type);
CREATE INDEX IF NOT EXISTS idx_right_goods_name_law_cd_code ON right_goods_name(law_cd);
CREATE INDEX IF NOT EXISTS idx_right_goods_name_reg_num_code ON right_goods_name(reg_num);
CREATE INDEX IF NOT EXISTS idx_right_goods_name_split_num_code ON right_goods_name(split_num);
CREATE INDEX IF NOT EXISTS idx_right_goods_name_app_num_code ON right_goods_name(app_num);
CREATE INDEX IF NOT EXISTS idx_right_goods_name_desig_goods_or_desig_wrk_class_code ON right_goods_name(desig_goods_or_desig_wrk_class);

-- 権利者記事ファイル(意匠) (登録マスタ)
CREATE TABLE IF NOT EXISTS right_person_art_d (
    processing_type TEXT,
    law_cd TEXT,
    reg_num TEXT,
    split_num TEXT,
    app_num TEXT,
    rec_num TEXT,
    pe_num TEXT,
    right_psn_art_upd_ymd TEXT,
    right_person_appl_id TEXT,
    right_person_addr_len TEXT,
    right_person_addr TEXT,
    right_person_name_len TEXT,
    right_person_name TEXT
);

CREATE INDEX IF NOT EXISTS idx_right_person_art_d_law_cd ON right_person_art_d(law_cd);
CREATE INDEX IF NOT EXISTS idx_right_person_art_d_reg_num ON right_person_art_d(reg_num);
CREATE INDEX IF NOT EXISTS idx_right_person_art_d_split_num ON right_person_art_d(split_num);
CREATE INDEX IF NOT EXISTS idx_right_person_art_d_app_num ON right_person_art_d(app_num);
CREATE INDEX IF NOT EXISTS idx_right_person_art_d_rec_num ON right_person_art_d(rec_num);
CREATE INDEX IF NOT EXISTS idx_right_person_art_d_pe_num ON right_person_art_d(pe_num);
CREATE INDEX IF NOT EXISTS idx_right_person_art_d_processing_type_code ON right_person_art_d(processing_type);
CREATE INDEX IF NOT EXISTS idx_right_person_art_d_law_cd_code ON right_person_art_d(law_cd);
CREATE INDEX IF NOT EXISTS idx_right_person_art_d_reg_num_code ON right_person_art_d(reg_num);
CREATE INDEX IF NOT EXISTS idx_right_person_art_d_split_num_code ON right_person_art_d(split_num);
CREATE INDEX IF NOT EXISTS idx_right_person_art_d_app_num_code ON right_person_art_d(app_num);
CREATE INDEX IF NOT EXISTS idx_right_person_art_d_pe_num_code ON right_person_art_d(pe_num);
CREATE INDEX IF NOT EXISTS idx_right_person_art_d_right_person_appl_id_code ON right_person_art_d(right_person_appl_id);

-- 権利者記事ファイル(ハーグ) (登録マスタ)
CREATE TABLE IF NOT EXISTS right_person_art_hague (
    processing_type TEXT,
    law_cd TEXT,
    reg_num TEXT,
    split_num TEXT,
    app_num TEXT,
    rec_num TEXT,
    pe_num TEXT,
    right_psn_art_upd_ymd TEXT,
    right_person_appl_id TEXT,
    right_person_addr_len TEXT,
    right_person_addr TEXT,
    right_person_name_len TEXT,
    right_person_name TEXT
);

CREATE INDEX IF NOT EXISTS idx_right_person_art_hague_law_cd ON right_person_art_hague(law_cd);
CREATE INDEX IF NOT EXISTS idx_right_person_art_hague_reg_num ON right_person_art_hague(reg_num);
CREATE INDEX IF NOT EXISTS idx_right_person_art_hague_split_num ON right_person_art_hague(split_num);
CREATE INDEX IF NOT EXISTS idx_right_person_art_hague_app_num ON right_person_art_hague(app_num);
CREATE INDEX IF NOT EXISTS idx_right_person_art_hague_rec_num ON right_person_art_hague(rec_num);
CREATE INDEX IF NOT EXISTS idx_right_person_art_hague_pe_num ON right_person_art_hague(pe_num);
CREATE INDEX IF NOT EXISTS idx_right_person_art_hague_processing_type_code ON right_person_art_hague(processing_type);
CREATE INDEX IF NOT EXISTS idx_right_person_art_hague_law_cd_code ON right_person_art_hague(law_cd);
CREATE INDEX IF NOT EXISTS idx_right_person_art_hague_reg_num_code ON right_person_art_hague(reg_num);
CREATE INDEX IF NOT EXISTS idx_right_person_art_hague_split_num_code ON right_person_art_hague(split_num);
CREATE INDEX IF NOT EXISTS idx_right_person_art_hague_app_num_code ON right_person_art_hague(app_num);
CREATE INDEX IF NOT EXISTS idx_right_person_art_hague_pe_num_code ON right_person_art_hague(pe_num);
CREATE INDEX IF NOT EXISTS idx_right_person_art_hague_right_person_appl_id_code ON right_person_art_hague(right_person_appl_id);

-- 権利者記事ファイル(特許) (登録マスタ)
CREATE TABLE IF NOT EXISTS right_person_art_p (
    processing_type TEXT,
    law_cd TEXT,
    reg_num TEXT,
    split_num TEXT,
    app_num TEXT,
    rec_num TEXT,
    pe_num TEXT,
    right_psn_art_upd_ymd TEXT,
    right_person_appl_id TEXT,
    right_person_addr_len TEXT,
    right_person_addr TEXT,
    right_person_name_len TEXT,
    right_person_name TEXT
);

CREATE INDEX IF NOT EXISTS idx_right_person_art_p_law_cd ON right_person_art_p(law_cd);
CREATE INDEX IF NOT EXISTS idx_right_person_art_p_reg_num ON right_person_art_p(reg_num);
CREATE INDEX IF NOT EXISTS idx_right_person_art_p_split_num ON right_person_art_p(split_num);
CREATE INDEX IF NOT EXISTS idx_right_person_art_p_app_num ON right_person_art_p(app_num);
CREATE INDEX IF NOT EXISTS idx_right_person_art_p_rec_num ON right_person_art_p(rec_num);
CREATE INDEX IF NOT EXISTS idx_right_person_art_p_pe_num ON right_person_art_p(pe_num);
CREATE INDEX IF NOT EXISTS idx_right_person_art_p_processing_type_code ON right_person_art_p(processing_type);
CREATE INDEX IF NOT EXISTS idx_right_person_art_p_law_cd_code ON right_person_art_p(law_cd);
CREATE INDEX IF NOT EXISTS idx_right_person_art_p_reg_num_code ON right_person_art_p(reg_num);
CREATE INDEX IF NOT EXISTS idx_right_person_art_p_split_num_code ON right_person_art_p(split_num);
CREATE INDEX IF NOT EXISTS idx_right_person_art_p_app_num_code ON right_person_art_p(app_num);
CREATE INDEX IF NOT EXISTS idx_right_person_art_p_pe_num_code ON right_person_art_p(pe_num);
CREATE INDEX IF NOT EXISTS idx_right_person_art_p_right_person_appl_id_code ON right_person_art_p(right_person_appl_id);

-- 権利者記事ファイル(商標) (登録マスタ)
CREATE TABLE IF NOT EXISTS right_person_art_t (
    processing_type TEXT,
    law_cd TEXT,
    reg_num TEXT,
    split_num TEXT,
    app_num TEXT,
    rec_num TEXT,
    pe_num TEXT,
    right_psn_art_upd_ymd TEXT,
    right_person_appl_id TEXT,
    right_person_addr_len TEXT,
    right_person_addr TEXT,
    right_person_name_len TEXT,
    right_person_name TEXT
);

CREATE INDEX IF NOT EXISTS idx_right_person_art_t_law_cd ON right_person_art_t(law_cd);
CREATE INDEX IF NOT EXISTS idx_right_person_art_t_reg_num ON right_person_art_t(reg_num);
CREATE INDEX IF NOT EXISTS idx_right_person_art_t_split_num ON right_person_art_t(split_num);
CREATE INDEX IF NOT EXISTS idx_right_person_art_t_app_num ON right_person_art_t(app_num);
CREATE INDEX IF NOT EXISTS idx_right_person_art_t_rec_num ON right_person_art_t(rec_num);
CREATE INDEX IF NOT EXISTS idx_right_person_art_t_pe_num ON right_person_art_t(pe_num);
CREATE INDEX IF NOT EXISTS idx_right_person_art_t_processing_type_code ON right_person_art_t(processing_type);
CREATE INDEX IF NOT EXISTS idx_right_person_art_t_law_cd_code ON right_person_art_t(law_cd);
CREATE INDEX IF NOT EXISTS idx_right_person_art_t_reg_num_code ON right_person_art_t(reg_num);
CREATE INDEX IF NOT EXISTS idx_right_person_art_t_split_num_code ON right_person_art_t(split_num);
CREATE INDEX IF NOT EXISTS idx_right_person_art_t_app_num_code ON right_person_art_t(app_num);
CREATE INDEX IF NOT EXISTS idx_right_person_art_t_pe_num_code ON right_person_art_t(pe_num);
CREATE INDEX IF NOT EXISTS idx_right_person_art_t_right_person_appl_id_code ON right_person_art_t(right_person_appl_id);

-- 権利者記事ファイル(実用) (登録マスタ)
CREATE TABLE IF NOT EXISTS right_person_art_u (
    processing_type TEXT,
    law_cd TEXT,
    reg_num TEXT,
    split_num TEXT,
    app_num TEXT,
    rec_num TEXT,
    pe_num TEXT,
    right_psn_art_upd_ymd TEXT,
    right_person_appl_id TEXT,
    right_person_addr_len TEXT,
    right_person_addr TEXT,
    right_person_name_len TEXT,
    right_person_name TEXT
);

CREATE INDEX IF NOT EXISTS idx_right_person_art_u_law_cd ON right_person_art_u(law_cd);
CREATE INDEX IF NOT EXISTS idx_right_person_art_u_reg_num ON right_person_art_u(reg_num);
CREATE INDEX IF NOT EXISTS idx_right_person_art_u_split_num ON right_person_art_u(split_num);
CREATE INDEX IF NOT EXISTS idx_right_person_art_u_app_num ON right_person_art_u(app_num);
CREATE INDEX IF NOT EXISTS idx_right_person_art_u_rec_num ON right_person_art_u(rec_num);
CREATE INDEX IF NOT EXISTS idx_right_person_art_u_pe_num ON right_person_art_u(pe_num);
CREATE INDEX IF NOT EXISTS idx_right_person_art_u_processing_type_code ON right_person_art_u(processing_type);
CREATE INDEX IF NOT EXISTS idx_right_person_art_u_law_cd_code ON right_person_art_u(law_cd);
CREATE INDEX IF NOT EXISTS idx_right_person_art_u_reg_num_code ON right_person_art_u(reg_num);
CREATE INDEX IF NOT EXISTS idx_right_person_art_u_split_num_code ON right_person_art_u(split_num);
CREATE INDEX IF NOT EXISTS idx_right_person_art_u_app_num_code ON right_person_art_u(app_num);
CREATE INDEX IF NOT EXISTS idx_right_person_art_u_pe_num_code ON right_person_art_u(pe_num);
CREATE INDEX IF NOT EXISTS idx_right_person_art_u_right_person_appl_id_code ON right_person_art_u(right_person_appl_id);

-- 関連事件ファイル (審判マスタ)
CREATE TABLE IF NOT EXISTS rlt_case (
    processing_type VARCHAR(1),
    appl_num VARCHAR(10),
    sequence_num SMALLINT,
    rlt_case_typ VARCHAR(1),
    merge_appeal_flg VARCHAR(2),
    instance_typ VARCHAR(1),
    appl_typ VARCHAR(3),
    rlt_appl_num VARCHAR(10),
    updt_dttm VARCHAR(12),
    updt_dttm VARCHAR(12)
);

CREATE INDEX IF NOT EXISTS idx_rlt_case_appl_num ON rlt_case(appl_num);
CREATE INDEX IF NOT EXISTS idx_rlt_case_sequence_num ON rlt_case(sequence_num);

-- サーチマスタファイル (サーチマスタ)
CREATE TABLE IF NOT EXISTS search_mstr (
    del_flg TEXT,
    isn TEXT,
    app_num TEXT,
    rep_doc_num_pub_exam_pub_num TEXT,
    doc_num TEXT,
    doc_typ TEXT,
    app_dt TEXT,
    well_known_dt TEXT,
    invent_title TEXT
);

CREATE INDEX IF NOT EXISTS idx_search_mstr_isn ON search_mstr(isn);
CREATE INDEX IF NOT EXISTS idx_search_mstr_rep_doc_num_pub_exam_pub_num ON search_mstr(rep_doc_num_pub_exam_pub_num);
CREATE INDEX IF NOT EXISTS idx_search_mstr_app_num_code ON search_mstr(app_num);
CREATE INDEX IF NOT EXISTS idx_search_mstr_rep_doc_num_pub_exam_pub_num_code ON search_mstr(rep_doc_num_pub_exam_pub_num);
CREATE INDEX IF NOT EXISTS idx_search_mstr_doc_typ_code ON search_mstr(doc_typ);

-- サーチマスタ_Ｆタームファイル (サーチマスタ)
CREATE TABLE IF NOT EXISTS search_mstr_f_term (
    isn TEXT,
    rep_doc_num_pub_exam_pub_num TEXT,
    repeat_num INTEGER,
    f_term TEXT
);

CREATE INDEX IF NOT EXISTS idx_search_mstr_f_term_isn ON search_mstr_f_term(isn);
CREATE INDEX IF NOT EXISTS idx_search_mstr_f_term_rep_doc_num_pub_exam_pub_num ON search_mstr_f_term(rep_doc_num_pub_exam_pub_num);
CREATE INDEX IF NOT EXISTS idx_search_mstr_f_term_repeat_num ON search_mstr_f_term(repeat_num);
CREATE INDEX IF NOT EXISTS idx_search_mstr_f_term_rep_doc_num_pub_exam_pub_num_code ON search_mstr_f_term(rep_doc_num_pub_exam_pub_num);
CREATE INDEX IF NOT EXISTS idx_search_mstr_f_term_f_term_code ON search_mstr_f_term(f_term);

-- サーチマスタ_ファセットファイル (サーチマスタ)
CREATE TABLE IF NOT EXISTS search_mstr_facet (
    isn TEXT,
    rep_doc_num_pub_exam_pub_num TEXT,
    repeat_num INTEGER,
    facet TEXT
);

CREATE INDEX IF NOT EXISTS idx_search_mstr_facet_isn ON search_mstr_facet(isn);
CREATE INDEX IF NOT EXISTS idx_search_mstr_facet_rep_doc_num_pub_exam_pub_num ON search_mstr_facet(rep_doc_num_pub_exam_pub_num);
CREATE INDEX IF NOT EXISTS idx_search_mstr_facet_repeat_num ON search_mstr_facet(repeat_num);
CREATE INDEX IF NOT EXISTS idx_search_mstr_facet_rep_doc_num_pub_exam_pub_num_code ON search_mstr_facet(rep_doc_num_pub_exam_pub_num);

-- サーチマスタ_リンクＩＰＣファイル (サーチマスタ)
CREATE TABLE IF NOT EXISTS search_mstr_link_ipc (
    isn TEXT,
    rep_doc_num_pub_exam_pub_num TEXT,
    link_ipc_num INTEGER,
    repeat_num INTEGER,
    theme_link_ipc TEXT
);

CREATE INDEX IF NOT EXISTS idx_search_mstr_link_ipc_isn ON search_mstr_link_ipc(isn);
CREATE INDEX IF NOT EXISTS idx_search_mstr_link_ipc_rep_doc_num_pub_exam_pub_num ON search_mstr_link_ipc(rep_doc_num_pub_exam_pub_num);
CREATE INDEX IF NOT EXISTS idx_search_mstr_link_ipc_link_ipc_num ON search_mstr_link_ipc(link_ipc_num);
CREATE INDEX IF NOT EXISTS idx_search_mstr_link_ipc_repeat_num ON search_mstr_link_ipc(repeat_num);
CREATE INDEX IF NOT EXISTS idx_search_mstr_link_ipc_rep_doc_num_pub_exam_pub_num_code ON search_mstr_link_ipc(rep_doc_num_pub_exam_pub_num);

-- サーチマスタ_検索ＩＰＣファイル (サーチマスタ)
CREATE TABLE IF NOT EXISTS search_mstr_search_ipc (
    isn TEXT,
    rep_doc_num_pub_exam_pub_num TEXT,
    repeat_num INTEGER,
    ipc TEXT,
    id_sign TEXT,
    separate_vol_class_sign TEXT
);

CREATE INDEX IF NOT EXISTS idx_search_mstr_search_ipc_isn ON search_mstr_search_ipc(isn);
CREATE INDEX IF NOT EXISTS idx_search_mstr_search_ipc_rep_doc_num_pub_exam_pub_num ON search_mstr_search_ipc(rep_doc_num_pub_exam_pub_num);
CREATE INDEX IF NOT EXISTS idx_search_mstr_search_ipc_repeat_num ON search_mstr_search_ipc(repeat_num);
CREATE INDEX IF NOT EXISTS idx_search_mstr_search_ipc_rep_doc_num_pub_exam_pub_num_code ON search_mstr_search_ipc(rep_doc_num_pub_exam_pub_num);
CREATE INDEX IF NOT EXISTS idx_search_mstr_search_ipc_ipc_code ON search_mstr_search_ipc(ipc);
CREATE INDEX IF NOT EXISTS idx_search_mstr_search_ipc_id_sign_code ON search_mstr_search_ipc(id_sign);
CREATE INDEX IF NOT EXISTS idx_search_mstr_search_ipc_separate_vol_class_sign_code ON search_mstr_search_ipc(separate_vol_class_sign);

-- サーチマスタ_テーマファイル (サーチマスタ)
CREATE TABLE IF NOT EXISTS search_mstr_theme (
    isn TEXT,
    rep_doc_num_pub_exam_pub_num TEXT,
    repeat_num INTEGER,
    theme TEXT
);

CREATE INDEX IF NOT EXISTS idx_search_mstr_theme_isn ON search_mstr_theme(isn);
CREATE INDEX IF NOT EXISTS idx_search_mstr_theme_rep_doc_num_pub_exam_pub_num ON search_mstr_theme(rep_doc_num_pub_exam_pub_num);
CREATE INDEX IF NOT EXISTS idx_search_mstr_theme_repeat_num ON search_mstr_theme(repeat_num);
CREATE INDEX IF NOT EXISTS idx_search_mstr_theme_rep_doc_num_pub_exam_pub_num_code ON search_mstr_theme(rep_doc_num_pub_exam_pub_num);
CREATE INDEX IF NOT EXISTS idx_search_mstr_theme_theme_code ON search_mstr_theme(theme);

-- 検索用商標記事ファイル (商標基本マスタ)
CREATE TABLE IF NOT EXISTS search_use_t_art_table (
    add_del_id TEXT,
    app_num TEXT,
    split_num TEXT,
    sub_data_num TEXT,
    search_use_t_seq INTEGER,
    search_use_t TEXT
);

CREATE INDEX IF NOT EXISTS idx_search_use_t_art_table_app_num ON search_use_t_art_table(app_num);
CREATE INDEX IF NOT EXISTS idx_search_use_t_art_table_split_num ON search_use_t_art_table(split_num);
CREATE INDEX IF NOT EXISTS idx_search_use_t_art_table_sub_data_num ON search_use_t_art_table(sub_data_num);
CREATE INDEX IF NOT EXISTS idx_search_use_t_art_table_search_use_t_seq ON search_use_t_art_table(search_use_t_seq);
CREATE INDEX IF NOT EXISTS idx_search_use_t_art_table_add_del_id_code ON search_use_t_art_table(add_del_id);
CREATE INDEX IF NOT EXISTS idx_search_use_t_art_table_app_num_code ON search_use_t_art_table(app_num);
CREATE INDEX IF NOT EXISTS idx_search_use_t_art_table_split_num_code ON search_use_t_art_table(split_num);

-- 防護記事ファイル (登録マスタ)
CREATE TABLE IF NOT EXISTS sec_art (
    processing_type TEXT,
    law_cd TEXT,
    reg_num TEXT,
    split_num TEXT,
    app_num TEXT,
    pe_num TEXT,
    sec_art_upd_ymd TEXT,
    sec_app_num TEXT,
    sec_num TEXT,
    sec_temp_reg_flg TEXT,
    sec_conti_prd_expire_ymd TEXT,
    sec_ersr_flg TEXT,
    sec_apply_law TEXT,
    sec_recovery_num TEXT,
    sec_app_year_month_day TEXT,
    sec_app_exam_pub_num TEXT,
    sec_app_exam_pub_ymd TEXT,
    sec_finl_dcsn_year_month_day TEXT,
    sec_trial_dcsn_year_month_day TEXT,
    sec_reg_year_month_day TEXT,
    sec_rwrt_app_num TEXT,
    sec_rwrt_app_year_month_day TEXT,
    sec_rwrt_finl_dcsn_ymd TEXT,
    sec_rwrt_trial_dcsn_ymd TEXT,
    sec_rwrt_reg_year_month_day TEXT,
    mu_num TEXT,
    sec_desig_goods_desig_wrk_cls TEXT
);

CREATE INDEX IF NOT EXISTS idx_sec_art_law_cd ON sec_art(law_cd);
CREATE INDEX IF NOT EXISTS idx_sec_art_reg_num ON sec_art(reg_num);
CREATE INDEX IF NOT EXISTS idx_sec_art_split_num ON sec_art(split_num);
CREATE INDEX IF NOT EXISTS idx_sec_art_app_num ON sec_art(app_num);
CREATE INDEX IF NOT EXISTS idx_sec_art_pe_num ON sec_art(pe_num);
CREATE INDEX IF NOT EXISTS idx_sec_art_mu_num ON sec_art(mu_num);
CREATE INDEX IF NOT EXISTS idx_sec_art_processing_type_code ON sec_art(processing_type);
CREATE INDEX IF NOT EXISTS idx_sec_art_law_cd_code ON sec_art(law_cd);
CREATE INDEX IF NOT EXISTS idx_sec_art_reg_num_code ON sec_art(reg_num);
CREATE INDEX IF NOT EXISTS idx_sec_art_split_num_code ON sec_art(split_num);
CREATE INDEX IF NOT EXISTS idx_sec_art_app_num_code ON sec_art(app_num);
CREATE INDEX IF NOT EXISTS idx_sec_art_pe_num_code ON sec_art(pe_num);
CREATE INDEX IF NOT EXISTS idx_sec_art_sec_app_num_code ON sec_art(sec_app_num);
CREATE INDEX IF NOT EXISTS idx_sec_art_sec_num_code ON sec_art(sec_num);
CREATE INDEX IF NOT EXISTS idx_sec_art_sec_apply_law_code ON sec_art(sec_apply_law);
CREATE INDEX IF NOT EXISTS idx_sec_art_sec_recovery_num_code ON sec_art(sec_recovery_num);
CREATE INDEX IF NOT EXISTS idx_sec_art_sec_app_exam_pub_num_code ON sec_art(sec_app_exam_pub_num);
CREATE INDEX IF NOT EXISTS idx_sec_art_sec_rwrt_app_num_code ON sec_art(sec_rwrt_app_num);
CREATE INDEX IF NOT EXISTS idx_sec_art_mu_num_code ON sec_art(mu_num);
CREATE INDEX IF NOT EXISTS idx_sec_art_sec_desig_goods_desig_wrk_cls_code ON sec_art(sec_desig_goods_desig_wrk_cls);

-- 防護商品名ファイル (登録マスタ)
CREATE TABLE IF NOT EXISTS sec_goods_name (
    processing_type TEXT,
    law_cd TEXT,
    reg_num TEXT,
    split_num TEXT,
    sec_num TEXT,
    sec_app_num TEXT,
    sec_desig_goods_desig_wrk_cls TEXT,
    mstr_updt_year_month_day TEXT,
    sec_desig_gds_desig_wrk_nm_len TEXT,
    sec_desig_gds_nm_desig_wrk_nm TEXT
);

CREATE INDEX IF NOT EXISTS idx_sec_goods_name_law_cd ON sec_goods_name(law_cd);
CREATE INDEX IF NOT EXISTS idx_sec_goods_name_reg_num ON sec_goods_name(reg_num);
CREATE INDEX IF NOT EXISTS idx_sec_goods_name_split_num ON sec_goods_name(split_num);
CREATE INDEX IF NOT EXISTS idx_sec_goods_name_sec_num ON sec_goods_name(sec_num);
CREATE INDEX IF NOT EXISTS idx_sec_goods_name_sec_app_num ON sec_goods_name(sec_app_num);
CREATE INDEX IF NOT EXISTS idx_sec_goods_name_sec_desig_goods_desig_wrk_cls ON sec_goods_name(sec_desig_goods_desig_wrk_cls);
CREATE INDEX IF NOT EXISTS idx_sec_goods_name_processing_type_code ON sec_goods_name(processing_type);
CREATE INDEX IF NOT EXISTS idx_sec_goods_name_law_cd_code ON sec_goods_name(law_cd);
CREATE INDEX IF NOT EXISTS idx_sec_goods_name_reg_num_code ON sec_goods_name(reg_num);
CREATE INDEX IF NOT EXISTS idx_sec_goods_name_split_num_code ON sec_goods_name(split_num);
CREATE INDEX IF NOT EXISTS idx_sec_goods_name_sec_num_code ON sec_goods_name(sec_num);
CREATE INDEX IF NOT EXISTS idx_sec_goods_name_sec_app_num_code ON sec_goods_name(sec_app_num);
CREATE INDEX IF NOT EXISTS idx_sec_goods_name_sec_desig_goods_desig_wrk_cls_code ON sec_goods_name(sec_desig_goods_desig_wrk_cls);

-- 防護更新記事ファイル (登録マスタ)
CREATE TABLE IF NOT EXISTS sec_updt_art (
    processing_type TEXT,
    law_cd TEXT,
    reg_num TEXT,
    split_num TEXT,
    app_num TEXT,
    pe_num TEXT,
    sec_updt_art_upd_ymd TEXT,
    sec_updt_app_num TEXT,
    sec_updt_sec_num TEXT,
    sec_updt_temp_reg_flg TEXT,
    sec_updt_title_chan_flg TEXT,
    sec_updt_recovery_num TEXT,
    sec_updt_app_year_month_day TEXT,
    sec_updt_finl_dcsn_ymd TEXT,
    sec_updt_trial_dcsn_ymd TEXT,
    sec_updt_reg_year_month_day TEXT,
    mu_num TEXT
);

CREATE INDEX IF NOT EXISTS idx_sec_updt_art_law_cd ON sec_updt_art(law_cd);
CREATE INDEX IF NOT EXISTS idx_sec_updt_art_reg_num ON sec_updt_art(reg_num);
CREATE INDEX IF NOT EXISTS idx_sec_updt_art_split_num ON sec_updt_art(split_num);
CREATE INDEX IF NOT EXISTS idx_sec_updt_art_app_num ON sec_updt_art(app_num);
CREATE INDEX IF NOT EXISTS idx_sec_updt_art_pe_num ON sec_updt_art(pe_num);
CREATE INDEX IF NOT EXISTS idx_sec_updt_art_mu_num ON sec_updt_art(mu_num);
CREATE INDEX IF NOT EXISTS idx_sec_updt_art_processing_type_code ON sec_updt_art(processing_type);
CREATE INDEX IF NOT EXISTS idx_sec_updt_art_law_cd_code ON sec_updt_art(law_cd);
CREATE INDEX IF NOT EXISTS idx_sec_updt_art_reg_num_code ON sec_updt_art(reg_num);
CREATE INDEX IF NOT EXISTS idx_sec_updt_art_split_num_code ON sec_updt_art(split_num);
CREATE INDEX IF NOT EXISTS idx_sec_updt_art_app_num_code ON sec_updt_art(app_num);
CREATE INDEX IF NOT EXISTS idx_sec_updt_art_pe_num_code ON sec_updt_art(pe_num);
CREATE INDEX IF NOT EXISTS idx_sec_updt_art_sec_updt_app_num_code ON sec_updt_art(sec_updt_app_num);
CREATE INDEX IF NOT EXISTS idx_sec_updt_art_sec_updt_sec_num_code ON sec_updt_art(sec_updt_sec_num);
CREATE INDEX IF NOT EXISTS idx_sec_updt_art_sec_updt_title_chan_flg_code ON sec_updt_art(sec_updt_title_chan_flg);
CREATE INDEX IF NOT EXISTS idx_sec_updt_art_sec_updt_recovery_num_code ON sec_updt_art(sec_updt_recovery_num);
CREATE INDEX IF NOT EXISTS idx_sec_updt_art_mu_num_code ON sec_updt_art(mu_num);

-- 申請人情報ファイル (出願マスタ（特実）)
CREATE TABLE IF NOT EXISTS sinseinin (
    sinseinin_code TEXT,
    version_no INTEGER,
    kuni_code TEXT,
    todohuken_code TEXT,
    kohokan_sikibetu TEXT,
    masshoriyu_mark TEXT,
    togosinseinin_code TEXT
);

CREATE INDEX IF NOT EXISTS idx_sinseinin_sinseinin_code ON sinseinin(sinseinin_code);
CREATE INDEX IF NOT EXISTS idx_sinseinin_version_no ON sinseinin(version_no);
CREATE INDEX IF NOT EXISTS idx_sinseinin_sinseinin_code_code ON sinseinin(sinseinin_code);
CREATE INDEX IF NOT EXISTS idx_sinseinin_kuni_code_code ON sinseinin(kuni_code);
CREATE INDEX IF NOT EXISTS idx_sinseinin_todohuken_code_code ON sinseinin(todohuken_code);
CREATE INDEX IF NOT EXISTS idx_sinseinin_kohokan_sikibetu_code ON sinseinin(kohokan_sikibetu);
CREATE INDEX IF NOT EXISTS idx_sinseinin_masshoriyu_mark_code ON sinseinin(masshoriyu_mark);
CREATE INDEX IF NOT EXISTS idx_sinseinin_togosinseinin_code_code ON sinseinin(togosinseinin_code);

-- 再送ファイル (共有データベース（審判）)
CREATE TABLE IF NOT EXISTS sisu (
    skbt_flg TEXT,
    tyuni_syri_bngu TEXT,
    hssu_syri_bngu TEXT,
    sisu_dt TEXT,
    kusn_ntz_bat TEXT
);

CREATE INDEX IF NOT EXISTS idx_sisu_tyuni_syri_bngu ON sisu(tyuni_syri_bngu);
CREATE INDEX IF NOT EXISTS idx_sisu_skbt_flg_code ON sisu(skbt_flg);
CREATE INDEX IF NOT EXISTS idx_sisu_tyuni_syri_bngu_code ON sisu(tyuni_syri_bngu);
CREATE INDEX IF NOT EXISTS idx_sisu_hssu_syri_bngu_code ON sisu(hssu_syri_bngu);

-- 氏名通知ファイル (共有データベース（審判）)
CREATE TABLE IF NOT EXISTS smi_tut (
    skbt_flg TEXT,
    hssu_syri_bngu TEXT,
    snpn_bngu TEXT,
    gugti_rrk_rrk_bngu INTEGER,
    kusn_ntz_bat TEXT
);

CREATE INDEX IF NOT EXISTS idx_smi_tut_hssu_syri_bngu ON smi_tut(hssu_syri_bngu);
CREATE INDEX IF NOT EXISTS idx_smi_tut_skbt_flg_code ON smi_tut(skbt_flg);
CREATE INDEX IF NOT EXISTS idx_smi_tut_hssu_syri_bngu_code ON smi_tut(hssu_syri_bngu);
CREATE INDEX IF NOT EXISTS idx_smi_tut_snpn_bngu_code ON smi_tut(snpn_bngu);

-- 類似物品名ファイル (登録マスタ)
CREATE TABLE IF NOT EXISTS smlr_dsgn_commodity_name (
    processing_type TEXT,
    law_cd TEXT,
    reg_num TEXT,
    smlr_dsgn_num TEXT,
    smlr_dsgn_d_app_num TEXT,
    mstr_updt_year_month_day TEXT,
    smlr_dsgn_d_commodity_name_len TEXT,
    smlr_dsgn_d_commodity_name TEXT
);

CREATE INDEX IF NOT EXISTS idx_smlr_dsgn_commodity_name_law_cd ON smlr_dsgn_commodity_name(law_cd);
CREATE INDEX IF NOT EXISTS idx_smlr_dsgn_commodity_name_reg_num ON smlr_dsgn_commodity_name(reg_num);
CREATE INDEX IF NOT EXISTS idx_smlr_dsgn_commodity_name_smlr_dsgn_num ON smlr_dsgn_commodity_name(smlr_dsgn_num);
CREATE INDEX IF NOT EXISTS idx_smlr_dsgn_commodity_name_smlr_dsgn_d_app_num ON smlr_dsgn_commodity_name(smlr_dsgn_d_app_num);
CREATE INDEX IF NOT EXISTS idx_smlr_dsgn_commodity_name_processing_type_code ON smlr_dsgn_commodity_name(processing_type);
CREATE INDEX IF NOT EXISTS idx_smlr_dsgn_commodity_name_law_cd_code ON smlr_dsgn_commodity_name(law_cd);
CREATE INDEX IF NOT EXISTS idx_smlr_dsgn_commodity_name_reg_num_code ON smlr_dsgn_commodity_name(reg_num);
CREATE INDEX IF NOT EXISTS idx_smlr_dsgn_commodity_name_smlr_dsgn_num_code ON smlr_dsgn_commodity_name(smlr_dsgn_num);
CREATE INDEX IF NOT EXISTS idx_smlr_dsgn_commodity_name_smlr_dsgn_d_app_num_code ON smlr_dsgn_commodity_name(smlr_dsgn_d_app_num);

-- 類似意匠記事ファイル (登録マスタ)
CREATE TABLE IF NOT EXISTS smlr_dsgn_d_art (
    processing_type TEXT,
    law_cd TEXT,
    reg_num TEXT,
    split_num TEXT,
    app_num TEXT,
    pe_num TEXT,
    smlr_dsgn_d_art_upd_ymd TEXT,
    smlr_dsgn_d_app_num TEXT,
    smlr_dsgn_num TEXT,
    smlr_dsgn_d_sect_prd TEXT,
    smlr_dsgn_d_recovery_num TEXT,
    smlr_dsgn_d_app_year_month_day TEXT,
    smlr_dsgn_d_finl_dcsn_ymd TEXT,
    smlr_dsgn_d_trial_dcsn_ymd TEXT,
    smlr_dsgn_d_reg_year_month_day TEXT,
    smlr_dsgn_d_pri_cntry_name_cd TEXT,
    smlr_dsgn_d_pri_clim_ymd TEXT,
    smlr_dsgn_d_pri_clim_cnt TEXT
);

CREATE INDEX IF NOT EXISTS idx_smlr_dsgn_d_art_law_cd ON smlr_dsgn_d_art(law_cd);
CREATE INDEX IF NOT EXISTS idx_smlr_dsgn_d_art_reg_num ON smlr_dsgn_d_art(reg_num);
CREATE INDEX IF NOT EXISTS idx_smlr_dsgn_d_art_split_num ON smlr_dsgn_d_art(split_num);
CREATE INDEX IF NOT EXISTS idx_smlr_dsgn_d_art_app_num ON smlr_dsgn_d_art(app_num);
CREATE INDEX IF NOT EXISTS idx_smlr_dsgn_d_art_pe_num ON smlr_dsgn_d_art(pe_num);
CREATE INDEX IF NOT EXISTS idx_smlr_dsgn_d_art_processing_type_code ON smlr_dsgn_d_art(processing_type);
CREATE INDEX IF NOT EXISTS idx_smlr_dsgn_d_art_law_cd_code ON smlr_dsgn_d_art(law_cd);
CREATE INDEX IF NOT EXISTS idx_smlr_dsgn_d_art_reg_num_code ON smlr_dsgn_d_art(reg_num);
CREATE INDEX IF NOT EXISTS idx_smlr_dsgn_d_art_split_num_code ON smlr_dsgn_d_art(split_num);
CREATE INDEX IF NOT EXISTS idx_smlr_dsgn_d_art_app_num_code ON smlr_dsgn_d_art(app_num);
CREATE INDEX IF NOT EXISTS idx_smlr_dsgn_d_art_pe_num_code ON smlr_dsgn_d_art(pe_num);
CREATE INDEX IF NOT EXISTS idx_smlr_dsgn_d_art_smlr_dsgn_d_app_num_code ON smlr_dsgn_d_art(smlr_dsgn_d_app_num);
CREATE INDEX IF NOT EXISTS idx_smlr_dsgn_d_art_smlr_dsgn_num_code ON smlr_dsgn_d_art(smlr_dsgn_num);
CREATE INDEX IF NOT EXISTS idx_smlr_dsgn_d_art_smlr_dsgn_d_recovery_num_code ON smlr_dsgn_d_art(smlr_dsgn_d_recovery_num);
CREATE INDEX IF NOT EXISTS idx_smlr_dsgn_d_art_smlr_dsgn_d_pri_cntry_name_cd_code ON smlr_dsgn_d_art(smlr_dsgn_d_pri_cntry_name_cd);

-- 侵害訴訟ファイル (共有データベース（審判）)
CREATE TABLE IF NOT EXISTS sngi_ssyu (
    skbt_flg TEXT,
    sibnsy_cd TEXT,
    zkn_krk_hgu_cd TEXT,
    zkn_bngu TEXT,
    hyuzyu_sngi_ssyu_zkn_bngu_gngu TEXT,
    hyuzyu_sngi_ssyu_zkn_bngu_nnsu TEXT,
    hyuzyu_sngi_ssyu_zkn_bngu_tubn TEXT,
    sibnsy_sbtu TEXT,
    syukyk_dt TEXT,
    syukyk_zyu_cd TEXT,
    kusn_ntz_bat TEXT
);

CREATE INDEX IF NOT EXISTS idx_sngi_ssyu_sibnsy_cd ON sngi_ssyu(sibnsy_cd);
CREATE INDEX IF NOT EXISTS idx_sngi_ssyu_zkn_krk_hgu_cd ON sngi_ssyu(zkn_krk_hgu_cd);
CREATE INDEX IF NOT EXISTS idx_sngi_ssyu_zkn_bngu ON sngi_ssyu(zkn_bngu);
CREATE INDEX IF NOT EXISTS idx_sngi_ssyu_skbt_flg_code ON sngi_ssyu(skbt_flg);
CREATE INDEX IF NOT EXISTS idx_sngi_ssyu_sibnsy_cd_code ON sngi_ssyu(sibnsy_cd);
CREATE INDEX IF NOT EXISTS idx_sngi_ssyu_zkn_krk_hgu_cd_code ON sngi_ssyu(zkn_krk_hgu_cd);
CREATE INDEX IF NOT EXISTS idx_sngi_ssyu_syukyk_zyu_cd_code ON sngi_ssyu(syukyk_zyu_cd);

-- 侵害登録番号ファイル (共有データベース（審判）)
CREATE TABLE IF NOT EXISTS sngi_turk_bngu (
    skbt_flg TEXT,
    sibnsy_cd TEXT,
    zkn_krk_hgu_cd TEXT,
    zkn_bngu TEXT,
    krkes_bngu INTEGER,
    ynpu_kbn TEXT,
    turk_bngu TEXT,
    bnkt_bngu TEXT,
    riz_bngu TEXT,
    kusn_ntz_bat TEXT
);

CREATE INDEX IF NOT EXISTS idx_sngi_turk_bngu_sibnsy_cd ON sngi_turk_bngu(sibnsy_cd);
CREATE INDEX IF NOT EXISTS idx_sngi_turk_bngu_zkn_krk_hgu_cd ON sngi_turk_bngu(zkn_krk_hgu_cd);
CREATE INDEX IF NOT EXISTS idx_sngi_turk_bngu_zkn_bngu ON sngi_turk_bngu(zkn_bngu);
CREATE INDEX IF NOT EXISTS idx_sngi_turk_bngu_krkes_bngu ON sngi_turk_bngu(krkes_bngu);
CREATE INDEX IF NOT EXISTS idx_sngi_turk_bngu_skbt_flg_code ON sngi_turk_bngu(skbt_flg);
CREATE INDEX IF NOT EXISTS idx_sngi_turk_bngu_sibnsy_cd_code ON sngi_turk_bngu(sibnsy_cd);
CREATE INDEX IF NOT EXISTS idx_sngi_turk_bngu_zkn_krk_hgu_cd_code ON sngi_turk_bngu(zkn_krk_hgu_cd);
CREATE INDEX IF NOT EXISTS idx_sngi_turk_bngu_ynpu_kbn_code ON sngi_turk_bngu(ynpu_kbn);
CREATE INDEX IF NOT EXISTS idx_sngi_turk_bngu_turk_bngu_code ON sngi_turk_bngu(turk_bngu);
CREATE INDEX IF NOT EXISTS idx_sngi_turk_bngu_bnkt_bngu_code ON sngi_turk_bngu(bnkt_bngu);

-- 参加決定ファイル (共有データベース（審判）)
CREATE TABLE IF NOT EXISTS snk_ktti (
    skbt_flg TEXT,
    snpn_bngu TEXT,
    snk_snsi_bngu TEXT,
    hssu_syri_bngu TEXT,
    kusn_ntz_bat TEXT
);

CREATE INDEX IF NOT EXISTS idx_snk_ktti_snpn_bngu ON snk_ktti(snpn_bngu);
CREATE INDEX IF NOT EXISTS idx_snk_ktti_snk_snsi_bngu ON snk_ktti(snk_snsi_bngu);
CREATE INDEX IF NOT EXISTS idx_snk_ktti_skbt_flg_code ON snk_ktti(skbt_flg);
CREATE INDEX IF NOT EXISTS idx_snk_ktti_snpn_bngu_code ON snk_ktti(snpn_bngu);
CREATE INDEX IF NOT EXISTS idx_snk_ktti_hssu_syri_bngu_code ON snk_ktti(hssu_syri_bngu);

-- 参加決定分類ファイル (共有データベース（審判）)
CREATE TABLE IF NOT EXISTS snk_ktti_bnri (
    skbt_flg TEXT,
    snpn_bngu TEXT,
    snk_snsi_bngu TEXT,
    krkes_bngu INTEGER,
    ynpu_kbn TEXT,
    tkyu_huk_skbt TEXT,
    snkyu_sybt TEXT,
    snpn_sybt TEXT,
    hnz_zku_cd TEXT,
    snk_ktti_bnri_ktrn_cd TEXT,
    hj_bnri_skbt TEXT,
    kusn_ntz_bat TEXT
);

CREATE INDEX IF NOT EXISTS idx_snk_ktti_bnri_snpn_bngu ON snk_ktti_bnri(snpn_bngu);
CREATE INDEX IF NOT EXISTS idx_snk_ktti_bnri_snk_snsi_bngu ON snk_ktti_bnri(snk_snsi_bngu);
CREATE INDEX IF NOT EXISTS idx_snk_ktti_bnri_krkes_bngu ON snk_ktti_bnri(krkes_bngu);
CREATE INDEX IF NOT EXISTS idx_snk_ktti_bnri_skbt_flg_code ON snk_ktti_bnri(skbt_flg);
CREATE INDEX IF NOT EXISTS idx_snk_ktti_bnri_snpn_bngu_code ON snk_ktti_bnri(snpn_bngu);
CREATE INDEX IF NOT EXISTS idx_snk_ktti_bnri_ynpu_kbn_code ON snk_ktti_bnri(ynpu_kbn);
CREATE INDEX IF NOT EXISTS idx_snk_ktti_bnri_tkyu_huk_skbt_code ON snk_ktti_bnri(tkyu_huk_skbt);
CREATE INDEX IF NOT EXISTS idx_snk_ktti_bnri_snkyu_sybt_code ON snk_ktti_bnri(snkyu_sybt);
CREATE INDEX IF NOT EXISTS idx_snk_ktti_bnri_snpn_sybt_code ON snk_ktti_bnri(snpn_sybt);
CREATE INDEX IF NOT EXISTS idx_snk_ktti_bnri_hnz_zku_cd_code ON snk_ktti_bnri(hnz_zku_cd);
CREATE INDEX IF NOT EXISTS idx_snk_ktti_bnri_snk_ktti_bnri_ktrn_cd_code ON snk_ktti_bnri(snk_ktti_bnri_ktrn_cd);

-- 参加申請ファイル (共有データベース（審判）)
CREATE TABLE IF NOT EXISTS snk_snsi (
    skbt_flg TEXT,
    snpn_bngu TEXT,
    snk_snsi_bngu TEXT,
    snsi_dt TEXT,
    tiyu_skbt TEXT,
    sisyu_sybn_stat TEXT,
    kusn_ntz_bat TEXT
);

CREATE INDEX IF NOT EXISTS idx_snk_snsi_snpn_bngu ON snk_snsi(snpn_bngu);
CREATE INDEX IF NOT EXISTS idx_snk_snsi_snk_snsi_bngu ON snk_snsi(snk_snsi_bngu);
CREATE INDEX IF NOT EXISTS idx_snk_snsi_skbt_flg_code ON snk_snsi(skbt_flg);
CREATE INDEX IF NOT EXISTS idx_snk_snsi_snpn_bngu_code ON snk_snsi(snpn_bngu);
CREATE INDEX IF NOT EXISTS idx_snk_snsi_tiyu_skbt_code ON snk_snsi(tiyu_skbt);
CREATE INDEX IF NOT EXISTS idx_snk_snsi_sisyu_sybn_stat_code ON snk_snsi(sisyu_sybn_stat);

-- 新規性喪失例外ファイル (共有データベース（審判）)
CREATE TABLE IF NOT EXISTS snksi_sust_rigi (
    skbt_flg TEXT,
    snpn_bngu TEXT,
    krkes_bngu INTEGER,
    jubn_cd TEXT,
    niyu TEXT,
    kusn_ntz_bat TEXT
);

CREATE INDEX IF NOT EXISTS idx_snksi_sust_rigi_snpn_bngu ON snksi_sust_rigi(snpn_bngu);
CREATE INDEX IF NOT EXISTS idx_snksi_sust_rigi_krkes_bngu ON snksi_sust_rigi(krkes_bngu);
CREATE INDEX IF NOT EXISTS idx_snksi_sust_rigi_skbt_flg_code ON snksi_sust_rigi(skbt_flg);
CREATE INDEX IF NOT EXISTS idx_snksi_sust_rigi_snpn_bngu_code ON snksi_sust_rigi(snpn_bngu);
CREATE INDEX IF NOT EXISTS idx_snksi_sust_rigi_jubn_cd_code ON snksi_sust_rigi(jubn_cd);

-- 審決ファイル (共有データベース（審判）)
CREATE TABLE IF NOT EXISTS snkt (
    skbt_flg TEXT,
    snpn_bngu TEXT,
    snkt_bngu TEXT,
    hssu_syri_bngu TEXT,
    snkttu_kkti_stat TEXT,
    kusn_ntz_bat TEXT
);

CREATE INDEX IF NOT EXISTS idx_snkt_snpn_bngu ON snkt(snpn_bngu);
CREATE INDEX IF NOT EXISTS idx_snkt_snkt_bngu ON snkt(snkt_bngu);
CREATE INDEX IF NOT EXISTS idx_snkt_skbt_flg_code ON snkt(skbt_flg);
CREATE INDEX IF NOT EXISTS idx_snkt_snpn_bngu_code ON snkt(snpn_bngu);
CREATE INDEX IF NOT EXISTS idx_snkt_hssu_syri_bngu_code ON snkt(hssu_syri_bngu);
CREATE INDEX IF NOT EXISTS idx_snkt_snkttu_kkti_stat_code ON snkt(snkttu_kkti_stat);

-- 審決分類ファイル (共有データベース（審判）)
CREATE TABLE IF NOT EXISTS snkt_bnri (
    skbt_flg TEXT,
    snpn_bngu TEXT,
    snkt_bngu TEXT,
    krkes_bngu INTEGER,
    ynpu_kbn TEXT,
    tkyu_huk_skbt TEXT,
    snkyu_sybt TEXT,
    snpn_sybt TEXT,
    hnz_zku_cd TEXT,
    snkt_bnri_ktrn_cd TEXT,
    hj_bnri_skbt TEXT,
    kusn_ntz_bat TEXT
);

CREATE INDEX IF NOT EXISTS idx_snkt_bnri_snpn_bngu ON snkt_bnri(snpn_bngu);
CREATE INDEX IF NOT EXISTS idx_snkt_bnri_snkt_bngu ON snkt_bnri(snkt_bngu);
CREATE INDEX IF NOT EXISTS idx_snkt_bnri_krkes_bngu ON snkt_bnri(krkes_bngu);
CREATE INDEX IF NOT EXISTS idx_snkt_bnri_skbt_flg_code ON snkt_bnri(skbt_flg);
CREATE INDEX IF NOT EXISTS idx_snkt_bnri_snpn_bngu_code ON snkt_bnri(snpn_bngu);
CREATE INDEX IF NOT EXISTS idx_snkt_bnri_ynpu_kbn_code ON snkt_bnri(ynpu_kbn);
CREATE INDEX IF NOT EXISTS idx_snkt_bnri_tkyu_huk_skbt_code ON snkt_bnri(tkyu_huk_skbt);
CREATE INDEX IF NOT EXISTS idx_snkt_bnri_snkyu_sybt_code ON snkt_bnri(snkyu_sybt);
CREATE INDEX IF NOT EXISTS idx_snkt_bnri_snpn_sybt_code ON snkt_bnri(snpn_sybt);
CREATE INDEX IF NOT EXISTS idx_snkt_bnri_hnz_zku_cd_code ON snkt_bnri(hnz_zku_cd);
CREATE INDEX IF NOT EXISTS idx_snkt_bnri_snkt_bnri_ktrn_cd_code ON snkt_bnri(snkt_bnri_ktrn_cd);

-- 審判請求に係る指定商品・役務名ファイル (共有データベース（審判）)
CREATE TABLE IF NOT EXISTS snpn_sk_kkr_st_sh_ekmmi (
    skbt_flg TEXT,
    snpn_bngu TEXT,
    sikyu_tisyu_syuhn_kbn TEXT,
    sikyu_tisyu_sti_syuhn_ekmmi TEXT,
    kusn_ntz_bat TEXT
);

CREATE INDEX IF NOT EXISTS idx_snpn_sk_kkr_st_sh_ekmmi_snpn_bngu ON snpn_sk_kkr_st_sh_ekmmi(snpn_bngu);
CREATE INDEX IF NOT EXISTS idx_snpn_sk_kkr_st_sh_ekmmi_sikyu_tisyu_syuhn_kbn ON snpn_sk_kkr_st_sh_ekmmi(sikyu_tisyu_syuhn_kbn);
CREATE INDEX IF NOT EXISTS idx_snpn_sk_kkr_st_sh_ekmmi_skbt_flg_code ON snpn_sk_kkr_st_sh_ekmmi(skbt_flg);
CREATE INDEX IF NOT EXISTS idx_snpn_sk_kkr_st_sh_ekmmi_snpn_bngu_code ON snpn_sk_kkr_st_sh_ekmmi(snpn_bngu);
CREATE INDEX IF NOT EXISTS idx_snpn_sk_kkr_st_sh_ekmmi_sikyu_tisyu_syuhn_kbn_code ON snpn_sk_kkr_st_sh_ekmmi(sikyu_tisyu_syuhn_kbn);

-- 審判当事者ファイル (共有データベース（審判）)
CREATE TABLE IF NOT EXISTS snpn_tuzsy (
    skbt_flg TEXT,
    snpn_bngu TEXT,
    tuzsy_sybt TEXT,
    krkes_bngu INTEGER,
    ig_tuzsy_bngu TEXT,
    snk_snsi_bngu TEXT,
    snsinn_cd TEXT,
    dirnn_sybt TEXT,
    kusn_ntz_bat TEXT
);

CREATE INDEX IF NOT EXISTS idx_snpn_tuzsy_snpn_bngu ON snpn_tuzsy(snpn_bngu);
CREATE INDEX IF NOT EXISTS idx_snpn_tuzsy_tuzsy_sybt ON snpn_tuzsy(tuzsy_sybt);
CREATE INDEX IF NOT EXISTS idx_snpn_tuzsy_krkes_bngu ON snpn_tuzsy(krkes_bngu);
CREATE INDEX IF NOT EXISTS idx_snpn_tuzsy_skbt_flg_code ON snpn_tuzsy(skbt_flg);
CREATE INDEX IF NOT EXISTS idx_snpn_tuzsy_snpn_bngu_code ON snpn_tuzsy(snpn_bngu);
CREATE INDEX IF NOT EXISTS idx_snpn_tuzsy_tuzsy_sybt_code ON snpn_tuzsy(tuzsy_sybt);
CREATE INDEX IF NOT EXISTS idx_snpn_tuzsy_ig_tuzsy_bngu_code ON snpn_tuzsy(ig_tuzsy_bngu);
CREATE INDEX IF NOT EXISTS idx_snpn_tuzsy_snsinn_cd_code ON snpn_tuzsy(snsinn_cd);
CREATE INDEX IF NOT EXISTS idx_snpn_tuzsy_dirnn_sybt_code ON snpn_tuzsy(dirnn_sybt);

-- 審判当事者・申請人コード優先情報ファイル (共有データベース（審判）)
CREATE TABLE IF NOT EXISTS snpn_tzs_ssn_cd_ys_juhu (
    skbt_flg TEXT,
    snpn_bngu TEXT,
    tuzsy_sybt TEXT,
    krkes_bngu INTEGER,
    jusy TEXT,
    smi TEXT,
    khukn_kbn TEXT,
    kkkn_cd TEXT,
    dirnn_skk_sybt TEXT,
    kusn_ntz_bat TEXT
);

CREATE INDEX IF NOT EXISTS idx_snpn_tzs_ssn_cd_ys_juhu_snpn_bngu ON snpn_tzs_ssn_cd_ys_juhu(snpn_bngu);
CREATE INDEX IF NOT EXISTS idx_snpn_tzs_ssn_cd_ys_juhu_tuzsy_sybt ON snpn_tzs_ssn_cd_ys_juhu(tuzsy_sybt);
CREATE INDEX IF NOT EXISTS idx_snpn_tzs_ssn_cd_ys_juhu_krkes_bngu ON snpn_tzs_ssn_cd_ys_juhu(krkes_bngu);
CREATE INDEX IF NOT EXISTS idx_snpn_tzs_ssn_cd_ys_juhu_skbt_flg_code ON snpn_tzs_ssn_cd_ys_juhu(skbt_flg);
CREATE INDEX IF NOT EXISTS idx_snpn_tzs_ssn_cd_ys_juhu_snpn_bngu_code ON snpn_tzs_ssn_cd_ys_juhu(snpn_bngu);
CREATE INDEX IF NOT EXISTS idx_snpn_tzs_ssn_cd_ys_juhu_tuzsy_sybt_code ON snpn_tzs_ssn_cd_ys_juhu(tuzsy_sybt);
CREATE INDEX IF NOT EXISTS idx_snpn_tzs_ssn_cd_ys_juhu_khukn_kbn_code ON snpn_tzs_ssn_cd_ys_juhu(khukn_kbn);
CREATE INDEX IF NOT EXISTS idx_snpn_tzs_ssn_cd_ys_juhu_kkkn_cd_code ON snpn_tzs_ssn_cd_ys_juhu(kkkn_cd);
CREATE INDEX IF NOT EXISTS idx_snpn_tzs_ssn_cd_ys_juhu_dirnn_skk_sybt_code ON snpn_tzs_ssn_cd_ys_juhu(dirnn_skk_sybt);

-- 審判事件ファイル (共有データベース（審判）)
CREATE TABLE IF NOT EXISTS snpn_zkn (
    skbt_flg TEXT,
    snpn_bngu TEXT,
    sytgn_bngu TEXT,
    ynpu_kbn TEXT,
    turk_bngu TEXT,
    bnkt_bngu TEXT,
    riz_bngu TEXT,
    bug_bngu TEXT,
    snkyu_sybt TEXT,
    snpn_sybt TEXT,
    snpn_sikyu_dt TEXT,
    sytgn_bngu_kbn TEXT,
    snpn_zkn_sisyu_sybn_cd TEXT,
    sisyu_sybn_kkti_dt TEXT,
    kusn_ntz_bat TEXT
);

CREATE INDEX IF NOT EXISTS idx_snpn_zkn_snpn_bngu ON snpn_zkn(snpn_bngu);
CREATE INDEX IF NOT EXISTS idx_snpn_zkn_skbt_flg_code ON snpn_zkn(skbt_flg);
CREATE INDEX IF NOT EXISTS idx_snpn_zkn_snpn_bngu_code ON snpn_zkn(snpn_bngu);
CREATE INDEX IF NOT EXISTS idx_snpn_zkn_sytgn_bngu_code ON snpn_zkn(sytgn_bngu);
CREATE INDEX IF NOT EXISTS idx_snpn_zkn_ynpu_kbn_code ON snpn_zkn(ynpu_kbn);
CREATE INDEX IF NOT EXISTS idx_snpn_zkn_turk_bngu_code ON snpn_zkn(turk_bngu);
CREATE INDEX IF NOT EXISTS idx_snpn_zkn_bnkt_bngu_code ON snpn_zkn(bnkt_bngu);
CREATE INDEX IF NOT EXISTS idx_snpn_zkn_snkyu_sybt_code ON snpn_zkn(snkyu_sybt);
CREATE INDEX IF NOT EXISTS idx_snpn_zkn_snpn_sybt_code ON snpn_zkn(snpn_sybt);
CREATE INDEX IF NOT EXISTS idx_snpn_zkn_sytgn_bngu_kbn_code ON snpn_zkn(sytgn_bngu_kbn);
CREATE INDEX IF NOT EXISTS idx_snpn_zkn_snpn_zkn_sisyu_sybn_cd_code ON snpn_zkn(snpn_zkn_sisyu_sybn_cd);

-- サーチマスタ_正審査官フリーワードファイル (サーチマスタ)
CREATE TABLE IF NOT EXISTS srch_forward_exam_free_word (
    isn TEXT,
    rep_doc_num_pub_exam_pub_num TEXT,
    repeat_num INTEGER,
    forward_exmn_free_word_theme TEXT,
    forward_exmn_free_word_word TEXT
);

CREATE INDEX IF NOT EXISTS idx_srch_forward_exam_free_word_isn ON srch_forward_exam_free_word(isn);
CREATE INDEX IF NOT EXISTS idx_srch_forward_exam_free_word_rep_doc_num_pub_exam_pub_num ON srch_forward_exam_free_word(rep_doc_num_pub_exam_pub_num);
CREATE INDEX IF NOT EXISTS idx_srch_forward_exam_free_word_repeat_num ON srch_forward_exam_free_word(repeat_num);
CREATE INDEX IF NOT EXISTS idx_srch_forward_exam_free_word_rep_doc_num_pub_exam_pub_num_code ON srch_forward_exam_free_word(rep_doc_num_pub_exam_pub_num);

-- 標準文字商標記事ファイル (商標基本マスタ)
CREATE TABLE IF NOT EXISTS standard_char_t_art (
    add_del_id TEXT,
    app_num TEXT,
    split_num TEXT,
    sub_data_num TEXT,
    standard_char_t TEXT
);

CREATE INDEX IF NOT EXISTS idx_standard_char_t_art_app_num ON standard_char_t_art(app_num);
CREATE INDEX IF NOT EXISTS idx_standard_char_t_art_split_num ON standard_char_t_art(split_num);
CREATE INDEX IF NOT EXISTS idx_standard_char_t_art_sub_data_num ON standard_char_t_art(sub_data_num);
CREATE INDEX IF NOT EXISTS idx_standard_char_t_art_add_del_id_code ON standard_char_t_art(add_del_id);
CREATE INDEX IF NOT EXISTS idx_standard_char_t_art_app_num_code ON standard_char_t_art(app_num);
CREATE INDEX IF NOT EXISTS idx_standard_char_t_art_split_num_code ON standard_char_t_art(split_num);

-- 早期審理情報ファイル (共有データベース（審判）)
CREATE TABLE IF NOT EXISTS suk_snr_juhu (
    skbt_flg TEXT,
    snpn_bngu TEXT,
    suk_snr_snti_stat TEXT,
    kusn_ntz_bat TEXT
);

CREATE INDEX IF NOT EXISTS idx_suk_snr_juhu_snpn_bngu ON suk_snr_juhu(snpn_bngu);
CREATE INDEX IF NOT EXISTS idx_suk_snr_juhu_skbt_flg_code ON suk_snr_juhu(skbt_flg);
CREATE INDEX IF NOT EXISTS idx_suk_snr_juhu_snpn_bngu_code ON suk_snr_juhu(snpn_bngu);
CREATE INDEX IF NOT EXISTS idx_suk_snr_juhu_suk_snr_snti_stat_code ON suk_snr_juhu(suk_snr_snti_stat);

-- 送達ファイル (共有データベース（審判）)
CREATE TABLE IF NOT EXISTS sutt (
    skbt_flg TEXT,
    tyuni_syri_bngu TEXT,
    hssu_syri_bngu TEXT,
    sutt_dt TEXT,
    kusn_ntz_bat TEXT
);

CREATE INDEX IF NOT EXISTS idx_sutt_tyuni_syri_bngu ON sutt(tyuni_syri_bngu);
CREATE INDEX IF NOT EXISTS idx_sutt_skbt_flg_code ON sutt(skbt_flg);
CREATE INDEX IF NOT EXISTS idx_sutt_tyuni_syri_bngu_code ON sutt(tyuni_syri_bngu);
CREATE INDEX IF NOT EXISTS idx_sutt_hssu_syri_bngu_code ON sutt(hssu_syri_bngu);

-- 出訴・上告情報ファイル (共有データベース（審判）)
CREATE TABLE IF NOT EXISTS syss_jukk_juhu (
    skbt_flg TEXT,
    sibnsy_cd TEXT,
    zkn_krk_hgu_cd TEXT,
    zkn_bngu TEXT,
    krkes_bngu INTEGER,
    syss_jukk_zkn_bngu TEXT,
    syss_jukk_zkn_krk_hgu_cd TEXT,
    hyuzyu_zkn_bngu_gngu TEXT,
    hyuzyu_zkn_bngu_nnsu TEXT,
    hyuzyu_zkn_bngu_bngu TEXT,
    syss_jukk_dt TEXT,
    tiou_krkes_bngu INTEGER,
    kusn_ntz_bat TEXT
);

CREATE INDEX IF NOT EXISTS idx_syss_jukk_juhu_sibnsy_cd ON syss_jukk_juhu(sibnsy_cd);
CREATE INDEX IF NOT EXISTS idx_syss_jukk_juhu_zkn_krk_hgu_cd ON syss_jukk_juhu(zkn_krk_hgu_cd);
CREATE INDEX IF NOT EXISTS idx_syss_jukk_juhu_zkn_bngu ON syss_jukk_juhu(zkn_bngu);
CREATE INDEX IF NOT EXISTS idx_syss_jukk_juhu_krkes_bngu ON syss_jukk_juhu(krkes_bngu);
CREATE INDEX IF NOT EXISTS idx_syss_jukk_juhu_skbt_flg_code ON syss_jukk_juhu(skbt_flg);
CREATE INDEX IF NOT EXISTS idx_syss_jukk_juhu_sibnsy_cd_code ON syss_jukk_juhu(sibnsy_cd);
CREATE INDEX IF NOT EXISTS idx_syss_jukk_juhu_zkn_krk_hgu_cd_code ON syss_jukk_juhu(zkn_krk_hgu_cd);
CREATE INDEX IF NOT EXISTS idx_syss_jukk_juhu_syss_jukk_zkn_krk_hgu_cd_code ON syss_jukk_juhu(syss_jukk_zkn_krk_hgu_cd);

-- 出訴対象審決等ファイル (共有データベース（審判）)
CREATE TABLE IF NOT EXISTS syss_tisyu_snkttu (
    skbt_flg TEXT,
    sibnsy_cd TEXT,
    zkn_krk_hgu_cd TEXT,
    zkn_bngu TEXT,
    krkes_bngu INTEGER,
    snpn_bngu TEXT,
    hssu_syri_bngu TEXT,
    kusn_ntz_bat TEXT
);

CREATE INDEX IF NOT EXISTS idx_syss_tisyu_snkttu_sibnsy_cd ON syss_tisyu_snkttu(sibnsy_cd);
CREATE INDEX IF NOT EXISTS idx_syss_tisyu_snkttu_zkn_krk_hgu_cd ON syss_tisyu_snkttu(zkn_krk_hgu_cd);
CREATE INDEX IF NOT EXISTS idx_syss_tisyu_snkttu_zkn_bngu ON syss_tisyu_snkttu(zkn_bngu);
CREATE INDEX IF NOT EXISTS idx_syss_tisyu_snkttu_krkes_bngu ON syss_tisyu_snkttu(krkes_bngu);
CREATE INDEX IF NOT EXISTS idx_syss_tisyu_snkttu_skbt_flg_code ON syss_tisyu_snkttu(skbt_flg);
CREATE INDEX IF NOT EXISTS idx_syss_tisyu_snkttu_sibnsy_cd_code ON syss_tisyu_snkttu(sibnsy_cd);
CREATE INDEX IF NOT EXISTS idx_syss_tisyu_snkttu_zkn_krk_hgu_cd_code ON syss_tisyu_snkttu(zkn_krk_hgu_cd);
CREATE INDEX IF NOT EXISTS idx_syss_tisyu_snkttu_snpn_bngu_code ON syss_tisyu_snkttu(snpn_bngu);
CREATE INDEX IF NOT EXISTS idx_syss_tisyu_snkttu_hssu_syri_bngu_code ON syss_tisyu_snkttu(hssu_syri_bngu);

-- 商標付加情報記事ファイル (商標基本マスタ)
CREATE TABLE IF NOT EXISTS t_add_info (
    add_del_id TEXT,
    app_num TEXT,
    split_num TEXT,
    sub_data_num TEXT,
    right_request TEXT,
    grphc_id TEXT,
    color_harftone TEXT,
    gdmral_flg TEXT,
    duplicate_reg_flg TEXT,
    special_exception_clim_flg TEXT,
    consent_coe_reg_id TEXT
);

CREATE INDEX IF NOT EXISTS idx_t_add_info_app_num ON t_add_info(app_num);
CREATE INDEX IF NOT EXISTS idx_t_add_info_split_num ON t_add_info(split_num);
CREATE INDEX IF NOT EXISTS idx_t_add_info_sub_data_num ON t_add_info(sub_data_num);
CREATE INDEX IF NOT EXISTS idx_t_add_info_add_del_id_code ON t_add_info(add_del_id);
CREATE INDEX IF NOT EXISTS idx_t_add_info_app_num_code ON t_add_info(app_num);
CREATE INDEX IF NOT EXISTS idx_t_add_info_split_num_code ON t_add_info(split_num);
CREATE INDEX IF NOT EXISTS idx_t_add_info_right_request_code ON t_add_info(right_request);
CREATE INDEX IF NOT EXISTS idx_t_add_info_grphc_id_code ON t_add_info(grphc_id);
CREATE INDEX IF NOT EXISTS idx_t_add_info_color_harftone_code ON t_add_info(color_harftone);
CREATE INDEX IF NOT EXISTS idx_t_add_info_gdmral_flg_code ON t_add_info(gdmral_flg);
CREATE INDEX IF NOT EXISTS idx_t_add_info_duplicate_reg_flg_code ON t_add_info(duplicate_reg_flg);
CREATE INDEX IF NOT EXISTS idx_t_add_info_special_exception_clim_flg_code ON t_add_info(special_exception_clim_flg);
CREATE INDEX IF NOT EXISTS idx_t_add_info_consent_coe_reg_id_code ON t_add_info(consent_coe_reg_id);

-- 商標基本項目記事ファイル (商標基本マスタ)
CREATE TABLE IF NOT EXISTS t_basic_item_art (
    add_del_id TEXT,
    mgt_num INTEGER,
    rec_status_id TEXT,
    app_num TEXT,
    reg_num TEXT,
    split_num TEXT,
    sec_num TEXT,
    app_typ_sec TEXT,
    app_typ_split TEXT,
    app_typ_complement_rjct TEXT,
    app_typ_chan TEXT,
    app_typ_priorty TEXT,
    app_typ_group TEXT,
    app_typ_area_group TEXT,
    app_dt TEXT,
    prior_app_right_occr_dt TEXT,
    rjct_finl_dcsn_dsptch_dt TEXT,
    final_dspst_cd TEXT,
    final_dspst_dt TEXT,
    rwrt_app_num TEXT,
    old_law TEXT,
    ver_num TEXT,
    intl_reg_num TEXT,
    intl_reg_split_num TEXT,
    intl_reg_dt TEXT,
    rec_latest_updt_dt TEXT,
    conti_prd_expire_dt TEXT,
    instllmnt_expr_dt_aft_des_dt TEXT,
    installments_id TEXT,
    set_reg_dt TEXT
);

CREATE INDEX IF NOT EXISTS idx_t_basic_item_art_mgt_num ON t_basic_item_art(mgt_num);
CREATE INDEX IF NOT EXISTS idx_t_basic_item_art_add_del_id_code ON t_basic_item_art(add_del_id);
CREATE INDEX IF NOT EXISTS idx_t_basic_item_art_mgt_num_code ON t_basic_item_art(mgt_num);
CREATE INDEX IF NOT EXISTS idx_t_basic_item_art_rec_status_id_code ON t_basic_item_art(rec_status_id);
CREATE INDEX IF NOT EXISTS idx_t_basic_item_art_app_num_code ON t_basic_item_art(app_num);
CREATE INDEX IF NOT EXISTS idx_t_basic_item_art_reg_num_code ON t_basic_item_art(reg_num);
CREATE INDEX IF NOT EXISTS idx_t_basic_item_art_split_num_code ON t_basic_item_art(split_num);
CREATE INDEX IF NOT EXISTS idx_t_basic_item_art_app_typ_sec_code ON t_basic_item_art(app_typ_sec);
CREATE INDEX IF NOT EXISTS idx_t_basic_item_art_app_typ_split_code ON t_basic_item_art(app_typ_split);
CREATE INDEX IF NOT EXISTS idx_t_basic_item_art_app_typ_complement_rjct_code ON t_basic_item_art(app_typ_complement_rjct);
CREATE INDEX IF NOT EXISTS idx_t_basic_item_art_app_typ_chan_code ON t_basic_item_art(app_typ_chan);
CREATE INDEX IF NOT EXISTS idx_t_basic_item_art_app_typ_priorty_code ON t_basic_item_art(app_typ_priorty);
CREATE INDEX IF NOT EXISTS idx_t_basic_item_art_app_typ_group_code ON t_basic_item_art(app_typ_group);
CREATE INDEX IF NOT EXISTS idx_t_basic_item_art_app_typ_area_group_code ON t_basic_item_art(app_typ_area_group);
CREATE INDEX IF NOT EXISTS idx_t_basic_item_art_final_dspst_cd_code ON t_basic_item_art(final_dspst_cd);
CREATE INDEX IF NOT EXISTS idx_t_basic_item_art_old_law_code ON t_basic_item_art(old_law);
CREATE INDEX IF NOT EXISTS idx_t_basic_item_art_ver_num_code ON t_basic_item_art(ver_num);
CREATE INDEX IF NOT EXISTS idx_t_basic_item_art_intl_reg_num_code ON t_basic_item_art(intl_reg_num);
CREATE INDEX IF NOT EXISTS idx_t_basic_item_art_installments_id_code ON t_basic_item_art(installments_id);

-- 商標称呼記事ファイル (商標基本マスタ)
CREATE TABLE IF NOT EXISTS t_dsgnt_art (
    add_del_id TEXT,
    app_num TEXT,
    split_num TEXT,
    sub_data_num TEXT,
    dsgnt_seq INTEGER,
    dsgnt TEXT
);

CREATE INDEX IF NOT EXISTS idx_t_dsgnt_art_app_num ON t_dsgnt_art(app_num);
CREATE INDEX IF NOT EXISTS idx_t_dsgnt_art_split_num ON t_dsgnt_art(split_num);
CREATE INDEX IF NOT EXISTS idx_t_dsgnt_art_sub_data_num ON t_dsgnt_art(sub_data_num);
CREATE INDEX IF NOT EXISTS idx_t_dsgnt_art_dsgnt_seq ON t_dsgnt_art(dsgnt_seq);
CREATE INDEX IF NOT EXISTS idx_t_dsgnt_art_add_del_id_code ON t_dsgnt_art(add_del_id);
CREATE INDEX IF NOT EXISTS idx_t_dsgnt_art_app_num_code ON t_dsgnt_art(app_num);
CREATE INDEX IF NOT EXISTS idx_t_dsgnt_art_split_num_code ON t_dsgnt_art(split_num);

-- 商標第一表示部ファイル (登録マスタ)
CREATE TABLE IF NOT EXISTS t_first_indct_div (
    processing_type TEXT,
    law_cd TEXT,
    reg_num TEXT,
    split_num TEXT,
    history_num TEXT,
    mstr_updt_year_month_day TEXT,
    cancel_and_disposal_id TEXT,
    intl_reg_num TEXT,
    intl_reg_year_month_day TEXT,
    aft_desig_year_month_day TEXT
);

CREATE INDEX IF NOT EXISTS idx_t_first_indct_div_law_cd ON t_first_indct_div(law_cd);
CREATE INDEX IF NOT EXISTS idx_t_first_indct_div_reg_num ON t_first_indct_div(reg_num);
CREATE INDEX IF NOT EXISTS idx_t_first_indct_div_split_num ON t_first_indct_div(split_num);
CREATE INDEX IF NOT EXISTS idx_t_first_indct_div_history_num ON t_first_indct_div(history_num);
CREATE INDEX IF NOT EXISTS idx_t_first_indct_div_processing_type_code ON t_first_indct_div(processing_type);
CREATE INDEX IF NOT EXISTS idx_t_first_indct_div_law_cd_code ON t_first_indct_div(law_cd);
CREATE INDEX IF NOT EXISTS idx_t_first_indct_div_reg_num_code ON t_first_indct_div(reg_num);
CREATE INDEX IF NOT EXISTS idx_t_first_indct_div_split_num_code ON t_first_indct_div(split_num);
CREATE INDEX IF NOT EXISTS idx_t_first_indct_div_cancel_and_disposal_id_code ON t_first_indct_div(cancel_and_disposal_id);
CREATE INDEX IF NOT EXISTS idx_t_first_indct_div_intl_reg_num_code ON t_first_indct_div(intl_reg_num);

-- 商標類情報記事ファイル (商標基本マスタ)
CREATE TABLE IF NOT EXISTS t_knd_info_art_table (
    add_del_id TEXT,
    app_num TEXT,
    split_num TEXT,
    sub_data_num TEXT,
    knd TEXT,
    smlr_dsgn_group_cd TEXT
);

CREATE INDEX IF NOT EXISTS idx_t_knd_info_art_table_app_num ON t_knd_info_art_table(app_num);
CREATE INDEX IF NOT EXISTS idx_t_knd_info_art_table_split_num ON t_knd_info_art_table(split_num);
CREATE INDEX IF NOT EXISTS idx_t_knd_info_art_table_sub_data_num ON t_knd_info_art_table(sub_data_num);
CREATE INDEX IF NOT EXISTS idx_t_knd_info_art_table_knd ON t_knd_info_art_table(knd);
CREATE INDEX IF NOT EXISTS idx_t_knd_info_art_table_add_del_id_code ON t_knd_info_art_table(add_del_id);
CREATE INDEX IF NOT EXISTS idx_t_knd_info_art_table_app_num_code ON t_knd_info_art_table(app_num);
CREATE INDEX IF NOT EXISTS idx_t_knd_info_art_table_split_num_code ON t_knd_info_art_table(split_num);
CREATE INDEX IF NOT EXISTS idx_t_knd_info_art_table_knd_code ON t_knd_info_art_table(knd);
CREATE INDEX IF NOT EXISTS idx_t_knd_info_art_table_smlr_dsgn_group_cd_code ON t_knd_info_art_table(smlr_dsgn_group_cd);

-- 商標見本ファイル (商標見本ファイル)
CREATE TABLE IF NOT EXISTS t_sample (
    cntry_cd TEXT,
    doc_typ TEXT,
    doc_num TEXT,
    app_num TEXT,
    page_num TEXT,
    rec_seq_num TEXT,
    year_issu_cd TEXT,
    data_crt_dt TEXT,
    all_page_cnt TEXT,
    final_rec_seq_num TEXT,
    fullsize_length TEXT,
    fullsize_width TEXT,
    comp_frmlchk TEXT,
    resolution TEXT,
    linecnt_length TEXT,
    linecnt_width TEXT,
    image_data_len INTEGER,
    image_data TEXT
);

CREATE INDEX IF NOT EXISTS idx_t_sample_doc_num ON t_sample(doc_num);
CREATE INDEX IF NOT EXISTS idx_t_sample_page_num ON t_sample(page_num);
CREATE INDEX IF NOT EXISTS idx_t_sample_rec_seq_num ON t_sample(rec_seq_num);
CREATE INDEX IF NOT EXISTS idx_t_sample_year_issu_cd ON t_sample(year_issu_cd);
CREATE INDEX IF NOT EXISTS idx_t_sample_doc_num_code ON t_sample(doc_num);
CREATE INDEX IF NOT EXISTS idx_t_sample_app_num_code ON t_sample(app_num);
CREATE INDEX IF NOT EXISTS idx_t_sample_year_issu_cd_code ON t_sample(year_issu_cd);

-- 商標更新記事ファイル (登録マスタ)
CREATE TABLE IF NOT EXISTS t_updt_art (
    processing_type TEXT,
    law_cd TEXT,
    reg_num TEXT,
    split_num TEXT,
    app_num TEXT,
    pe_num TEXT,
    t_updt_art_upd_ymd TEXT,
    t_updt_app_num TEXT,
    t_updt_temp_reg_flg TEXT,
    t_updt_title_chan_flg TEXT,
    t_updt_recovery_num TEXT,
    t_updt_app_ymd_app_ymd TEXT,
    t_updt_finl_dcsn_ymd TEXT,
    t_updt_trial_dcsn_ymd TEXT,
    t_updt_reg_year_month_day TEXT,
    mu_num TEXT
);

CREATE INDEX IF NOT EXISTS idx_t_updt_art_law_cd ON t_updt_art(law_cd);
CREATE INDEX IF NOT EXISTS idx_t_updt_art_reg_num ON t_updt_art(reg_num);
CREATE INDEX IF NOT EXISTS idx_t_updt_art_split_num ON t_updt_art(split_num);
CREATE INDEX IF NOT EXISTS idx_t_updt_art_app_num ON t_updt_art(app_num);
CREATE INDEX IF NOT EXISTS idx_t_updt_art_pe_num ON t_updt_art(pe_num);
CREATE INDEX IF NOT EXISTS idx_t_updt_art_mu_num ON t_updt_art(mu_num);
CREATE INDEX IF NOT EXISTS idx_t_updt_art_processing_type_code ON t_updt_art(processing_type);
CREATE INDEX IF NOT EXISTS idx_t_updt_art_law_cd_code ON t_updt_art(law_cd);
CREATE INDEX IF NOT EXISTS idx_t_updt_art_reg_num_code ON t_updt_art(reg_num);
CREATE INDEX IF NOT EXISTS idx_t_updt_art_split_num_code ON t_updt_art(split_num);
CREATE INDEX IF NOT EXISTS idx_t_updt_art_app_num_code ON t_updt_art(app_num);
CREATE INDEX IF NOT EXISTS idx_t_updt_art_pe_num_code ON t_updt_art(pe_num);
CREATE INDEX IF NOT EXISTS idx_t_updt_art_t_updt_app_num_code ON t_updt_art(t_updt_app_num);
CREATE INDEX IF NOT EXISTS idx_t_updt_art_t_updt_title_chan_flg_code ON t_updt_art(t_updt_title_chan_flg);
CREATE INDEX IF NOT EXISTS idx_t_updt_art_t_updt_recovery_num_code ON t_updt_art(t_updt_recovery_num);
CREATE INDEX IF NOT EXISTS idx_t_updt_art_mu_num_code ON t_updt_art(mu_num);

-- ウィーン分類図形ターム記事ファイル (商標基本マスタ)
CREATE TABLE IF NOT EXISTS t_vienna_class_grphc_term_art (
    add_del_id TEXT,
    app_num TEXT,
    split_num TEXT,
    sub_data_num TEXT,
    grphc_term_large_class TEXT,
    grphc_term_mid_class TEXT,
    grphc_term_small_class TEXT,
    grphc_term_complement_sub_cls TEXT
);

CREATE INDEX IF NOT EXISTS idx_t_vienna_class_grphc_term_art_app_num ON t_vienna_class_grphc_term_art(app_num);
CREATE INDEX IF NOT EXISTS idx_t_vienna_class_grphc_term_art_split_num ON t_vienna_class_grphc_term_art(split_num);
CREATE INDEX IF NOT EXISTS idx_t_vienna_class_grphc_term_art_sub_data_num ON t_vienna_class_grphc_term_art(sub_data_num);
CREATE INDEX IF NOT EXISTS idx_t_vienna_class_grphc_term_art_grphc_term_large_class ON t_vienna_class_grphc_term_art(grphc_term_large_class);
CREATE INDEX IF NOT EXISTS idx_t_vienna_class_grphc_term_art_grphc_term_mid_class ON t_vienna_class_grphc_term_art(grphc_term_mid_class);
CREATE INDEX IF NOT EXISTS idx_t_vienna_class_grphc_term_art_grphc_term_small_class ON t_vienna_class_grphc_term_art(grphc_term_small_class);
CREATE INDEX IF NOT EXISTS idx_t_vienna_class_grphc_term_art_grphc_term_complement_sub_cls ON t_vienna_class_grphc_term_art(grphc_term_complement_sub_cls);
CREATE INDEX IF NOT EXISTS idx_t_vienna_class_grphc_term_art_add_del_id_code ON t_vienna_class_grphc_term_art(add_del_id);
CREATE INDEX IF NOT EXISTS idx_t_vienna_class_grphc_term_art_app_num_code ON t_vienna_class_grphc_term_art(app_num);
CREATE INDEX IF NOT EXISTS idx_t_vienna_class_grphc_term_art_split_num_code ON t_vienna_class_grphc_term_art(split_num);
CREATE INDEX IF NOT EXISTS idx_t_vienna_class_grphc_term_art_grphc_term_large_class_code ON t_vienna_class_grphc_term_art(grphc_term_large_class);
CREATE INDEX IF NOT EXISTS idx_t_vienna_class_grphc_term_art_grphc_term_mid_class_code ON t_vienna_class_grphc_term_art(grphc_term_mid_class);
CREATE INDEX IF NOT EXISTS idx_t_vienna_class_grphc_term_art_grphc_term_small_class_code ON t_vienna_class_grphc_term_art(grphc_term_small_class);
CREATE INDEX IF NOT EXISTS idx_t_vienna_class_grphc_term_art_grphc_term_complement_sub_cls_code ON t_vienna_class_grphc_term_art(grphc_term_complement_sub_cls);

-- 特許参考文献ファイル (共有データベース（審判）)
CREATE TABLE IF NOT EXISTS tkky_snku_bnkn (
    skbt_flg TEXT,
    snpn_bngu TEXT,
    krkes_bngu INTEGER,
    tkky_snku_bnknmi TEXT,
    kusn_ntz_bat TEXT
);

CREATE INDEX IF NOT EXISTS idx_tkky_snku_bnkn_snpn_bngu ON tkky_snku_bnkn(snpn_bngu);
CREATE INDEX IF NOT EXISTS idx_tkky_snku_bnkn_krkes_bngu ON tkky_snku_bnkn(krkes_bngu);
CREATE INDEX IF NOT EXISTS idx_tkky_snku_bnkn_skbt_flg_code ON tkky_snku_bnkn(skbt_flg);
CREATE INDEX IF NOT EXISTS idx_tkky_snku_bnkn_snpn_bngu_code ON tkky_snku_bnkn(snpn_bngu);

-- 審決ファイル (審判マスタ)
CREATE TABLE IF NOT EXISTS trial_dcsn (
    processing_type VARCHAR(1),
    appl_num VARCHAR(10),
    trial_dcsn_num VARCHAR(2),
    updt_dttm VARCHAR(12)
);

CREATE INDEX IF NOT EXISTS idx_trial_dcsn_appl_num ON trial_dcsn(appl_num);
CREATE INDEX IF NOT EXISTS idx_trial_dcsn_trial_dcsn_num ON trial_dcsn(trial_dcsn_num);

-- 審決分類コードファイル (審判マスタ)
CREATE TABLE IF NOT EXISTS trial_dcsn_class_cd (
    processing_type VARCHAR(1),
    appl_num VARCHAR(10),
    trial_dcsn_num VARCHAR(2),
    sequence_num SMALLINT,
    law_cd_class VARCHAR(1),
    apply_law_id VARCHAR(1),
    instance_typ VARCHAR(1),
    appl_typ VARCHAR(3),
    jdgmnt_item_cd VARCHAR(3),
    conclusion_cd VARCHAR(3),
    complement_sub_class_id VARCHAR(13),
    litigation_id VARCHAR(1),
    updt_dttm VARCHAR(12)
);

CREATE INDEX IF NOT EXISTS idx_trial_dcsn_class_cd_appl_num ON trial_dcsn_class_cd(appl_num);
CREATE INDEX IF NOT EXISTS idx_trial_dcsn_class_cd_trial_dcsn_num ON trial_dcsn_class_cd(trial_dcsn_num);
CREATE INDEX IF NOT EXISTS idx_trial_dcsn_class_cd_sequence_num ON trial_dcsn_class_cd(sequence_num);

-- 審決情報ファイル (審判マスタ)
CREATE TABLE IF NOT EXISTS trial_dcsn_info (
    processing_type VARCHAR(1),
    appl_num VARCHAR(10),
    rtrctd_dt VARCHAR(8),
    updt_dttm VARCHAR(12)
);

CREATE INDEX IF NOT EXISTS idx_trial_dcsn_info_appl_num ON trial_dcsn_info(appl_num);

-- 移転受付情報ファイル(意匠) (登録マスタ)
CREATE TABLE IF NOT EXISTS trnsfr_rcpt_info_d (
    processing_type TEXT,
    law_cd TEXT,
    reg_num TEXT,
    split_num TEXT,
    app_num TEXT,
    mrgn_info_upd_ymd TEXT,
    mu_num TEXT,
    trnsfr_rcpt_info TEXT
);

CREATE INDEX IF NOT EXISTS idx_trnsfr_rcpt_info_d_law_cd ON trnsfr_rcpt_info_d(law_cd);
CREATE INDEX IF NOT EXISTS idx_trnsfr_rcpt_info_d_reg_num ON trnsfr_rcpt_info_d(reg_num);
CREATE INDEX IF NOT EXISTS idx_trnsfr_rcpt_info_d_split_num ON trnsfr_rcpt_info_d(split_num);
CREATE INDEX IF NOT EXISTS idx_trnsfr_rcpt_info_d_app_num ON trnsfr_rcpt_info_d(app_num);
CREATE INDEX IF NOT EXISTS idx_trnsfr_rcpt_info_d_mu_num ON trnsfr_rcpt_info_d(mu_num);
CREATE INDEX IF NOT EXISTS idx_trnsfr_rcpt_info_d_processing_type_code ON trnsfr_rcpt_info_d(processing_type);
CREATE INDEX IF NOT EXISTS idx_trnsfr_rcpt_info_d_law_cd_code ON trnsfr_rcpt_info_d(law_cd);
CREATE INDEX IF NOT EXISTS idx_trnsfr_rcpt_info_d_reg_num_code ON trnsfr_rcpt_info_d(reg_num);
CREATE INDEX IF NOT EXISTS idx_trnsfr_rcpt_info_d_split_num_code ON trnsfr_rcpt_info_d(split_num);
CREATE INDEX IF NOT EXISTS idx_trnsfr_rcpt_info_d_app_num_code ON trnsfr_rcpt_info_d(app_num);
CREATE INDEX IF NOT EXISTS idx_trnsfr_rcpt_info_d_mu_num_code ON trnsfr_rcpt_info_d(mu_num);

-- 移転受付情報ファイル(ハーグ) (登録マスタ)
CREATE TABLE IF NOT EXISTS trnsfr_rcpt_info_hague (
    processing_type TEXT,
    law_cd TEXT,
    reg_num TEXT,
    split_num TEXT,
    app_num TEXT,
    mrgn_info_upd_ymd TEXT,
    mu_num TEXT,
    trnsfr_rcpt_info TEXT
);

CREATE INDEX IF NOT EXISTS idx_trnsfr_rcpt_info_hague_law_cd ON trnsfr_rcpt_info_hague(law_cd);
CREATE INDEX IF NOT EXISTS idx_trnsfr_rcpt_info_hague_reg_num ON trnsfr_rcpt_info_hague(reg_num);
CREATE INDEX IF NOT EXISTS idx_trnsfr_rcpt_info_hague_split_num ON trnsfr_rcpt_info_hague(split_num);
CREATE INDEX IF NOT EXISTS idx_trnsfr_rcpt_info_hague_app_num ON trnsfr_rcpt_info_hague(app_num);
CREATE INDEX IF NOT EXISTS idx_trnsfr_rcpt_info_hague_mu_num ON trnsfr_rcpt_info_hague(mu_num);
CREATE INDEX IF NOT EXISTS idx_trnsfr_rcpt_info_hague_processing_type_code ON trnsfr_rcpt_info_hague(processing_type);
CREATE INDEX IF NOT EXISTS idx_trnsfr_rcpt_info_hague_law_cd_code ON trnsfr_rcpt_info_hague(law_cd);
CREATE INDEX IF NOT EXISTS idx_trnsfr_rcpt_info_hague_reg_num_code ON trnsfr_rcpt_info_hague(reg_num);
CREATE INDEX IF NOT EXISTS idx_trnsfr_rcpt_info_hague_split_num_code ON trnsfr_rcpt_info_hague(split_num);
CREATE INDEX IF NOT EXISTS idx_trnsfr_rcpt_info_hague_app_num_code ON trnsfr_rcpt_info_hague(app_num);
CREATE INDEX IF NOT EXISTS idx_trnsfr_rcpt_info_hague_mu_num_code ON trnsfr_rcpt_info_hague(mu_num);

-- 移転受付情報ファイル(特許) (登録マスタ)
CREATE TABLE IF NOT EXISTS trnsfr_rcpt_info_p (
    processing_type TEXT,
    law_cd TEXT,
    reg_num TEXT,
    split_num TEXT,
    app_num TEXT,
    mrgn_info_upd_ymd TEXT,
    mu_num TEXT,
    trnsfr_rcpt_info TEXT
);

CREATE INDEX IF NOT EXISTS idx_trnsfr_rcpt_info_p_law_cd ON trnsfr_rcpt_info_p(law_cd);
CREATE INDEX IF NOT EXISTS idx_trnsfr_rcpt_info_p_reg_num ON trnsfr_rcpt_info_p(reg_num);
CREATE INDEX IF NOT EXISTS idx_trnsfr_rcpt_info_p_split_num ON trnsfr_rcpt_info_p(split_num);
CREATE INDEX IF NOT EXISTS idx_trnsfr_rcpt_info_p_app_num ON trnsfr_rcpt_info_p(app_num);
CREATE INDEX IF NOT EXISTS idx_trnsfr_rcpt_info_p_mu_num ON trnsfr_rcpt_info_p(mu_num);
CREATE INDEX IF NOT EXISTS idx_trnsfr_rcpt_info_p_processing_type_code ON trnsfr_rcpt_info_p(processing_type);
CREATE INDEX IF NOT EXISTS idx_trnsfr_rcpt_info_p_law_cd_code ON trnsfr_rcpt_info_p(law_cd);
CREATE INDEX IF NOT EXISTS idx_trnsfr_rcpt_info_p_reg_num_code ON trnsfr_rcpt_info_p(reg_num);
CREATE INDEX IF NOT EXISTS idx_trnsfr_rcpt_info_p_split_num_code ON trnsfr_rcpt_info_p(split_num);
CREATE INDEX IF NOT EXISTS idx_trnsfr_rcpt_info_p_app_num_code ON trnsfr_rcpt_info_p(app_num);
CREATE INDEX IF NOT EXISTS idx_trnsfr_rcpt_info_p_mu_num_code ON trnsfr_rcpt_info_p(mu_num);

-- 移転受付情報ファイル(商標) (登録マスタ)
CREATE TABLE IF NOT EXISTS trnsfr_rcpt_info_t (
    processing_type TEXT,
    law_cd TEXT,
    reg_num TEXT,
    split_num TEXT,
    app_num TEXT,
    mrgn_info_upd_ymd TEXT,
    mu_num TEXT,
    trnsfr_rcpt_info TEXT
);

CREATE INDEX IF NOT EXISTS idx_trnsfr_rcpt_info_t_law_cd ON trnsfr_rcpt_info_t(law_cd);
CREATE INDEX IF NOT EXISTS idx_trnsfr_rcpt_info_t_reg_num ON trnsfr_rcpt_info_t(reg_num);
CREATE INDEX IF NOT EXISTS idx_trnsfr_rcpt_info_t_split_num ON trnsfr_rcpt_info_t(split_num);
CREATE INDEX IF NOT EXISTS idx_trnsfr_rcpt_info_t_app_num ON trnsfr_rcpt_info_t(app_num);
CREATE INDEX IF NOT EXISTS idx_trnsfr_rcpt_info_t_mu_num ON trnsfr_rcpt_info_t(mu_num);
CREATE INDEX IF NOT EXISTS idx_trnsfr_rcpt_info_t_processing_type_code ON trnsfr_rcpt_info_t(processing_type);
CREATE INDEX IF NOT EXISTS idx_trnsfr_rcpt_info_t_law_cd_code ON trnsfr_rcpt_info_t(law_cd);
CREATE INDEX IF NOT EXISTS idx_trnsfr_rcpt_info_t_reg_num_code ON trnsfr_rcpt_info_t(reg_num);
CREATE INDEX IF NOT EXISTS idx_trnsfr_rcpt_info_t_split_num_code ON trnsfr_rcpt_info_t(split_num);
CREATE INDEX IF NOT EXISTS idx_trnsfr_rcpt_info_t_app_num_code ON trnsfr_rcpt_info_t(app_num);
CREATE INDEX IF NOT EXISTS idx_trnsfr_rcpt_info_t_mu_num_code ON trnsfr_rcpt_info_t(mu_num);

-- 移転受付情報ファイル(実用) (登録マスタ)
CREATE TABLE IF NOT EXISTS trnsfr_rcpt_info_u (
    processing_type TEXT,
    law_cd TEXT,
    reg_num TEXT,
    split_num TEXT,
    app_num TEXT,
    mrgn_info_upd_ymd TEXT,
    mu_num TEXT,
    trnsfr_rcpt_info TEXT
);

CREATE INDEX IF NOT EXISTS idx_trnsfr_rcpt_info_u_law_cd ON trnsfr_rcpt_info_u(law_cd);
CREATE INDEX IF NOT EXISTS idx_trnsfr_rcpt_info_u_reg_num ON trnsfr_rcpt_info_u(reg_num);
CREATE INDEX IF NOT EXISTS idx_trnsfr_rcpt_info_u_split_num ON trnsfr_rcpt_info_u(split_num);
CREATE INDEX IF NOT EXISTS idx_trnsfr_rcpt_info_u_app_num ON trnsfr_rcpt_info_u(app_num);
CREATE INDEX IF NOT EXISTS idx_trnsfr_rcpt_info_u_mu_num ON trnsfr_rcpt_info_u(mu_num);
CREATE INDEX IF NOT EXISTS idx_trnsfr_rcpt_info_u_processing_type_code ON trnsfr_rcpt_info_u(processing_type);
CREATE INDEX IF NOT EXISTS idx_trnsfr_rcpt_info_u_law_cd_code ON trnsfr_rcpt_info_u(law_cd);
CREATE INDEX IF NOT EXISTS idx_trnsfr_rcpt_info_u_reg_num_code ON trnsfr_rcpt_info_u(reg_num);
CREATE INDEX IF NOT EXISTS idx_trnsfr_rcpt_info_u_split_num_code ON trnsfr_rcpt_info_u(split_num);
CREATE INDEX IF NOT EXISTS idx_trnsfr_rcpt_info_u_app_num_code ON trnsfr_rcpt_info_u(app_num);
CREATE INDEX IF NOT EXISTS idx_trnsfr_rcpt_info_u_mu_num_code ON trnsfr_rcpt_info_u(mu_num);

-- 庁内書類ファイル (共有データベース（審判）)
CREATE TABLE IF NOT EXISTS tyuni_syri (
    skbt_flg TEXT,
    tyuni_syri_bngu TEXT,
    snpn_bngu TEXT,
    tyukn_cd TEXT,
    kan_dt TEXT,
    tyukn_krk_hyuzjn_kjn_dt TEXT,
    atsk_sybt TEXT,
    ig_tuzsy_bngu TEXT,
    snk_snsi_bngu TEXT,
    tyuni_syri_sksi_dt TEXT,
    yuku_flg TEXT,
    tiou_mk TEXT,
    etrn_kns_flg TEXT,
    syri_fomt_sybt TEXT,
    tyuni_syri_img_pagesu INTEGER,
    syri_siz INTEGER,
    kusn_ntz_bat TEXT
);

CREATE INDEX IF NOT EXISTS idx_tyuni_syri_tyuni_syri_bngu ON tyuni_syri(tyuni_syri_bngu);
CREATE INDEX IF NOT EXISTS idx_tyuni_syri_skbt_flg_code ON tyuni_syri(skbt_flg);
CREATE INDEX IF NOT EXISTS idx_tyuni_syri_tyuni_syri_bngu_code ON tyuni_syri(tyuni_syri_bngu);
CREATE INDEX IF NOT EXISTS idx_tyuni_syri_snpn_bngu_code ON tyuni_syri(snpn_bngu);
CREATE INDEX IF NOT EXISTS idx_tyuni_syri_tyukn_cd_code ON tyuni_syri(tyukn_cd);
CREATE INDEX IF NOT EXISTS idx_tyuni_syri_atsk_sybt_code ON tyuni_syri(atsk_sybt);
CREATE INDEX IF NOT EXISTS idx_tyuni_syri_ig_tuzsy_bngu_code ON tyuni_syri(ig_tuzsy_bngu);
CREATE INDEX IF NOT EXISTS idx_tyuni_syri_yuku_flg_code ON tyuni_syri(yuku_flg);
CREATE INDEX IF NOT EXISTS idx_tyuni_syri_tiou_mk_code ON tyuni_syri(tiou_mk);
CREATE INDEX IF NOT EXISTS idx_tyuni_syri_etrn_kns_flg_code ON tyuni_syri(etrn_kns_flg);
CREATE INDEX IF NOT EXISTS idx_tyuni_syri_syri_fomt_sybt_code ON tyuni_syri(syri_fomt_sybt);

-- 実用新案登録に基づく特許出願ファイル (審判マスタ)
CREATE TABLE IF NOT EXISTS u_model_reg_ascrb_p_app (
    processing_type VARCHAR(1),
    law_cd_class VARCHAR(1),
    app_num VARCHAR(10),
    new_app_law_cd_class VARCHAR(1),
    new_app_num VARCHAR(10),
    appl_ntc_reception_detail VARCHAR(1),
    updt_dttm VARCHAR(12)
);

CREATE INDEX IF NOT EXISTS idx_u_model_reg_ascrb_p_app_law_cd_class ON u_model_reg_ascrb_p_app(law_cd_class);
CREATE INDEX IF NOT EXISTS idx_u_model_reg_ascrb_p_app_app_num ON u_model_reg_ascrb_p_app(app_num);
CREATE INDEX IF NOT EXISTS idx_u_model_reg_ascrb_p_app_new_app_law_cd_class ON u_model_reg_ascrb_p_app(new_app_law_cd_class);
CREATE INDEX IF NOT EXISTS idx_u_model_reg_ascrb_p_app_new_app_num ON u_model_reg_ascrb_p_app(new_app_num);

-- 受付書類ファイル (共有データベース（審判）)
CREATE TABLE IF NOT EXISTS uktk_syri (
    skbt_flg TEXT,
    uktk_syri_bngu TEXT,
    snpn_bngu TEXT,
    tyukn_cd TEXT,
    syri_ssds_dt TEXT,
    syri_uktk_dt TEXT,
    sri_kykr_kbn TEXT,
    husk_sybn_stat TEXT,
    hssu_syri_bngu TEXT,
    sir_bngu TEXT,
    syri_sybt_cd TEXT,
    syri_bnri_cd TEXT,
    yuku_flg TEXT,
    tiou_mk TEXT,
    etrn_kns_flg TEXT,
    hnku_tisyu_sytgnnn_dirnn_cd TEXT,
    yusnkn_tisytkk_cd TEXT,
    syri_ztti_rrk_bngu INTEGER,
    misisy_ver TEXT,
    mkug_syri_um TEXT,
    syri_fomt_sybt TEXT,
    tksk_bngu TEXT,
    dna_hirthyu_um TEXT,
    yuyksy_tnp_syri_sikyu_hni_um TEXT,
    tnp_syri_pagesu INTEGER,
    syri_siz INTEGER,
    kusn_ntz_bat TEXT
);

CREATE INDEX IF NOT EXISTS idx_uktk_syri_uktk_syri_bngu ON uktk_syri(uktk_syri_bngu);
CREATE INDEX IF NOT EXISTS idx_uktk_syri_skbt_flg_code ON uktk_syri(skbt_flg);
CREATE INDEX IF NOT EXISTS idx_uktk_syri_uktk_syri_bngu_code ON uktk_syri(uktk_syri_bngu);
CREATE INDEX IF NOT EXISTS idx_uktk_syri_snpn_bngu_code ON uktk_syri(snpn_bngu);
CREATE INDEX IF NOT EXISTS idx_uktk_syri_tyukn_cd_code ON uktk_syri(tyukn_cd);
CREATE INDEX IF NOT EXISTS idx_uktk_syri_sri_kykr_kbn_code ON uktk_syri(sri_kykr_kbn);
CREATE INDEX IF NOT EXISTS idx_uktk_syri_husk_sybn_stat_code ON uktk_syri(husk_sybn_stat);
CREATE INDEX IF NOT EXISTS idx_uktk_syri_hssu_syri_bngu_code ON uktk_syri(hssu_syri_bngu);
CREATE INDEX IF NOT EXISTS idx_uktk_syri_syri_sybt_cd_code ON uktk_syri(syri_sybt_cd);
CREATE INDEX IF NOT EXISTS idx_uktk_syri_yuku_flg_code ON uktk_syri(yuku_flg);
CREATE INDEX IF NOT EXISTS idx_uktk_syri_tiou_mk_code ON uktk_syri(tiou_mk);
CREATE INDEX IF NOT EXISTS idx_uktk_syri_etrn_kns_flg_code ON uktk_syri(etrn_kns_flg);
CREATE INDEX IF NOT EXISTS idx_uktk_syri_mkug_syri_um_code ON uktk_syri(mkug_syri_um);
CREATE INDEX IF NOT EXISTS idx_uktk_syri_syri_fomt_sybt_code ON uktk_syri(syri_fomt_sybt);
CREATE INDEX IF NOT EXISTS idx_uktk_syri_dna_hirthyu_um_code ON uktk_syri(dna_hirthyu_um);
CREATE INDEX IF NOT EXISTS idx_uktk_syri_yuyksy_tnp_syri_sikyu_hni_um_code ON uktk_syri(yuyksy_tnp_syri_sikyu_hni_um);

-- 実用出願人発の事件書誌ファイル (出願マスタ（特実）)
CREATE TABLE IF NOT EXISTS umab_g_appl_case_biblog (
    law_cd TEXT,
    app_num TEXT,
    ab_delete_flg TEXT,
    ab_update_dttm TEXT,
    abcn_delete_flg TEXT,
    abcn_app_claim_cnt INTEGER,
    abcn_exam_pub_claim_cnt INTEGER,
    abcn_reg_claim_cnt INTEGER,
    abrt_delete_flg TEXT,
    abrt_right_trf TEXT,
    abrt_license_permission TEXT,
    abpp_delete_flg TEXT,
    abip_delete_flg TEXT,
    abna_delete_flg TEXT,
    abpa_delete_flg TEXT,
    abpa_parent_app_typ TEXT,
    abpa_parent_app_law_cd TEXT,
    abpa_parent_app_num TEXT,
    abpa_retroacted_dt TEXT,
    abdn_delete_flg TEXT,
    abdn_device_title TEXT,
    abaa_delete_flg TEXT,
    abde_delete_flg TEXT,
    abti_delete_flg TEXT,
    abds_delete_flg TEXT,
    abli_delete_flg TEXT,
    abdp_delete_flg TEXT,
    abnl_delete_flg TEXT,
    abnl_novelty_lack_class TEXT,
    abae_delete_flg TEXT,
    abct_delete_flg TEXT,
    aban_delete_flg TEXT
);

CREATE INDEX IF NOT EXISTS idx_umab_g_appl_case_biblog_law_cd ON umab_g_appl_case_biblog(law_cd);
CREATE INDEX IF NOT EXISTS idx_umab_g_appl_case_biblog_app_num ON umab_g_appl_case_biblog(app_num);
CREATE INDEX IF NOT EXISTS idx_umab_g_appl_case_biblog_law_cd_code ON umab_g_appl_case_biblog(law_cd);
CREATE INDEX IF NOT EXISTS idx_umab_g_appl_case_biblog_app_num_code ON umab_g_appl_case_biblog(app_num);
CREATE INDEX IF NOT EXISTS idx_umab_g_appl_case_biblog_ab_delete_flg_code ON umab_g_appl_case_biblog(ab_delete_flg);
CREATE INDEX IF NOT EXISTS idx_umab_g_appl_case_biblog_abcn_delete_flg_code ON umab_g_appl_case_biblog(abcn_delete_flg);
CREATE INDEX IF NOT EXISTS idx_umab_g_appl_case_biblog_abrt_delete_flg_code ON umab_g_appl_case_biblog(abrt_delete_flg);
CREATE INDEX IF NOT EXISTS idx_umab_g_appl_case_biblog_abrt_right_trf_code ON umab_g_appl_case_biblog(abrt_right_trf);
CREATE INDEX IF NOT EXISTS idx_umab_g_appl_case_biblog_abrt_license_permission_code ON umab_g_appl_case_biblog(abrt_license_permission);
CREATE INDEX IF NOT EXISTS idx_umab_g_appl_case_biblog_abpp_delete_flg_code ON umab_g_appl_case_biblog(abpp_delete_flg);
CREATE INDEX IF NOT EXISTS idx_umab_g_appl_case_biblog_abip_delete_flg_code ON umab_g_appl_case_biblog(abip_delete_flg);
CREATE INDEX IF NOT EXISTS idx_umab_g_appl_case_biblog_abna_delete_flg_code ON umab_g_appl_case_biblog(abna_delete_flg);
CREATE INDEX IF NOT EXISTS idx_umab_g_appl_case_biblog_abpa_delete_flg_code ON umab_g_appl_case_biblog(abpa_delete_flg);
CREATE INDEX IF NOT EXISTS idx_umab_g_appl_case_biblog_abpa_parent_app_typ_code ON umab_g_appl_case_biblog(abpa_parent_app_typ);
CREATE INDEX IF NOT EXISTS idx_umab_g_appl_case_biblog_abpa_parent_app_law_cd_code ON umab_g_appl_case_biblog(abpa_parent_app_law_cd);
CREATE INDEX IF NOT EXISTS idx_umab_g_appl_case_biblog_abpa_parent_app_num_code ON umab_g_appl_case_biblog(abpa_parent_app_num);
CREATE INDEX IF NOT EXISTS idx_umab_g_appl_case_biblog_abdn_delete_flg_code ON umab_g_appl_case_biblog(abdn_delete_flg);
CREATE INDEX IF NOT EXISTS idx_umab_g_appl_case_biblog_abaa_delete_flg_code ON umab_g_appl_case_biblog(abaa_delete_flg);
CREATE INDEX IF NOT EXISTS idx_umab_g_appl_case_biblog_abde_delete_flg_code ON umab_g_appl_case_biblog(abde_delete_flg);
CREATE INDEX IF NOT EXISTS idx_umab_g_appl_case_biblog_abti_delete_flg_code ON umab_g_appl_case_biblog(abti_delete_flg);
CREATE INDEX IF NOT EXISTS idx_umab_g_appl_case_biblog_abds_delete_flg_code ON umab_g_appl_case_biblog(abds_delete_flg);
CREATE INDEX IF NOT EXISTS idx_umab_g_appl_case_biblog_abli_delete_flg_code ON umab_g_appl_case_biblog(abli_delete_flg);
CREATE INDEX IF NOT EXISTS idx_umab_g_appl_case_biblog_abdp_delete_flg_code ON umab_g_appl_case_biblog(abdp_delete_flg);
CREATE INDEX IF NOT EXISTS idx_umab_g_appl_case_biblog_abnl_delete_flg_code ON umab_g_appl_case_biblog(abnl_delete_flg);
CREATE INDEX IF NOT EXISTS idx_umab_g_appl_case_biblog_abnl_novelty_lack_class_code ON umab_g_appl_case_biblog(abnl_novelty_lack_class);
CREATE INDEX IF NOT EXISTS idx_umab_g_appl_case_biblog_abae_delete_flg_code ON umab_g_appl_case_biblog(abae_delete_flg);
CREATE INDEX IF NOT EXISTS idx_umab_g_appl_case_biblog_abct_delete_flg_code ON umab_g_appl_case_biblog(abct_delete_flg);
CREATE INDEX IF NOT EXISTS idx_umab_g_appl_case_biblog_aban_delete_flg_code ON umab_g_appl_case_biblog(aban_delete_flg);

-- 実用出願人発の事件書誌繰返データファイル (出願マスタ（特実）)
CREATE TABLE IF NOT EXISTS umab_gr_appl_case_biblog (
    law_cd TEXT,
    app_num TEXT,
    article_id TEXT,
    repeat_num INTEGER,
    abpp_pri_app_num TEXT,
    abpp_pri_claim_dt TEXT,
    abpp_pri_cntry_cd TEXT,
    abip_intnl_pri_law_cd TEXT,
    abip_intnl_pri_app_num TEXT,
    abip_intl_app_num TEXT,
    abip_claim_dt TEXT,
    abna_newapp_app_typ TEXT,
    abna_newapp_law_cd TEXT,
    abna_newapp_app_num TEXT,
    abna_newapp_app_dt TEXT,
    abaa_appl_atty_class TEXT,
    abaa_appl_atty_id TEXT,
    abaa_change_num TEXT,
    abaa_req_typ TEXT,
    abaa_nationality_cd TEXT,
    abaa_pref_cd TEXT,
    abaa_rep_appl_id TEXT,
    abaa_above_appl_cnt INTEGER,
    abaa_atty_other_cnt INTEGER,
    abaa_atty_typ_cd TEXT,
    abaa_atty_qualify_cd TEXT,
    abaa_crrspnd_num TEXT,
    abde_device_creator_name TEXT,
    abde_device_creator_addr TEXT,
    abti_trust_typ TEXT,
    abti_nationality_cd TEXT,
    abti_name TEXT,
    abti_addr TEXT,
    abds_design_state_cd TEXT,
    abds_regional_patent_mk TEXT,
    abli_later_pri_law_cd TEXT,
    abli_later_pri_app_num TEXT,
    abli_later_pri_app_dt TEXT,
    abdp_mcrb_dpst_instt_id TEXT,
    abdp_mcrb_dpst_num TEXT,
    abnl_novelty_lack_art_cd TEXT,
    abnl_novelty_lack_content TEXT,
    abae_crrspnd_num TEXT,
    abae_appl_atty_addr TEXT,
    abae_appl_atty_name TEXT,
    abae_representative_name TEXT,
    abae_office_addr TEXT,
    abae_wrk_place_addr TEXT,
    abct_clmt_atty_id TEXT,
    abct_req_typ TEXT,
    abct_pref_cd TEXT,
    abct_rep_clmt_id TEXT,
    abct_atty_typ_cd TEXT,
    abct_crrspnd_num TEXT,
    aban_crrspnd_num TEXT,
    aban_clmt_atty_addr TEXT,
    aban_clmt_atty_name TEXT
);

CREATE INDEX IF NOT EXISTS idx_umab_gr_appl_case_biblog_law_cd ON umab_gr_appl_case_biblog(law_cd);
CREATE INDEX IF NOT EXISTS idx_umab_gr_appl_case_biblog_app_num ON umab_gr_appl_case_biblog(app_num);
CREATE INDEX IF NOT EXISTS idx_umab_gr_appl_case_biblog_article_id ON umab_gr_appl_case_biblog(article_id);
CREATE INDEX IF NOT EXISTS idx_umab_gr_appl_case_biblog_repeat_num ON umab_gr_appl_case_biblog(repeat_num);
CREATE INDEX IF NOT EXISTS idx_umab_gr_appl_case_biblog_law_cd_code ON umab_gr_appl_case_biblog(law_cd);
CREATE INDEX IF NOT EXISTS idx_umab_gr_appl_case_biblog_app_num_code ON umab_gr_appl_case_biblog(app_num);
CREATE INDEX IF NOT EXISTS idx_umab_gr_appl_case_biblog_article_id_code ON umab_gr_appl_case_biblog(article_id);
CREATE INDEX IF NOT EXISTS idx_umab_gr_appl_case_biblog_abpp_pri_app_num_code ON umab_gr_appl_case_biblog(abpp_pri_app_num);
CREATE INDEX IF NOT EXISTS idx_umab_gr_appl_case_biblog_abpp_pri_cntry_cd_code ON umab_gr_appl_case_biblog(abpp_pri_cntry_cd);
CREATE INDEX IF NOT EXISTS idx_umab_gr_appl_case_biblog_abip_intnl_pri_law_cd_code ON umab_gr_appl_case_biblog(abip_intnl_pri_law_cd);
CREATE INDEX IF NOT EXISTS idx_umab_gr_appl_case_biblog_abip_intnl_pri_app_num_code ON umab_gr_appl_case_biblog(abip_intnl_pri_app_num);
CREATE INDEX IF NOT EXISTS idx_umab_gr_appl_case_biblog_abip_intl_app_num_code ON umab_gr_appl_case_biblog(abip_intl_app_num);
CREATE INDEX IF NOT EXISTS idx_umab_gr_appl_case_biblog_abna_newapp_app_typ_code ON umab_gr_appl_case_biblog(abna_newapp_app_typ);
CREATE INDEX IF NOT EXISTS idx_umab_gr_appl_case_biblog_abna_newapp_law_cd_code ON umab_gr_appl_case_biblog(abna_newapp_law_cd);
CREATE INDEX IF NOT EXISTS idx_umab_gr_appl_case_biblog_abna_newapp_app_num_code ON umab_gr_appl_case_biblog(abna_newapp_app_num);
CREATE INDEX IF NOT EXISTS idx_umab_gr_appl_case_biblog_abaa_appl_atty_class_code ON umab_gr_appl_case_biblog(abaa_appl_atty_class);
CREATE INDEX IF NOT EXISTS idx_umab_gr_appl_case_biblog_abaa_appl_atty_id_code ON umab_gr_appl_case_biblog(abaa_appl_atty_id);
CREATE INDEX IF NOT EXISTS idx_umab_gr_appl_case_biblog_abaa_req_typ_code ON umab_gr_appl_case_biblog(abaa_req_typ);
CREATE INDEX IF NOT EXISTS idx_umab_gr_appl_case_biblog_abaa_nationality_cd_code ON umab_gr_appl_case_biblog(abaa_nationality_cd);
CREATE INDEX IF NOT EXISTS idx_umab_gr_appl_case_biblog_abaa_pref_cd_code ON umab_gr_appl_case_biblog(abaa_pref_cd);
CREATE INDEX IF NOT EXISTS idx_umab_gr_appl_case_biblog_abaa_rep_appl_id_code ON umab_gr_appl_case_biblog(abaa_rep_appl_id);
CREATE INDEX IF NOT EXISTS idx_umab_gr_appl_case_biblog_abaa_atty_typ_cd_code ON umab_gr_appl_case_biblog(abaa_atty_typ_cd);
CREATE INDEX IF NOT EXISTS idx_umab_gr_appl_case_biblog_abaa_atty_qualify_cd_code ON umab_gr_appl_case_biblog(abaa_atty_qualify_cd);
CREATE INDEX IF NOT EXISTS idx_umab_gr_appl_case_biblog_abaa_crrspnd_num_code ON umab_gr_appl_case_biblog(abaa_crrspnd_num);
CREATE INDEX IF NOT EXISTS idx_umab_gr_appl_case_biblog_abti_trust_typ_code ON umab_gr_appl_case_biblog(abti_trust_typ);
CREATE INDEX IF NOT EXISTS idx_umab_gr_appl_case_biblog_abti_nationality_cd_code ON umab_gr_appl_case_biblog(abti_nationality_cd);
CREATE INDEX IF NOT EXISTS idx_umab_gr_appl_case_biblog_abds_design_state_cd_code ON umab_gr_appl_case_biblog(abds_design_state_cd);
CREATE INDEX IF NOT EXISTS idx_umab_gr_appl_case_biblog_abds_regional_patent_mk_code ON umab_gr_appl_case_biblog(abds_regional_patent_mk);
CREATE INDEX IF NOT EXISTS idx_umab_gr_appl_case_biblog_abli_later_pri_law_cd_code ON umab_gr_appl_case_biblog(abli_later_pri_law_cd);
CREATE INDEX IF NOT EXISTS idx_umab_gr_appl_case_biblog_abli_later_pri_app_num_code ON umab_gr_appl_case_biblog(abli_later_pri_app_num);
CREATE INDEX IF NOT EXISTS idx_umab_gr_appl_case_biblog_abdp_mcrb_dpst_instt_id_code ON umab_gr_appl_case_biblog(abdp_mcrb_dpst_instt_id);
CREATE INDEX IF NOT EXISTS idx_umab_gr_appl_case_biblog_abdp_mcrb_dpst_num_code ON umab_gr_appl_case_biblog(abdp_mcrb_dpst_num);
CREATE INDEX IF NOT EXISTS idx_umab_gr_appl_case_biblog_abnl_novelty_lack_art_cd_code ON umab_gr_appl_case_biblog(abnl_novelty_lack_art_cd);
CREATE INDEX IF NOT EXISTS idx_umab_gr_appl_case_biblog_abae_crrspnd_num_code ON umab_gr_appl_case_biblog(abae_crrspnd_num);
CREATE INDEX IF NOT EXISTS idx_umab_gr_appl_case_biblog_abct_clmt_atty_id_code ON umab_gr_appl_case_biblog(abct_clmt_atty_id);
CREATE INDEX IF NOT EXISTS idx_umab_gr_appl_case_biblog_abct_req_typ_code ON umab_gr_appl_case_biblog(abct_req_typ);
CREATE INDEX IF NOT EXISTS idx_umab_gr_appl_case_biblog_abct_pref_cd_code ON umab_gr_appl_case_biblog(abct_pref_cd);
CREATE INDEX IF NOT EXISTS idx_umab_gr_appl_case_biblog_abct_rep_clmt_id_code ON umab_gr_appl_case_biblog(abct_rep_clmt_id);
CREATE INDEX IF NOT EXISTS idx_umab_gr_appl_case_biblog_abct_atty_typ_cd_code ON umab_gr_appl_case_biblog(abct_atty_typ_cd);
CREATE INDEX IF NOT EXISTS idx_umab_gr_appl_case_biblog_abct_crrspnd_num_code ON umab_gr_appl_case_biblog(abct_crrspnd_num);
CREATE INDEX IF NOT EXISTS idx_umab_gr_appl_case_biblog_aban_crrspnd_num_code ON umab_gr_appl_case_biblog(aban_crrspnd_num);

-- 実用出願事件ファイル (出願マスタ（特実）)
CREATE TABLE IF NOT EXISTS umac_g_app_case (
    law_cd TEXT,
    app_num TEXT,
    ac_delete_flg TEXT,
    ac_update_dttm TEXT,
    acai_delete_flg TEXT,
    acai_app_dt TEXT,
    acai_app_typ_1 TEXT,
    acai_app_typ_2 TEXT,
    acai_app_typ_3 TEXT,
    acai_app_typ_4 TEXT,
    acai_app_typ_5 TEXT,
    acai_refer_num TEXT,
    acai_org_lang_app_flg TEXT,
    acup_delete_flg TEXT,
    acup_pub_num TEXT,
    acup_pub_dt TEXT,
    actp_delete_flg TEXT,
    actp_trnsl_pub_num TEXT,
    actp_trnsl_pub_dt TEXT,
    actp_trnsl_repub_dt TEXT,
    acap_delete_flg TEXT,
    acld_delete_flg TEXT,
    acld_final_dspst_typ TEXT,
    acld_final_dspst_dt TEXT,
    acrg_delete_flg TEXT,
    acrg_reg_num TEXT,
    acrg_reg_dt TEXT,
    acrb_delete_flg TEXT,
    acrb_reg_bul_publish_dt TEXT,
    acia_delete_flg TEXT,
    acia_intl_app_num TEXT,
    acia_intl_pub_num TEXT,
    acia_intl_pub_dt TEXT,
    acia_trnsl_submit_dt TEXT,
    acia_lang_flg TEXT
);

CREATE INDEX IF NOT EXISTS idx_umac_g_app_case_law_cd ON umac_g_app_case(law_cd);
CREATE INDEX IF NOT EXISTS idx_umac_g_app_case_app_num ON umac_g_app_case(app_num);
CREATE INDEX IF NOT EXISTS idx_umac_g_app_case_law_cd_code ON umac_g_app_case(law_cd);
CREATE INDEX IF NOT EXISTS idx_umac_g_app_case_app_num_code ON umac_g_app_case(app_num);
CREATE INDEX IF NOT EXISTS idx_umac_g_app_case_ac_delete_flg_code ON umac_g_app_case(ac_delete_flg);
CREATE INDEX IF NOT EXISTS idx_umac_g_app_case_acai_delete_flg_code ON umac_g_app_case(acai_delete_flg);
CREATE INDEX IF NOT EXISTS idx_umac_g_app_case_acai_app_typ_1_code ON umac_g_app_case(acai_app_typ_1);
CREATE INDEX IF NOT EXISTS idx_umac_g_app_case_acai_app_typ_2_code ON umac_g_app_case(acai_app_typ_2);
CREATE INDEX IF NOT EXISTS idx_umac_g_app_case_acai_app_typ_3_code ON umac_g_app_case(acai_app_typ_3);
CREATE INDEX IF NOT EXISTS idx_umac_g_app_case_acai_app_typ_4_code ON umac_g_app_case(acai_app_typ_4);
CREATE INDEX IF NOT EXISTS idx_umac_g_app_case_acai_app_typ_5_code ON umac_g_app_case(acai_app_typ_5);
CREATE INDEX IF NOT EXISTS idx_umac_g_app_case_acai_refer_num_code ON umac_g_app_case(acai_refer_num);
CREATE INDEX IF NOT EXISTS idx_umac_g_app_case_acai_org_lang_app_flg_code ON umac_g_app_case(acai_org_lang_app_flg);
CREATE INDEX IF NOT EXISTS idx_umac_g_app_case_acup_delete_flg_code ON umac_g_app_case(acup_delete_flg);
CREATE INDEX IF NOT EXISTS idx_umac_g_app_case_acup_pub_num_code ON umac_g_app_case(acup_pub_num);
CREATE INDEX IF NOT EXISTS idx_umac_g_app_case_actp_delete_flg_code ON umac_g_app_case(actp_delete_flg);
CREATE INDEX IF NOT EXISTS idx_umac_g_app_case_actp_trnsl_pub_num_code ON umac_g_app_case(actp_trnsl_pub_num);
CREATE INDEX IF NOT EXISTS idx_umac_g_app_case_acap_delete_flg_code ON umac_g_app_case(acap_delete_flg);
CREATE INDEX IF NOT EXISTS idx_umac_g_app_case_acld_delete_flg_code ON umac_g_app_case(acld_delete_flg);
CREATE INDEX IF NOT EXISTS idx_umac_g_app_case_acld_final_dspst_typ_code ON umac_g_app_case(acld_final_dspst_typ);
CREATE INDEX IF NOT EXISTS idx_umac_g_app_case_acrg_delete_flg_code ON umac_g_app_case(acrg_delete_flg);
CREATE INDEX IF NOT EXISTS idx_umac_g_app_case_acrg_reg_num_code ON umac_g_app_case(acrg_reg_num);
CREATE INDEX IF NOT EXISTS idx_umac_g_app_case_acrb_delete_flg_code ON umac_g_app_case(acrb_delete_flg);
CREATE INDEX IF NOT EXISTS idx_umac_g_app_case_acia_delete_flg_code ON umac_g_app_case(acia_delete_flg);
CREATE INDEX IF NOT EXISTS idx_umac_g_app_case_acia_intl_app_num_code ON umac_g_app_case(acia_intl_app_num);
CREATE INDEX IF NOT EXISTS idx_umac_g_app_case_acia_intl_pub_num_code ON umac_g_app_case(acia_intl_pub_num);
CREATE INDEX IF NOT EXISTS idx_umac_g_app_case_acia_lang_flg_code ON umac_g_app_case(acia_lang_flg);

-- 実用出願事件繰返データファイル (出願マスタ（特実）)
CREATE TABLE IF NOT EXISTS umac_gr_app_case (
    law_cd TEXT,
    app_num TEXT,
    article_id TEXT,
    repeat_num INTEGER,
    acap_appeal_num TEXT
);

CREATE INDEX IF NOT EXISTS idx_umac_gr_app_case_law_cd ON umac_gr_app_case(law_cd);
CREATE INDEX IF NOT EXISTS idx_umac_gr_app_case_app_num ON umac_gr_app_case(app_num);
CREATE INDEX IF NOT EXISTS idx_umac_gr_app_case_article_id ON umac_gr_app_case(article_id);
CREATE INDEX IF NOT EXISTS idx_umac_gr_app_case_repeat_num ON umac_gr_app_case(repeat_num);
CREATE INDEX IF NOT EXISTS idx_umac_gr_app_case_law_cd_code ON umac_gr_app_case(law_cd);
CREATE INDEX IF NOT EXISTS idx_umac_gr_app_case_app_num_code ON umac_gr_app_case(app_num);
CREATE INDEX IF NOT EXISTS idx_umac_gr_app_case_article_id_code ON umac_gr_app_case(article_id);
CREATE INDEX IF NOT EXISTS idx_umac_gr_app_case_acap_appeal_num_code ON umac_gr_app_case(acap_appeal_num);

-- 実用出願書類ファイル (出願マスタ（特実）)
CREATE TABLE IF NOT EXISTS umap_g_app_doc (
    law_cd TEXT,
    app_num TEXT,
    storing_seq_num INTEGER,
    article_id TEXT,
    ap_delete_flg TEXT,
    ap_update_dttm TEXT,
    apad_delete_flg TEXT,
    apad_update_dttm TEXT,
    apad_create_dt TEXT,
    apad_valid_flg TEXT,
    apad_intrmd_doc_cd TEXT,
    apad_crrspnd_mk TEXT,
    apad_submit_dt TEXT,
    apad_rcpt_dt TEXT,
    apad_inspect_prhbt_flg TEXT,
    apad_cllctd_amount INTEGER,
    apad_opp_num TEXT,
    apad_rcpt_num TEXT,
    apad_frml_chked_mk TEXT,
    apad_instructed_flg TEXT,
    apad_dspst_dt TEXT,
    apad_change_appl_atty_id TEXT,
    apad_pri_submit_cntry_cd TEXT,
    apad_ver_num TEXT,
    apad_descript_ver_num TEXT,
    apad_invalid_doc_flg TEXT,
    apad_doc_frmt_typ TEXT,
    apad_crrspnd_doc_num TEXT,
    apad_doc_typ_cd TEXT,
    apad_amend_doc_rcpt_num TEXT,
    apad_store_num TEXT,
    apad_dna_flg TEXT,
    apad_description_page INTEGER,
    apad_descript_flg TEXT,
    apad_drawing_page INTEGER,
    apad_drawing_flg TEXT,
    apad_abstrct_doc_page INTEGER,
    apad_abstrct_flg TEXT,
    apad_attchd_doc_page INTEGER,
    apad_doc_size INTEGER,
    apdd_delete_flg TEXT,
    apdd_create_dt TEXT,
    apdd_valid_flg TEXT,
    apdd_intrmd_doc_cd TEXT,
    apdd_crrspnd_mk TEXT,
    apdd_draft_dt TEXT,
    apdd_dsptch_dt TEXT,
    apdd_inspect_prhbt_flg TEXT,
    apdd_cllctd_amount INTEGER,
    apdd_opp_num TEXT,
    apdd_dsptch_doc_num TEXT,
    apdd_rjct_reason_art_cd TEXT,
    apdd_ver_num TEXT,
    apdd_invalid_doc_flg TEXT,
    apdd_doc_frmt_typ TEXT,
    apdd_crrspnd_doc_num TEXT,
    apdd_doc_typ_cd TEXT,
    apdd_dsptch_doc_image_page INTEGER,
    apdd_doc_size INTEGER,
    apjd_delete_flg TEXT,
    apjd_create_dt TEXT,
    apjd_valid_flg TEXT,
    apjd_intrmd_doc_cd TEXT,
    apjd_crrspnd_mk TEXT,
    apjd_jpo_doc_create_dt TEXT,
    apjd_inspect_prhbt_flg TEXT,
    apjd_admnst_appeal_num TEXT,
    apjd_litigate_num TEXT,
    apjd_jpo_doc_num TEXT,
    apjd_goodmoral_violate_cd TEXT,
    apjd_ver_num TEXT,
    apjd_invalid_doc_flg TEXT,
    apjd_doc_frmt_typ TEXT,
    apjd_crrspnd_doc_num TEXT,
    apjd_doc_typ_cd TEXT,
    apjd_jpo_doc_image_page INTEGER,
    apjd_doc_size INTEGER
);

CREATE INDEX IF NOT EXISTS idx_umap_g_app_doc_law_cd ON umap_g_app_doc(law_cd);
CREATE INDEX IF NOT EXISTS idx_umap_g_app_doc_app_num ON umap_g_app_doc(app_num);
CREATE INDEX IF NOT EXISTS idx_umap_g_app_doc_storing_seq_num ON umap_g_app_doc(storing_seq_num);
CREATE INDEX IF NOT EXISTS idx_umap_g_app_doc_law_cd_code ON umap_g_app_doc(law_cd);
CREATE INDEX IF NOT EXISTS idx_umap_g_app_doc_app_num_code ON umap_g_app_doc(app_num);
CREATE INDEX IF NOT EXISTS idx_umap_g_app_doc_article_id_code ON umap_g_app_doc(article_id);
CREATE INDEX IF NOT EXISTS idx_umap_g_app_doc_ap_delete_flg_code ON umap_g_app_doc(ap_delete_flg);
CREATE INDEX IF NOT EXISTS idx_umap_g_app_doc_apad_delete_flg_code ON umap_g_app_doc(apad_delete_flg);
CREATE INDEX IF NOT EXISTS idx_umap_g_app_doc_apad_valid_flg_code ON umap_g_app_doc(apad_valid_flg);
CREATE INDEX IF NOT EXISTS idx_umap_g_app_doc_apad_intrmd_doc_cd_code ON umap_g_app_doc(apad_intrmd_doc_cd);
CREATE INDEX IF NOT EXISTS idx_umap_g_app_doc_apad_crrspnd_mk_code ON umap_g_app_doc(apad_crrspnd_mk);
CREATE INDEX IF NOT EXISTS idx_umap_g_app_doc_apad_inspect_prhbt_flg_code ON umap_g_app_doc(apad_inspect_prhbt_flg);
CREATE INDEX IF NOT EXISTS idx_umap_g_app_doc_apad_opp_num_code ON umap_g_app_doc(apad_opp_num);
CREATE INDEX IF NOT EXISTS idx_umap_g_app_doc_apad_rcpt_num_code ON umap_g_app_doc(apad_rcpt_num);
CREATE INDEX IF NOT EXISTS idx_umap_g_app_doc_apad_frml_chked_mk_code ON umap_g_app_doc(apad_frml_chked_mk);
CREATE INDEX IF NOT EXISTS idx_umap_g_app_doc_apad_instructed_flg_code ON umap_g_app_doc(apad_instructed_flg);
CREATE INDEX IF NOT EXISTS idx_umap_g_app_doc_apad_change_appl_atty_id_code ON umap_g_app_doc(apad_change_appl_atty_id);
CREATE INDEX IF NOT EXISTS idx_umap_g_app_doc_apad_ver_num_code ON umap_g_app_doc(apad_ver_num);
CREATE INDEX IF NOT EXISTS idx_umap_g_app_doc_apad_invalid_doc_flg_code ON umap_g_app_doc(apad_invalid_doc_flg);
CREATE INDEX IF NOT EXISTS idx_umap_g_app_doc_apad_doc_frmt_typ_code ON umap_g_app_doc(apad_doc_frmt_typ);
CREATE INDEX IF NOT EXISTS idx_umap_g_app_doc_apad_crrspnd_doc_num_code ON umap_g_app_doc(apad_crrspnd_doc_num);
CREATE INDEX IF NOT EXISTS idx_umap_g_app_doc_apad_doc_typ_cd_code ON umap_g_app_doc(apad_doc_typ_cd);
CREATE INDEX IF NOT EXISTS idx_umap_g_app_doc_apad_amend_doc_rcpt_num_code ON umap_g_app_doc(apad_amend_doc_rcpt_num);
CREATE INDEX IF NOT EXISTS idx_umap_g_app_doc_apdd_delete_flg_code ON umap_g_app_doc(apdd_delete_flg);
CREATE INDEX IF NOT EXISTS idx_umap_g_app_doc_apdd_valid_flg_code ON umap_g_app_doc(apdd_valid_flg);
CREATE INDEX IF NOT EXISTS idx_umap_g_app_doc_apdd_intrmd_doc_cd_code ON umap_g_app_doc(apdd_intrmd_doc_cd);
CREATE INDEX IF NOT EXISTS idx_umap_g_app_doc_apdd_crrspnd_mk_code ON umap_g_app_doc(apdd_crrspnd_mk);
CREATE INDEX IF NOT EXISTS idx_umap_g_app_doc_apdd_inspect_prhbt_flg_code ON umap_g_app_doc(apdd_inspect_prhbt_flg);
CREATE INDEX IF NOT EXISTS idx_umap_g_app_doc_apdd_opp_num_code ON umap_g_app_doc(apdd_opp_num);
CREATE INDEX IF NOT EXISTS idx_umap_g_app_doc_apdd_dsptch_doc_num_code ON umap_g_app_doc(apdd_dsptch_doc_num);
CREATE INDEX IF NOT EXISTS idx_umap_g_app_doc_apdd_rjct_reason_art_cd_code ON umap_g_app_doc(apdd_rjct_reason_art_cd);
CREATE INDEX IF NOT EXISTS idx_umap_g_app_doc_apdd_ver_num_code ON umap_g_app_doc(apdd_ver_num);
CREATE INDEX IF NOT EXISTS idx_umap_g_app_doc_apdd_invalid_doc_flg_code ON umap_g_app_doc(apdd_invalid_doc_flg);
CREATE INDEX IF NOT EXISTS idx_umap_g_app_doc_apdd_doc_frmt_typ_code ON umap_g_app_doc(apdd_doc_frmt_typ);
CREATE INDEX IF NOT EXISTS idx_umap_g_app_doc_apdd_crrspnd_doc_num_code ON umap_g_app_doc(apdd_crrspnd_doc_num);
CREATE INDEX IF NOT EXISTS idx_umap_g_app_doc_apdd_doc_typ_cd_code ON umap_g_app_doc(apdd_doc_typ_cd);
CREATE INDEX IF NOT EXISTS idx_umap_g_app_doc_apjd_delete_flg_code ON umap_g_app_doc(apjd_delete_flg);
CREATE INDEX IF NOT EXISTS idx_umap_g_app_doc_apjd_valid_flg_code ON umap_g_app_doc(apjd_valid_flg);
CREATE INDEX IF NOT EXISTS idx_umap_g_app_doc_apjd_intrmd_doc_cd_code ON umap_g_app_doc(apjd_intrmd_doc_cd);
CREATE INDEX IF NOT EXISTS idx_umap_g_app_doc_apjd_crrspnd_mk_code ON umap_g_app_doc(apjd_crrspnd_mk);
CREATE INDEX IF NOT EXISTS idx_umap_g_app_doc_apjd_inspect_prhbt_flg_code ON umap_g_app_doc(apjd_inspect_prhbt_flg);
CREATE INDEX IF NOT EXISTS idx_umap_g_app_doc_apjd_admnst_appeal_num_code ON umap_g_app_doc(apjd_admnst_appeal_num);
CREATE INDEX IF NOT EXISTS idx_umap_g_app_doc_apjd_litigate_num_code ON umap_g_app_doc(apjd_litigate_num);
CREATE INDEX IF NOT EXISTS idx_umap_g_app_doc_apjd_jpo_doc_num_code ON umap_g_app_doc(apjd_jpo_doc_num);
CREATE INDEX IF NOT EXISTS idx_umap_g_app_doc_apjd_goodmoral_violate_cd_code ON umap_g_app_doc(apjd_goodmoral_violate_cd);
CREATE INDEX IF NOT EXISTS idx_umap_g_app_doc_apjd_ver_num_code ON umap_g_app_doc(apjd_ver_num);
CREATE INDEX IF NOT EXISTS idx_umap_g_app_doc_apjd_invalid_doc_flg_code ON umap_g_app_doc(apjd_invalid_doc_flg);
CREATE INDEX IF NOT EXISTS idx_umap_g_app_doc_apjd_doc_frmt_typ_code ON umap_g_app_doc(apjd_doc_frmt_typ);
CREATE INDEX IF NOT EXISTS idx_umap_g_app_doc_apjd_crrspnd_doc_num_code ON umap_g_app_doc(apjd_crrspnd_doc_num);
CREATE INDEX IF NOT EXISTS idx_umap_g_app_doc_apjd_doc_typ_cd_code ON umap_g_app_doc(apjd_doc_typ_cd);

-- 実用事件ステータスファイル (出願マスタ（特実）)
CREATE TABLE IF NOT EXISTS umcs_g_case_stat (
    law_cd TEXT,
    app_num TEXT,
    cs_delete_flg TEXT,
    cs_update_dttm TEXT,
    cscs_delete_flg TEXT,
    cscs_exam_claim_list_mk TEXT,
    cscs_final_dspst_dt TEXT,
    cscs_acclrtd_exam_mk TEXT,
    cscs_pub_prep_flg TEXT,
    cscs_applicable_law_class TEXT,
    cscs_exam_typ TEXT,
    cscs_litigate_cd TEXT,
    cscs_final_decision_typ_cd TEXT,
    cscs_exam_claim_cnt INTEGER,
    cscs_newapp_flg TEXT,
    cscs_later_intnl_pri_flg TEXT,
    cscs_citd_others_mk TEXT
);

CREATE INDEX IF NOT EXISTS idx_umcs_g_case_stat_law_cd ON umcs_g_case_stat(law_cd);
CREATE INDEX IF NOT EXISTS idx_umcs_g_case_stat_app_num ON umcs_g_case_stat(app_num);
CREATE INDEX IF NOT EXISTS idx_umcs_g_case_stat_law_cd_code ON umcs_g_case_stat(law_cd);
CREATE INDEX IF NOT EXISTS idx_umcs_g_case_stat_app_num_code ON umcs_g_case_stat(app_num);
CREATE INDEX IF NOT EXISTS idx_umcs_g_case_stat_cs_delete_flg_code ON umcs_g_case_stat(cs_delete_flg);
CREATE INDEX IF NOT EXISTS idx_umcs_g_case_stat_cscs_delete_flg_code ON umcs_g_case_stat(cscs_delete_flg);
CREATE INDEX IF NOT EXISTS idx_umcs_g_case_stat_cscs_exam_claim_list_mk_code ON umcs_g_case_stat(cscs_exam_claim_list_mk);
CREATE INDEX IF NOT EXISTS idx_umcs_g_case_stat_cscs_acclrtd_exam_mk_code ON umcs_g_case_stat(cscs_acclrtd_exam_mk);
CREATE INDEX IF NOT EXISTS idx_umcs_g_case_stat_cscs_pub_prep_flg_code ON umcs_g_case_stat(cscs_pub_prep_flg);
CREATE INDEX IF NOT EXISTS idx_umcs_g_case_stat_cscs_applicable_law_class_code ON umcs_g_case_stat(cscs_applicable_law_class);
CREATE INDEX IF NOT EXISTS idx_umcs_g_case_stat_cscs_exam_typ_code ON umcs_g_case_stat(cscs_exam_typ);
CREATE INDEX IF NOT EXISTS idx_umcs_g_case_stat_cscs_litigate_cd_code ON umcs_g_case_stat(cscs_litigate_cd);
CREATE INDEX IF NOT EXISTS idx_umcs_g_case_stat_cscs_final_decision_typ_cd_code ON umcs_g_case_stat(cscs_final_decision_typ_cd);
CREATE INDEX IF NOT EXISTS idx_umcs_g_case_stat_cscs_newapp_flg_code ON umcs_g_case_stat(cscs_newapp_flg);

-- 実用特許庁発の事件書誌ファイル (出願マスタ（特実）)
CREATE TABLE IF NOT EXISTS umjb_g_jpo_case_biblog (
    law_cd TEXT,
    app_num TEXT,
    jb_delete_flg TEXT,
    jb_update_dttm TEXT,
    jbui_delete_flg TEXT,
    jbri_delete_flg TEXT,
    jbdc_delete_flg TEXT,
    jbdc_desig_class_ipc TEXT,
    jboi_delete_flg TEXT,
    jboi_staff_id TEXT,
    jboi_div_cd TEXT,
    jbpo_delete_flg TEXT,
    jbpo_goodmoral_mk TEXT,
    jbuf_delete_flg TEXT,
    jbrf_delete_flg TEXT,
    jbdf_delete_flg TEXT,
    jbdf_fi_section TEXT,
    jbdf_fi_class TEXT,
    jbdf_fi_subclass TEXT,
    jbdf_fi_main_grp TEXT,
    jbdf_fi_separator TEXT,
    jbdf_fi_sub_grp TEXT,
    jbdf_fi_subdiv_sign TEXT,
    jbdf_fi_separate_vol_class TEXT,
    jbdf_fi_facet TEXT
);

CREATE INDEX IF NOT EXISTS idx_umjb_g_jpo_case_biblog_law_cd ON umjb_g_jpo_case_biblog(law_cd);
CREATE INDEX IF NOT EXISTS idx_umjb_g_jpo_case_biblog_app_num ON umjb_g_jpo_case_biblog(app_num);
CREATE INDEX IF NOT EXISTS idx_umjb_g_jpo_case_biblog_law_cd_code ON umjb_g_jpo_case_biblog(law_cd);
CREATE INDEX IF NOT EXISTS idx_umjb_g_jpo_case_biblog_app_num_code ON umjb_g_jpo_case_biblog(app_num);
CREATE INDEX IF NOT EXISTS idx_umjb_g_jpo_case_biblog_jb_delete_flg_code ON umjb_g_jpo_case_biblog(jb_delete_flg);
CREATE INDEX IF NOT EXISTS idx_umjb_g_jpo_case_biblog_jbui_delete_flg_code ON umjb_g_jpo_case_biblog(jbui_delete_flg);
CREATE INDEX IF NOT EXISTS idx_umjb_g_jpo_case_biblog_jbri_delete_flg_code ON umjb_g_jpo_case_biblog(jbri_delete_flg);
CREATE INDEX IF NOT EXISTS idx_umjb_g_jpo_case_biblog_jbdc_delete_flg_code ON umjb_g_jpo_case_biblog(jbdc_delete_flg);
CREATE INDEX IF NOT EXISTS idx_umjb_g_jpo_case_biblog_jbdc_desig_class_ipc_code ON umjb_g_jpo_case_biblog(jbdc_desig_class_ipc);
CREATE INDEX IF NOT EXISTS idx_umjb_g_jpo_case_biblog_jboi_delete_flg_code ON umjb_g_jpo_case_biblog(jboi_delete_flg);
CREATE INDEX IF NOT EXISTS idx_umjb_g_jpo_case_biblog_jboi_staff_id_code ON umjb_g_jpo_case_biblog(jboi_staff_id);
CREATE INDEX IF NOT EXISTS idx_umjb_g_jpo_case_biblog_jboi_div_cd_code ON umjb_g_jpo_case_biblog(jboi_div_cd);
CREATE INDEX IF NOT EXISTS idx_umjb_g_jpo_case_biblog_jbpo_delete_flg_code ON umjb_g_jpo_case_biblog(jbpo_delete_flg);
CREATE INDEX IF NOT EXISTS idx_umjb_g_jpo_case_biblog_jbpo_goodmoral_mk_code ON umjb_g_jpo_case_biblog(jbpo_goodmoral_mk);
CREATE INDEX IF NOT EXISTS idx_umjb_g_jpo_case_biblog_jbuf_delete_flg_code ON umjb_g_jpo_case_biblog(jbuf_delete_flg);
CREATE INDEX IF NOT EXISTS idx_umjb_g_jpo_case_biblog_jbrf_delete_flg_code ON umjb_g_jpo_case_biblog(jbrf_delete_flg);
CREATE INDEX IF NOT EXISTS idx_umjb_g_jpo_case_biblog_jbdf_delete_flg_code ON umjb_g_jpo_case_biblog(jbdf_delete_flg);
CREATE INDEX IF NOT EXISTS idx_umjb_g_jpo_case_biblog_jbdf_fi_section_code ON umjb_g_jpo_case_biblog(jbdf_fi_section);
CREATE INDEX IF NOT EXISTS idx_umjb_g_jpo_case_biblog_jbdf_fi_class_code ON umjb_g_jpo_case_biblog(jbdf_fi_class);
CREATE INDEX IF NOT EXISTS idx_umjb_g_jpo_case_biblog_jbdf_fi_subclass_code ON umjb_g_jpo_case_biblog(jbdf_fi_subclass);
CREATE INDEX IF NOT EXISTS idx_umjb_g_jpo_case_biblog_jbdf_fi_main_grp_code ON umjb_g_jpo_case_biblog(jbdf_fi_main_grp);
CREATE INDEX IF NOT EXISTS idx_umjb_g_jpo_case_biblog_jbdf_fi_separator_code ON umjb_g_jpo_case_biblog(jbdf_fi_separator);
CREATE INDEX IF NOT EXISTS idx_umjb_g_jpo_case_biblog_jbdf_fi_sub_grp_code ON umjb_g_jpo_case_biblog(jbdf_fi_sub_grp);
CREATE INDEX IF NOT EXISTS idx_umjb_g_jpo_case_biblog_jbdf_fi_subdiv_sign_code ON umjb_g_jpo_case_biblog(jbdf_fi_subdiv_sign);
CREATE INDEX IF NOT EXISTS idx_umjb_g_jpo_case_biblog_jbdf_fi_separate_vol_class_code ON umjb_g_jpo_case_biblog(jbdf_fi_separate_vol_class);
CREATE INDEX IF NOT EXISTS idx_umjb_g_jpo_case_biblog_jbdf_fi_facet_code ON umjb_g_jpo_case_biblog(jbdf_fi_facet);

-- 実用特許庁発の事件書誌繰返データファイル (出願マスタ（特実）)
CREATE TABLE IF NOT EXISTS umjb_gr_jpo_case_biblog (
    law_cd TEXT,
    app_num TEXT,
    article_id TEXT,
    repeat_num INTEGER,
    jbui_amend_mk TEXT,
    jbui_ver_num TEXT,
    jbui_seq_num INTEGER,
    jbui_pub_ipc TEXT,
    jbri_amend_mk TEXT,
    jbri_ver_num TEXT,
    jbri_seq_num INTEGER,
    jbri_reg_ipc TEXT,
    jbuf_fi_class_typ TEXT,
    jbuf_fi_left_sign TEXT,
    jbuf_fi_section TEXT,
    jbuf_fi_class TEXT,
    jbuf_fi_subclass TEXT,
    jbuf_fi_main_grp TEXT,
    jbuf_fi_separator TEXT,
    jbuf_fi_sub_grp TEXT,
    jbuf_fi_subdiv_sign TEXT,
    jbuf_fi_separate_vol_class TEXT,
    jbuf_fi_facet TEXT,
    jbuf_fi_right_sign TEXT,
    jbuf_fi_jpo_refer_num TEXT,
    jbuf_fi_amend_mk TEXT,
    jbuf_fi_prlmnry TEXT,
    jbrf_fi_class_typ TEXT,
    jbrf_fi_left_sign TEXT,
    jbrf_fi_section TEXT,
    jbrf_fi_class TEXT,
    jbrf_fi_subclass TEXT,
    jbrf_fi_main_grp TEXT,
    jbrf_fi_separator TEXT,
    jbrf_fi_sub_grp TEXT,
    jbrf_fi_subdiv_sign TEXT,
    jbrf_fi_separate_vol_class TEXT,
    jbrf_fi_facet TEXT,
    jbrf_fi_right_sign TEXT,
    jbrf_fi_jpo_refer_num TEXT,
    jbrf_fi_amend_mk TEXT,
    jbrf_fi_prlmnry TEXT
);

CREATE INDEX IF NOT EXISTS idx_umjb_gr_jpo_case_biblog_law_cd ON umjb_gr_jpo_case_biblog(law_cd);
CREATE INDEX IF NOT EXISTS idx_umjb_gr_jpo_case_biblog_app_num ON umjb_gr_jpo_case_biblog(app_num);
CREATE INDEX IF NOT EXISTS idx_umjb_gr_jpo_case_biblog_article_id ON umjb_gr_jpo_case_biblog(article_id);
CREATE INDEX IF NOT EXISTS idx_umjb_gr_jpo_case_biblog_repeat_num ON umjb_gr_jpo_case_biblog(repeat_num);
CREATE INDEX IF NOT EXISTS idx_umjb_gr_jpo_case_biblog_law_cd_code ON umjb_gr_jpo_case_biblog(law_cd);
CREATE INDEX IF NOT EXISTS idx_umjb_gr_jpo_case_biblog_app_num_code ON umjb_gr_jpo_case_biblog(app_num);
CREATE INDEX IF NOT EXISTS idx_umjb_gr_jpo_case_biblog_article_id_code ON umjb_gr_jpo_case_biblog(article_id);
CREATE INDEX IF NOT EXISTS idx_umjb_gr_jpo_case_biblog_jbui_amend_mk_code ON umjb_gr_jpo_case_biblog(jbui_amend_mk);
CREATE INDEX IF NOT EXISTS idx_umjb_gr_jpo_case_biblog_jbui_ver_num_code ON umjb_gr_jpo_case_biblog(jbui_ver_num);
CREATE INDEX IF NOT EXISTS idx_umjb_gr_jpo_case_biblog_jbui_seq_num_code ON umjb_gr_jpo_case_biblog(jbui_seq_num);
CREATE INDEX IF NOT EXISTS idx_umjb_gr_jpo_case_biblog_jbui_pub_ipc_code ON umjb_gr_jpo_case_biblog(jbui_pub_ipc);
CREATE INDEX IF NOT EXISTS idx_umjb_gr_jpo_case_biblog_jbri_amend_mk_code ON umjb_gr_jpo_case_biblog(jbri_amend_mk);
CREATE INDEX IF NOT EXISTS idx_umjb_gr_jpo_case_biblog_jbri_ver_num_code ON umjb_gr_jpo_case_biblog(jbri_ver_num);
CREATE INDEX IF NOT EXISTS idx_umjb_gr_jpo_case_biblog_jbri_seq_num_code ON umjb_gr_jpo_case_biblog(jbri_seq_num);
CREATE INDEX IF NOT EXISTS idx_umjb_gr_jpo_case_biblog_jbuf_fi_class_typ_code ON umjb_gr_jpo_case_biblog(jbuf_fi_class_typ);
CREATE INDEX IF NOT EXISTS idx_umjb_gr_jpo_case_biblog_jbuf_fi_left_sign_code ON umjb_gr_jpo_case_biblog(jbuf_fi_left_sign);
CREATE INDEX IF NOT EXISTS idx_umjb_gr_jpo_case_biblog_jbuf_fi_section_code ON umjb_gr_jpo_case_biblog(jbuf_fi_section);
CREATE INDEX IF NOT EXISTS idx_umjb_gr_jpo_case_biblog_jbuf_fi_class_code ON umjb_gr_jpo_case_biblog(jbuf_fi_class);
CREATE INDEX IF NOT EXISTS idx_umjb_gr_jpo_case_biblog_jbuf_fi_subclass_code ON umjb_gr_jpo_case_biblog(jbuf_fi_subclass);
CREATE INDEX IF NOT EXISTS idx_umjb_gr_jpo_case_biblog_jbuf_fi_main_grp_code ON umjb_gr_jpo_case_biblog(jbuf_fi_main_grp);
CREATE INDEX IF NOT EXISTS idx_umjb_gr_jpo_case_biblog_jbuf_fi_separator_code ON umjb_gr_jpo_case_biblog(jbuf_fi_separator);
CREATE INDEX IF NOT EXISTS idx_umjb_gr_jpo_case_biblog_jbuf_fi_sub_grp_code ON umjb_gr_jpo_case_biblog(jbuf_fi_sub_grp);
CREATE INDEX IF NOT EXISTS idx_umjb_gr_jpo_case_biblog_jbuf_fi_subdiv_sign_code ON umjb_gr_jpo_case_biblog(jbuf_fi_subdiv_sign);
CREATE INDEX IF NOT EXISTS idx_umjb_gr_jpo_case_biblog_jbuf_fi_separate_vol_class_code ON umjb_gr_jpo_case_biblog(jbuf_fi_separate_vol_class);
CREATE INDEX IF NOT EXISTS idx_umjb_gr_jpo_case_biblog_jbuf_fi_facet_code ON umjb_gr_jpo_case_biblog(jbuf_fi_facet);
CREATE INDEX IF NOT EXISTS idx_umjb_gr_jpo_case_biblog_jbuf_fi_right_sign_code ON umjb_gr_jpo_case_biblog(jbuf_fi_right_sign);
CREATE INDEX IF NOT EXISTS idx_umjb_gr_jpo_case_biblog_jbuf_fi_jpo_refer_num_code ON umjb_gr_jpo_case_biblog(jbuf_fi_jpo_refer_num);
CREATE INDEX IF NOT EXISTS idx_umjb_gr_jpo_case_biblog_jbuf_fi_amend_mk_code ON umjb_gr_jpo_case_biblog(jbuf_fi_amend_mk);
CREATE INDEX IF NOT EXISTS idx_umjb_gr_jpo_case_biblog_jbuf_fi_prlmnry_code ON umjb_gr_jpo_case_biblog(jbuf_fi_prlmnry);
CREATE INDEX IF NOT EXISTS idx_umjb_gr_jpo_case_biblog_jbrf_fi_class_typ_code ON umjb_gr_jpo_case_biblog(jbrf_fi_class_typ);
CREATE INDEX IF NOT EXISTS idx_umjb_gr_jpo_case_biblog_jbrf_fi_subdiv_sign_code ON umjb_gr_jpo_case_biblog(jbrf_fi_subdiv_sign);
CREATE INDEX IF NOT EXISTS idx_umjb_gr_jpo_case_biblog_jbrf_fi_separate_vol_class_code ON umjb_gr_jpo_case_biblog(jbrf_fi_separate_vol_class);
CREATE INDEX IF NOT EXISTS idx_umjb_gr_jpo_case_biblog_jbrf_fi_facet_code ON umjb_gr_jpo_case_biblog(jbrf_fi_facet);
CREATE INDEX IF NOT EXISTS idx_umjb_gr_jpo_case_biblog_jbrf_fi_jpo_refer_num_code ON umjb_gr_jpo_case_biblog(jbrf_fi_jpo_refer_num);
CREATE INDEX IF NOT EXISTS idx_umjb_gr_jpo_case_biblog_jbrf_fi_amend_mk_code ON umjb_gr_jpo_case_biblog(jbrf_fi_amend_mk);

-- 実用旧出願事件ファイル (出願マスタ（特実）)
CREATE TABLE IF NOT EXISTS umoa_g_old_app_case (
    law_cd TEXT,
    app_num TEXT,
    oa_delete_flg TEXT,
    oa_update_dttm TEXT,
    oaep_delete_flg TEXT,
    oaep_exam_pub_num TEXT,
    oaep_exam_pub_dt TEXT
);

CREATE INDEX IF NOT EXISTS idx_umoa_g_old_app_case_law_cd ON umoa_g_old_app_case(law_cd);
CREATE INDEX IF NOT EXISTS idx_umoa_g_old_app_case_app_num ON umoa_g_old_app_case(app_num);
CREATE INDEX IF NOT EXISTS idx_umoa_g_old_app_case_law_cd_code ON umoa_g_old_app_case(law_cd);
CREATE INDEX IF NOT EXISTS idx_umoa_g_old_app_case_app_num_code ON umoa_g_old_app_case(app_num);
CREATE INDEX IF NOT EXISTS idx_umoa_g_old_app_case_oa_delete_flg_code ON umoa_g_old_app_case(oa_delete_flg);
CREATE INDEX IF NOT EXISTS idx_umoa_g_old_app_case_oaep_delete_flg_code ON umoa_g_old_app_case(oaep_delete_flg);
CREATE INDEX IF NOT EXISTS idx_umoa_g_old_app_case_oaep_exam_pub_num_code ON umoa_g_old_app_case(oaep_exam_pub_num);

-- 実用旧事件書誌ファイル (出願マスタ（特実）)
CREATE TABLE IF NOT EXISTS umob_g_old_case_biblog (
    law_cd TEXT,
    app_num TEXT,
    ob_delete_flg TEXT,
    ob_update_dttm TEXT,
    obpr_delete_flg TEXT,
    obpr_pllt_ctrl_relate_tech_mk TEXT,
    obei_delete_flg TEXT,
    obpd_delete_flg TEXT,
    obnp_delete_flg TEXT
);

CREATE INDEX IF NOT EXISTS idx_umob_g_old_case_biblog_law_cd ON umob_g_old_case_biblog(law_cd);
CREATE INDEX IF NOT EXISTS idx_umob_g_old_case_biblog_app_num ON umob_g_old_case_biblog(app_num);
CREATE INDEX IF NOT EXISTS idx_umob_g_old_case_biblog_law_cd_code ON umob_g_old_case_biblog(law_cd);
CREATE INDEX IF NOT EXISTS idx_umob_g_old_case_biblog_app_num_code ON umob_g_old_case_biblog(app_num);
CREATE INDEX IF NOT EXISTS idx_umob_g_old_case_biblog_ob_delete_flg_code ON umob_g_old_case_biblog(ob_delete_flg);
CREATE INDEX IF NOT EXISTS idx_umob_g_old_case_biblog_obpr_delete_flg_code ON umob_g_old_case_biblog(obpr_delete_flg);
CREATE INDEX IF NOT EXISTS idx_umob_g_old_case_biblog_obpr_pllt_ctrl_relate_tech_mk_code ON umob_g_old_case_biblog(obpr_pllt_ctrl_relate_tech_mk);
CREATE INDEX IF NOT EXISTS idx_umob_g_old_case_biblog_obei_delete_flg_code ON umob_g_old_case_biblog(obei_delete_flg);
CREATE INDEX IF NOT EXISTS idx_umob_g_old_case_biblog_obpd_delete_flg_code ON umob_g_old_case_biblog(obpd_delete_flg);
CREATE INDEX IF NOT EXISTS idx_umob_g_old_case_biblog_obnp_delete_flg_code ON umob_g_old_case_biblog(obnp_delete_flg);

-- 実用旧事件書誌繰返データファイル (出願マスタ（特実）)
CREATE TABLE IF NOT EXISTS umob_gr_old_case_biblog (
    law_cd TEXT,
    app_num TEXT,
    article_id TEXT,
    repeat_num INTEGER,
    obei_examiner_typ TEXT,
    obei_examiner_id TEXT,
    obei_name TEXT,
    obpd_patent_doc_title TEXT,
    obnp_non_patent_doc_title TEXT
);

CREATE INDEX IF NOT EXISTS idx_umob_gr_old_case_biblog_law_cd ON umob_gr_old_case_biblog(law_cd);
CREATE INDEX IF NOT EXISTS idx_umob_gr_old_case_biblog_app_num ON umob_gr_old_case_biblog(app_num);
CREATE INDEX IF NOT EXISTS idx_umob_gr_old_case_biblog_article_id ON umob_gr_old_case_biblog(article_id);
CREATE INDEX IF NOT EXISTS idx_umob_gr_old_case_biblog_repeat_num ON umob_gr_old_case_biblog(repeat_num);
CREATE INDEX IF NOT EXISTS idx_umob_gr_old_case_biblog_law_cd_code ON umob_gr_old_case_biblog(law_cd);
CREATE INDEX IF NOT EXISTS idx_umob_gr_old_case_biblog_app_num_code ON umob_gr_old_case_biblog(app_num);
CREATE INDEX IF NOT EXISTS idx_umob_gr_old_case_biblog_article_id_code ON umob_gr_old_case_biblog(article_id);
CREATE INDEX IF NOT EXISTS idx_umob_gr_old_case_biblog_obei_examiner_typ_code ON umob_gr_old_case_biblog(obei_examiner_typ);
CREATE INDEX IF NOT EXISTS idx_umob_gr_old_case_biblog_obei_examiner_id_code ON umob_gr_old_case_biblog(obei_examiner_id);

-- 実用異議情報ファイル (出願マスタ（特実）)
CREATE TABLE IF NOT EXISTS umoi_g_opposition_info (
    law_cd TEXT,
    app_num TEXT,
    opp_num TEXT,
    oi_delete_flg TEXT,
    oi_update_dttm TEXT,
    oici_delete_flg TEXT,
    oici_opp_dt TEXT,
    oiop_delete_flg TEXT,
    oiop_opp_decision_content TEXT,
    oioa_delete_flg TEXT,
    oion_delete_flg TEXT
);

CREATE INDEX IF NOT EXISTS idx_umoi_g_opposition_info_law_cd ON umoi_g_opposition_info(law_cd);
CREATE INDEX IF NOT EXISTS idx_umoi_g_opposition_info_app_num ON umoi_g_opposition_info(app_num);
CREATE INDEX IF NOT EXISTS idx_umoi_g_opposition_info_opp_num ON umoi_g_opposition_info(opp_num);
CREATE INDEX IF NOT EXISTS idx_umoi_g_opposition_info_law_cd_code ON umoi_g_opposition_info(law_cd);
CREATE INDEX IF NOT EXISTS idx_umoi_g_opposition_info_app_num_code ON umoi_g_opposition_info(app_num);
CREATE INDEX IF NOT EXISTS idx_umoi_g_opposition_info_opp_num_code ON umoi_g_opposition_info(opp_num);
CREATE INDEX IF NOT EXISTS idx_umoi_g_opposition_info_oi_delete_flg_code ON umoi_g_opposition_info(oi_delete_flg);
CREATE INDEX IF NOT EXISTS idx_umoi_g_opposition_info_oici_delete_flg_code ON umoi_g_opposition_info(oici_delete_flg);
CREATE INDEX IF NOT EXISTS idx_umoi_g_opposition_info_oiop_delete_flg_code ON umoi_g_opposition_info(oiop_delete_flg);
CREATE INDEX IF NOT EXISTS idx_umoi_g_opposition_info_oiop_opp_decision_content_code ON umoi_g_opposition_info(oiop_opp_decision_content);
CREATE INDEX IF NOT EXISTS idx_umoi_g_opposition_info_oioa_delete_flg_code ON umoi_g_opposition_info(oioa_delete_flg);
CREATE INDEX IF NOT EXISTS idx_umoi_g_opposition_info_oion_delete_flg_code ON umoi_g_opposition_info(oion_delete_flg);

-- 実用異議情報繰返データファイル (出願マスタ（特実）)
CREATE TABLE IF NOT EXISTS umoi_gr_opposition_info (
    law_cd TEXT,
    app_num TEXT,
    opp_num TEXT,
    article_id TEXT,
    repeat_num INTEGER,
    oioa_oppn_atty_class TEXT,
    oioa_oppn_atty_id TEXT,
    oioa_change_num TEXT,
    oioa_req_typ TEXT,
    oioa_pref_cd TEXT,
    oioa_above_oppn_cnt TEXT,
    oioa_opp_atty_other_cnt TEXT,
    oioa_opp_atty_typ_cd TEXT,
    oioa_opp_atty_qualify_cd TEXT,
    oioa_crrspnd_num TEXT,
    oion_crrspnd_num TEXT,
    oion_clmt_atty_addr TEXT,
    oion_clmt_atty_name TEXT,
    oion_representative_name TEXT,
    oion_office_addr TEXT,
    oion_wrk_place_addr TEXT
);

CREATE INDEX IF NOT EXISTS idx_umoi_gr_opposition_info_law_cd ON umoi_gr_opposition_info(law_cd);
CREATE INDEX IF NOT EXISTS idx_umoi_gr_opposition_info_app_num ON umoi_gr_opposition_info(app_num);
CREATE INDEX IF NOT EXISTS idx_umoi_gr_opposition_info_opp_num ON umoi_gr_opposition_info(opp_num);
CREATE INDEX IF NOT EXISTS idx_umoi_gr_opposition_info_article_id ON umoi_gr_opposition_info(article_id);
CREATE INDEX IF NOT EXISTS idx_umoi_gr_opposition_info_repeat_num ON umoi_gr_opposition_info(repeat_num);
CREATE INDEX IF NOT EXISTS idx_umoi_gr_opposition_info_law_cd_code ON umoi_gr_opposition_info(law_cd);
CREATE INDEX IF NOT EXISTS idx_umoi_gr_opposition_info_app_num_code ON umoi_gr_opposition_info(app_num);
CREATE INDEX IF NOT EXISTS idx_umoi_gr_opposition_info_opp_num_code ON umoi_gr_opposition_info(opp_num);
CREATE INDEX IF NOT EXISTS idx_umoi_gr_opposition_info_article_id_code ON umoi_gr_opposition_info(article_id);
CREATE INDEX IF NOT EXISTS idx_umoi_gr_opposition_info_oioa_oppn_atty_class_code ON umoi_gr_opposition_info(oioa_oppn_atty_class);
CREATE INDEX IF NOT EXISTS idx_umoi_gr_opposition_info_oioa_oppn_atty_id_code ON umoi_gr_opposition_info(oioa_oppn_atty_id);
CREATE INDEX IF NOT EXISTS idx_umoi_gr_opposition_info_oioa_req_typ_code ON umoi_gr_opposition_info(oioa_req_typ);
CREATE INDEX IF NOT EXISTS idx_umoi_gr_opposition_info_oioa_pref_cd_code ON umoi_gr_opposition_info(oioa_pref_cd);
CREATE INDEX IF NOT EXISTS idx_umoi_gr_opposition_info_oioa_opp_atty_typ_cd_code ON umoi_gr_opposition_info(oioa_opp_atty_typ_cd);
CREATE INDEX IF NOT EXISTS idx_umoi_gr_opposition_info_oioa_opp_atty_qualify_cd_code ON umoi_gr_opposition_info(oioa_opp_atty_qualify_cd);
CREATE INDEX IF NOT EXISTS idx_umoi_gr_opposition_info_oioa_crrspnd_num_code ON umoi_gr_opposition_info(oioa_crrspnd_num);
CREATE INDEX IF NOT EXISTS idx_umoi_gr_opposition_info_oion_crrspnd_num_code ON umoi_gr_opposition_info(oion_crrspnd_num);

-- 実用旧事件ステータスファイル (出願マスタ（特実）)
CREATE TABLE IF NOT EXISTS umos_g_old_case_stat (
    law_cd TEXT,
    app_num TEXT,
    os_delete_flg TEXT,
    os_update_dttm TEXT,
    osos_delete_flg TEXT,
    osos_opp_cnt INTEGER,
    osos_opp_valid_cnt INTEGER
);

CREATE INDEX IF NOT EXISTS idx_umos_g_old_case_stat_law_cd ON umos_g_old_case_stat(law_cd);
CREATE INDEX IF NOT EXISTS idx_umos_g_old_case_stat_app_num ON umos_g_old_case_stat(app_num);
CREATE INDEX IF NOT EXISTS idx_umos_g_old_case_stat_law_cd_code ON umos_g_old_case_stat(law_cd);
CREATE INDEX IF NOT EXISTS idx_umos_g_old_case_stat_app_num_code ON umos_g_old_case_stat(app_num);
CREATE INDEX IF NOT EXISTS idx_umos_g_old_case_stat_os_delete_flg_code ON umos_g_old_case_stat(os_delete_flg);
CREATE INDEX IF NOT EXISTS idx_umos_g_old_case_stat_osos_delete_flg_code ON umos_g_old_case_stat(osos_delete_flg);

-- 申請人登録情報_被統合申請人情報管理ファイル (申請人登録マスタ)
CREATE TABLE IF NOT EXISTS under_integ_appl_info_mgt (
    appl_cd TEXT,
    repeat_num INTEGER,
    under_integ_appl_cd TEXT
);

CREATE INDEX IF NOT EXISTS idx_under_integ_appl_info_mgt_appl_cd ON under_integ_appl_info_mgt(appl_cd);
CREATE INDEX IF NOT EXISTS idx_under_integ_appl_info_mgt_repeat_num ON under_integ_appl_info_mgt(repeat_num);

-- 前置登録ファイル (共有データベース（審判）)
CREATE TABLE IF NOT EXISTS znt_turk (
    skbt_flg TEXT,
    tyuni_syri_bngu TEXT,
    znt_turk_dt TEXT,
    kusn_ntz_bat TEXT
);

CREATE INDEX IF NOT EXISTS idx_znt_turk_tyuni_syri_bngu ON znt_turk(tyuni_syri_bngu);
CREATE INDEX IF NOT EXISTS idx_znt_turk_skbt_flg_code ON znt_turk(skbt_flg);
CREATE INDEX IF NOT EXISTS idx_znt_turk_tyuni_syri_bngu_code ON znt_turk(tyuni_syri_bngu);

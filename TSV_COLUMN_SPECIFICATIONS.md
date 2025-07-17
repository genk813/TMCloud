# TSVファイルカラム仕様書

このドキュメントは、日本特許庁から提供されるTSVファイルのカラム定義と、TMCloudデータベースとの対応関係を記載します。
仕様は、CSVファイル仕様書（version 1.13）に基づいています。

## 1. jiken_c_t.tsv (事件フォルダ_商標ファイル)

**CSV仕様書**: （別添3.3）ファイル仕様書_1.13版_042_事件フォルダ_商標ファイル.csv

### TSVファイルカラム仕様

| カラム名（物理名） | カラム名（論理名） | データ型 | 最大桁数 | 主キー | コードINDEX | 備考 |
|-------------------|-------------------|----------|----------|--------|------------|------|
| masterkosin_nitiji | マスタ更新日時 | 半角文字列型 | 14 | - | - | - |
| yonpo_code | 四法コード | 半角文字列型 | 1 | ○ | 02210 | - |
| shutugan_no | 出願番号 | 半角文字列型 | 10 | ○ | 02020 | - |
| shutugan_bi | 出願日 | 半角文字列型 | 8 | - | - | - |
| shutugan_shubetu1 | 出願種別１ | 半角文字列型 | 2 | - | 02010 | - |
| shutugan_shubetu2 | 出願種別２ | 半角文字列型 | 2 | - | 02010 | - |
| shutugan_shubetu3 | 出願種別３ | 半角文字列型 | 2 | - | 02010 | - |
| shutugan_shubetu4 | 出願種別４ | 半角文字列型 | 2 | - | 02010 | - |
| shutugan_shubetu5 | 出願種別５ | 半角文字列型 | 2 | - | 02010 | - |
| seiri_no | 整理番号 | 半角文字列型 | 10 | - | 02330 | - |
| saishushobun_shubetu | 最終処分種別 | 半角文字列型 | 3 | - | 02200 | - |
| saishushobun_bi | 最終処分日 | 半角文字列型 | 8 | - | - | - |
| raz_toroku_no | 登録記事登録番号 | 半角文字列型 | 7 | - | 02450 | - |
| raz_bunkatu_no | 登録記事分割番号 | 半角文字列型 | 31 | - | 02510 | - |
| bogo_no | 防護番号 | 半角文字列型 | 3 | - | 02530 | - |
| toroku_bi | 登録日 | 半角文字列型 | 8 | - | - | - |
| raz_sotugo_su | 登録記事総通号数 | 半角文字列型 | 6 | - | - | - |
| raz_nenkantugo_su | 登録記事年間通号数 | 半角文字列型 | 6 | - | - | - |
| raz_kohohakko_bi | 登録記事公報発行日 | 半角文字列型 | 8 | - | - | - |
| tantokan_code | 担当官コード | 半角文字列型 | 4 | - | - | - |
| pcz_kokaikohohakko_bi | 公開公報記事公開公報発行日 | 半角文字列型 | 8 | - | - | - |
| kubun_su | 区分数 | 半角文字列型 | 3 | - | - | - |
| torokusateijikubun_su | 登録査定時区分数 | 半角文字列型 | 3 | - | - | - |
| hyojunmoji_umu | 標準文字有無 | 半角文字列型 | 1 | - | 02480 | - |
| rittaishohyo_umu | 特殊商標識別 | 半角文字列型 | 1 | - | 02460 | - |
| hyoshosikisai_umu | 標章色彩有無 | 半角文字列型 | 1 | - | 02490 | - |
| shohyoho3jo2ko_flag | 商標法３条２項フラグ | 半角文字列型 | 1 | - | 02280 | - |
| shohyoho5jo4ko_flag | 色彩の但し書フラグ | 半角文字列型 | 1 | - | 02300 | - |
| genshutugan_shubetu | 原出願種別 | 半角文字列型 | 2 | - | 02130 | - |
| genshutuganyonpo_code | 原出願四法コード | 半角文字列型 | 1 | - | 02210 | - |
| genshutugan_no | 原出願番号 | 半角文字列型 | 10 | - | 02020 | - |
| sokyu_bi | 遡及日 | 半角文字列型 | 8 | - | - | - |
| obz_shutugan_no | 防護原登録記事出願番号 | 半角文字列型 | 10 | - | 02020 | - |
| obz_toroku_no | 防護原登録記事登録番号 | 半角文字列型 | 7 | - | 02450 | - |
| obz_bunkatu_no | 防護原登録記事分割番号 | 半角文字列型 | 31 | - | 02510 | - |
| kosintoroku_no | 更新登録番号 | 半角文字列型 | 7 | - | 02450 | - |
| pez_bunkatu_no | 更新登録記事分割番号 | 半角文字列型 | 31 | - | 02510 | - |
| pez_bogo_no | 更新登録記事防護番号 | 半角文字列型 | 3 | - | 02530 | - |
| kakikaetoroku_no | 書換登録番号 | 半角文字列型 | 7 | - | 02450 | - |
| ktz_bunkatu_no | 書換登録記事分割番号 | 半角文字列型 | 31 | - | 02510 | - |
| ktz_bogo_no | 書換登録記事防護番号 | 半角文字列型 | 3 | - | 02530 | - |
| krz_kojoryozokuihan_flag | 公序良俗違反フラグ | 半角文字列型 | 1 | - | 02150 | - |
| sokisinsa_mark | 早期審査マーク | 半角文字列型 | 1 | - | 02370 | - |
| tekiyohoki_kubun | 適用法規区分 | 半角文字列型 | 1 | - | 02440 | - |
| sinsa_shubetu | 審査種別 | 半角文字列型 | 2 | - | 02310 | - |
| sosho_code | 訴訟コード | 半角文字列型 | 1 | - | 02360 | - |
| satei_shubetu | 査定種別 | 半角文字列型 | 1 | - | 02190 | - |
| igiken_su | 異議件数 | 半角文字列型 | 2 | - | - | - |
| igiyuko_su | 異議有効数 | 半角文字列型 | 2 | - | - | - |

### データベーステーブル構造

```sql
CREATE TABLE IF NOT EXISTS jiken_c_t (
    normalized_app_num TEXT PRIMARY KEY,  -- shutugan_noからハイフンを除去した値
    shutugan_bi TEXT,                    -- 出願日
    reg_reg_ymd TEXT                     -- 登録日（toroku_biに対応）
);
```

### TSVカラムとデータベースカラムの対応

| TSVカラム | データベースカラム | 変換処理 |
|-----------|-------------------|----------|
| shutugan_no | normalized_app_num | ハイフン除去（例：2021-123456 → 2021123456） |
| shutugan_bi | shutugan_bi | そのまま |
| toroku_bi | reg_reg_ymd | そのまま |

---

## 2. jiken_c_t_shohin_joho.tsv (事件フォルダ_商標_商品情報ファイル)

**CSV仕様書**: （別添3.3）ファイル仕様書_1.13版_048_事件フォルダ_商標_商品情報ファイル.csv

### TSVファイルカラム仕様

| カラム名（物理名） | カラム名（論理名） | データ型 | 最大桁数 | 主キー | コードINDEX | 備考 |
|-------------------|-------------------|----------|----------|--------|------------|------|
| yonpo_code | 四法コード | 半角文字列型 | 1 | ○ | 02210 | - |
| shutugan_no | 出願番号 | 半角文字列型 | 10 | ○ | 02020 | - |
| rui | 類 | 半角文字列型 | 2 | - | 02290 | - |
| lengthchoka_flag | レングス超過フラグ | 半角文字列型 | 1 | - | 02430 | - |
| shohinekimumeisho | 商品役務名称 | 全半角文字列型 | 5500 | - | - | - |
| abz_junjo_no | 商品情報記事順序番号 | 数値型 | 4 | ○ | - | - |

### データベーステーブル構造（現在）

```sql
CREATE TABLE IF NOT EXISTS jiken_c_t_shohin_joho (
    normalized_app_num TEXT,
    designated_goods TEXT,
    FOREIGN KEY (normalized_app_num) REFERENCES jiken_c_t(normalized_app_num)
);
```

### TSVカラムとデータベースカラムの対応

| TSVカラム | データベースカラム | 変換処理 |
|-----------|-------------------|----------|
| shutugan_no | normalized_app_num | ハイフン除去 |
| shohinekimumeisho | designated_goods | そのまま |
| **rui** | **（対応カラムなし）** | **重要：欠損している** |
| lengthchoka_flag | （対応カラムなし） | インポートされない |
| abz_junjo_no | （対応カラムなし） | インポートされない |

---

## 3. standard_char_t_art.tsv (標準文字商標記事ファイル)

**CSV仕様書**: （別添3.3）ファイル仕様書_1.13版_157_標準文字商標記事ファイル.csv

### TSVファイルカラム仕様

| カラム名（物理名） | カラム名（論理名） | データ型 | 最大桁数 | 主キー | コードINDEX | 備考 |
|-------------------|-------------------|----------|----------|--------|------------|------|
| add_del_id | 追加削除識別 | 半角文字列型 | 1 | - | 12280 | - |
| app_num | 出願番号 | 半角文字列型 | 10 | ○ | 12160 | - |
| split_num | 分割番号 | 半角文字列型 | 31 | ○ | 12240 | - |
| sub_data_num | サブデータ番号 | 半角文字列型 | 9 | ○ | - | 初期値（NULL）固定 |
| standard_char_t | 標準文字商標 | 全半角文字列型 | 127 | - | - | - |

### データベーステーブル構造

```sql
CREATE TABLE IF NOT EXISTS standard_char_t_art (
    normalized_app_num TEXT,
    standard_char_t TEXT,
    FOREIGN KEY (normalized_app_num) REFERENCES jiken_c_t(normalized_app_num)
);
```

### TSVカラムとデータベースカラムの対応

| TSVカラム | データベースカラム | 変換処理 |
|-----------|-------------------|----------|
| app_num | normalized_app_num | ハイフン除去 |
| standard_char_t | standard_char_t | そのまま |

---

## 4. goods_class_art.tsv (商品区分記事ファイル)

**CSV仕様書**: （別添3.3）ファイル仕様書_1.13版_117_商品区分記事ファイル.csv

### TSVファイルカラム仕様

| カラム名（物理名） | カラム名（論理名） | データ型 | 最大桁数 | 主キー | コードINDEX | 備考 |
|-------------------|-------------------|----------|----------|--------|------------|------|
| processing_type | 処理種別 | 半角文字列型 | 1 | - | 05330 | - |
| law_cd | 四法コード | 半角文字列型 | 1 | ○ | 05080 | - |
| reg_num | 登録番号 | 半角文字列型 | 7 | ○ | 05220 | - |
| split_num | 分割番号 | 半角文字列型 | 31 | ○ | 05270 | - |
| app_num | 出願番号 | 半角文字列型 | 10 | ○ | 05110 | - |
| goods_cls_art_upd_ymd | 商品区分記事部作成更新年月日 | 半角文字列型 | 8 | - | - | - |
| mu_num | ＭＵ番号 | 半角文字列型 | 3 | ○ | 05350 | - |
| desig_goods_or_desig_wrk_class | 指定商品又は指定役務の区分 | 半角文字列型 | 2 | - | 05130 | - |

### データベーステーブル構造

```sql
CREATE TABLE IF NOT EXISTS goods_class_art (
    processing_type TEXT,
    law_cd TEXT,
    reg_num TEXT,
    split_num TEXT,
    normalized_app_num TEXT,
    goods_cls_art_upd_ymd TEXT,
    mu_num TEXT,
    goods_classes TEXT,  -- desig_goods_or_desig_wrk_classに対応
    FOREIGN KEY (normalized_app_num) REFERENCES jiken_c_t(normalized_app_num)
);
```

### TSVカラムとデータベースカラムの対応

| TSVカラム | データベースカラム | 変換処理 |
|-----------|-------------------|----------|
| processing_type | processing_type | そのまま |
| law_cd | law_cd | そのまま |
| reg_num | reg_num | そのまま |
| split_num | split_num | 0000...の場合はNULL |
| app_num | normalized_app_num | ハイフン除去、0000000000の場合はNULL |
| goods_cls_art_upd_ymd | goods_cls_art_upd_ymd | そのまま |
| mu_num | mu_num | そのまま |
| desig_goods_or_desig_wrk_class | goods_classes | そのまま |

---

## 5. t_knd_info_art_table.tsv (商標類情報記事ファイル)

**CSV仕様書**: （別添3.3）ファイル仕様書_1.13版_160_商標類情報記事ファイル.csv

### TSVファイルカラム仕様

| カラム名（物理名） | カラム名（論理名） | データ型 | 最大桁数 | 主キー | コードINDEX | 備考 |
|-------------------|-------------------|----------|----------|--------|------------|------|
| add_del_id | 追加削除識別 | 半角文字列型 | 1 | - | 12280 | - |
| app_num | 出願番号 | 半角文字列型 | 10 | ○ | 12160 | - |
| split_num | 分割番号 | 半角文字列型 | 31 | ○ | 12240 | - |
| sub_data_num | サブデータ番号 | 半角文字列型 | 9 | ○ | - | 初期値（NULL）固定 |
| knd | 類 | 半角文字列型 | 2 | ○ | 12260 | - |
| smlr_dsgn_group_cd | 類似群コード | 全半角文字列型 | 2500 | - | 12270 | - |

### データベーステーブル構造

```sql
CREATE TABLE IF NOT EXISTS t_knd_info_art_table (
    normalized_app_num TEXT,
    smlr_dsgn_group_cd TEXT,
    FOREIGN KEY (normalized_app_num) REFERENCES jiken_c_t(normalized_app_num)
);
```

### TSVカラムとデータベースカラムの対応

| TSVカラム | データベースカラム | 変換処理 |
|-----------|-------------------|----------|
| app_num | normalized_app_num | ハイフン除去 |
| smlr_dsgn_group_cd | smlr_dsgn_group_cd | そのまま |
| knd | （対応カラムなし） | インポートされない |

---

## 6. right_person_art_t.tsv (権利者記事ファイル(商標))

**CSV仕様書**: （別添3.3）ファイル仕様書_1.13版_124_権利者記事ファイル(商標).csv

### TSVファイルカラム仕様

| カラム名（物理名） | カラム名（論理名） | データ型 | 最大桁数 | 主キー | コードINDEX | 備考 |
|-------------------|-------------------|----------|----------|--------|------------|------|
| processing_type | 処理種別 | 半角文字列型 | 1 | - | 05330 | - |
| law_cd | 四法コード | 半角文字列型 | 1 | ○ | 05080 | - |
| reg_num | 登録番号 | 半角文字列型 | 7 | ○ | 05220 | - |
| split_num | 分割番号 | 半角文字列型 | 31 | ○ | 05270 | - |
| app_num | 出願番号 | 半角文字列型 | 10 | ○ | 05110 | - |
| rec_num | レコード番号 | 半角文字列型 | 2 | ○ | - | - |
| pe_num | ＰＥ番号 | 半角文字列型 | 3 | ○ | 05360 | - |
| right_psn_art_upd_ymd | 権利者記事部作成更新年月日 | 半角文字列型 | 8 | - | - | - |
| right_person_appl_id | 権利者申請人ＩＤ | 半角文字列型 | 9 | - | 05150 | - |
| right_person_addr_len | 権利者住所レングス | 半角文字列型 | 10 | - | - | - |
| right_person_addr | 権利者住所 | 全半角文字列型 | 1000 | - | - | - |
| right_person_name_len | 権利者氏名レングス | 半角文字列型 | 10 | - | - | - |
| right_person_name | 権利者氏名 | 全半角文字列型 | 1000 | - | - | - |

### データベーステーブル構造

```sql
CREATE TABLE IF NOT EXISTS right_person_art_t (
    processing_type TEXT,
    law_cd TEXT,
    reg_num TEXT,
    split_num TEXT,
    normalized_app_num TEXT,
    rec_num TEXT,
    pe_num TEXT,
    right_psn_art_upd_ymd TEXT,
    right_person_appl_id TEXT,
    right_person_addr_len TEXT,
    right_person_addr TEXT,
    right_person_name_len TEXT,
    right_person_name TEXT,
    FOREIGN KEY (normalized_app_num) REFERENCES jiken_c_t(normalized_app_num)
);
```

### TSVカラムとデータベースカラムの対応

| TSVカラム | データベースカラム | 変換処理 |
|-----------|-------------------|----------|
| processing_type | processing_type | そのまま |
| law_cd | law_cd | そのまま |
| reg_num | reg_num | そのまま |
| split_num | split_num | 0000...の場合はNULL |
| app_num | normalized_app_num | ハイフン除去、0000000000の場合はNULL |
| rec_num | rec_num | そのまま |
| pe_num | pe_num | そのまま |
| right_psn_art_upd_ymd | right_psn_art_upd_ymd | そのまま |
| right_person_appl_id | right_person_appl_id | そのまま |
| right_person_addr_len | right_person_addr_len | そのまま |
| right_person_addr | right_person_addr | そのまま |
| right_person_name_len | right_person_name_len | そのまま |
| right_person_name | right_person_name | そのまま |

---

## 7. t_dsgnt_art.tsv (表示用商標記事ファイル)

**CSV仕様書**: （別添3.3）ファイル仕様書_1.13版_156_表示用商標記事ファイル.csv

### TSVファイルカラム仕様

| カラム名（物理名） | カラム名（論理名） | データ型 | 最大桁数 | 主キー | コードINDEX | 備考 |
|-------------------|-------------------|----------|----------|--------|------------|------|
| add_del_id | 追加削除識別 | 半角文字列型 | 1 | - | 12280 | - |
| app_num | 出願番号 | 半角文字列型 | 10 | ○ | 12160 | - |
| split_num | 分割番号 | 半角文字列型 | 31 | ○ | 12240 | - |
| sub_data_num | サブデータ番号 | 半角文字列型 | 9 | ○ | - | 初期値（NULL）固定 |
| dsgnt | 表示用商標 | 全半角文字列型 | 1023 | - | - | - |

### データベーステーブル構造

```sql
CREATE TABLE IF NOT EXISTS t_dsgnt_art (
    normalized_app_num TEXT,
    dsgnt TEXT,
    FOREIGN KEY (normalized_app_num) REFERENCES jiken_c_t(normalized_app_num)
);
```

### TSVカラムとデータベースカラムの対応

| TSVカラム | データベースカラム | 変換処理 |
|-----------|-------------------|----------|
| app_num | normalized_app_num | ハイフン除去 |
| dsgnt | dsgnt | そのまま |

---

## 8. t_sample.tsv (商標見本ファイル)

**CSV仕様書**: （別添3.3）ファイル仕様書_1.13版_187_商標見本ファイル.csv

### TSVファイルカラム仕様

| カラム名（物理名） | カラム名（論理名） | データ型 | 最大桁数 | 主キー | コードINDEX | 備考 |
|-------------------|-------------------|----------|----------|--------|------------|------|
| add_del_id | 追加削除識別 | 半角文字列型 | 1 | - | 12330 | - |
| app_num | 出願番号 | 半角文字列型 | 10 | ○ | 12320 | - |
| split_num | 分割番号 | 半角文字列型 | 31 | ○ | 12340 | - |
| rec_seq_num | レコード通番 | 数値型 | 4 | ○ | - | - |
| image_data | イメージデータ | 半角文字列型 | 200 | - | - | - |

### データベーステーブル構造

```sql
CREATE TABLE IF NOT EXISTS t_sample (
    normalized_app_num TEXT,
    image_data TEXT,
    rec_seq_num INTEGER,
    FOREIGN KEY (normalized_app_num) REFERENCES jiken_c_t(normalized_app_num)
);
```

### TSVカラムとデータベースカラムの対応

| TSVカラム | データベースカラム | 変換処理 |
|-----------|-------------------|----------|
| app_num | normalized_app_num | ハイフン除去 |
| image_data | image_data | そのまま |
| rec_seq_num | rec_seq_num | そのまま（デフォルト: 1） |

---

## 9. indct_use_t_art.tsv (表示用商標記事ファイル - 称呼)

**CSV仕様書**: （別添3.3）ファイル仕様書_1.13版_156_表示用商標記事ファイル.csv

### TSVファイルカラム仕様

| カラム名（物理名） | カラム名（論理名） | データ型 | 最大桁数 | 主キー | コードINDEX | 備考 |
|-------------------|-------------------|----------|----------|--------|------------|------|
| add_del_id | 追加削除識別 | 半角文字列型 | 1 | - | 12280 | - |
| app_num | 出願番号 | 半角文字列型 | 10 | ○ | 12160 | - |
| split_num | 分割番号 | 半角文字列型 | 31 | ○ | 12240 | - |
| sub_data_num | サブデータ番号 | 半角文字列型 | 9 | ○ | - | 初期値（NULL）固定 |
| indct_use_t | 称呼（参考情報） | 全半角文字列型 | 1023 | - | - | - |

### データベーステーブル構造

```sql
CREATE TABLE IF NOT EXISTS indct_use_t_art (
    normalized_app_num TEXT,
    indct_use_t TEXT,
    FOREIGN KEY (normalized_app_num) REFERENCES jiken_c_t(normalized_app_num)
);
```

### TSVカラムとデータベースカラムの対応

| TSVカラム | データベースカラム | 変換処理 |
|-----------|-------------------|----------|
| app_num | normalized_app_num | ハイフン除去 |
| indct_use_t | indct_use_t | そのまま |

---

## 10. search_use_t_art_table.tsv (検索用商標記事ファイル)

**CSV仕様書**: （別添3.3）ファイル仕様書_1.13版_158_検索用商標記事ファイル.csv

### TSVファイルカラム仕様

| カラム名（物理名） | カラム名（論理名） | データ型 | 最大桁数 | 主キー | コードINDEX | 備考 |
|-------------------|-------------------|----------|----------|--------|------------|------|
| add_del_id | 追加削除識別 | 半角文字列型 | 1 | - | 12280 | - |
| app_num | 出願番号 | 半角文字列型 | 10 | ○ | 12160 | - |
| split_num | 分割番号 | 半角文字列型 | 31 | ○ | 12240 | - |
| sub_data_num | サブデータ番号 | 半角文字列型 | 9 | ○ | - | 初期値（NULL）固定 |
| search_use_t_seq | 検索用商標順番 | 数値型 | 2 | ○ | - | - |
| search_use_t | 検索用商標 | 全半角文字列型 | 255 | - | - | - |

### データベーステーブル構造

```sql
CREATE TABLE IF NOT EXISTS search_use_t_art_table (
    normalized_app_num TEXT,
    search_use_t_seq INTEGER,
    search_use_t TEXT,
    FOREIGN KEY (normalized_app_num) REFERENCES jiken_c_t(normalized_app_num)
);
```

### TSVカラムとデータベースカラムの対応

| TSVカラム | データベースカラム | 変換処理 |
|-----------|-------------------|----------|
| app_num | normalized_app_num | ハイフン除去 |
| search_use_t_seq | search_use_t_seq | そのまま（デフォルト: 1） |
| search_use_t | search_use_t | そのまま |

---

## 11. jiken_c_t_shutugannindairinin.tsv (事件フォルダ_商標_出願人代理人情報ファイル)

**CSV仕様書**: （別添3.3）ファイル仕様書_1.13版_047_事件フォルダ_商標_出願人代理人情報ファイル.csv

### TSVファイルカラム仕様

| カラム名（物理名） | カラム名（論理名） | データ型 | 最大桁数 | 主キー | コードINDEX | 備考 |
|-------------------|-------------------|----------|----------|--------|------------|------|
| yonpo_code | 四法コード | 半角文字列型 | 1 | ○ | 02210 | - |
| shutugan_no | 出願番号 | 半角文字列型 | 10 | ○ | 02020 | - |
| shutugannindairinin_code | 出願人代理人コード | 半角文字列型 | 9 | ○ | 02060 | - |
| shutugannindairinin_sikbt | 出願人代理人識別 | 半角文字列型 | 1 | ○ | 02070 | - |

### データベーステーブル構造

```sql
CREATE TABLE IF NOT EXISTS jiken_c_t_shutugannindairinin (
    shutugan_no TEXT,
    shutugannindairinin_code TEXT,
    shutugannindairinin_sikbt TEXT,
    FOREIGN KEY (shutugan_no) REFERENCES jiken_c_t(normalized_app_num)
);
```

### TSVカラムとデータベースカラムの対応

| TSVカラム | データベースカラム | 変換処理 |
|-----------|-------------------|----------|
| shutugan_no | shutugan_no | そのまま（正規化なし） |
| shutugannindairinin_code | shutugannindairinin_code | そのまま |
| shutugannindairinin_sikbt | shutugannindairinin_sikbt | そのまま |

---

## 12. reg_mapping.tsv (登録番号マッピングテーブル)

### データベーステーブル構造

```sql
CREATE TABLE IF NOT EXISTS reg_mapping (
    app_num TEXT,
    reg_num TEXT,
    FOREIGN KEY (app_num) REFERENCES jiken_c_t(normalized_app_num)
);
```

### TSVカラムとデータベースカラムの対応

| TSVカラム | データベースカラム | 変換処理 |
|-----------|-------------------|----------|
| app_num | app_num | そのまま |
| reg_num | reg_num | そのまま |

---

## その他のデータベーステーブル

### applicant_master (申請人マスタ)

```sql
CREATE TABLE IF NOT EXISTS applicant_master (
    appl_cd TEXT PRIMARY KEY,
    appl_name TEXT,
    appl_addr TEXT
);
```

### applicant_mapping (申請人マッピング)

```sql
CREATE TABLE IF NOT EXISTS applicant_mapping (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    applicant_code TEXT,
    applicant_name TEXT,
    applicant_addr TEXT,
    trademark_count INTEGER,
    confidence_level TEXT,
    created_date TEXT DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(applicant_code, applicant_name, applicant_addr)
);
```

---

## データベースビュー

### v_goods_classes

```sql
CREATE VIEW IF NOT EXISTS v_goods_classes AS
SELECT 
    normalized_app_num,
    GROUP_CONCAT(DISTINCT goods_classes) AS concatenated_classes
FROM goods_class_art
GROUP BY normalized_app_num;
```

### v_designated_goods

```sql
CREATE VIEW IF NOT EXISTS v_designated_goods AS
SELECT 
    normalized_app_num,
    GROUP_CONCAT(DISTINCT designated_goods) AS concatenated_goods
FROM jiken_c_t_shohin_joho
GROUP BY normalized_app_num;
```

### v_similar_group_codes

```sql
CREATE VIEW IF NOT EXISTS v_similar_group_codes AS
SELECT 
    normalized_app_num,
    GROUP_CONCAT(DISTINCT smlr_dsgn_group_cd) AS concatenated_codes
FROM t_knd_info_art_table
GROUP BY normalized_app_num;
```

---

作成日: 2025年1月17日
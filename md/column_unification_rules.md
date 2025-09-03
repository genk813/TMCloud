# カラム名統一ルール

## 基本方針
1. **特許庁のTSVファイルのカラム名（物理名）を原則使用**
2. **同じ意味の項目は統一された名前を使用**
3. **スネークケース（snake_case）で統一**

## 統一が必要な主要カラム

### 1. 識別子・番号系

| 統一後のカラム名 | 元のバリエーション | 説明 |
|-----------------|-------------------|------|
| `app_num` | app_num, shutugan_no, sytgn_bngu | 出願番号 |
| `law_cd` | law_cd, yonpo_code, law_code | 四法コード |
| `reg_num` | reg_num, toroku_no, turk_bngu | 登録番号 |
| `split_num` | split_num, bunkatu_no, bnkt_bngu | 分割番号 |
| `intl_reg_num` | intl_reg_num, kksi_turk_bngu | 国際登録番号 |
| `appeal_num` | appeal_num, appl_num, snpn_bngu | 審判番号 |
| `defensive_num` | defensive_num, bogo_no, bug_bngu, sec_num | 防護番号 |
| `priority_num` | priority_num, yusenkenshutugan_no, pri_app_num | 優先権出願番号 |
| `similar_num` | similar_num, ruiji_no, riz_bngu, smlr_dsgn_num | 類似番号 |

### 2. 日付系

| 統一後のカラム名 | 元のバリエーション | 説明 |
|-----------------|-------------------|------|
| `app_dt` | app_dt, shutugan_bi | 出願日 |
| `reg_dt` | reg_dt, toroku_bi | 登録日 |
| `pub_dt` | pub_dt, koho_bi | 公開日/公報日 |
| `final_dspst_dt` | final_dspst_dt, saishushobun_bi | 最終処分日 |
| `draft_dt` | draft_dt, kian_bi, kan_dt | 起案日 |
| `dsptch_dt` | dsptch_dt, hasso_bi | 発送日 |
| `rcpt_dt` | rcpt_dt, uketuke_bi, uktk_dt | 受付日 |

### 3. コード系

| 統一後のカラム名 | 元のバリエーション | 説明 |
|-----------------|-------------------|------|
| `appl_cd` | appl_cd, sinseinin_code, snsinn_cd | 申請人コード |
| `cntry_cd` | cntry_cd, kuni_code | 国コード |
| `intrmd_cd` | intrmd_cd, tyukn_cd, chukanshorui_code | 中間コード |
| `atty_typ` | atty_typ, dairinin_shubetu, dirnn_sybt | 代理人種別 |

### 4. フラグ・識別系

| 統一後のカラム名 | 元のバリエーション | 説明 |
|-----------------|-------------------|------|
| `delete_flg` | delete_flg, sakujo_flag | 削除フラグ |
| `valid_flg` | valid_flg, yuku_flg | 有効フラグ |
| `inspct_prhbt_flg` | inspct_prhbt_flg, eturankinsi_flag, etrn_kns_flg | 閲覧禁止フラグ |
| `special_t_id` | special_t_id, rittaishohyo_umu | 特殊商標識別 |

### 5. 名称・テキスト系

| 統一後のカラム名 | 元のバリエーション | 説明 |
|-----------------|-------------------|------|
| `addr` | addr, jusho, jusy | 住所 |
| `name` | name, simei, smi | 氏名 |
| `mark` | mark, hyosho | 商標/標章 |
| `goods_name` | goods_name, shohin_mei | 商品名 |

### 6. その他の重要カラム

| 統一後のカラム名 | 元のバリエーション | 説明 |
|-----------------|-------------------|------|
| `update_dttm` | update_dttm, kusn_ntz_bat | 更新日時 |
| `doc_num` | doc_num, shorui_no | 書類番号 |
| `repeat_num` | repeat_num, krkes_bngu | 繰返番号 |
| `class` | class, rui, knd | 類 |

## 適用ルール

1. **新規テーブル作成時**
   - 上記の統一カラム名を使用
   - TSVファイルの物理名が統一リストにない場合はそのまま使用

2. **既存データの移行時**
   - 統一カラム名にマッピング
   - 元のカラム名はコメントに記録

3. **複合的な名前**
   - アンダースコアで単語を区切る
   - 例: `intl_reg_num_update_count_code`

4. **データ型の統一**
   - 番号系: TEXT（ゼロパディングを保持）
   - 日付系: TEXT（YYYYMMDD形式）
   - フラグ系: TEXT（'0' or '1'）
   - コード系: TEXT

## 注意事項

- 同じテーブル内で重複するカラム名は避ける
- 外部キー参照時は参照先と同じカラム名を使用
- 日本語カラム名は使用しない（コメントには記載可）
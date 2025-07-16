# TMCloud データベース ER図設計書

## 概要
商標管理システム（TMCloud）のデータベース構造をER図として表現するための設計書です。

## エンティティ分類

### 🏠 国内商標エンティティ群

#### 1. 基本エンティティ
- **jiken_c_t** (事件管理テーブル) - 22,227件
  - PK: normalized_app_num (TEXT)
  - shutugan_bi (TEXT) - 出願日
  - reg_reg_ymd (TEXT) - 登録日

#### 2. テキスト関連エンティティ
- **standard_char_t_art** (標準文字商標) - 15,109件
  - FK: normalized_app_num → jiken_c_t
  - standard_char_t (TEXT) - 商標文字

- **indct_use_t_art** (表示用商標) - 31,681件
  - FK: normalized_app_num → jiken_c_t
  - indct_use_t (TEXT) - 表示商標

- **search_use_t_art_table** (検索用商標) - 31,681件
  - FK: normalized_app_num → jiken_c_t
  - search_use_t (TEXT) - 検索用商標

#### 3. 分類関連エンティティ
- **goods_class_art** (商品区分) - 30,582件
  - FK: normalized_app_num → jiken_c_t
  - goods_classes (TEXT) - 商品区分

- **t_knd_info_art_table** (類似群) - 64,404件
  - FK: normalized_app_num → jiken_c_t
  - smlr_dsgn_group_cd (TEXT) - 類似群コード

#### 4. 権利者関連エンティティ
- **right_person_art_t** (権利者) - 17,099件
  - FK: normalized_app_num → jiken_c_t
  - right_person_name (TEXT) - 権利者名
  - right_person_addr (TEXT) - 権利者住所

- **jiken_c_t_shutugannindairinin** (出願人・代理人) - 37,019件
  - FK: normalized_app_num → jiken_c_t
  - shutugannindairinin_code - 出願人コード
  - shutugannindairinin_nm - 出願人名

#### 5. マッピングエンティティ
- **reg_mapping** (登録番号マッピング) - 33,764件
  - app_num (TEXT) → jiken_c_t.normalized_app_num
  - reg_num (TEXT) - 登録番号

### 🌍 国際商標エンティティ群

#### 1. 基本エンティティ
- **intl_trademark_registration** (国際商標基本) - 1,430件
  - PK: id (INTEGER)
  - UK: intl_reg_num (TEXT) - 国際登録番号
  - app_date (TEXT) - 出願日
  - intl_reg_date (TEXT) - 国際登録日

#### 2. 関連エンティティ（1対多関係）
- **intl_trademark_text** (商標テキスト) - 2,678件
  - FK: intl_reg_num → intl_trademark_registration
  - t_dtl_explntn (TEXT) - 商標詳細説明

- **intl_trademark_goods_services** (商品・役務) - 2,280件
  - FK: intl_reg_num → intl_trademark_registration
  - goods_class (TEXT) - 商品区分
  - goods_content (TEXT) - 商品内容

- **intl_trademark_holder** (権利者) - 1,492件
  - FK: intl_reg_num → intl_trademark_registration
  - holder_name (TEXT) - 権利者名
  - holder_name_japanese (TEXT) - 権利者名（日本語）

- **intl_trademark_progress** (進行状況) - 5,738件
  - FK: intl_reg_num → intl_trademark_registration
  - prog_cd (TEXT) - 進行コード
  - prog_content (TEXT) - 進行内容

### 👤 申請人マスターエンティティ群

- **applicant_master** (申請人マスター) - 1,612件
  - PK: appl_cd (TEXT)
  - appl_name (TEXT) - 申請人名
  - appl_addr (TEXT) - 申請人住所

- **applicant_mapping** (申請人マッピング) - 4,429件
  - PK: applicant_code
  - applicant_name - マッピング後名称

## 主要リレーション

### 国内商標の関係
```
jiken_c_t (1) ──── (0..1) standard_char_t_art
jiken_c_t (1) ──── (0..n) goods_class_art
jiken_c_t (1) ──── (0..n) right_person_art_t
jiken_c_t (1) ──── (0..1) reg_mapping
```

### 国際商標の関係
```
intl_trademark_registration (1) ──── (0..n) intl_trademark_text
intl_trademark_registration (1) ──── (0..n) intl_trademark_goods_services
intl_trademark_registration (1) ──── (1..n) intl_trademark_holder
intl_trademark_registration (1) ──── (0..n) intl_trademark_progress
```

### 申請人関係
```
applicant_master (1) ──── (0..n) jiken_c_t_shutugannindairinin
```

## ER図描画のポイント

1. **エンティティボックス**:
   - エンティティ名
   - 主キー（🔑マーク）
   - 重要な属性3-5個
   - 件数表示

2. **リレーション線**:
   - 実線: 強い関係（必須）
   - 破線: 弱い関係（任意）
   - カーディナリティ表示（1, n, 0..1, 1..n）

3. **グループ化**:
   - 国内商標グループ（青系）
   - 国際商標グループ（緑系）
   - 申請人マスターグループ（橙系）

4. **配置推奨**:
   ```
   [申請人マスター群]
           |
   [国内商標基本] ── [国内商標詳細群]
           |
   [統合検索ビュー]
           |
   [国際商標基本] ── [国際商標詳細群]
   ```

## 統合検索の視点

- unified_trademark_search_view により国内・国際商標を統合検索
- source_type で 'domestic' / 'international' を識別
- 共通検索インターフェースを提供
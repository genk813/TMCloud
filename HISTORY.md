# TMCloud プロジェクト履歴

## 2025-09-03 PostgreSQL 237テーブル完全実装

### 概要
TMCloudプロジェクトのデータベースを完全に再構築し、237テーブルのPostgreSQLスキーマを実装、1,176,941行のデータを正常にインポートした。

### 問題の発見と解決

#### 1. 仕様書の特定
- 当初、誤った仕様書（3.3版）を使用していた
- 正しい仕様書を特定：
  - **3-3b.xlsx**: 通常テーブル（198テーブル）
  - **5-1.xlsx**: 審判系テーブル（39テーブル）
  - **3-1b.xlsx**: ファイル一覧（247番号、49欠番あり）

#### 2. テーブル数の検証
- 3-1b.xlsxの分析により247番号中49個が欠番と判明
  - 57-95番（39個）：審判系テーブル（5-1.xlsxに移動）
  - その他10個：実在しない番号（195, 196, 197, 198, 199, 200, 207, 215, 228, 246）
- 実際のテーブル数：247 - 10欠番 = 237テーブル

### 実装内容

#### 1. 仕様抽出スクリプト
- **extract_all_perfect_specs.py**: 3-3b.xlsx用（198テーブル抽出）
- **extract_5_1_specs.py**: 5-1.xlsx用（39テーブル抽出、異なるカラム構造に対応）
  - 5-1.xlsxの特殊構造：主キーは37列目、データ型は39列目、最大桁数は44列目

#### 2. スキーマ生成
- **merge_and_generate_schema.py**: 両仕様を統合してPostgreSQLスキーマ生成
- **tmcloud_complete_schema.sql**: 237テーブルの完全なスキーマ
  - NOT NULL制約を除外（データにNULL値が存在）
  - PRIMARY KEY制約をコメントアウト（NULL値のため）
  - 1,662個のインデックスを定義

#### 3. データインポート
- **tmcloud_import_postgresql.py**: 237テーブル対応のインポートスクリプト（V2）
  - 1行ずつの確実な処理
  - カラム不一致の自動処理
  - データクレンジング（31桁の0をNULL変換、日付ハイフン除去など）
  - エンコーディング自動検出（UTF-8, Shift-JIS, CP932）

### 成果

#### データベース構成
```
総テーブル数: 237
- 通常テーブル: 198（3-3b.xlsx）
- 審判系テーブル: 39（5-1.xlsx）
```

#### インポート結果（2025-09-03 14:49）
```
成功: 1,176,941行
エラー: 0行
スキップ: 145テーブル（TSVファイルなし）
```

### 技術的詳細

#### PostgreSQL設定
```
データベース: tmcloud_db
ユーザー: ygenk
パスワード: tmcloud
ホスト: localhost
ポート: 5432
```

#### ファイル構成
```
仕様関連：
- all_specs_merged.json: 237テーブル統合仕様
- 3_3b_specs.json: 通常テーブル仕様（198）
- 5_1_specs.json: 審判系テーブル仕様（39）

スキーマ：
- tmcloud_complete_schema.sql: 完全スキーマ（237テーブル）

スクリプト：
- tmcloud_import_postgresql.py: インポートスクリプト（V2版）
- extract_all_perfect_specs.py: 3-3b.xlsx抽出
- extract_5_1_specs.py: 5-1.xlsx抽出
- merge_and_generate_schema.py: 統合＆SQL生成
```

#### 修正事項
- rlt_caseテーブルの重複カラム（updt_dttm）を修正
- fix_rlt_case.sqlで個別対応

### コマンド履歴

```bash
# データベース作成
sudo -u postgres psql -c "DROP DATABASE IF EXISTS tmcloud_db;"
sudo -u postgres psql -c "CREATE DATABASE tmcloud_db OWNER ygenk;"

# スキーマ適用
psql -U ygenk -d tmcloud_db -f tmcloud_complete_schema.sql

# rlt_caseテーブル修正
psql -U ygenk -d tmcloud_db -f fix_rlt_case.sql

# インポート実行
source .venv/bin/activate && python3 tmcloud_import_postgresql.py 20250618
```

### 今後の課題
1. 検索機能の実装
2. APIの作成
3. クエリ最適化
4. バックアップ戦略の策定

---

## 2025-01-02 データベーススキーマ全面刷新

### 実施内容

#### 1. JPO CSVファイル仕様書のクリーンアップ
- **問題**: 特許庁のCSVファイル仕様書が52列あるが、実際のデータは8列のみに散在
- **解決**: `clean_jpo_csv_final.py`を作成し、全198個のCSVファイルをクリーンアップ
  - メタデータ行を2列形式に統一
  - ヘッダー行を正しく抽出
  - 不要な空カンマを削除
  - cleanフォルダに整理して保存

#### 2. カラム名の不一致分析
- **`check_column_consistency.py`**: 同じ論理名で異なる物理名を検出
  - 45件の不一致を発見（例：出願番号が`app_num`/`shutugan_no`/`sytgn_bngu`の3種類）
- **`find_similar_logical_names.py`**: 類似度分析
  - 類似度0.8以上で792件のペアを検出
  - パターン別分析（コード系、番号系、日付系など）

#### 3. カラム名統一ルールの策定
- **`column_unification_rules.md`**: 統一ルールを文書化
  - 主要な統一例：
    - 出願番号 → `app_num`（107テーブルで使用）
    - 四法コード → `law_cd`（92テーブルで使用）
    - 登録番号 → `reg_num`（45テーブルで使用）
  - スネークケース（snake_case）で統一
  - 特許庁のTSVファイルの物理名を原則使用

#### 4. 完全データベーススキーマの生成
- **`generate_complete_schema.py`**: 全CSVファイル仕様書からスキーマ自動生成
  - ルールベースでCSVファイルを解析
  - 項番、論理名、物理名、主キー、データ型を正確に抽出
  - カラム名統一ルールを自動適用
- **`tmcloud_complete_schema.sql`**: 生成された完全スキーマ
  - 197テーブルの定義（全198CSVファイルから）
  - 4,083行のSQL定義
  - CREATE TABLE IF NOT EXISTSで柔軟な運用が可能

### 成果

#### データベース構造の把握
- 現在のデータベース: 40テーブル、38個のTSVファイルがインポート済み
- 主要テーブルのレコード数:
  - `trademark_case_info`: 16,688件
  - `trademark_goods_services`: 33,385件
  - `trademark_progress_info`: 223,693件
  - `trademark_vienna_codes`: 100,370件

#### 統一されたカラム統計
```
app_num: 107テーブル
law_cd: 92テーブル
split_num: 49テーブル
reg_num: 45テーブル
```

### 新しい運用方針

1. **完全スキーマ定義アプローチ**
   - SQLファイルに全198テーブルの定義を記載
   - 週次更新時にTSVファイルが存在すればデータ投入
   - データがないテーブルは空のまま（エラーにならない）
   - TSVファイルの選別ミスによる漏れを防止

2. **カラム名統一**
   - 同じ意味の項目は統一された名前を使用
   - 外部キー参照時の一貫性を確保
   - 検索・結合処理の効率化

### ファイル整理
- 分析・テスト用スクリプト28個を`old_files/scripts/`へ移動
- 分析結果JSON 4個を`old_files/json/`へ移動
- 古いデータベース2個を`old_files/db/`へ移動
- ドキュメント15個を`old_files/docs/`へ移動

### 残された重要ファイル
- `tmcloud_complete_schema.sql` - 完全データベーススキーマ
- `generate_complete_schema.py` - スキーマ生成スクリプト
- `column_unification_rules.md` - カラム名統一ルール
- `README.md` - プロジェクト説明
- `CLAUDE.md` - Claude用設定

---

## 以前の履歴

### 2024-08-02 週次更新スクリプトの開発
- `tmcloud_weekly_update.py`の作成（v1〜v12まで改善）
- UPSERT処理で差分更新を実現
- 113,079件挿入、44,318件更新、0エラーを達成

### 2024-07-30 スキーマ設計
- `tmcloud_schema_v2_design.md`の作成
- TMSONAR_REQUIRED_COLUMNS.mdに基づく設計

### 2024-07-29 プロジェクト開始
- TMSONARレベルの商標検索システム構築を目標に設定
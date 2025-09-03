# 🗄️ SQL基礎 - TMCloudのデータベースを理解しよう！

## 📚 目次
1. [SQLとは？データベースとは？](#1-sqlとデータベース)
2. [SELECT文 - データを取り出す](#2-select文)
3. [WHERE句 - 条件で絞り込む](#3-where句)
4. [JOIN - テーブルを結合する](#4-join)
5. [集計関数](#5-集計関数)
6. [並び替えと制限](#6-並び替えと制限)
7. [INSERT/UPDATE/DELETE](#7-データの追加更新削除)
8. [インデックス](#8-インデックス)
9. [TMCloudで使われているSQL](#9-tmcloudの実例)
10. [SQLiteの特徴](#10-sqliteの特徴)

---

## 1. SQLとデータベース 📊

### データベース = 整理されたデータの倉庫

```
エクセルとデータベースの比較：

エクセル:                    データベース:
┌─────────────┐            ┌──────────────────┐
│ 1つのファイル │            │ 複数のテーブル    │
│ 1つのシート   │            │ リレーション      │
│ 手動で検索    │            │ SQLで高速検索     │
└─────────────┘            └──────────────────┘
```

### SQL = データベースと話す言語

```sql
-- 人間の言葉: 「プルという名前の商標を探して」
-- SQL: 
SELECT * FROM trademark_search WHERE search_use_t LIKE '%プル%';
```

### TMCloudのデータベース構造
```
tmcloud_v2.db (SQLiteデータベース)
│
├── trademark_case_info (商標基本情報)
│   ├── app_num (出願番号) - PRIMARY KEY
│   ├── app_date (出願日)
│   ├── reg_num (登録番号)
│   └── ...
│
├── trademark_phonetics (称呼)
│   ├── app_num (出願番号) - FOREIGN KEY
│   └── phonetic (読み方)
│
└── trademark_search (検索用)
    ├── app_num (出願番号)
    └── search_use_t_norm (正規化商標名)
```

---

## 2. SELECT文 - データを取り出す 🔍

### 基本構文
```sql
SELECT カラム名 FROM テーブル名;
```

### TMCloudでの実例

```sql
-- 1. 全てのカラムを取得（*は全部という意味）
SELECT * FROM trademark_case_info;

-- 2. 特定のカラムだけ取得
SELECT app_num, app_date, reg_num 
FROM trademark_case_info;

-- 3. 別名をつける（AS）
SELECT 
    app_num AS 出願番号,
    app_date AS 出願日,
    reg_num AS 登録番号
FROM trademark_case_info;
```

### 図解：SELECTの動作
```
[元のテーブル: trademark_case_info]
┌──────────┬──────────┬──────────┬──────────┐
│ app_num  │ app_date │ reg_num  │ status   │
├──────────┼──────────┼──────────┼──────────┤
│2025064118│ 20250725 │    -     │ 審査中    │
│2025064119│ 20250725 │    -     │ 審査中    │
└──────────┴──────────┴──────────┴──────────┘

SELECT app_num, app_date FROM trademark_case_info;
                ↓
[結果]
┌──────────┬──────────┐
│ app_num  │ app_date │
├──────────┼──────────┤
│2025064118│ 20250725 │
│2025064119│ 20250725 │
└──────────┴──────────┘
```

---

## 3. WHERE句 - 条件で絞り込む 🎯

### 基本構文
```sql
SELECT * FROM テーブル名 WHERE 条件;
```

### 条件の書き方

```sql
-- TMCloudでよく使う条件

-- 1. 完全一致（=）
SELECT * FROM trademark_case_info 
WHERE app_num = '2025064118';

-- 2. 部分一致（LIKE）
SELECT * FROM trademark_search 
WHERE search_use_t_norm LIKE '%プル%';
-- % は「任意の文字列」を表す

-- 3. 範囲指定（BETWEEN）
SELECT * FROM trademark_case_info 
WHERE app_date BETWEEN '20250701' AND '20250731';

-- 4. リストに含まれる（IN）
SELECT * FROM trademark_case_info 
WHERE substr(app_num, 5, 2) IN ('35', '36', '37');
-- マドプロ案件の抽出

-- 5. NULL値のチェック
SELECT * FROM trademark_case_info 
WHERE reg_num IS NOT NULL;
-- 登録済みの商標だけ
```

### 複数条件の組み合わせ

```sql
-- AND（両方満たす）
SELECT * FROM trademark_case_info 
WHERE app_date >= '20250101' 
  AND final_disposition_type = 'A01';

-- OR（どちらか満たす）
SELECT * FROM trademark_search 
WHERE search_use_t_norm LIKE '%プル%' 
   OR search_use_t_norm LIKE '%PULL%';
```

### 図解：WHERE句の絞り込み
```
[元データ: 100万件]
        ↓
    WHERE句で条件指定
        ↓
    条件に合うか？
    ／        ＼
  Yes          No
   ↓           ↓
[結果に含む] [除外]
   ↓
[結果: 166件]
```

---

## 4. JOIN - テーブルを結合する 🔗

### TMCloudで重要なJOIN

```sql
-- 基本情報と称呼を結合
SELECT 
    tci.app_num,
    tci.app_date,
    tp.phonetic
FROM trademark_case_info tci
LEFT JOIN trademark_phonetics tp 
    ON tci.app_num = tp.app_num
WHERE tci.app_num = '2025064118';
```

### JOINの種類

```sql
-- 1. INNER JOIN（両方に存在するデータのみ）
SELECT * FROM A
INNER JOIN B ON A.id = B.id;

-- 2. LEFT JOIN（左側は全て、右側は一致するもののみ）
SELECT * FROM A
LEFT JOIN B ON A.id = B.id;

-- 3. TMCloudでの実例（複数テーブル結合）
SELECT 
    ts.app_num,
    ts.search_use_t,
    tci.app_date,
    tci.reg_num,
    tp.phonetic
FROM trademark_search ts
LEFT JOIN trademark_case_info tci 
    ON ts.app_num = tci.app_num
LEFT JOIN trademark_phonetics tp 
    ON ts.app_num = tp.app_num
WHERE ts.search_use_t_norm LIKE '%プル%';
```

### 図解：JOINの仕組み
```
[テーブルA]           [テーブルB]
┌────┬────┐       ┌────┬────┐
│ ID │名前 │       │ ID │住所 │
├────┼────┤       ├────┼────┤
│ 1  │田中 │       │ 1  │東京 │
│ 2  │佐藤 │       │ 3  │大阪 │
└────┴────┘       └────┴────┘

INNER JOIN:         LEFT JOIN:
┌────┬────┬────┐   ┌────┬────┬────┐
│ ID │名前 │住所 │   │ ID │名前 │住所 │
├────┼────┼────┤   ├────┼────┼────┤
│ 1  │田中 │東京 │   │ 1  │田中 │東京 │
└────┴────┴────┘   │ 2  │佐藤 │NULL│
                    └────┴────┴────┘
```

---

## 5. 集計関数 📈

### よく使う集計関数

```sql
-- 1. COUNT - 件数を数える
SELECT COUNT(*) FROM trademark_case_info;
-- 結果: 796707

-- 2. COUNT DISTINCT - 重複を除いて数える
SELECT COUNT(DISTINCT applicant_name) 
FROM trademark_applicants_agents;

-- 3. MAX/MIN - 最大値/最小値
SELECT 
    MAX(app_date) AS 最新出願日,
    MIN(app_date) AS 最古出願日
FROM trademark_case_info;

-- 4. GROUP BY - グループごとに集計
SELECT 
    substr(app_num, 1, 4) AS year,
    COUNT(*) AS count
FROM trademark_case_info
GROUP BY substr(app_num, 1, 4)
ORDER BY year DESC;
```

### TMCloudでの集計例

```sql
-- 年ごとの出願件数
SELECT 
    substr(app_date, 1, 4) AS 年,
    COUNT(*) AS 出願件数
FROM trademark_case_info
WHERE app_date >= '20200101'
GROUP BY substr(app_date, 1, 4)
ORDER BY 年;

-- 結果例:
-- 2020 | 125432
-- 2021 | 134521
-- 2022 | 142365
-- 2023 | 151234
-- 2024 | 165432
-- 2025 | 78543
```

---

## 6. 並び替えと制限 🔢

### ORDER BY - 並び替え

```sql
-- 1. 昇順（ASC - デフォルト）
SELECT * FROM trademark_case_info
ORDER BY app_date;  -- 古い順

-- 2. 降順（DESC）
SELECT * FROM trademark_case_info
ORDER BY app_date DESC;  -- 新しい順

-- 3. 複数条件での並び替え
SELECT * FROM trademark_case_info
ORDER BY app_date DESC, app_num ASC;
```

### LIMIT - 件数制限

```sql
-- 最新10件を取得
SELECT * FROM trademark_case_info
ORDER BY app_date DESC
LIMIT 10;

-- 11件目から20件目を取得（ページング）
SELECT * FROM trademark_case_info
ORDER BY app_date DESC
LIMIT 10 OFFSET 10;
```

### TMCloudでの実例

```sql
-- 「プル」を含む最新5件の商標
SELECT 
    ts.app_num,
    ts.search_use_t,
    tci.app_date
FROM trademark_search ts
LEFT JOIN trademark_case_info tci 
    ON ts.app_num = tci.app_num
WHERE ts.search_use_t_norm LIKE '%プル%'
ORDER BY tci.app_date DESC
LIMIT 5;
```

---

## 7. データの追加・更新・削除 ✏️

### INSERT - データ追加

```sql
-- 基本構文
INSERT INTO テーブル名 (カラム1, カラム2) 
VALUES (値1, 値2);

-- TMCloudでの例（週次更新）
INSERT INTO trademark_case_info (
    app_num, 
    app_date, 
    applicant_name
) VALUES (
    '2025999999', 
    '20250830', 
    'テスト株式会社'
);
```

### UPDATE - データ更新

```sql
-- 基本構文
UPDATE テーブル名 
SET カラム1 = 新しい値 
WHERE 条件;

-- TMCloudでの例
UPDATE trademark_case_info 
SET final_disposition_type = 'A01',
    reg_num = '7123456'
WHERE app_num = '2025064118';
```

### DELETE - データ削除

```sql
-- 基本構文
DELETE FROM テーブル名 WHERE 条件;

-- 注意：WHERE句なしは全削除！
DELETE FROM trademark_case_info;  -- 危険！

-- 安全な削除
DELETE FROM trademark_case_info 
WHERE app_num = '2025999999';
```

### UPSERT（INSERT OR REPLACE）

```sql
-- SQLiteの特殊構文
INSERT OR REPLACE INTO trademark_case_info (
    app_num, app_date, reg_num
) VALUES (
    '2025064118', '20250725', '7123456'
);
-- 存在すれば更新、なければ追加
```

---

## 8. インデックス ⚡

### インデックス = 本の索引

```sql
-- インデックスの作成
CREATE INDEX idx_app_date 
ON trademark_case_info(app_date);

-- 複合インデックス
CREATE INDEX idx_search_norm 
ON trademark_search(search_use_t_norm);
```

### 図解：インデックスの効果
```
インデックスなし:           インデックスあり:
全ページを確認              索引で場所を特定
📚→📖→📖→📖→📖           📚→📑→📖
  1秒かかる                  0.001秒

速度: 1000倍！
```

### TMCloudのインデックス戦略

```sql
-- 主キーは自動的にインデックス
-- app_num (PRIMARY KEY)

-- よく検索される項目にインデックス
CREATE INDEX idx_search_norm 
ON trademark_search(search_use_t_norm);

CREATE INDEX idx_phonetic 
ON trademark_phonetics(phonetic);

CREATE INDEX idx_app_date 
ON trademark_case_info(app_date);
```

---

## 9. TMCloudの実例 🎯

### 商標名検索の完全なSQL

```sql
-- tmcloud_search_integrated.pyで使われているSQL
SELECT 
    ts.app_num,
    COALESCE(
        td.indct_use_t,
        tsc.standard_char_t,
        ts.search_use_t
    ) as trademark_name,
    tci.app_date,
    tci.reg_date,
    tci.final_disposition_type,
    tci.law_code,
    tci.class_count
FROM trademark_search ts
LEFT JOIN trademark_case_info tci 
    ON ts.app_num = tci.app_num
LEFT JOIN trademark_basic_items tbi 
    ON ts.app_num = tbi.app_num
LEFT JOIN trademark_display td 
    ON ts.app_num = td.app_num
LEFT JOIN trademark_standard_char tsc 
    ON ts.app_num = tsc.app_num
WHERE ts.search_use_t_norm LIKE ?
ORDER BY COALESCE(tci.app_date, tbi.app_date) DESC
LIMIT ?;
```

### 国際登録番号検索

```sql
-- マドプロ案件の検索
SELECT 
    app_num,
    intl_reg_num,
    intl_reg_date
FROM trademark_basic_items
WHERE intl_reg_num = ?
   OR (intl_reg_num || intl_reg_date) = ?;
```

### 統計情報の取得

```sql
-- データベースの状態確認
SELECT 
    'trademark_case_info' as table_name,
    COUNT(*) as record_count
FROM trademark_case_info
UNION ALL
SELECT 
    'trademark_phonetics',
    COUNT(*)
FROM trademark_phonetics
UNION ALL
SELECT 
    'trademark_search',
    COUNT(*)
FROM trademark_search;
```

---

## 10. SQLiteの特徴 💎

### SQLiteとは
- ファイルベースのデータベース
- サーバー不要
- 軽量・高速
- TMCloudで採用

### SQLite特有の機能

```sql
-- 1. 型の柔軟性
CREATE TABLE flexible (
    id INTEGER,
    data  -- 型指定なしでもOK
);

-- 2. PRAGMA（設定コマンド）
PRAGMA foreign_keys = ON;  -- 外部キー制約を有効化
PRAGMA journal_mode = WAL;  -- 高速化

-- 3. 文字列関数
SELECT 
    substr(app_num, 1, 4) AS year,  -- 部分文字列
    length(trademark_name) AS len,   -- 文字数
    upper(trademark_name) AS upper_name  -- 大文字変換
FROM trademark_case_info;

-- 4. 日付関数
SELECT 
    date('now') AS today,
    datetime('now', 'localtime') AS now_local;
```

---

## 📝 練習問題

### 問題1: SELECT文
```sql
-- trademark_case_infoから2025年の出願を取得
-- ヒント: app_numの最初4文字が年を表す
SELECT * FROM trademark_case_info
WHERE ______________;
```

### 問題2: JOIN
```sql
-- 商標名と称呼を一緒に取得
SELECT 
    ts.app_num,
    ts.search_use_t,
    _______________
FROM trademark_search ts
_________ trademark_phonetics tp
    ON _____________
WHERE ts.app_num = '2025064118';
```

### 問題3: 集計
```sql
-- 月ごとの出願件数を集計（2025年）
SELECT 
    substr(_______, _, _) AS month,
    _______ AS count
FROM trademark_case_info
WHERE app_date LIKE '2025%'
GROUP BY _______
ORDER BY _______;
```

<details>
<summary>答え</summary>

問題1:
```sql
SELECT * FROM trademark_case_info
WHERE substr(app_num, 1, 4) = '2025';
-- または
WHERE app_num LIKE '2025%';
```

問題2:
```sql
SELECT 
    ts.app_num,
    ts.search_use_t,
    tp.phonetic
FROM trademark_search ts
LEFT JOIN trademark_phonetics tp
    ON ts.app_num = tp.app_num
WHERE ts.app_num = '2025064118';
```

問題3:
```sql
SELECT 
    substr(app_date, 5, 2) AS month,
    COUNT(*) AS count
FROM trademark_case_info
WHERE app_date LIKE '2025%'
GROUP BY substr(app_date, 5, 2)
ORDER BY month;
```
</details>

---

## 🎓 SQLマスターへの道

### 学習のコツ
1. **実際に書いて実行** - 読むだけでなく実践
2. **エラーを恐れない** - エラーメッセージから学ぶ
3. **少しずつ複雑に** - 簡単なSQLから始める
4. **実行計画を見る** - EXPLAIN QUERYで最適化を学ぶ

### よくある間違い
```sql
-- ❌ 間違い
SELECT * FROM table WHERE name = プル;
-- ✅ 正解（文字列は引用符で囲む）
SELECT * FROM table WHERE name = 'プル';

-- ❌ 間違い（WHERE句なしのDELETE）
DELETE FROM table;
-- ✅ 正解（条件を必ず指定）
DELETE FROM table WHERE id = 1;
```

### TMCloudでSQLを試す方法
```bash
# SQLiteに接続
sqlite3 tmcloud_v2.db

# SQLを実行
sqlite> SELECT COUNT(*) FROM trademark_case_info;

# テーブル一覧
sqlite> .tables

# スキーマ確認
sqlite> .schema trademark_case_info

# 終了
sqlite> .quit
```

---

## 🚀 次のステップ

SQLの基礎を理解したら：
1. **HTML/CSS** - Web画面の作成方法を学ぶ
2. **Python + SQL** - プログラムからデータベースを操作
3. **最適化** - インデックスと実行計画の理解
4. **NoSQL** - 他のデータベース技術も学ぶ

データベースは**現代のアプリケーションの心臓部**です。
しっかり理解して、効率的なデータ管理を目指しましょう！
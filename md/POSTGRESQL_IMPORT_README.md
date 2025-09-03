# TMCloud PostgreSQL インポートシステム

## 概要
PostgreSQLデータベースにTSVファイルをインポートする確実なシステムです。

## 特徴
- **1行ずつ処理**：最も確実な方式
- **エラースキップ**：エラー行をスキップして継続
- **カラム自動マッチング**：TSVとDBのカラムを自動マッチング
- **データクレンジング**：自動的にデータを正規化
- **詳細ログ**：全ての処理を記録

## 必要な準備

### 1. Pythonパッケージのインストール
```bash
pip install psycopg2-binary chardet
```

### 2. PostgreSQLデータベースの確認
```bash
# データベース接続テスト
psql -U ygenk -h localhost -d tmcloud_db -c "\dt" | head -5
```

## 使用方法

### 基本的な使用
```bash
# Windows PowerShell/コマンドプロンプト
python tmcloud_import_postgresql.py 20250618

# WSL/Linux
python3 tmcloud_import_postgresql.py 20250618
```

### オプション指定
```bash
# 詳細ログ出力
python tmcloud_import_postgresql.py 20250618 --verbose

# ドライラン（実行せずに確認）
python tmcloud_import_postgresql.py 20250618 --dry-run

# データベース接続情報を指定
python tmcloud_import_postgresql.py 20250618 \
  --host localhost \
  --port 5432 \
  --database tmcloud_db \
  --user ygenk \
  --password tmcloud
```

## データクレンジング処理

### 自動的に行われる処理
1. **NULL変換**
   - 空文字列 → NULL
   - 7桁以上の0のみ → NULL

2. **番号正規化**
   - ハイフン除去（出願番号・登録番号など）

3. **日付変換**
   - YYYYMMDD → YYYY-MM-DD形式

## ログファイル

`logs/`ディレクトリに以下のファイルが作成されます：

- `import_YYYYMMDD_HHMMSS.log` - 詳細ログ
- `error_YYYYMMDD_HHMMSS.log` - エラーのみ
- `import_result_YYYYMMDD_HHMMSS.json` - 統計情報

## カラム不一致の処理

TSVファイルとデータベースのカラムが一致しない場合：

1. **自動マッチング**：名前が一致するカラムのみインポート
2. **ログ記録**：不一致内容を記録
3. **処理継続**：エラーにせず処理を継続

## トラブルシューティング

### psycopg2のインストールエラー
```bash
# Windows環境の場合
pip install psycopg2-binary

# それでもエラーの場合
pip install --upgrade pip
pip install psycopg2-binary
```

### 接続エラー
```bash
# PostgreSQLサービスの確認
sudo service postgresql status

# 接続テスト
psql -U ygenk -h localhost -d tmcloud_db
```

### 文字化け
- TSVファイルのエンコーディングは自動検出されます
- UTF-8, Shift-JIS, CP932などに対応

## 処理時間の目安

- 1万行：約3-5分
- 10万行：約30-50分
- 確実性を重視した1行ずつ処理のため時間がかかります

## 実行例

```bash
$ python tmcloud_import_postgresql.py 20250618
============================================================
TMCloud PostgreSQL インポートシステム
日付: 20250618
データベース: tmcloud_db@localhost:5432
============================================================
2025-09-03 12:00:00 [INFO] PostgreSQL接続成功: tmcloud_db
2025-09-03 12:00:00 [INFO] TSVファイル数: 45
2025-09-03 12:00:01 [INFO] [1/45] upd_t_basic_item_art.tsv -> t_basic_item_art
2025-09-03 12:00:01 [INFO] インポート開始: upd_t_basic_item_art.tsv -> t_basic_item_art
2025-09-03 12:00:05 [INFO]   処理中: 1,000行 (成功: 998, エラー: 2)
2025-09-03 12:00:10 [INFO]   完了: 成功=1,996, エラー=4
...
============================================================
インポート完了
処理時間: 180.5秒
成功: 15,234行
エラー: 45行
スキップ: 2テーブル
カラム不一致: 3テーブル
結果保存: logs/import_result_20250903_120000.json
```

## 注意事項

- **削除ファイル（del_*.tsv）はスキップされます**
- **主キーが重複する場合は更新（UPSERT）されます**
- **エラーが発生してもインポートは継続されます**

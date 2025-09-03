# TMCloud データインポートシステム詳細仕様書

## 1. システム概要
- **目的**: 特許庁提供のTSVファイルをSQLiteデータベースに確実にインポート
- **対応範囲**: 198テーブル完全対応
- **処理モード**: 初回フルインポート / 週次差分更新

## 2. TSVファイル処理仕様

### 2.1 ファイル命名規則
| 処理種別 | ファイル名パターン | 例 | 処理内容 |
|---------|------------------|-----|---------|
| 更新（差分） | `upd_{table_name}.tsv` | `upd_jiken_c_t.tsv` | UPSERT処理（初回・週次共通） |
| 削除（差分） | `del_{table_name}.tsv` | `del_jiken_c_t.tsv` | DELETE処理 |

**注意**: 現在は初回インポートも`upd_`プレフィックス付きファイルを使用

### 2.2 処理優先順位
1. **削除処理** (`del_*.tsv`) - 最初に実行
2. **更新処理** (`upd_*.tsv`) - 次に実行（初回は全件INSERT、週次はUPSERT）

## 3. データベース操作戦略

### 3.1 初回インポート
```sql
-- トランザクション単位：テーブル毎
BEGIN TRANSACTION;
PRAGMA foreign_keys = OFF;  -- 外部キー制約一時無効化
-- バルクINSERT実行
INSERT INTO table_name (...) VALUES (...);
PRAGMA foreign_keys = ON;
COMMIT;
```

### 3.2 週次更新（UPSERT）
```sql
-- PRIMARY KEYベースの更新
INSERT OR REPLACE INTO table_name (...) VALUES (...);
```

### 3.3 週次削除
```sql
-- PRIMARY KEYベースの削除
DELETE FROM table_name WHERE primary_key_columns = ?;
```

## 4. データ整合性保証

### 4.1 プライマリキー管理
- スキーマから自動抽出
- 重複チェック実施
- NULL値の適切な処理

### 4.2 データクレンジング
- 空文字列 → NULL変換
- 31桁の0 → NULL変換
- 出願番号のハイフン除去
- 日付フォーマット正規化

## 5. エラーハンドリング

### 5.1 リトライ戦略
- **リトライ回数**: 最大3回
- **リトライ間隔**: 1秒、2秒、4秒（指数バックオフ）
- **ロールバック**: エラー時は自動ロールバック

### 5.2 ログ記録
```
logs/
├── import_YYYYMMDD_HHMMSS.log    # 処理ログ
├── error_YYYYMMDD_HHMMSS.log     # エラーログ
└── stats_YYYYMMDD_HHMMSS.json    # 統計情報
```

### 5.3 エラー種別と対応
| エラー種別 | 対応 |
|-----------|------|
| ファイル不在 | スキップして続行 |
| エンコーディング | 自動検出リトライ |
| PRIMARY KEY違反 | REPLACE処理 |
| 外部キー違反 | エラーログ記録、スキップ |
| メモリ不足 | バッチサイズ縮小 |

## 6. パフォーマンス最適化

### 6.1 バッチ処理
- **バッチサイズ**: 1000レコード/トランザクション
- **メモリ制限**: 最大500MB
- **動的調整**: エラー時はバッチサイズを半減

### 6.2 SQLite最適化
```sql
PRAGMA journal_mode = WAL;          -- Write-Ahead Logging
PRAGMA synchronous = NORMAL;        -- 同期モード
PRAGMA cache_size = 10000;          -- キャッシュサイズ
PRAGMA temp_store = MEMORY;         -- 一時ストレージ
```

## 7. 週次更新の確実性保証

### 7.1 更新前チェックリスト
- [ ] データベースバックアップ作成
- [ ] ディスク容量確認（必要容量の2倍以上）
- [ ] 処理対象ファイル一覧確認
- [ ] スキーマバージョン確認

### 7.2 更新後検証
- [ ] レコード数整合性（前回比較）
- [ ] PRIMARY KEY重複チェック
- [ ] 削除レコード確認
- [ ] 統計情報の妥当性確認

## 8. 特殊ケース処理

### 8.1 大容量データ
- **商標画像**: ストリーミング処理
- **長文テキスト**: 分割読み込み
- **複数行データ**: 結合処理

### 8.2 文字エンコーディング
**検出順序**:
1. UTF-8
2. CP932（Windows日本語）
3. Shift-JIS
4. EUC-JP

## 9. モニタリング

### 9.1 進捗表示
```
[商標基本情報] ████████████░░░░ 75% (15,234/20,312) 1,523 rec/s ETA: 00:03:20
```

### 9.2 統計情報出力
```json
{
  "start_time": "2025-01-09T10:00:00",
  "end_time": "2025-01-09T10:45:23",
  "duration_seconds": 2723,
  "tables_processed": 198,
  "records": {
    "inserted": 450234,
    "updated": 12345,
    "deleted": 234,
    "errors": 12
  },
  "performance": {
    "avg_records_per_second": 165,
    "peak_memory_mb": 423
  }
}
```

## 10. 実行コマンド

### 10.1 初回インポート
```bash
# 初回も upd_*.tsv ファイルを使用
python tmcloud_import.py --mode initial --db tmcloud.db --tsv-dir /path/to/tsv/20250611/
```

### 10.2 週次更新
```bash
python tmcloud_import.py --mode weekly --db tmcloud.db --tsv-dir /path/to/weekly/20250618/
```

### 10.3 オプション
```bash
--dry-run          # 実行せずに処理内容を確認
--skip-backup      # バックアップをスキップ（非推奨）
--parallel N       # 並列処理数（デフォルト:1）
--batch-size N     # バッチサイズ（デフォルト:1000）
--log-level LEVEL  # ログレベル（DEBUG/INFO/WARNING/ERROR）
```

## 11. 障害復旧

### 11.1 ロールバック手順
1. 処理を中断（Ctrl+C）
2. バックアップから復元
3. エラーログ確認
4. 問題修正後、再実行

### 11.2 部分再実行
```bash
# 特定テーブルのみ再実行
python tmcloud_import.py --mode weekly --tables jiken_c_t,trademark_case
```

## 12. データ検証ツール

### 12.1 整合性チェック
```bash
python tmcloud_verify.py --db tmcloud.db --check integrity
```

### 12.2 差分レポート
```bash
python tmcloud_verify.py --db tmcloud.db --compare-with backup.db
```
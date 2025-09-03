# TMCloud PostgreSQL移行戦略

## 1. 移行の必要性

### 現状の課題
- **データ規模**: 10億件規模のデータ（現在の500倍）
- **SQLiteの限界**:
  - 同時書き込み不可（単一ライターのみ）
  - 大規模データでのパフォーマンス劣化
  - パーティショニング未対応
  - 高度なインデックス機能の欠如

### PostgreSQLの利点
- **スケーラビリティ**: 数十億レコード対応
- **並列処理**: 複数CPUコアの活用
- **パーティショニング**: テーブル分割による高速化
- **高度なインデックス**: BRIN、GIN、GiST、SP-GiST
- **COPY機能**: 超高速バルクインポート

## 2. アーキテクチャ設計

### 2.1 パーティショニング戦略

```sql
-- 年度別パーティショニング（大規模テーブル用）
CREATE TABLE jiken_c_t (
    processing_type TEXT,
    law_cd TEXT,
    app_num TEXT,
    split_num TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) PARTITION BY RANGE (app_num);

-- 年度別パーティション作成
CREATE TABLE jiken_c_t_2020 PARTITION OF jiken_c_t 
    FOR VALUES FROM ('2020000000') TO ('2021000000');
CREATE TABLE jiken_c_t_2021 PARTITION OF jiken_c_t 
    FOR VALUES FROM ('2021000000') TO ('2022000000');
```

### 2.2 インデックス戦略

#### 通常のB-treeインデックス（小〜中規模）
```sql
CREATE INDEX idx_app_num ON jiken_c_t(app_num);
```

#### BRINインデックス（超大規模テーブル用）
```sql
-- 物理的に順序付けられたデータに最適
CREATE INDEX idx_created_at_brin ON large_table 
    USING BRIN (created_at);
```

#### GINインデックス（全文検索用）
```sql
CREATE INDEX idx_trademark_gin ON trademark_search 
    USING GIN (to_tsvector('japanese', trademark_name));
```

## 3. データ型マッピング

| SQLite | PostgreSQL | 備考 |
|--------|------------|------|
| TEXT | TEXT/VARCHAR | 長さ制限がある場合はVARCHAR |
| INTEGER | INTEGER/BIGINT | 10億件ならBIGINT推奨 |
| REAL | REAL/DOUBLE PRECISION | |
| BLOB | BYTEA | バイナリデータ |
| DATETIME | TIMESTAMP WITH TIME ZONE | タイムゾーン対応 |

## 4. パフォーマンス最適化

### 4.1 PostgreSQL設定（postgresql.conf）

```ini
# メモリ設定（64GBサーバー想定）
shared_buffers = 16GB          # 総メモリの25%
effective_cache_size = 48GB    # 総メモリの75%
work_mem = 256MB              # ソート・ハッシュ用
maintenance_work_mem = 2GB     # VACUUM、インデックス作成用

# 並列処理
max_parallel_workers_per_gather = 4
max_parallel_workers = 8
max_parallel_maintenance_workers = 4

# チェックポイント
checkpoint_timeout = 30min
checkpoint_completion_target = 0.9
max_wal_size = 16GB
min_wal_size = 2GB

# 統計情報
default_statistics_target = 100
random_page_cost = 1.1  # SSD使用時
```

### 4.2 インポート最適化

```python
# COPY使用による高速インポート
def bulk_import_postgresql(conn, table_name, tsv_file):
    with conn.cursor() as cursor:
        with open(tsv_file, 'r', encoding='utf-8') as f:
            cursor.copy_expert(
                f"COPY {table_name} FROM STDIN WITH (FORMAT csv, DELIMITER E'\\t', HEADER true)",
                f
            )
```

## 5. 実装手順

### Phase 1: 環境準備（1週間）
1. PostgreSQLサーバーセットアップ
2. 必要なエクステンション導入（pg_trgm、btree_gin等）
3. 開発環境構築

### Phase 2: スキーマ移行（1週間）
1. PostgreSQL用スキーマ生成スクリプト作成
2. パーティショニング設計実装
3. インデックス設計実装

### Phase 3: データ移行（2週間）
1. インポートスクリプトのPostgreSQL対応
2. 初期データ移行（現在の200万件）
3. パフォーマンステスト

### Phase 4: 本番移行（1週間）
1. 全データ（10億件）のインポート
2. インデックス構築
3. VACUUM ANALYZE実行
4. パフォーマンスチューニング

## 6. 必要なリソース

### ハードウェア要件（10億件対応）
- **CPU**: 16コア以上
- **メモリ**: 64GB以上（理想は128GB）
- **ストレージ**: 
  - NVMe SSD 2TB以上
  - データ: 約1TB
  - インデックス: 約300GB
  - WAL・バックアップ: 約500GB

### ソフトウェア
- PostgreSQL 15以上
- pgAdmin 4（管理ツール）
- pg_stat_statements（性能分析）
- pg_repack（オンラインVACUUM）

## 7. 監視・運用

### 監視項目
- クエリ実行時間
- テーブル・インデックスサイズ
- VACUUM実行状況
- レプリケーション遅延

### バックアップ戦略
- pg_basebackup（フルバックアップ）
- WALアーカイブ（増分バックアップ）
- pg_dump（論理バックアップ）

## 8. リスクと対策

| リスク | 対策 |
|--------|------|
| インポート時間が長い | パラレルインポート、UNLOGGED TABLE使用 |
| メモリ不足 | work_mem動的調整、パーティション分割 |
| ディスクI/O遅延 | テーブルスペース分散、SSD使用 |
| インデックス肥大化 | 定期的なREINDEX、pg_repack使用 |

## 9. 移行判定基準

### 成功基準
- [ ] 全データ（10億件）のインポート完了
- [ ] 主要クエリの応答時間 < 1秒
- [ ] 日次更新処理 < 1時間
- [ ] 同時接続100ユーザー対応

### ロールバック計画
- SQLiteデータベースの保持（3ヶ月）
- 段階的移行（読み取り→書き込み）
- データ整合性チェックツール

## 10. 次のステップ

1. **PostgreSQL用スキーマ生成スクリプト作成**
2. **パーティショニング詳細設計**
3. **COPY対応インポートスクリプト作成**
4. **性能テスト環境構築**
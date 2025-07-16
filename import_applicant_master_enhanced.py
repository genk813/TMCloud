#!/usr/bin/env python3
"""
申請人マスターデータの拡充インポートスクリプト
申請人名の取得率を大幅に向上させる
"""
import sqlite3
import csv
import os
from datetime import datetime

def import_applicant_master_data():
    """申請人マスターデータをインポート"""
    
    conn = sqlite3.connect("output.db")
    cursor = conn.cursor()
    
    print("🔧 申請人マスターデータのインポート開始")
    print("=" * 50)
    print(f"実行時間: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print("=" * 50)
    
    # 1. 申請人マスターテーブルの作成（存在しない場合）
    print("\n1. 申請人マスターテーブルの準備")
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS applicant_master (
            appl_cd TEXT PRIMARY KEY,
            appl_name TEXT,
            appl_cana_name TEXT,
            appl_postcode TEXT,
            appl_addr TEXT,
            wes_join_name TEXT,
            wes_join_addr TEXT,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    """)
    
    # 既存データをクリア
    cursor.execute("DELETE FROM applicant_master")
    conn.commit()
    
    # 2. upd_appl_reg_info.tsv のインポート
    tsv_file = "tsv_data/tsv/upd_appl_reg_info.tsv"
    if os.path.exists(tsv_file):
        print(f"\n2. {tsv_file} をインポート中...")
        
        with open(tsv_file, 'r', encoding='utf-8') as f:
            reader = csv.DictReader(f, delimiter='\t')
            
            import_count = 0
            error_count = 0
            
            for row in reader:
                try:
                    cursor.execute("""
                        INSERT OR REPLACE INTO applicant_master 
                        (appl_cd, appl_name, appl_cana_name, appl_postcode, appl_addr, wes_join_name, wes_join_addr)
                        VALUES (?, ?, ?, ?, ?, ?, ?)
                    """, (
                        row.get('appl_cd', ''),
                        row.get('appl_name', ''),
                        row.get('appl_cana_name', ''),
                        row.get('appl_postcode', ''),
                        row.get('appl_addr', ''),
                        row.get('wes_join_name', ''),
                        row.get('wes_join_addr', '')
                    ))
                    import_count += 1
                    
                    if import_count % 1000 == 0:
                        print(f"  {import_count:,}件処理済み...")
                        
                except Exception as e:
                    error_count += 1
                    if error_count <= 5:
                        print(f"  エラー: {e}")
            
            conn.commit()
            print(f"  ✅ {import_count:,}件インポート完了（エラー: {error_count}件）")
    
    # 3. 申請人マッピングの拡張
    print("\n3. 申請人マッピングの拡張")
    
    # 既存のマッピングテーブルをバックアップ
    cursor.execute("CREATE TABLE IF NOT EXISTS applicant_mapping_backup AS SELECT * FROM applicant_mapping")
    
    # 新しいマッピングを作成
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS applicant_mapping_new (
            applicant_code TEXT PRIMARY KEY,
            applicant_name TEXT,
            applicant_addr TEXT,
            confidence_level REAL DEFAULT 1.0,
            source TEXT DEFAULT 'master',
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
    """)
    
    # マスターデータからマッピングを生成
    cursor.execute("""
        INSERT OR REPLACE INTO applicant_mapping_new (applicant_code, applicant_name, applicant_addr, source)
        SELECT 
            appl_cd,
            appl_name,
            appl_addr,
            'master'
        FROM applicant_master
        WHERE appl_name IS NOT NULL AND appl_name != ''
    """)
    
    new_mappings = cursor.rowcount
    print(f"  マスターから {new_mappings:,}件の新規マッピング作成")
    
    # 既存のマッピングも統合
    cursor.execute("""
        INSERT OR IGNORE INTO applicant_mapping_new (applicant_code, applicant_name, applicant_addr, confidence_level, source)
        SELECT 
            applicant_code,
            applicant_name,
            NULL,
            confidence_level,
            'existing'
        FROM applicant_mapping
    """)
    
    existing_kept = cursor.rowcount
    print(f"  既存マッピング {existing_kept:,}件を保持")
    
    # 新しいマッピングテーブルに置き換え
    cursor.execute("DROP TABLE IF EXISTS applicant_mapping")
    cursor.execute("ALTER TABLE applicant_mapping_new RENAME TO applicant_mapping")
    
    # 4. インデックスの作成
    print("\n4. インデックスの作成")
    cursor.execute("CREATE INDEX IF NOT EXISTS idx_applicant_master_appl_cd ON applicant_master(appl_cd)")
    cursor.execute("CREATE INDEX IF NOT EXISTS idx_applicant_master_appl_name ON applicant_master(appl_name)")
    cursor.execute("CREATE INDEX IF NOT EXISTS idx_applicant_mapping_code ON applicant_mapping(applicant_code)")
    cursor.execute("CREATE INDEX IF NOT EXISTS idx_applicant_mapping_name ON applicant_mapping(applicant_name)")
    print("  ✅ インデックス作成完了")
    
    # 5. 統計情報の更新
    print("\n5. 統計情報の更新")
    
    # 申請人名カバレッジの再計算
    cursor.execute("""
        SELECT COUNT(DISTINCT j.normalized_app_num)
        FROM jiken_c_t j
        LEFT JOIN jiken_c_t_shutugannindairinin ap ON j.normalized_app_num = ap.shutugan_no
        WHERE ap.shutugannindairinin_sikbt = '1'
    """)
    total_apps_with_applicant = cursor.fetchone()[0]
    
    cursor.execute("""
        SELECT COUNT(DISTINCT j.normalized_app_num)
        FROM jiken_c_t j
        LEFT JOIN jiken_c_t_shutugannindairinin ap ON j.normalized_app_num = ap.shutugan_no
        LEFT JOIN applicant_mapping am ON ap.shutugannindairinin_code = am.applicant_code
        WHERE ap.shutugannindairinin_sikbt = '1' AND am.applicant_name IS NOT NULL
    """)
    apps_with_name = cursor.fetchone()[0]
    
    new_coverage = apps_with_name / total_apps_with_applicant * 100 if total_apps_with_applicant > 0 else 0
    
    print("\n📊 インポート結果サマリー")
    print("=" * 50)
    
    cursor.execute("SELECT COUNT(*) FROM applicant_master")
    master_count = cursor.fetchone()[0]
    
    cursor.execute("SELECT COUNT(*) FROM applicant_mapping")
    mapping_count = cursor.fetchone()[0]
    
    print(f"申請人マスター登録数: {master_count:,}件")
    print(f"申請人マッピング数: {mapping_count:,}件")
    print(f"申請人名カバレッジ: {new_coverage:.1f}% (改善前: 14.8%)")
    
    if new_coverage > 50:
        print("\n✅ 目標の50%以上を達成！")
    else:
        print(f"\n⚠️ 目標の50%には未達（現在: {new_coverage:.1f}%）")
    
    conn.commit()
    conn.close()
    
    return {
        'master_count': master_count,
        'mapping_count': mapping_count,
        'coverage': new_coverage
    }

if __name__ == "__main__":
    result = import_applicant_master_data()
    print("\n処理完了！")
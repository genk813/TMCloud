#!/usr/bin/env python3
"""
申請人データのカバレッジ分析と改善策の検討
"""
import sqlite3
from collections import Counter

def analyze_applicant_coverage():
    """申請人データのカバレッジを詳細分析"""
    
    conn = sqlite3.connect("output.db")
    cursor = conn.cursor()
    
    print("🔍 申請人データカバレッジの詳細分析")
    print("=" * 60)
    
    # 1. 申請人コードの長さ分布
    print("\n1. 申請人コードの特徴分析")
    cursor.execute("""
        SELECT 
            shutugannindairinin_code,
            COUNT(*) as usage_count
        FROM jiken_c_t_shutugannindairinin
        WHERE shutugannindairinin_sikbt = '1'
        GROUP BY shutugannindairinin_code
        ORDER BY usage_count DESC
        LIMIT 20
    """)
    
    print("最も頻繁に使用される申請人コード（上位20件）:")
    top_codes = []
    for code, count in cursor.fetchall():
        top_codes.append(code)
        print(f"  {code}: {count}件")
    
    # 2. マッピング状況の確認
    print("\n2. 上位申請人コードのマッピング状況")
    placeholders = ','.join(['?' for _ in top_codes])
    cursor.execute(f"""
        SELECT 
            applicant_code,
            applicant_name
        FROM applicant_mapping
        WHERE applicant_code IN ({placeholders})
    """, top_codes)
    
    mapped_codes = {row[0]: row[1] for row in cursor.fetchall()}
    
    for code in top_codes[:10]:
        if code in mapped_codes:
            print(f"  ✅ {code}: {mapped_codes[code]}")
        else:
            print(f"  ❌ {code}: マッピングなし")
    
    # 3. 申請人名の直接取得を試みる
    print("\n3. jiken_c_t_shutugannindairininテーブルの申請人名フィールド確認")
    cursor.execute("PRAGMA table_info(jiken_c_t_shutugannindairinin)")
    columns = [row[1] for row in cursor.fetchall()]
    print(f"カラム一覧: {', '.join(columns)}")
    
    # 申請人名が直接格納されているか確認
    name_columns = [col for col in columns if 'name' in col.lower() or 'mei' in col.lower()]
    if name_columns:
        print(f"\n申請人名関連カラム発見: {', '.join(name_columns)}")
        
        for col in name_columns:
            cursor.execute(f"""
                SELECT COUNT(DISTINCT {col})
                FROM jiken_c_t_shutugannindairinin
                WHERE {col} IS NOT NULL AND {col} != ''
            """)
            count = cursor.fetchone()[0]
            print(f"  {col}: {count}件の非空値")
    
    # 4. 出願人コードの形式分析
    print("\n4. 申請人コードの形式分析")
    cursor.execute("""
        SELECT DISTINCT shutugannindairinin_code
        FROM jiken_c_t_shutugannindairinin
        WHERE shutugannindairinin_sikbt = '1'
        LIMIT 1000
    """)
    
    codes = [row[0] for row in cursor.fetchall() if row[0]]
    code_lengths = Counter(len(code) for code in codes)
    
    print("コード長の分布:")
    for length, count in sorted(code_lengths.items()):
        print(f"  {length}文字: {count}件")
    
    # 5. 年代別のカバレッジ
    print("\n5. 年代別申請人名カバレッジ")
    cursor.execute("""
        SELECT 
            SUBSTR(j.shutugan_bi, 1, 4) as year,
            COUNT(DISTINCT j.normalized_app_num) as total,
            COUNT(DISTINCT CASE WHEN am.applicant_name IS NOT NULL THEN j.normalized_app_num END) as with_name
        FROM jiken_c_t j
        LEFT JOIN jiken_c_t_shutugannindairinin ap ON j.normalized_app_num = ap.shutugan_no
        LEFT JOIN applicant_mapping am ON ap.shutugannindairinin_code = am.applicant_code
        WHERE ap.shutugannindairinin_sikbt = '1'
        GROUP BY year
        ORDER BY year DESC
        LIMIT 10
    """)
    
    for year, total, with_name in cursor.fetchall():
        coverage = with_name / total * 100 if total > 0 else 0
        print(f"  {year}年: {with_name}/{total} ({coverage:.1f}%)")
    
    # 6. 改善提案
    print("\n6. 改善提案")
    
    # 申請人名フィールドがある場合の直接マッピング作成
    if name_columns:
        print("\n申請人名フィールドからの直接マッピング作成を試みます...")
        
        for col in name_columns[:1]:  # 最初の名前カラムを使用
            cursor.execute(f"""
                INSERT OR IGNORE INTO applicant_mapping (applicant_code, applicant_name, source)
                SELECT 
                    shutugannindairinin_code,
                    {col},
                    'direct_field'
                FROM jiken_c_t_shutugannindairinin
                WHERE shutugannindairinin_sikbt = '1'
                  AND shutugannindairinin_code IS NOT NULL
                  AND {col} IS NOT NULL 
                  AND {col} != ''
            """)
            
            new_mappings = cursor.rowcount
            if new_mappings > 0:
                conn.commit()
                print(f"  ✅ {col}から{new_mappings}件の新規マッピング作成")
    
    # 最終カバレッジの再計算
    cursor.execute("""
        SELECT COUNT(DISTINCT j.normalized_app_num)
        FROM jiken_c_t j
        LEFT JOIN jiken_c_t_shutugannindairinin ap ON j.normalized_app_num = ap.shutugan_no
        WHERE ap.shutugannindairinin_sikbt = '1'
    """)
    total_apps = cursor.fetchone()[0]
    
    cursor.execute("""
        SELECT COUNT(DISTINCT j.normalized_app_num)
        FROM jiken_c_t j
        LEFT JOIN jiken_c_t_shutugannindairinin ap ON j.normalized_app_num = ap.shutugan_no
        LEFT JOIN applicant_mapping am ON ap.shutugannindairinin_code = am.applicant_code
        WHERE ap.shutugannindairinin_sikbt = '1' AND am.applicant_name IS NOT NULL
    """)
    apps_with_name = cursor.fetchone()[0]
    
    final_coverage = apps_with_name / total_apps * 100 if total_apps > 0 else 0
    
    print(f"\n最終カバレッジ: {final_coverage:.1f}%")
    
    conn.close()
    return final_coverage

if __name__ == "__main__":
    coverage = analyze_applicant_coverage()
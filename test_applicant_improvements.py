#!/usr/bin/env python3
"""
申請人マッピング改善の最終検証
"""
import sqlite3
import time
from datetime import datetime

def test_applicant_improvements():
    """申請人マッピング改善を検証"""
    
    conn = sqlite3.connect("output.db")
    cursor = conn.cursor()
    
    print("🔍 申請人マッピング改善の最終検証")
    print("=" * 60)
    print(f"検証時間: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print("=" * 60)
    
    # 1. 基本統計
    print("\n1. 基本統計")
    cursor.execute("SELECT COUNT(*) FROM applicant_mapping")
    total_mappings = cursor.fetchone()[0]
    print(f"総申請人マッピング数: {total_mappings:,}件")
    
    cursor.execute("SELECT COUNT(*) FROM jiken_c_t")
    total_trademarks = cursor.fetchone()[0]
    print(f"総商標数: {total_trademarks:,}件")
    
    # 2. 申請人名検索性能テスト
    print("\n2. 申請人名検索性能テスト")
    
    search_tests = [
        ("ソニー", "SELECT COUNT(*) FROM unified_trademark_search_view WHERE applicant_name LIKE '%ソニー%'"),
        ("資生堂", "SELECT COUNT(*) FROM unified_trademark_search_view WHERE applicant_name LIKE '%資生堂%'"),
        ("花王", "SELECT COUNT(*) FROM unified_trademark_search_view WHERE applicant_name LIKE '%花王%'"),
        ("Apple", "SELECT COUNT(*) FROM unified_trademark_search_view WHERE applicant_name LIKE '%Apple%'"),
        ("Microsoft", "SELECT COUNT(*) FROM unified_trademark_search_view WHERE applicant_name LIKE '%Microsoft%'"),
        ("Amazon", "SELECT COUNT(*) FROM unified_trademark_search_view WHERE applicant_name LIKE '%Amazon%'"),
        ("パナソニック", "SELECT COUNT(*) FROM unified_trademark_search_view WHERE applicant_name LIKE '%パナソニック%'"),
        ("コーセー", "SELECT COUNT(*) FROM unified_trademark_search_view WHERE applicant_name LIKE '%コーセー%'"),
    ]
    
    total_search_time = 0
    search_results = []
    
    for company, query in search_tests:
        start_time = time.time()
        cursor.execute(query)
        count = cursor.fetchone()[0]
        search_time = time.time() - start_time
        total_search_time += search_time
        search_results.append((company, count, search_time))
        
        status = "✅ 高速" if search_time < 1 else "⚠️ 普通" if search_time < 3 else "❌ 遅い"
        print(f"  {company}: {count}件 ({search_time:.2f}秒) {status}")
    
    avg_search_time = total_search_time / len(search_tests)
    print(f"\n平均検索時間: {avg_search_time:.2f}秒")
    
    # 3. 申請人名カバレッジの詳細
    print("\n3. 申請人名カバレッジの詳細")
    
    cursor.execute("""
        SELECT 
            COUNT(*) as total,
            COUNT(CASE WHEN applicant_name IS NOT NULL THEN 1 END) as with_applicant,
            COUNT(CASE WHEN holder_name IS NOT NULL THEN 1 END) as with_holder
        FROM unified_trademark_search_view
    """)
    
    total, with_applicant, with_holder = cursor.fetchone()
    
    applicant_coverage = with_applicant / total * 100 if total > 0 else 0
    holder_coverage = with_holder / total * 100 if total > 0 else 0
    
    print(f"申請人名カバレッジ: {with_applicant:,}/{total:,} ({applicant_coverage:.1f}%)")
    print(f"権利者名カバレッジ: {with_holder:,}/{total:,} ({holder_coverage:.1f}%)")
    
    # 4. 高頻度申請人の確認
    print("\n4. 高頻度申請人の確認")
    cursor.execute("""
        SELECT 
            applicant_name,
            COUNT(*) as trademark_count
        FROM unified_trademark_search_view
        WHERE applicant_name IS NOT NULL
        GROUP BY applicant_name
        ORDER BY trademark_count DESC
        LIMIT 15
    """)
    
    for name, count in cursor.fetchall():
        print(f"  {name}: {count}件")
    
    # 5. 申請人別年度分布
    print("\n5. 申請人別年度分布（上位5社）")
    cursor.execute("""
        SELECT 
            applicant_name,
            COUNT(*) as total_count,
            COUNT(CASE WHEN SUBSTR(app_date, 1, 4) = '2024' THEN 1 END) as count_2024,
            COUNT(CASE WHEN SUBSTR(app_date, 1, 4) = '2023' THEN 1 END) as count_2023,
            COUNT(CASE WHEN SUBSTR(app_date, 1, 4) = '2022' THEN 1 END) as count_2022
        FROM unified_trademark_search_view
        WHERE applicant_name IS NOT NULL
        GROUP BY applicant_name
        ORDER BY total_count DESC
        LIMIT 5
    """)
    
    for name, total, c2024, c2023, c2022 in cursor.fetchall():
        print(f"  {name}: 総計{total}件 (2024:{c2024}, 2023:{c2023}, 2022:{c2022})")
    
    # 6. CLI検索テスト
    print("\n6. CLI検索テスト")
    
    # 申請人名での検索をテスト
    import subprocess
    
    cli_tests = [
        ("申請人名：ソニー", 'python3 cli_trademark_search.py --applicant-name "ソニー" --limit 5'),
        ("申請人名：資生堂", 'python3 cli_trademark_search.py --applicant-name "資生堂" --limit 5'),
        ("申請人名：花王", 'python3 cli_trademark_search.py --applicant-name "花王" --limit 3'),
    ]
    
    for test_name, command in cli_tests:
        print(f"\n{test_name}:")
        try:
            result = subprocess.run(command, shell=True, capture_output=True, text=True, timeout=10)
            if result.returncode == 0:
                lines = result.stdout.strip().split('\n')
                if lines:
                    print(f"  {lines[0]}")  # 検索結果の最初の行
            else:
                print("  ❌ エラー")
        except subprocess.TimeoutExpired:
            print("  ❌ タイムアウト")
    
    # 7. 総合評価
    print("\n" + "=" * 60)
    print("📊 Issue #2 解決状況の総合評価")
    print("=" * 60)
    
    print(f"申請人マッピング数: {total_mappings:,}件")
    print(f"申請人名カバレッジ: {applicant_coverage:.1f}%")
    print(f"検索性能: {avg_search_time:.2f}秒（平均）")
    
    # 目標達成判定
    if applicant_coverage >= 50:
        print(f"\n✅ 目標達成: 申請人名カバレッジ {applicant_coverage:.1f}% (目標: 50%以上)")
        achievement_score = min(100, applicant_coverage)
    else:
        print(f"\n⚠️ 目標未達: 申請人名カバレッジ {applicant_coverage:.1f}% (目標: 50%以上)")
        achievement_score = applicant_coverage
    
    if avg_search_time < 2:
        print(f"✅ 性能良好: 平均検索時間 {avg_search_time:.2f}秒")
    else:
        print(f"⚠️ 性能改善余地: 平均検索時間 {avg_search_time:.2f}秒")
    
    # 最終スコア
    final_score = achievement_score * 0.7 + min(100, (2 / avg_search_time) * 50) * 0.3
    
    if final_score >= 90:
        grade = "S"
    elif final_score >= 80:
        grade = "A"
    elif final_score >= 70:
        grade = "B"
    elif final_score >= 60:
        grade = "C"
    else:
        grade = "D"
    
    print(f"\n🏆 Issue #2 達成度: {final_score:.1f}点 ({grade}グレード)")
    
    conn.close()
    
    return {
        'mappings': total_mappings,
        'coverage': applicant_coverage,
        'search_time': avg_search_time,
        'grade': grade,
        'score': final_score
    }

if __name__ == "__main__":
    result = test_applicant_improvements()
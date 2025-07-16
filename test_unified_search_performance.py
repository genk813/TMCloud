#!/usr/bin/env python3
"""
統合検索性能テストスクリプト
軽量版統合ビューの性能を包括的にテスト
"""
import sqlite3
import time
import sys
from datetime import datetime

def test_unified_search_performance():
    """統合検索の性能テストを実行"""
    
    conn = sqlite3.connect("output.db")
    cursor = conn.cursor()
    
    print("🚀 統合検索性能テスト")
    print("=" * 50)
    print(f"テスト実行時間: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    print("=" * 50)
    
    test_results = []
    
    # テスト1: 基本統計
    print("\n📊 基本統計テスト")
    start_time = time.time()
    cursor.execute("SELECT COUNT(*) FROM unified_trademark_search_view")
    total_count = cursor.fetchone()[0]
    test1_time = time.time() - start_time
    test_results.append(("基本統計", test1_time))
    print(f"総件数: {total_count:,}件 ({test1_time:.2f}秒)")
    
    # 国内・国際の内訳
    cursor.execute("SELECT source_type, COUNT(*) FROM unified_trademark_search_view GROUP BY source_type")
    for source_type, count in cursor.fetchall():
        print(f"  {source_type}: {count:,}件")
    
    # テスト2: 商標名検索
    print("\n🔍 商標名検索テスト")
    test_queries = [
        ("ソニー", "SELECT COUNT(*) FROM unified_trademark_search_view WHERE trademark_text LIKE '%ソニー%'"),
        ("パナソニック", "SELECT COUNT(*) FROM unified_trademark_search_view WHERE trademark_text LIKE '%パナソニック%'"),
        ("Apple", "SELECT COUNT(*) FROM unified_trademark_search_view WHERE trademark_text LIKE '%Apple%'"),
        ("Microsoft", "SELECT COUNT(*) FROM unified_trademark_search_view WHERE trademark_text LIKE '%Microsoft%'"),
    ]
    
    for query_name, query_sql in test_queries:
        start_time = time.time()
        cursor.execute(query_sql)
        result_count = cursor.fetchone()[0]
        query_time = time.time() - start_time
        test_results.append((f"商標名検索({query_name})", query_time))
        print(f"  {query_name}: {result_count}件 ({query_time:.2f}秒)")
    
    # テスト3: 制限付き検索
    print("\n📋 制限付き検索テスト")
    start_time = time.time()
    cursor.execute("""
        SELECT app_num, trademark_text, source_type, registration_status 
        FROM unified_trademark_search_view 
        WHERE trademark_text LIKE '%ソニー%' 
        LIMIT 10
    """)
    results = cursor.fetchall()
    test3_time = time.time() - start_time
    test_results.append(("制限付き検索", test3_time))
    print(f"制限付き検索: {len(results)}件 ({test3_time:.2f}秒)")
    
    for i, (app_num, text, source, status) in enumerate(results, 1):
        print(f"  {i}. {app_num} - {text} ({source}, {status})")
    
    # テスト4: 複雑な検索条件
    print("\n🔬 複雑な検索条件テスト")
    complex_queries = [
        ("登録済み商標", "SELECT COUNT(*) FROM unified_trademark_search_view WHERE registration_status = '登録済'"),
        ("未登録商標", "SELECT COUNT(*) FROM unified_trademark_search_view WHERE registration_status = '未登録'"),
        ("国内登録済み", "SELECT COUNT(*) FROM unified_trademark_search_view WHERE source_type = 'domestic' AND registration_status = '登録済'"),
        ("国際登録済み", "SELECT COUNT(*) FROM unified_trademark_search_view WHERE source_type = 'international' AND registration_status = '登録済'"),
    ]
    
    for query_name, query_sql in complex_queries:
        start_time = time.time()
        cursor.execute(query_sql)
        result_count = cursor.fetchone()[0]
        query_time = time.time() - start_time
        test_results.append((f"複雑検索({query_name})", query_time))
        print(f"  {query_name}: {result_count:,}件 ({query_time:.2f}秒)")
    
    # テスト5: 年代別検索
    print("\n📅 年代別検索テスト")
    start_time = time.time()
    cursor.execute("""
        SELECT COUNT(*) FROM unified_trademark_search_view 
        WHERE app_date LIKE '2020%' OR app_date LIKE '2021%' OR app_date LIKE '2022%'
    """)
    recent_count = cursor.fetchone()[0]
    test5_time = time.time() - start_time
    test_results.append(("年代別検索", test5_time))
    print(f"最近3年間（2020-2022）: {recent_count:,}件 ({test5_time:.2f}秒)")
    
    # 総合評価
    print("\n" + "=" * 50)
    print("📋 性能テスト結果サマリー")
    print("=" * 50)
    
    total_test_time = sum(result[1] for result in test_results)
    avg_test_time = total_test_time / len(test_results)
    
    print(f"総テスト時間: {total_test_time:.2f}秒")
    print(f"平均応答時間: {avg_test_time:.2f}秒")
    
    # 個別結果
    print("\n個別テスト結果:")
    for test_name, test_time in test_results:
        status = "✅ 高速" if test_time < 1 else "⚠️ 普通" if test_time < 3 else "❌ 遅い"
        print(f"  {test_name}: {test_time:.2f}秒 {status}")
    
    # 目標達成確認
    print("\n🎯 目標達成状況:")
    if avg_test_time < 5:
        print("✅ 目標達成: 平均応答時間が5秒以内")
        grade = "S" if avg_test_time < 1 else "A" if avg_test_time < 2 else "B"
        print(f"性能評価: {grade}グレード")
    else:
        print(f"❌ 目標未達: 平均応答時間が{avg_test_time:.2f}秒（目標: 5秒以内）")
        grade = "C"
        print(f"性能評価: {grade}グレード")
    
    conn.close()
    
    return {
        'total_records': total_count,
        'avg_response_time': avg_test_time,
        'test_results': test_results,
        'grade': grade
    }

if __name__ == "__main__":
    result = test_unified_search_performance()
    sys.exit(0 if result['avg_response_time'] < 5 else 1)
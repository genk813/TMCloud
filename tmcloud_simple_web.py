#!/usr/bin/env python3
"""
TMCloud 簡易Webインターフェース
将来のFlask Webサービスへの第一歩
"""

from flask import Flask, render_template, request, jsonify
from tmcloud_search_integrated import TMCloudIntegratedSearch
from pathlib import Path
import json
import sys
import logging

# エラーをコンソールに強制的に出す設定
logging.basicConfig(stream=sys.stderr, level=logging.DEBUG)

app = Flask(__name__)

# データベースパス（変更可能）
DB_PATH = Path(__file__).parent / "tmcloud_v2_20250831_182810.db"

@app.route('/')
def index():
    """トップページ"""
    return render_template('base.html')

@app.route('/search', methods=['POST', 'GET'])
def search():
    """検索API"""
    try:
        # GETリクエストの場合
        if request.method == 'GET':
            search_type = request.args.get('type', 'trademark')
            keyword = request.args.get('keyword', '')
            format_type = request.args.get('format', 'html')
        # POSTリクエストの場合
        else:
            data = request.json
            # 'type' と 'search_type' の両方を受け入れる（互換性のため）
            search_type = data.get('type') or data.get('search_type', 'trademark')
            keyword = data.get('keyword', '')
            format_type = 'json'
        
        if not keyword:
            return jsonify({'error': 'キーワードを入力してください'}), 400
        
        # 毎回新しい接続を作成（コネクション切れ対策）
        searcher = TMCloudIntegratedSearch(str(DB_PATH))
        
        if search_type == 'trademark':
            print(f"[DEBUG] Trademark search for: {keyword}", file=sys.stderr)
            results = searcher.search_trademark_name(keyword, limit=3000, unified_format=True)
            print(f"[DEBUG] Trademark search returned {len(results)} results", file=sys.stderr)
        elif search_type == 'phonetic':
            print(f"[DEBUG] Phonetic search for: {keyword}", file=sys.stderr)
            results = searcher.search_phonetic(keyword, limit=3000, unified_format=True)
            print(f"[DEBUG] Phonetic search returned {len(results)} results", file=sys.stderr)
        elif search_type == 'phonetic_exact':
            print(f"[DEBUG] Phonetic exact search for: {keyword}", file=sys.stderr)
            results = searcher.search_phonetic(keyword, limit=3000, unified_format=True)
            print(f"[DEBUG] Phonetic exact search returned {len(results)} results", file=sys.stderr)
        elif search_type == 'app_num':
            result = searcher.search_by_app_num(keyword, unified_format=True)  # 単一番号検索
            results = [result] if result else []  # リストに変換
        elif search_type == 'reg_num':
            result = searcher.search_by_reg_num(keyword, unified_format=True)  # 単一番号検索
            results = [result] if result else []  # リストに変換
        elif search_type == 'intl_reg_num':
            print(f"[DEBUG] IntlReg search raw: {keyword}", file=sys.stderr)
            result = searcher.search_by_intl_reg_num(keyword, unified_format=True, limit=10000)

            # ワイルドカード検索の場合はリスト、通常検索の場合は単一結果
            if isinstance(result, list):
                print(f"[DEBUG] IntlReg wildcard results: {len(result)} items", file=sys.stderr)
                results = result
            elif result:
                print(f"[DEBUG] IntlReg result: {bool(result)} {result.get('app_num')}", file=sys.stderr)
                results = [result]  # リストに変換
            else:
                results = []

        elif search_type == 'applicant':
            results = searcher.search_applicant(keyword, limit=3000, unified_format=True)
        elif search_type == 'similar_group':
            results = searcher.search_by_similar_group(keyword, limit=3000, unified_format=True)
        elif search_type == 'goods_services':
            results = searcher.search_goods_services(keyword, limit=3000, item_and=True, unified_format=True)
        elif search_type == 'rejection_reason':
            results = searcher.search_rejection_reason(keyword, limit=3000, unified_format=True)
        elif search_type == 'vienna_code':
            results = searcher.search_by_vienna_code(keyword, limit=3000, unified_format=True)
        else:
            return jsonify({'error': '不明な検索タイプ'})
        
        # GETリクエストでformat=htmlの場合はHTMLとして表示
        if request.method == 'GET' and format_type == 'html':
            # 検索結果をテンプレートに渡して表示
            return render_template('base.html', 
                search_results=json.dumps({
                    'results': results,
                    'count': len(results),
                    'search_type': search_type,
                    'keyword': keyword
                }, ensure_ascii=False)
            )
        
        return jsonify({
            'results': results,
            'count': len(results),
            'search_type': search_type,
            'keyword': keyword
        })
        
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/search_complex', methods=['POST'])
def search_complex():
    """複合条件検索API"""
    try:
        data = request.json
        conditions = data.get('conditions', [])
        operator = data.get('operator', 'AND')
        
        # デバッグ: 受信した条件をログ出力
        print(f"[DEBUG] Received conditions: {conditions}", file=sys.stderr)
        
        if not conditions:
            return jsonify({'error': '検索条件を入力してください'}), 400
        
        # 毎回新しい接続を作成
        searcher = TMCloudIntegratedSearch(str(DB_PATH))
        
        # デフォルトのlimit設定
        limit = 10000
        
        # 複合検索実行
        results = searcher.search_complex(conditions, operator=operator, limit=limit, unified_format=True)
        
        return jsonify({
            'results': results,
            'count': len(results),
            'search_type': 'complex',
            'conditions': conditions,
            'operator': operator
        })
        
    except Exception as e:
        import traceback
        traceback.print_exc()   # ← 強制的にターミナルへ出す
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    import os
    print(f"データベース: {DB_PATH}")
    print("サーバー起動中...")
    
    # 環境変数から設定を読み込み（本番対応）
    debug = os.environ.get('FLASK_DEBUG', 'True').lower() == 'true'
    host = os.environ.get('FLASK_HOST', '0.0.0.0')  # 全インターフェースでリッスン
    port = int(os.environ.get('FLASK_PORT', '5000'))
    
    print(f"ブラウザで http://{host}:{port} を開いてください")
    app.run(debug=debug, host=host, port=port)
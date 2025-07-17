#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
正しい検索アプローチを使用したHTMLジェネレーター
"""

import argparse
from pathlib import Path
from datetime import datetime
from correct_trademark_search import CorrectTrademarkSearch

class CorrectHTMLGenerator:
    """正しい検索アプローチのHTMLジェネレーター"""
    
    def __init__(self, output_dir: str = "search_results/html"):
        self.output_dir = Path(output_dir)
        self.output_dir.mkdir(parents=True, exist_ok=True)
        self.searcher = CorrectTrademarkSearch()
    
    def generate_html(self, mark_text: str = None, class_num: str = None, limit: int = 100) -> str:
        """HTML検索結果を生成"""
        
        # 正しい検索実行
        if class_num:
            results = self.searcher.search_by_class(class_num, limit)
            search_key = f"区分{class_num}"
            filename = f"class_{class_num}_search_results.html"
        elif mark_text:
            results = self.searcher.search_by_mark_text(mark_text, limit)
            search_key = mark_text
            filename = "correct_trademark_search_results.html"
        else:
            raise ValueError("mark_text または class_num のいずれかが必要です")
        
        # HTML生成
        html_content = self._generate_html_content(search_key, results, class_num is not None)
        
        # ファイル保存
        output_file = self.output_dir / filename
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(html_content)
        
        return str(output_file)
    
    def _generate_html_content(self, search_key: str, results: list, is_class_search: bool = False) -> str:
        """HTML内容を生成"""
        
        current_time = datetime.now().strftime("%Y年%m月%d日 %H:%M:%S")
        search_type = "商標区分" if is_class_search else "商標文字"
        
        html = f"""<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>商標検索結果 - {search_type}: {search_key}</title>
    <style>
        {self._generate_css()}
    </style>
</head>
<body>
    <div class="container">
        <div class="search-header">
            <h1>🔍 商標検索結果</h1>
            <p>TMCloud - 高速商標検索システム</p>
        </div>
        
        <div class="search-conditions">
            <h3>📋 検索条件</h3>
            <p><strong>{search_type}: {search_key}</strong></p>
        </div>
        
        <div class="results-summary">
            <div class="results-count">
                📊 検索結果: <strong>{len(results)}</strong> 件
            </div>
            <div class="generation-time">
                生成日時: {current_time}
            </div>
        </div>
        
        <div class="results-table-wrapper">
            <table class="results-table">
                <thead>
                    <tr>
                        <th class="col-no">No.</th>
                        <th class="col-mark">商標</th>
                        <th class="col-app-num">出願番号</th>
                        <th class="col-reg-num">登録番号</th>
                        <th class="col-app-date">出願日</th>
                        <th class="col-class">区分</th>
                        <th class="col-goods">指定商品・役務</th>
                        <th class="col-similar">類似群コード</th>
                        <th class="col-applicant">出願人</th>
                        <th class="col-rights">権利者</th>
                    </tr>
                </thead>
                <tbody>
"""
        
        # 検索結果の各行を生成
        for i, result in enumerate(results, 1):
            html += self._generate_result_row(i, result)
        
        html += """
                </tbody>
            </table>
        </div>
        
        <div class="footer">
            <p>TMCloud - 商標検索システム</p>
        </div>
    </div>
</body>
</html>"""
        
        return html
    
    def _generate_result_row(self, index: int, result: dict) -> str:
        """検索結果の1行を生成"""
        
        mark_text = result.get('mark_text', '[商標名なし]')
        app_num = result.get('app_num', '')
        reg_num = result.get('reg_num', '')
        app_date = self._format_date_for_display(result.get('shutugan_bi', ''))
        goods_classes = result.get('goods_classes', '調査中')
        designated_goods = result.get('designated_goods', '')
        similar_codes = result.get('similar_group_codes', '')
        applicant = result.get('applicant_name', '')
        rights_holder = result.get('rights_holder', '')
        has_image = result.get('has_image', 'NO')
        
        # 商標の表示（画像優先表示）
        if has_image == 'YES':
            # 画像商標の場合は実際の画像を表示
            image_path = f'../../images/final_complete/{app_num.replace("-", "")}.jpg'
            mark_display = f'<img src="{image_path}" alt="{mark_text}" style="max-width: 200px; max-height: 100px; object-fit: contain;" onerror="this.style.display=\'none\'; this.nextElementSibling.style.display=\'inline\';"><span style="display: none;">🖼️ {mark_text}</span>'
        else:
            mark_display = mark_text
        
        # 区分の表示
        if goods_classes and goods_classes != '調査中':
            class_display = goods_classes
            class_style = ""
        else:
            class_display = "調査中"
            class_style = 'style="color: #dc3545;"'
        
        # 商品・役務の表示
        if designated_goods:
            goods_display = designated_goods[:100] + "..." if len(designated_goods) > 100 else designated_goods
        else:
            goods_display = "なし"
        
        # 類似群コードの表示（半角スペース区切り）
        if similar_codes:
            similar_display = similar_codes[:80] + "..." if len(similar_codes) > 80 else similar_codes
        else:
            similar_display = "なし"
        
        return f"""
                    <tr>
                        <td class="col-no" style="text-align: center; font-weight: 600;">{index}</td>
                        <td class="col-mark">
                            <div class="mark-text">{mark_display}</div>
                        </td>
                        <td class="col-app-num">
                            <span class="app-num">{app_num}</span>
                        </td>
                        <td class="col-reg-num">
                            <span class="reg-num">{reg_num if reg_num else 'なし'}</span>
                        </td>
                        <td class="col-app-date">
                            <div class="date-text">{app_date}</div>
                        </td>
                        <td class="col-class" style="text-align: center;" {class_style}>
                            {class_display}
                        </td>
                        <td class="col-goods">
                            <div class="goods-text">{goods_display}</div>
                        </td>
                        <td class="col-similar">
                            <div class="similar-text">{similar_display}</div>
                        </td>
                        <td class="col-applicant">
                            <div class="applicant-text">{applicant if applicant else 'なし'}</div>
                        </td>
                        <td class="col-rights">
                            <div class="rights-text">{rights_holder if rights_holder else 'なし'}</div>
                        </td>
                    </tr>
        """
    
    def _format_date_for_display(self, date_str: str) -> str:
        """日付の表示形式変換"""
        if not date_str or len(date_str) != 8:
            return date_str if date_str else "未設定"
        
        return f"{date_str[:4]}/{date_str[4:6]}/{date_str[6:8]}"
    
    def _generate_css(self) -> str:
        """CSSスタイルを生成"""
        return """
        * {
            box-sizing: border-box;
        }
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            line-height: 1.5;
            margin: 0;
            padding: 0;
            background-color: #f8f9fa;
            color: #212529;
        }
        
        .container {
            max-width: 1600px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .search-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px 0;
            margin-bottom: 30px;
            border-radius: 12px;
            text-align: center;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
        }
        
        .search-header h1 {
            margin: 0 0 10px 0;
            font-size: 2.5rem;
            font-weight: 600;
        }
        
        .search-conditions {
            background: white;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            border-left: 4px solid #667eea;
        }
        
        .results-summary {
            background: white;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-left: 4px solid #28a745;
        }
        
        .results-count {
            font-size: 1.3rem;
            font-weight: 600;
            color: #28a745;
        }
        
        .generation-time {
            color: #6c757d;
            font-size: 0.9rem;
        }
        
        .results-table-wrapper {
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            margin-bottom: 30px;
            overflow-x: auto;
        }
        
        .results-table {
            width: 100%;
            border-collapse: collapse;
            margin: 0;
            font-size: 0.9rem;
            min-width: 1400px;
        }
        
        .results-table th {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 15px 10px;
            text-align: left;
            font-weight: 600;
            border-bottom: 2px solid #ddd;
            white-space: nowrap;
        }
        
        .results-table td {
            padding: 12px 10px;
            border-bottom: 1px solid #eee;
            vertical-align: top;
        }
        
        .results-table tr:hover {
            background-color: #f8f9fa;
        }
        
        .col-no { width: 50px; }
        .col-mark { width: 220px; }
        .col-app-num { width: 120px; }
        .col-reg-num { width: 120px; }
        .col-app-date { width: 100px; }
        .col-class { width: 80px; }
        .col-goods { width: 320px; }
        .col-similar { width: 180px; }
        .col-applicant { width: 200px; }
        .col-rights { width: 200px; }
        
        .mark-text {
            font-weight: 600;
            color: #495057;
            word-wrap: break-word;
        }
        
        .app-num {
            font-family: monospace;
            color: #6c757d;
            font-size: 0.9rem;
        }
        
        .reg-num {
            font-family: monospace;
            color: #28a745;
            font-weight: 600;
        }
        
        .goods-text {
            font-size: 0.85rem;
            color: #6c757d;
            line-height: 1.4;
        }
        
        .similar-text {
            font-size: 0.8rem;
            color: #6c757d;
            font-family: monospace;
        }
        
        .applicant-text, .rights-text {
            font-size: 0.85rem;
            color: #495057;
        }
        
        .footer {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            text-align: center;
            color: #6c757d;
        }
        
        .footer p {
            margin: 5px 0;
        }
        """

def main():
    parser = argparse.ArgumentParser(description="正しい検索アプローチのHTMLジェネレーター")
    parser.add_argument("--mark-text", help="商標文字")
    parser.add_argument("--class", dest="class_num", help="商標区分")
    parser.add_argument("--limit", type=int, default=100, help="検索結果件数")
    
    args = parser.parse_args()
    
    generator = CorrectHTMLGenerator()
    
    if args.class_num:
        output_file = generator.generate_html(class_num=args.class_num, limit=args.limit)
    elif args.mark_text:
        output_file = generator.generate_html(mark_text=args.mark_text, limit=args.limit)
    else:
        print("商標文字または区分を指定してください:")
        print("  --mark-text '検索文字'")
        print("  --class '区分番号'")
        return
    
    print(f"✅ 正しい検索HTML生成完了: {output_file}")
    print(f"🌐 ブラウザで開くには: file://{Path(output_file).absolute()}")

if __name__ == "__main__":
    main()
#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
モダンテーブル形式商標検索結果HTML生成ツール
TMSONARスタイルの一覧性重視デザイン + 現代的なUI
"""

import json
import argparse
import shutil
from pathlib import Path
from datetime import datetime
from typing import List, Dict, Any
from cli_trademark_search import TrademarkSearchCLI


class ModernDataFormatter:
    """データフォーマット処理クラス"""
    
    @staticmethod
    def format_app_num(app_num: str) -> str:
        """出願番号のフォーマット"""
        if not app_num:
            return "不明"
        
        app_num = str(app_num).strip()
        if len(app_num) >= 12:
            return f"{app_num[:4]}-{app_num[4:10]}"
        return app_num
    
    @staticmethod
    def format_date(date_str: str) -> str:
        """日付のフォーマット"""
        if not date_str or date_str.strip() in ['', '0', 'None']:
            return "未設定"
        
        date_str = str(date_str).strip()
        if len(date_str) == 8 and date_str.isdigit():
            return f"{date_str[:4]}/{date_str[4:6]}/{date_str[6:8]}"
        return date_str
    
    @staticmethod
    def format_similar_codes(codes_str: str, max_display: int = 6) -> str:
        """類似群コードのフォーマット"""
        if not codes_str:
            return "なし"
        
        codes = str(codes_str).split(',')
        codes = [code.strip() for code in codes if code.strip()]
        
        if len(codes) <= max_display:
            return ", ".join(codes)
        else:
            visible_codes = ", ".join(codes[:max_display])
            return f"{visible_codes} +{len(codes)-max_display}個"
    
    @staticmethod
    def format_designated_goods(goods_str: str, max_length: int = 80) -> str:
        """指定商品・役務の省略表示"""
        if not goods_str or goods_str.strip().lower() in ['none', 'null', '']:
            return "なし"
        
        goods_str = str(goods_str).strip()
        if len(goods_str) <= max_length:
            return goods_str
        return goods_str[:max_length] + "..."
    
    @staticmethod
    def format_applicant_name(name_str: str, max_length: int = 30) -> str:
        """出願人・権利者名の省略表示"""
        if not name_str or name_str.strip().lower() in ['none', 'null', '']:
            return "なし"
        
        name_str = str(name_str).strip()
        if len(name_str) <= max_length:
            return name_str
        return name_str[:max_length] + "..."


class ModernSearchResultsHTMLGenerator:
    """モダンテーブル形式HTML生成クラス"""
    
    def __init__(self, output_dir: str = "search_results/html"):
        self.output_dir = Path(output_dir)
        self.output_dir.mkdir(parents=True, exist_ok=True)
        self.searcher = TrademarkSearchCLI()
        self.formatter = ModernDataFormatter()
    
    def generate_modern_css(self) -> str:
        """現代的なCSSスタイル生成"""
        return """
        /* モダンテーブル形式CSS */
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
            max-width: 1400px;
            margin: 0 auto;
            padding: 20px;
        }
        
        /* ヘッダー */
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
        
        .search-conditions h3 {
            margin: 0 0 10px 0;
            color: #495057;
            font-size: 1.1rem;
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
        
        /* テーブル */
        .results-table-wrapper {
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            margin-bottom: 30px;
        }
        
        .results-table {
            width: 100%;
            border-collapse: collapse;
            margin: 0;
            font-size: 0.9rem;
        }
        
        .results-table th {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            color: #495057;
            font-weight: 600;
            padding: 15px 12px;
            text-align: center;
            border-bottom: 2px solid #dee2e6;
            position: sticky;
            top: 0;
            z-index: 10;
            white-space: nowrap;
        }
        
        .results-table td {
            padding: 12px;
            border-bottom: 1px solid #e9ecef;
            vertical-align: top;
        }
        
        .results-table tbody tr {
            transition: all 0.2s ease;
        }
        
        .results-table tbody tr:hover {
            background-color: #f8f9fa;
            transform: scale(1.001);
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        /* カラム幅 */
        .col-no { width: 50px; }
        .col-mark { width: 180px; }
        .col-app-num { width: 120px; }
        .col-reg-num { width: 120px; }
        .col-status { width: 90px; }
        .col-class { width: 80px; }
        .col-goods { width: 250px; }
        .col-similar { width: 150px; }
        .col-applicant { width: 160px; }
        .col-app-date { width: 100px; }
        .col-reg-date { width: 100px; }
        .col-expiry { width: 100px; }
        .col-call { width: 120px; }
        .col-image { width: 80px; }
        .col-trial { width: 100px; }
        
        /* セル内容 */
        .mark-text {
            font-weight: 600;
            color: #495057;
            word-break: break-all;
            line-height: 1.3;
        }
        
        .app-num, .reg-num {
            font-family: 'Monaco', 'Menlo', 'Ubuntu Mono', monospace;
            font-size: 0.85rem;
            background: #f8f9fa;
            padding: 4px 8px;
            border-radius: 4px;
            display: inline-block;
        }
        
        .status-registered {
            background: #d4edda;
            color: #155724;
            padding: 4px 8px;
            border-radius: 15px;
            font-size: 0.8rem;
            font-weight: 600;
            display: inline-block;
        }
        
        .status-pending {
            background: #fff3cd;
            color: #856404;
            padding: 4px 8px;
            border-radius: 15px;
            font-size: 0.8rem;
            font-weight: 600;
            display: inline-block;
        }
        
        .similar-codes {
            display: flex;
            flex-wrap: wrap;
            gap: 4px;
        }
        
        .similar-code {
            background: #e3f2fd;
            color: #1565c0;
            padding: 2px 6px;
            border-radius: 12px;
            font-size: 0.75rem;
            font-weight: 500;
        }
        
        .goods-text {
            line-height: 1.4;
            color: #495057;
        }
        
        .applicant-name {
            color: #6c757d;
            font-size: 0.9rem;
        }
        
        .date-text {
            font-size: 0.85rem;
            color: #6c757d;
        }
        
        .no-results {
            text-align: center;
            padding: 60px 20px;
            color: #6c757d;
            font-size: 1.2rem;
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }
        
        .footer {
            text-align: center;
            padding: 30px 20px;
            color: #6c757d;
            font-size: 0.9rem;
            border-top: 1px solid #e9ecef;
            margin-top: 40px;
        }
        
        /* レスポンシブ */
        @media (max-width: 1200px) {
            .container {
                padding: 15px;
            }
            
            .results-table {
                font-size: 0.8rem;
            }
            
            .results-table th,
            .results-table td {
                padding: 8px 6px;
            }
            
            .col-goods { width: 200px; }
            .col-similar { width: 120px; }
            .col-applicant { width: 150px; }
        }
        
        @media (max-width: 768px) {
            .search-header h1 {
                font-size: 2rem;
            }
            
            .results-summary {
                flex-direction: column;
                text-align: center;
                gap: 10px;
            }
            
            .results-table-wrapper {
                overflow-x: auto;
            }
            
            .results-table {
                min-width: 1800px;  /* 拡張されたテーブル幅 */
            }
        }
        
        /* デスクトップでも横スクロール対応 */
        .results-table-wrapper {
            overflow-x: auto;
        }
        
        .results-table {
            min-width: 1800px;
        }
        """
    
    def build_results_table(self, results: List[Dict[str, Any]]) -> str:
        """結果テーブルのHTML生成"""
        if not results:
            return '<div class="no-results">🔍 該当する商標情報が見つかりませんでした。</div>'
        
        html = """
        <div class="results-table-wrapper">
            <table class="results-table">
                <thead>
                    <tr>
                        <th class="col-no">No.</th>
                        <th class="col-mark">商標</th>
                        <th class="col-app-num">出願番号</th>
                        <th class="col-reg-num">登録番号</th>
                        <th class="col-status">状態</th>
                        <th class="col-class">区分</th>
                        <th class="col-goods">指定商品・役務</th>
                        <th class="col-similar">類似群コード</th>
                        <th class="col-applicant">出願人・権利者</th>
                        <th class="col-app-date">出願日</th>
                        <th class="col-reg-date">登録日</th>
                        <th class="col-expiry">存続期間満了日</th>
                        <th class="col-call">称呼</th>
                        <th class="col-image">画像</th>
                        <th class="col-trial">審判情報</th>
                    </tr>
                </thead>
                <tbody>
        """
        
        for i, result in enumerate(results, 1):
            # データフォーマット
            app_num_formatted = self.formatter.format_app_num(result.get('app_num', ''))
            reg_num = result.get('registration_number') or '未登録'
            app_date = self.formatter.format_date(result.get('app_date', ''))
            reg_date = self.formatter.format_date(result.get('reg_date', ''))
            expiry_date = self.formatter.format_date(result.get('expiry_date', ''))
            
            # ステータス判定
            is_registered = bool(result.get('registration_number'))
            status_class = "status-registered" if is_registered else "status-pending"
            status_text = "登録済み" if is_registered else "出願中"
            
            # 商標文字
            mark_text = result.get('mark_text') or '文字情報なし'
            
            # 商品区分 - Noneの場合は「調査中」と表示
            goods_classes = result.get('goods_classes')
            if goods_classes is None or str(goods_classes).strip() == '':
                goods_classes_display = '<span style="color: #dc3545;">調査中</span>'
            else:
                goods_classes_display = str(goods_classes)
            
            # 指定商品・役務
            designated_goods = self.formatter.format_designated_goods(result.get('designated_goods'))
            
            # 類似群コード
            similar_codes_formatted = self.formatter.format_similar_codes(result.get('similar_group_codes', ''))
            
            # 出願人・権利者
            applicant_name = self.formatter.format_applicant_name(
                result.get('right_person_name') or result.get('applicant_name') or 'なし'
            )
            
            # 称呼
            call_name = result.get('call_name') or 'なし'
            if call_name and len(call_name) > 20:
                call_name = call_name[:20] + "..."
            
            # 画像有無
            has_image = result.get('has_image', 'NO')
            image_display = '🖼️ あり' if has_image == 'YES' else '📄 なし'
            
            # 審判情報
            trial_type = result.get('trial_type')
            trial_display = trial_type if trial_type else 'なし'
            
            html += f"""
                    <tr>
                        <td class="col-no" style="text-align: center; font-weight: 600;">{i}</td>
                        <td class="col-mark">
                            <div class="mark-text">{mark_text}</div>
                        </td>
                        <td class="col-app-num">
                            <span class="app-num">{app_num_formatted}</span>
                        </td>
                        <td class="col-reg-num">
                            <span class="reg-num">{reg_num}</span>
                        </td>
                        <td class="col-status">
                            <span class="{status_class}">{status_text}</span>
                        </td>
                        <td class="col-class" style="text-align: center;">{goods_classes_display}</td>
                        <td class="col-goods">
                            <div class="goods-text">{designated_goods}</div>
                        </td>
                        <td class="col-similar">
                            <div class="similar-codes">
                                {self._format_similar_codes_with_tags(similar_codes_formatted)}
                            </div>
                        </td>
                        <td class="col-applicant">
                            <div class="applicant-name">{applicant_name}</div>
                        </td>
                        <td class="col-app-date">
                            <div class="date-text">{app_date}</div>
                        </td>
                        <td class="col-reg-date">
                            <div class="date-text">{reg_date}</div>
                        </td>
                        <td class="col-expiry">
                            <div class="date-text">{expiry_date}</div>
                        </td>
                        <td class="col-call">
                            <div class="call-text">{call_name}</div>
                        </td>
                        <td class="col-image" style="text-align: center;">
                            <div class="image-text">{image_display}</div>
                        </td>
                        <td class="col-trial">
                            <div class="trial-text">{trial_display}</div>
                        </td>
                    </tr>
            """
        
        html += """
                </tbody>
            </table>
        </div>
        """
        
        return html
    
    def _format_similar_codes_with_tags(self, codes_str: str) -> str:
        """類似群コードをタグ形式でフォーマット"""
        if codes_str == "なし":
            return "なし"
        
        if "+" in codes_str:  # 省略表示の場合
            return codes_str
        
        codes = codes_str.split(", ")
        tags_html = ""
        for code in codes[:6]:  # 最大6個まで表示
            if code.strip():
                tags_html += f'<span class="similar-code">{code.strip()}</span>'
        
        return tags_html
    
    def generate_html(self, search_params: Dict[str, Any], results: List[Dict[str, Any]], 
                     total_count: int) -> str:
        """HTML生成"""
        
        # 検索条件文字列化
        search_conditions = []
        mappings = {
            'app_num': '出願番号',
            'mark_text': '商標文字',
            'goods_classes': '商品区分',
            'designated_goods': '指定商品',
            'similar_group_codes': '類似群コード'
        }
        
        for key, label in mappings.items():
            if search_params.get(key):
                search_conditions.append(f"{label}: {search_params[key]}")
        
        search_condition_text = " / ".join(search_conditions) if search_conditions else "全件検索"
        generation_time = datetime.now().strftime('%Y年%m月%d日 %H:%M:%S')
        
        # 結果テーブルHTML
        results_html = self.build_results_table(results)
        
        html = f"""<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>商標検索結果 - {search_condition_text}</title>
    <style>
        {self.generate_modern_css()}
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
            <p><strong>{search_condition_text}</strong></p>
        </div>
        
        <div class="results-summary">
            <div class="results-count">
                📊 検索結果: <strong>{len(results)}</strong> 件
            </div>
            <div class="generation-time">
                生成日時: {generation_time}
            </div>
        </div>
        
        {results_html}
        
        <div class="footer">
            <p>🤖 TMCloud 商標検索システム | 生成日時: {generation_time}</p>
        </div>
    </div>
</body>
</html>"""
        
        return html
    
    def search_and_generate_html(self, search_params: Dict[str, Any]) -> str:
        """検索実行とHTML生成"""
        results, total_count = self.searcher.search_trademarks(**search_params)
        return self.generate_html(search_params, results, total_count)
    
    def save_html_file(self, html_content: str, filename: str) -> Path:
        """HTMLファイル保存"""
        html_path = self.output_dir / filename
        
        with open(html_path, 'w', encoding='utf-8') as f:
            f.write(html_content)
        
        return html_path


def main():
    """メイン関数"""
    parser = argparse.ArgumentParser(description='モダンテーブル形式商標検索結果HTML生成ツール')
    parser.add_argument('--mark-text', help='商標文字で検索')
    parser.add_argument('--app-num', help='出願番号で検索')
    parser.add_argument('--goods-classes', help='商品区分で検索')
    parser.add_argument('--designated-goods', help='指定商品で検索')
    parser.add_argument('--similar-group-codes', help='類似群コードで検索')
    parser.add_argument('--output', default='modern_trademark_search_results.html', help='出力ファイル名')
    
    args = parser.parse_args()
    
    # 検索パラメータ構築
    search_params = {}
    if args.mark_text:
        search_params['mark_text'] = args.mark_text
    if args.app_num:
        search_params['app_num'] = args.app_num
    if args.goods_classes:
        search_params['goods_classes'] = args.goods_classes
    if args.designated_goods:
        search_params['designated_goods'] = args.designated_goods
    if args.similar_group_codes:
        search_params['similar_group_codes'] = args.similar_group_codes
    
    # HTML生成
    generator = ModernSearchResultsHTMLGenerator()
    
    try:
        html_content = generator.search_and_generate_html(search_params)
        output_path = generator.save_html_file(html_content, args.output)
        
        print(f"✅ モダンHTML生成完了: {output_path}")
        print(f"🌐 ブラウザで開くには: file://{output_path.absolute()}")
        
    except Exception as e:
        print(f"❌ エラー: {e}")
        return 1
    
    return 0


if __name__ == "__main__":
    exit(main())
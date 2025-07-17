#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
リファクタリング版商標検索結果HTML生成ツール
テンプレート分離によりファイルサイズを大幅削減
"""

import json
import argparse
import shutil
from pathlib import Path
from datetime import datetime
from typing import List, Dict, Any
from cli_trademark_search import TrademarkSearchCLI


class SearchConditionFormatter:
    """検索条件のフォーマット処理クラス"""
    
    @staticmethod
    def format_search_conditions(search_params: Dict[str, Any]) -> str:
        """検索条件の文字列化"""
        conditions = []
        
        mappings = {
            'app_num': '出願番号',
            'mark_text': '商標文字',
            'goods_classes': '商品区分',
            'designated_goods': '指定商品',
            'similar_group_codes': '類似群コード'
        }
        
        for key, label in mappings.items():
            if search_params.get(key):
                conditions.append(f"{label}: {search_params[key]}")
        
        return " / ".join(conditions) if conditions else "全件検索"


class DataFormatter:
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
    def format_similar_codes(codes_str: str) -> str:
        """類似群コードのフォーマット"""
        if not codes_str:
            return "なし"
        
        codes = str(codes_str).split(',')
        codes = [code.strip() for code in codes if code.strip()]
        
        if len(codes) <= 8:
            return ", ".join(codes)
        else:
            visible_codes = ", ".join(codes[:8])
            return f"{visible_codes} ... 他{len(codes)-8}個"


class ResultsHTMLBuilder:
    """検索結果HTML構築クラス"""
    
    def __init__(self, formatter: DataFormatter):
        self.formatter = formatter
    
    def build_trademark_card(self, result: Dict[str, Any]) -> str:
        """個別の商標カードHTML生成"""
        app_num_formatted = self.formatter.format_app_num(result.get('app_num', ''))
        app_date_formatted = self.formatter.format_date(result.get('app_date', ''))
        reg_date_formatted = self.formatter.format_date(result.get('reg_date', ''))
        similar_codes_formatted = self.formatter.format_similar_codes(result.get('similar_group_codes', ''))
        
        # ステータス判定
        status_class = "status-registered" if result.get('reg_date') else "status-pending"
        status_text = "登録済み" if result.get('reg_date') else "出願中"
        
        # 画像有無
        has_image = result.get('has_image', 'NO')
        image_class = "image-yes" if has_image == 'YES' else "image-no"
        image_text = "あり" if has_image == 'YES' else "なし"
        
        # 商標文字
        mark_text = result.get('mark_text', '') or '文字情報なし'
        
        return f"""
        <div class="trademark-card">
            <div class="trademark-title">
                🏷️ {mark_text}
                <span class="{status_class}">{status_text}</span>
            </div>
            
            <div class="info-section basic-info">
                <div class="section-header">
                    📋 基本情報
                    <span class="section-toggle">▼</span>
                </div>
                <div class="section-content">
                    <div class="info-item">
                        <span class="info-label">出願番号</span>
                        <span class="info-value app-num">{app_num_formatted}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">登録番号</span>
                        <span class="info-value">{result.get('registration_number', '未登録')}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">商標画像</span>
                        <span class="info-value image-status {image_class}">{image_text}</span>
                    </div>
                </div>
            </div>
            
            <div class="info-section dates-info">
                <div class="section-header">
                    📅 日付情報
                    <span class="section-toggle">▼</span>
                </div>
                <div class="section-content">
                    <div class="info-item">
                        <span class="info-label">出願日</span>
                        <span class="info-value">{app_date_formatted}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">登録日</span>
                        <span class="info-value">{reg_date_formatted}</span>
                    </div>
                </div>
            </div>
            
            <div class="info-section business-info">
                <div class="section-header">
                    🏢 商品・サービス情報
                    <span class="section-toggle">▼</span>
                </div>
                <div class="section-content">
                    <div class="info-item">
                        <span class="info-label">商品区分</span>
                        <span class="info-value">{result.get('goods_classes') or 'なし'}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">類似群コード</span>
                        <span class="info-value">{similar_codes_formatted}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">指定商品・役務</span>
                        <div class="info-value text-expandable">
                            <div class="text-content collapsed">{result.get('designated_goods') or 'なし'}</div>
                            <button class="expand-btn">続きを見る</button>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="info-section additional-info">
                <div class="section-header">
                    ℹ️ 権利者情報
                    <span class="section-toggle">▼</span>
                </div>
                <div class="section-content">
                    <div class="info-item">
                        <span class="info-label">権利者名</span>
                        <span class="info-value">{result.get('right_person_name') or 'なし'}</span>
                    </div>
                    <div class="info-item">
                        <span class="info-label">権利者住所</span>
                        <div class="info-value text-expandable">
                            <div class="text-content collapsed">{result.get('right_person_addr') or 'なし'}</div>
                            <button class="expand-btn">続きを見る</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        """
    
    def build_results_html(self, results: List[Dict[str, Any]]) -> str:
        """全結果のHTML生成"""
        if not results:
            return '<div class="no-results">🔍 該当する商標情報が見つかりませんでした。</div>'
        
        html_parts = []
        for result in results:
            html_parts.append(self.build_trademark_card(result))
        
        return "\n".join(html_parts)


class TemplateEngine:
    """テンプレートエンジンクラス"""
    
    def __init__(self, template_dir: str = "templates"):
        self.template_dir = Path(template_dir)
    
    def load_template(self, template_name: str) -> str:
        """テンプレートファイル読み込み"""
        template_path = self.template_dir / template_name
        if not template_path.exists():
            raise FileNotFoundError(f"Template not found: {template_path}")
        
        with open(template_path, 'r', encoding='utf-8') as f:
            return f.read()
    
    def render_template(self, template_content: str, **kwargs) -> str:
        """テンプレート変数置換"""
        for key, value in kwargs.items():
            placeholder = f"{{{{{key}}}}}"
            template_content = template_content.replace(placeholder, str(value))
        return template_content


class SearchResultsHTMLGenerator:
    """メインHTML生成クラス（簡素化版）"""
    
    def __init__(self, output_dir: str = "search_results/html"):
        self.output_dir = Path(output_dir)
        self.output_dir.mkdir(parents=True, exist_ok=True)
        self.searcher = TrademarkSearchCLI()
        
        # 各種コンポーネント初期化
        self.condition_formatter = SearchConditionFormatter()
        self.data_formatter = DataFormatter()
        self.results_builder = ResultsHTMLBuilder(self.data_formatter)
        self.template_engine = TemplateEngine()
    
    def generate_html(self, search_params: Dict[str, Any], results: List[Dict[str, Any]], 
                     total_count: int) -> str:
        """HTML生成（テンプレート使用）"""
        
        # 検索条件文字列化
        search_condition_text = self.condition_formatter.format_search_conditions(search_params)
        
        # 結果HTML生成
        results_html = self.results_builder.build_results_html(results)
        
        # 結果なしメッセージ
        no_results_message = "" if results else '<div class="no-results">🔍 該当する商標情報が見つかりませんでした。</div>'
        
        # テンプレート読み込みと変数置換
        template_content = self.template_engine.load_template("search_results.html")
        
        html = self.template_engine.render_template(
            template_content,
            search_condition_text=search_condition_text,
            total_count=total_count,
            generation_date=datetime.now().strftime('%Y年%m月%d日 %H:%M:%S'),
            results_html=results_html,
            no_results_message=no_results_message
        )
        
        return html
    
    def search_and_generate_html(self, search_params: Dict[str, Any]) -> str:
        """検索実行とHTML生成"""
        results, total_count = self.searcher.search_trademarks(**search_params)
        return self.generate_html(search_params, results, total_count)
    
    def save_html_file(self, html_content: str, filename: str) -> Path:
        """HTMLファイル保存とCSS複製"""
        html_path = self.output_dir / filename
        
        with open(html_path, 'w', encoding='utf-8') as f:
            f.write(html_content)
        
        # CSSファイルをコピー
        css_source = Path("templates/search_results.css")
        css_dest = self.output_dir / "search_results.css"
        
        if css_source.exists():
            shutil.copy2(css_source, css_dest)
        
        return html_path


def main():
    """メイン関数"""
    parser = argparse.ArgumentParser(description='商標検索結果HTML生成ツール')
    parser.add_argument('--mark-text', help='商標文字で検索')
    parser.add_argument('--app-num', help='出願番号で検索')
    parser.add_argument('--goods-classes', help='商品区分で検索')
    parser.add_argument('--designated-goods', help='指定商品で検索')
    parser.add_argument('--similar-group-codes', help='類似群コードで検索')
    parser.add_argument('--output', default='trademark_search_results.html', help='出力ファイル名')
    
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
    generator = SearchResultsHTMLGenerator()
    
    try:
        html_content = generator.search_and_generate_html(search_params)
        output_path = generator.save_html_file(html_content, args.output)
        
        print(f"✅ HTML生成完了: {output_path}")
        print(f"📁 CSSファイル: {output_path.parent / 'search_results.css'}")
        
    except Exception as e:
        print(f"❌ エラー: {e}")
        return 1
    
    return 0


if __name__ == "__main__":
    exit(main())
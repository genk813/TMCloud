#!/usr/bin/env python3
"""
🎓 TMCloud 簡単サンプルプログラム
～中学生でも分かる検索プログラム～

このプログラムを実行すると、簡単な商標検索を体験できます。
実行方法: python3 sample_for_beginners.py
"""

import sqlite3
import os

# カラフルな出力のための設定
class Colors:
    """色付き文字を出力するためのクラス"""
    BLUE = '\033[94m'
    GREEN = '\033[92m'
    YELLOW = '\033[93m'
    RED = '\033[91m'
    END = '\033[0m'
    BOLD = '\033[1m'

def print_title():
    """タイトルを表示する関数"""
    print(Colors.BOLD + Colors.BLUE + """
    ╔════════════════════════════════════╗
    ║   🔍 TMCloud 検索システム 🔍      ║
    ║     ～かんたん体験版～            ║
    ╔════════════════════════════════════╗
    """ + Colors.END)

def print_menu():
    """メニューを表示する関数"""
    print(Colors.GREEN + """
    何をしたいですか？
    1. 商標名で検索 📝
    2. 読み方で検索 🔊
    3. データベースの中身を見る 📊
    4. 終了 👋
    """ + Colors.END)

class SimpleSearcher:
    """簡単な検索クラス"""
    
    def __init__(self, db_path):
        """
        初期化メソッド（準備をする関数）
        db_path: データベースファイルのパス
        """
        # データベースが存在するか確認
        if os.path.exists(db_path):
            self.conn = sqlite3.connect(db_path)
            print(Colors.GREEN + f"✅ データベースに接続しました: {db_path}" + Colors.END)
        else:
            print(Colors.RED + f"❌ データベースが見つかりません: {db_path}" + Colors.END)
            self.conn = None
    
    def search_by_name(self, keyword):
        """
        商標名で検索する関数
        keyword: 検索したいキーワード
        """
        if not self.conn:
            print(Colors.RED + "データベースに接続されていません" + Colors.END)
            return []
        
        print(Colors.YELLOW + f"\n🔍 「{keyword}」を検索中..." + Colors.END)
        
        try:
            # SQLクエリ（データベースへの質問）を作成
            query = """
                SELECT 
                    ts.app_num as 出願番号,
                    ts.search_use_t as 商標名,
                    tci.app_date as 出願日
                FROM trademark_search ts
                LEFT JOIN trademark_case_info tci ON ts.app_num = tci.app_num
                WHERE ts.search_use_t_norm LIKE ?
                LIMIT 5
            """
            
            # データベースに質問する
            cursor = self.conn.cursor()
            pattern = f"%{keyword}%"  # 部分一致で検索
            cursor.execute(query, (pattern,))
            
            # 結果を取得
            results = cursor.fetchall()
            
            return results
            
        except Exception as e:
            print(Colors.RED + f"エラーが発生しました: {e}" + Colors.END)
            return []
    
    def search_by_phonetic(self, keyword):
        """
        読み方（称呼）で検索する関数
        keyword: カタカナの読み方
        """
        if not self.conn:
            print(Colors.RED + "データベースに接続されていません" + Colors.END)
            return []
        
        print(Colors.YELLOW + f"\n🔍 「{keyword}」の読み方で検索中..." + Colors.END)
        
        try:
            query = """
                SELECT 
                    tp.app_num as 出願番号,
                    tp.phonetic as 読み方,
                    tci.app_date as 出願日
                FROM trademark_phonetics tp
                LEFT JOIN trademark_case_info tci ON tp.app_num = tci.app_num
                WHERE tp.phonetic LIKE ?
                LIMIT 5
            """
            
            cursor = self.conn.cursor()
            pattern = f"%{keyword}%"
            cursor.execute(query, (pattern,))
            
            results = cursor.fetchall()
            
            return results
            
        except Exception as e:
            print(Colors.RED + f"エラーが発生しました: {e}" + Colors.END)
            return []
    
    def show_database_info(self):
        """データベースの情報を表示する関数"""
        if not self.conn:
            print(Colors.RED + "データベースに接続されていません" + Colors.END)
            return
        
        print(Colors.BLUE + "\n📊 データベースの中身：" + Colors.END)
        
        try:
            cursor = self.conn.cursor()
            
            # テーブル一覧を取得
            cursor.execute("SELECT name FROM sqlite_master WHERE type='table'")
            tables = cursor.fetchall()
            
            print(f"\nテーブル数: {len(tables)}個")
            print("\n主なテーブル:")
            
            # 主要なテーブルの件数を表示
            main_tables = [
                ('trademark_case_info', '商標基本情報'),
                ('trademark_search', '商標検索用'),
                ('trademark_phonetics', '商標の読み方'),
                ('trademark_applicants_agents', '出願人・代理人')
            ]
            
            for table_name, description in main_tables:
                try:
                    cursor.execute(f"SELECT COUNT(*) FROM {table_name}")
                    count = cursor.fetchone()[0]
                    print(f"  • {description} ({table_name}): {count:,}件")
                except:
                    print(f"  • {description} ({table_name}): テーブルなし")
            
        except Exception as e:
            print(Colors.RED + f"エラーが発生しました: {e}" + Colors.END)

def display_results(results, result_type="商標"):
    """
    検索結果を表示する関数
    results: 検索結果のリスト
    result_type: 結果の種類
    """
    if not results:
        print(Colors.YELLOW + "\n検索結果はありませんでした 😢" + Colors.END)
    else:
        print(Colors.GREEN + f"\n✨ {len(results)}件見つかりました！\n" + Colors.END)
        
        for i, result in enumerate(results, 1):
            print(f"--- {i}件目 ---")
            if result_type == "商標":
                print(f"出願番号: {result[0]}")
                print(f"商標名: {result[1] if result[1] else '(名前なし)'}")
                print(f"出願日: {format_date(result[2]) if result[2] else '不明'}")
            elif result_type == "称呼":
                print(f"出願番号: {result[0]}")
                print(f"読み方: {result[1] if result[1] else '(読み方なし)'}")
                print(f"出願日: {format_date(result[2]) if result[2] else '不明'}")
            print()

def format_date(date_str):
    """
    日付を見やすい形式に変換する関数
    例: 20250725 → 2025年7月25日
    """
    if not date_str or len(date_str) != 8:
        return date_str
    
    try:
        year = date_str[:4]
        month = date_str[4:6]
        day = date_str[6:8]
        return f"{year}年{int(month)}月{int(day)}日"
    except:
        return date_str

def main():
    """メインの処理"""
    print_title()
    
    # データベースファイルのパスを設定
    db_paths = [
        "../tmcloud_v2_20250818_081655.db",  # 親フォルダのデータベース
        "../tmcloud_v2_20250810_restored.db",  # 親フォルダの別のデータベース
        "/mnt/c/Users/ygenk/Desktop/TMCloud/tmcloud_v2_20250818_081655.db",
        "tmcloud_v2_20250818_081655.db",
        "tmcloud_v2.db"
    ]
    
    # 使用可能なデータベースを探す
    db_path = None
    for path in db_paths:
        if os.path.exists(path):
            db_path = path
            break
    
    if not db_path:
        print(Colors.RED + """
        ⚠️ データベースファイルが見つかりません。
        TMCloudのデータベースファイルが必要です。
        """ + Colors.END)
        return
    
    # 検索システムを初期化
    searcher = SimpleSearcher(db_path)
    
    # メインループ
    while True:
        print_menu()
        
        try:
            choice = input(Colors.BOLD + "番号を入力してください: " + Colors.END)
            
            if choice == "1":
                # 商標名検索
                keyword = input(Colors.BLUE + "検索したい商標名を入力: " + Colors.END)
                if keyword:
                    results = searcher.search_by_name(keyword)
                    display_results(results, "商標")
                
            elif choice == "2":
                # 称呼検索
                keyword = input(Colors.BLUE + "検索したい読み方（カタカナ）を入力: " + Colors.END)
                if keyword:
                    results = searcher.search_by_phonetic(keyword)
                    display_results(results, "称呼")
                
            elif choice == "3":
                # データベース情報表示
                searcher.show_database_info()
                
            elif choice == "4":
                # 終了
                print(Colors.GREEN + "\n👋 またね！プログラミングがんばって！\n" + Colors.END)
                break
                
            else:
                print(Colors.YELLOW + "1〜4の番号を入力してください" + Colors.END)
        
        except KeyboardInterrupt:
            # Ctrl+Cで終了
            print(Colors.GREEN + "\n\n👋 終了します！\n" + Colors.END)
            break
        except Exception as e:
            print(Colors.RED + f"エラー: {e}" + Colors.END)
    
    # データベース接続を閉じる
    if searcher.conn:
        searcher.conn.close()

# プログラムのスタート地点
if __name__ == "__main__":
    """
    このプログラムが直接実行されたときだけ main() を実行する
    他のプログラムから読み込まれたときは実行しない
    """
    main()
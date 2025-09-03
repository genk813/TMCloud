# 🐍 Python基礎 - TMCloudで使われている部分だけ！

## 📚 目次
1. [変数とデータ型](#1-変数とデータ型)
2. [文字列の操作](#2-文字列の操作)
3. [リストと辞書](#3-リストと辞書)
4. [条件分岐（if文）](#4-条件分岐)
5. [ループ（繰り返し）](#5-ループ)
6. [関数](#6-関数)
7. [クラス](#7-クラス)
8. [エラー処理](#8-エラー処理)
9. [ファイル操作](#9-ファイル操作)
10. [ライブラリの使用](#10-ライブラリ)

---

## 1. 変数とデータ型 📦

### 変数 = データを入れる箱

```python
# TMCloudでの実例
app_num = "2025064118"        # 文字列型（str）
year = 2025                    # 整数型（int）
is_madrid = False              # ブール型（bool）
reg_rate = 0.85               # 浮動小数点型（float）
```

### 図解：変数の仕組み
```
メモリ（コンピュータの記憶場所）
┌─────────────────────────────────┐
│ app_num → [2025064118]          │
│ year    → [2025]                │
│ is_madrid → [False]             │
└─────────────────────────────────┘
```

### TMCloudでの使用例
```python
# tmcloud_search_integrated.pyより
def search_by_app_num(self, app_num: str):
    # app_numという変数に出願番号を格納
    app_num = app_num.replace('-', '').replace('－', '')
    #         ↑変数を上書き（ハイフンを削除）
```

---

## 2. 文字列の操作 ✂️

### よく使う文字列メソッド

```python
# TMCloudで実際に使われている操作

# 1. 文字列の切り出し（スライス）
app_num = "2025364118"
year = app_num[:4]      # "2025" （最初の4文字）
type_code = app_num[4:6] # "36" （5-6文字目）

# 2. 文字列の置換
keyword = "国際登録第1858710号"
clean = keyword.replace("国際登録第", "").replace("号", "")
# 結果: "1858710"

# 3. 文字列の結合
first = "TMCloud"
version = "2.0"
full_name = f"{first} バージョン {version}"
# 結果: "TMCloud バージョン 2.0"

# 4. 大文字小文字の変換
search_term = "Apple"
normalized = search_term.upper()  # "APPLE"
```

### 図解：文字列のインデックス
```
文字列: "2025364118"
インデックス:
 0  1  2  3  4  5  6  7  8  9
[2][0][2][5][3][6][4][1][1][8]
 ↑        ↑  ↑  ↑
年(4文字) タイプ(2文字)
```

### TMCloudでの実例
```python
# 国際登録番号の正規化処理
def normalize_intl_reg_num(self, intl_reg_num):
    import re
    # 数字以外を全て削除
    return re.sub(r'\D', '', str(intl_reg_num or ''))
    #            ↑正規表現で「数字でない文字」を削除
```

---

## 3. リストと辞書 📋

### リスト = 順番付きの箱

```python
# TMCloudでの使用例
phonetics = ["プル", "プルーフ", "プール"]
#            0番目   1番目      2番目

# リストの操作
phonetics.append("プルトップ")  # 追加
first = phonetics[0]            # 取得: "プル"
count = len(phonetics)          # 長さ: 4
```

### 辞書 = ラベル付きの箱

```python
# TMCloudでの商標情報
trademark = {
    "app_num": "2025064118",
    "name": "プルーフ",
    "app_date": "20250725",
    "classes": ["03", "05"]
}

# 辞書の操作
name = trademark["name"]           # 取得: "プルーフ"
trademark["status"] = "登録済"      # 追加/更新
keys = trademark.keys()            # キー一覧
```

### 図解：リストと辞書の違い
```
リスト（順番が重要）          辞書（名前で管理）
┌────┬────┬────┐        ┌─────────────────┐
│ 0  │ 1  │ 2  │        │ app_num: 2025... │
├────┼────┼────┤        │ name: プルーフ    │
│プル │プール│... │        │ date: 2025/7/25  │
└────┴────┴────┘        └─────────────────┘
```

### TMCloudでの実例
```python
# 検索結果の整形
result = {
    "app_num": row[0],
    "trademark_name": row[1] or "[商標画像]",
    "phonetics": self._get_phonetics(row[0]),
    "classes": self._get_classes(row[0])
}
```

---

## 4. 条件分岐（if文）🚦

### 基本構造
```python
if 条件:
    # 条件が真のとき実行
elif 別の条件:
    # 別の条件が真のとき実行
else:
    # どの条件も偽のとき実行
```

### TMCloudでの実例
```python
# 商標タイプの判定
def get_trademark_type(app_num):
    type_code = app_num[4:6]
    
    if type_code in ["35", "36", "37"]:
        return "国際登録（マドプロ）"
    elif type_code == "00":
        return "通常出願"
    else:
        return "その他"
```

### 図解：条件分岐の流れ
```
        [出願番号]
            ↓
    [5-6桁目を確認]
            ↓
        35,36,37?
        ／    ＼
      Yes      No
      ／        ＼
[国際登録]    [国内出願]
```

### よく使う条件演算子
```python
# TMCloudで使われている条件
if keyword == "":           # 空文字チェック
if len(results) > 0:        # リストに要素があるか
if "プル" in trademark_name: # 文字列に含まれるか
if not is_valid:            # 否定（〜でない）
if a and b:                 # 両方真
if a or b:                  # どちらか真
```

---

## 5. ループ（繰り返し）🔄

### for文 - 決まった回数の繰り返し

```python
# TMCloudでの実例：検索結果の表示
results = ["商標A", "商標B", "商標C"]

for trademark in results:
    print(f"- {trademark}")
    
# 出力:
# - 商標A
# - 商標B
# - 商標C
```

### while文 - 条件が真の間繰り返し

```python
# TMCloudでの実例：メニューループ
while True:
    choice = input("選択してください: ")
    
    if choice == "1":
        search()
    elif choice == "q":
        break  # ループを抜ける
```

### 図解：ループの流れ
```
for文の処理:
[リスト] → [1個目] → 処理 → [2個目] → 処理 → ... → [終了]

while文の処理:
[条件チェック] → True → 処理 → [条件チェック] → True → ...
                ↑                              ↓
                └──────── False ←──────────────┘
```

### TMCloudでの実例（データベース結果処理）
```python
# 複数の結果を処理
cursor.execute(query)
for row in cursor.fetchall():
    app_num = row[0]
    name = row[1]
    # 各行を辞書に変換
    result = {
        "app_num": app_num,
        "name": name
    }
    results.append(result)
```

---

## 6. 関数 🔧

### 関数 = 再利用可能な処理のまとまり

```python
# 基本構造
def 関数名(引数1, 引数2):
    """関数の説明"""
    # 処理
    return 結果
```

### TMCloudでの実例
```python
def format_date(date_str):
    """
    日付を見やすい形式に変換
    例: "20250725" → "2025年7月25日"
    """
    if not date_str or len(date_str) != 8:
        return date_str
    
    year = date_str[:4]
    month = date_str[4:6]
    day = date_str[6:8]
    
    return f"{year}年{int(month)}月{int(day)}日"

# 使用例
formatted = format_date("20250725")
print(formatted)  # "2025年7月25日"
```

### 図解：関数の入出力
```
     入力（引数）
         ↓
    "20250725"
         ↓
   ┌─────────────┐
   │ format_date │
   │   関数      │
   └─────────────┘
         ↓
  "2025年7月25日"
         ↓
    出力（戻り値）
```

### デフォルト引数
```python
# TMCloudでの実例
def search_trademark(keyword, limit=100, unified_format=True):
    # limit と unified_format はデフォルト値がある
    pass

# 使い方
search_trademark("プル")           # limit=100, unified_format=True
search_trademark("プル", 10)       # limit=10, unified_format=True
search_trademark("プル", 10, False) # limit=10, unified_format=False
```

---

## 7. クラス 🏗️

### クラス = データと機能をまとめた設計図

```python
# TMCloudの検索クラス（簡略版）
class TMCloudSearch:
    def __init__(self, db_path):
        """初期化メソッド（コンストラクタ）"""
        self.db_path = db_path
        self.conn = None
        self.connect()
    
    def connect(self):
        """データベースに接続"""
        self.conn = sqlite3.connect(self.db_path)
    
    def search(self, keyword):
        """検索メソッド"""
        query = f"SELECT * FROM trademarks WHERE name LIKE '%{keyword}%'"
        cursor = self.conn.cursor()
        cursor.execute(query)
        return cursor.fetchall()

# 使い方
searcher = TMCloudSearch("database.db")  # インスタンス作成
results = searcher.search("プル")         # メソッド呼び出し
```

### 図解：クラスとインスタンス
```
[クラス（設計図）]           [インスタンス（実体）]
┌──────────────┐           ┌──────────────┐
│ TMCloudSearch│  作成→    │ searcher     │
├──────────────┤           ├──────────────┤
│ - db_path    │           │ db_path="..." │
│ - conn       │           │ conn=<接続>   │
├──────────────┤           ├──────────────┤
│ + connect()  │           │ 実際に動く    │
│ + search()   │           │ メソッド      │
└──────────────┘           └──────────────┘
```

### self の意味
```python
class Example:
    def __init__(self):
        self.value = 10  # 自分の変数
    
    def show(self):
        print(self.value)  # 自分の変数を使う

# self は「そのインスタンス自身」を指す
obj = Example()
obj.show()  # 10 が表示される
```

---

## 8. エラー処理 🚨

### try-except文

```python
# TMCloudでの実例
def connect_database(path):
    try:
        # エラーが起きるかもしれない処理
        conn = sqlite3.connect(path)
        print("✅ 接続成功")
        return conn
    
    except FileNotFoundError:
        # ファイルが見つからない場合
        print("❌ データベースファイルが見つかりません")
        return None
    
    except Exception as e:
        # その他のエラー
        print(f"❌ エラー: {e}")
        return None
    
    finally:
        # 必ず実行される
        print("接続処理終了")
```

### 図解：エラー処理の流れ
```
     [通常の処理]
         ↓
    エラー発生？
    ／        ＼
  No           Yes
  ↓             ↓
[続行]      [except節]
  ↓             ↓
  └─────┬───────┘
        ↓
    [finally節]
        ↓
    [処理続行]
```

### よくあるエラーと対処
```python
# TMCloudで起きやすいエラー

# 1. キーエラー（辞書に存在しないキー）
try:
    value = data["missing_key"]
except KeyError:
    value = "デフォルト値"

# 2. インデックスエラー（リスト範囲外）
try:
    item = my_list[10]
except IndexError:
    item = None

# 3. 型エラー（型の不一致）
try:
    result = "文字" + 123  # エラー！
except TypeError:
    result = "文字" + str(123)  # OK
```

---

## 9. ファイル操作 📁

### ファイルの読み書き

```python
# TMCloudでの設定ファイル読み込み例

# ファイルを読む
with open("config.txt", "r", encoding="utf-8") as f:
    content = f.read()
    # with文を使うと自動的にファイルが閉じられる

# ファイルに書く
with open("results.txt", "w", encoding="utf-8") as f:
    f.write("検索結果\n")
    f.write("1. プルーフ\n")

# JSONファイルの読み書き
import json

# 読み込み
with open("data.json", "r") as f:
    data = json.load(f)

# 書き込み
with open("output.json", "w") as f:
    json.dump(data, f, ensure_ascii=False, indent=2)
```

### パスの操作
```python
import os

# TMCloudでのパス操作
db_path = "tmcloud_v2.db"

# ファイルの存在確認
if os.path.exists(db_path):
    print("データベースあり")

# ディレクトリの作成
os.makedirs("backup", exist_ok=True)

# パスの結合
full_path = os.path.join("data", "trademarks", "2025.csv")
```

---

## 10. ライブラリの使用 📚

### import文

```python
# TMCloudで使われているライブラリ

# 標準ライブラリ
import sqlite3      # データベース操作
import re          # 正規表現
import json        # JSON処理
import os          # ファイル・パス操作
from datetime import datetime  # 日時処理

# 外部ライブラリ
from flask import Flask, request, jsonify  # Webサーバー
```

### ライブラリの使い方
```python
# sqlite3の例（データベース操作）
import sqlite3

conn = sqlite3.connect("database.db")
cursor = conn.cursor()
cursor.execute("SELECT * FROM table")
results = cursor.fetchall()
conn.close()

# reの例（正規表現）
import re

# 数字以外を削除
clean = re.sub(r'\D', '', "国際登録第123号")
# 結果: "123"

# datetimeの例
from datetime import datetime

now = datetime.now()
formatted = now.strftime("%Y年%m月%d日")
```

---

## 🎯 TMCloudでよく使うパターン

### 1. データベース検索パターン
```python
def search_pattern(keyword):
    conn = sqlite3.connect("db.db")
    cursor = conn.cursor()
    
    query = "SELECT * FROM table WHERE column LIKE ?"
    cursor.execute(query, (f"%{keyword}%",))
    
    results = []
    for row in cursor.fetchall():
        results.append({
            "id": row[0],
            "name": row[1]
        })
    
    conn.close()
    return results
```

### 2. エラーハンドリングパターン
```python
def safe_operation():
    try:
        # 危険な操作
        result = dangerous_operation()
        return {"success": True, "data": result}
    except Exception as e:
        return {"success": False, "error": str(e)}
```

### 3. 設定読み込みパターン
```python
def load_config():
    default_config = {
        "database": "tmcloud.db",
        "limit": 100
    }
    
    try:
        with open("config.json", "r") as f:
            config = json.load(f)
            return {**default_config, **config}
    except FileNotFoundError:
        return default_config
```

---

## 📝 練習問題

### 問題1: 変数と文字列
```python
# 出願番号から情報を抽出する関数を作ってください
def analyze_app_num(app_num):
    # ヒント: スライスを使う
    year = ___
    type_code = ___
    
    if type_code in ["35", "36", "37"]:
        type_name = "国際登録"
    else:
        type_name = "国内出願"
    
    return {
        "year": year,
        "type": type_name
    }
```

### 問題2: リストと辞書
```python
# 商標リストから特定の条件のものを抽出
trademarks = [
    {"name": "プルーフ", "year": 2025},
    {"name": "アップル", "year": 2024},
    {"name": "プルトップ", "year": 2025}
]

# "プル"を含む2025年の商標だけ抽出する関数
def filter_trademarks(trademarks):
    result = []
    # ここにコードを書く
    return result
```

<details>
<summary>答え</summary>

問題1:
```python
def analyze_app_num(app_num):
    year = app_num[:4]
    type_code = app_num[4:6]
    
    if type_code in ["35", "36", "37"]:
        type_name = "国際登録"
    else:
        type_name = "国内出願"
    
    return {
        "year": year,
        "type": type_name
    }
```

問題2:
```python
def filter_trademarks(trademarks):
    result = []
    for tm in trademarks:
        if "プル" in tm["name"] and tm["year"] == 2025:
            result.append(tm)
    return result
```
</details>

---

## 🚀 次のステップ

このPython基礎を理解したら、次は：
1. SQL基礎（データベース操作）
2. HTML/CSS基礎（Web画面作成）
3. 実際のTMCloudコードを読んで理解を深める

プログラミングは**実践が大切**です。
小さなコードから始めて、徐々に大きなプログラムを作っていきましょう！
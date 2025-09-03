# 🎯 TMCloud 練習問題集
～実践で学ぶプログラミング～

## レベル1: 基礎理解 🔰

### 問題1-1: プログラムの流れ
次のコードを実行したとき、何が表示されますか？

```python
name = "TMCloud"
version = 2.0
print(f"{name} バージョン {version}")
```

<details>
<summary>答えを見る</summary>

**答え:** `TMCloud バージョン 2.0`

**解説:**
- `name`という変数に"TMCloud"を入れる
- `version`という変数に2.0を入れる
- f文字列で変数を埋め込んで表示
</details>

---

### 問題1-2: 条件分岐
このコードの空欄に何を入れればよいでしょうか？

```python
keyword = "プル"
if len(keyword) ___ 2:
    print("短い検索語です")
else:
    print("通常の検索語です")
# 結果: "通常の検索語です"と表示したい
```

<details>
<summary>答えを見る</summary>

**答え:** `>`

**解説:**
- `len(keyword)`は文字数を数える（"プル"は2文字）
- 2文字より多い（>2）なら「通常」と表示したい
- "プル"は2文字なので、`2 > 2`は偽（False）
- よって`else`の部分が実行される
</details>

---

### 問題1-3: リスト操作
検索結果が以下のリストで返ってきました。3番目の要素を取得するには？

```python
results = ["アップル", "グーグル", "プルーフ", "サンプル"]
third_item = results[___]
print(third_item)  # "プルーフ"と表示したい
```

<details>
<summary>答えを見る</summary>

**答え:** `2`

**解説:**
- リストのインデックスは0から始まる
- 1番目 = results[0] = "アップル"
- 2番目 = results[1] = "グーグル"  
- 3番目 = results[2] = "プルーフ"
</details>

---

## レベル2: 関数を作ろう 🔧

### 問題2-1: 簡単な関数
出願番号から年を取り出す関数を完成させてください。

```python
def get_year(app_num):
    """
    出願番号から年を取り出す
    例: "2025064118" → "2025"
    """
    # ここにコードを書く
    return ___

# テスト
print(get_year("2025064118"))  # "2025"と表示される
```

<details>
<summary>答えを見る</summary>

**答え:**
```python
def get_year(app_num):
    return app_num[:4]
```

**解説:**
- 文字列のスライス`[:4]`で最初の4文字を取得
- "2025064118"の最初の4文字は"2025"
</details>

---

### 問題2-2: 条件付き関数
商標の種類を判定する関数を作ってください。

```python
def get_trademark_type(app_num):
    """
    出願番号の5-6桁目で種類を判定
    35, 36, 37 → "国際登録"
    それ以外 → "国内出願"
    """
    type_code = app_num[___:___]
    if type_code in ["35", "36", "37"]:
        return ___
    else:
        return ___

# テスト
print(get_trademark_type("2025364118"))  # "国際登録"
print(get_trademark_type("2025064118"))  # "国内出願"
```

<details>
<summary>答えを見る</summary>

**答え:**
```python
def get_trademark_type(app_num):
    type_code = app_num[4:6]
    if type_code in ["35", "36", "37"]:
        return "国際登録"
    else:
        return "国内出願"
```

**解説:**
- `app_num[4:6]`で5-6文字目を取得（インデックスは0から）
- inを使ってリスト内に含まれるか確認
</details>

---

## レベル3: データベース操作 💾

### 問題3-1: SQL文の理解
次のSQL文は何を検索していますか？

```sql
SELECT app_num, trademark_name 
FROM trademark_case_info 
WHERE app_date >= '20250701' 
AND app_date <= '20250731'
ORDER BY app_date DESC
LIMIT 10
```

<details>
<summary>答えを見る</summary>

**答え:** 
2025年7月中に出願された商標を、出願日の新しい順に10件取得

**解説:**
- `WHERE app_date >= '20250701' AND app_date <= '20250731'`
  → 7月1日から7月31日の間
- `ORDER BY app_date DESC`
  → 出願日の降順（新しい順）
- `LIMIT 10`
  → 最初の10件だけ
</details>

---

### 問題3-2: SQL文を書く
「プル」を含む商標名を持つ、2025年の出願を検索するSQL文を書いてください。

```sql
SELECT * FROM trademark_search
WHERE _______________
AND _______________
```

<details>
<summary>答えを見る</summary>

**答え:**
```sql
SELECT * FROM trademark_search
WHERE search_use_t_norm LIKE '%プル%'
AND app_num LIKE '2025%'
```

**解説:**
- `LIKE '%プル%'`で部分一致検索
- `app_num LIKE '2025%'`で2025で始まる番号
</details>

---

## レベル4: エラー対処 🚨

### 問題4-1: エラーの原因
このコードを実行するとエラーが出ます。なぜでしょう？

```python
results = ["商標A", "商標B", "商標C"]
for i in range(1, 4):
    print(f"{i}. {results[i]}")
```

<details>
<summary>答えを見る</summary>

**答え:** 
リストのインデックスが範囲外（IndexError）

**解説:**
- リストは3要素（インデックス0,1,2）
- range(1,4)は1,2,3を生成
- results[3]は存在しないのでエラー

**修正版:**
```python
for i in range(len(results)):
    print(f"{i+1}. {results[i]}")
```
</details>

---

### 問題4-2: エラー処理
データベース接続でエラーが起きても止まらないようにしてください。

```python
def connect_database(path):
    # ここにtry-except文を追加
    conn = sqlite3.connect(path)
    return conn
```

<details>
<summary>答えを見る</summary>

**答え:**
```python
def connect_database(path):
    try:
        conn = sqlite3.connect(path)
        print("接続成功")
        return conn
    except Exception as e:
        print(f"接続失敗: {e}")
        return None
```

**解説:**
- tryブロックで危険な処理を実行
- エラーが起きたらexceptブロックが実行される
- Noneを返して、呼び出し元で対処できるようにする
</details>

---

## レベル5: 実践プロジェクト 🚀

### プロジェクト: ミニ検索システムを作ろう

以下の仕様を満たす簡単な検索プログラムを作ってください。

**仕様:**
1. 商標データを辞書のリストで管理
2. キーワード検索機能
3. 結果の表示機能

**スターターコード:**
```python
# データ（本来はデータベースから取得）
trademarks = [
    {"id": "2025001", "name": "スーパープル", "date": "2025-01-01"},
    {"id": "2025002", "name": "プルトップ", "date": "2025-01-02"},
    {"id": "2025003", "name": "アップル", "date": "2025-01-03"},
]

def search_trademark(keyword):
    """キーワードで商標を検索する"""
    # ここにコードを書く
    pass

def display_results(results):
    """検索結果を表示する"""
    # ここにコードを書く
    pass

# メイン処理
keyword = input("検索キーワード: ")
results = search_trademark(keyword)
display_results(results)
```

<details>
<summary>解答例を見る</summary>

```python
# データ
trademarks = [
    {"id": "2025001", "name": "スーパープル", "date": "2025-01-01"},
    {"id": "2025002", "name": "プルトップ", "date": "2025-01-02"},
    {"id": "2025003", "name": "アップル", "date": "2025-01-03"},
]

def search_trademark(keyword):
    """キーワードで商標を検索する"""
    results = []
    for tm in trademarks:
        if keyword.lower() in tm["name"].lower():
            results.append(tm)
    return results

def display_results(results):
    """検索結果を表示する"""
    if not results:
        print("検索結果はありません")
    else:
        print(f"\n{len(results)}件見つかりました！\n")
        for i, tm in enumerate(results, 1):
            print(f"{i}. {tm['name']}")
            print(f"   ID: {tm['id']}")
            print(f"   日付: {tm['date']}\n")

# メイン処理
keyword = input("検索キーワード: ")
results = search_trademark(keyword)
display_results(results)
```

**発展課題:**
1. 大文字小文字を区別しない検索
2. 複数キーワードのAND/OR検索
3. 日付範囲での絞り込み
4. 結果のソート機能
</details>

---

## 🎓 学習のヒント

### デバッグのコツ
```python
# print文を使って変数の中身を確認
def mystery_function(x):
    print(f"入力: {x}")  # デバッグ用
    result = x * 2
    print(f"結果: {result}")  # デバッグ用
    return result
```

### コードを読むコツ
1. **関数名から推測** - `search_by_name`は名前で検索
2. **変数名から推測** - `app_num`は出願番号
3. **コメントを読む** - `# 商標名で検索`
4. **実行して確認** - 実際に動かしてみる

### エラーと友達になる
```
よくあるエラーと対処法:

NameError: name 'x' is not defined
→ 変数xが定義されていない。スペルミスかも？

TypeError: unsupported operand type
→ 型が違う。数字と文字を混ぜてない？

IndentationError: unexpected indent
→ インデント（字下げ）がおかしい

SyntaxError: invalid syntax
→ 文法エラー。カッコや引用符を確認
```

---

## 🏆 チャレンジ問題

### 上級問題: 検索履歴機能
検索履歴を保存して表示する機能を追加してください。

**ヒント:**
- リストに履歴を保存
- ファイルに書き込んで永続化
- 日時も記録

### 超上級問題: Web API作成
Flask（フラスク）を使って、検索結果をJSON形式で返すWeb APIを作ってください。

**ヒント:**
```python
from flask import Flask, jsonify, request
app = Flask(__name__)

@app.route('/search')
def search():
    keyword = request.args.get('keyword')
    # 検索処理
    return jsonify(results)
```

---

## 📚 さらに学ぶために

### おすすめの学習順序
1. **Python基礎** (1ヶ月)
   - 変数、条件分岐、ループ
   - 関数、クラス
   
2. **データベース** (2週間)
   - SQL基礎
   - テーブル設計
   
3. **Web開発** (1ヶ月)
   - HTML/CSS
   - Flask or Django
   
4. **実践プロジェクト** (継続)
   - 自分のアイデアを形に

### 無料で学べるサイト
- [Progate](https://prog-8.com/) - プログラミング基礎
- [paizaラーニング](https://paiza.jp/works) - 動画で学習
- [ドットインストール](https://dotinstall.com/) - 3分動画
- [Qiita](https://qiita.com/) - 技術記事

---

🌟 **がんばって！プログラミングは楽しい！**

質問があれば、コードと一緒にエラーメッセージを見せてください。
一緒に解決方法を考えましょう！
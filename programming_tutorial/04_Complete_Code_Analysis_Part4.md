# 🔬 TMCloud完全コード解説 Part 4 - Webインターフェース前編
～FlaskによるWebアプリケーションの構築～

## 📚 Part 4の内容

tmcloud_simple_web.pyの前半部分を解説します。FlaskフレームワークによるWebサーバーの構築と、HTML/CSS/JavaScriptによるユーザーインターフェースの実装を詳しく見ていきます。

---

## 1. ファイルヘッダーとインポート（1-12行目）

```python
#!/usr/bin/env python3
"""
TMCloud 簡易Webインターフェース
将来のFlask Webサービスへの第一歩
"""

from flask import Flask, render_template_string, request, jsonify
from tmcloud_search_integrated import TMCloudIntegratedSearch
from pathlib import Path
import json
import sys

app = Flask(__name__)
```

#### 詳細解説：

**7行目：Flaskのインポート**
```python
from flask import Flask, render_template_string, request, jsonify
```
- `Flask`：Webアプリケーションの本体クラス
- `render_template_string`：文字列からHTMLを生成
- `request`：HTTPリクエストのデータを取得
- `jsonify`：PythonオブジェクトをJSONレスポンスに変換

**8行目：検索エンジンのインポート**
```python
from tmcloud_search_integrated import TMCloudIntegratedSearch
```
- Part 1-3で解説した検索エンジン本体を使用

**13行目：Flaskアプリケーションの作成**
```python
app = Flask(__name__)
```
- `__name__`：現在のモジュール名（`__main__`または`tmcloud_simple_web`）
- Flaskはこれを使って静的ファイルの場所などを決定

---

## 2. データベースパスの設定（15-16行目）

```python
# データベースパス（変更可能）
DB_PATH = Path(__file__).parent / "tmcloud_v2_20250818_081655.db"
```

#### 詳細解説：

**Pathオブジェクトの使用：**
- `__file__`：現在のPythonファイルのパス
- `.parent`：親ディレクトリ
- `/`演算子：パスの結合（os.path.joinより直感的）

**例：**
```python
# __file__ = "/home/user/TMCloud/tmcloud_simple_web.py"
# __file__.parent = "/home/user/TMCloud"
# DB_PATH = "/home/user/TMCloud/tmcloud_v2_20250818_081655.db"
```

---

## 3. HTMLテンプレート - ヘッド部分（18-51行目）

### DOCTYPE とメタ情報（19-24行目）

```python
HTML_TEMPLATE = """
<!DOCTYPE html>
<html>
<head>
    <title>TMCloud 商標検索</title>
    <meta charset="utf-8">
```

#### 詳細解説：

**19行目：トリプルクォート文字列**
- Pythonで複数行の文字列を定義
- HTMLコード全体を1つの文字列として保持

**20行目：`<!DOCTYPE html>`**
- HTML5の宣言
- ブラウザにHTML5として解釈するよう指示

**24行目：`<meta charset="utf-8">`**
- 文字エンコーディングをUTF-8に指定
- 日本語を正しく表示するために必須

### CSSスタイル定義（25-50行目）

```python
    <style>
        body { font-family: sans-serif; margin: 20px; }
        .search-box { margin: 20px 0; padding: 20px; background: #f0f0f0; border-radius: 8px; }
        input[type="text"] { width: 300px; padding: 5px; }
        button { padding: 5px 15px; cursor: pointer; }
        button:hover { opacity: 0.9; }
        .result { border: 1px solid #ddd; margin: 10px 0; padding: 10px; border-radius: 4px; }
        .result h3 { margin: 0 0 10px 0; color: #333; }
        .field { margin: 5px 0; }
        .field-label { font-weight: bold; display: inline-block; width: 140px; vertical-align: top; }
        .field-value { display: inline-block; margin-left: 140px; }
        .goods-services { 
            margin-left: 140px; 
            padding-left: 55px;  /* 「区分XX: 」の幅 */
            text-indent: -55px;  /* 最初の行だけ左に戻す */
        }
        .similar-codes { 
            margin-left: 140px;
            padding-left: 55px;  /* 「区分XX: 」の幅 */
            text-indent: -55px;  /* 最初の行だけ左に戻す */
        }
        .intermediate-records { margin-left: 140px; }
        #searchConditions { max-height: 400px; overflow-y: auto; }
        .condition-item { transition: all 0.3s ease; }
        .condition-item:hover { background: #e8f4f8 !important; }
    </style>
```

#### 詳細解説：

**26行目：基本スタイル**
```css
body { font-family: sans-serif; margin: 20px; }
```
- `sans-serif`：ゴシック体フォント（読みやすい）
- `margin: 20px`：ページ全体に20pxの余白

**30行目：ホバー効果**
```css
button:hover { opacity: 0.9; }
```
- マウスを載せたときにボタンが少し透明になる
- ユーザビリティの向上

**36-40行目：特殊なインデント処理**
```css
.goods-services { 
    margin-left: 140px;      /* ラベル分の余白 */
    padding-left: 55px;      /* 「区分XX: 」の幅 */
    text-indent: -55px;      /* 最初の行だけ左に戻す */
}
```
- 複数行テキストの2行目以降をインデント
- 「区分01: 化学品、接着剤、...」のような表示を整形

**48-49行目：アニメーション効果**
```css
.condition-item { transition: all 0.3s ease; }
.condition-item:hover { background: #e8f4f8 !important; }
```
- `transition`：スムーズな変化（0.3秒）
- ホバー時に背景色が変わる

---

## 4. HTMLボディ - 検索フォーム（52-77行目）

```html
<body>
    <h1>TMCloud 商標検索システム</h1>
    
    <!-- 統合検索フォーム -->
    <div class="search-box">
        <h2 style="margin-top: 0;">商標検索</h2>
        <form id="complexSearchForm">
            <div id="operatorSection" style="margin-bottom: 10px; display: none;">
                <label>演算子:
                    <select id="globalOperator">
                        <option value="AND">すべての条件を満たす（AND）</option>
                        <option value="OR">いずれかの条件を満たす（OR）</option>
                    </select>
                </label>
            </div>
            <div id="searchConditions">
                <!-- 動的に条件が追加される -->
            </div>
            <div style="margin-top: 10px;">
                <button type="button" onclick="addCondition()" style="background: #28a745; color: white; padding: 5px 10px;">+ 条件を追加</button>
                <button type="submit" style="margin-left: 10px;">検索実行</button>
            </div>
        </form>
    </div>
    
    <div id="results"></div>
```

#### 詳細解説：

**58行目：フォーム要素**
```html
<form id="complexSearchForm">
```
- `id`属性でJavaScriptから参照可能
- submitイベントで検索を実行

**59-65行目：AND/OR演算子選択**
```html
<div id="operatorSection" style="margin-bottom: 10px; display: none;">
```
- 初期状態では非表示（`display: none`）
- 条件が2つ以上になると表示される

**67-69行目：動的コンテンツエリア**
```html
<div id="searchConditions">
    <!-- 動的に条件が追加される -->
</div>
```
- JavaScriptで検索条件のUIを動的に追加

**71行目：条件追加ボタン**
```html
<button type="button" onclick="addCondition()" style="background: #28a745; color: white;">
```
- `type="button"`：フォーム送信しない普通のボタン
- `onclick`：クリック時にJavaScript関数を呼ぶ
- `#28a745`：緑色（Bootstrapの成功色）

---

## 5. JavaScript - 基本設定（79-111行目）

### XSS対策とユーティリティ（80-81行目）

```javascript
// XSS対策用のエスケープ関数
const esc = (s) => String(s).replace(/[&<>"']/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;', "'":'&#39;'}[c]));
```

#### 詳細解説：

**XSS（クロスサイトスクリプティング）対策：**
- ユーザー入力をHTMLに表示する際の必須処理
- 特殊文字をHTMLエンティティに変換

**エスケープ処理の詳細：**
```javascript
String(s)                    // 文字列に変換
.replace(/[&<>"']/g, c =>   // 特殊文字を置換
    ({
        '&': '&amp;',        // アンパサンド
        '<': '&lt;',         // 小なり
        '>': '&gt;',         // 大なり
        '"': '&quot;',       // ダブルクォート
        "'": '&#39;'         // シングルクォート
    }[c])
)
```

**使用例：**
```javascript
esc("<script>alert('XSS')</script>")
// 結果: "&lt;script&gt;alert(&#39;XSS&#39;)&lt;/script&gt;"
// これはHTMLとして安全に表示される
```

### ヘルパー表示制御（83-103行目）

```javascript
// 拒絶条文コードヘルパーの表示/非表示切り替え
function toggleRejectionCodeHelper(selectElement) {
    const conditionDiv = selectElement.closest('.condition-item');
    const rejectionHelper = conditionDiv.querySelector('.rejection-code-helper');
    const typeHelper = conditionDiv.querySelector('.trademark-type-helper');
    
    // すべてのヘルパーを非表示
    if (rejectionHelper) rejectionHelper.style.display = 'none';
    if (typeHelper) typeHelper.style.display = 'none';
    
    // 選択されたタイプに応じてヘルパーを表示
    if (selectElement.value === 'rejection_reason') {
        if (rejectionHelper) {
            rejectionHelper.style.display = 'block';
        }
    } else if (selectElement.value === 'trademark_type') {
        if (typeHelper) {
            typeHelper.style.display = 'block';
        }
    }
}
```

#### 詳細解説：

**85行目：DOM要素の検索**
```javascript
const conditionDiv = selectElement.closest('.condition-item');
```
- `closest()`：親要素を上方向に検索
- 最も近い`.condition-item`クラスの要素を取得

**86-87行目：子要素の検索**
```javascript
const rejectionHelper = conditionDiv.querySelector('.rejection-code-helper');
```
- `querySelector()`：CSS セレクタで要素を検索
- 最初にマッチした要素を返す

**94-102行目：条件分岐による表示制御**
- 検索タイプに応じて適切なヘルプを表示
- 拒絶理由検索なら拒絶コードのヘルプ
- 商標タイプ検索ならタイプ一覧のヘルプ

### グローバル変数（105-110行目）

```javascript
// 条件のカウンター
let conditionCount = 0;

// 現在の検索結果を保持
let currentSearchResults = null;
let originalSearchResults = null;  // ソート前のオリジナルデータを保持
```

#### 詳細解説：

**条件管理：**
- `conditionCount`：追加された検索条件の数を管理
- 各条件に一意のIDを付けるために使用

**検索結果の保持：**
- `currentSearchResults`：現在表示中の検索結果
- `originalSearchResults`：ソート前の元データ
- ソート機能で元に戻せるように保持

---

## 6. 検索タイプの定義（112-127行目）

```javascript
// 検索タイプのオプション
const searchTypes = [
    {value: 'trademark', label: '商標名'},
    {value: 'phonetic', label: '称呼（発音同一）'},
    {value: 'phonetic_exact', label: '称呼（表記同一）'},
    {value: 'trademark_type', label: '商標タイプ'},
    {value: 'app_num', label: '出願番号'},
    {value: 'reg_num', label: '登録番号'},
    {value: 'intl_reg_num', label: '国際登録番号'},
    {value: 'class', label: '区分'},
    {value: 'applicant', label: '出願人'},
    {value: 'similar_group', label: '類似群コード'},
    {value: 'goods_services', label: '商品・役務'},
    {value: 'rejection_reason', label: '拒絶条文コード'},
    {value: 'vienna_code', label: 'ウィーンコード'}
];
```

#### 詳細解説：

**オブジェクトの配列：**
- 各検索タイプを`{value, label}`のオブジェクトで定義
- `value`：サーバーに送信される値
- `label`：ユーザーに表示される日本語ラベル

**検索タイプの種類：**
1. **基本検索**：商標名、称呼
2. **番号検索**：出願番号、登録番号、国際登録番号
3. **分類検索**：区分、類似群コード、ウィーンコード
4. **関係者検索**：出願人
5. **内容検索**：商品・役務、拒絶条文

---

## 7. 条件追加関数の開始（129-150行目）

```javascript
// 条件を追加する関数
function addCondition() {
    conditionCount++;
    const container = document.getElementById('searchConditions');
    const condDiv = document.createElement('div');
    condDiv.id = `condition_${conditionCount}`;
    condDiv.className = 'condition-item';
    condDiv.style.marginBottom = '10px';
    condDiv.style.padding = '10px';
    condDiv.style.background = '#f8f9fa';
    condDiv.style.border = '1px solid #dee2e6';
    condDiv.style.borderRadius = '4px';
    
    let optionsHtml = searchTypes.map(t => 
        `<option value="${t.value}">${t.label}</option>`
    ).join('');
    
    // 条件が2つ以上になったら演算子セレクタを表示
    const conditionElements = container.getElementsByClassName('condition-item');
    if (conditionElements.length >= 1) {
        document.getElementById('operatorSection').style.display = 'block';
    }
```

#### 詳細解説：

**131行目：カウンターのインクリメント**
```javascript
conditionCount++;
```
- 新しい条件のための一意のIDを生成

**133-141行目：DOM要素の作成とスタイリング**
```javascript
const condDiv = document.createElement('div');
condDiv.id = `condition_${conditionCount}`;      // 例: "condition_1"
condDiv.className = 'condition-item';
```
- 新しいdiv要素を作成
- テンプレートリテラルで動的なIDを生成

**142-144行目：オプションHTMLの生成**
```javascript
let optionsHtml = searchTypes.map(t => 
    `<option value="${t.value}">${t.label}</option>`
).join('');
```
- `map()`：配列の各要素を変換
- テンプレートリテラルでHTMLを生成
- `join('')`：配列を文字列に結合

**147-150行目：演算子セクションの表示制御**
```javascript
if (conditionElements.length >= 1) {
    document.getElementById('operatorSection').style.display = 'block';
}
```
- 既存の条件が1つ以上あれば、AND/OR選択を表示
- 2つ目の条件追加時に演算子が必要になる

---

## まとめ：Part 4で学んだこと

### 🎯 Webアプリケーションの基礎

1. **Flaskフレームワーク**
   - 軽量なPython Webフレームワーク
   - ルーティングとテンプレート

2. **HTML/CSS/JavaScript統合**
   - Pythonの文字列としてHTMLを定義
   - インラインCSSでスタイリング
   - 動的なUIの構築

3. **セキュリティ対策**
   - XSS対策のエスケープ処理
   - 安全なHTML生成

### 💡 プログラミングテクニック

- **DOM操作**：`createElement`, `querySelector`
- **配列のmap/join**：効率的なHTML生成
- **テンプレートリテラル**：動的な文字列生成
- **スタイルの動的変更**：表示/非表示の制御

### 🔍 UIデザインのポイント

- **段階的な複雑性**：最初はシンプル、必要に応じて複雑に
- **視覚的フィードバック**：ホバー効果、アニメーション
- **ヘルパー機能**：ユーザーを支援する追加情報

---

## 次のPart 5では

- 条件追加関数の続き
- 検索実行処理
- サーバーサイドのルーティング
- 検索結果の表示処理

を詳しく解説します。
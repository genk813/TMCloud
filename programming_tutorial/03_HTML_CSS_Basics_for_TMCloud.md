# 🎨 HTML/CSS基礎 - TMCloudのWeb画面を理解しよう！

## 📚 目次
1. [HTMLとは？Webページの骨組み](#1-htmlとは)
2. [HTML基本タグ](#2-html基本タグ)
3. [フォームと入力](#3-フォームと入力)
4. [CSSとは？見た目の装飾](#4-cssとは)
5. [CSSセレクタ](#5-cssセレクタ)
6. [レイアウト](#6-レイアウト)
7. [TMCloudのHTML構造](#7-tmcloudのhtml構造)
8. [JavaScriptとの連携](#8-javascriptとの連携)
9. [レスポンシブデザイン](#9-レスポンシブデザイン)
10. [実践演習](#10-実践演習)

---

## 1. HTMLとは？Webページの骨組み 🏗️

### HTML = HyperText Markup Language
ウェブページの**構造**を作る言語

```html
<!DOCTYPE html>
<html>
    <head>
        <title>ページのタイトル</title>
    </head>
    <body>
        <h1>見出し</h1>
        <p>段落の文章</p>
    </body>
</html>
```

### 図解：HTMLの構造
```
┌─────────────────────────────┐
│         <html>              │ ← ページ全体
│  ┌─────────────────────┐    │
│  │      <head>         │    │ ← ページ情報（見えない）
│  │  タイトルやCSS      │    │
│  └─────────────────────┘    │
│  ┌─────────────────────┐    │
│  │      <body>         │    │ ← ページ内容（見える）
│  │  実際の内容         │    │
│  └─────────────────────┘    │
└─────────────────────────────┘
```

### TMCloudでの基本構造
```html
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>TMCloud商標検索システム</title>
    <style>
        /* CSSスタイル */
    </style>
</head>
<body>
    <h1>🔍 TMCloud検索</h1>
    <form>
        <!-- 検索フォーム -->
    </form>
    <div id="results">
        <!-- 検索結果 -->
    </div>
</body>
</html>
```

---

## 2. HTML基本タグ 🏷️

### よく使うタグ一覧

```html
<!-- 見出し（h1が一番大きい） -->
<h1>大見出し</h1>
<h2>中見出し</h2>
<h3>小見出し</h3>

<!-- 段落 -->
<p>これは段落です。</p>

<!-- リンク -->
<a href="https://www.j-platpat.inpit.go.jp">J-PlatPatへ</a>

<!-- 画像 -->
<img src="logo.png" alt="ロゴ画像">

<!-- リスト -->
<ul>  <!-- 番号なしリスト -->
    <li>項目1</li>
    <li>項目2</li>
</ul>

<ol>  <!-- 番号付きリスト -->
    <li>手順1</li>
    <li>手順2</li>
</ol>

<!-- 表 -->
<table>
    <tr>
        <th>出願番号</th>
        <th>商標名</th>
    </tr>
    <tr>
        <td>2025064118</td>
        <td>プルーフ</td>
    </tr>
</table>

<!-- 区切り線 -->
<hr>

<!-- 改行 -->
<br>

<!-- 強調 -->
<strong>重要</strong>
<em>強調</em>
```

### TMCloudでの使用例
```html
<div class="search-result">
    <h3>検索結果: 166件</h3>
    <div class="result-item">
        <strong>商標名:</strong> プルーフ<br>
        <strong>出願番号:</strong> 2025064118<br>
        <strong>出願日:</strong> 2025年7月25日<br>
        <a href="#" onclick="openJPlatPat('2025064118')">
            J-PlatPatで確認
        </a>
    </div>
</div>
```

### 図解：タグの入れ子構造
```
<div>                    ← 親要素
    <h3>タイトル</h3>    ← 子要素
    <p>                  ← 子要素
        <strong>         ← 孫要素
            重要
        </strong>
        な内容
    </p>
</div>
```

---

## 3. フォームと入力 📝

### TMCloudの検索フォーム

```html
<form id="searchForm" onsubmit="performSearch(event)">
    <!-- 検索タイプ選択 -->
    <select name="search_type" id="searchType">
        <option value="trademark">商標名</option>
        <option value="phonetic">称呼（読み方）</option>
        <option value="app_num">出願番号</option>
        <option value="applicant">出願人</option>
    </select>
    
    <!-- 検索キーワード入力 -->
    <input type="text" 
           name="keyword" 
           id="keyword"
           placeholder="検索キーワードを入力">
    
    <!-- 件数制限 -->
    <input type="number" 
           name="limit" 
           value="100"
           min="1" 
           max="1000">
    
    <!-- 送信ボタン -->
    <button type="submit">🔍 検索</button>
</form>
```

### 入力タイプ一覧
```html
<!-- テキスト -->
<input type="text" placeholder="名前">

<!-- パスワード -->
<input type="password">

<!-- 数値 -->
<input type="number" min="0" max="100">

<!-- 日付 -->
<input type="date">

<!-- チェックボックス -->
<input type="checkbox" id="agree">
<label for="agree">同意する</label>

<!-- ラジオボタン -->
<input type="radio" name="type" value="1">国内
<input type="radio" name="type" value="2">国際

<!-- テキストエリア -->
<textarea rows="5" cols="30"></textarea>
```

---

## 4. CSSとは？見た目の装飾 🎨

### CSS = Cascading Style Sheets
HTMLの**見た目**を整える言語

### 3つの書き方

```html
<!-- 1. インライン（直接書く） -->
<p style="color: red;">赤い文字</p>

<!-- 2. 内部スタイル（headタグ内） -->
<head>
    <style>
        p { color: blue; }
    </style>
</head>

<!-- 3. 外部ファイル -->
<head>
    <link rel="stylesheet" href="style.css">
</head>
```

### TMCloudのCSS例
```css
/* 基本スタイル */
body {
    font-family: 'Helvetica Neue', Arial, sans-serif;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    margin: 0;
    padding: 20px;
}

/* コンテナ */
.container {
    max-width: 1200px;
    margin: 0 auto;
    background: rgba(255, 255, 255, 0.95);
    border-radius: 20px;
    padding: 30px;
    box-shadow: 0 20px 60px rgba(0,0,0,0.3);
}

/* 見出し */
h1 {
    color: #4a5568;
    text-align: center;
    margin-bottom: 30px;
}

/* ボタン */
button {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    border: none;
    padding: 12px 30px;
    border-radius: 50px;
    font-size: 16px;
    cursor: pointer;
    transition: transform 0.2s;
}

button:hover {
    transform: translateY(-2px);
}
```

### 図解：CSSの適用
```
HTMLタグ → CSSセレクタ → スタイル適用
<p>      → p { }       → 色、サイズなど変更

優先順位:
インライン > ID > クラス > タグ
style=""   #id  .class   p
```

---

## 5. CSSセレクタ 🎯

### セレクタの種類

```css
/* タグセレクタ */
p {
    color: black;
}

/* クラスセレクタ（.） */
.highlight {
    background-color: yellow;
}

/* IDセレクタ（#） */
#header {
    background-color: blue;
}

/* 子要素セレクタ */
.container p {
    margin: 10px;
}

/* 直接の子要素 */
.container > p {
    font-weight: bold;
}

/* 属性セレクタ */
input[type="text"] {
    border: 1px solid gray;
}

/* 疑似クラス */
a:hover {
    color: red;
}

button:active {
    background-color: darkblue;
}

/* n番目の要素 */
li:nth-child(2) {
    color: green;
}
```

### TMCloudでの実例
```css
/* 検索結果のスタイル */
.search-result {
    border: 1px solid #e2e8f0;
    border-radius: 8px;
    padding: 15px;
    margin-bottom: 15px;
    transition: all 0.3s;
}

.search-result:hover {
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    transform: translateY(-2px);
}

/* 拒絶理由の強調 */
.rejection-reason {
    background-color: #fff5f5;
    border-left: 4px solid #fc8181;
    padding: 10px;
    margin: 10px 0;
}
```

---

## 6. レイアウト 📐

### Flexbox - 柔軟な配置

```css
/* TMCloudの検索フォーム */
.search-container {
    display: flex;
    gap: 10px;
    align-items: center;
}

.search-container input {
    flex: 1;  /* 残りの幅を使う */
}

/* 横並び */
.row {
    display: flex;
    justify-content: space-between;
}

/* 縦並び */
.column {
    display: flex;
    flex-direction: column;
}

/* 中央揃え */
.center {
    display: flex;
    justify-content: center;
    align-items: center;
}
```

### Grid - 格子状レイアウト

```css
/* 検索結果のグリッド表示 */
.results-grid {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
    gap: 20px;
}

.result-card {
    border: 1px solid #ccc;
    padding: 15px;
    border-radius: 8px;
}
```

### 図解：Flexboxの配置
```
justify-content（横方向）:
├─ flex-start   [■■■      ]
├─ center       [   ■■■   ]
├─ flex-end     [      ■■■]
├─ space-between[■   ■   ■]
└─ space-around [ ■  ■  ■ ]

align-items（縦方向）:
├─ flex-start   ■ ← 上
├─ center       ■ ← 中央
└─ flex-end     ■ ← 下
```

---

## 7. TMCloudのHTML構造 🏢

### 実際のTMCloud HTMLテンプレート

```html
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TMCloud商標検索システム</title>
    <style>
        /* スタイル定義 */
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Helvetica Neue', Arial, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
        }
        
        .search-section {
            background: white;
            padding: 25px;
            border-radius: 15px;
            margin-bottom: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .search-form {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
            align-items: flex-end;
        }
        
        .form-group {
            display: flex;
            flex-direction: column;
            gap: 5px;
        }
        
        label {
            font-size: 12px;
            color: #718096;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        select, input {
            padding: 12px 15px;
            border: 2px solid #e2e8f0;
            border-radius: 10px;
            font-size: 14px;
            transition: all 0.3s;
        }
        
        button {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            padding: 12px 30px;
            border-radius: 50px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        button:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.4);
        }
        
        .results {
            background: white;
            padding: 25px;
            border-radius: 15px;
            min-height: 200px;
        }
        
        .result-item {
            background: #f7fafc;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 15px;
            border-left: 4px solid #667eea;
            transition: all 0.3s;
        }
        
        .result-item:hover {
            transform: translateX(5px);
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🔍 TMCloud商標検索システム</h1>
        
        <div class="search-section">
            <form class="search-form" onsubmit="performSearch(event)">
                <div class="form-group">
                    <label>検索タイプ</label>
                    <select id="searchType">
                        <option value="trademark">商標名</option>
                        <option value="phonetic">称呼</option>
                        <option value="app_num">出願番号</option>
                    </select>
                </div>
                
                <div class="form-group" style="flex: 1;">
                    <label>検索キーワード</label>
                    <input type="text" id="keyword" 
                           placeholder="検索キーワードを入力">
                </div>
                
                <div class="form-group">
                    <label>表示件数</label>
                    <input type="number" id="limit" 
                           value="100" min="1" max="1000">
                </div>
                
                <button type="submit">🔍 検索</button>
            </form>
        </div>
        
        <div class="results" id="results">
            <!-- 検索結果がここに表示される -->
        </div>
    </div>
    
    <script>
        // JavaScript処理
        function performSearch(event) {
            event.preventDefault();
            // 検索処理
        }
    </script>
</body>
</html>
```

---

## 8. JavaScriptとの連携 ⚡

### HTMLとJavaScriptの接続

```html
<!-- イベント処理 -->
<button onclick="alert('クリックされました')">クリック</button>

<!-- フォーム送信 -->
<form onsubmit="handleSubmit(event)">
    <input type="text" id="searchInput">
    <button type="submit">検索</button>
</form>

<script>
function handleSubmit(event) {
    event.preventDefault();  // デフォルト動作を防ぐ
    
    // 入力値を取得
    const keyword = document.getElementById('searchInput').value;
    
    // 結果を表示
    document.getElementById('results').innerHTML = 
        `<p>「${keyword}」で検索中...</p>`;
}
</script>
```

### TMCloudでの実例
```javascript
async function performSearch(event) {
    event.preventDefault();
    
    // フォームデータ取得
    const searchType = document.getElementById('searchType').value;
    const keyword = document.getElementById('keyword').value;
    const limit = document.getElementById('limit').value;
    
    // APIリクエスト
    const response = await fetch('/search', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            search_type: searchType,
            keyword: keyword,
            limit: parseInt(limit)
        })
    });
    
    const data = await response.json();
    
    // 結果表示
    displayResults(data);
}

function displayResults(data) {
    const resultsDiv = document.getElementById('results');
    
    if (data.count === 0) {
        resultsDiv.innerHTML = '<p>検索結果がありません</p>';
        return;
    }
    
    let html = `<h3>検索結果: ${data.count}件</h3>`;
    
    data.results.forEach(item => {
        html += `
            <div class="result-item">
                <strong>商標名:</strong> ${item.trademark_name}<br>
                <strong>出願番号:</strong> ${item.app_num}<br>
                <strong>出願日:</strong> ${formatDate(item.app_date)}
            </div>
        `;
    });
    
    resultsDiv.innerHTML = html;
}
```

---

## 9. レスポンシブデザイン 📱

### 画面サイズに対応

```css
/* TMCloudのレスポンシブCSS */

/* モバイル（基本） */
.container {
    width: 100%;
    padding: 10px;
}

/* タブレット（768px以上） */
@media (min-width: 768px) {
    .container {
        width: 750px;
        padding: 20px;
    }
    
    .search-form {
        flex-direction: row;
    }
}

/* デスクトップ（1024px以上） */
@media (min-width: 1024px) {
    .container {
        width: 1000px;
        padding: 30px;
    }
    
    .results-grid {
        grid-template-columns: repeat(3, 1fr);
    }
}
```

### viewport設定
```html
<meta name="viewport" content="width=device-width, initial-scale=1.0">
```

### 図解：レスポンシブデザイン
```
スマホ (375px)     タブレット (768px)    PC (1920px)
┌──────┐          ┌────────────┐      ┌──────────────────┐
│      │          │            │      │                  │
│  縦  │          │    中間    │      │      横長        │
│  長  │          │            │      │                  │
└──────┘          └────────────┘      └──────────────────┘
```

---

## 10. 実践演習 💻

### 演習1: 簡単な検索画面を作る

```html
<!DOCTYPE html>
<html lang="ja">
<head>
    <meta charset="UTF-8">
    <title>商標検索</title>
    <style>
        /* ここにCSSを書く */
        body {
            font-family: sans-serif;
            padding: 20px;
        }
        
        .search-box {
            /* 演習: 検索ボックスのスタイルを追加 */
        }
        
        .result {
            /* 演習: 結果のスタイルを追加 */
        }
    </style>
</head>
<body>
    <h1>商標検索システム</h1>
    
    <!-- 演習: 検索フォームを作成 -->
    <div class="search-box">
        <!-- ここにフォームを追加 -->
    </div>
    
    <!-- 演習: 結果表示エリアを作成 -->
    <div id="results">
        <!-- ここに結果が表示される -->
    </div>
    
    <script>
        // 演習: 検索機能を実装
        function search() {
            // ここにJavaScriptを書く
        }
    </script>
</body>
</html>
```

### 演習2: TMCloudスタイルのボタン

```css
/* グラデーションボタンを作ってみよう */
.tm-button {
    /* 演習: 以下のスタイルを完成させる */
    background: linear-gradient(_____, _____, _____);
    color: _____;
    border: _____;
    padding: _____ _____;
    border-radius: _____;
    cursor: _____;
    transition: _____;
}

.tm-button:hover {
    /* 演習: ホバー時の効果を追加 */
}
```

<details>
<summary>答え</summary>

演習1の答え:
```html
<div class="search-box">
    <form onsubmit="search(event)">
        <input type="text" id="keyword" placeholder="検索キーワード">
        <button type="submit">検索</button>
    </form>
</div>

<script>
function search(event) {
    event.preventDefault();
    const keyword = document.getElementById('keyword').value;
    document.getElementById('results').innerHTML = 
        `<div class="result">「${keyword}」の検索結果</div>`;
}
</script>
```

演習2の答え:
```css
.tm-button {
    background: linear-gradient(135deg, #667eea, #764ba2);
    color: white;
    border: none;
    padding: 12px 24px;
    border-radius: 25px;
    cursor: pointer;
    transition: all 0.3s;
}

.tm-button:hover {
    transform: translateY(-2px);
    box-shadow: 0 5px 15px rgba(0,0,0,0.2);
}
```
</details>

---

## 🎓 学習のポイント

### HTML/CSSマスターへの道

1. **構造と見た目を分離**
   - HTML = 構造
   - CSS = デザイン
   - JavaScript = 動作

2. **セマンティックHTML**
   - 意味のあるタグを使う
   - `<header>`, `<nav>`, `<main>`, `<footer>`

3. **CSSの優先順位を理解**
   - インライン > ID > クラス > タグ
   - !important は最後の手段

4. **デベロッパーツールを使う**
   - F12キーで開く
   - 要素の検証
   - スタイルの確認と編集

### よくある間違い

```html
<!-- ❌ 間違い：閉じタグ忘れ -->
<div>
    <p>テキスト
</div>

<!-- ✅ 正解 -->
<div>
    <p>テキスト</p>
</div>
```

```css
/* ❌ 間違い：セミコロン忘れ */
.class {
    color: red
    font-size: 16px;
}

/* ✅ 正解 */
.class {
    color: red;
    font-size: 16px;
}
```

---

## 🚀 次のステップ

HTML/CSSの基礎を理解したら：

1. **JavaScript深掘り** - 動的な機能を追加
2. **フレームワーク** - React, Vue.jsなど
3. **サーバーサイド** - Flask, Djangoとの連携
4. **モダンCSS** - CSS Grid, Flexbox, アニメーション

Webデザインは**創造性と技術の融合**です。
楽しみながら、美しく使いやすいインターフェースを作りましょう！
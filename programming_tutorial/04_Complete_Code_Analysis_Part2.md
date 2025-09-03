# 🔬 TMCloud完全コード解説 Part 2 - 正規化メソッドの実装
～テキスト処理の核心部分を完全理解～

## 📚 Part 2の内容

Part 1で学んだ変換テーブルを使って、実際の正規化処理を行うメソッドを詳しく解説します。

---

## 7. 会社種別定義（105-110行目）

```python
    # 会社種別（type-102でのみ除去）
    COMPANY_TYPES = [
        '株式会社', '有限会社', '合名会社', '合資会社', '合同会社', '保険相互会社',
        'カブシキガイシャ', 'ユウゲンガイシャ', 'ゴウメイガイシャ', 
        'ゴウシガイシャ', 'ゴウドウガイシャ', 'ホケンソウゴガイシャ'
    ]
```

#### 詳細解説：

**106-110行目：日本の会社形態リスト**

日本の法人形態を網羅：
- **株式会社**：最も一般的な会社形態
- **有限会社**：2006年以降新設不可だが既存のものは存続
- **合名会社**：無限責任社員のみ
- **合資会社**：有限責任社員と無限責任社員
- **合同会社**：LLCとも呼ばれる
- **保険相互会社**：保険業特有の形態

**カタカナ表記も含む理由：**
- 商標登録では漢字とカタカナ両方使われる
- 検索時に両方マッチさせる必要がある

**使用場面：**
```python
# 「株式会社トヨタ」→「トヨタ」
# 会社種別を除去して企業名の本体だけで検索
```

---

## 8. 日本語テキスト正規化メソッド（112-177行目）

### メソッド定義とdocstring（112-122行目）

```python
    @classmethod
    def normalize_text_jp(cls, text: str, for_trademark: bool = False) -> str:
        """日本語テキストの正規化（TMSONAR準拠）
        
        Args:
            text: 入力テキスト
            for_trademark: 商標用の場合True（ローマ数字変換を適用）
        
        Returns:
            正規化されたテキスト
        """
```

#### 詳細解説：

**112行目：`@classmethod`**
- **クラスメソッド**を定義するデコレータ
- インスタンスを作らずに呼べる：`TextNormalizer.normalize_text_jp(text)`
- 第一引数は`cls`（クラス自身）

**113行目：メソッドシグネチャ**
- `cls`：クラス自身への参照
- `text: str`：正規化する文字列（型ヒント付き）
- `for_trademark: bool = False`：商標用フラグ（デフォルトはFalse）
- `-> str`：戻り値の型（文字列）

### 空文字チェック（123-124行目）

```python
        if not text:
            return text
```

#### 詳細解説：

**早期リターン**パターン：
- 空文字列、None、空リストなどは`not`でTrueになる
- 処理不要な場合は早めに返す（ガード節）
- これによりインデントが深くならない

### ローマ数字変換（126-129行目）

```python
        # 商標用：ローマ数字→算用数字（NFKC前に実行！）
        if for_trademark:
            for roman, arabic in cls.ROMAN_TO_ARABIC.items():
                text = text.replace(roman, arabic)
```

#### 詳細解説：

**なぜNFKC前に実行？**
- NFKC正規化でローマ数字が変わる可能性がある
- 確実に変換するため先に処理

**127行目：商標用の条件分岐**
- 商標検索では数字を統一したい
- 通常のテキストではローマ数字を保持したい場合もある

**128-129行目：辞書をループして置換**
```python
for roman, arabic in cls.ROMAN_TO_ARABIC.items():
    # 'Ⅲ' -> '3', 'Ⅳ' -> '4' など順次置換
    text = text.replace(roman, arabic)
```

### NFKC正規化（131-132行目）

```python
        # NFKC正規化
        text = unicodedata.normalize('NFKC', text)
```

#### 詳細解説：

**NFKC = Normalization Form KC**
- **N**ormalization：正規化
- **F**orm：形式
- **K**ompatibility：互換性
- **C**omposition：合成

**何をするか：**
1. **全角英数字→半角**：`Ａ`→`A`、`１`→`1`
2. **半角カナ→全角カナ**：`ｱ`→`ア`
3. **合成文字の分解と再合成**：`が`を`か`+`゛`に分解して再合成
4. **互換文字の統一**：`㈱`→`(株)`、`①`→`1`

### ひらがな→カタカナ変換（134-141行目）

```python
        # ひらがな→カタカナ変換
        result = []
        for char in text:
            if 'ぁ' <= char <= 'ん':
                result.append(chr(ord(char) - ord('ぁ') + ord('ァ')))
            else:
                result.append(char)
        text = ''.join(result)
```

#### 詳細解説：

**文字コードを使った変換ロジック：**

```
ひらがな：ぁ(U+3041) ～ ん(U+3093)
カタカナ：ァ(U+30A1) ～ ン(U+30F3)
差分：0x60（96）
```

**137行目：範囲チェック**
- `'ぁ' <= char <= 'ん'`：ひらがなの範囲判定
- Pythonでは文字の大小比較が可能

**138行目：文字コード変換**
```python
chr(ord(char) - ord('ぁ') + ord('ァ'))
# ord(): 文字→文字コード
# chr(): 文字コード→文字
# 例：'あ'(0x3042) - 'ぁ'(0x3041) + 'ァ'(0x30A1) = 'ア'(0x30A2)
```

### 大文字変換（143-144行目）

```python
        # 英小文字→大文字、カナ小文字→大文字
        text = text.upper()
```

#### 詳細解説：

`upper()`メソッドの動作：
- `a-z` → `A-Z`
- `ぁぃぅぇぉ` → そのまま（すでにカタカナに変換済み）
- 数字や記号はそのまま

### ハイフン類の統一（146-149行目）

```python
        # 長音・横線・ハイフン類をハイフン（-）に統一
        hyphens = '－—–―〜～‐ｰ'
        for h in hyphens:
            text = text.replace(h, '-')
```

#### 詳細解説：

**様々なハイフン文字：**
- `－`：全角ハイフンマイナス
- `—`：EMダッシュ
- `–`：ENダッシュ
- `―`：水平線
- `〜`：波ダッシュ
- `～`：全角チルダ
- `‐`：ハイフン
- `ｰ`：半角カタカナ長音

これらを半角ハイフン`-`に統一。

### ギリシャ文字変換（151-153行目）

```python
        # ギリシャ文字・ラテン文字異体→アルファベット
        for old, new in cls.GREEK_LATIN_TO_ALPHABET.items():
            text = text.replace(old, new)
```

Part 1で定義した変換テーブルを適用。

### 特殊記号の削除（155-158行目）

```python
        # 特殊記号削除（▲▼§￠＼∞）
        special_chars = '▲▼§￠＼∞'
        for char in special_chars:
            text = text.replace(char, '')
```

#### 詳細解説：

**削除される記号：**
- `▲▼`：三角記号（強調に使われるが検索では不要）
- `§`：セクション記号
- `￠`：セント記号
- `＼`：バックスラッシュ
- `∞`：無限大記号

### 句読点処理（160-168行目）

```python
        # 句読点・中点・カンマ・クォート類削除
        # ただし商標の場合、句点（。）と括弧類《》【】『』は残す
        if for_trademark:
            remove_chars = '、・．，\'\"`'
        else:
            remove_chars = '、。・．，\'\"`'
        
        for char in remove_chars:
            text = text.replace(char, '')
```

#### 詳細解説：

**商標モードと通常モードの違い：**
- 商標：句点`。`を残す（商標の一部として重要な場合がある）
- 通常：句点も削除

### スペース削除（170-171行目）

```python
        # スペース削除
        text = text.replace(' ', '').replace('　', '')
```

半角スペースと全角スペースの両方を削除。

### 旧字体変換（173-175行目）

```python
        # 旧字体→新字体変換
        for old, new in cls.OLD_TO_NEW_KANJI.items():
            text = text.replace(old, new)
```

Part 1で定義した膨大な変換テーブルを適用。

---

## 9. 称呼用カナ正規化メソッド（179-239行目）

### メソッド定義（179-193行目）

```python
    @classmethod
    def normalize_kana_for_pron(cls, text: str) -> str:
        """称呼用カナ正規化（TMSONAR準拠5段階処理）
        
        Args:
            text: 入力テキスト（カナ）
        
        Returns:
            正規化された称呼
        """
        if not text:
            return text
        
        # 基本正規化（カタカナ化・大文字化）
        text = cls.normalize_text_jp(text)
```

#### 詳細解説：

**称呼（しょうこ）とは：**
- 商標の「読み方」
- 「コカ・コーラ」の称呼は「コカコーラ」
- 音が似ている商標を見つけるために重要

**TMSONAR準拠5段階処理：**
特許庁の検索システムと同じアルゴリズム。

### 段階2：発音同一（195-201行目）

```python
        # 段階2: 発音同一
        text = text.replace('ヲ', 'オ')
        text = text.replace('ヂ', 'ジ')
        text = text.replace('ヅ', 'ズ')
        text = text.replace('ヂャ', 'ジャ')
        text = text.replace('ヂュ', 'ジュ')
        text = text.replace('ヂョ', 'ジョ')
```

#### 詳細解説：

**現代日本語で同じ発音：**
- `ヲ`と`オ`：どちらも「お」
- `ヂ`と`ジ`：どちらも「じ」
- `ヅ`と`ズ`：どちらも「ず」

### 段階3：微差音統一（203-212行目）

```python
        # 段階3: 微差音統一
        text = text.replace('ヴァ', 'バ')
        text = text.replace('ヴィ', 'ビ')
        text = text.replace('ヴ', 'ブ')
        text = text.replace('ヴェ', 'ベ')
        text = text.replace('ヴォ', 'ボ')
```

#### 詳細解説：

**外来語の表記揺れ：**
- `ヴァイオリン`と`バイオリン`
- `ヴィーナス`と`ビーナス`
- 発音が似ているので統一

### 段階4：長音処理（214-229行目）

```python
        # 段階4: 長音処理
        # 長音記号除去
        text = text.replace('ー', '')
        
        # エイ→エー→エ、オウ→オー→オなどの処理
        # 母音連続の簡略化
        text = text.replace('エイ', 'エ')
        text = text.replace('オウ', 'オ')
        text = text.replace('アア', 'ア')
        text = text.replace('イイ', 'イ')
        text = text.replace('ウウ', 'ウ')
        text = text.replace('エエ', 'エ')
        text = text.replace('オオ', 'オ')
        
        # 促音の除去
        text = text.replace('ッ', '')
```

#### 詳細解説：

**長音の扱い：**
- `コーヒー` → `コヒ`
- `サーバー` → `サバ`
- 音の長さは無視して本質的な音だけ残す

**促音（そくおん）の除去：**
- `ハッピー` → `ハピ`
- `サッカー` → `サカ`

### 段階5：拗音大文字化（231-237行目）

```python
        # 段階5: 拗音大文字化（最後に実行）
        replacements = [
            ('ャ', 'ヤ'), ('ュ', 'ユ'), ('ョ', 'ヨ'),
            ('ァ', 'ア'), ('ィ', 'イ'), ('ゥ', 'ウ'), ('ェ', 'エ'), ('ォ', 'オ'),
        ]
        for small, large in replacements:
            text = text.replace(small, large)
```

#### 詳細解説：

**小文字カナを大文字に：**
- `キャ` → `キヤ`
- `シュ` → `シユ`
- `チョ` → `チヨ`

これにより、`キャンプ`と`キヤンプ`が同じになる。

---

## 10. 会社名正規化メソッド（241-250行目）

```python
    @classmethod
    def normalize_company_name(cls, text: str) -> str:
        """会社名正規化（type-102用）"""
        text = cls.normalize_text_jp(text)
        
        # 会社種別除去
        for company_type in cls.COMPANY_TYPES:
            text = text.replace(company_type, '')
        
        return text
```

#### 詳細解説：

**処理の流れ：**
1. 基本的な日本語正規化を適用
2. 会社種別（株式会社など）を削除

**使用例：**
```python
# 「株式会社ソニー」→「ソニー」
# 「トヨタ自動車株式会社」→「トヨタ自動車」
```

---

## 11. 住所正規化メソッド（252-275行目）

```python
    @classmethod
    def normalize_address(cls, text: str) -> str:
        """住所正規化（type-134用）"""
        text = cls.normalize_text_jp(text)
        
        # 丁目の漢数字→算用数字（1-44まで）
        chome_map = {
            '一丁目': '1丁目', '二丁目': '2丁目', '三丁目': '3丁目',
            # ... 省略 ...
            '四十四丁目': '44丁目'
        }
        
        for kanji, arabic in chome_map.items():
            text = text.replace(kanji, arabic)
        
        return text
```

#### 詳細解説：

**なぜ44丁目まで？**
- 日本の住所で実在する最大の丁目番号を考慮
- 札幌市などでは40番台の丁目が存在

**住所正規化の重要性：**
- 同じ場所でも表記が異なる
- 「東京都千代田区霞が関一丁目」
- 「東京都千代田区霞ヶ関1丁目」
- これらを統一して検索可能にする

---

## 12. QueryParserクラス - クエリ解析（280-299行目）

### クラス定義とsplit_termsメソッド

```python
class QueryParser:
    """クエリパースユーティリティ"""
    
    @staticmethod
    def split_terms(text: str) -> List[str]:
        """複数キーワードの分割
        
        Args:
            text: 入力テキスト（空白/カンマ区切り）
        
        Returns:
            キーワードのリスト
        """
        if not text:
            return []
        
        # 全指定の場合
        if text.strip() in ['？', '?']:
            return ['?']
```

#### 詳細解説：

**283行目：`@staticmethod`**
- 静的メソッド（インスタンスもクラスも不要）
- `QueryParser.split_terms(text)`で呼べる
- `self`も`cls`も不要

**296-298行目：全検索の特殊処理**
- `？`または`?`だけの入力は「全件検索」を意味
- TMSONARの仕様に準拠

---

## まとめ：Part 2で学んだこと

### 🎯 正規化処理の流れ

1. **基本正規化**
   - NFKC正規化（文字の統一）
   - ひらがな→カタカナ
   - 小文字→大文字

2. **商標特有の処理**
   - ローマ数字→算用数字
   - 旧字体→新字体
   - 特殊記号の削除

3. **称呼の5段階処理**
   - 発音同一
   - 微差音統一
   - 長音処理
   - 促音除去
   - 拗音大文字化

### 💡 プログラミングテクニック

- **@classmethod**：インスタンス不要のメソッド
- **@staticmethod**：クラスも不要のメソッド
- **早期リターン**：ガード節で深いネストを避ける
- **文字コード操作**：`ord()`と`chr()`の活用

### 🔍 実務での応用

この正規化技術は：
- **検索エンジン**の精度向上
- **データクレンジング**
- **自然言語処理**の前処理
- **音声認識**の後処理

などで活用できます。

---

## 次のPart 3では

- QueryParserの続き（AND/OR検索、ワイルドカード処理）
- 検索クエリの構築
- データベース接続とSQL実行

を詳しく解説します。
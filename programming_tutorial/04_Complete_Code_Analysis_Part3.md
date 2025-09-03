# 🔬 TMCloud完全コード解説 Part 3 - クエリ解析と検索タイプ
～検索条件の処理と検索エンジン本体の開始～

## 📚 Part 3の内容

QueryParserクラスの続き（複数キーワード処理、ワイルドカード、日付解析）と、検索エンジンの本体であるTMCloudIntegratedSearchクラスの開始部分を解説します。

---

## 13. 複数キーワードの分割処理（300-308行目）

```python
        # 空白とカンマで分割（全角・半角両対応）
        import re
        # カンマ（全角・半角）と空白（全角・半角）で分割
        terms = re.split(r'[,，\s　]+', text)
        
        # 空要素除去
        terms = [t.strip() for t in terms if t.strip()]
        
        return terms
```

#### 詳細解説：

**301行目：importの位置**
- 通常はファイル先頭でimportすべきだが、ここでは関数内import
- 理由：このメソッドだけでreを使うため（軽微な最適化）

**303行目：正規表現による分割**
```python
re.split(r'[,，\s　]+', text)
```
- `r''`：raw文字列（バックスラッシュをそのまま扱う）
- `[,，\s　]+`：正規表現パターン
  - `[...]`：文字クラス（いずれか1文字）
  - `,`：半角カンマ
  - `，`：全角カンマ
  - `\s`：空白文字（半角スペース、タブ、改行など）
  - `　`：全角スペース
  - `+`：1文字以上の繰り返し

**使用例：**
```python
# 入力: "商標A,  商標B，商標C　商標D"
# 結果: ['商標A', '商標B', '商標C', '商標D']
```

**306行目：リスト内包表記による空要素除去**
```python
terms = [t.strip() for t in terms if t.strip()]
```
- `t.strip()`：前後の空白を削除
- `if t.strip()`：空文字でない場合のみ含める
- 二重にstrip()を呼ぶ理由：
  1. 条件判定用（空チェック）
  2. 値の整形用

---

## 14. LIKE検索用ワイルドカード処理（310-324行目）

```python
    @staticmethod
    def wildcard_like(term: str) -> str:
        """LIKE用ワイルドカード変換とエスケープ"""
        if not term:
            return '%'
        
        # まずエスケープ処理（順序重要！）
        pattern = term.replace('\\', '\\\\')  # バックスラッシュを先に
        pattern = pattern.replace('%', '\\%')  # 既存の%をエスケープ
        pattern = pattern.replace('_', '\\_')  # アンダースコアをエスケープ
        
        # その後ワイルドカード変換
        pattern = pattern.replace('？', '%').replace('?', '%')
        
        return pattern
```

#### 詳細解説：

**SQLのLIKE演算子のメタ文字：**
- `%`：任意の0文字以上
- `_`：任意の1文字
- `\`：エスケープ文字

**313-314行目：空の場合の処理**
```python
if not term:
    return '%'  # すべてにマッチ
```

**316-319行目：エスケープ処理（順序が重要！）**
```python
# 順序1: バックスラッシュ自体をエスケープ
pattern = term.replace('\\', '\\\\')
# 例: "test\" → "test\\"

# 順序2: %をエスケープ
pattern = pattern.replace('%', '\\%')
# 例: "50%" → "50\%"（リテラルの%として扱う）

# 順序3: _をエスケープ
pattern = pattern.replace('_', '\\_')
# 例: "user_name" → "user\_name"（リテラルの_として扱う）
```

**322行目：ユーザー入力のワイルドカード変換**
```python
pattern = pattern.replace('？', '%').replace('?', '%')
```
- ユーザーが入力した`?`や`？`をSQLの`%`に変換
- TMSONARの仕様：`?`は任意文字列を表す

---

## 15. FTS用ワイルドカード処理（326-335行目）

```python
    @staticmethod
    def wildcard_fts(term: str) -> str:
        """FTS用ワイルドカード変換"""
        if not term:
            return '*'
        
        # ?を*に変換
        pattern = term.replace('？', '*').replace('?', '*')
        
        return pattern
```

#### 詳細解説：

**FTS（Full Text Search）のワイルドカード：**
- SQLiteのFTS5では`*`が任意文字列
- LIKEの`%`とは異なる記号を使用

**使用例：**
```python
# LIKE用: "商標?" → "商標%"
# FTS用:  "商標?" → "商標*"
```

---

## 16. 日付範囲のパース（338-390行目）

### メインメソッド（338-352行目）

```python
    @staticmethod
    def parse_date_range(expr: str) -> Tuple[Optional[str], Optional[str]]:
        """日付範囲のパース（和暦対応）"""
        if not expr or expr.strip() in ['？', '?']:
            return (None, None)
        
        # 範囲指定の場合
        if ':' in expr:
            parts = expr.split(':', 1)
            start = QueryParser._parse_single_date(parts[0].strip()) if parts[0].strip() else None
            end = QueryParser._parse_single_date(parts[1].strip()) if parts[1].strip() else None
            return (start, end)
        
        # 単一日付の場合
        date = QueryParser._parse_single_date(expr)
        return (date, date) if date else (None, None)
```

#### 詳細解説：

**338行目：戻り値の型ヒント**
```python
-> Tuple[Optional[str], Optional[str]]
```
- タプルで開始日と終了日を返す
- `Optional[str]`：文字列またはNone

**344-348行目：範囲指定の処理**
```python
if ':' in expr:
    parts = expr.split(':', 1)  # 最初の:で分割（1回だけ）
```
- 例：`"20250101:20251231"` → `["20250101", "20251231"]`
- 例：`":20251231"` → 終了日のみ指定
- 例：`"20250101:"` → 開始日のみ指定

### 単一日付のパース（354-390行目）

```python
    @staticmethod
    def _parse_single_date(date_str: str) -> Optional[str]:
        """単一日付のパース（YYYYMMDD形式に変換）"""
        if not date_str:
            return None
        
        # 和暦変換テーブル（簡易版）
        wareki_map = {
            'R': 2019, 'H': 1989, 'S': 1926, 'T': 1912, 'M': 1868,
            '令和': 2019, '平成': 1989, '昭和': 1926, '大正': 1912, '明治': 1868
        }
```

#### 詳細解説：

**361-364行目：和暦の基準年**
- 各元号の元年（1年目）の西暦年
- 令和元年 = 2019年
- 平成元年 = 1989年
- 昭和元年 = 1926年

**366-375行目：和暦→西暦変換**
```python
for era, base_year in wareki_map.items():
    if date_str.startswith(era):
        # 正規表現で年月日を抽出
        match = re.match(rf'{era}(\d+)[/.\-]?(\d+)[/.\-]?(\d+)', date_str)
        if match:
            year = base_year + int(match.group(1)) - 1
            month = match.group(2).zfill(2)
            day = match.group(3).zfill(2)
            return f'{year}{month}{day}'
```

**変換例：**
```python
# "R5/7/25" → "20230725"
# 計算: 2019 + 5 - 1 = 2023

# "平成31/4/30" → "20190430"
# 計算: 1989 + 31 - 1 = 2019
```

**372行目：年の計算式**
```python
year = base_year + int(match.group(1)) - 1
```
- なぜ-1？元号の1年目は基準年そのものだから
- 令和1年 = 2019年（2019 + 1 - 1 = 2019）
- 令和5年 = 2023年（2019 + 5 - 1 = 2023）

**373-374行目：ゼロパディング**
```python
month = match.group(2).zfill(2)  # "7" → "07"
day = match.group(3).zfill(2)    # "5" → "05"
```

---

## 17. 番号範囲のパース（392-416行目）

```python
    @staticmethod
    def parse_number_range(expr: str) -> Tuple[Optional[str], Optional[str]]:
        """番号範囲のパース"""
        if not expr or expr.strip() in ['？', '?']:
            return (None, None)
        
        # 範囲指定の場合
        if ':' in expr:
            parts = expr.split(':', 1)
            start = QueryParser._normalize_number(parts[0].strip()) if parts[0].strip() else None
            end = QueryParser._normalize_number(parts[1].strip()) if parts[1].strip() else None
            return (start, end)
        
        # 単一番号の場合
        number = QueryParser._normalize_number(expr)
        return (number, number) if number else (None, None)
    
    @staticmethod
    def _normalize_number(number_str: str) -> Optional[str]:
        """番号の正規化（ハイフン除去）"""
        if not number_str:
            return None
        
        # ハイフンを除去
        return number_str.replace('-', '').replace('－', '')
```

#### 詳細解説：

**番号正規化の必要性：**
- 出願番号の表記揺れ：`2025-064118`、`2025064118`
- 登録番号の表記揺れ：`7-123456`、`7123456`

---

## 18. 法区分＋類のパース（418-442行目）

```python
    @staticmethod
    def parse_law_class(expr: str) -> Tuple[Optional[str], Optional[str]]:
        """法区分＋類のパース"""
        if not expr or expr.strip() in ['？', '?']:
            return (None, None)
        
        expr = expr.strip()
        
        # ?09形式（類のみ）
        if expr.startswith('?') or expr.startswith('？'):
            if len(expr) >= 3:
                return (None, expr[1:3])
            return (None, None)
        
        # W?形式（法区分のみ）
        if expr.endswith('?') or expr.endswith('？'):
            if len(expr) >= 1:
                return (expr[0], None)
            return (None, None)
        
        # Y01形式（両方指定）
        if len(expr) >= 3:
            return (expr[0], expr[1:3])
        
        return (None, None)
```

#### 詳細解説：

**法区分と類の意味：**
- **法区分**：商標法の区分（商標、サービスマークなど）
- **類**：商品・サービスの分類（01～45類）

**パターン：**
- `?09`：第9類のみ指定（電子機器など）
- `W?`：法区分Wのみ指定
- `Y01`：法区分Yの第1類

---

## 19. SearchType列挙型（445-478行目）

```python
class SearchType(Enum):
    """検索タイプの定義"""
    TRADEMARK = "trademark"     # 商標名検索
    PHONETIC = "phonetic"       # 称呼検索
    APP_NUM = "app_num"         # 出願番号検索
    REG_NUM = "reg_num"         # 登録番号検索
    DATE_RANGE = "date_range"   # 日付範囲検索
    STATUS = "status"           # ステータス検索
    SIMILAR_GROUP = "similar_group"  # 類似群コード検索
    GOODS_SERVICES = "goods_services"  # 商品・役務検索
    APPLICANT = "applicant"     # 出願人/権利者検索
    LAW_CLASS = "law_class"     # 法区分＋類検索
    VIENNA_CODE = "vienna_code"  # ウィーンコード検索
    DETAILED_DESC = "detailed_desc"  # 商標の詳細な説明検索
    TRADEMARK_TYPE = "trademark_type"  # 商標タイプ検索
    APP_TYPE = "app_type"       # 出願種別
    # 追加検索タイプ（TMSONAR仕様完全準拠）
    REJECTION_CODE = "rejection_code"          # ID108: 拒絶条文コード
    INTERMEDIATE_CODE = "intermediate_code"    # ID131: 中間記録コード
    APPLICANT_ADDRESS = "applicant_address"    # ID134: 出願人/権利者住所
    TRADEMARK_LENGTH = "trademark_length"      # ID132: 商標文字数
    PHONETIC_LENGTH = "phonetic_length"        # ID133: 称呼音数検索
    CLASS_COUNT = "class_count"                # ID137: 区分数検索
    APPLICANT_COUNT = "applicant_count"        # ID138: 出願人/権利者数検索
    PHONETIC_COUNT = "phonetic_count"          # ID139: 称呼数検索
    ADDITIONAL_INFO = "additional_info"        # ID128: 付加情報検索
    COUNTRY_CODE = "country_code"              # ID129: 国県コード検索
    EXPIRY_DATE = "expiry_date"                # ID114: 存続期間満了日検索
    PAYMENT_DATE = "payment_date"              # ID121: 分納満了日検索
    DECISION_DATE = "decision_date"            # ID116: 最終処分日検索
    APPEAL_NUM = "appeal_num"                  # ID120: 審判番号検索
    DECISION_CLASS = "decision_class"          # ID109: 審決分類検索
    INFO_PROVISION_COUNT = "info_provision_count"      # ID135: 情報提供数検索
    BROWSING_REQUEST_COUNT = "browsing_request_count"  # ID136: 閲覧請求数検索
```

#### 詳細解説：

**Enumクラスの利点：**
1. **型安全**：文字列の誤字を防ぐ
2. **自動補完**：IDEで候補が表示される
3. **一覧性**：すべての検索タイプが一目瞭然

**基本的な検索タイプ（447-460行目）：**
- 商標名、称呼、番号など一般的な検索

**TMSONAR準拠の高度な検索（462-478行目）：**
- IDコメントは特許庁の仕様書での項目番号
- 例：`ID108: 拒絶条文コード`は仕様書の108番目の項目

**使用例：**
```python
# 型安全な比較
if search_type == SearchType.TRADEMARK:
    # 商標名検索の処理

# 値の取得
print(SearchType.TRADEMARK.value)  # "trademark"
```

---

## 20. TMCloudIntegratedSearchクラス開始（480-499行目）

```python
class TMCloudIntegratedSearch:
    """統合検索クラス"""
    
    # 種別コードマッピング（特許庁公式定義より）
    
    # 四法コード（C0010）
    LAW_CODE_MAP = {
        '１': '特許',
        '２': '実用新案',
        '３': '意匠',
        '４': '商標',
        '９': '審判',
    }
    
    # 審査最終処分種別コード（C0360/C0440）
    EXAMINATION_DISPOSITION_MAP = {
        'Ａ００': '欠号',
        'Ａ０１': '登録',
        'Ａ０２': '拒絶',
        'Ａ０４': '取下',
```

#### 詳細解説：

**480-481行目：メインクラスの開始**
- このクラスが検索エンジンの本体
- すべての検索機能がここに実装される

**485-492行目：四法コード**
- 日本の知的財産権の4つの法律
- 特許、実用新案、意匠、商標
- 全角数字を使用（特許庁の仕様）

**494-499行目：処分コード**
- 審査の結果を表すコード
- `Ａ０１`：登録査定（合格）
- `Ａ０２`：拒絶査定（不合格）
- `Ａ０４`：取下げ（申請者が取り下げ）

---

## まとめ：Part 3で学んだこと

### 🎯 高度なテキスト処理

1. **正規表現による分割**
   - 複数の区切り文字に対応
   - 全角・半角の両方を処理

2. **ワイルドカード処理**
   - SQLインジェクション対策（エスケープ）
   - LIKE用とFTS用の使い分け

3. **日付の柔軟な処理**
   - 和暦→西暦変換
   - 様々な形式に対応

### 💡 設計パターン

- **Enumによる定数管理**
- **静的メソッドとクラスメソッドの使い分け**
- **Optional型による null安全性**
- **早期リターンによる可読性向上**

### 🔍 実務での知識

- **和暦の計算方法**
- **SQLのメタ文字エスケープ**
- **特許庁のコード体系**
- **商標検索の多様な条件**

---

## 次のPart 4では

- TMCloudIntegratedSearchクラスの初期化
- データベース接続処理
- 実際の検索メソッドの実装

を詳しく解説します。
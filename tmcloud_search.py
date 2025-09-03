#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
TMCloud 統合検索システム
Version: 2.0
Date: 2025-08-08

TMSONAR仕様準拠の統合検索システム
- 商標名検索（FTS5、文字統一処理）
- 称呼検索（TMSONAR準拠5段階処理）
- 番号検索（出願番号・登録番号）
- 日付範囲検索（和暦対応）
- ステータス検索
- 類似群コード検索（前方一致対応）
- 指定商品/役務検索（項目内AND）
"""

import sqlite3
import sys
import os
import unicodedata
import re
import time
import json
import logging
from pathlib import Path
from typing import List, Tuple, Optional, Set, Dict, Any
from datetime import datetime
from enum import Enum


# ========== 正規化ユーティリティ ==========

class TextNormalizer:
    """テキスト正規化ユーティリティ（TMSONAR準拠）"""
    
    # ローマ数字→算用数字変換テーブル
    ROMAN_TO_ARABIC = {
        'Ⅰ': '1', 'Ⅱ': '2', 'Ⅲ': '3', 'Ⅳ': '4', 'Ⅴ': '5',
        'Ⅵ': '6', 'Ⅶ': '7', 'Ⅷ': '8', 'Ⅸ': '9', 'Ⅹ': '10',
        'Ⅺ': '11', 'Ⅻ': '12', 'ⅰ': '1', 'ⅱ': '2', 'ⅲ': '3',
        'ⅳ': '4', 'ⅴ': '5', 'ⅵ': '6', 'ⅶ': '7', 'ⅷ': '8',
        'ⅸ': '9', 'ⅹ': '10', 'ⅺ': '11', 'ⅻ': '12'
    }
    
    # ギリシャ文字・ラテン文字異体→アルファベット変換
    GREEK_LATIN_TO_ALPHABET = {
        'Α': 'A', 'Β': 'B', 'Γ': 'G', 'Δ': 'D', 'Ε': 'E', 'Ζ': 'Z',
        'Η': 'H', 'Θ': 'TH', 'Ι': 'I', 'Κ': 'K', 'Λ': 'L', 'Μ': 'M',
        'Ν': 'N', 'Ξ': 'X', 'Ο': 'O', 'Π': 'P', 'Ρ': 'R', 'Σ': 'S',
        'Τ': 'T', 'Υ': 'Y', 'Φ': 'F', 'Χ': 'CH', 'Ψ': 'PS', 'Ω': 'O',
        'α': 'a', 'β': 'b', 'γ': 'g', 'δ': 'd', 'ε': 'e', 'ζ': 'z',
        'η': 'h', 'θ': 'th', 'ι': 'i', 'κ': 'k', 'λ': 'l', 'μ': 'm',
        'ν': 'n', 'ξ': 'x', 'ο': 'o', 'π': 'p', 'ρ': 'r', 'σ': 's',
        'τ': 't', 'υ': 'y', 'φ': 'f', 'χ': 'ch', 'ψ': 'ps', 'ω': 'o',
        'Å': 'A', 'Ø': 'O', 'Æ': 'AE', 'æ': 'ae', 'ø': 'o', 'å': 'a'
    }
    
    # 会社種別（type-102でのみ除去）
    COMPANY_TYPES = [
        '株式会社', '有限会社', '合名会社', '合資会社', '合同会社', '保険相互会社',
        'カブシキガイシャ', 'ユウゲンガイシャ', 'ゴウメイガイシャ', 
        'ゴウシガイシャ', 'ゴウドウガイシャ', 'ホケンソウゴガイシャ'
    ]
    
    # 旧字体→新字体変換テーブル（JSONファイルから読み込み）
    OLD_TO_NEW_KANJI = {}
    
    @classmethod
    def load_kanji_conversion(cls):
        """旧字体→新字体変換テーブルをJSONから読み込み"""
        if not cls.OLD_TO_NEW_KANJI:
            json_path = Path(__file__).parent / 'config' / 'kanji_conversion.json'
            try:
                with open(json_path, 'r', encoding='utf-8') as f:
                    cls.OLD_TO_NEW_KANJI = json.load(f)
            except Exception as e:
                # フォールバック用の最小限の変換テーブル
                cls.OLD_TO_NEW_KANJI = {
                    '萬': '万', '圓': '円', '會': '会', '醫': '医', '驛': '駅',
                    '學': '学', '廣': '広', '國': '国', '齊': '斉', '澤': '沢'
                }
    
    @classmethod
    def normalize_text_jp(cls, text: str, for_trademark: bool = False) -> str:
        """日本語テキストの正規化（TMSONAR準拠）
        
        Args:
            text: 入力テキスト
            for_trademark: 商標用の場合True（ローマ数字変換を適用）
        
        Returns:
            正規化されたテキスト
        """
        if not text:
            return text
        
        # 商標用：ローマ数字→算用数字（NFKC前に実行！）
        if for_trademark:
            for roman, arabic in cls.ROMAN_TO_ARABIC.items():
                text = text.replace(roman, arabic)
        
        # NFKC正規化
        text = unicodedata.normalize('NFKC', text)
        
        # ひらがな→カタカナ変換
        result = []
        for char in text:
            if 'ぁ' <= char <= 'ん':
                result.append(chr(ord(char) - ord('ぁ') + ord('ァ')))
            else:
                result.append(char)
        text = ''.join(result)
        
        # 英小文字→大文字、カナ小文字→大文字
        text = text.upper()
        
        # 長音・横線・ハイフン類をハイフン（-）に統一
        hyphens = '－—–―〜～‐ｰ'
        for h in hyphens:
            text = text.replace(h, '-')
        
        # ギリシャ文字・ラテン文字異体→アルファベット
        for old, new in cls.GREEK_LATIN_TO_ALPHABET.items():
            text = text.replace(old, new)
        
        # 特殊記号削除（▲▼§￠＼∞）
        special_chars = '▲▼§￠＼∞'
        for char in special_chars:
            text = text.replace(char, '')
        
        # 句読点・中点・カンマ・クォート類削除
        # ただし商標の場合、句点（。）と括弧類《》【】『』は残す
        if for_trademark:
            remove_chars = '、・．，\'\"`'
        else:
            remove_chars = '、。・．，\'\"`'
        
        for char in remove_chars:
            text = text.replace(char, '')
        
        # スペース削除
        text = text.replace(' ', '').replace('　', '')
        
        # 旧字体→新字体変換（初回呼び出し時にJSONを読み込み）
        cls.load_kanji_conversion()
        for old, new in cls.OLD_TO_NEW_KANJI.items():
            text = text.replace(old, new)
        
        return text
    
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
        
        # 段階2: 発音同一
        text = text.replace('ヲ', 'オ')
        text = text.replace('ヂ', 'ジ')
        text = text.replace('ヅ', 'ズ')
        text = text.replace('ヂャ', 'ジャ')
        text = text.replace('ヂュ', 'ジュ')
        text = text.replace('ヂョ', 'ジョ')
        
        # 段階3: 微差音統一
        text = text.replace('ヴァ', 'バ')
        text = text.replace('ヴィ', 'ビ')
        text = text.replace('ヴ', 'ブ')
        text = text.replace('ヴェ', 'ベ')
        text = text.replace('ヴォ', 'ボ')
        text = text.replace('ツィ', 'チ')
        text = text.replace('テュ', 'チュ')
        text = text.replace('フュ', 'ヒュ')
        text = text.replace('ヴュ', 'ビュ')
        
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
        
        # 段階5: 拗音大文字化（最後に実行）
        replacements = [
            ('ャ', 'ヤ'), ('ュ', 'ユ'), ('ョ', 'ヨ'),
            ('ァ', 'ア'), ('ィ', 'イ'), ('ゥ', 'ウ'), ('ェ', 'エ'), ('ォ', 'オ'),
        ]
        for small, large in replacements:
            text = text.replace(small, large)
        
        return text
    
    @classmethod
    def normalize_company_name(cls, text: str) -> str:
        """会社名正規化（type-102用）"""
        text = cls.normalize_text_jp(text)
        
        # 会社種別除去
        for company_type in cls.COMPANY_TYPES:
            text = text.replace(company_type, '')
        
        return text
    
    @classmethod
    def normalize_address(cls, text: str) -> str:
        """住所正規化（type-134用）"""
        text = cls.normalize_text_jp(text)
        
        # 丁目の漢数字→算用数字（1-44まで）
        chome_map = {
            '一丁目': '1丁目', '二丁目': '2丁目', '三丁目': '3丁目', '四丁目': '4丁目',
            '五丁目': '5丁目', '六丁目': '6丁目', '七丁目': '7丁目', '八丁目': '8丁目',
            '九丁目': '9丁目', '十丁目': '10丁目', '十一丁目': '11丁目', '十二丁目': '12丁目',
            '十三丁目': '13丁目', '十四丁目': '14丁目', '十五丁目': '15丁目', '十六丁目': '16丁目',
            '十七丁目': '17丁目', '十八丁目': '18丁目', '十九丁目': '19丁目', '二十丁目': '20丁目',
            '二十一丁目': '21丁目', '二十二丁目': '22丁目', '二十三丁目': '23丁目', '二十四丁目': '24丁目',
            '二十五丁目': '25丁目', '二十六丁目': '26丁目', '二十七丁目': '27丁目', '二十八丁目': '28丁目',
            '二十九丁目': '29丁目', '三十丁目': '30丁目', '三十一丁目': '31丁目', '三十二丁目': '32丁目',
            '三十三丁目': '33丁目', '三十四丁目': '34丁目', '三十五丁目': '35丁目', '三十六丁目': '36丁目',
            '三十七丁目': '37丁目', '三十八丁目': '38丁目', '三十九丁目': '39丁目', '四十丁目': '40丁目',
            '四十一丁目': '41丁目', '四十二丁目': '42丁目', '四十三丁目': '43丁目', '四十四丁目': '44丁目'
        }
        
        for kanji, arabic in chome_map.items():
            text = text.replace(kanji, arabic)
        
        return text


# ========== パースユーティリティ ==========

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
        
        # 空白とカンマで分割（全角・半角両対応）
        import re
        # カンマ（全角・半角）と空白（全角・半角）で分割
        terms = re.split(r'[,，\s　]+', text)
        
        # 空要素除去
        terms = [t.strip() for t in terms if t.strip()]
        
        return terms
    
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
    
    @staticmethod
    def wildcard_fts(term: str) -> str:
        """FTS用ワイルドカード変換"""
        if not term:
            return '*'
        
        # ?を*に変換
        pattern = term.replace('？', '*').replace('?', '*')
        
        return pattern
    
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
        
        # 和暦の処理
        for era, base_year in wareki_map.items():
            if date_str.startswith(era):
                # 和暦年を抽出して西暦に変換
                match = re.match(rf'{era}(\d+)[/.\-]?(\d+)[/.\-]?(\d+)', date_str)
                if match:
                    year = base_year + int(match.group(1)) - 1
                    month = match.group(2).zfill(2)
                    day = match.group(3).zfill(2)
                    return f'{year}{month}{day}'
        
        # 西暦の処理
        # 区切り文字を統一
        date_str = date_str.replace('/', '').replace('.', '').replace('-', '')
        
        # 8桁の場合はそのまま
        if len(date_str) == 8 and date_str.isdigit():
            return date_str
        
        # その他の形式を試みる
        match = re.match(r'(\d{4})(\d{2})(\d{2})', date_str)
        if match:
            return date_str
        
        return None
    
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
    
    @staticmethod
    def parse_law_class(expr: str) -> Tuple[Optional[str], Optional[str]]:
        """法区分＋類のパース"""
        if not expr or expr.strip() in ['？', '?']:
            return (None, None)
        
        expr = expr.strip()
        
        # ?09形式（類のみ）
        if expr.startswith('?') or expr.startswith('？'):
            if len(expr) == 2:
                # 例: "?9" → "09"
                return (None, expr[1:].zfill(2))
            elif len(expr) >= 3:
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
    INTL_REG_NUM = "intl_reg_num"              # 国際登録番号
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
        'Ａ０５': '放棄',
        'Ａ０６': '変更',
        'Ａ０７': '翻訳文未提出による取下（ＰＣＴ）',
        'Ａ０８': '補正却下',
        'Ａ０９': '未審査請求によるみなし取下',
        'Ａ１０': '出願却下（方式）',
        'Ａ１１': '国内優先権に基づくみなし取下',
        'Ａ１２': '再審査請求期間満了によるみなし取下',
        'Ａ１３': '手続無効（無効処分）',
        'Ａ１４': '取下・放棄後の出願却下（方式）',
        'Ａ１５': '出願変更取下による原出願回復',
        'Ａ１６': '手続（出願）取消',
        'Ａ１７': '特許公報発行',
        'Ａ１８': '却下理由通知',
        'Ａ１９': '国際商標登録出願・領域指定の取下',
        'Ａ２０': '国際商標登録出願・領域指定の放棄',
        'Ａ２１': '存続期間満了',
        'Ａ３１': '出願無効（方式）',
        'Ａ３２': '出願無効（登録）',
        'Ａ４２': '出願却下（方式却理）',
        'Ａ４３': '出願却下（方式指令）',
        'Ａ４５': '出願却下（登録）',
    }
    
    # 審判最終処分種別コード（C0470）
    APPEAL_DISPOSITION_MAP = {
        '００': '審査部差戻し',
        '０１': '請求成立',
        '０２': '請求不成立',
        '０３': '一部成立',
        '０４': '出願取下による審判終了',
        '０５': '出願放棄による審判終了',
        '０６': '出願変更による審判終了',
        '０７': '前置登録査定',
        '０８': '補正却下新出願による審判終了',
        '０９': '審判請求取下',
        '１０': '請求無効',
        '１１': '審決却下',
        '１２': '決定却下',
        '１３': '欠号（誤送取戻等による審判終了）',
        '１４': '不受理',
        '１５': '異議終了',
        '１６': '請求手続却下（旧請求無効）',
        '１７': '書換申請取下による審判終了',
    }

    # 審判種別コードマッピング（コードINDEX 18170準拠）
    APPEAL_TYPE_MAP = {
        "01": "拒絶査定不服審判",
        "70": "補正却下不服審判",
        "10": "無効審判",
        "11": "全部無効",
        "12": "一部無効",
        "13": "更新登録無効（全部）",
        "14": "更新登録無効（一部）",
        "15": "延長登録無効（全部）",
        "16": "延長登録無効（一部）",
        "17": "書換登録無効（全部）",
        "18": "書換登録無効（一部）",
        "20": "取消審判",
        "21": "不使用取消審判",
        "22": "不正使用取消審判",
        "23": "代理人による不正登録取消審判",
        "24": "混同による取消審判",
        "26": "商標法53条の2による取消審判",
        "40": "訂正審判",
        "50": "判定請求",
        "65": "登録異議申立て",
        "80": "査定不服審判",
        "81": "書換査定不服審判",
        "31": "取消審判(マドプロ)",
        "32": "取消審判(マドプロ・不使用)",
        "41": "無効審判(マドプロ)",
        "91": "参加許否の決定",
        "92": "登録異議の決定",
        "93": "補正却下の決定",
        "94": "証拠保全の決定",
        "95": "受継許否の決定",
        "99": "その他",
        # 3桁コード（詳細分類）
        "113": "全部無効（新々無効）",
        "114": "全部無効（新実用）",
        "123": "一部無効（新々無効）",
        "124": "一部無効（新実用）",
        "651": "登録異議申立て（特許）",
        "652": "登録異議申立て（実用新案）"
    }
    
    # 審判条文コードマッピング（審判条文記事用）
    APPEAL_ARTICLE_CODE_MAP = {
        # 商標法に基づく審判条文
        "C441": "第44条第1項（拒絶査定不服審判）",
        "45": "第45条（補正却下不服審判）",
        "46": "第46条（無効審判）",
        "C461": "第46条第1項（無効審判）",
        "47": "第47条（無効審判の審決確定の効果）",
        "50": "第50条（不使用取消審判）",
        "51": "第51条（不正使用取消審判）",
        "52": "第52条の2（不正使用取消審判）",
        "53": "第53条（使用権者の不正使用取消審判）",
        "C532": "第53条の2（代理人等の不正登録取消審判）",
        "54": "第54条（審決の効果）",
        "C552": "第55条の2（商標登録の取消しの審判）",
        "C553": "第55条の3（審決の効果）",
        "56": "第56条（再審）",
        "57": "第57条（再審の期間）",
        "58": "第58条（再審により回復した商標権の効力の制限）",
        "59": "第59条（審判の規定の準用）",
        "60": "第60条（審判における費用負担）",
        "61": "第61条（審判の手続）",
        "62": "第62条（査定に対する審判）",
        "63": "第63条（拒絶査定不服審判における特則）",
        "C432": "第43条の2（異議申立）",
        "C433": "第43条の3（異議申立理由）",
        "C434": "第43条の4（異議申立についての審理）",
        "C435": "第43条の5（異議申立についての決定）",
        "C436": "第43条の6（審判の規定の準用）",
        "C437": "第43条の7（異議申立と審判の関係）",
        "C438": "第43条の8（審判官の指定）",
        "C439": "第43条の9（審理の方式）",
        "C4310": "第43条の10（異議申立の取下げ）",
        "C4311": "第43条の11（参加）",
        "C4312": "第43条の12（証拠調べ）",
        "C4313": "第43条の13（職権審理）",
        "C4314": "第43条の14（意見書提出の機会）",
        "C4315": "第43条の15（決定）"
    }
    
    # 拒絶理由条文コードマッピング（特許庁公式コードINDEX 02110より）
    REJECTION_REASON_CODE_MAP = {
        # 商標の拒絶理由条文コード
        "30": "第3条第1項各号",
        "31": "第3条第1項各号＋第4条第1項第16号",
        "32": "第3条第1項柱書",
        "33": "第3条第1項柱書（定型文付）",
        "34": "第3条第1項柱書（定型文、但し書付）",
        "40": "第4条第1項各号（第11号～第13号を除く）",
        "41": "第4条第1項第11号",
        "42": "第4条第1項第12号",
        "43": "第4条第1項第13号",
        "44": "第4条第1項第11号＋第12号",
        "45": "第4条第1項第11号＋第13号",
        "46": "第4条第1項第12号＋第13号",
        "47": "第4条第1項第11号＋第12号＋第13号",
        "48": "第4条第3項",
        "49": "第5条第5項",
        "50": "第5条第5項＋第53条の2",
        "51": "第5条第5項（標準文字）",
        "52": "第5条の2第1項",
        "53": "第5条の2第1項＋第53条の2",
        "54": "第8条第1項",
        "55": "第8条第2項",
        "56": "第8条第5項",
        "60": "第6条第3項で準用する第5条第5項",
        "61": "第6条第1項",
        "62": "第6条第2項",
        "63": "第6条第1項＋第6条第2項",
        "64": "第64条（防護）",
        "65": "第6条第1項（防護）＋第6条第2項（防護）",
        "66": "第6条第1項又は第6条第2項",
        "67": "第6条第1項（防護）",
        "68": "防護更新",
        "69": "第6条第2項",
        "71": "第7条第1項（商標・商品類似）",
        "72": "第7条の2第1項",
        "73": "第7条の2第1項（団体）",
        "74": "第7条の2第1項（団体）（構成員）",
        "75": "第7条の2第1項（地域団体）",
        "76": "第7条の2第1項（防護）",
        "80": "第8条第2項＋第5条第5項",
        "81": "第8条第2項＋第6条第1項＋第6条第2項",
        "82": "第4条第1項各号＋第8条第2項＋第5条第5項",
        "84": "第4条第1項各号＋第8条第5項",
        "85": "第8条第5項＋第5条第5項",
        "90": "第65条の4第2項",
        "91": "第15条の3第2項",
        "99": "その他"
    }

    
    # 査定種別コード（半角数字版も追加）
    DECISION_TYPE_MAP = {
        '0': '査定なし',
        '1': '登録査定',
        '2': '拒絶査定',
    }
    
    # 審査種別コード
    EXAMINATION_TYPE_MAP = {
        '01': '通常審査',
        '03': '早期審査',
        '1': '通常審査',
        '3': '早期審査',
    }
    
    # 出願種別マッピング（コードINDEX: 02010）
    # 4-02出願マスタ（意商）_1.13版.docx Table 1より
    APPLICATION_TYPE_MAP = {
        '01': '通常',  # 11条1項、12条1項
        '04': '分割',  # 10条1項
        '05': '変更',
        '06': '補正却下',  # 17条
        '07': '地域団体',
        '10': '連合',  # 11条2項
        '11': '防護',  # 65条1項
        '12': '更新',
        '13': '防護の更新',
        '14': '団体',
        '15': '書換',
        '16': '防護の書換',
        '17': '重複更新',
    }
    
    # 中間記録コードマップは上記で定義済み（497行目～）
    
    def __init__(self, db_path: str = None):
        """初期化"""
        if db_path is None:
            # デフォルトのデータベースパスを探す
            db_files = sorted(Path('.').glob('tmcloud_v2_*.db'))
            if db_files:
                db_path = str(db_files[-1])
            else:
                raise FileNotFoundError("データベースファイルが見つかりません")
        
        self.db_path = db_path
        self.conn = None
        self.connect()
        
        # IN句の上限設定
        self.IN_CLAUSE_LIMIT = 400
        
        # ロガー設定
        self.logger = logging.getLogger(__name__)
        
        # JSONファイルから中間記録コードを読み込み
        self._load_code_mappings()
    
    def _load_code_mappings(self):
        """JSONファイルから各種コードマッピングを読み込み"""
        config_dir = Path(__file__).parent / "config" / "final"
        
        # 審査中間記録コード
        examination_json = config_dir / "examination_codes.json"
        if examination_json.exists():
            with open(examination_json, 'r', encoding='utf-8') as f:
                self.examination_codes = json.load(f)
                self.logger.info(f"審査中間記録コード読み込み成功: {len(self.examination_codes)}件")
        else:
            self.examination_codes = {}
            self.logger.warning("審査中間記録コードファイルが見つかりません")
        
        # 登録中間記録コード
        registration_json = config_dir / "registration_codes.json"
        if registration_json.exists():
            with open(registration_json, 'r', encoding='utf-8') as f:
                self.registration_codes = json.load(f)
                self.logger.info(f"登録中間記録コード読み込み成功: {len(self.registration_codes)}件")
        else:
            self.registration_codes = {}
            self.logger.warning("登録中間記録コードファイルが見つかりません")
        
        # 審判中間記録コード
        trial_json = config_dir / "trial_codes.json"
        if trial_json.exists():
            with open(trial_json, 'r', encoding='utf-8') as f:
                self.trial_codes = json.load(f)
                self.logger.info(f"審判中間記録コード読み込み成功: {len(self.trial_codes)}件")
        else:
            self.trial_codes = {}
            self.logger.warning("審判中間記録コードファイルが見つかりません")
        
        # マドプロ出願中間記録コード
        madrid_json = config_dir / "madrid_codes.json"
        if madrid_json.exists():
            with open(madrid_json, 'r', encoding='utf-8') as f:
                self.madrid_codes = json.load(f)
                self.logger.info(f"マドプロ出願中間記録コード読み込み成功: {len(self.madrid_codes)}件")
        else:
            self.madrid_codes = {}
            self.logger.warning("マドプロ出願中間記録コードファイルが見つかりません")
        
        # マドプロ原簿中間記録コード
        madrid_genbo_json = config_dir / "madrid_codes_genbo.json"
        if madrid_genbo_json.exists():
            with open(madrid_genbo_json, 'r', encoding='utf-8') as f:
                self.madrid_genbo_codes = json.load(f)
                self.logger.info(f"マドプロ原簿中間記録コード読み込み成功: {len(self.madrid_genbo_codes)}件")
        else:
            self.madrid_genbo_codes = {}
            self.logger.warning("マドプロ原簿中間記録コードファイルが見つかりません")
    
    def connect(self):
        """データベース接続"""
        try:
            self.conn = sqlite3.connect(self.db_path)
            self.conn.row_factory = sqlite3.Row  # 結果を辞書形式で取得
            
            # パフォーマンス設定
            self.conn.execute("PRAGMA journal_mode=WAL")
            self.conn.execute("PRAGMA synchronous=NORMAL")
            self.conn.execute("PRAGMA temp_store=MEMORY")
            self.conn.execute("PRAGMA cache_size=-1048576")  # 1GB cache
            
            # 必要なカラムとFTSテーブルの存在確認・作成
            self._ensure_required_columns_and_tables()
            
            print(f"データベース接続成功: {self.db_path}")
        except Exception as e:
            print(f"データベース接続エラー: {e}")
            sys.exit(1)
    
    def _ensure_required_columns_and_tables(self):
        """必要なカラムとFTSテーブルの存在確認・作成"""
        cursor = self.conn.cursor()
        
        # trademark_searchの_normカラム確認・追加
        cursor.execute("PRAGMA table_info(trademark_search)")
        cols = {row[1] for row in cursor.fetchall()}
        if 'search_use_t_norm' not in cols:
            try:
                cursor.execute("ALTER TABLE trademark_search ADD COLUMN search_use_t_norm TEXT")
                # 既存データの正規化（簡易版）
                cursor.execute("""
                    UPDATE trademark_search 
                    SET search_use_t_norm = UPPER(REPLACE(REPLACE(search_use_t, ' ', ''), '　', ''))
                    WHERE search_use_t_norm IS NULL
                """)
                self.conn.commit()
                print("search_use_t_normカラムを追加しました")
            except sqlite3.OperationalError:
                pass  # 既に存在する場合
        
        # trademark_pronunciationsの_normカラム確認・追加
        cursor.execute("PRAGMA table_info(trademark_pronunciations)")
        cols = {row[1] for row in cursor.fetchall()}
        if 'pronunciation_norm' not in cols:
            try:
                cursor.execute("ALTER TABLE trademark_pronunciations ADD COLUMN pronunciation_norm TEXT")
                # 既存データの正規化（簡易版）
                cursor.execute("""
                    UPDATE trademark_pronunciations 
                    SET pronunciation_norm = pronunciation
                    WHERE pronunciation_norm IS NULL
                """)
                self.conn.commit()
                print("pronunciation_normカラムを追加しました")
            except sqlite3.OperationalError:
                pass  # 既に存在する場合
        
        # FTSテーブルの確認・作成
        cursor.execute("SELECT name FROM sqlite_master WHERE type='table' AND name='trademark_search_fts'")
        if not cursor.fetchone():
            try:
                cursor.execute("""
                    CREATE VIRTUAL TABLE trademark_search_fts
                    USING fts5(
                        search_use_t,
                        content='trademark_search',
                        content_rowid='rowid',
                        tokenize='unicode61'
                    )
                """)
                # 初回データ同期
                cursor.execute("""
                    INSERT INTO trademark_search_fts(rowid, search_use_t)
                    SELECT rowid, search_use_t FROM trademark_search WHERE search_use_t IS NOT NULL
                """)
                self.conn.commit()
                print("trademark_search_ftsテーブルを作成しました")
            except sqlite3.OperationalError as e:
                print(f"FTSテーブル作成エラー: {e}")
        
        # trademark_draft_recordsテーブルの確認
        cursor.execute("SELECT name FROM sqlite_master WHERE type='table' AND name='trademark_draft_records'")
        if not cursor.fetchone():
            # テーブルが存在しない場合は警告を出す
            print("警告: trademark_draft_recordsテーブルが存在しません。拒絶条文・中間記録検索は利用できません。")
    
    # ========== 商標名検索（FTS5） ==========
    
    def search_trademark_name(self, keywords: str, limit: int = 100, unified_format: bool = True) -> List[Dict[str, Any]]:
        """商標名検索（TMSONAR準拠）
        
        Args:
            keywords: 検索キーワード（複数可、空白/カンマ区切り）
            limit: 最大取得件数
        
        Returns:
            検索結果リスト
        """
        terms = QueryParser.split_terms(keywords)
        if not terms:
            return []
        
        # 全指定の場合
        if terms == ['?']:
            return self._get_all_trademarks(limit)
        
        results = []
        for term in terms:
            # 正規化
            normalized = TextNormalizer.normalize_text_jp(term, for_trademark=True)
            
            if len(normalized) < 2:
                # 2文字未満はLIKE検索
                results.extend(self._search_trademark_like(normalized, limit))
            elif len(normalized) < 3:
                # 2文字はLIKE検索（trigramでは効果が薄い）
                results.extend(self._search_trademark_like(normalized, limit))
            else:
                # 3文字以上はFTS検索
                results.extend(self._search_trademark_fts(normalized, limit))
        
        # 重複除去
        seen = set()
        unique_results = []
        for r in results:
            if r['app_num'] not in seen:
                seen.add(r['app_num'])
                unique_results.append(r)
        
        # 統一フォーマットで返す
        if unified_format:
            app_nums = [r['app_num'] for r in unique_results[:limit]]
            # 検索固有データとして商標名検索の情報を含める
            search_specific = {
                r['app_num']: {
                    'matched_trademark': r.get('trademark_name'),
                    'search_term': keywords
                } for r in unique_results[:limit]
            }
            return self._format_unified_result(app_nums, search_specific)
        
        return unique_results[:limit]
        
    
    def _create_like_pattern(self, term: str) -> str:
        """ワイルドカードの位置に基づいてLIKEパターンを生成"""
        # ワイルドカード文字の判定
        has_prefix_wildcard = term.startswith('？') or term.startswith('?')
        has_suffix_wildcard = term.endswith('？') or term.endswith('?')
        
        # ワイルドカードを除去して実際の検索語を取得
        clean_term = term
        if has_prefix_wildcard:
            clean_term = clean_term[1:]
        if has_suffix_wildcard:
            clean_term = clean_term[:-1]
        
        # エスケープ処理
        escaped_term = QueryParser.wildcard_like(clean_term)
        
        # パターン生成
        if has_prefix_wildcard and has_suffix_wildcard:
            # ？xxx？ → 部分一致
            return f"%{escaped_term}%"
        elif has_suffix_wildcard:
            # xxx？ → 前方一致
            return f"{escaped_term}%"
        elif has_prefix_wildcard:
            # ？xxx → 後方一致
            return f"%{escaped_term}"
        else:
            # xxx → 完全一致
            return escaped_term
    
    def _search_trademark_like(self, term: str, limit: int) -> List[Dict[str, Any]]:
        """商標名LIKE検索"""
        pattern = self._create_like_pattern(term)
        cursor = self.conn.cursor()
        
        query = """
            SELECT 
                ts.app_num,
                tci.reg_article_reg_num as reg_num,
                -- 商標名の優先順位: 商標見本→標準文字→表示用商標
                COALESCE(
                    td.indct_use_t,
                    tsc.standard_char_t,
                    ts.search_use_t
                ) as trademark_name,
                tci.app_date,
                tci.reg_date,
                tci.final_disposition_type,
                tci.law_code,
                tci.class_count
            FROM trademark_search ts
            INNER JOIN trademark_case_info tci ON ts.app_num = tci.app_num
            LEFT JOIN trademark_display td ON tci.app_num = td.app_num
            LEFT JOIN trademark_standard_char tsc ON tci.app_num = tsc.app_num
            WHERE ts.search_use_t_norm LIKE ? ESCAPE '\\'
            ORDER BY tci.app_date DESC
            LIMIT ?
        """
        
        cursor.execute(query, (pattern, limit))
        return [dict(row) for row in cursor.fetchall()]
    
    def _create_fts_pattern(self, term: str) -> str:
        """ワイルドカードの位置に基づいてFTSパターンを生成"""
        # ワイルドカード文字の判定
        has_prefix_wildcard = term.startswith('？') or term.startswith('?')
        has_suffix_wildcard = term.endswith('？') or term.endswith('?')
        
        # ワイルドカードを除去して実際の検索語を取得
        clean_term = term
        if has_prefix_wildcard:
            clean_term = clean_term[1:]
        if has_suffix_wildcard:
            clean_term = clean_term[:-1]
        
        # FTSパターン生成
        if has_prefix_wildcard and has_suffix_wildcard:
            # ？xxx？ → 部分一致（*xxx*）
            return f"*{clean_term}*"
        elif has_suffix_wildcard:
            # xxx？ → 前方一致（xxx*）
            return f"{clean_term}*"
        elif has_prefix_wildcard:
            # ？xxx → 後方一致（*xxx）
            return f"*{clean_term}"
        else:
            # xxx → 完全一致（ダブルクォートで囲む）
            return f'"{clean_term}"'
    
    def _search_trademark_fts(self, term: str, limit: int) -> List[Dict[str, Any]]:
        """商標名FTS検索"""
        cursor = self.conn.cursor()
        
        # FTS用にワイルドカードパターンを生成
        fts_pattern = self._create_fts_pattern(term)
        
        query = """
            SELECT 
                ts.app_num,
                tci.reg_article_reg_num as reg_num,
                -- 商標名の優先順位: 商標見本→標準文字→表示用商標
                COALESCE(
                    td.indct_use_t,
                    tsc.standard_char_t,
                    ts.search_use_t
                ) as trademark_name,
                tci.app_date,
                tci.reg_date,
                tci.final_disposition_type,
                tci.law_code,
                tci.class_count
            FROM trademark_search_fts fts
            JOIN trademark_search ts ON fts.rowid = ts.rowid
            INNER JOIN trademark_case_info tci ON ts.app_num = tci.app_num
            LEFT JOIN trademark_display td ON tci.app_num = td.app_num
            LEFT JOIN trademark_standard_char tsc ON tci.app_num = tsc.app_num
            WHERE fts MATCH ?
            ORDER BY tci.app_date DESC
            LIMIT ?
        """
        
        try:
            cursor.execute(query, (fts_pattern, limit))
            return [dict(row) for row in cursor.fetchall()]
        except sqlite3.OperationalError:
            # FTSテーブルが存在しない場合はLIKE検索にフォールバック
            return self._search_trademark_like(term, limit)
    
    def _get_all_trademarks(self, limit: int) -> List[Dict[str, Any]]:
        """全商標取得"""
        cursor = self.conn.cursor()
        query = """
            SELECT 
                ts.app_num,
                tci.reg_article_reg_num as reg_num,
                -- 商標名の優先順位: 商標見本→標準文字→表示用商標
                COALESCE(
                    td.indct_use_t,
                    tsc.standard_char_t,
                    ts.search_use_t
                ) as trademark_name,
                tci.app_date,
                tci.reg_date,
                tci.final_disposition_type,
                tci.law_code,
                tci.class_count
            FROM trademark_search ts
            LEFT JOIN trademark_case_info tci ON ts.app_num = tci.app_num
            LEFT JOIN trademark_display td ON tci.app_num = td.app_num
            LEFT JOIN trademark_standard_char tsc ON tci.app_num = tsc.app_num
            ORDER BY tci.app_date DESC
            LIMIT ?
        """
        
        cursor.execute(query, (limit,))
        return [dict(row) for row in cursor.fetchall()]
    
    # ========== 称呼検索（TMSONAR準拠） ==========
    
    def search_phonetic(self, keywords: str, limit: int = 100, unified_format: bool = True) -> List[Dict[str, Any]]:
        """称呼検索（TMSONAR準拠）
        
        Args:
            keywords: 検索キーワード（複数可）
            limit: 最大取得件数
            unified_format: 統一フォーマットで返すか
        
        Returns:
            検索結果リスト
        """
        terms = QueryParser.split_terms(keywords)
        if not terms:
            return []
        
        # 全指定の場合
        if terms == ['?']:
            if unified_format:
                results = self._get_all_phonetics(limit)
                app_nums = [r['app_num'] for r in results if r.get('app_num')]
                search_specific = {
                    r['app_num']: {
                        'matched_phonetic': r.get('pronunciation'),
                        'search_term': keywords
                    } for r in results if r.get('app_num')
                }
                return self._format_unified_result(app_nums[:limit], search_specific)
            else:
                return self._get_all_phonetics(limit)
        
        results = []
        for term in terms:
            # 正規化（ワイルドカード判定前に元の形を保持）
            has_prefix_wildcard = term.startswith('？') or term.startswith('?')
            has_suffix_wildcard = term.endswith('？') or term.endswith('?')
            
            # ワイルドカードを除去してから正規化
            clean_term = term
            if has_prefix_wildcard:
                clean_term = clean_term[1:]
            if has_suffix_wildcard:
                clean_term = clean_term[:-1]
            
            normalized = TextNormalizer.normalize_kana_for_pron(clean_term)
            escaped = QueryParser.wildcard_like(normalized)
            
            # パターン生成
            if has_prefix_wildcard and has_suffix_wildcard:
                # ？xxx？ → 部分一致
                pattern = f"%{escaped}%"
            elif has_suffix_wildcard:
                # xxx？ → 前方一致
                pattern = f"{escaped}%"
            elif has_prefix_wildcard:
                # ？xxx → 後方一致
                pattern = f"%{escaped}"
            else:
                # xxx → 完全一致
                pattern = escaped
            
            cursor = self.conn.cursor()
            # シンプルなクエリ：出願番号でGROUP BYして重複を除去
            query = """
                SELECT 
                    tp.app_num,
                    GROUP_CONCAT(DISTINCT tp.pronunciation) as pronunciation,
                    COALESCE(
                        td.indct_use_t,
                        tsc.standard_char_t,
                        ts.search_use_t
                    ) as trademark_name,
                    tci.app_date,
                    tci.reg_date,
                    tci.final_disposition_type,
                    tci.law_code,
                    tci.class_count
                FROM trademark_pronunciations tp
                INNER JOIN trademark_case_info tci ON tp.app_num = tci.app_num
                LEFT JOIN trademark_search ts ON tp.app_num = ts.app_num
                LEFT JOIN trademark_display td ON tp.app_num = td.app_num
                LEFT JOIN trademark_standard_char tsc ON tp.app_num = tsc.app_num
                WHERE tp.pronunciation_norm LIKE ? ESCAPE '\\'
                GROUP BY tp.app_num
                ORDER BY tci.app_date DESC
                LIMIT ?
            """
            
            cursor.execute(query, (pattern, limit))
            results.extend([dict(row) for row in cursor.fetchall()])
        
        # 重複除去（出願番号単位）
        seen = set()
        unique_results = []
        for r in results:
            if r['app_num'] not in seen:
                seen.add(r['app_num'])
                unique_results.append(r)
        
        # 統一フォーマットで返す
        if unified_format:
            app_nums = [r['app_num'] for r in unique_results[:limit]]
            search_specific = {
                r['app_num']: {
                    'matched_phonetic': r.get('pronunciation'),
                    'search_term': keywords
                } for r in unique_results[:limit]
            }
            return self._format_unified_result(app_nums, search_specific)
        else:
            return unique_results[:limit]
    
    def _get_all_phonetics(self, limit: int) -> List[Dict[str, Any]]:
        """全称呼取得"""
        cursor = self.conn.cursor()
        
        query = """
            SELECT DISTINCT
                tp.app_num,
                tp.pronunciation,
                COALESCE(
                    td.indct_use_t,
                    tsc.standard_char_t,
                    ts.search_use_t
                ) as trademark_name,
                tci.app_date,
                tci.reg_date,
                tci.final_disposition_type,
                tci.law_code,
                tci.class_count
            FROM trademark_pronunciations tp
            LEFT JOIN trademark_search ts ON tp.app_num = ts.app_num
            LEFT JOIN trademark_display td ON tp.app_num = td.app_num
            LEFT JOIN trademark_standard_char tsc ON tp.app_num = tsc.app_num
            LEFT JOIN trademark_case_info tci ON tp.app_num = tci.app_num
            ORDER BY tci.app_date DESC
            LIMIT ?
        """
        
        cursor.execute(query, (limit,))
        return [dict(row) for row in cursor.fetchall()]
    
    # ========== 番号検索 ==========
    
    def search_by_app_num(self, app_num: str, unified_format: bool = True) -> Optional[Dict[str, Any]]:
        """出願番号による検索"""
        if not app_num:
            return None
        
        # 番号の正規化（ハイフンを除去）
        app_num = app_num.replace('-', '').replace('－', '')
        
        cursor = self.conn.cursor()
        
        query = """
            SELECT 
                tci.app_num,
                tci.reg_article_reg_num as reg_num,
                ts.search_use_t as trademark_name,
                tci.app_date,
                tci.reg_date,
                tci.pub_article_gazette_date as public_date,
                tci.final_disposition_type as final_disposition_code,
                tci.final_disposition_date,
                tci.law_code || '-' || tci.class_count as class_info,
                '' as right_holder_name,
                '' as right_holder_address
            FROM trademark_case_info tci
            LEFT JOIN trademark_search ts ON tci.app_num = ts.app_num
            WHERE tci.app_num = ?
        """
        
        cursor.execute(query, (app_num,))
        row = cursor.fetchone()
        
        if row:
            if unified_format:
                # 統一フォーマットで返す
                search_specific = {
                    app_num: {
                        'search_type': 'app_num',
                        'search_term': app_num
                    }
                }
                return self._format_unified_result([app_num], search_specific)[0] if self._format_unified_result([app_num], search_specific) else None
            else:
                return dict(row)
        return None
    
    def search_by_reg_num(self, reg_num: str, unified_format: bool = True) -> Optional[Dict[str, Any]]:
        """登録番号による検索
        
        Args:
            reg_num: 登録番号
            unified_format: 統一フォーマットで返すか
        
        Returns:
            検索結果（単一）
        """
        if not reg_num:
            return None
        
        # 番号の正規化
        reg_num = reg_num.replace('-', '').replace('－', '')
        
        cursor = self.conn.cursor()
        
        # シンプルなクエリ
        query = """
            SELECT 
                tci.app_num,
                tci.reg_article_reg_num as reg_num,
                ts.search_use_t as trademark_name,
                tci.app_date,
                tci.reg_date,
                tci.pub_article_gazette_date as public_date,
                tci.final_disposition_type as final_disposition_code,
                tci.final_disposition_date,
                tci.law_code,
                tci.class_count
            FROM trademark_case_info tci
            LEFT JOIN trademark_search ts ON tci.app_num = ts.app_num
            WHERE tci.reg_article_reg_num = ?
        """
        
        cursor.execute(query, (reg_num,))
        row = cursor.fetchone()
        
        if row:
            if unified_format:
                # 統一フォーマットで返す
                app_num = row['app_num']
                search_specific = {
                    app_num: {
                        'search_type': 'reg_num',
                        'search_term': reg_num
                    }
                }
                results = self._format_unified_result([app_num], search_specific)
                return results[0] if results else None
            else:
                return dict(row)
        return None
    
    def search_by_intl_reg_num(self, intl_reg_num: str, limit: int = 100, unified_format: bool = True) -> List[Dict[str, Any]]:
        """国際登録番号による検索
        
        Args:
            intl_reg_num: 国際登録番号（部分一致も可）
            limit: 最大取得件数
            unified_format: 統一フォーマットで返すか
        
        Returns:
            検索結果リスト
        """
        if not intl_reg_num:
            return []
        
        cursor = self.conn.cursor()
        
        # 番号の正規化（必要に応じて）
        intl_reg_num = intl_reg_num.strip()
        
        # 7桁の完全な番号でない場合は部分一致検索
        if len(intl_reg_num) != 7 or not intl_reg_num.isdigit():
            # 部分一致検索
            query = """
                SELECT 
                    tbi.app_num,
                    tbi.intl_reg_num,
                    ts.search_use_t as trademark_name,
                    CASE 
                        WHEN tbi.instllmnt_expr_date_aft_des_date != '' AND tbi.instllmnt_expr_date_aft_des_date != '00000000' 
                        THEN tbi.instllmnt_expr_date_aft_des_date
                        ELSE tbi.intl_reg_date
                    END as app_date,
                    tbi.set_reg_date as reg_date,
                    tbi.final_disposition_date as final_disposition_type,
                    tbi.law_code_applied as law_code,
                    tbi.goods_classes_count as class_count
                FROM trademark_basic_items tbi
                LEFT JOIN trademark_search ts ON tbi.app_num = ts.app_num
                WHERE tbi.intl_reg_num LIKE ?
                AND tbi.intl_reg_num NOT LIKE '0000000'
                AND tbi.app_num LIKE '____35%'
                ORDER BY tbi.intl_reg_num
                LIMIT ?
            """
            cursor.execute(query, (f'%{intl_reg_num}%', limit))
        else:
            # 完全一致検索
            query = """
                SELECT 
                    tbi.app_num,
                    tbi.intl_reg_num,
                    ts.search_use_t as trademark_name,
                    CASE 
                        WHEN tbi.instllmnt_expr_date_aft_des_date != '' AND tbi.instllmnt_expr_date_aft_des_date != '00000000' 
                        THEN tbi.instllmnt_expr_date_aft_des_date
                        ELSE tbi.intl_reg_date
                    END as app_date,
                    tbi.set_reg_date as reg_date,
                    tbi.final_disposition_date as final_disposition_type,
                    tbi.law_code_applied as law_code,
                    tbi.goods_classes_count as class_count
                FROM trademark_basic_items tbi
                LEFT JOIN trademark_search ts ON tbi.app_num = ts.app_num
                WHERE tbi.intl_reg_num = ?
                AND tbi.app_num LIKE '____35%'
                LIMIT ?
            """
            cursor.execute(query, (intl_reg_num, limit))
        
        rows = cursor.fetchall()
        
        if unified_format and rows:
            # マドプロ出願はtrademark_case_infoに存在しないため、直接フォーマット
            results = []
            for row in rows:
                # 基本情報を取得
                app_num = row['app_num']
                
                # 追加情報の取得
                cursor.execute("""
                    SELECT 
                        GROUP_CONCAT(DISTINCT pronunciation) as phonetics
                    FROM trademark_pronunciations
                    WHERE app_num = ?
                """, (app_num,))
                phonetics_row = cursor.fetchone()
                
                # 名義人（holder）取得
                cursor.execute("""
                    SELECT 
                        GROUP_CONCAT(DISTINCT holder_name) as applicants
                    FROM intl_trademark_holders
                    WHERE intl_reg_num = ?
                """, (row['intl_reg_num'],))
                applicants_row = cursor.fetchone()
                
                # 区分（madpro_class）取得
                cursor.execute("""
                    SELECT 
                        GROUP_CONCAT(DISTINCT madpro_class) as classes
                    FROM intl_trademark_goods_services
                    WHERE intl_reg_num = ?
                """, (row['intl_reg_num'],))
                classes_row = cursor.fetchone()
                
                # 商品・役務（英語・日本語）取得
                cursor.execute("""
                    SELECT madpro_class, goods_service_name
                    FROM intl_trademark_goods_services
                    WHERE intl_reg_num = ?
                """, (row['intl_reg_num'],))
                goods_services = {}
                for gs_row in cursor.fetchall():
                    if gs_row['madpro_class'] and gs_row['goods_service_name']:
                        cls = str(gs_row['madpro_class'])
                        if cls not in goods_services:
                            goods_services[cls] = []
                        goods_services[cls].append(gs_row['goods_service_name'])
                
                # 日本語の商品・役務を追加
                cursor.execute("""
                    SELECT madpro_class, goods_service_japanese_name
                    FROM intl_trademark_goods_services_jp
                    WHERE jpo_rfr_num = ?
                """, (app_num,))
                for gs_row in cursor.fetchall():
                    if gs_row['madpro_class'] and gs_row['goods_service_japanese_name']:
                        cls = str(gs_row['madpro_class'])
                        if cls not in goods_services:
                            goods_services[cls] = []
                        goods_services[cls].append(f"（日）{gs_row['goods_service_japanese_name']}")
                
                # 商品・役務リストを結合
                for cls in goods_services:
                    goods_services[cls] = '、'.join(goods_services[cls])
                
                # 結果を統一フォーマットで構築
                result = {
                    'basic_info': {
                        'app_num': app_num,
                        'intl_reg_num': row['intl_reg_num'],
                        'trademark_name': row['trademark_name'],
                        'app_date': row['app_date'],
                        'reg_date': row['reg_date'],
                        'final_disposition_type': row['final_disposition_type'],
                        'law_code': row['law_code'],
                        'class_count': row['class_count'],
                        'phonetics': phonetics_row['phonetics'].split(',') if phonetics_row and phonetics_row['phonetics'] else [],
                        'applicants': applicants_row['applicants'].split(',') if applicants_row and applicants_row['applicants'] else [],
                        'classes': classes_row['classes'].split(',') if classes_row and classes_row['classes'] else [],
                        'goods_services': goods_services,
                        'similar_groups': {},
                        'vienna_codes': [],
                        'rejection_codes': [],
                        'appeal_nums': [],
                        'appeal_types': [],
                        'progress_records': {},
                        'intermediate_records': {}
                    },
                    'search_specific': {
                        'search_type': 'intl_reg_num',
                        'search_term': intl_reg_num
                    }
                }
                results.append(result)
            
            return results
        else:
            return [dict(row) for row in rows]
    
    # ========== 日付範囲検索 ==========
    
    def search_by_date_range(
        self, 
        date_type: str, 
        start_date: str, 
        end_date: str, 
        limit: int = 100,
        unified_format: bool = False
    ) -> List[Dict[str, Any]]:
        """日付範囲検索（国内案件とマドプロ案件の両方を検索）
        
        Args:
            date_type: 'app_date'（出願日）, 'reg_date'（登録日）, 'pub_date'（公開日）
            start_date: 開始日（YYYY-MM-DD, YYYY/MM/DD, YYYYMMDD, 和暦形式など）
            end_date: 終了日（YYYY-MM-DD, YYYY/MM/DD, YYYYMMDD, 和暦形式など）
            limit: 最大取得件数
        """
        if date_type not in ['app_date', 'reg_date', 'pub_article_gazette_date']:
            raise ValueError("date_typeは'app_date', 'reg_date', 'pub_article_gazette_date'のいずれかを指定してください")
        
        # 日付を正規化（YYYYMMDD形式に変換）
        # 範囲指定(:)がある場合もparse_date_rangeで処理
        if start_date and ':' in start_date:
            # start_dateに範囲指定が含まれている場合
            norm_start, norm_end = QueryParser.parse_date_range(start_date)
        else:
            # 個別に指定されている場合
            norm_start = QueryParser._parse_single_date(start_date) if start_date else None
            norm_end = QueryParser._parse_single_date(end_date) if end_date else None
        
        if not norm_start and not norm_end:
            return []
        
        cursor = self.conn.cursor()
        results = []
        
        # WHERE句とパラメータを構築
        if norm_start and norm_end:
            where_clause = f"{date_type} BETWEEN ? AND ?"
            params = [norm_start, norm_end]
        elif norm_start:
            where_clause = f"{date_type} >= ?"
            params = [norm_start]
        else:
            where_clause = f"{date_type} <= ?"
            params = [norm_end]
        
        # 1. 国内案件を検索（trademark_case_info）
        query_domestic = f"""
            SELECT 
                tci.app_num,
                tci.reg_article_reg_num as reg_num,
                ts.search_use_t as trademark_name,
                tci.app_date,
                tci.reg_date,
                tci.pub_article_gazette_date as public_date,
                tci.final_disposition_type as final_disposition_code,
                tci.final_disposition_date,
                tci.law_code || '-' || tci.class_count as class_info
            FROM trademark_case_info tci
            LEFT JOIN trademark_search ts ON tci.app_num = ts.app_num
            WHERE tci.{where_clause}
            ORDER BY tci.{date_type} DESC
            LIMIT ?
        """
        
        cursor.execute(query_domestic, params + [limit])
        for row in cursor.fetchall():
            results.append(dict(row))
        
        # 2. マドプロ案件を検索（trademark_basic_items）
        # マドプロの日付フィールドマッピング
        madrid_date_mapping = {
            'app_date': """CASE 
                            WHEN tbi.instllmnt_expr_date_aft_des_date != '' AND tbi.instllmnt_expr_date_aft_des_date != '00000000' 
                            THEN tbi.instllmnt_expr_date_aft_des_date
                            ELSE tbi.intl_reg_date
                          END""",
            'reg_date': 'tbi.set_reg_date',
            'pub_article_gazette_date': 'tbi.intl_reg_date'  # マドプロには公開日がないので国際登録日を使用
        }
        
        madrid_date_field = madrid_date_mapping.get(date_type, 'tbi.intl_reg_date')
        
        # マドプロ用のWHERE句を構築
        if norm_start and norm_end:
            madrid_where = f"{madrid_date_field} BETWEEN ? AND ?"
            madrid_params = [norm_start, norm_end]
        elif norm_start:
            madrid_where = f"{madrid_date_field} >= ?"
            madrid_params = [norm_start]
        else:
            madrid_where = f"{madrid_date_field} <= ?"
            madrid_params = [norm_end]
        
        query_madrid = f"""
            SELECT 
                tbi.app_num,
                tbi.intl_reg_num,
                ts.search_use_t as trademark_name,
                {madrid_date_field} as app_date,
                tbi.set_reg_date as reg_date,
                tbi.intl_reg_date as public_date,
                tbi.final_disposition_code,
                tbi.final_disposition_date,
                tbi.old_law as class_info
            FROM trademark_basic_items tbi
            LEFT JOIN trademark_search ts ON tbi.app_num = ts.app_num
            WHERE {madrid_where}
            AND tbi.app_num LIKE '____35%'
            ORDER BY {madrid_date_field} DESC
            LIMIT ?
        """
        
        cursor.execute(query_madrid, madrid_params + [limit])
        for row in cursor.fetchall():
            madrid_result = dict(row)
            # reg_numがない場合は国際登録番号を使用
            if not madrid_result.get('reg_num'):
                madrid_result['reg_num'] = madrid_result.get('intl_reg_num', '')
            results.append(madrid_result)
        
        # 結果を日付でソート（降順）して上限件数まで返す
        results.sort(key=lambda x: x.get(date_type, ''), reverse=True)
        return results[:limit]
    
    # ========== 最終処分コード定義（補助ボタン用） ==========
    
    FINAL_DISPOSITION_CODES = {
        'A01': '登録査定',
        'A02': '拒絶査定',
        'A03': '審決（請求成立）',
        'A04': '審決（請求不成立）',
        'A05': '審決（請求却下）',
        'A06': '審決（無効）',
        'A07': '審決（取消）',
        'A20': '出願取下',
        'A21': '出願放棄',
        'A22': '出願却下',
        'A23': '書換登録申請却下',
        'A30': '存続期間満了',
        'A31': '商標権消滅',
        'A32': '無効',
        'A33': '取消',
        'A40': '放棄（全部）',
        'A41': '放棄（一部）',
        'A42': '出願却下（方式却理）',
        'A43': '出願却下（方式指令）',
        'A44': '異議申立係属中',
        'A45': '却下処分',
        'A46': '審査中',
        'A47': '方式審査中'
    }
    
    # ========== 最終処分検索（TMSONAR ID:130） ==========
    
    def search_by_final_disposition(self, codes: str, limit: int = 100) -> List[Dict[str, Any]]:
        """最終処分による検索（TMSONAR ID:130）
        
        Args:
            codes: 最終処分コード（複数可、スペース/カンマ区切り）
                   例: A01:登録査定, A02:拒絶査定, A0?:査定系全部
                   ?で全指定
            limit: 最大取得件数
        
        Returns:
            検索結果リスト
        """
        terms = QueryParser.split_terms(codes)
        if not terms or terms == ['?']:
            return self._get_all_final_dispositions(limit)
        
        cursor = self.conn.cursor()
        results = []
        
        for term in terms:
            if term.endswith('?'):
                # 前方一致検索
                prefix = term[:-1]
                query = """
                    SELECT DISTINCT
                        tci.app_num,
                        tci.final_disposition_type,
                        tci.final_disposition_date,
                        ts.search_use_t as trademark_name,
                        tci.app_date,
                        tci.reg_date,
                        tci.reg_article_reg_num as reg_num,
                        tci.law_code,
                        tci.class_count
                    FROM trademark_case_info tci
                    LEFT JOIN trademark_search ts ON tci.app_num = ts.app_num
                    WHERE tci.final_disposition_type LIKE ? ESCAPE '\\'
                    ORDER BY tci.app_date DESC
                    LIMIT ?
                """
                pattern = prefix.replace('_', '\\_').replace('%', '\\%') + '%'
                cursor.execute(query, (pattern, limit))
            else:
                # 完全一致検索
                query = """
                    SELECT DISTINCT
                        tci.app_num,
                        tci.final_disposition_type,
                        tci.final_disposition_date,
                        ts.search_use_t as trademark_name,
                        tci.app_date,
                        tci.reg_date,
                        tci.reg_article_reg_num as reg_num,
                        tci.law_code,
                        tci.class_count
                    FROM trademark_case_info tci
                    LEFT JOIN trademark_search ts ON tci.app_num = ts.app_num
                    WHERE tci.final_disposition_type = ?
                    ORDER BY tci.app_date DESC
                    LIMIT ?
                """
                cursor.execute(query, (term, limit))
            
            results.extend([dict(row) for row in cursor.fetchall()])
        
        # 重複除去
        seen = set()
        unique_results = []
        for r in results:
            if r['app_num'] not in seen:
                seen.add(r['app_num'])
                unique_results.append(r)
        
        return unique_results[:limit]
    
    def _get_all_final_dispositions(self, limit: int) -> List[Dict[str, Any]]:
        """全最終処分取得"""
        cursor = self.conn.cursor()
        query = """
            SELECT DISTINCT
                tci.app_num,
                tci.final_disposition_type,
                tci.final_disposition_date,
                ts.search_use_t as trademark_name,
                tci.app_date,
                tci.reg_date,
                tci.reg_article_reg_num as reg_num,
                tci.law_code,
                tci.class_count
            FROM trademark_case_info tci
            LEFT JOIN trademark_search ts ON tci.app_num = ts.app_num
            WHERE tci.final_disposition_type IS NOT NULL AND tci.final_disposition_type != ''
            ORDER BY tci.app_date DESC
            LIMIT ?
        """
        cursor.execute(query, (limit,))
        return [dict(row) for row in cursor.fetchall()]
    
    # ========== ステータス検索（旧インターフェース、互換性維持） ==========
    
    def search_by_status(
        self, 
        final_disposition_type: str = None, 
        final_disposition_date: str = None,
        law_code: str = None,
        class_count: str = None,
        limit: int = 100
    ) -> List[Dict[str, Any]]:
        """ステータス検索
        
        Args:
            final_disposition_type: 最終処分種別
            final_disposition_date: 最終処分日
            law_code: 四法コード
            class_count: 区分数
            limit: 最大取得件数
        """
        cursor = self.conn.cursor()
        
        conditions = []
        params = []
        
        if final_disposition_type:
            conditions.append("tci.final_disposition_type = ?")
            params.append(final_disposition_type)
        
        if final_disposition_date:
            conditions.append("tci.final_disposition_date = ?")
            params.append(final_disposition_date)
        
        if law_code:
            conditions.append("tci.law_code = ?")
            params.append(law_code)
        
        if class_count:
            conditions.append("tci.class_count = ?")
            params.append(class_count)
        
        if not conditions:
            return []
        
        where_clause = " AND ".join(conditions)
        
        query = f"""
            SELECT 
                tci.app_num,
                tci.reg_article_reg_num as reg_num,
                ts.search_use_t as trademark_name,
                tci.app_date,
                tci.reg_date,
                tci.final_disposition_type as final_disposition_code,
                tci.final_disposition_date,
                tci.law_code || '-' || tci.class_count as class_info
            FROM trademark_case_info tci
            LEFT JOIN trademark_search ts ON tci.app_num = ts.app_num
            WHERE {where_clause}
            ORDER BY tci.app_date DESC
            LIMIT ?
        """
        
        params.append(limit)
        cursor.execute(query, params)
        
        results = []
        for row in cursor.fetchall():
            results.append(dict(row))
        
        return results
    
    # ========== 国際分類（類展開）検索（TMSONAR ID:104） ==========
    
    def search_by_international_class(self, class_nums: str, limit: int = 100) -> List[Dict[str, Any]]:
        """国際分類（類似群コード展開）検索（TMSONAR ID:104）
        
        Args:
            class_nums: 類番号（複数可、スペース/カンマ区切り）
                       例: '09', '09,42', '01 03 05'
                       2桁類番号を指定すると、その類に属する類似群コードに展開
            limit: 最大取得件数
        
        Returns:
            検索結果リスト
        """
        terms = QueryParser.split_terms(class_nums)
        if not terms or terms == ['?']:
            return self._get_all_class_items(limit)
        
        cursor = self.conn.cursor()
        results = []
        
        for class_num in terms:
            # 2桁にゼロパディング
            class_num = class_num.zfill(2)
            
            # その類番号を持つ商標を検索
            query = """
                SELECT DISTINCT
                    tsgc.app_num,
                    tsgc.class_num,
                    tsgc.similar_group_codes,
                    ts.search_use_t as trademark_name,
                    tci.app_date,
                    tci.reg_date,
                    tci.reg_article_reg_num as reg_num,
                    tci.final_disposition_type,
                    tci.law_code,
                    tci.class_count
                FROM trademark_similar_group_codes tsgc
                LEFT JOIN trademark_search ts ON tsgc.app_num = ts.app_num
                LEFT JOIN trademark_case_info tci ON tsgc.app_num = tci.app_num
                WHERE tsgc.class_num = ?
                ORDER BY tci.app_date DESC
                LIMIT ?
            """
            cursor.execute(query, (class_num, limit))
            results.extend([dict(row) for row in cursor.fetchall()])
        
        # 重複除去
        seen = set()
        unique_results = []
        for r in results:
            if r['app_num'] not in seen:
                seen.add(r['app_num'])
                unique_results.append(r)
        
        return unique_results[:limit]
    
    def _get_all_class_items(self, limit: int) -> List[Dict[str, Any]]:
        """全類の商標取得"""
        cursor = self.conn.cursor()
        query = """
            SELECT DISTINCT
                tsgc.app_num,
                tsgc.class_num,
                tsgc.similar_group_codes,
                ts.search_use_t as trademark_name,
                tci.app_date,
                tci.reg_date,
                tci.reg_article_reg_num as reg_num,
                tci.final_disposition_type,
                tci.law_code,
                tci.class_count
            FROM trademark_similar_group_codes tsgc
            LEFT JOIN trademark_search ts ON tsgc.app_num = ts.app_num
            LEFT JOIN trademark_case_info tci ON tsgc.app_num = tci.app_num
            WHERE tsgc.class_num IS NOT NULL
            ORDER BY tci.app_date DESC
            LIMIT ?
        """
        cursor.execute(query, (limit,))
        return [dict(row) for row in cursor.fetchall()]
    
    # ========== 類似群コード検索 ==========
    
    def search_by_similar_group(self, codes: str, limit: int = 100, unified_format: bool = True) -> List[Dict[str, Any]]:
        """類似群コード検索（TMSONAR準拠）
        
        Args:
            codes: 類似群コード（複数可、末尾?で前方一致）
            limit: 最大取得件数
            unified_format: 統一フォーマットで返すか
        
        Returns:
            検索結果リスト
        """
        terms = QueryParser.split_terms(codes)
        if not terms:
            return []
        
        # 全指定の場合
        if terms == ['?']:
            results = self._get_all_similar_groups(limit)
            if unified_format:
                app_nums = [r['app_num'] for r in results]
                search_specific = {
                    r['app_num']: {
                        'matched_similar_group': r.get('similar_group_codes'),
                        'search_term': codes
                    } for r in results
                }
                return self._format_unified_result(app_nums, search_specific)
            else:
                return results
        
        results = []
        for term in terms:
            cursor = self.conn.cursor()
            
            if term.endswith('?') or term.endswith('？'):
                # 前方一致
                prefix = term[:-1]
                # カンマ区切りを考慮：先頭、中間、末尾のいずれかでマッチ
                pattern = f"%{prefix}%"
                where_clause = """(
                    tsgc.similar_group_codes LIKE ? OR
                    tsgc.similar_group_codes LIKE ? OR
                    tsgc.similar_group_codes LIKE ?
                )"""
                params = (f"{prefix}%", f"%,{prefix}%", f"%,{prefix}")
            else:
                # 完全一致
                # カンマ区切りを考慮：先頭、中間、末尾のいずれかで完全一致
                where_clause = """(
                    tsgc.similar_group_codes = ? OR
                    tsgc.similar_group_codes LIKE ? OR
                    tsgc.similar_group_codes LIKE ? OR
                    tsgc.similar_group_codes LIKE ?
                )"""
                params = (term, f"{term},%", f"%,{term},%", f"%,{term}")
            
            query = f"""
                SELECT DISTINCT
                    tsgc.app_num,
                    tsgc.similar_group_codes,
                    COALESCE(
                        td.indct_use_t,
                        tsc.standard_char_t,
                        ts.search_use_t
                    ) as trademark_name,
                    tci.app_date,
                    tci.reg_date,
                    tci.final_disposition_type,
                    tci.law_code,
                    tci.class_count
                FROM trademark_similar_group_codes tsgc
                INNER JOIN trademark_case_info tci ON tsgc.app_num = tci.app_num
                LEFT JOIN trademark_search ts ON tsgc.app_num = ts.app_num
                LEFT JOIN trademark_display td ON tsgc.app_num = td.app_num
                LEFT JOIN trademark_standard_char tsc ON tsgc.app_num = tsc.app_num
                WHERE {where_clause}
                ORDER BY tci.app_date DESC
                LIMIT ?
            """
            
            cursor.execute(query, params + (limit,))
            results.extend([dict(row) for row in cursor.fetchall()])
        
        # 重複除去
        seen = set()
        unique_results = []
        for r in results:
            if r['app_num'] not in seen:
                seen.add(r['app_num'])
                unique_results.append(r)
        
        # 統一フォーマットで返す
        if unified_format:
            app_nums = [r['app_num'] for r in unique_results[:limit]]
            search_specific = {
                r['app_num']: {
                    'matched_similar_group': r.get('similar_group_codes'),
                    'search_term': codes
                } for r in unique_results[:limit]
            }
            return self._format_unified_result(app_nums, search_specific)
        else:
            return unique_results[:limit]
    
    def _get_all_similar_groups(self, limit: int) -> List[Dict[str, Any]]:
        """全類似群コード取得"""
        cursor = self.conn.cursor()
        query = """
            SELECT DISTINCT
                tsgc.app_num,
                tsgc.similar_group_codes,
                COALESCE(
                    td.indct_use_t,
                    tsc.standard_char_t,
                    ts.search_use_t
                ) as trademark_name,
                tci.app_date,
                tci.reg_date,
                tci.final_disposition_type,
                tci.law_code,
                tci.class_count
            FROM trademark_similar_group_codes tsgc
            INNER JOIN trademark_case_info tci ON tsgc.app_num = tci.app_num
            LEFT JOIN trademark_search ts ON tsgc.app_num = ts.app_num
            LEFT JOIN trademark_display td ON tsgc.app_num = td.app_num
            LEFT JOIN trademark_standard_char tsc ON tsgc.app_num = tsc.app_num
            ORDER BY tci.app_date DESC
            LIMIT ?
        """
        cursor.execute(query, (limit,))
        return [dict(row) for row in cursor.fetchall()]
    
    # ========== 商品・役務検索 ==========
    
    def search_goods_services(self, keywords: str, limit: int = 100, item_and: bool = True, unified_format: bool = True) -> List[Dict[str, Any]]:
        """指定商品/役務検索（TMSONAR準拠）
        
        注意: trademark_goods_servicesテーブルには正規化カラム（goods_services_name_norm）が
              存在しないため、オリジナルテキストに対してLIKE検索を行う。
              将来的にDB改修で正規化カラムを追加すれば、より高精度な検索が可能。
        
        Args:
            keywords: 検索キーワード（複数可）
            limit: 最大取得件数
            item_and: True=項目内AND, False=項目間AND
            unified_format: 統一フォーマットで返すか
        
        Returns:
            検索結果リスト
        """
        terms = QueryParser.split_terms(keywords)
        if not terms or terms == ['?']:
            return self._get_all_goods_services(limit)
        
        # 各キーワードを正規化
        # ※DBに正規化カラムがないため、検索パターンを正規化してLIKE検索
        normalized_terms = []
        for term in terms:
            # ワイルドカード判定
            has_prefix_wildcard = term.startswith('？') or term.startswith('?')
            has_suffix_wildcard = term.endswith('？') or term.endswith('?')
            
            # ワイルドカードを除去して正規化
            clean_term = term
            if has_prefix_wildcard:
                clean_term = clean_term[1:]
            if has_suffix_wildcard:
                clean_term = clean_term[:-1]
            
            normalized = TextNormalizer.normalize_text_jp(clean_term)
            escaped = QueryParser.wildcard_like(normalized)
            
            # パターン生成
            if has_prefix_wildcard and has_suffix_wildcard:
                # ？xxx？ → 部分一致
                pattern = f"%{escaped}%"
            elif has_suffix_wildcard:
                # xxx？ → 前方一致
                pattern = f"{escaped}%"
            elif has_prefix_wildcard:
                # ？xxx → 後方一致
                pattern = f"%{escaped}"
            else:
                # xxx → 完全一致
                pattern = escaped
            
            normalized_terms.append(pattern)
        
        cursor = self.conn.cursor()
        
        if item_and:
            # 項目内AND（同一goods_seq_num内で全キーワードがマッチ）
            conditions = []
            for pattern in normalized_terms:
                conditions.append(f"goods_services_name LIKE ? ESCAPE '\\'") 
            
            where_clause = " AND ".join(conditions)
            
            query = f"""
                SELECT DISTINCT
                    tgs.app_num,
                    tgs.class_num,
                    tgs.goods_services_name,
                    COALESCE(
                        td.indct_use_t,
                        tsc.standard_char_t,
                        ts.search_use_t
                    ) as trademark_name,
                    tci.app_date,
                    tci.reg_date,
                    tci.final_disposition_type,
                    tci.law_code,
                    tci.class_count
                FROM trademark_goods_services tgs
                INNER JOIN trademark_case_info tci ON tgs.app_num = tci.app_num
                LEFT JOIN trademark_search ts ON tgs.app_num = ts.app_num
                LEFT JOIN trademark_display td ON tgs.app_num = td.app_num
                LEFT JOIN trademark_standard_char tsc ON tgs.app_num = tsc.app_num
                WHERE {where_clause}
                ORDER BY tci.app_date DESC
                LIMIT ?
            """
            
            params = normalized_terms + [limit]
            cursor.execute(query, params)
            results = [dict(row) for row in cursor.fetchall()]
        else:
            # 項目間AND（異なるgoods_seq_numでもOK）- 簡略化した実装
            results = self._search_goods_services_between_items(normalized_terms, limit, unified_format)
        
        if unified_format:
            app_nums = [r['app_num'] for r in results]
            search_specific = {
                r['app_num']: {
                    'matched_goods_services': r.get('goods_services_name'),
                    'search_term': keywords
                } for r in results
            }
            return self._format_unified_result(app_nums, search_specific)
        else:
            return results
    
    def _search_goods_services_between_items(self, patterns: List[str], limit: int, unified_format: bool = True) -> List[Dict[str, Any]]:
        """項目間AND検索"""
        # 各パターンでマッチする出願番号を取得
        cursor = self.conn.cursor()
        app_num_sets = []
        
        for pattern in patterns:
            query = """
                SELECT DISTINCT app_num
                FROM trademark_goods_services
                WHERE goods_services_name LIKE ? ESCAPE '\\'
            """
            cursor.execute(query, (pattern,))
            app_nums = {row[0] for row in cursor.fetchall()}
            app_num_sets.append(app_nums)
        
        # 全パターンにマッチする出願番号の交差を取る
        if app_num_sets:
            common_app_nums = set.intersection(*app_num_sets)
        else:
            return []
        
        if not common_app_nums:
            return []
        
        # IN句の制限とlimitを考慮
        app_nums_list = list(common_app_nums)[:min(limit, self.IN_CLAUSE_LIMIT)]
        
        # 結果を取得
        placeholders = ','.join(['?'] * len(app_nums_list))
        query = f"""
            SELECT DISTINCT
                tgs.app_num,
                tgs.class_num,
                GROUP_CONCAT(DISTINCT tgs.goods_services_name, '; ') as goods_services_name,
                COALESCE(
                    td.indct_use_t,
                    tsc.standard_char_t,
                    ts.search_use_t
                ) as trademark_name,
                tci.app_date,
                tci.reg_date,
                tci.final_disposition_type,
                tci.law_code,
                tci.class_count
            FROM trademark_goods_services tgs
            INNER JOIN trademark_case_info tci ON tgs.app_num = tci.app_num
            LEFT JOIN trademark_search ts ON tgs.app_num = ts.app_num
            LEFT JOIN trademark_display td ON tgs.app_num = td.app_num
            LEFT JOIN trademark_standard_char tsc ON tgs.app_num = tsc.app_num
            WHERE tgs.app_num IN ({placeholders})
            GROUP BY tgs.app_num, tgs.class_num
            ORDER BY tci.app_date DESC
            LIMIT ?
        """
        
        params = app_nums_list + [limit]
        cursor.execute(query, params)
        results = [dict(row) for row in cursor.fetchall()]
        
        # unified_formatは呼び出し元で処理されるので、ここでは結果を返すだけ
        return results
    
    def _get_all_goods_services(self, limit: int) -> List[Dict[str, Any]]:
        """全商品/役務取得"""
        cursor = self.conn.cursor()
        query = """
            SELECT DISTINCT
                tgs.app_num,
                tgs.class_num,
                tgs.goods_services_name,
                ts.search_use_t as trademark_name,
                tci.app_date,
                tci.reg_date,
                tci.final_disposition_type,
                tci.law_code,
                tci.class_count
            FROM trademark_goods_services tgs
            LEFT JOIN trademark_search ts ON tgs.app_num = ts.app_num
            LEFT JOIN trademark_case_info tci ON tgs.app_num = tci.app_num
            ORDER BY tci.app_date DESC
            LIMIT ?
        """
        cursor.execute(query, (limit,))
        return [dict(row) for row in cursor.fetchall()]
    
    # ========== 出願人/権利者検索 ==========
    
    def search_applicant(self, keywords: str, limit: int = 100, use_or: bool = False, unified_format: bool = True) -> List[Dict[str, Any]]:
        """出願人/権利者検索（type-102）
        
        Args:
            keywords: 検索キーワード（複数可、スペース=AND、カンマ=OR）
            limit: 最大取得件数
            use_or: True=OR検索、False=AND検索（スペース区切り時）
            unified_format: 統一フォーマットで返すか
        
        Returns:
            検索結果リスト
        """
        # カンマ区切りは常にOR
        if ',' in keywords or '，' in keywords:
            terms = QueryParser.split_terms(keywords)
            use_or = True
        else:
            # スペース区切り
            terms = keywords.split()
        
        if not terms or terms == ['?']:
            return self._get_all_applicants(limit)
        
        # 各キーワードを正規化（会社種別除去）と半角・全角両パターン生成
        normalized_terms = []
        for term in terms:
            # ワイルドカード判定
            has_prefix_wildcard = term.startswith('？') or term.startswith('?')
            has_suffix_wildcard = term.endswith('？') or term.endswith('?')
            
            # ワイルドカードを除去
            clean_term = term
            if has_prefix_wildcard:
                clean_term = clean_term[1:]
            if has_suffix_wildcard:
                clean_term = clean_term[:-1]
            
            # 正規化（NFKC変換で全角→半角に統一、会社種別除去）
            normalized = TextNormalizer.normalize_company_name(clean_term)
            escaped = QueryParser.wildcard_like(normalized)
            
            # パターン生成
            if has_prefix_wildcard and has_suffix_wildcard:
                # ？xxx？ → 部分一致
                pattern_base = f"%{escaped}%"
            elif has_suffix_wildcard:
                # xxx？ → 前方一致
                pattern_base = f"{escaped}%"
            elif has_prefix_wildcard:
                # ？xxx → 後方一致
                pattern_base = f"%{escaped}"
            else:
                # xxx → 完全一致
                pattern_base = escaped
            
            # 半角パターン
            normalized_terms.append(pattern_base)
            
            # 全角パターンも生成（半角英数字を全角に変換）
            zenkaku = ''
            for c in escaped:  # エスケープ済みの文字列を使用
                if 'A' <= c <= 'Z':
                    zenkaku += chr(ord(c) - ord('A') + ord('Ａ'))
                elif 'a' <= c <= 'z':
                    zenkaku += chr(ord(c) - ord('a') + ord('ａ'))
                elif '0' <= c <= '9':
                    zenkaku += chr(ord(c) - ord('0') + ord('０'))
                else:
                    zenkaku += c
            
            # 全角パターンも同じワイルドカード位置を適用
            if has_prefix_wildcard and has_suffix_wildcard:
                pattern_zenkaku = f"%{zenkaku}%"
            elif has_suffix_wildcard:
                pattern_zenkaku = f"{zenkaku}%"
            elif has_prefix_wildcard:
                pattern_zenkaku = f"%{zenkaku}"
            else:
                pattern_zenkaku = zenkaku
            
            normalized_terms.append(pattern_zenkaku)
        
        cursor = self.conn.cursor()
        
        # WHERE句構築（申請人マスタの名前は正規化後にマッチング）
        conditions = []
        for i in range(0, len(normalized_terms), 2):  # 半角と全角のペアで処理
            # 申請人名を正規化してマッチング（会社種別除去）＋ 半角・全角両方でマッチ
            conditions.append("""(
                REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
                    COALESCE(ari.applicant_name, ''),
                    '株式会社', ''), '有限会社', ''), '合同会社', ''),
                    '合資会社', ''), '合名会社', ''), '一般社団法人', '')
                LIKE ? OR 
                REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(
                    COALESCE(ari.applicant_name, ''),
                    '株式会社', ''), '有限会社', ''), '合同会社', ''),
                    '合資会社', ''), '合名会社', ''), '一般社団法人', '')
                LIKE ? OR
                taa.applicant_agent_code LIKE ? OR
                taa.applicant_agent_code LIKE ?
            )""")
        
        if use_or:
            where_clause = " OR ".join(conditions)
        else:
            where_clause = " AND ".join(conditions)
        
        # パラメータ構築（半角・全角の各パターンを2回使用）
        params = []
        for i in range(0, len(normalized_terms), 2):
            params.extend([normalized_terms[i], normalized_terms[i+1], normalized_terms[i], normalized_terms[i+1]])
        params.append(limit)
        
        query = f"""
            SELECT DISTINCT
                taa.app_num,
                ari.applicant_name as applicant_name,
                ari.applicant_address as applicant_address,
                COALESCE(
                    td.indct_use_t,
                    tsc.standard_char_t,
                    ts.search_use_t
                ) as trademark_name,
                tci.app_date,
                tci.reg_date,
                tci.reg_article_reg_num as reg_num,
                tci.final_disposition_type,
                tci.law_code,
                tci.class_count
            FROM trademark_applicants_agents taa
            INNER JOIN applicant_registration_info ari 
                ON taa.applicant_agent_code = ari.applicant_code
            LEFT JOIN trademark_search ts ON taa.app_num = ts.app_num
            LEFT JOIN trademark_display td ON taa.app_num = td.app_num
            LEFT JOIN trademark_standard_char tsc ON taa.app_num = tsc.app_num
            INNER JOIN trademark_case_info tci ON taa.app_num = tci.app_num
            WHERE ({where_clause})
            AND ari.applicant_name IS NOT NULL
            AND taa.applicant_agent_type = '1'
            ORDER BY tci.app_date DESC
            LIMIT ?
        """
        
        # 構築したパラメータを使用
        cursor.execute(query, params)
        results = [dict(row) for row in cursor.fetchall()]
        
        # 統一フォーマットで返す
        if unified_format:
            app_nums = [r['app_num'] for r in results if r.get('app_num')]
            search_specific = {
                r['app_num']: {
                    'matched_applicant': r.get('applicant_name'),
                    'search_term': keywords
                } for r in results if r.get('app_num')
            }
            return self._format_unified_result(app_nums[:limit], search_specific)
        else:
            return results
    
    def _get_all_applicants(self, limit: int) -> List[Dict[str, Any]]:
        """全出願人取得"""
        cursor = self.conn.cursor()
        query = """
            SELECT DISTINCT
                taa.app_num,
                taa.applicant_name,
                taa.agent_name,
                ts.search_use_t as trademark_name,
                tci.app_date,
                tci.reg_date,
                tci.reg_article_reg_num as reg_num,
                tci.final_disposition_type,
                tci.law_code,
                tci.class_count
            FROM trademark_applicants_agents taa
            LEFT JOIN trademark_search ts ON taa.app_num = ts.app_num
            LEFT JOIN trademark_case_info tci ON taa.app_num = tci.app_num
            WHERE taa.applicant_name IS NOT NULL
            ORDER BY tci.app_date DESC
            LIMIT ?
        """
        cursor.execute(query, (limit,))
        return [dict(row) for row in cursor.fetchall()]
    
    # ========== 法区分＋類検索 ==========
    
    def search_by_law_class(self, expr: str, limit: int = 100) -> List[Dict[str, Any]]:
        """法区分＋類検索（TMSONAR ID:105）
        
        Args:
            expr: 検索式（例: 'Y01', '?09', 'W?'）
                - 完全一致: 'Y01' (法区分Y、類01)
                - 類のみ: '?09' (任意の法区分、類09)
                - 法区分のみ: 'W?' (法区分W、任意の類)
                - 全指定: '?' または空文字
            limit: 最大取得件数
        
        Returns:
            検索結果リスト
        """
        if not expr or expr.strip() in ['？', '?']:
            # 全指定
            return self._get_all_law_class(limit)
        
        law_code, class_num = QueryParser.parse_law_class(expr)
        
        cursor = self.conn.cursor()
        conditions = []
        params = []
        
        if law_code:
            conditions.append("tci.law_code = ?")
            params.append(law_code)
        
        if class_num:
            # class_numは2桁の文字列として扱う
            # trademark_goods_servicesテーブルのclass_numと結合
            conditions.append("tgs.class_num = ?")
            params.append(class_num)
        
        if not conditions:
            return []
        
        where_clause = " AND ".join(conditions)
        params.append(limit)
        
        query = f"""
            SELECT DISTINCT
                tci.app_num,
                tci.reg_article_reg_num as reg_num,
                ts.search_use_t as trademark_name,
                tci.law_code,
                tgs.class_num,
                tci.law_code || tgs.class_num as law_class,
                tci.app_date,
                tci.reg_date,
                tci.final_disposition_type,
                tci.class_count
            FROM trademark_case_info tci
            LEFT JOIN trademark_goods_services tgs ON tci.app_num = tgs.app_num
            LEFT JOIN trademark_search ts ON tci.app_num = ts.app_num
            WHERE {where_clause}
            ORDER BY tci.app_date DESC
            LIMIT ?
        """
        
        cursor.execute(query, params)
        return [dict(row) for row in cursor.fetchall()]
    
    def _get_all_law_class(self, limit: int) -> List[Dict[str, Any]]:
        """全法区分＋類取得"""
        cursor = self.conn.cursor()
        query = """
            SELECT DISTINCT
                tci.app_num,
                tci.reg_article_reg_num as reg_num,
                ts.search_use_t as trademark_name,
                tci.law_code,
                tgs.class_num,
                tci.law_code || tgs.class_num as law_class,
                tci.app_date,
                tci.reg_date,
                tci.final_disposition_type,
                tci.class_count
            FROM trademark_case_info tci
            LEFT JOIN trademark_goods_services tgs ON tci.app_num = tgs.app_num
            LEFT JOIN trademark_search ts ON tci.app_num = ts.app_num
            ORDER BY tci.app_date DESC
            LIMIT ?
        """
        cursor.execute(query, (limit,))
        return [dict(row) for row in cursor.fetchall()]
    
    # ========== ウィーンコード検索 ==========
    
    def search_by_vienna_code(self, codes: str, limit: int = 100, unified_format: bool = True) -> List[Dict[str, Any]]:
        """ウィーンコード検索（TMSONAR ID:112）
        
        Args:
            codes: ウィーンコード（複数可、スペース/カンマ区切り）
                  階層的前方一致対応（例: '1.3.20' → '1.3.20.01'等を含む）
            limit: 最大取得件数
            unified_format: 統一フォーマットで返すか
        
        Returns:
            検索結果リスト
        """
        terms = QueryParser.split_terms(codes)
        if not terms or terms == ['?']:
            results = self._get_all_vienna_codes(limit)
            if unified_format:
                app_nums = [r['app_num'] for r in results]
                search_specific = {
                    r['app_num']: {
                        'matched_vienna_codes': r.get('vienna_codes'),
                        'search_term': codes
                    } for r in results
                }
                return self._format_unified_result(app_nums, search_specific)
            else:
                return results
        
        results = []
        for term in terms:
            cursor = self.conn.cursor()
            
            # ウィーンコードの階層分解（大分類.中分類.小分類.細分類）
            parts = term.split('.')
            conditions = []
            params = []
            
            if len(parts) >= 1 and parts[0]:
                # 大分類の処理（?で前方一致対応）
                if '?' in parts[0]:
                    # 前方一致検索
                    prefix = parts[0].replace('?', '')
                    if prefix:
                        conditions.append("large_class LIKE ?")
                        params.append(prefix.zfill(2) + '%')
                    # ?のみの場合は条件を追加しない（全件取得）
                else:
                    # 完全一致
                    large_class = parts[0].zfill(2)
                    conditions.append("large_class = ?")
                    params.append(large_class)
            
            if len(parts) >= 2 and parts[1]:
                # 中分類も2桁でゼロパディング
                mid_class = parts[1].zfill(2)
                conditions.append("mid_class = ?")
                params.append(mid_class)
            
            if len(parts) >= 3 and parts[2]:
                # 小分類も2桁でゼロパディング
                small_class = parts[2].zfill(2)
                conditions.append("small_class = ?")
                params.append(small_class)
            
            if len(parts) >= 4 and parts[3]:
                # 細分類も2桁でゼロパディング
                complement = parts[3].zfill(2)
                conditions.append("complement_sub_class = ?")
                params.append(complement)
            
            if not conditions:
                continue
            
            where_clause = " AND ".join(conditions)
            params.append(limit)
            
            query = f"""
                WITH vienna_matches AS (
                    SELECT DISTINCT
                        app_num,
                        CASE 
                            WHEN complement_sub_class = '00' AND small_class = '00' AND mid_class = '00' THEN large_class
                            WHEN complement_sub_class = '00' AND small_class = '00' THEN large_class || '.' || mid_class
                            WHEN complement_sub_class = '00' THEN large_class || '.' || mid_class || '.' || small_class
                            ELSE large_class || '.' || mid_class || '.' || small_class || '.' || complement_sub_class
                        END as vienna_code
                    FROM trademark_vienna_codes
                    WHERE {where_clause}
                ),
                vienna_grouped AS (
                    SELECT 
                        app_num,
                        GROUP_CONCAT(vienna_code, ', ') as vienna_codes
                    FROM vienna_matches
                    GROUP BY app_num
                )
                SELECT 
                    vg.app_num,
                    vg.vienna_codes,
                    ts.search_use_t as trademark_name,
                    tci.app_date,
                    tci.reg_date,
                    tci.reg_article_reg_num as reg_num,
                    tci.final_disposition_type,
                    tci.law_code,
                    tci.class_count
                FROM vienna_grouped vg
                LEFT JOIN trademark_search ts ON vg.app_num = ts.app_num
                LEFT JOIN trademark_case_info tci ON vg.app_num = tci.app_num
                ORDER BY tci.app_date DESC
                LIMIT ?
            """
            
            cursor.execute(query, params)
            results.extend([dict(row) for row in cursor.fetchall()])
        
        # 重複除去（app_numベースで）
        seen = set()
        unique_results = []
        for r in results:
            if r['app_num'] not in seen:
                seen.add(r['app_num'])
                unique_results.append(r)
        
        # 統一フォーマットで返す
        if unified_format:
            app_nums = [r['app_num'] for r in unique_results[:limit]]
            search_specific = {
                r['app_num']: {
                    'matched_vienna_codes': r.get('vienna_codes'),
                    'search_term': codes
                } for r in unique_results[:limit]
            }
            return self._format_unified_result(app_nums, search_specific)
        else:
            return unique_results[:limit]
    
    def _get_all_vienna_codes(self, limit: int) -> List[Dict[str, Any]]:
        """全ウィーンコード取得"""
        cursor = self.conn.cursor()
        query = """
            WITH vienna_all AS (
                SELECT DISTINCT
                    app_num,
                    CASE 
                        WHEN complement_sub_class = '00' AND small_class = '00' AND mid_class = '00' THEN large_class
                        WHEN complement_sub_class = '00' AND small_class = '00' THEN large_class || '.' || mid_class
                        WHEN complement_sub_class = '00' THEN large_class || '.' || mid_class || '.' || small_class
                        ELSE large_class || '.' || mid_class || '.' || small_class || '.' || complement_sub_class
                    END as vienna_code
                FROM trademark_vienna_codes
            ),
            vienna_grouped AS (
                SELECT 
                    app_num,
                    GROUP_CONCAT(vienna_code, ', ') as vienna_codes
                FROM vienna_all
                GROUP BY app_num
            )
            SELECT 
                vg.app_num,
                vg.vienna_codes,
                ts.search_use_t as trademark_name,
                tci.app_date,
                tci.reg_date,
                tci.reg_article_reg_num as reg_num,
                tci.final_disposition_type,
                tci.law_code,
                tci.class_count
            FROM vienna_grouped vg
            LEFT JOIN trademark_search ts ON vg.app_num = ts.app_num
            LEFT JOIN trademark_case_info tci ON vg.app_num = tci.app_num
            ORDER BY tci.app_date DESC
            LIMIT ?
        """
        cursor.execute(query, (limit,))
        return [dict(row) for row in cursor.fetchall()]
    
    # ========== 商標の詳細な説明検索 ==========
    
    def search_detailed_description(self, keywords: str, limit: int = 100) -> List[Dict[str, Any]]:
        """商標の詳細な説明検索（TMSONAR ID:126）
        
        Args:
            keywords: 検索キーワード（複数可、部分一致）
            limit: 最大取得件数
        
        Returns:
            検索結果リスト
        """
        terms = QueryParser.split_terms(keywords)
        if not terms or terms == ['?']:
            return self._get_all_detailed_descriptions(limit)
        
        results = []
        for term in terms:
            # ワイルドカード判定
            has_prefix_wildcard = term.startswith('？') or term.startswith('?')
            has_suffix_wildcard = term.endswith('？') or term.endswith('?')
            
            # ワイルドカードを除去して正規化
            clean_term = term
            if has_prefix_wildcard:
                clean_term = clean_term[1:]
            if has_suffix_wildcard:
                clean_term = clean_term[:-1]
            
            normalized = TextNormalizer.normalize_text_jp(clean_term)
            escaped = QueryParser.wildcard_like(normalized)
            
            # パターン生成
            if has_prefix_wildcard and has_suffix_wildcard:
                # ？xxx？ → 部分一致
                pattern = f"%{escaped}%"
            elif has_suffix_wildcard:
                # xxx？ → 前方一致
                pattern = f"{escaped}%"
            elif has_prefix_wildcard:
                # ？xxx → 後方一致
                pattern = f"%{escaped}"
            else:
                # xxx → 完全一致
                pattern = escaped
            
            cursor = self.conn.cursor()
            query = """
                SELECT DISTINCT
                    tdd.app_num,
                    tdd.detailed_description,
                    ts.search_use_t as trademark_name,
                    tci.app_date,
                    tci.reg_date,
                    tci.reg_article_reg_num as reg_num,
                    tci.final_disposition_type,
                    tci.law_code,
                    tci.class_count
                FROM trademark_detailed_descriptions tdd
                LEFT JOIN trademark_search ts ON tdd.app_num = ts.app_num
                LEFT JOIN trademark_case_info tci ON tdd.app_num = tci.app_num
                WHERE tdd.detailed_description LIKE ? ESCAPE '\\'
                ORDER BY tci.app_date DESC
                LIMIT ?
            """
            
            cursor.execute(query, (pattern, limit))
            results.extend([dict(row) for row in cursor.fetchall()])
        
        # 重複除去
        seen = set()
        unique_results = []
        for r in results:
            if r['app_num'] not in seen:
                seen.add(r['app_num'])
                unique_results.append(r)
        
        return unique_results[:limit]
    
    def _get_all_detailed_descriptions(self, limit: int) -> List[Dict[str, Any]]:
        """全詳細説明取得"""
        cursor = self.conn.cursor()
        query = """
            SELECT DISTINCT
                tdd.app_num,
                tdd.detailed_description,
                ts.search_use_t as trademark_name,
                tci.app_date,
                tci.reg_date,
                tci.reg_article_reg_num as reg_num,
                tci.final_disposition_type,
                tci.law_code,
                tci.class_count
            FROM trademark_detailed_descriptions tdd
            LEFT JOIN trademark_search ts ON tdd.app_num = ts.app_num
            LEFT JOIN trademark_case_info tci ON tdd.app_num = tci.app_num
            ORDER BY tci.app_date DESC
            LIMIT ?
        """
        cursor.execute(query, (limit,))
        return [dict(row) for row in cursor.fetchall()]
    
    # ========== 出願種別検索 ==========
    
    def search_by_app_type(self, types: str, limit: int = 100) -> List[Dict[str, Any]]:
        """出願種別検索（TMSONAR ID:127）
        
        Args:
            types: 出願種別コード（複数可、スペース/カンマ区切り）
                  01:通常, 02:分割, 03:変更, 04:優先, 06:防護, 07:防護更新,
                  08:団体, 09:地域団体, 10:連合, 11:書換, 13:重複, 14:国際
            limit: 最大取得件数
        
        Returns:
            検索結果リスト
        """
        terms = QueryParser.split_terms(types)
        if not terms or terms == ['?']:
            return self._get_all_app_types(limit)
        
        # app_type1〜app_type5のいずれかに指定コードが含まれる商標を検索
        cursor = self.conn.cursor()
        
        # OR条件構築（各typeについて、app_type1〜5のいずれかでマッチ）
        type_conditions = []
        params = []
        for type_code in terms:
            type_code = type_code.zfill(2)  # 2桁にゼロパディング
            subconditions = []
            for i in range(1, 6):
                subconditions.append(f"tci.app_type{i} = ?")
                params.append(type_code)
            type_conditions.append(f"({' OR '.join(subconditions)})")
        
        where_clause = " OR ".join(type_conditions)
        params.append(limit)
        
        query = f"""
            SELECT DISTINCT
                tci.app_num,
                tci.app_type1,
                tci.app_type2,
                tci.app_type3,
                tci.app_type4,
                tci.app_type5,
                ts.search_use_t as trademark_name,
                tci.app_date,
                tci.reg_date,
                tci.reg_article_reg_num as reg_num,
                tci.final_disposition_type,
                tci.law_code,
                tci.class_count
            FROM trademark_case_info tci
            LEFT JOIN trademark_search ts ON tci.app_num = ts.app_num
            WHERE {where_clause}
            ORDER BY tci.app_date DESC
            LIMIT ?
        """
        
        cursor.execute(query, params)
        return [dict(row) for row in cursor.fetchall()]
    
    def _get_all_app_types(self, limit: int) -> List[Dict[str, Any]]:
        """全出願種別取得"""
        cursor = self.conn.cursor()
        query = """
            SELECT DISTINCT
                tci.app_num,
                tci.app_type1,
                tci.app_type2,
                tci.app_type3,
                tci.app_type4,
                tci.app_type5,
                ts.search_use_t as trademark_name,
                tci.app_date,
                tci.reg_date,
                tci.reg_article_reg_num as reg_num,
                tci.final_disposition_type,
                tci.law_code,
                tci.class_count
            FROM trademark_case_info tci
            LEFT JOIN trademark_search ts ON tci.app_num = ts.app_num
            WHERE tci.app_type1 IS NOT NULL
            ORDER BY tci.app_date DESC
            LIMIT ?
        """
        cursor.execute(query, (limit,))
        return [dict(row) for row in cursor.fetchall()]
    
    # ========== 商標タイプ検索（簡易版） ==========
    
    def search_by_trademark_type(self, type_expr: str, limit: int = 100, unified_format: bool = True) -> List[Dict[str, Any]]:
        """商標タイプ検索（TMSONAR ID:125 - 完全版）
        
        Args:
            type_expr: 検索する商標タイプ
                      '通常': 通常商標
                      '標準文字': 標準文字商標
                      '立体商標': 立体商標
                      '音商標': 音商標
                      '動き商標': 動き商標
                      'ホログラム商標': ホログラム商標
                      '色彩のみからなる商標': 色彩商標
                      '位置商標': 位置商標
                      'その他の商標': その他
                      '?': 全指定
            limit: 最大取得件数
        
        Returns:
            検索結果リスト
        """
        if not type_expr or type_expr.strip() in ['？', '?']:
            return self._get_all_trademark_types(limit)
        
        cursor = self.conn.cursor()
        
        # 商標タイプ名から対応する条件を生成
        if type_expr == '標準文字':
            # 標準文字商標の検索
            query = """
                SELECT DISTINCT
                    tci.app_num,
                    tci.standard_char_exist,
                    tci.special_mark_exist,
                    ts.search_use_t as trademark_name,
                    tsc.standard_char_t,
                    tci.app_date,
                    tci.reg_date,
                    tci.reg_article_reg_num as reg_num,
                    tci.final_disposition_type,
                    tci.law_code,
                    tci.class_count
                FROM trademark_case_info tci
                LEFT JOIN trademark_search ts ON tci.app_num = ts.app_num
                LEFT JOIN trademark_standard_char tsc ON tci.app_num = tsc.app_num
                WHERE tci.standard_char_exist = '1'
                ORDER BY tci.app_date DESC
                LIMIT ?
            """
            cursor.execute(query, (limit,))
            
        elif type_expr == '通常':
            # 通常商標の検索（標準文字でも特殊商標でもない）
            query = """
                SELECT DISTINCT
                    tci.app_num,
                    tci.standard_char_exist,
                    tci.special_mark_exist,
                    ts.search_use_t as trademark_name,
                    tci.app_date,
                    tci.reg_date,
                    tci.reg_article_reg_num as reg_num,
                    tci.final_disposition_type,
                    tci.law_code,
                    tci.class_count
                FROM trademark_case_info tci
                LEFT JOIN trademark_search ts ON tci.app_num = ts.app_num
                WHERE (tci.standard_char_exist IS NULL OR tci.standard_char_exist != '1')
                  AND (tci.special_mark_exist IS NULL OR tci.special_mark_exist = '0')
                ORDER BY tci.app_date DESC
                LIMIT ?
            """
            cursor.execute(query, (limit,))
            
        else:
            # 特殊商標タイプの検索
            # SPECIAL_MARK_TYPE_MAPの逆引き
            special_mark_code = None
            for code, name in self.SPECIAL_MARK_TYPE_MAP.items():
                if name == type_expr:
                    special_mark_code = code
                    break
            
            if special_mark_code:
                query = """
                    SELECT DISTINCT
                        tci.app_num,
                        tci.standard_char_exist,
                        tci.special_mark_exist,
                        ts.search_use_t as trademark_name,
                        tci.app_date,
                        tci.reg_date,
                        tci.reg_article_reg_num as reg_num,
                        tci.final_disposition_type,
                        tci.law_code,
                        tci.class_count
                    FROM trademark_case_info tci
                    LEFT JOIN trademark_search ts ON tci.app_num = ts.app_num
                    WHERE tci.special_mark_exist = ?
                    ORDER BY tci.app_date DESC
                    LIMIT ?
                """
                cursor.execute(query, (special_mark_code, limit))
            else:
                return []
        
        # 結果を処理して商標タイプを追加
        results = []
        for row in cursor.fetchall():
            row_dict = dict(row)
            # 商標タイプを判定して追加
            row_dict['trademark_type'] = self._determine_trademark_type(row_dict)
            results.append(row_dict)
        return results
    
    def _get_all_trademark_types(self, limit: int) -> List[Dict[str, Any]]:
        """全商標タイプ取得"""
        cursor = self.conn.cursor()
        query = """
            SELECT DISTINCT
                tci.app_num,
                tci.standard_char_exist,
                tci.special_mark_exist,
                ts.search_use_t as trademark_name,
                tci.app_date,
                tci.reg_date,
                tci.reg_article_reg_num as reg_num,
                tci.final_disposition_type,
                tci.law_code,
                tci.class_count
            FROM trademark_case_info tci
            LEFT JOIN trademark_search ts ON tci.app_num = ts.app_num
            ORDER BY tci.app_date DESC
            LIMIT ?
        """
        cursor.execute(query, (limit,))
        # 結果を処理して商標タイプを追加
        results = []
        for row in cursor.fetchall():
            row_dict = dict(row)
            # 商標タイプを判定して追加
            row_dict['trademark_type'] = self._determine_trademark_type(row_dict)
            results.append(row_dict)
        return results
    
    # ========== 統合検索インターフェース ==========
    
    def search(
        self, 
        search_type: SearchType,
        keyword: str = None,
        **kwargs
    ) -> List[Dict[str, Any]]:
        """統合検索インターフェース
        
        Args:
            search_type: 検索タイプ（SearchType enum）
            keyword: 検索キーワード
            **kwargs: 検索タイプごとの追加パラメータ
        
        Returns:
            検索結果のリスト
        """
        start_time = time.time()
        
        try:
            if search_type == SearchType.TRADEMARK:
                results = self.search_trademark_name(keyword, kwargs.get('limit', 100))
            
            elif search_type == SearchType.PHONETIC:
                results = self.search_phonetic(keyword, kwargs.get('limit', 100))
            
            elif search_type == SearchType.APP_NUM:
                result = self.search_by_app_num(keyword)
                results = [result] if result else []
            
            elif search_type == SearchType.REG_NUM:
                result = self.search_by_reg_num(keyword)
                results = [result] if result else []
            
            elif search_type == SearchType.DATE_RANGE:
                results = self.search_by_date_range(
                    kwargs.get('date_type', 'app_date'),
                    kwargs.get('start_date'),
                    kwargs.get('end_date'),
                    kwargs.get('limit', 100)
                )
            
            elif search_type == SearchType.STATUS:
                results = self.search_by_status(
                    kwargs.get('final_disposition_type'),
                    kwargs.get('final_disposition_date'),
                    kwargs.get('law_code'),
                    kwargs.get('class_count'),
                    kwargs.get('limit', 100)
                )
            
            elif search_type == SearchType.SIMILAR_GROUP:
                results = self.search_by_similar_group(keyword, kwargs.get('limit', 100))
            
            elif search_type == SearchType.GOODS_SERVICES:
                results = self.search_goods_services(
                    keyword, 
                    kwargs.get('limit', 100),
                    kwargs.get('item_and', True)
                )
            
            elif search_type == SearchType.APPLICANT:
                results = self.search_applicant(
                    keyword,
                    kwargs.get('limit', 100),
                    kwargs.get('use_or', False)
                )
            
            elif search_type == SearchType.LAW_CLASS:
                results = self.search_by_law_class(keyword, kwargs.get('limit', 100))
            
            elif search_type == SearchType.VIENNA_CODE:
                results = self.search_by_vienna_code(keyword, kwargs.get('limit', 100))
            
            elif search_type == SearchType.DETAILED_DESC:
                results = self.search_detailed_description(keyword, kwargs.get('limit', 100))
            
            elif search_type == SearchType.TRADEMARK_TYPE:
                results = self.search_by_trademark_type(keyword, kwargs.get('limit', 100))
            
            elif search_type == SearchType.APP_TYPE:
                results = self.search_by_app_type(keyword, kwargs.get('limit', 100))
            
            elif search_type == SearchType.REJECTION_CODE:
                results = self.search_by_rejection_code(keyword, kwargs.get('limit', 100))
            
            elif search_type == SearchType.INTERMEDIATE_CODE:
                results = self.search_by_intermediate_code(keyword, kwargs.get('limit', 100))
            
            elif search_type == SearchType.APPLICANT_ADDRESS:
                results = self.search_by_applicant_address(keyword, kwargs.get('limit', 100))
            
            elif search_type == SearchType.TRADEMARK_LENGTH:
                results = self.search_by_trademark_length(keyword, kwargs.get('limit', 100))
            
            elif search_type == SearchType.PHONETIC_LENGTH:
                results = self.search_by_phonetic_length(keyword, kwargs.get('limit', 100))
            
            elif search_type == SearchType.CLASS_COUNT:
                results = self.search_by_class_count(keyword, kwargs.get('limit', 100))
            
            elif search_type == SearchType.APPLICANT_COUNT:
                results = self.search_by_applicant_count(keyword, kwargs.get('limit', 100))
            
            elif search_type == SearchType.PHONETIC_COUNT:
                results = self.search_by_phonetic_count(keyword, kwargs.get('limit', 100))
            
            elif search_type == SearchType.ADDITIONAL_INFO:
                results = self.search_by_additional_info(keyword, kwargs.get('limit', 100))
            
            elif search_type == SearchType.COUNTRY_CODE:
                results = self.search_by_country_code(keyword, kwargs.get('limit', 100))
            
            elif search_type == SearchType.EXPIRY_DATE:
                results = self.search_by_expiry_date(keyword, kwargs.get('limit', 100))
            
            elif search_type == SearchType.PAYMENT_DATE:
                results = self.search_by_payment_date(keyword, kwargs.get('limit', 100))
            
            elif search_type == SearchType.DECISION_DATE:
                results = self.search_by_decision_date(keyword, kwargs.get('limit', 100))
            
            elif search_type == SearchType.APPEAL_NUM:
                results = self.search_by_appeal_num(keyword, kwargs.get('limit', 100))
            
            elif search_type == SearchType.DECISION_CLASS:
                results = self.search_by_decision_class(keyword, kwargs.get('limit', 100))
            
            elif search_type == SearchType.INTL_REG_NUM:
                results = self.search_by_intl_reg_num(keyword, kwargs.get('limit', 100))
            
            else:
                results = []
            
            elapsed_time = time.time() - start_time
            
            print(f"\n検索完了: {len(results)}件 ({elapsed_time:.3f}秒)")
            
            return results
            
        except Exception as e:
            print(f"検索エラー: {e}")
            return []
    
    # ========== 追加検索機能（TMSONAR仕様完全準拠） ==========
    
    def search_by_rejection_code(self, codes: str, limit: int = 100, unified_format: bool = True) -> List[Dict[str, Any]]:
        """拒絶条文コード検索（TMSONAR ID:108）
        
        Args:
            codes: 拒絶条文コード（複数可、前方一致は末尾?）
                   例: 41:3条1項各号, 31:4条1項11号, 30:4条1項10号
            limit: 最大取得件数
            unified_format: 統一フォーマットで返すか
        
        Returns:
            検索結果リスト
        """
        terms = QueryParser.split_terms(codes)
        if not terms or terms == ['?']:
            return self._get_all_rejection_codes(limit)
        
        cursor = self.conn.cursor()
        results = []
        
        for term in terms:
            term = term.strip()  # 前後の空白を削除
            if term.endswith('?'):
                # 前方一致検索
                prefix = term[:-1]
                query = """
                    SELECT DISTINCT
                        tdr.app_num,
                        tdr.rejection_reason_code,
                        tdr.intermediate_doc_code,
                        tdr.draft_date,
                        tdr.dispatch_date,
                        ts.search_use_t as trademark_name,
                        tci.app_date,
                        tci.reg_date
                    FROM trademark_draft_records tdr
                    LEFT JOIN trademark_search ts ON tdr.app_num = ts.app_num
                    LEFT JOIN trademark_case_info tci ON tdr.app_num = tci.app_num
                    WHERE TRIM(tdr.rejection_reason_code) LIKE ? ESCAPE '\\'
                    ORDER BY tdr.draft_date DESC
                    LIMIT ?
                """
                pattern = prefix.replace('_', '\\_').replace('%', '\\%') + '%'
                cursor.execute(query, (pattern, limit))
            else:
                # 完全一致検索
                query = """
                    SELECT DISTINCT
                        tdr.app_num,
                        tdr.rejection_reason_code,
                        tdr.intermediate_doc_code,
                        tdr.draft_date,
                        tdr.dispatch_date,
                        ts.search_use_t as trademark_name,
                        tci.app_date,
                        tci.reg_date
                    FROM trademark_draft_records tdr
                    LEFT JOIN trademark_search ts ON tdr.app_num = ts.app_num
                    LEFT JOIN trademark_case_info tci ON tdr.app_num = tci.app_num
                    WHERE TRIM(tdr.rejection_reason_code) = ?
                    ORDER BY tdr.draft_date DESC
                    LIMIT ?
                """
                cursor.execute(query, (term, limit))
            
            results.extend([dict(row) for row in cursor.fetchall()])
        
        # 重複除去
        seen = set()
        unique_results = []
        for r in results:
            key = (r['app_num'], r.get('rejection_reason_code'))
            if key not in seen:
                seen.add(key)
                unique_results.append(r)
        
        # 統一フォーマットで返す
        if unified_format:
            # 拒絶条文コード情報を含めたsearch_specific_dataを作成
            app_nums = list(set(r['app_num'] for r in unique_results))[:limit]
            search_specific = {}
            for app_num in app_nums:
                # その出願番号の拒絶条文コード情報を取得
                rejection_info = next((r for r in unique_results if r['app_num'] == app_num), {})
                search_specific[app_num] = {
                    'rejection_reason_code': rejection_info.get('rejection_reason_code'),
                    'intermediate_doc_code': rejection_info.get('intermediate_doc_code'),
                    'draft_date': rejection_info.get('draft_date'),
                    'dispatch_date': rejection_info.get('dispatch_date')
                }
            return self._format_unified_result(app_nums, search_specific)
        else:
            return unique_results[:limit]
    
    def search_rejection_reason(self, codes: str, limit: int = 100, unified_format: bool = True) -> List[Dict[str, Any]]:
        """拒絶条文コード検索のエイリアス（WEB用）"""
        return self.search_by_rejection_code(codes, limit, unified_format)
    
    def _get_all_rejection_codes(self, limit: int) -> List[Dict[str, Any]]:
        """全拒絶条文取得"""
        cursor = self.conn.cursor()
        query = """
            SELECT DISTINCT
                tdr.app_num,
                tdr.rejection_reason_code,
                tdr.intermediate_doc_code,
                tdr.draft_date,
                tdr.dispatch_date,
                ts.search_use_t as trademark_name,
                tci.app_date,
                tci.reg_date
            FROM trademark_draft_records tdr
            LEFT JOIN trademark_search ts ON tdr.app_num = ts.app_num
            LEFT JOIN trademark_case_info tci ON tdr.app_num = tci.app_num
            WHERE tdr.rejection_reason_code IS NOT NULL AND tdr.rejection_reason_code != ''
            ORDER BY tdr.draft_date DESC
            LIMIT ?
        """
        cursor.execute(query, (limit,))
        return [dict(row) for row in cursor.fetchall()]
    
    def search_by_intermediate_code(self, codes: str, limit: int = 100) -> List[Dict[str, Any]]:
        """中間記録コード検索（TMSONAR ID:131）
        
        Args:
            codes: 中間記録コード（全指定?、複数可）
                   例: A01:拒絶理由通知書, A131:拒絶査定, A02:登録査定
            limit: 最大取得件数
        
        Returns:
            検索結果リスト
        """
        terms = QueryParser.split_terms(codes)
        if not terms or terms == ['?']:
            return self._get_all_intermediate_codes(limit)
        
        cursor = self.conn.cursor()
        results = []
        
        for term in terms:
            if term.endswith('?'):
                # 前方一致検索
                prefix = term[:-1]
                query = """
                    SELECT DISTINCT
                        tdr.app_num,
                        tdr.intermediate_doc_code,
                        tdr.rejection_reason_code,
                        tdr.draft_date,
                        tdr.dispatch_date,
                        ts.search_use_t as trademark_name,
                        tci.app_date,
                        tci.reg_date
                    FROM trademark_draft_records tdr
                    LEFT JOIN trademark_search ts ON tdr.app_num = ts.app_num
                    LEFT JOIN trademark_case_info tci ON tdr.app_num = tci.app_num
                    WHERE tdr.intermediate_doc_code LIKE ? ESCAPE '\\'
                    ORDER BY tdr.draft_date DESC
                    LIMIT ?
                """
                pattern = prefix.replace('_', '\\_').replace('%', '\\%') + '%'
                cursor.execute(query, (pattern, limit))
            else:
                # 完全一致検索
                query = """
                    SELECT DISTINCT
                        tdr.app_num,
                        tdr.intermediate_doc_code,
                        tdr.rejection_reason_code,
                        tdr.draft_date,
                        tdr.dispatch_date,
                        ts.search_use_t as trademark_name,
                        tci.app_date,
                        tci.reg_date
                    FROM trademark_draft_records tdr
                    LEFT JOIN trademark_search ts ON tdr.app_num = ts.app_num
                    LEFT JOIN trademark_case_info tci ON tdr.app_num = tci.app_num
                    WHERE tdr.intermediate_doc_code = ?
                    ORDER BY tdr.draft_date DESC
                    LIMIT ?
                """
                cursor.execute(query, (term, limit))
            
            results.extend([dict(row) for row in cursor.fetchall()])
        
        # 重複除去
        seen = set()
        unique_results = []
        for r in results:
            key = (r['app_num'], r.get('intermediate_doc_code'))
            if key not in seen:
                seen.add(key)
                unique_results.append(r)
        
        return unique_results[:limit]
    
    def _get_all_intermediate_codes(self, limit: int) -> List[Dict[str, Any]]:
        """全中間記録コード取得"""
        cursor = self.conn.cursor()
        query = """
            SELECT DISTINCT
                tdr.app_num,
                tdr.intermediate_doc_code,
                tdr.rejection_reason_code,
                tdr.draft_date,
                tdr.dispatch_date,
                ts.search_use_t as trademark_name,
                tci.app_date,
                tci.reg_date
            FROM trademark_draft_records tdr
            LEFT JOIN trademark_search ts ON tdr.app_num = ts.app_num
            LEFT JOIN trademark_case_info tci ON tdr.app_num = tci.app_num
            WHERE tdr.intermediate_doc_code IS NOT NULL AND tdr.intermediate_doc_code != ''
            ORDER BY tdr.draft_date DESC
            LIMIT ?
        """
        cursor.execute(query, (limit,))
        return [dict(row) for row in cursor.fetchall()]
    
    def search_by_applicant_address(self, address: str, limit: int = 100) -> List[Dict[str, Any]]:
        """出願人/権利者住所検索（TMSONAR ID:134）
        
        Args:
            address: 住所文字列（部分一致、?で全指定）
            limit: 最大取得件数
        
        Returns:
            検索結果リスト
        """
        if not address or address == '?':
            # 全件取得（申請人マスタから住所を取得）
            cursor = self.conn.cursor()
            query = """
                SELECT DISTINCT
                    taa.app_num,
                    COALESCE(ari.applicant_name, taa.applicant_agent_name) as applicant_name,
                    COALESCE(ari.applicant_address, taa.applicant_agent_address) as address,
                    ts.search_use_t as trademark_name,
                    tci.app_date,
                    tci.reg_date
                FROM trademark_applicants_agents taa
                LEFT JOIN applicant_registration_info ari 
                    ON taa.applicant_agent_code = ari.applicant_code
                LEFT JOIN trademark_search ts ON taa.app_num = ts.app_num
                LEFT JOIN trademark_case_info tci ON taa.app_num = tci.app_num
                WHERE (ari.applicant_address IS NOT NULL AND ari.applicant_address != '（省略）')
                    OR (taa.applicant_agent_address IS NOT NULL AND taa.applicant_agent_address != '（省略）')
                ORDER BY tci.app_date DESC
                LIMIT ?
            """
            cursor.execute(query, (limit,))
            return [dict(row) for row in cursor.fetchall()]
        
        # 住所正規化と部分一致検索
        normalized = TextNormalizer.normalize_address(address)
        pattern = '%' + normalized.replace('_', '\\_').replace('%', '\\%') + '%'
        
        cursor = self.conn.cursor()
        query = """
            SELECT DISTINCT
                taa.app_num,
                COALESCE(ari.applicant_name, taa.applicant_agent_name) as applicant_name,
                COALESCE(ari.applicant_address, taa.applicant_agent_address) as address,
                ts.search_use_t as trademark_name,
                tci.app_date,
                tci.reg_date
            FROM trademark_applicants_agents taa
            LEFT JOIN applicant_registration_info ari 
                ON taa.applicant_agent_code = ari.applicant_code
            LEFT JOIN trademark_search ts ON taa.app_num = ts.app_num
            LEFT JOIN trademark_case_info tci ON taa.app_num = tci.app_num
            WHERE (ari.applicant_address LIKE ? ESCAPE '\\' 
                   OR taa.applicant_agent_address LIKE ? ESCAPE '\\')
                AND ((ari.applicant_address IS NOT NULL AND ari.applicant_address != '（省略）')
                     OR (taa.applicant_agent_address IS NOT NULL AND taa.applicant_agent_address != '（省略）'))
            ORDER BY tci.app_date DESC
            LIMIT ?
        """
        cursor.execute(query, (pattern, pattern, limit))
        return [dict(row) for row in cursor.fetchall()]
    
    def search_by_trademark_length(self, length_range: str, limit: int = 100) -> List[Dict[str, Any]]:
        """商標文字数検索（TMSONAR ID:132）
        
        Args:
            length_range: 文字数範囲（例: '1:5', '1:', ':5', '3'）
            limit: 最大取得件数
        
        Returns:
            検索結果リスト
        """
        cursor = self.conn.cursor()
        
        # 範囲解析
        if ':' in length_range:
            parts = length_range.split(':')
            min_len = int(parts[0]) if parts[0] else 0
            max_len = int(parts[1]) if parts[1] else 999
        else:
            min_len = max_len = int(length_range)
        
        query = """
            SELECT DISTINCT
                ts.app_num,
                ts.search_use_t as trademark_name,
                LENGTH(ts.search_use_t_norm) as trademark_length,
                tci.app_date,
                tci.reg_date
            FROM trademark_search ts
            LEFT JOIN trademark_case_info tci ON ts.app_num = tci.app_num
            WHERE LENGTH(ts.search_use_t_norm) BETWEEN ? AND ?
            ORDER BY tci.app_date DESC
            LIMIT ?
        """
        cursor.execute(query, (min_len, max_len, limit))
        return [dict(row) for row in cursor.fetchall()]
    
    def search_by_phonetic_length(self, length_range: str, limit: int = 100) -> List[Dict[str, Any]]:
        """称呼音数検索（TMSONAR ID:133）
        
        Args:
            length_range: 音数範囲（例: '1:5', '1:', ':5', '3'）
            limit: 最大取得件数
        
        Returns:
            検索結果リスト
        """
        cursor = self.conn.cursor()
        
        # 範囲解析
        if ':' in length_range:
            parts = length_range.split(':')
            min_len = int(parts[0]) if parts[0] else 0
            max_len = int(parts[1]) if parts[1] else 999
        else:
            min_len = max_len = int(length_range)
        
        # trademark_pronunciationsテーブルを使用
        query = """
            SELECT DISTINCT
                tp.app_num,
                tp.pronunciation,
                LENGTH(tp.pronunciation_norm) as phonetic_length,
                ts.search_use_t as trademark_name,
                tci.app_date,
                tci.reg_date
            FROM trademark_pronunciations tp
            LEFT JOIN trademark_search ts ON tp.app_num = ts.app_num
            LEFT JOIN trademark_case_info tci ON tp.app_num = tci.app_num
            WHERE tp.pronunciation_norm IS NOT NULL
              AND LENGTH(tp.pronunciation_norm) BETWEEN ? AND ?
            ORDER BY tci.app_date DESC
            LIMIT ?
        """
        cursor.execute(query, (min_len, max_len, limit))
        return [dict(row) for row in cursor.fetchall()]
    
    def search_by_class_count(self, count_range: str, limit: int = 100) -> List[Dict[str, Any]]:
        """区分数検索（TMSONAR ID:137）
        
        Args:
            count_range: 区分数範囲（例: '1:5', '1:', ':5', '3'）、?で全指定
            limit: 最大取得件数
        
        Returns:
            検索結果リスト
        """
        cursor = self.conn.cursor()
        
        if not count_range or count_range == '?':
            # 全件取得
            query = """
                SELECT 
                    app_num,
                    class_count,
                    search_use_t as trademark_name,
                    app_date,
                    reg_date,
                    final_disposition_type
                FROM trademark_case_info tci
                LEFT JOIN trademark_search ts USING (app_num)
                WHERE class_count IS NOT NULL
                ORDER BY app_date DESC
                LIMIT ?
            """
            cursor.execute(query, (limit,))
            return [dict(row) for row in cursor.fetchall()]
        
        # 範囲解析
        if ':' in count_range:
            parts = count_range.split(':')
            min_count = int(parts[0]) if parts[0] else 0
            max_count = int(parts[1]) if parts[1] else 999
        else:
            min_count = max_count = int(count_range)
        
        query = """
            SELECT 
                app_num,
                class_count,
                search_use_t as trademark_name,
                app_date,
                reg_date,
                final_disposition_type
            FROM trademark_case_info tci
            LEFT JOIN trademark_search ts USING (app_num)
            WHERE class_count IS NOT NULL
              AND CAST(SUBSTR(class_count, 1, 3) AS INTEGER) BETWEEN ? AND ?
            ORDER BY app_date DESC
            LIMIT ?
        """
        cursor.execute(query, (min_count, max_count, limit))
        return [dict(row) for row in cursor.fetchall()]
    
    def search_by_applicant_count(self, count_range: str, limit: int = 100) -> List[Dict[str, Any]]:
        """出願人/権利者数検索（TMSONAR ID:138）
        
        Args:
            count_range: 出願人数範囲（例: '2:5', '2:', ':5', '3'）、?で全指定
            limit: 最大取得件数
        
        Returns:
            検索結果リスト
        """
        cursor = self.conn.cursor()
        
        # 範囲解析
        if not count_range or count_range == '?':
            min_count = 1
            max_count = 999
        elif ':' in count_range:
            parts = count_range.split(':')
            min_count = int(parts[0]) if parts[0] else 1
            max_count = int(parts[1]) if parts[1] else 999
        else:
            min_count = max_count = int(count_range)
        
        # 出願人数を集計してから結果を取得
        query = """
            WITH applicant_counts AS (
                SELECT 
                    app_num,
                    COUNT(DISTINCT applicant_agent_code) as applicant_count
                FROM trademark_applicants_agents
                WHERE applicant_agent_type = '1'
                GROUP BY app_num
                HAVING applicant_count BETWEEN ? AND ?
            )
            SELECT 
                ac.app_num,
                ac.applicant_count,
                ts.search_use_t as trademark_name,
                tci.app_date,
                tci.reg_date,
                GROUP_CONCAT(
                    DISTINCT COALESCE(ari.applicant_name, taa.applicant_agent_name)
                ) as applicant_names
            FROM applicant_counts ac
            LEFT JOIN trademark_search ts ON ac.app_num = ts.app_num
            LEFT JOIN trademark_case_info tci ON ac.app_num = tci.app_num
            LEFT JOIN trademark_applicants_agents taa 
                ON ac.app_num = taa.app_num AND taa.applicant_agent_type = '1'
            LEFT JOIN applicant_registration_info ari 
                ON taa.applicant_agent_code = ari.applicant_code
            GROUP BY ac.app_num, ac.applicant_count, ts.search_use_t, 
                     tci.app_date, tci.reg_date
            ORDER BY tci.app_date DESC
            LIMIT ?
        """
        cursor.execute(query, (min_count, max_count, limit))
        return [dict(row) for row in cursor.fetchall()]
    
    def search_by_phonetic_count(self, count_range: str, limit: int = 100) -> List[Dict[str, Any]]:
        """称呼数検索（TMSONAR ID:139）
        
        Args:
            count_range: 称呼数範囲（例: '2:5', '2:', ':5', '3'）、?で全指定
            limit: 最大取得件数
        
        Returns:
            検索結果リスト
        """
        cursor = self.conn.cursor()
        
        # 範囲解析
        if not count_range or count_range == '?':
            min_count = 1
            max_count = 999
        elif ':' in count_range:
            parts = count_range.split(':')
            min_count = int(parts[0]) if parts[0] else 1
            max_count = int(parts[1]) if parts[1] else 999
        else:
            min_count = max_count = int(count_range)
        
        # 称呼数を集計してから結果を取得
        query = """
            WITH phonetic_counts AS (
                SELECT 
                    app_num,
                    COUNT(DISTINCT pronunciation) as phonetic_count
                FROM trademark_pronunciations
                WHERE pronunciation IS NOT NULL
                GROUP BY app_num
                HAVING phonetic_count BETWEEN ? AND ?
            )
            SELECT 
                pc.app_num,
                pc.phonetic_count,
                ts.search_use_t as trademark_name,
                tci.app_date,
                tci.reg_date,
                GROUP_CONCAT(DISTINCT tp.pronunciation) as pronunciations
            FROM phonetic_counts pc
            LEFT JOIN trademark_search ts ON pc.app_num = ts.app_num
            LEFT JOIN trademark_case_info tci ON pc.app_num = tci.app_num
            LEFT JOIN trademark_pronunciations tp ON pc.app_num = tp.app_num
            GROUP BY pc.app_num, pc.phonetic_count, ts.search_use_t, 
                     tci.app_date, tci.reg_date
            ORDER BY tci.app_date DESC
            LIMIT ?
        """
        cursor.execute(query, (min_count, max_count, limit))
        return [dict(row) for row in cursor.fetchall()]
    
    def search_by_additional_info(self, info_codes: str, limit: int = 100) -> List[Dict[str, Any]]:
        """付加情報検索（TMSONAR ID:128）
        
        Args:
            info_codes: 付加情報コード（カンマ区切りで複数指定可）
                      例: '05'(標準文字), '04'(3条2項), '01,05'
            limit: 最大取得件数
        
        Returns:
            検索結果リスト
        """
        if not info_codes or info_codes == '?':
            # 全件取得
            cursor = self.conn.cursor()
            query = """
                SELECT DISTINCT
                    app_num,
                    search_use_t as trademark_name,
                    orig_app_type as additional_info,
                    app_date,
                    reg_date
                FROM trademark_case_info tci
                LEFT JOIN trademark_search ts USING (app_num)
                WHERE orig_app_type IS NOT NULL
                ORDER BY app_date DESC
                LIMIT ?
            """
            cursor.execute(query, (limit,))
            return [dict(row) for row in cursor.fetchall()]
        
        # コード分割
        codes = [c.strip() for c in info_codes.replace('，', ',').split(',')]
        
        cursor = self.conn.cursor()
        
        # orig_app_typeで検索（元の出願種別コード）
        # IN句の制限を考慮
        codes_limited = codes[:self.IN_CLAUSE_LIMIT]
        placeholders = ','.join(['?' for _ in codes_limited])
        query = f"""
            SELECT DISTINCT
                app_num,
                search_use_t as trademark_name,
                orig_app_type as additional_info,
                app_date,
                reg_date,
                final_disposition_type
            FROM trademark_case_info tci
            LEFT JOIN trademark_search ts USING (app_num)
            WHERE orig_app_type IN ({placeholders})
            ORDER BY app_date DESC
            LIMIT ?
        """
        params = codes_limited + [limit]
        cursor.execute(query, params)
        return [dict(row) for row in cursor.fetchall()]
    
    def search_by_country_code(self, country_codes: str, limit: int = 100) -> List[Dict[str, Any]]:
        """国県コード検索（TMSONAR ID:129）
        
        Args:
            country_codes: 国県コード（カンマ区切りで複数指定可）
                          例: '13'(東京都), '27'(大阪府), 'US'(米国)
            limit: 最大取得件数
        
        Returns:
            検索結果リスト
        """
        cursor = self.conn.cursor()
        
        if not country_codes or country_codes == '?':
            # 全件取得
            query = """
                SELECT DISTINCT
                    taa.app_num,
                    taa.country_prefecture_code,
                    COALESCE(ari.applicant_name, taa.applicant_agent_name) as applicant_name,
                    ts.search_use_t as trademark_name,
                    tci.app_date,
                    tci.reg_date
                FROM trademark_applicants_agents taa
                LEFT JOIN applicant_registration_info ari 
                    ON taa.applicant_agent_code = ari.applicant_code
                LEFT JOIN trademark_search ts ON taa.app_num = ts.app_num
                LEFT JOIN trademark_case_info tci ON taa.app_num = tci.app_num
                WHERE taa.country_prefecture_code IS NOT NULL 
                  AND taa.country_prefecture_code != ''
                  AND taa.applicant_agent_type = '1'
                ORDER BY tci.app_date DESC
                LIMIT ?
            """
            cursor.execute(query, (limit,))
            return [dict(row) for row in cursor.fetchall()]
        
        # コード分割
        codes = [c.strip() for c in country_codes.replace('，', ',').split(',')]
        
        # IN句の制限を考慮
        codes_limited = codes[:self.IN_CLAUSE_LIMIT]
        placeholders = ','.join(['?' for _ in codes_limited])
        query = f"""
            SELECT DISTINCT
                taa.app_num,
                taa.country_prefecture_code,
                COALESCE(ari.applicant_name, taa.applicant_agent_name) as applicant_name,
                ts.search_use_t as trademark_name,
                tci.app_date,
                tci.reg_date
            FROM trademark_applicants_agents taa
            LEFT JOIN applicant_registration_info ari 
                ON taa.applicant_agent_code = ari.applicant_code
            LEFT JOIN trademark_search ts ON taa.app_num = ts.app_num
            LEFT JOIN trademark_case_info tci ON taa.app_num = tci.app_num
            WHERE taa.country_prefecture_code IN ({placeholders})
              AND taa.applicant_agent_type = '1'
            ORDER BY tci.app_date DESC
            LIMIT ?
        """
        params = codes_limited + [limit]
        cursor.execute(query, params)
        return [dict(row) for row in cursor.fetchall()]
    
    def _search_by_date_field(self, date_field: str, date_range: str, table: str, limit: int = 100) -> List[Dict[str, Any]]:
        """汎用日付フィールド検索ヘルパー"""
        cursor = self.conn.cursor()
        
        # 範囲解析
        if ':' in date_range:
            parts = date_range.split(':')
            start_date = parts[0].replace('-', '').replace('/', '') if parts[0] else '00000000'
            end_date = parts[1].replace('-', '').replace('/', '') if parts[1] else '99999999'
        else:
            # 単一日付
            date = date_range.replace('-', '').replace('/', '')
            start_date = end_date = date
        
        if table == 'trademark_management_info':
            query = f"""
                SELECT 
                    tmi.app_num,
                    tmi.{date_field},
                    ts.search_use_t as trademark_name,
                    tci.app_date,
                    tci.reg_date,
                    tmi.reg_num
                FROM {table} tmi
                LEFT JOIN trademark_search ts ON tmi.app_num = ts.app_num
                LEFT JOIN trademark_case_info tci ON tmi.app_num = tci.app_num
                WHERE tmi.{date_field} BETWEEN ? AND ?
                  AND tmi.{date_field} != '00000000'
                ORDER BY tmi.{date_field} DESC
                LIMIT ?
            """
        else:
            query = f"""
                SELECT 
                    app_num,
                    {date_field},
                    search_use_t as trademark_name,
                    app_date,
                    reg_date
                FROM {table} t
                LEFT JOIN trademark_search ts USING (app_num)
                LEFT JOIN trademark_case_info tci USING (app_num)
                WHERE t.{date_field} BETWEEN ? AND ?
                  AND t.{date_field} != '00000000'
                ORDER BY t.{date_field} DESC
                LIMIT ?
            """
        
        cursor.execute(query, (start_date, end_date, limit))
        return [dict(row) for row in cursor.fetchall()]
    
    def search_by_expiry_date(self, date_range: str, limit: int = 100) -> List[Dict[str, Any]]:
        """存続期間満了日検索（TMSONAR ID:114）
        
        Args:
            date_range: 日付範囲（YYYYMMDD:YYYYMMDD、前後省略可）
            limit: 最大取得件数
        
        Returns:
            検索結果リスト
        """
        return self._search_by_date_field('conti_prd_expire_date', date_range, 'trademark_management_info', limit)
    
    def search_by_payment_date(self, date_range: str, limit: int = 100) -> List[Dict[str, Any]]:
        """分納満了日検索（TMSONAR ID:121）
        
        Args:
            date_range: 日付範囲（YYYYMMDD:YYYYMMDD、前後省略可）
            limit: 最大取得件数
        
        Returns:
            検索結果リスト
        """
        return self._search_by_date_field('next_pen_payment_limit_date', date_range, 'trademark_management_info', limit)
    
    def search_by_decision_date(self, date_range: str, limit: int = 100) -> List[Dict[str, Any]]:
        """最終処分日検索（TMSONAR ID:116）
        
        Args:
            date_range: 日付範囲（YYYYMMDD:YYYYMMDD、前後省略可）
            limit: 最大取得件数
        
        Returns:
            検索結果リスト
        """
        return self._search_by_date_field('final_decision_date', date_range, 'trademark_management_info', limit)
    
    def search_by_appeal_num(self, appeal_nums: str, limit: int = 100) -> List[Dict[str, Any]]:
        """審判番号検索（TMSONAR ID:120）
        
        Args:
            appeal_nums: 審判番号（完全一致または範囲）
                        例: '2023300949', '2023300000:2023400000'
            limit: 最大取得件数
        
        Returns:
            検索結果リスト
        """
        cursor = self.conn.cursor()
        
        # 範囲検索
        if ':' in appeal_nums:
            parts = appeal_nums.split(':')
            start_num = parts[0]
            end_num = parts[1]
            
            query = """
                SELECT 
                    tac.appeal_num,
                    tac.app_num,
                    tac.appeal_type,
                    tac.appeal_request_date,
                    ts.search_use_t as trademark_name,
                    tci.reg_article_reg_num as reg_num
                FROM trademark_appeal_cases tac
                LEFT JOIN trademark_search ts ON tac.app_num = ts.app_num
                LEFT JOIN trademark_case_info tci ON tac.app_num = tci.app_num
                WHERE tac.appeal_num BETWEEN ? AND ?
                ORDER BY tac.appeal_num DESC
                LIMIT ?
            """
            cursor.execute(query, (start_num, end_num, limit))
        else:
            # 完全一致
            query = """
                SELECT 
                    tac.appeal_num,
                    tac.app_num,
                    tac.appeal_type,
                    tac.appeal_request_date,
                    ts.search_use_t as trademark_name,
                    tci.reg_article_reg_num as reg_num
                FROM trademark_appeal_cases tac
                LEFT JOIN trademark_search ts ON tac.app_num = ts.app_num
                LEFT JOIN trademark_case_info tci ON tac.app_num = tci.app_num
                WHERE tac.appeal_num = ?
            """
            cursor.execute(query, (appeal_nums,))
        
        return [dict(row) for row in cursor.fetchall()]
    
    def search_by_decision_class(self, class_expr: str, limit: int = 100) -> List[Dict[str, Any]]:
        """審決分類検索（TMSONAR ID:109）
        
        Args:
            class_expr: 審決分類式（審判種別-判示コード-結論コード）
                       例: '1-121-Y', '1-?-Y', '?-121-?'
            limit: 最大取得件数
        
        Returns:
            検索結果リスト
        """
        cursor = self.conn.cursor()
        
        # 分類式を分解
        parts = class_expr.split('-') if '-' in class_expr else [class_expr]
        
        conditions = []
        params = []
        
        if len(parts) >= 1 and parts[0] != '?':
            conditions.append("tdc.appeal_type = ?")
            params.append(parts[0])
        
        if len(parts) >= 2 and parts[1] != '?':
            conditions.append("tdc.judgment_item_code = ?")
            params.append(parts[1])
        
        if len(parts) >= 3 and parts[2] != '?':
            conditions.append("tdc.decision_classification_conclusion_code = ?")
            params.append(parts[2])
        
        where_clause = " AND ".join(conditions) if conditions else "1=1"
        params.append(limit)
        
        query = f"""
            SELECT 
                tdc.appeal_num,
                tdc.appeal_type,
                tdc.judgment_item_code,
                tdc.decision_classification_conclusion_code,
                tac.app_num,
                ts.search_use_t as trademark_name
            FROM trademark_decision_classifications tdc
            LEFT JOIN trademark_appeal_cases tac ON tdc.appeal_num = tac.appeal_num
            LEFT JOIN trademark_search ts ON tac.app_num = ts.app_num
            WHERE {where_clause}
            ORDER BY tdc.appeal_num DESC
            LIMIT ?
        """
        
        cursor.execute(query, params)
        return [dict(row) for row in cursor.fetchall()]
    
    def search_by_info_provision_count(self, count_range: str, limit: int = 100) -> List[Dict[str, Any]]:
        """情報提供数検索（刊行物等提出書の提出数）（TMSONAR ID:135）
        
        Args:
            count_range: 数値範囲（例："1:", ":5", "1:3"）
            limit: 最大件数
        
        Returns:
            検索結果リスト
        """
        cursor = self.conn.cursor()
        
        # 範囲解析
        if not count_range or count_range == '?':
            min_count = 1
            max_count = 999
        elif ':' in count_range:
            parts = count_range.split(':')
            min_count = int(parts[0]) if parts[0] else 1
            max_count = int(parts[1]) if parts[1] else 999
        else:
            min_count = max_count = int(count_range)
        
        # 刊行物等提出書の中間記録コードでカウント
        # A50: 刊行物等提出書、A417: 刊行物等提出による通知書
        query = """
            WITH info_provision_counts AS (
                SELECT 
                    tci.app_num, 
                    COUNT(DISTINCT tdr.document_num) as info_count
                FROM trademark_case_info tci
                LEFT JOIN trademark_draft_records tdr 
                    ON tci.law_code = tdr.law_code 
                    AND tci.app_num = tdr.app_num
                    AND tdr.intermediate_doc_code IN ('A50', 'A417')
                GROUP BY tci.app_num
                HAVING COUNT(DISTINCT tdr.document_num) BETWEEN ? AND ?
            )
            SELECT 
                ipc.app_num,
                ipc.info_count,
                ts.search_use_t as trademark_name,
                tci.app_date,
                tci.reg_date,
                tci.final_disposition_type
            FROM info_provision_counts ipc
            LEFT JOIN trademark_search ts ON ipc.app_num = ts.app_num
            LEFT JOIN trademark_case_info tci ON ipc.app_num = tci.app_num
            ORDER BY tci.app_date DESC
            LIMIT ?
        """
        
        cursor.execute(query, (min_count, max_count, limit))
        return [dict(row) for row in cursor.fetchall()]
    
    def search_by_browsing_request_count(self, count_range: str, limit: int = 100) -> List[Dict[str, Any]]:
        """閲覧請求数検索（ファイル記録事項の閲覧請求書の提出数）（TMSONAR ID:136）
        
        Args:
            count_range: 数値範囲（例："1:", ":5", "1:3"）
            limit: 最大件数
        
        Returns:
            検索結果リスト
        """
        cursor = self.conn.cursor()
        
        # 範囲解析
        if not count_range or count_range == '?':
            min_count = 1
            max_count = 999
        elif ':' in count_range:
            parts = count_range.split(':')
            min_count = int(parts[0]) if parts[0] else 1
            max_count = int(parts[1]) if parts[1] else 999
        else:
            min_count = max_count = int(count_range)
        
        # 閲覧請求書の中間記録コードでカウント
        # A405: ファイル記録事項の閲覧(縦覧)請求書
        query = """
            WITH browsing_counts AS (
                SELECT 
                    tci.app_num, 
                    COUNT(DISTINCT tdr.document_num) as browse_count
                FROM trademark_case_info tci
                LEFT JOIN trademark_draft_records tdr 
                    ON tci.law_code = tdr.law_code 
                    AND tci.app_num = tdr.app_num
                    AND tdr.intermediate_doc_code = 'A405'
                GROUP BY tci.app_num
                HAVING COUNT(DISTINCT tdr.document_num) BETWEEN ? AND ?
            )
            SELECT 
                bc.app_num,
                bc.browse_count,
                ts.search_use_t as trademark_name,
                tci.app_date,
                tci.reg_date,
                tci.final_disposition_type
            FROM browsing_counts bc
            LEFT JOIN trademark_search ts ON bc.app_num = ts.app_num
            LEFT JOIN trademark_case_info tci ON bc.app_num = tci.app_num
            ORDER BY tci.app_date DESC
            LIMIT ?
        """
        
        cursor.execute(query, (min_count, max_count, limit))
        return [dict(row) for row in cursor.fetchall()]
    
    def _format_unified_result(self, app_nums: List[str], search_specific_data: Dict[str, Any] = None) -> List[Dict[str, Any]]:
        """統一フォーマットで検索結果を整形
        
        Args:
            app_nums: 出願番号リスト
            search_specific_data: 検索種別固有のデータ（出願番号をキーとした辞書）
        
        Returns:
            統一フォーマットの検索結果リスト
        """
        import sys
        print(f"[DEBUG] _format_unified_result called with {len(app_nums)} app_nums", file=sys.stderr)
        if app_nums:
            print(f"[DEBUG] Sample app_nums in _format_unified_result: {app_nums[:3]}", file=sys.stderr)
        
        if not app_nums:
            return []
        
        cursor = self.conn.cursor()
        results = []
        
        # IN句の制限を考慮してバッチ処理
        for batch_start in range(0, len(app_nums), self.IN_CLAUSE_LIMIT):
            batch_app_nums = app_nums[batch_start:batch_start + self.IN_CLAUSE_LIMIT]
            placeholders = ','.join(['?' for _ in batch_app_nums])
            
            # 基本情報の取得クエリ
            query = f"""
                WITH image_data AS (
                    SELECT 
                        app_num,
                        GROUP_CONCAT(image_data, '') as image_data  -- 複数行の画像データを結合
                    FROM (
                        -- 最初のページのみ取得（複数ページの場合は最小page_num）
                        SELECT ti.app_num, ti.rec_seq_num, ti.image_data
                        FROM trademark_images ti
                        WHERE ti.app_num IN ({placeholders})
                        AND ti.image_data IS NOT NULL
                        AND LENGTH(ti.image_data) > 0
                        AND ti.compression_format = 'JP'
                        AND (
                            -- page_numがNULLの場合、または最小のpage_numのレコード
                            ti.page_num IS NULL 
                            OR ti.page_num = (
                                SELECT MIN(page_num)
                                FROM trademark_images
                                WHERE app_num = ti.app_num
                                AND page_num IS NOT NULL
                            )
                        )
                        AND ti.ROWID IN (
                            SELECT MIN(ROWID)
                            FROM trademark_images
                            WHERE app_num = ti.app_num
                            AND rec_seq_num = ti.rec_seq_num
                            AND (page_num = ti.page_num OR (page_num IS NULL AND ti.page_num IS NULL))
                            AND image_data IS NOT NULL
                            GROUP BY app_num, rec_seq_num, page_num
                        )
                        ORDER BY ti.app_num, ti.rec_seq_num
                    )
                    GROUP BY app_num
                ),
                basic_data AS (
                    SELECT DISTINCT
                        tci.app_num,
                        tci.app_date,
                        tci.reg_article_reg_num as reg_num,
                        tci.reg_date,
                        -- 商標名の優先順位: 画像→商標見本→標準文字→表示用商標
                        CASE 
                            WHEN ti.image_data IS NOT NULL THEN '[商標画像]'
                            ELSE COALESCE(
                                td.indct_use_t,
                                tsc.standard_char_t,
                                ts.search_use_t
                            )
                        END as trademark_name,
                        ti.image_data as trademark_image_data,
                        tci.final_disposition_type,
                        tci.final_disposition_date,
                        tci.law_code,
                        tci.reg_article_gazette_date,
                        tci.pub_article_gazette_date,
                        tmi.conti_prd_expire_date,
                        tmi.next_pen_payment_limit_date,
                        tbi.conti_prd_expire_date as basic_expiry_date,
                        -- 分納関連フィールド
                        tbi.installments_id,
                        tbi.instllmnt_expr_date_aft_des_date,
                        -- 追加項目
                        tci.app_type1,
                        tci.app_type2,
                        tci.app_type3,
                        tci.app_type4,
                        tci.app_type5,
                        tci.orig_app_type,
                        tci.article3_2_flag,
                        tci.article5_4_flag,
                        tci.exam_type,
                        tci.decision_type,
                        tci.applicable_law_class,
                        -- 商標タイプ判定用フラグ
                        tci.standard_char_exist,
                        tci.special_mark_exist,
                        tci.color_exist,
                        -- 補助情報
                        tci.defensive_num,
                        tbi.prior_app_right_occr_date,
                        tci.renewal_reg_num,
                        tci.renewal_defensive_num
                    FROM trademark_case_info tci
                    LEFT JOIN image_data ti ON tci.app_num = ti.app_num
                    LEFT JOIN trademark_display td ON tci.app_num = td.app_num
                    LEFT JOIN trademark_standard_char tsc ON tci.app_num = tsc.app_num
                    LEFT JOIN trademark_search ts ON tci.app_num = ts.app_num
                    LEFT JOIN trademark_management_info tmi ON tci.app_num = tmi.app_num
                    LEFT JOIN trademark_basic_items tbi ON tci.app_num = tbi.app_num
                    WHERE tci.app_num IN ({placeholders})
                ),
                phonetics_data AS (
                    SELECT 
                        app_num,
                        GROUP_CONCAT(DISTINCT pronunciation) as phonetics
                    FROM trademark_pronunciations
                    WHERE app_num IN ({placeholders})
                    GROUP BY app_num
                ),
                applicants_data AS (
                    SELECT 
                        taa.app_num,
                        GROUP_CONCAT(DISTINCT 
                            CASE 
                                WHEN taa.applicant_agent_type = '1' THEN 
                                    COALESCE(ari.applicant_name, taa.applicant_agent_name)
                                ELSE NULL 
                            END
                        ) as applicants,
                        GROUP_CONCAT(DISTINCT 
                            CASE 
                                WHEN taa.applicant_agent_type = '1' THEN 
                                    taa.applicant_agent_address
                                ELSE NULL 
                            END
                        ) as applicant_addresses,
                        GROUP_CONCAT(DISTINCT 
                            CASE 
                                WHEN taa.applicant_agent_type = '1' THEN 
                                    taa.country_prefecture_code
                                ELSE NULL 
                            END
                        ) as applicant_country_codes,
                        GROUP_CONCAT(DISTINCT 
                            CASE 
                                WHEN taa.applicant_agent_type = '2' THEN 
                                    taa.applicant_agent_name
                                ELSE NULL 
                            END
                        ) as agents
                    FROM trademark_applicants_agents taa
                    LEFT JOIN applicant_registration_info ari 
                        ON taa.applicant_agent_code = ari.applicant_code
                    WHERE taa.app_num IN ({placeholders})
                    GROUP BY taa.app_num
                ),
                right_holders_data AS (
                    SELECT 
                        app_num,
                        GROUP_CONCAT(DISTINCT right_person_name) as right_holders
                    FROM trademark_right_holders
                    WHERE app_num IN ({placeholders})
                    GROUP BY app_num
                ),
                classes_data AS (
                    SELECT 
                        app_num,
                        GROUP_CONCAT(DISTINCT class_num) as classes
                    FROM trademark_goods_services
                    WHERE app_num IN ({placeholders})
                    GROUP BY app_num
                ),
                goods_services_data AS (
                    SELECT 
                        app_num,
                        class_num,
                        GROUP_CONCAT(goods_services_name, '、') as goods_services_name
                    FROM (
                        SELECT DISTINCT app_num, class_num, goods_services_name
                        FROM trademark_goods_services
                        WHERE app_num IN ({placeholders})
                    )
                    GROUP BY app_num, class_num
                ),
                similar_groups_data AS (
                    SELECT 
                        app_num,
                        class_num,
                        similar_group_codes
                    FROM trademark_similar_group_codes
                    WHERE app_num IN ({placeholders})
                ),
                vienna_data AS (
                    SELECT 
                        app_num,
                        GROUP_CONCAT(DISTINCT 
                            CASE 
                                WHEN complement_sub_class = '00' AND small_class = '00' AND mid_class = '00' THEN large_class
                                WHEN complement_sub_class = '00' AND small_class = '00' THEN large_class || '.' || mid_class
                                WHEN complement_sub_class = '00' THEN large_class || '.' || mid_class || '.' || small_class
                                ELSE large_class || '.' || mid_class || '.' || small_class || '.' || complement_sub_class
                            END
                        ) as vienna_codes
                    FROM trademark_vienna_codes
                    WHERE app_num IN ({placeholders})
                    GROUP BY app_num
                ),
                rejection_data AS (
                    SELECT 
                        app_num,
                        GROUP_CONCAT(DISTINCT rejection_reason_code) as rejection_codes,
                        MAX(dispatch_date) as latest_rejection_date
                    FROM trademark_draft_records
                    WHERE app_num IN ({placeholders})
                    AND rejection_reason_code IS NOT NULL
                    AND rejection_reason_code != ''
                    GROUP BY app_num
                ),
                detail_desc_data AS (
                    SELECT 
                        app_num,
                        GROUP_CONCAT(detailed_description, ' ') as detailed_description
                    FROM trademark_detailed_descriptions
                    WHERE app_num IN ({placeholders})
                    GROUP BY app_num
                ),
                appeal_data AS (
                    SELECT 
                        app_num,
                        GROUP_CONCAT(DISTINCT appeal_num) as appeal_nums,
                        GROUP_CONCAT(DISTINCT appeal_type) as appeal_types
                    FROM trademark_appeal_cases
                    WHERE app_num IN ({placeholders})
                    GROUP BY app_num
                ),
                progress_data AS (
                    SELECT 
                        app_num,
                        GROUP_CONCAT(
                            intermediate_doc_code || ':' || record_date, '|'
                        ) as progress_records
                    FROM (
                        -- 審査中間記録（従来通り）
                        SELECT app_num, intermediate_doc_code, creation_date as record_date
                        FROM trademark_draft_records
                        WHERE app_num IN ({placeholders})
                        AND intermediate_doc_code IS NOT NULL
                        UNION ALL
                        SELECT app_num, intermediate_doc_code, receipt_date as record_date
                        FROM trademark_application_records
                        WHERE app_num IN ({placeholders})
                        AND intermediate_doc_code IS NOT NULL
                        
                        -- 審判中間記録を追加
                        -- trial_received_docsから取得（C60も含む）
                        UNION ALL
                        SELECT tc.app_num, trd.doc_type as intermediate_doc_code, trd.received_date as record_date
                        FROM trial_cases tc
                        INNER JOIN trial_received_docs trd ON tc.appeal_num = trd.appeal_num
                        WHERE tc.app_num IN ({placeholders})
                        AND trd.doc_type IS NOT NULL
                        AND trd.doc_type != ''
                        
                        UNION ALL
                        SELECT tc.app_num, tdd.doc_type as intermediate_doc_code, tdd.dispatch_date as record_date
                        FROM trial_cases tc
                        INNER JOIN trial_dispatched_docs tdd ON tc.appeal_num = tdd.appeal_num
                        WHERE tc.app_num IN ({placeholders})
                        AND tdd.doc_type IS NOT NULL
                        AND tdd.doc_type != ''
                        
                        -- 登録中間記録を追加
                        UNION ALL
                        SELECT progress_app_num as app_num, reg_intermediate_code as intermediate_doc_code, process_date as record_date
                        FROM trademark_progress_info
                        WHERE progress_app_num IN ({placeholders})
                        AND reg_intermediate_code IS NOT NULL
                        AND reg_intermediate_code != ''
                        AND progress_app_num != '0000000000'
                        
                        ORDER BY app_num, record_date ASC
                    )
                    GROUP BY app_num
                )
                SELECT 
                    bd.*,
                    pd.phonetics,
                    ad.applicants,
                    ad.applicant_addresses,
                    ad.applicant_country_codes,
                    ad.agents,
                    rhd.right_holders,
                    cd.classes,
                    gsd.class_num as gs_class_num,
                    gsd.goods_services_name,
                    sgd.class_num as sg_class_num,
                    sgd.similar_group_codes,
                    vd.vienna_codes,
                    rd.rejection_codes,
                    rd.latest_rejection_date,
                    ddd.detailed_description,
                    apd.appeal_nums,
                    apd.appeal_types,
                    prd.progress_records
                FROM basic_data bd
                LEFT JOIN phonetics_data pd ON bd.app_num = pd.app_num
                LEFT JOIN applicants_data ad ON bd.app_num = ad.app_num
                LEFT JOIN right_holders_data rhd ON bd.app_num = rhd.app_num
                LEFT JOIN classes_data cd ON bd.app_num = cd.app_num
                LEFT JOIN goods_services_data gsd ON bd.app_num = gsd.app_num
                LEFT JOIN similar_groups_data sgd ON bd.app_num = sgd.app_num
                LEFT JOIN vienna_data vd ON bd.app_num = vd.app_num
                LEFT JOIN rejection_data rd ON bd.app_num = rd.app_num
                LEFT JOIN detail_desc_data ddd ON bd.app_num = ddd.app_num
                LEFT JOIN appeal_data apd ON bd.app_num = apd.app_num
                LEFT JOIN progress_data prd ON bd.app_num = prd.app_num
                ORDER BY bd.app_date DESC
            """
            
            # パラメータを17回繰り返す（各サブクエリで使用）
            params = batch_app_nums * 17
            cursor.execute(query, params)
            
            # 結果を出願番号ごとにグループ化
            app_num_data = {}
            for row in cursor.fetchall():
                app_num = row['app_num']
                if app_num not in app_num_data:
                    app_num_data[app_num] = {
                        'app_num': app_num,
                        'app_date': row['app_date'],
                        'reg_num': row['reg_num'],
                        'reg_date': row['reg_date'],
                        'trademark_name': row['trademark_name'],
                        'trademark_image_data': row['trademark_image_data'] if 'trademark_image_data' in dict(row) else None,  # 画像データを追加
                        'phonetics': row['phonetics'].split(',') if row['phonetics'] else [],
                        'applicants': row['applicants'].split(',') if row['applicants'] else [],
                        'applicant_addresses': row['applicant_addresses'].split(',') if row['applicant_addresses'] else [],
                        'applicant_country_codes': row['applicant_country_codes'].split(',') if row['applicant_country_codes'] else [],
                        'agents': row['agents'].split(',') if row['agents'] else [],
                        'right_holders': row['right_holders'].split(',') if row['right_holders'] else [],
                        'classes': row['classes'].split(',') if row['classes'] else [],
                        'goods_services': {},
                        'similar_groups': {},
                        'vienna_codes': row['vienna_codes'].split(',') if row['vienna_codes'] else [],
                        # 拒絶理由情報を追加
                        'rejection_codes': self._format_rejection_codes(row['rejection_codes']),
                        'latest_rejection_date': row['latest_rejection_date'],
                        # ステータス情報を追加（コードを日本語に変換）
                        'final_disposition_type': self._convert_code_to_name(row['final_disposition_type'], 'final_disposition'),
                        'final_disposition_date': row['final_disposition_date'],
                        # 最終処分記事（日本語変換）
                        'final_disposition_article': self._format_final_disposition(row['final_disposition_type']),
                        # 公報情報を追加
                        'reg_article_gazette_date': row['reg_article_gazette_date'],
                        'pub_article_gazette_date': row['pub_article_gazette_date'],
                        # 存続期間・分納情報を追加
                        'conti_prd_expire_date': row['conti_prd_expire_date'] or row['basic_expiry_date'],  # management_infoまたはbasic_itemsから
                        # 分納期限日: installments_id='1'の場合は instllmnt_expr_date_aft_des_date を使用
                        'next_pen_payment_limit_date': (
                            row['instllmnt_expr_date_aft_des_date'] 
                            if row['installments_id'] == '1' and row['instllmnt_expr_date_aft_des_date']
                            else row['next_pen_payment_limit_date']
                        ),
                        # 出願種別・付加情報（コードを日本語に変換）
                        'app_type1': self._convert_code_to_name(row['app_type1'], 'app_type'),
                        'app_type2': self._convert_code_to_name(row['app_type2'], 'app_type'),
                        'app_type3': self._convert_code_to_name(row['app_type3'], 'app_type'),
                        'app_type4': self._convert_code_to_name(row['app_type4'], 'app_type'),
                        'app_type5': self._convert_code_to_name(row['app_type5'], 'app_type'),
                        'orig_app_type': self._convert_code_to_name(row['orig_app_type'], 'app_type'),
                        'article3_2_flag': row['article3_2_flag'],
                        'article5_4_flag': row['article5_4_flag'],
                        'exam_type': self._convert_code_to_name(row['exam_type'], 'exam_type'),
                        'decision_type': self._convert_code_to_name(row['decision_type'], 'decision_type'),
                        'applicable_law_class': self._convert_code_to_name(row['applicable_law_class'], 'international_class_version'),
                        # 商標タイプ
                        'trademark_type': self._determine_trademark_type(row),
                        # 補助情報
                        'defensive_num': row['defensive_num'],
                        'prior_app_right_occr_dt': row['prior_app_right_occr_date'],
                        'renewal_reg_num': row['renewal_reg_num'],
                        'renewal_defensive_num': row['renewal_defensive_num'],
                        'detailed_description': row['detailed_description'],
                        # 審判情報
                        'appeal_nums': row['appeal_nums'].split(',') if row['appeal_nums'] else [],
                        'appeal_types': self._format_appeal_types(row['appeal_types']),
                        # 中間記録（コードをマッピングして表示）
                        'progress_records': self._format_progress_records(row['progress_records'])
                    }
                
                # 指定商品・役務を追加
                if row['gs_class_num'] and row['goods_services_name']:
                    app_num_data[app_num]['goods_services'][row['gs_class_num']] = row['goods_services_name']
                
                # 類似群コードを追加
                if row['sg_class_num'] and row['similar_group_codes']:
                    app_num_data[app_num]['similar_groups'][row['sg_class_num']] = row['similar_group_codes'].split(',')
            
            # 検索種別固有データを追加
            for app_num, data in app_num_data.items():
                result = {
                    'basic_info': data,
                    'search_specific': search_specific_data.get(app_num, {}) if search_specific_data else {}
                }
                results.append(result)
        
        return results
    
    def _format_rejection_codes(self, codes_str: str) -> List[str]:
        """拒絶理由コードを条文記事に変換"""
        if not codes_str:
            return []
        
        formatted_codes = []
        for code in codes_str.split(','):
            code = code.strip()
            if code:
                # コードを条文記事に変換
                article = self.REJECTION_REASON_CODE_MAP.get(code)
                if article:
                    formatted_codes.append(article)
                else:
                    # マッピングがない場合はコードをそのまま表示
                    formatted_codes.append(code)
        
        return formatted_codes
    
    def _format_appeal_types(self, types_str: str) -> List[str]:
        """審判種別コードを日本語に変換"""
        if not types_str:
            return []
        
        formatted_types = []
        for type_code in types_str.split(','):
            type_code = type_code.strip()
            if type_code:
                # コードを日本語に変換
                type_name = self.APPEAL_TYPE_MAP.get(type_code, type_code)
                formatted_types.append(type_name)
        
        return formatted_types
    
    def _format_final_disposition(self, code: str) -> str:
        """最終処分コードを日本語の記事に変換"""
        if not code:
            return ""
        
        # FINAL_DISPOSITION_CODESを使って変換
        return self.FINAL_DISPOSITION_CODES.get(code, code)
    
    def _format_appeal_article_codes(self, codes_str: str) -> List[str]:
        """審判条文コードを日本語の条文記事に変換"""
        if not codes_str:
            return []
        
        formatted_codes = []
        for code in codes_str.split(','):
            code = code.strip()
            if code:
                # コードを条文記事に変換
                article = self.APPEAL_ARTICLE_CODE_MAP.get(code)
                if article:
                    formatted_codes.append(article)
                else:
                    # マッピングがない場合はコードをそのまま表示
                    formatted_codes.append(f"審判条文{code}")
        
        return formatted_codes
    
    def _format_progress_records(self, records_str: str) -> Dict[str, List[str]]:
        """中間記録コードを日本語に変換して分類して返す"""
        if not records_str:
            return {'exam': [], 'trial': [], 'registration': []}
        
        exam_records = []      # 審査中間記録
        trial_records = []     # 審判中間記録
        registration_records = [] # 登録中間記録
        
        for record in records_str.split('|'):
            if ':' in record:
                code, date = record.split(':', 1)
                
                # 空のコードはスキップ
                if not code:
                    continue
                
                # コードマッピングから日本語名を取得
                # JSONから読み込んだコードを使用（フォールバック付き）
                # 1. まず審査コード（A系）を確認
                code_name = self.examination_codes.get(code, None) if hasattr(self, 'examination_codes') else None
                if code_name is None and hasattr(self, 'INTERMEDIATE_CODE_MAP'):
                    code_name = self.INTERMEDIATE_CODE_MAP.get(code, None)
                
                # 2. 見つからない場合は審判コード（数字系・C系）を確認
                if code_name is None:
                    code_name = self.trial_codes.get(code, None) if hasattr(self, 'trial_codes') else None
                    if code_name is None and hasattr(self, 'TRIAL_INTERMEDIATE_CODE_MAP'):
                        code_name = self.TRIAL_INTERMEDIATE_CODE_MAP.get(code, None)
                
                # 3. それでも見つからない場合は登録コード（R系）を確認
                if code_name is None:
                    code_name = self.registration_codes.get(code, None) if hasattr(self, 'registration_codes') else None
                    if code_name is None and hasattr(self, 'REGISTRATION_INTERMEDIATE_CODE_MAP'):
                        code_name = self.REGISTRATION_INTERMEDIATE_CODE_MAP.get(code, None)
                
                # 4. 最後にマドプロコード（IB/MD/AP/M3系）を確認
                if code_name is None:
                    if hasattr(self, 'madrid_codes') and code in self.madrid_codes:
                        code_name = self.madrid_codes.get(code)
                    elif hasattr(self, 'madrid_genbo_codes') and code in self.madrid_genbo_codes:
                        code_name = self.madrid_genbo_codes.get(code)
                    elif hasattr(self, 'MADRID_INTERMEDIATE_CODE_MAP'):
                        code_name = self.MADRID_INTERMEDIATE_CODE_MAP.get(code, code)
                    else:
                        code_name = code
                
                # 日付をYYYY/MM/DD形式に変換
                if date and len(date) == 8:
                    formatted_date = f"{date[:4]}/{date[4:6]}/{date[6:]}"
                else:
                    formatted_date = date
                
                formatted_record = f"{code_name}:{formatted_date}"
                
                # コードの種別で分類
                first_char = code[0].upper()
                if first_char == 'R':
                    # R系 = 登録系
                    registration_records.append(formatted_record)
                elif first_char == 'C' or first_char.isdigit():
                    # C系または数字で始まる = 審判系
                    trial_records.append(formatted_record)
                else:
                    # A系およびその他（IB/MD/AP/M3など） = 審査系
                    exam_records.append(formatted_record)
        
        return {
            'exam': exam_records,
            'trial': trial_records,
            'registration': registration_records
        }
    
    # 特殊商標タイプマッピング（コードINDEX C1390準拠）
    SPECIAL_MARK_TYPE_MAP = {
        "1": "立体商標",
        "2": "音商標",
        "3": "動き商標",
        "4": "ホログラム商標",
        "5": "色彩のみからなる商標",
        "6": "位置商標",
        "9": "その他の商標"
    }
    
    def _determine_trademark_type(self, row) -> str:
        """商標タイプを判定（コードINDEX C1390準拠）
        
        Args:
            row: データベースの行データ
        
        Returns:
            商標タイプ名（標準文字/立体商標/音商標/etc）
        """
        # sqlite3.Rowオブジェクトを辞書に変換
        row_dict = dict(row) if not isinstance(row, dict) else row
        
        # 標準文字商標（最優先で表示）
        if row_dict.get('standard_char_exist') == '1':
            return '標準文字'
        
        # special_mark_existカラムに特殊商標タイプコードが格納されている
        # （データベースにspecial_mark_typeカラムが存在しないため）
        special_type = row_dict.get('special_mark_exist')
        if special_type and special_type != '0' and special_type in self.SPECIAL_MARK_TYPE_MAP:
            return self.SPECIAL_MARK_TYPE_MAP[special_type]
        
        # 通常商標（special_mark_exist が '0' またはNULL）
        return '通常'
    
    def _convert_code_to_name(self, code: str, code_type: str) -> str:
        """種別コードを日本語名に変換
        
        Args:
            code: 変換対象のコード
            code_type: コードの種類（'final_disposition', 'app_type', 'exam_type', 'decision_type'）
        
        Returns:
            日本語名（変換できない場合は元のコード）
        """
        if not code:
            return code
        
        # 半角を全角に変換してマッピングを試みる
        zenkaku_code = code.translate(str.maketrans('ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789', 
                                                    'ＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺ０１２３４５６７８９'))
        
        # コードタイプに応じて適切なマッピングを選択
        if code_type == 'final_disposition':
            # 審査最終処分と審判最終処分の両方を試す
            name = self.EXAMINATION_DISPOSITION_MAP.get(zenkaku_code)
            if not name:
                name = self.EXAMINATION_DISPOSITION_MAP.get(code)
            if not name:
                name = self.APPEAL_DISPOSITION_MAP.get(zenkaku_code)
            if not name:
                name = self.APPEAL_DISPOSITION_MAP.get(code)
            return name if name else code
        
        elif code_type == 'app_type':
            name = self.APPLICATION_TYPE_MAP.get(zenkaku_code)
            if not name:
                name = self.APPLICATION_TYPE_MAP.get(code)
            return name if name else code
        
        elif code_type == 'exam_type':
            name = self.EXAMINATION_TYPE_MAP.get(zenkaku_code)
            if not name:
                name = self.EXAMINATION_TYPE_MAP.get(code)
            return name if name else code
        
        elif code_type == 'decision_type':
            name = self.DECISION_TYPE_MAP.get(zenkaku_code)
            if not name:
                name = self.DECISION_TYPE_MAP.get(code)
            return name if name else code
        
        elif code_type == 'international_class_version':
            # 国際分類版のマッピング
            version_map = {
                'Z': '第12版',
                'Y': '第11版',
                'X': '第10版',
                'W': '第9版',
                'V': '第8版',
                'U': '第7版',
                'T': '第6版'
            }
            return version_map.get(code, code) if code else None
        
        else:
            return code
    
    # ========== 複合条件検索 ==========
    
    def _search_by_class_for_complex(self, class_num: str, limit: int = 10000) -> List[Dict[str, Any]]:
        """複合検索用の区分検索（内部メソッド）
        trademark_goods_servicesテーブルから直接検索する
        """
        cursor = self.conn.cursor()
        query = """
            SELECT DISTINCT
                tgs.app_num,
                tgs.class_num,
                ts.search_use_t as trademark_name,
                tci.app_date,
                tci.reg_date,
                tci.reg_article_reg_num as reg_num,
                tci.final_disposition_type,
                tci.law_code,
                tci.class_count
            FROM trademark_goods_services tgs
            LEFT JOIN trademark_search ts ON tgs.app_num = ts.app_num
            LEFT JOIN trademark_case_info tci ON tgs.app_num = tci.app_num
            WHERE tgs.class_num = ?
            LIMIT ?
        """
        cursor.execute(query, (class_num.zfill(2), limit))
        return [dict(row) for row in cursor.fetchall()]
    
    def search_complex(self, conditions: List[Dict[str, Any]], operator: str = 'AND', limit: int = 100, unified_format: bool = True) -> List[Dict[str, Any]]:
        """複合条件検索
        
        Args:
            conditions: 検索条件のリスト。各条件は以下の形式:
                       [{'type': 'trademark', 'keyword': 'プル'},
                        {'type': 'class', 'keyword': '09'}]
            operator: 条件の結合方法 ('AND' or 'OR')
            limit: 最大取得件数
            unified_format: 統一フォーマットで返すか
        
        Returns:
            検索結果リスト
        """
        if not conditions:
            return []
        
        # 各条件で検索を実行
        all_results = []
        for cond in conditions:
            search_type = cond.get('type')
            keyword = cond.get('keyword')
            print(f"[DEBUG] Processing condition: type={search_type}, keyword={keyword}")
            
            if not keyword:
                continue
            
            # 各検索タイプに応じて検索実行
            if search_type == 'trademark':
                results = self.search_trademark_name(keyword, limit=10000, unified_format=False)
            elif search_type == 'phonetic':
                results = self.search_phonetic(keyword, limit=10000, unified_format=False)
            elif search_type == 'phonetic_exact':
                results = self.search_phonetic(keyword, limit=10000, unified_format=False)
            elif search_type == 'class':
                # 複合検索用の区分検索メソッドを使用
                results = self._search_by_class_for_complex(keyword, limit=10000)
            elif search_type == 'applicant':
                results = self.search_applicant(keyword, limit=10000, unified_format=False)
            elif search_type == 'goods_services':
                results = self.search_goods_services(keyword, limit=10000, unified_format=False)
            elif search_type == 'app_num':
                # 出願番号検索（単一結果をリストに変換）
                result = self.search_by_app_num(keyword, unified_format=False)
                results = [result] if result else []
            elif search_type == 'reg_num':
                # 登録番号検索（単一結果をリストに変換）
                result = self.search_by_reg_num(keyword, unified_format=False)
                results = [result] if result else []
            elif search_type == 'similar_group':
                # 類似群コード検索
                results = self.search_by_similar_group(keyword, limit=10000, unified_format=False)
            elif search_type == 'rejection_reason':
                # 拒絶条文コード検索（例: "3?" 前方一致、"30" 完全一致、カンマ区切り複数可）
                results = self.search_by_rejection_code(keyword.strip(), limit=10000, unified_format=False)
            elif search_type == 'vienna_code':
                # ウィーンコード検索（例: "1.3.20" 階層的前方一致、複数指定可）
                results = self.search_by_vienna_code(keyword.strip(), limit=10000, unified_format=False)
            elif search_type == 'trademark_type':
                # 商標タイプ検索
                results = self.search_by_trademark_type(keyword.strip(), limit=10000, unified_format=False)
            elif search_type == 'intl_reg_num':
                # 国際登録番号検索
                import sys
                print(f"[DEBUG] Processing intl_reg_num search for: {keyword}", file=sys.stderr)
                results = self.search_by_intl_reg_num(keyword, limit=10000, unified_format=False)
                print(f"[DEBUG] intl_reg_num search returned {len(results)} results", file=sys.stderr)
                if results and len(results) > 0:
                    print(f"[DEBUG] First result keys: {list(results[0].keys())}", file=sys.stderr)
                    print(f"[DEBUG] First result app_num: {results[0].get('app_num')}", file=sys.stderr)
            elif search_type == 'date_range':
                # 日付範囲検索
                # keyword format: "date_type:YYYYMMDD:YYYYMMDD"
                parts = keyword.split(':')
                if len(parts) == 3:
                    date_type, start_date, end_date = parts
                    results = self.search_by_date_range(date_type, start_date, end_date, limit=10000, unified_format=False)
                else:
                    results = []
            else:
                continue
            
            # 拒絶条文コード検索の場合、詳細情報を保持
            if search_type == 'rejection_reason' and results:
                if not hasattr(self, '_temp_rejection_info'):
                    self._temp_rejection_info = {}
                for r in results:
                    if r.get('app_num'):
                        self._temp_rejection_info[r['app_num']] = {
                            'rejection_reason_code': r.get('rejection_reason_code'),
                            'intermediate_doc_code': r.get('intermediate_doc_code'),
                            'draft_date': r.get('draft_date'),
                            'dispatch_date': r.get('dispatch_date')
                        }
            
            app_nums = set(r.get('app_num') for r in results if r.get('app_num'))
            import sys
            print(f"[DEBUG] Collected {len(app_nums)} app_nums from {search_type}", file=sys.stderr)
            all_results.append(app_nums)
        
        if not all_results:
            return []
        
        # AND/OR演算
        import sys
        print(f"[DEBUG] all_results count: {len(all_results)}", file=sys.stderr)
        print(f"[DEBUG] operator: {operator}", file=sys.stderr)
        
        if operator == 'AND':
            # 全ての条件を満たす出願番号
            common_app_nums = set.intersection(*all_results) if all_results else set()
        else:  # OR
            # いずれかの条件を満たす出願番号
            common_app_nums = set.union(*all_results) if all_results else set()
        
        print(f"[DEBUG] common_app_nums count: {len(common_app_nums)}", file=sys.stderr)
        
        if not common_app_nums:
            return []
        
        # 統一フォーマットで結果を取得
        if unified_format:
            app_nums_list = list(common_app_nums)[:limit]
            print(f"[DEBUG] Calling _format_unified_result with {len(app_nums_list)} app_nums", file=sys.stderr)
            if app_nums_list:
                print(f"[DEBUG] Sample app_nums: {app_nums_list[:3]}", file=sys.stderr)
            search_specific = {}
            
            for app_num in app_nums_list:
                specific_data = {
                    'matched_conditions': [c.get('type') + ':' + c.get('keyword', '') for c in conditions],
                    'operator': operator
                }
                
                # 拒絶条文コード情報があれば追加
                if hasattr(self, '_temp_rejection_info') and app_num in self._temp_rejection_info:
                    rejection_info = self._temp_rejection_info[app_num]
                    # 拒絶条文コードを日本語に変換
                    if rejection_info.get('rejection_reason_code'):
                        code = rejection_info['rejection_reason_code']
                        rejection_info['rejection_reason_article'] = self.REJECTION_REASON_CODE_MAP.get(code, f"コード{code}")
                    specific_data.update(rejection_info)
                
                search_specific[app_num] = specific_data
            
            # 一時データをクリア
            if hasattr(self, '_temp_rejection_info'):
                delattr(self, '_temp_rejection_info')
            
            # マドプロ出願（____35で始まる）と通常出願を分離
            madrid_app_nums = [app_num for app_num in app_nums_list if app_num.startswith('20') and app_num[4:6] == '35']
            normal_app_nums = [app_num for app_num in app_nums_list if not (app_num.startswith('20') and app_num[4:6] == '35')]
            
            print(f"[DEBUG] Madrid app_nums: {len(madrid_app_nums)}, Normal app_nums: {len(normal_app_nums)}", file=sys.stderr)
            
            results = []
            
            # 通常出願の処理
            if normal_app_nums:
                results.extend(self._format_unified_result(normal_app_nums, search_specific))
            
            # マドプロ出願の処理（詳細フォーマット）
            if madrid_app_nums:
                cursor = self.conn.cursor()
                for app_num in madrid_app_nums[:limit - len(results)]:
                    # 基本情報の取得
                    cursor.execute("""
                        SELECT 
                            tbi.app_num,
                            tbi.intl_reg_num,
                            ts.search_use_t as trademark_name,
                            tbi.intl_reg_date,
                            tbi.instllmnt_expr_date_aft_des_date as after_designation_date,
                            tbi.set_reg_date as reg_date,
                            tbi.conti_prd_expire_date,
                            td.indct_use_t as trademark_display,
                            tsc.standard_char_t as standard_char
                        FROM trademark_basic_items tbi
                        LEFT JOIN trademark_search ts ON tbi.app_num = ts.app_num
                        LEFT JOIN trademark_display td ON tbi.app_num = ts.app_num
                        LEFT JOIN trademark_standard_char tsc ON tbi.app_num = ts.app_num
                        WHERE tbi.app_num = ?
                    """, (app_num,))
                    
                    row = cursor.fetchone()
                    if row:
                        # 称呼の取得
                        cursor.execute("""
                            SELECT GROUP_CONCAT(DISTINCT pronunciation) as phonetics
                            FROM trademark_pronunciations
                            WHERE app_num = ?
                        """, (app_num,))
                        phonetics_row = cursor.fetchone()
                        
                        # 名義人の取得（マドプロ用）
                        intl_reg_num = row['intl_reg_num']
                        cursor.execute("""
                            SELECT GROUP_CONCAT(DISTINCT holder_name) as holders,
                                   GROUP_CONCAT(DISTINCT holder_address) as holder_addresses
                            FROM intl_trademark_holders
                            WHERE intl_reg_num = ?
                        """, (intl_reg_num,))
                        holders_row = cursor.fetchone()
                        applicants = holders_row['holders'].split(',') if holders_row and holders_row['holders'] else []
                        applicant_addresses = holders_row['holder_addresses'].split(',') if holders_row and holders_row['holder_addresses'] else []
                        
                        # 区分の取得（マドプロ用）
                        cursor.execute("""
                            SELECT GROUP_CONCAT(DISTINCT madpro_class) as classes
                            FROM intl_trademark_goods_services
                            WHERE intl_reg_num = ?
                        """, (intl_reg_num,))
                        classes_row = cursor.fetchone()
                        
                        # 商品・役務の取得（英語・日本語）
                        cursor.execute("""
                            SELECT madpro_class, goods_service_name
                            FROM intl_trademark_goods_services
                            WHERE intl_reg_num = ?
                        """, (intl_reg_num,))
                        goods_services = {}
                        for gs_row in cursor.fetchall():
                            if gs_row['madpro_class'] and gs_row['goods_service_name']:
                                cls = str(gs_row['madpro_class'])
                                if cls not in goods_services:
                                    goods_services[cls] = []
                                goods_services[cls].append(gs_row['goods_service_name'])
                        
                        # 日本語の商品・役務を追加
                        cursor.execute("""
                            SELECT madpro_class, goods_service_japanese_name
                            FROM intl_trademark_goods_services_jp
                            WHERE jpo_rfr_num = ?
                        """, (app_num,))
                        for gs_row in cursor.fetchall():
                            if gs_row['madpro_class'] and gs_row['goods_service_japanese_name']:
                                cls = str(gs_row['madpro_class'])
                                if cls not in goods_services:
                                    goods_services[cls] = []
                                goods_services[cls].append(f"（日）{gs_row['goods_service_japanese_name']}")
                        
                        # 商品・役務リストを結合
                        for cls in goods_services:
                            goods_services[cls] = '、'.join(goods_services[cls])
                        
                        # 類似群コードの取得
                        cursor.execute("""
                            SELECT class_num, GROUP_CONCAT(DISTINCT similar_group_codes) as codes
                            FROM trademark_similar_group_codes
                            WHERE app_num = ?
                            GROUP BY class_num
                        """, (app_num,))
                        similar_groups = {}
                        for sg_row in cursor.fetchall():
                            if sg_row['class_num'] and sg_row['codes']:
                                similar_groups[sg_row['class_num']] = sg_row['codes'].split(',')
                        
                        # ウィーンコードの取得
                        cursor.execute("""
                            SELECT GROUP_CONCAT(DISTINCT 
                                CASE 
                                    WHEN large_class || '.' || mid_class || '.' || small_class IS NOT NULL 
                                    THEN large_class || '.' || mid_class || '.' || small_class
                                    ELSE NULL
                                END
                            ) as vienna_codes
                            FROM trademark_vienna_codes
                            WHERE app_num = ?
                        """, (app_num,))
                        vienna_row = cursor.fetchone()
                        
                        # 拒絶理由の取得
                        cursor.execute("""
                            SELECT GROUP_CONCAT(DISTINCT rejection_reason_code) as rejection_codes
                            FROM trademark_draft_records
                            WHERE app_num = ? AND rejection_reason_code IS NOT NULL
                        """, (app_num,))
                        rejection_row = cursor.fetchone()
                        
                        # 中間記録の取得
                        cursor.execute("""
                            SELECT intermediate_doc_code, creation_date
                            FROM trademark_draft_records
                            WHERE app_num = ? AND intermediate_doc_code IS NOT NULL
                            UNION ALL
                            SELECT intermediate_doc_code, receipt_date
                            FROM trademark_application_records
                            WHERE app_num = ? AND intermediate_doc_code IS NOT NULL
                            ORDER BY creation_date DESC
                        """, (app_num, app_num))
                        
                        progress_records = {'exam': [], 'trial': [], 'registration': []}
                        for pr_row in cursor.fetchall():
                            if pr_row['intermediate_doc_code']:
                                code = pr_row['intermediate_doc_code']
                                date = pr_row['creation_date']
                                
                                # コードを日本語に変換
                                code_name = self.intermediate_codes.get(code, code) if hasattr(self, 'intermediate_codes') else code
                                if date and len(str(date)) == 8:
                                    formatted_date = f"{date[:4]}/{date[4:6]}/{date[6:]}"
                                else:
                                    formatted_date = date
                                
                                record = f"{code_name}:{formatted_date}"
                                
                                # コードの種別で分類
                                first_char = code[0].upper() if code else ''
                                if first_char == 'R':
                                    progress_records['registration'].append(record)
                                elif first_char == 'C' or first_char.isdigit():
                                    progress_records['trial'].append(record)
                                else:
                                    progress_records['exam'].append(record)
                        
                        # 商標名の優先順位決定
                        trademark_name = row['trademark_display'] or row['standard_char'] or row['trademark_name'] or '[商標画像]'
                        
                        # 出願日の決定（事後指定日があれば優先、なければ国際登録日）
                        app_date = row['after_designation_date'] if (row['after_designation_date'] and 
                                                                     row['after_designation_date'] != '00000000' and 
                                                                     row['after_designation_date'] != '') else row['intl_reg_date']
                        
                        result = {
                            'basic_info': {
                                'app_num': row['app_num'],
                                'intl_reg_num': row['intl_reg_num'],
                                'trademark_name': trademark_name,
                                'app_date': app_date,
                                'reg_date': row['reg_date'],
                                'conti_prd_expire_date': row['conti_prd_expire_date'],
                                'phonetics': phonetics_row['phonetics'].split(',') if phonetics_row and phonetics_row['phonetics'] else [],
                                'applicants': applicants,
                                'applicant_addresses': applicant_addresses,
                                'classes': classes_row['classes'].split(',') if classes_row and classes_row['classes'] else [],
                                'goods_services': goods_services,
                                'similar_groups': similar_groups,
                                'vienna_codes': vienna_row['vienna_codes'].split(',') if vienna_row and vienna_row['vienna_codes'] else [],
                                'rejection_codes': self._format_rejection_codes(rejection_row['rejection_codes']) if rejection_row and rejection_row['rejection_codes'] else [],
                                'appeal_nums': [],
                                'appeal_types': [],
                                'progress_records': progress_records,
                                'intermediate_records': progress_records,
                                # マドプロ特有のフラグ
                                'is_madrid': True,
                                'final_disposition_type': None,
                                'final_disposition_date': None,
                                'law_code': None,
                                'trademark_type': '通常'
                            },
                            'search_specific': search_specific.get(app_num, {})
                        }
                        results.append(result)
            
            return results
        else:
            # 基本情報を取得して返す
            cursor = self.conn.cursor()
            # limitとIN句の制限を考慮
            app_nums_list = list(common_app_nums)[:min(limit, self.IN_CLAUSE_LIMIT)]
            placeholders = ','.join(['?'] * len(app_nums_list))
            query = f"""
                SELECT DISTINCT
                    tci.app_num,
                    tci.reg_article_reg_num as reg_num,
                    ts.search_use_t as trademark_name,
                    tci.app_date,
                    tci.reg_date,
                    tci.final_disposition_type,
                    tci.law_code,
                    tci.class_count
                FROM trademark_case_info tci
                LEFT JOIN trademark_search ts ON tci.app_num = ts.app_num
                WHERE tci.app_num IN ({placeholders})
                ORDER BY tci.app_date DESC
            """
            cursor.execute(query, app_nums_list)
            return [dict(row) for row in cursor.fetchall()]
    
    def close(self):
        """データベース接続を閉じる"""
        if self.conn:
            self.conn.close()

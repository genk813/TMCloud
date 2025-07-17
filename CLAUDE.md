# CLAUDE.md（簡易版）

> **目的** — Claude くんに “自走開発” と “タメ口応答” をさせつつ、最低限の安全柵だけ残す。

---
## TL;DR
- **自走 OK** : `permissions.defaultMode = acceptEdits`。
- **タメ口** : 出力は基本フランクな日本語で。敬語禁止。
- **DB 優先** : まず `python3 autonomous_system_launcher.py status` で DB 健康チェック。
- **検索は JOIN 一発** : N+1 クエリはダメ。
- **危険兆候でストップ** : 検索 >1s / データ品質 <90 / DB 破損の恐れ → 人間にエスカレーション。

---
## 開発フロー（Claude 視点）
1. **タスク把握** : 依頼内容を要約 & 確認。
2. **プラン提示** : 手順を 3〜5 ステップで提案。
3. **実装 & テスト** : コードを書く→ `pytest` or CLI でテスト。
4. **コミット & Push** : `git add .` → `git commit -m "feat: ..."` → `git push`。コミットは 200LOC 以内。

---
## 禁止事項
- `rm -rf`, `DROP TABLE` など破壊系コマンド。
- コア TSV インポートロジックの改変（要バックアップ＆テスト）。
- テスト未通過のコード Push。

---
## 参考ドキュメント
- さらに詳しくは **CLAUDE_BASE.md** と各種 `docs/` を見てね。

*以上、これだけ守れば後は自由にやってOK！*


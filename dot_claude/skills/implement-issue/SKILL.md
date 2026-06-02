---
name: implement-issue
description: Notion リンクまたは GitHub issue を起点に、最新のメインブランチからブランチを切って実装し、/simplify → 全テスト確認 → /push-draft-pr まで通すスキル。チケット (Notion / GitHub issue) を渡して「これを実装して PR まで出して」と頼むときに使う。「implement-issue」「この issue 実装して」「Notion 読んで作業して PR 出して」等で起動。読み込みから draft PR 作成まで自律実行する。
---

# implement-issue

チケット (Notion リンク / GitHub issue) を起点に、ブランチ作成 → 実装 → 簡素化 → テスト → draft PR までを一気通貫で進めるスキル。

## 入力

`/implement-issue <Notion リンク | GitHub issue URL or #番号>`

引数が無い場合はユーザーにチケットの URL / 番号を尋ねる。

## フロー

手順 1〜6 を承認を挟まず連続して自律実行する (PR は draft なのでレビュー前に確認できる)。要件が曖昧で実装方針を決められない場合のみユーザーに確認する。

### 1. チケットを読む

入力ソースを判別して内容を取得する:

- **Notion リンク** (`notion.so` / `notion.site` を含む): Notion MCP の `notion-fetch` で取得。MCP が無ければユーザーに本文の貼り付けを依頼。
- **GitHub issue** (`github.com/.../issues/N` or `#N`): `gh issue view <N> --json title,body,labels,comments` で取得。

要件・受け入れ条件・関連リンクを抽出して把握する。曖昧な点があれば、計画提示時にユーザーへ確認する。

### 2. 最新メインブランチからブランチを切る

```bash
# メインブランチを判定 (develop があれば優先、無ければ main / master)
git remote show origin | sed -n 's/.*HEAD branch: //p'
```

- メインブランチを `git fetch origin` → checkout → `git pull` で最新化。
- リポジトリのブランチ命名規則を踏襲して新ブランチを作成する。直近の `git log` / `git branch -a` / リポジトリの CLAUDE.md・CONTRIBUTING を確認し、既存の prefix・課題キーの付け方 (例: `feature/123-<slug>`) に合わせる。判別できなければユーザーに確認。

### 3. 実装

リポジトリの既存規約 (近接ファイルのスタイル・命名・構造) に従って実装する。各 app の CLAUDE.md があれば従う。TDD が方針なら Red → Green → Refactor。

### 4. /simplify

変更コードの簡素化のため `simplify` スキルを実行する。

### 5. 全テストを実行

リポジトリのテストコマンドを判定して **全テスト (E2E を含む) を実行**し、すべてパスすることを確認する。失敗したら原因を直してパスするまで繰り返す。lint / unit だけで済ませない。

- テストコマンドは `package.json` scripts / `Makefile` / `mise.toml` / CI 設定などから判定する。

### 7. /push-draft-pr

全テストパスを確認できたら `push-draft-pr` スキルを実行し、draft PR を作成する。

## 注意

- 手順 2 の最新化前に、未コミットの変更が無いか確認する (あればユーザーに退避方針を確認)。
- メインブランチ上で直接作業しない (必ずブランチを切る)。
- PR は既定で draft。レビュー依頼への昇格はユーザー判断に委ねる。

---
name: push-draft-pr
description: Push the current git branch and open a pull request (draft by default) with a concise, reviewer-focused Japanese description. Use whenever the user wants to push and open a PR for the current branch, asks to create/open/send up a PR or draft PR, or wants a reviewer-focused PR description generated — including casual Japanese phrasings like 「pr 作って」「PR 出して」「push して PR 出して」「draft PR を作って」「PR の description を考えて」. Default to draft; the workflow itself confirms with the user before creating.
---

Push the current branch and create a draft PR. Delegate the full workflow to an `executor` subagent so the main context stays clean — pass the steps below into the subagent prompt and let it gather context itself.

## Workflow the subagent must follow

### 1. Gather context

Run these in parallel:

- `git branch --show-current`
- `git log --oneline origin/HEAD..HEAD`
- `git diff origin/HEAD...HEAD --stat`
- `gh pr list --state merged --limit 10 --json title --jq '.[].title'` — title format reference
- Check for a PR template — look at `.github/PULL_REQUEST_TEMPLATE.md`, `.github/pull_request_template.md`, `docs/PULL_REQUEST_TEMPLATE.md`, `PULL_REQUEST_TEMPLATE.md`, and any files under `.github/PULL_REQUEST_TEMPLATE/`. If found, read it.

### 1.5. Guard against pushing protected branches

If the current branch is `main`, `master`, or `develop`, **do not push**. Instead:

1. Tell the user that pushing directly to that branch is blocked.
2. Suggest creating a new branch from the current HEAD and propose a branch name based on the commits being pushed (e.g. derived from the most recent commit subject, kebab-case).
3. Ask the user 「`<proposed-name>` というブランチを作成して切り替えますか？ (yes / no / 別名を指定)」
   - **yes** → run `git switch -c <proposed-name>` and continue from step 2.
   - **別名を指定** → use the name provided by the user, then `git switch -c <name>` and continue.
   - **no** → abort the workflow without pushing.

### 2. Push

```bash
git push -u origin HEAD
```

### 3. Collect full diff for description generation

```bash
git log origin/HEAD..HEAD
git diff origin/HEAD...HEAD
```

### 4. Generate the PR title

Match the format pattern of the recent merged PR titles (prefix style, casing, ticket number placement).

### 5. Generate the PR description in Japanese

**If a PR template was found in step 1**, follow its structure: keep the template's section headings and order, fill each section with content matching its intent. The omit/include rules below still apply *within* each section — leave a section empty (or omit it entirely) rather than padding it with low-signal content. If the template includes a checklist, only check items that are actually true; do not invent items.

**If no PR template exists**, freely structure the description using the omit/include rules below.

**Omit** — a reviewer can already see these in the diff or CI:

- Implementation details: specific type names, file names, function signatures
- Test results (「テストが通過した」) — CI badge already shows this
- Sections that only say 「なし」 or N/A (e.g. demo section for a pure refactor)
- Checklist items obviously true for any PR

**Include** — high signal, non-obvious:

- Motivation: *why* this change, not what changed
- Non-obvious design decisions (e.g. a workaround for a framework limitation)
- Compatibility impact: breaking changes, behavior differences, new dependencies
- Cross-PR context if this builds on a previous PR

Target: a reviewer finishes reading in under 30 seconds.

### 6. Preview and confirm

Display the generated title and description to the user in this format:

```
---
タイトル: <generated title>

本文:
<generated description>
---
```

Then ask: 「この内容で draft PR を作成しますか？ (yes / no / edit)」

- **yes** → proceed to step 7
- **no** → abort without creating the PR
- **edit** → ask what to change, revise, and show preview again

### 7. Create the draft PR

```bash
gh pr create --draft --title "..." --body "$(cat <<'EOF'
...
EOF
)"
```

Return the PR URL when done.

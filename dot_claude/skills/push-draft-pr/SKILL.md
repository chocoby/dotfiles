---
name: push-draft-pr
description: Push the current git branch and open a pull request (draft by default) with a concise, reviewer-focused Japanese description. Use whenever the user wants to push and open a PR for the current branch, asks to create/open/send up a PR or draft PR, or wants a reviewer-focused PR description generated — including casual Japanese phrasings like 「pr 作って」「PR 出して」「push して PR 出して」「draft PR を作って」「PR の description を考えて」. Default to draft; the workflow itself confirms with the user before creating.
---

Push the current branch and create a draft PR.

## Why interaction stays in the main context

A subagent cannot pause to ask the user a question — it runs autonomously to completion. So **any step that requires user confirmation MUST run in the main context, never inside a subagent.** A subagent that reaches a "confirm with the user" step will just proceed on its own and create the PR prematurely.

Therefore the work is split into phases. Delegate only the non-interactive phases to an `executor` subagent; keep every confirmation in the main context.

## Phase A — Protected-branch guard (main context)

Run `git branch --show-current`.

If the branch is `main`, `master`, or `develop`, **do not push**:

1. Tell the user that pushing directly to that branch is blocked.
2. Propose a new branch name derived from the most recent commit subject (kebab-case).
3. Ask 「`<proposed-name>` というブランチを作成して切り替えますか？ (yes / no / 別名を指定)」
   - **yes** → `git switch -c <proposed-name>`, then continue to Phase B.
   - **別名を指定** → `git switch -c <name>` with the user's name, then continue.
   - **no** → abort the workflow.

Otherwise continue to Phase B.

## Phase B — Prepare (delegate to `executor` subagent)

The subagent does everything below and **returns the generated title and description as text. It MUST NOT run `gh pr create` and MUST NOT ask the user anything.** Make this explicit in the subagent prompt:

> Do not create the PR. Do not ask any questions. Push the branch, then generate the title and description, and return them as your final message. Stop there.

Subagent steps:

### B1. Resolve the base branch

`origin/HEAD` is not always set locally (common after `git remote add` or some clones), and `git log origin/HEAD..` then fails with `ambiguous argument`. Resolve a base ref up front and use it everywhere below:

```bash
base=$(git rev-parse --abbrev-ref origin/HEAD 2>/dev/null)
if [ -z "$base" ]; then git remote set-head origin -a >/dev/null 2>&1; base=$(git rev-parse --abbrev-ref origin/HEAD 2>/dev/null); fi
[ -z "$base" ] && base=origin/main
echo "$base"
```

In the commands below, substitute the resolved value for `<base>`.

### B2. Gather context (run in parallel)

- `git log <base>..HEAD` — the commits being pushed (also used for the description). **If this is empty, there are no commits to PR — stop and tell the user instead of pushing.**
- `git diff <base>...HEAD` — the full diff for the description
- `gh pr list --state merged --limit 10 --json title --jq '.[].title'` — title format reference
- `gh pr list --head "$(git branch --show-current)" --state open --json url,number,isDraft` — **check for an existing open PR on this branch.** If one exists, do not plan to create a new one; capture its URL and report it in B7 (Phase D will update it instead of creating a duplicate).

### B3. Find the PR template (do not skip)

This step is mandatory — the description in B6 depends on it. Run this single discovery command to list every template candidate at once (case-insensitive, covers all GitHub-recognized locations):

```bash
find . .github docs .github/PULL_REQUEST_TEMPLATE docs/PULL_REQUEST_TEMPLATE PULL_REQUEST_TEMPLATE -maxdepth 1 -iname '*pull_request_template*' 2>/dev/null
```

- If the command prints one or more paths, **read every one** with the Read tool. Note the path(s); a template was found.
- If it prints nothing, no template exists. Record that explicitly.

Do not generate the description until this step has run and you know which case you are in.

### B4. Push

```bash
git push -u origin HEAD
```

### B5. Generate the PR title

Match the format pattern of the recent merged PR titles (prefix style, casing, ticket number placement).

### B6. Generate the PR description in Japanese

**If B3 found a template**, you MUST follow its structure: keep the template's section headings and order, fill each section with content matching its intent. The omit/include rules below still apply *within* each section — leave a section empty (or omit it entirely) rather than padding it with low-signal content. If the template includes a checklist, only check items that are actually true; do not invent items.

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

### B7. Return the result

Return to the main context as your final message, then stop:

- the generated title and description,
- which PR template you applied (the path), or that no template was found, and
- whether an open PR already exists for this branch (its URL), or none.

## Phase C — Preview and confirm (main context)

Display the title and description returned by the subagent in this format. Include the template line so the user can see whether the repo's PR template was applied:

```
---
タイトル: <generated title>
テンプレート: <applied template path, or 「なし」>

本文:
<generated description>
---
```

Then ask — **the wording depends on whether B7 reported an existing open PR**:

- No existing PR → 「この内容で draft PR を作成しますか？ (yes / no / edit)」
- An open PR already exists (show its URL) → 「このブランチには既に PR があります (<url>)。この内容で PR の説明を更新しますか？ (yes / no / edit)」

Then:

- **yes** → proceed to Phase D
- **no** → abort without creating or updating the PR
- **edit** → ask what to change, revise the title/description in place (the branch is already pushed — do not re-run Phase B), and show the preview again

Do not proceed to Phase D until the user has explicitly answered **yes**.

## Phase D — Create or update the PR (after the user says yes)

Write the body to a temp file with the **Write tool** (not a shell heredoc), then pass it via `--body-file`. This avoids shell escaping that can mangle code blocks / backticks in the description.

1. Write the confirmed description verbatim to a temp file, e.g. `/tmp/pr-body.md`, using the Write tool. Do **not** escape backticks, backslashes, or fenced code blocks — the body must be the literal markdown that should appear in the PR.
2. Create or update the PR:
   - **No existing PR** — create a draft:

     ```bash
     gh pr create --draft --title "..." --body-file /tmp/pr-body.md
     ```

   - **An open PR already exists** (from B7) — update it instead of creating a duplicate:

     ```bash
     gh pr edit <url> --title "..." --body-file /tmp/pr-body.md
     ```

3. Remove the temp file: `rm -f /tmp/pr-body.md`

Return the PR URL when done.

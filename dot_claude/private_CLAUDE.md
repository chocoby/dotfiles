## Language

- Code comments & commits: English

## Code Standards

- Add spaces between Japanese and alphanumeric characters
- Use half-width parentheses () instead of full-width （） (surround with spaces per the spacing rule above)
- Follow existing conventions in nearby files (style, naming, structure)

## Commit Convention

- Always commit in a single line — no body, no footer.
- If the project defines its own commit convention (CONTRIBUTING.md, recent `git log`, commit hooks, etc.), follow it (still one line).
- Otherwise, use Conventional Commits: `<type>(<scope>): <subject>` (scope optional).
  - Types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`

## Development Style

- Follow TDD: explore → Red → Green → Refactor
- Ask clarifying questions when instructions are ambiguous

## Git Signing (1Password)

Signing goes through the 1Password SSH agent (`op-ssh-sign`, `commit.gpgsign = true`) and hangs
until timeout when 1Password is locked or its prompt is unanswered. Never stall the whole task on
it, and never disable `commit.gpgsign` or edit the git config to get around it.

- Signing hang (`git commit`, or a merge commit from `git pull`): retry with `--no-gpg-sign` and
  keep going, then report the commits are unsigned and ask whether to re-sign them
  (`git commit --amend --no-edit -S`, or `git rebase --exec '...' <base>` for several).
- Auth hang (`git push`, `git fetch`, the fetch half of `git pull`): the agent is blocked, not the
  signer, so `--no-gpg-sign` does nothing. Defer the network step, carry on with local work (edit,
  commit, test), and retry it once at the end. After the first hang, skip further network calls in
  between rather than timing out on each.
- Deferred steps are unfinished work: track them and list them in the completion report, in the
  order they need to run. If the retry still hangs, ask the user to unlock 1Password.
- A deferred `fetch`/`pull` means working from a stale base. Say so, and ask first before branching
  off a remote-tracking ref that could not be updated.

## RTK

@RTK.md


<!-- OMC:IMPORT:START -->
@CLAUDE-omc.md
<!-- OMC:IMPORT:END -->

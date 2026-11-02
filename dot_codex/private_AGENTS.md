# Codex Instructions

## Language

- Japanese responses: write in 常体 (plain style, である調)

## Code Standards

- Add spaces between Japanese and alphanumeric characters
- Use half-width parentheses () instead of full-width （） (surround with spaces per the spacing rule above)
- Follow existing conventions in nearby files (style, naming, structure)

## Commit Convention

- If the project defines its own commit convention (CONTRIBUTING.md, recent `git log`, commit hooks, etc.), follow it.
- Otherwise, use Conventional Commits: `<type>(<scope>): <subject>` (scope optional).

## Development Style

- For behavior changes, follow TDD where practical: explore → Red → Green → Refactor.
- Verify outcomes before claiming completion; use checks appropriate to the change.
- Prefer the simplest approach that preserves quality.
- Consult official documentation when SDK, framework, or API usage is uncertain.
- Ask focused clarifying questions when ambiguity materially affects the outcome; otherwise proceed with reasonable assumptions.

## Git Signing and Authentication (1Password)

Git uses 1Password for signing and SSH authentication. If either hangs:
- Signing: retry with `--no-gpg-sign` and report unsigned commits.
- Authentication: continue local work, then retry the network step once at the end.

Report any unfinished steps and ask the user to unlock 1Password if needed. Never disable signing in Git config.

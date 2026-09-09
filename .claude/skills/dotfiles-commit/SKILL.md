---
name: dotfiles-commit
description: Stage and commit changes in this dotfiles repo using Conventional Commits
---

# Dotfiles Commit

Use this skill when the user wants to commit changes in this dotfiles repository.

## Commit Message Convention

Format: `<type>(<scope>): <subject>` — single line, no body, no footer, no trailing period.

- `<type>`: see Type Guidelines below.
- `<scope>`: lowercase component name from the mapping table (omit only when truly cross-cutting).
- `<subject>`: imperative mood, lowercase first word, concise.

Examples:
- `feat(tmux): enable extended keys`
- `feat(ghostty): enable left Option key as Alt`
- `feat(mise): install gnupg on macOS`
- `feat(git): add git-commit-with-claude script and gcic alias`
- `fix(homebrew): correct package name`
- `chore(claude): update permissions`
- `chore(chezmoi): add zsh to brew bundle`
- `refactor(neovim): migrate nvim-treesitter to main branch`

## Scope Mapping

Determine the scope from changed file paths:

| Path pattern | Scope |
|---|---|
| `dot_config/nvim/` or `nvim` | `neovim` |
| `dot_config/ghostty/` | `ghostty` |
| `dot_config/tmux/` or `dot_tmux` | `tmux` |
| `.mise.toml` or `mise/` | `mise` |
| `.claude/` or `dot_claude/` | `claude` |
| `dot_config/starship.toml` | `starship` |
| `Brewfile` or homebrew-related | `homebrew` |
| `.chezmoi*` or chezmoi config | `chezmoi` |
| `dot_config/git/` or `.gitconfig` | `git` |
| Multiple components | Use the primary one, or omit scope if truly cross-cutting |

## Type Guidelines

- `feat` — new config, new feature, new tool enabled
- `fix` — correct a bug or broken config
- `docs` — documentation only (README, CLAUDE.md, skill docs, comments)
- `refactor` — restructure without behavior change (e.g. migrate to new API/branch)
- `chore` — maintenance: dependency/version bumps, permissions, housekeeping
- `revert` — undo a previous change

When in doubt between `feat` and `chore`: user-visible behavior change → `feat`; internal upkeep → `chore`.

## Workflow

1. Run `git status` to see what has changed.
2. Run `git diff` (unstaged) and `git diff --cached` (staged) to understand the changes.
3. Identify the scope(s) from the file paths using the mapping table.
4. Determine the most appropriate type from the guidelines.
5. Craft a concise subject in imperative mood (lowercase first word, no trailing period).
6. Show the proposed commit message to the user and ask for confirmation before committing.
7. Stage the relevant files (`git add`) — prefer specific files over `git add -A`.
8. Commit with the agreed message.

## Rules

- Always confirm the commit message with the user before committing.
- Never use `git add -A` without listing what will be staged.
- Do not push unless the user explicitly requests it.
- Keep the subject short — one line, no trailing punctuation.
- If changes span multiple scopes, prefer the primary scope or split into separate commits.

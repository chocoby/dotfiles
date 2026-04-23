---
name: dotfiles-commit
description: Stage and commit changes in this dotfiles repo using the established commit message convention
---

# Dotfiles Commit

Use this skill when the user wants to commit changes in this dotfiles repository.

## Commit Message Convention

Format: `{Component}: {Verb} {description}`

Examples from history:
- `Neovim: Migrate nvim-treesitter to main branch`
- `Claude: Update permissions`
- `Homebrew: Fix package name`
- `Tmux: Enable extended keys`
- `Mise: Install gnupg on macOS`
- `Ghostty: Enable left Option key as Alt`
- `Git: Add git-commit-with-claude script and gcic alias`
- `Chezmoi: Add zsh to brew bundle`

## Component Mapping

Determine the component from changed file paths:

| Path pattern | Component |
|---|---|
| `dot_config/nvim/` or `nvim` | `Neovim` |
| `dot_config/ghostty/` | `Ghostty` |
| `dot_config/tmux/` or `dot_tmux` | `Tmux` |
| `.mise.toml` or `mise/` | `Mise` |
| `.claude/` or `dot_claude/` | `Claude` |
| `dot_config/starship.toml` | `Starship` |
| Multiple components | Use the primary one or the most significant |

## Verb Guidelines

Choose an imperative verb that best describes the change:

- `Add` — new file, new config, new feature
- `Update` — modify existing config or version
- `Fix` — correct a bug or broken config
- `Remove` — delete file or config entry
- `Enable` / `Disable` — toggle a feature/option
- `Migrate` — move to new API/format/branch
- `Install` — add a new tool
- `Manage` — take over management of something
- `Pin` — lock to specific version/commit
- `Setup` — initial configuration
- `Switch` — change from one thing to another
- `Revert` — undo a previous change

## Workflow

1. Run `git status` to see what has changed.
2. Run `git diff` (unstaged) and `git diff --cached` (staged) to understand the changes.
3. Identify the component(s) from the file paths using the mapping table.
4. Determine the most appropriate verb from the guidelines.
5. Craft a concise description in imperative mood (no trailing period).
6. Show the proposed commit message to the user and ask for confirmation before committing.
7. Stage the relevant files (`git add`) — prefer specific files over `git add -A`.
8. Commit with the agreed message.

## Rules

- Always confirm the commit message with the user before committing.
- Never use `git add -A` without listing what will be staged.
- Do not push unless the user explicitly requests it.
- Keep the description short — one line, no trailing punctuation.
- If changes span multiple components, prefer the primary component or split into separate commits.

# Chezmoi Dotfiles

This repository is the chezmoi **source directory** (`~/.local/share/chezmoi`).
Editing files here does NOT affect `$HOME` until `chezmoi apply` is run.

## File naming conventions

- `dot_foo` → `~/.foo` (e.g. `dot_claude/CLAUDE.md` → `~/.claude/CLAUDE.md`)
- `executable_foo` → adds `chmod +x`
- `private_foo` → enforces `0600` permissions
- `*.tmpl` → Go template, rendered at apply time

## Workflow

1. Edit the source file under this repo
2. `chezmoi diff` to preview what will change in `$HOME`
3. `chezmoi apply` to materialize the change
4. Verify the applied file works, then commit

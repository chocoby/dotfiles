---
description: Generate a commit message based on current branch state
---

## Context

- Current branch: !`git branch --show-current`
- Git status: !`git status`
- Staged and unstaged diff: !`git diff HEAD`
- Recent commits (for style reference): !`git log --oneline -10`

## Your task

Based on the above changes, generate an appropriate commit message.

Rules:
- Write commit messages in English
- Use conventional commit format when appropriate (e.g., `feat:`, `fix:`, `refactor:`, `docs:`, `ci:`, `chore:`)
- Keep the message concise — summary line only, no bullet points
- Focus on the "why" or overall intent, not a list of changed files
- Do NOT stage or commit anything — only output the commit message

Output only the commit message string, nothing else.

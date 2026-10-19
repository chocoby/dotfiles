#!/bin/bash

case "$1" in
    approval) message='Codex が承認を求めています' ;;
    complete) message='Codex のタスクが完了しました' ;;
    *) exit 0 ;;
esac

if ! { exec 3>/dev/tty; } 2>/dev/null; then
    exit 0
fi

if [ -n "${TMUX-}" ]; then
    printf '\033Ptmux;\033\033]9;%s\007\033\\' "$message" >&3
else
    printf '\033]9;%s\007' "$message" >&3
fi

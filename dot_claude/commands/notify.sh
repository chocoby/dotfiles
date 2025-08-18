#!/bin/bash

# Check if running on macOS
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS - use osascript
    if [ "$1" == "notification" ]; then
        osascript -e 'display notification "Claude Code が許可を求めています" with title "Claude Code" subtitle "確認待ち" sound name "Glass"'
    elif [ "$1" == "stop" ]; then
        osascript -e 'display notification "タスクが完了しました" with title "Claude Code" subtitle "処理終了" sound name "Hero"'
    fi
else
    # Other OS - no notification (silent)
    exit 0
fi

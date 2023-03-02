#!/bin/bash

function help_command() {
    CHAT_ID="$1"
    curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
        -d chat_id="$CHAT_ID" \
        -d text="I can do the following commands:\n\n/rename - Rename a file or video. Reply to the file or video that you want to rename, and then enter the new name when prompted.\n\nIf you're renaming a video, you can choose to output it in either document or streamable video format." \
        -d parse_mode="Markdown"
}

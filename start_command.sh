#!/bin/bash

function start_command() {
    CHAT_ID="$1"
    curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
        -d chat_id="$CHAT_ID" \
        -d text="Hi! I'm a bot that can help you rename files and videos. To use me, reply to a file or video with the /rename command." \
        -d parse_mode="Markdown"
}

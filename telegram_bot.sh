#!/bin/bash

# Set the Telegram bot token
TELEGRAM_BOT_TOKEN="6145559264:AAEkUH_znhpaTdkbnndwP1Vy2ppv-C9Zf4o"

# Start the bot
while true; do
    # Get the updates from Telegram
    UPDATES=$(curl -s "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/getUpdates")

    # Parse the updates and process the commands
    if [[ "$UPDATES" == '{"ok":true'* ]]; then
        UPDATES=$(echo "$UPDATES" | jq -r '.result[] | {message_id: .message.message_id, chat_id: .message.chat.id, command: .message.text, reply_to_message_id: .message.reply_to_message.message_id}')
        while read -r UPDATE; do
            MESSAGE_ID=$(echo "$UPDATE" | jq -r '.message_id')
            CHAT_ID=$(echo "$UPDATE" | jq -r '.chat_id')
            COMMAND=$(echo "$UPDATE" | jq -r '.command')
            REPLY_TO_MESSAGE_ID=$(echo "$UPDATE" | jq -r '.reply_to_message_id')
            case "$COMMAND" in
                "/start")
                    source ./start_command.sh
                    start_command "$CHAT_ID"
                    ;;
                "/help")
                    source ./help_command.sh
                    help_command "$CHAT_ID"
                    ;;
                "/rename")
                    source ./rename_command.sh
                    rename_command "$MESSAGE_ID" "$CHAT_ID" "$REPLY_TO_MESSAGE_ID"
                    ;;
            esac
        done <<< "$UPDATES"
    fi

    # Sleep for 1 second before checking for new updates
    sleep 1
done

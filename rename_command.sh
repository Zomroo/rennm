#!/bin/bash

function rename_command() {
    MESSAGE_ID="$1"
    CHAT_ID="$2"
    REPLY_TO_MESSAGE_ID="$3"
    if [[ -n "$REPLY_TO_MESSAGE_ID" ]]; then
        FILE_INFO=$(curl -s "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/getFile" -d file_id="$(echo "$UPDATES" | jq -r ".[] | select(.message.message_id == $REPLY_TO_MESSAGE_ID) | .message.document.file_id // .message.video.file_id)") || true
        FILE_PATH=$(echo "$FILE_INFO" | jq -r '.result.file_path')
        FILE_NAME=$(basename "$FILE_PATH")
        FILE_EXT="${FILE_NAME##*.}"
        NEW_NAME=$(curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
            -d chat_id="$CHAT_ID" \
            -d text="What would you like to rename the file or video to?" \
            -d reply_to_message_id="$MESSAGE_ID" \
            -d allow_sending_without_reply=true \
            -d reply_markup="{\"force_reply\":true}" | jq -r '.result.message_id as $mid | "{\"callback_data\": \"$mid\"}"')
        NEW_NAME=$(curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
            -d chat_id="$CHAT_ID" \
            -d text="$NEW_NAME" \
            -d parse_mode="Markdown" \
            -d reply_to_message_id="$MESSAGE_ID" \
            -d allow_sending_without_reply=true \
            -d reply_markup="{\"inline_keyboard\":[[{\"text\":\"Cancel\",\"callback_data\":\"cancel\"}]]}")
        NEW_NAME_MESSAGE_ID=$(echo "$NEW_NAME" | jq -r '.result.message_id')
        sleep 1
        while true; do
            CALLBACK_QUERY=$(curl -s "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/getUpdates" | jq -r ".result[] | select(.callback_query != null and .callback_query.message.message_id == $NEW_NAME_MESSAGE_ID)")
            if [[ -n "$CALLBACK_QUERY" ]]; then
                CALLBACK_QUERY_ID=$(echo "$CALLBACK_QUERY" | jq -r '.callback_query.id')
                CALLBACK_QUERY_DATA=$(echo "$CALLBACK_QUERY" | jq -r '.callback_query.data')
                if [[ "$CALLBACK_QUERY_DATA" == "cancel" ]]; then
                    curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/deleteMessage" \
                        -d chat_id="$CHAT_ID" \
                        -d message_id="$NEW_NAME_MESSAGE_ID"
                    curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/answerCallbackQuery" \
                        -d callback_query_id="$CALLBACK_QUERY_ID"
                    break
                else
                    NEW_FILE_NAME=$(echo "$CALLBACK_QUERY" | jq -r '.callback_query.data')
                    NEW_FILE_NAME="${NEW_FILE_NAME%\"}"
                    NEW_FILE_NAME="${NEW_FILE_NAME#\"}"
                    NEW_FILE_NAME=$(echo "$NEW_FILE_NAME" | tr -dc '[:alnum:]\n\r')
                    if [[ -n "$NEW_FILE_NAME" ]]; then
                        NEW_FILE_NAME="$NEW_FILE_NAME.$FILE_EXT"
                        NEW_FILE_PATH="/tmp/$NEW_FILE_NAME"
                        curl -s "https://api.telegram.org/file/bot$TELEG_RAM_BOT_TOKEN/getFile" -d file_path="$FILE_PATH" -o "$NEW_FILE_PATH"
curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendDocument"
-F chat_id="$CHAT_ID"
-F document=@"$NEW_FILE_PATH"
-F reply_to_message_id="$REPLY_TO_MESSAGE_ID"
curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/deleteMessage"
-d chat_id="$CHAT_ID"
-d message_id="$NEW_NAME_MESSAGE_ID"
curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/answerCallbackQuery"
-d callback_query_id="$CALLBACK_QUERY_ID"
fi
break
fi
fi
sleep 1
done
else
curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage"
-d chat_id="$CHAT_ID"
-d text="Please reply to a message with a file or video to rename"
-d reply_to_message_id="$MESSAGE_ID"
fi
}

#Sample usage
rename_command "123" "456" "789" # Replace the arguments with your own values.

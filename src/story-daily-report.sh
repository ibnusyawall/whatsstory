#!/data/data/com.termux/files/usr/bin/bash

# === CONFIG ===
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
fi

DEST_DIR="/storage/emulated/0/.DailyStoryWa"
LOG_DIR="$DEST_DIR/logs"
TODAY=$(date '+%Y-%m-%d')
LOG_FILE="$LOG_DIR/$TODAY.log"

# === FUNCTION: Send Telegram Notification ===
send_telegram() {
  curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
    -d chat_id="$TELEGRAM_CHAT_ID" \
    -d parse_mode="markdown" \
    -d text="$1" > /dev/null
}

# === CEK LOG HARI INI ===
if [ ! -f "$LOG_FILE" ]; then
  send_telegram "No WA status activity log found for $TODAY."
  exit 0
fi

# === PARSE LOG ===
copied=$(grep -c "Copied today" "$LOG_FILE")
archived=$(grep -c "Archived" "$LOG_FILE")

# === KIRIM NOTIF ===
MESSAGE="*Daily WA Story Report* (%F0%9F%93%85 $TODAY)

- Copied today: $copied
- Archived: $archived
- Log: $LOG_FILE"

send_telegram "$MESSAGE"

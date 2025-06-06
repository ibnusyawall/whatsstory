#!/data/data/com.termux/files/usr/bin/bash

# === CONFIG ===
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
fi

PAUSE_FLAG="$HOME/whatsstory/.paused"
LOG_DIR="$HOME/whatsstory/logs"
SCRIPT_SAVER="$HOME/whatsstory/src/story-daily-saver.sh"
INTERVAL=900  # 15 menit

send_telegram() {
  local msg="$1"
  curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
    -d chat_id="$TELEGRAM_CHAT_ID" \
    -d parse_mode="markdown" \
    -d text="$msg" || echo "[ERROR] Gagal kirim notif Telegram di $(date)" >> "$LOGFILE"
}

get_logfile() {
  mkdir -p "$LOG_DIR"
  echo "$LOG_DIR/story-saver-$(date +%F).log"
}

LOGFILE="$(get_logfile)"
trap 'echo "[ERROR] Script terminated at $(date)" >> "$LOGFILE"' EXIT
trap 'echo "[SIGTERM] Script kena terminate sinyal di $(date)" >> "$LOGFILE"' SIGTERM
trap 'echo "[SIGINT] Manual ctrl+c di $(date)" >> "$LOGFILE"' SIGINT

echo "[INFO] Script dimulai pada $(date)" >> "$LOGFILE"

was_paused=false

while true; do
  LOGFILE="$(get_logfile)"

  if [ -f "$PAUSE_FLAG" ]; then
    if [ "$was_paused" = false ]; then
      echo "[PAUSED] $(date)" >> "$LOGFILE"
      send_telegram "[StorySaver] Script dipause: $(date)"
      was_paused=true
    fi
    sleep 60
    continue
  fi

  # Kalau sebelumnya paused dan sekarang udah resume
  if [ "$was_paused" = true ]; then
    echo "[RESUME] $(date)" >> "$LOGFILE"
    send_telegram "[StorySaver] Script dilanjutkan: $(date)"
    was_paused=false
  fi

  echo "[RUN] Menyimpan story: $(date)" >> "$LOGFILE"
  bash "$SCRIPT_SAVER" >> "$LOGFILE" 2>&1

  # sleep "$INTERVAL"
  for ((i = 0; i < INTERVAL / 10; i++)); do
    sleep 10
    [ -f "$PAUSE_FLAG" ] && break
  done
done

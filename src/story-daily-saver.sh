#!/data/data/com.termux/files/usr/bin/bash

# === CONFIG ===
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
fi

ARCHIVE_DIR="$OUTPUT_DIR/arsip"
LOG_DIR="$OUTPUT_DIR/logs"
TODAY=$(date '+%Y-%m-%d')
LOG_FILE="$LOG_DIR/$TODAY.log"

SOURCE_DIRS=(
  "/storage/ace-999/Android/media/com.whatsapp/WhatsApp/Media/.Statuses"
  "/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses"
)

# === INIT ===
mkdir -p "$OUTPUT_DIR"
mkdir -p "$ARCHIVE_DIR"
mkdir -p "$LOG_DIR"

log() {
  echo "[$(date '+%H:%M:%S')] $1" >> "$LOG_FILE"
}

# === MAIN ===
for SRC in "${SOURCE_DIRS[@]}"; do
  for FILE in "$SRC"/*.{jpg,mp4}; do
    [ -e "$FILE" ] || continue

    MOD_DATE=$(date -r "$FILE" '+%Y-%m-%d')
    BASENAME=$(basename "$FILE")

    if [ "$MOD_DATE" = "$TODAY" ]; then
      DEST_FILE="$OUTPUT_DIR/$BASENAME"
      if [ ! -f "$DEST_FILE" ]; then
        cp "$FILE" "$DEST_FILE"
        log "Copied today: $BASENAME"
      fi
    else
      DEST_SUBDIR="$ARCHIVE_DIR/$MOD_DATE"
      mkdir -p "$DEST_SUBDIR"
      DEST_FILE="$DEST_SUBDIR/$BASENAME"
      if [ ! -f "$DEST_FILE" ]; then
        cp "$FILE" "$DEST_FILE"
        log "Archived ($MOD_DATE): $BASENAME"
      fi
    fi
  done
done

for FILE in "$OUTPUT_DIR"/*.{jpg,mp4}; do
  [ -e "$FILE" ] || continue

  MOD_DATE=$(date -r "$FILE" '+%Y-%m-%d')

  # Skip kalau file adalah milik hari ini
  if [ "$MOD_DATE" = "$TODAY" ]; then
    continue
  fi

  BASENAME=$(basename "$FILE")
  DEST_SUBDIR="$ARCHIVE_DIR/$MOD_DATE"
  mkdir -p "$DEST_SUBDIR"

  mv "$FILE" "$DEST_SUBDIR/"
  log "Moved to archive ($MOD_DATE): $BASENAME"
done

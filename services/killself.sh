#!/data/data/com.termux/files/usr/bin/bash
# stop_story_loop.sh

echo "[INFO] Killing all story loops..."
pkill -f start_story_loop_rev.sh
pkill -f start_notif_loop.sh
pkill -f start_story_loop.sh
echo "[DONE] All loop processes terminated."

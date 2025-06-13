#!/data/data/com.termux/files/usr/bin/bash
LOG_FILE="$HOME/flash-termux/logs/flash.log"

log_shell() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
    [ "$2" = "ERROR" ] && exit 1
}
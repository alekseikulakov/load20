#!/bin/bash

DURATION="$1"

TARGET_PERCENT=20
WORKERS=1  


MEM_AVAILABLE_KB=$(awk '/MemAvailable/ { print $2 }' /proc/meminfo)
MEM_AVAILABLE_MB=$((MEM_AVAILABLE_KB / 1024))
MEM_TARGET_MB=$((MEM_AVAILABLE_MB * TARGET_PERCENT / 100))
LOG_FILE_MEM="logs/memtest_$(date +%F_%H-%M-%S).log"

echo "Avaliable: $MEM_AVAILABLE_MB MB"
echo "TArget (20%): $MEM_TARGET_MB MB"


PER_WORKER_MB=$((MEM_TARGET_MB / WORKERS))

echo "TEst duration $DURATION"

# Запуск memrate без vm
stress-ng --memrate "$WORKERS" \
          --memrate-bytes "${PER_WORKER_MB}M" \
          --memrate-rd 80 \
          --memrate-wr 20 \
          --metrics-brief \
          --timeout $DURATION \
          --log-file $LOG_FILE_MEM


#!/bin/bash

cleanup() {
    echo -e "\nЗавершение работы... Лог сохранён в $LOG_FILE"
    exit 0
}

# Перехватываем Ctrl+C
trap cleanup SIGINT

./bmc_monitor.sh &
./gpu_stat.sh &

echo Monitoring started

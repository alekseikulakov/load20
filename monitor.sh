#!/bin/bash

LOG_FILE="load.monitor_$(date +%F_%H-%M-%S).csv"
DISK_DEV="nvme0n1p2"  
#sudo apt install ipmitool

echo "timestamp,         cpu_used, mem_used, disk_io,   outlet t,cpu1 t,cpu2 t" | tee "$LOG_FILE"

while true; do
    TS=$(date +"%F %T")

    # CPU: 100 - idle
    CPU_IDLE=$(mpstat 1 1 | awk '/Average/ && $12 ~ /[0-9.]+/ { print $12 }')
    CPU_USED=$(awk "BEGIN { printf \"%.2f\", 100 - $CPU_IDLE }")

    # RAM: used / total
    read MEM_TOTAL MEM_USED <<< $(free | awk '/Mem:/ { print $2, $3 }')
    MEM_USED_PCT=$(awk "BEGIN { printf \"%.2f\", ($MEM_USED / $MEM_TOTAL) * 100 }")

    # DISK util% 
    DISK_UTIL=$(iostat -dx 1 1 | awk '$1=="nvme0n1" { print $NF }')

   #ipmitool 
   output=$(sudo ipmitool sensor)
   outlet_temp_value=$(echo "$output" | grep -w "Outlet Temp" | awk '{print $4}')
   cpu1_core_rem_value=$(echo "$output" | grep -w "CPU1 Core Rem" | awk '{print $5}')
   cpu2_core_rem_value=$(echo "$output" | grep -w "CPU2 Core Rem" | awk '{print $5}')   

   # Запись в файл и вывод
    echo "$TS   | $CPU_USED |  $MEM_USED_PCT |  $DISK_UTIL | $outlet_temp_value |  $cpu1_core_rem_value |  $cpu2_core_rem_value" | tee -a "$LOG_FILE"
    
   
    sleep 6
done



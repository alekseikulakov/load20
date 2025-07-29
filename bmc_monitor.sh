#!/bin/bash

LOG_FILE="bmc.monitor_$(date +%F_%H-%M-%S).csv"

sudo apt install ipmitool
output=$(sudo ipmitool sensor)


while true; do
    TS=$(date +"%F %T")


outlet_temp_value=$(echo "$output" | grep -w "Outlet Temp" | awk '{print $4}')
cpu1_core_rem_value=$(echo "$output" | grep -w "CPU1 Core Rem" | awk '{print $5}')
cpu2_core_rem_value=$(echo "$output" | grep -w "CPU2 Core Rem" | awk '{print $5}')

echo "timestamp,             Outlet T,CPU1 T,CPU2 T" | tee "$LOG_FILE"
echo "$TS   | $outlet_temp_value |  $cpu1_core_rem_value |  $cpu2_core_rem_value" | tee -a "$LOG_FILE"


    sleep 6
done

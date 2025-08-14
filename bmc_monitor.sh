#!/bin/bash

LOG_FILE=logs/"bmc.monitor_$(date +%F_%H-%M-%S).csv"

determine_package_manager() {
    if command -v dnf >/dev/null 2>&1; then
        echo "dnf"
    elif command -v apt >/dev/null 2>&1; then
        echo "apt"
    elif command -v yum >/dev/null 2>&1; then
        echo "yum"
    elif command -v zypper >/dev/null 2>&1; then
        echo "zypper"
    else
        echo "unknown"
    fi
}

# Определяем менеджер пакетов
PKG_MGR=$(determine_package_manager)

# Устанавливаем ipmitool в зависимости от менеджера пакетов
case $PKG_MGR in
    "dnf")
        echo "Обнаружен менеджер пакетов: DNF (Fedora/RHEL)"
        sudo dnf install -y ipmitool
        ;;
    "apt")
        echo "Обнаружен менеджер пакетов: APT (Debian/Ubuntu)"
        sudo apt update
        sudo apt install -y ipmitool
        ;;
    "yum")
        echo "Обнаружен менеджер пакетов: YUM (старые RHEL/CentOS)"
        sudo yum install -y ipmitool
        ;;
    "zypper")
        echo "Обнаружен менеджер пакетов: Zypper (openSUSE)"
        sudo zypper install -y ipmitool
        ;;
    *)
        echo "Не удалось определить менеджер пакетов. Установите ipmitool вручную."
        echo "Для RHEL/Fedora: sudo dnf install ipmitool"
        echo "Для Debian/Ubuntu: sudo apt install ipmitool"
        exit 1
        ;;
esac

cleanup() {
    echo -e "\nЗавершение работы... Лог сохранён в $LOG_FILE"
    exit 0
}

trap cleanup SIGINT

#sudo dnf install ipmitool
DISK_DEV="sda"

while true; do
    TS=$(date +"%F %T")

output=$(sudo ipmitool sensor)
outlet_temp_value=$(echo "$output" | grep -w "Outlet_Temp" | awk '{print $3}')
inlet_temp_value=$(echo "$output" | grep -w "Inlet_Temp" | awk '{print $3}')
cpu0_temp_value=$(echo "$output" | grep -w "CPU0_Temp" | awk '{print $3}')
cpu1_temp_value=$(echo "$output" | grep -w "CPU1_Temp" | awk '{print $3}')
fan0_speed_value=$(echo "$output" | grep -w "FAN0_0_Speed" | awk '{print $3}')
fan0_1_speed_value=$(echo "$output" | grep -w "FAN0_1_Speed" | awk '{print $3}')
fan1_0_speed_value=$(echo "$output" | grep -w "FAN1_0_Speed" | awk '{print $3}')
fan1_1_speed_value=$(echo "$output" | grep -w "FAN1_1_Speed" | awk '{print $3}')
fan2_0_speed_value=$(echo "$output" | grep -w "FAN2_0_Speed" | awk '{print $3}')
fan2_1_speed_value=$(echo "$output" | grep -w "FAN2_1_Speed" | awk '{print $3}')
fan3_0_speed_value=$(echo "$output" | grep -w "FAN3_0_Speed" | awk '{print $3}')
fan3_1_speed_value=$(echo "$output" | grep -w "FAN3_1_Speed" | awk '{print $3}')
fan4_0_speed_value=$(echo "$output" | grep -w "FAN4_0_Speed" | awk '{print $3}')
fan4_1_speed_value=$(echo "$output" | grep -w "FAN4_1_Speed" | awk '{print $3}')
fan5_0_speed_value=$(echo "$output" | grep -w "FAN5_0_Speed" | awk '{print $3}')
fan5_1_speed_value=$(echo "$output" | grep -w "FAN5_1_Speed" | awk '{print $3}')
fan6_0_speed_value=$(echo "$output" | grep -w "FAN6_0_Speed" | awk '{print $3}')
fan6_1_speed_value=$(echo "$output" | grep -w "FAN6_1_Speed" | awk '{print $3}')
fan7_0_speed_value=$(echo "$output" | grep -w "FAN7_0_Speed" | awk '{print $3}')
fan7_1_speed_value=$(echo "$output" | grep -w "FAN7_1_Speed" | awk '{print $3}')
fan8_0_speed_value=$(echo "$output" | grep -w "FAN8_0_Speed" | awk '{print $3}')
fan8_1_speed_value=$(echo "$output" | grep -w "FAN8_1_Speed" | awk '{print $3}')
fan9_0_speed_value=$(echo "$output" | grep -w "FAN9_0_Speed" | awk '{print $3}')
fan9_1_speed_value=$(echo "$output" | grep -w "FAN9_1_Speed" | awk '{print $3}')
fan10_0_speed_value=$(echo "$output" | grep -w "FAN10_0_Speed" | awk '{print $3}')
fan10_1_speed_value=$(echo "$output" | grep -w "FAN10_1_Speed" | awk '{print $3}')
gpu0_temp_value=$(echo "$output" | grep -w "GPU0_Temp" | awk '{print $3}')
gpu1_temp_value=$(echo "$output" | grep -w "GPU1_Temp" | awk '{print $3}')
gpu2_temp_value=$(echo "$output" | grep -w "GPU2_Temp" | awk '{print $3}')
gpu3_temp_value=$(echo "$output" | grep -w "GPU3_Temp" | awk '{print $3}')
gpu4_temp_value=$(echo "$output" | grep -w "GPU4_Temp" | awk '{print $3}')
gpu5_temp_value=$(echo "$output" | grep -w "GPU5_Temp" | awk '{print $3}')
gpu6_temp_value=$(echo "$output" | grep -w "GPU6_Temp" | awk '{print $3}')
gpu7_temp_value=$(echo "$output" | grep -w "GPU7_Temp" | awk '{print $3}')
# CPU: 100 - idle
CPU_IDLE=$(mpstat 1 1 | awk '/Average/ && $12 ~ /[0-9.]+/ { print $12 }')
CPU_USED=$(awk "BEGIN { printf \"%.2f\", 100 - $CPU_IDLE }")

# RAM: used / total
read MEM_TOTAL MEM_USED <<< $(free | awk '/Mem:/ { print $2, $3 }')
MEM_USED_PCT=$(awk "BEGIN { printf \"%.2f\", ($MEM_USED / $MEM_TOTAL) * 100 }")

# DISK util%
DISK_UTIL=$(iostat -dx 1 2 | awk '$1=="sda" { print $NF }' | tail -n 1)


echo "timestamp,             Outlet T, Inlet T, CPU1 T, CPU2 T,   FAN0 SP,    FAN8 SP,   GPU0 T,  GPU1 T,  GPU2 T,  GPU3 T,  GPU4 T,  GPU5 T,  GPU6 T,  GPU7 T " >> "$LOG_FILE"
echo "$TS   | $outlet_temp_value | $inlet_temp_value | $cpu0_temp_value | $cpu1_temp_value | $fan0_speed_value | $fan8_0_speed_value | $gpu0_temp_value | $gpu1_temp_value | $gpu2_temp_value | $gpu3_temp_value | $gpu4_temp_value | $gpu5_temp_value | $gpu6_temp_value | $gpu7_temp_value" >> "$LOG_FILE"
echo "---------------------------------------------------------------- " >> "$LOG_FILE"
echo "           timestamp,               FAN0 SP,    FAN1 SP,     FAN2 SP,    FAN3 SP,    FAN4 SP,    FAN5 SP,     FAN6 SP,   FAN7 SP,     FAN8 SP,    FAN9 SP,  FAN10 SP " >> "$LOG_FILE"
echo "ALL FANS | $TS   | $fan0_speed_value | $fan1_0_speed_value | $fan2_0_speed_value | $fan3_0_speed_value | $fan4_0_speed_value | $fan5_0_speed_value | $fan6_0_speed_value | $fan7_0_speed_value | $fan8_0_speed_value | $fan9_0_speed_value | $fan10_0_speed_value" >> "$LOG_FILE"
echo "---------------------------------------------------------------- " >> "$LOG_FILE"
echo "timestamp,            cpu_used,mem_used,disk_io" >> "$LOG_FILE"
echo "$TS   | $CPU_USED |  $MEM_USED_PCT |  $DISK_UTIL |" >> "$LOG_FILE"
echo "---------------------------------------------------------------- " >> "$LOG_FILE"
    sleep 3
done

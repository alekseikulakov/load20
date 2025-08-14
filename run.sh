#!/bin/bash

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
        sudo dnf install stress-ng fio sysstat dstat -y
        ;;
    "apt")
	echo "Обнаружен менеджер пакетов: APT (Debian/Ubuntu)"
        sudo apt update
        sudo apt install stress-ng fio sysstat dstat -y
        ;;
    "yum")
	echo "Обнаружен менеджер пакетов: YUM (старые RHEL/CentOS)"
        sudo yum install stress-ng fio sysstat dstat -y
        ;;
    "zypper")
	echo "Обнаружен менеджер пакетов: Zypper (openSUSE)"
        sudo zypper install stress-ng fio sysstat dstat -y
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


DURATION=800

./cpu.sh "$DURATION" &
./disk.sh "$DURATION" &
./mem.sh "$DURATION" &
./sensors.sh &

echo run all jobs

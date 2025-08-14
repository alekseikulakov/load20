#!/bin/bash

#sudo apt-get install stress-ng fio sysstat dstat -y
#sudo dnf install stress-ng fio sysstat dstat -y

AVX_MODE=${1:-noavx}    # transfer as a paramener avx or noavx wl. noavg -default
LOG_FILE_CPU="logs/cpu_stress_$(date +%F_%H-%M-%S).log"
echo "LOGF_CHECK $LOG_FILE_CPU"
DURATION="$1"


if [[ "$AVX_MODE" == "avx" ]]; then
    echo "Запуск AVX нагрузки на CPU"
    stress-ng -c40 -l 19 --cpu-method all --metrics-brief --timeout $DURATION --log-file $LOG_FILE_CPU
else
    echo "Запуск обычной CPU нагрузки"
    stress-ng -c40 -l 19 --cpu-method loop --metrics-brief --timeout $DURATION --log-file $LOG_FILE_CPU 

fi


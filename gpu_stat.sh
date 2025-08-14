
#!/bin/bash


LOG_FILE="logs/gpu_stats_$(date +%F_%H-%M-%S).csv"
INTERVAL=2

GPU_COUNT=$(nvidia-smi --query-gpu=count --format=csv,noheader | head -n 1)

echo -n "Timestamp          " > "$LOG_FILE"
for i in $(seq 0 $((GPU_COUNT-1))); do
    echo -n "|GPU${i}_Temp|GPU${i}_TDP|GPU${i}_Thro" >> "$LOG_FILE"
done
echo >> "$LOG_FILE"

while true; do
    TS=$(date "+%Y-%m-%d %H:%M:%S")

    # Получаем данные
    TEMPS=$(nvidia-smi --query-gpu=temperature.gpu --format=csv,noheader,nounits | tr '\n' ' ')
    TDPS=$(nvidia-smi --query-gpu=power.draw --format=csv,noheader,nounits | awk '{print $1}' | tr '\n' ' ')
    THROTTLE_TEMPS=$(nvidia-smi --query-gpu=temperature.threshold --format=csv,noheader,nounits | grep -oP 'throttle = \K\d+' | tr '\n' ' ')
#    TR=$(nvidia-smi -q | awk '/GPU Current Temp/ {current = $5}')
#    CURRENT=$(nvidia-smi -q | awk '/GPU Current Temp/ {print $5}' | tr '\n' ' ')
#    THROTTLING_T=$(nvidia-smi -q | awk '/GPU Slowdown Temp/ {print $5}')
#    MARGIN=$((THROTTLING_T - CURRENT))    
#    echo "THHHHHRRRRR $THROTTLE_TEMPS"
#    nvidia-smi -q | awk '/GPU Current Temp/ {current = $5} /GPU Shutdown Temp/ {shutdown = $5} /GPU Slowdown Temp/ {slowdown = $5}  END {printf "Текущая: %s°C\nДо троттлинга: %s°C\nПорог: %s°C\n", current, slowdown-current, slowdown}'
    # Формируем строку данных
    LOG_LINE="$TS"
    for i in $(seq 0 $((GPU_COUNT-1))); do
        TEMP=$(echo $TEMPS | awk -v i=$i '{print $(i+1)}')
        TDP=$(echo $TDPS | awk -v i=$i '{print $(i+1)}')
        THROTTLE_TEMP=$(echo $THROTTLE_TEMPS | awk -v i=$i '{print $(i+1)}')
        THERMAL_HEADROOM=89
#$((THROTTLE_TEMP - TEMP))

       	LOG_LINE+="|  $TEMP C  | $TDP W |  $THERMAL_HEADROOM C  "
    done

    # Записываем в файл
    echo "$LOG_LINE" >> "$LOG_FILE"

    sleep $INTERVAL
done

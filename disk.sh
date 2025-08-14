#!/bin/bash

DURATION="$1"
DEVICE="./fio_loadfile"  
LOG_FILE_FIO="logs/fio_${JOB_NAME}_$(date +%F_%H-%M-%S).log"
JOB_NAME="disk_load_20percent"

fio --name="$JOB_NAME" \
    --filename=$DEVICE \
    --rw=randrw \
    --rate_iops=30 \
    --thinktime=600 \
    --rwmixread=60 \
    --bs=128k \
    --iodepth=16 \
    --numjobs=8 \
    --ioengine=libaio \
    --direct=1 \
    --time_based \
    --runtime=$DURATION \
    --group_reporting \
    --output="$LOG_FILE_FIO"

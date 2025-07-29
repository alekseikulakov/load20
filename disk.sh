#!/bin/bash

DURATION="$1"


DEVICE="./fio_loadfile"  
JOB_NAME="sas3_seq_mixed"
LOG_FILE_FIO="fio_${JOB_NAME}_$(date +%F_%H-%M-%S).log"



DISK_RATE="200M"  

fio --name="$JOB_NAME" \
    --filename=$DEVICE \
    --rw=readwrite \
    --rwmixread=80 \
    --bs=4k \
    --iodepth=32 \
    --numjobs=4 \
    --rate 200M
    --ioengine=libaio \
    --direct=1 \
    --time_based \
    --runtime=$DURATION \
    --size=10G \
    --group_reporting \
    --log_avg_msec=1000 \
    --rate=$DISK_RATE \
    --output="$LOG_FILE_FIO"

echo "FIO test complete. Log saved to $LOG_FILE_FIO"

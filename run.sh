#!/bin/bash

sudo apt-get install stress-ng fio sysstat dstat -y

#export 

DURATION=30

./cpu.sh "$DURATION" &
./disk.sh "$DURATION" &
./mem.sh "$DURATION" &

echo run all jobs

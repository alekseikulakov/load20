
#!/bin/bash

sudo pkill -9 -f 'stress-ng'
sudo pkill -9 -f '/bin/bash ./sensors.sh'
sudo pkill -9 -f '/bin/bash ./bmc_monitor.sh'
sudo pkill -9 -f 'fio'









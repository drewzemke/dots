#! /bin/sh
echo $(nvidia-smi -q -d utilization | /home/drew/.cargo/bin/rg 'Gpu .* (\d+)' -or '$1')%

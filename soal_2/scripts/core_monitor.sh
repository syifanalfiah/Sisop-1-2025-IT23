#!/bin/bash

cpu_model=$(grep "model name" /proc/cpuinfo | head -n 1 | cut -d ':' -f2- | sed 's/^[ \t]*//')

timestamp=$(date '+%Y-%m-%d %H:%M:%S')

# pakai awk untuk menghitung 100 - idle
cpu_idle=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/")
cpu_usage=$(awk -v idle="$cpu_idle" 'BEGIN { usage=100 - idle; printf "%.0f", usage }')

echo "[$timestamp] - Core Usage [${cpu_usage}%] - Terminal Model [${cpu_model}]"


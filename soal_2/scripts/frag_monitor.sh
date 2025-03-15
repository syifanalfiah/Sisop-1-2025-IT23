#!/bin/bash

read total used free shared buff_cache available < <(free -m | awk 'NR==2 {print $2, $3, $4, $5, $6, $7}')

used_mem=$(echo "$total - $available" | bc)
usage=$(echo "scale=1; ($used_mem*100)/$total" | bc)
timestamp=$(date '+%Y-%m-%d %H:%M:%S')

echo "[$timestamp] - Fragment Usage [${usage}%] - Fragment Count [${used_mem} MB] - Details [Total: ${total} MB, Available: ${available} MB]"



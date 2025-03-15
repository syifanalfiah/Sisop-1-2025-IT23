#!/bin/bash

speak_to_me() {
    echo -e "\e[1;34mSᑭᕮᗩK TO ᗰᕮ - ᗯOᖇᗪS Oᖴ ᗩᖴᖴIᖇᗰᗩTIOᑎ\e[0m"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    
    while true; do
        curl -s https://www.affirmations.dev/ | jq -r '.affirmation'
        sleep 1
    done
}

on_the_run() {
    panjang=$(tput cols)
    progres=0

    while [ $progres -le $panjang ]; do
        clear
        echo -e "\e[1;32moᑎ Tᕼᕮ ᗯᗩY ᑌᗯᑌ\e[0m"
        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        echo -n "["
        for ((i = 0; i < progres; i++)); do echo -n "•"; done
        for ((i = progres; i < panjang; i++)); do echo -n " "; done
        echo "] $(($progres * 100 / $panjang))%"

        progres=$((progres + 1))
        sleep $(awk -v min=0.1 -v max=1 'BEGIN{srand(); print min+rand()*(max-min)}')
    done
}

time_display() {
    while true; do
        clear
        echo -e "\e[1;33mjam brp iyeah\e[0m"
        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        date "+%Y-%m-%d %H:%M:%S"
	sleep 1
    done
}

money() {
    simbols=('$' '€' '£' '¥' '¢' '₹' '₩' '₿' '₣')
    cols=$(tput cols)
    lines=$(tput lines)
    
    declare -A positions

    while true; do
        clear
        for ((i = 0; i < cols; i+=3)); do
            row=${positions[$i]:-$(shuf -i 1-$lines -n 1)}
            simbol=${simbols[$RANDOM % ${#simbols[@]}]}

            tput cup $row $i
            echo -n "$simbol"

            if ((row > 0)); then
                positions[$i]=$((row - 1))
            else
                positions[$i]=$lines
            fi
        done
        sleep 0.1
    done
}

brain_damage() {
    while true; do
        clear
        echo -e "\e[1;35mBʀᴀɪɴ Dᴀᴍᴀɢᴇ - Cᴜsᴛᴏᴍ Tᴀsᴋ Mᴀɴᴀɢᴇʀ\e[0m"
        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        echo -e "\e[1;32mCPU Usage:\e[0m"
        ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -10 | awk '{printf "%-8s %-20s %-10s %-10s\n", $1, $2, $3"%", $4"%"}'
        
        echo ""
        echo -e "\e[1;34mMemory Usage:\e[0m"
        free -h | awk 'NR==1 || NR==2 {print}'

        echo ""
        echo -e "\e[1;31mProcesses (Top 10 by CPU):\e[0m"
        echo "----------------------------------------------------------"
        echo -e "\e[1;33mPID      COMMAND              CPU%      MEM%\e[0m"
        ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -10 | awk '{printf "%-8s %-20s %-10s %-10s\n", $1, $2, $3"%", $4"%"}'

        sleep 1
    done
}

clear

case "$1" in
    --play="Speak to Me")
        speak_to_me
        ;;
    --play="On the Run")
        on_the_run
        ;;
    --play="Time")
        time_display
        ;;
    --play="Money")
        money
        ;;
    --play="Brain Damage")
        brain_damage
        ;;
    *)
        echo "Usage: ./dsotm.sh --play=\"<Track>\""
        echo "Available Tracks: Speak to Me, On the Run, Time, Money, Brain Damage"
        ;;
esac

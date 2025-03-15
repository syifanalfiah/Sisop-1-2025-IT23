#!/bin/bash

ORANGE='\033[38;5;214m'
CYAN='\033[1;36m'
PURPLE='\033[1;35m'
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
WHITE='\033[1;37m'
NC='\033[0m'  # No Color

project_dir="$(dirname "$(dirname "$(realpath "$0")")")"
logs_dir="$project_dir/logs"

# Fungsi untuk menampilkan menu
function A_nexus() {
    echo -e "${ORANGE}"
    echo " ╔═════════════════════════════════╗"
    echo " ║         ARCAEA MONITOR          ║"
    echo " ╠═════════════════════════════════╣"
    echo " ║ 1. Activate Core Monitor        ║"
    echo " ║ 2. Deactivate Core Monitor      ║"
    echo " ║ 3. Activate Fragment Monitor    ║"
    echo " ║ 4. Deactivate Fragment Monitor  ║"
    echo " ║ 5. View Active Jobs             ║"
    echo " ║ 6. Return to ARCAEA NEXUS       ║"
    echo " ╚═════════════════════════════════╝"
    echo -e "${NC}"
}

while true; do
  A_nexus
  read -p "$(echo -e ${ORANGE}Select an option [1-6]: ${NC})" choice
  case $choice in
    1)
      if ! crontab -l | grep -q "core_monitor.sh"; then
         (crontab -l; echo "*/5 * * * * /bin/bash $project_dir/scripts/core_monitor.sh >> $logs_dir/core.log 2>&1") | crontab -
         echo -e "${GREEN}CPU [Core] Monitor meownyala!${NC}"
      else
         echo -e "${YELLOW}CPU [Core] Monitor udah meownyala abangku!${NC}"
      fi
      sleep 1
      ;;
    2)
      crontab -l | grep -v "core_monitor.sh" | crontab -
      echo -e "${RED}CPU [Core] Monitor turu${NC}"
      sleep 1
      ;;
    3)
      if ! crontab -l | grep -q "frag_monitor.sh"; then
         (crontab -l; echo "*/10 * * * * /bin/bash $project_dir/scripts/frag_monitor.sh >> $logs_dir/fragment.log 2>&1") | crontab -
         echo -e "${GREEN}RAM [Fragment] Monitor meownyala!${NC}"
      else
         echo -e "${YELLOW}RAM [Fragment] Monitor udah meownyala abangku!${NC}"
      fi
      sleep 1
      ;;
    4)
      crontab -l | grep -v "frag_monitor.sh" | crontab -
      echo -e "${RED}RAM [Fragment] Monitor turu${NC}"
      sleep 1
      ;;
    5)
      echo -e "${CYAN}Active Cron Jobs:${NC}"
      crontab -l
      echo -e "\nENTER buat balik ke menu..."
      read -r
      ;;
    6)
      echo -e "${GREEN}Exiting ARCAEA MONITOR... じゃあね!${NC}"
      exit 0
      ;;
    *)
      echo -e "${RED}Invalid option! Please try again.${NC}"
      sleep 1
      ;;
  esac
done

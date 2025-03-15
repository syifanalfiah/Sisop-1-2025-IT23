#!/bin/bash

# Warna untuk antarmuka VRMMO
ORANGE='\033[38;5;214m'
CYAN='\033[1;36m'
PURPLE='\033[1;35m'
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
WHITE='\033[1;37m'
NC='\033[0m'  # No Color

script_dir=$(dirname "$0")

function show_menu() {
  echo -e "${ORANGE}"
  echo " ╔══════════════════════════════════╗"
  echo " ║           ARCAEA NEXUS           ║"
  echo " ╠══════════════════════════════════╣"
  echo " ║ 1. Register to Arcaea            ║"
  echo " ║ 2. Login to Arcaea               ║"
  echo " ║ 3. Exit                          ║"
  echo " ╚══════════════════════════════════╝"
  echo -e "${NC}"
}

while true; do
  show_menu
  read -p "$(echo -e ${ORANGE}Select an option [1-3]: ${NC})" choice

  case $choice in
    1)
      "$script_dir/register.sh"
      ;;
    2)
      "$script_dir/login.sh"
      if [ $? -eq 0 ]; then
        bash "$script_dir/scripts/manager.sh"
      fi
      ;;
    3)
      echo -e "${RED}Exiting ARCAEA NEXUS... またね!!${NC}"
      exit 0
      ;;
    *)
      echo -e "${RED}Invalid option! Please try again.${NC}"
      ;;
  esac
  sleep 1
done

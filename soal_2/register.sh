#!/bin/bash

echo -n "Email: "
read Email
echo "$Email" | awk '
BEGIN {
    janjiw = 1;
    merah = "\033[31m";
    reset = "\033[0m";
}
{
    if (!($0 ~ /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/)) {
       print merah "emailnya tolong diperhatikan yah" reset;
       janjiw = 0;
    }
}
END {
    if (janjiw == 0)
        exit 1;
}'|| { exit 1; }

if grep -q "^$Email," data/player.csv; then
  echo -e "\033[31mCoba ganti email bang, yang ini udah ada.\033[0m"
  exit 1
fi

echo -n "Username: "
read username

echo -n "Password: "
read -s Pword
echo ""
echo "$Pword" | awk '
BEGIN {
    Menyala = "\033[31m"
    Membenar = "\033[32m"
    reset = "\033[0m"
}
{
    rucak = ""
    if (length($0) < 8)
        rucak = rucak "Singkat,padat,kurang (min. 8 char). "
    if (!($0 ~ /[A-Z]/))
        rucak = rucak "Sedikitnya 1 huruf major. "
    if (!($0 ~ /[a-z]/))
        rucak = rucak "Sedikitnya 1 huruf minor. "
    if (!($0 ~ /[0-9]/))
        rucak = rucak "Sedikitnya 1 angka. "

    if (length(rucak) > 0) {
        print Menyala rucak reset
        exit 1
    } else {
        print Membenar "Oke, Passwordnya udah manjiww!" reset
    }
}' || exit 1

sSalt="V3st1@Zet4"
HPword=$(echo -n "$Pword$sSalt" | sha256sum | awk '{print $1}')

record="$Email,$username,$HPword"
echo "$record" >> data/player.csv

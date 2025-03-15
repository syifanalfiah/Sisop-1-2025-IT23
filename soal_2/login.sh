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
    # Regex untuk validasi format email
    if (!($0 ~ /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/)) {
       print merah "emailnya tolong diperhatikan yah" reset;
       janjiw = 0;
    }
}
END {
    if (janjiw == 0)
        exit 1;
}'|| { exit 1; }

if ! grep -q "^$Email," data/player.csv; then
    echo -e "\033[31mEmail tidak ditemukan, kamu bohong, register dulu.\033[0m"
    exit 1
fi

echo -n "Password: "
read -s Pword
echo ""

sSalt="V3st1@Zet4"
HPword=$(echo -n "$Pword$sSalt" | sha256sum | awk '{print $1}')

storedHPword=$(grep "^$Email," data/player.csv | head -n 1 | awk -F',' '{print $3}')

if [ "$HPword" = "$storedHPword" ]; then
    echo -e "\033[32mLogin berhasil!\033[0m"
else
    echo -e "\033[31mTolong diperhatikan lagi passwordnya\033[0m"
    exit 1
fi


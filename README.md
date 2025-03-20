# Laporan Praktikum Modul 1

## Nama Anggota

| Nama                        | NRP        |
| --------------------------- | ---------- |
| Syifa Nurul Alfiah          | 5027241019 |
| Alnico Virendra Kitaro Diaz | 5027241081 |
| Hafiz Ramadhan              | 5027241096 |

## Soal No 1
soon

## Soal No 2
soon

## Soal No 3

### Deskripsi
Skrip Bash ini adalah program interaktif yang melakukan banyak hal menarik, seperti menampilkan afirmasi motivasi, progres visual, waktu saat ini, simulasi simbol uang, dan pemantauan proses sistem. Skrip ini menggunakan perintah dasar Bash serta library eksternal seperti curl, jq, dan tput untuk membuat efek visual dan mengatur tampilan terminal.

### Speak to Me
- Menampilkan teks "SPEAK TO ME - WORDS OF AFFIRMATION" dalam format berwarna.
- Menggunakan perintah curl untuk mengambil afirmasi dari API https://www.affirmations.dev/.
- Parsing JSON menggunakan jq untuk menampilkan hanya bagian teks afirmasi.
- Menampilkan afirmasi dengan delay 1 detik dalam perulangan tanpa henti.

```sh
speak_to_me() {
    echo -e "\e[1;34mSᑭᕮᗩK TO ᗰᕮ - ᗯOᖇᗪS Oᖴ ᗩᖴᖴIᖖᗩTIOᑎ\e[0m"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    
    while true; do
        curl -s https://www.affirmations.dev/ | jq -r '.affirmation'
        sleep 1
    done
}
```

### On the Run
- Menghitung panjang terminal menggunakan tput cols.
- Menampilkan progress bar yang bergerak maju dari kiri ke kanan.
- Menggunakan karakter • sebagai indikator progres.
- Menambahkan delay acak antara 0.1 hingga 1 detik.

```sh
on_the_run() {
    panjang=$(($(tput cols) - 10))
    progres=0

    while [ $progres -le $panjang ]; do
        clear
        echo -e "\e[1;32moᑎ Tᕼᕮ ᗯᗩY ᑌᗯᑌ\e[0m"
        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"

        echo -n "["
        for ((i = 0; i < progres; i++)); do echo -n "•"; done
        for ((i = progres; i < panjang; i++)); do echo -n " "; done
        echo -n "] $(($progres * 100 / $panjang))%"

        progres=$((progres + 1))
        sleep $(awk -v min=0.1 -v max=1 'BEGIN{srand(); print min+rand()*(max-min)}')
    done
}
```

### Tiime Display
- Menampilkan header dalam warna kuning.
- Menggunakan perintah date untuk mendapatkan waktu sekarang.
- Memperbarui tampilan setiap 1 detik.

```sh
time_display() {
    while true; do
        clear
        echo -e "\e[1;33mjam brp iyeah\e[0m"
        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        date "+%Y-%m-%d %H:%M:%S"
        sleep 1
    done
}
```

### money 
- Mengambil ukuran terminal dengan tput cols dan tput lines.
- Mengacak posisi simbol uang menggunakan array dan shuf.
- Menampilkan simbol mata uang dalam perulangan.

```sh
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
```

### Brain Damage
- Menampilkan informasi penggunaan memori menggunakan free -h.
- Menampilkan daftar 10 proses dengan konsumsi CPU tertinggi menggunakan ps -eo pid,comm,%cpu,%mem.
- Memperbarui informasi setiap 1 detik.

```sh
brain_damage() {
    while true; do
        tput cup 0 0
        echo -e "\e[1;35mBʀᴀɪɴ Dᴀᴍᴀɢᴇ - Cᴜsᴛᴏᴍ Tᴀsᴋ Mᴀɴᴀɢᴇʀ\e[0m"
        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        
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
```

### Cara Menjalankan
```sh
chmod +x dsotm.sh
./dsotm.sh --play="Speak to Me"
Pilihan yang tersedia:

--play="Speak to Me" → Menampilkan afirmasi motivasi.
--play="On the Run" → Menampilkan progres visual.
--play="Time" → Menampilkan waktu saat ini.
--play="Money" → Simulasi hujan simbol mata uang.
--play="Brain Damage" → Menampilkan pemantauan sistem.
```

### Revisi

### On the Run
sebelum
```sh
panjang=$(tput cols)
```

sesudah
```sh
panjang=$(($(tput cols) - 10))
```
- Sebelumnya, panjang progress bar diatur sebesar lebar terminal penuh.
- Sekarang, dikurangi 10 karakter agar tidak mentok di tepi layar terminal kecil.

### Brain Damage
sebelum
```sh
while true; do
    clear
```

sesudah
```sh
while true; do
    tput cup 0 0
```
- Sebelumnya, clear digunakan, yang membuat terminal refresh penuh setiap update.
- Sekarang, menggunakan tput cup 0 0, yang memindahkan kursor ke pojok kiri atas tanpa menghapus layar.
- Ini membuat tampilan lebih stabil tanpa kedipan layar setiap refresh.

### Speak to Me
sebelum
```sh
echo -e "\e[1;34mSᑭᕮᗩK TO ᗰᕮ - ᗯOᖇᗪS Oᖴ ᗩᖴᖴIᖇᗰᗩTIOᑎ\e[0m"
```

sesudah
```sh
echo -e "\e[1;34mSᑭᕮᗩK TO ᗰᕮ - ᗯOᖇᗪS Oᖴ ᗩᖴᖖᗩTIOᑎ\e[0m"
```
- Perubahan huruf "R" menjadi "Q" pada kata "AFFIRMATION", kemungkinan untuk gaya teks dekoratif.

### Output

![Screenshot from 2025-03-20 21-13-15](https://github.com/user-attachments/assets/ef118ee0-ef52-4372-9d21-5833444057e2)


## Soal No 4

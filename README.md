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

![Screenshot from 2025-03-20 21-14-50](https://github.com/user-attachments/assets/f2f55310-00fe-4824-96d8-842e96ccf62f)

![Screenshot from 2025-03-20 21-14-30](https://github.com/user-attachments/assets/3c4dc23a-051a-451a-82e0-dddb6c53b578)

![Screenshot from 2025-03-20 21-14-14](https://github.com/user-attachments/assets/e754b66d-d017-4a29-a568-a8dd2f8db3d3)

![Screenshot from 2025-03-20 21-13-44](https://github.com/user-attachments/assets/e1d52912-38f7-469e-9e32-3794684414e4)

![Screenshot from 2025-03-20 21-13-15](https://github.com/user-attachments/assets/dbd71d8e-ac46-469b-b9fb-ccf008e24c7f)

## Soal No 4

### Deskripsi
Untuk menganalisis file CSV yang berisi data Pokémon, skrip Bash pokemon_analysis.sh memiliki beberapa fitur utama, seperti menampilkan ringkasan data, mengurutkan data berdasarkan kolom tertentu, mencari Pokémon berdasarkan nama, dan memfilter Pokémon berdasarkan tipe.

### Periksa Input
Bagian pertama skrip mengecek apakah pengguna sudah memberikan minimal dua argumen (file.csv dan perintah). Jika tidak, skrip akan menampilkan pesan error dan keluar.

```sh
if [ $# -lt 2 ]; then
    echo "Gunakan: $0 <file.csv> <perintah>"
    exit 1
fi
```

### Info
- gsub("%", "", $2) menghapus simbol % dari kolom Usage%.
- awk mencari Pokémon dengan Usage% tertinggi dan Raw Usage tertinggi.

```sh
  if [ "$perintah" == "--info" ]; then
    awk -F',' '
    BEGIN {
        max_usage = 0; max_raw = 0;
    }
    NR > 1 {
        gsub("%", "", $2)  
        usage = $2 + 0
        raw_usage = $3 + 0

        if (usage > max_usage) { max_usage = usage; max_pokemon = $1 }
        if (raw_usage > max_raw) { max_raw = raw_usage; max_raw_pokemon = $1 }
    }
    END {
        print "Summary of", ARGV[1]
        print "Usage Tertinggi:", max_pokemon, "with", max_usage "%"
        print "Raw Usage Tertinggi:", max_raw_pokemon, "with", max_raw, "uses"
    }' "$file"
    exit 0
fi
```

### Sort
- Mengecek apakah pengguna memasukkan nama kolom yang valid (usage, rawusage, name, hp, atk, def, dll.).
- Mengurutkan berdasarkan kolom yang dipilih dengan sort.

```sh
if [ "$perintah" == "--sort" ]; then
    if [ -z "$3" ]; then
        echo "Error: tidak ada argumen untuk sort
        gunakan -h atau --help untuk bantuan"
        exit 1
    fi

    column="$3"
    case $column in
        usage) sort_col=2;;
        rawusage) sort_col=3;;
        name) sort_col=1;;
        hp) sort_col=6;;
        atk) sort_col=7;;
        def) sort_col=8;;
        spatk) sort_col=9;;
        spdef) sort_col=10;;
        speed) sort_col=11;;
        *)
            echo "Error: Invalid column name"
            exit 1
            ;;
    esac
```

### Grep
- tolower($1) ~ tolower(key) memungkinkan pencarian tidak case-sensitive.
- Data diurutkan berdasarkan Usage%.

```sh
if [ "$perintah" == "--grep" ]; then
    if [ -z "$3" ]; then
        echo "Error: tidak ada argumen untuk grep
        gunakan -h atau --help untuk bantuan"
        
        exit 1
    fi

    grep_keyword="$3"

    { 
        head -n1 "$file" 
        awk -F',' -v key="$grep_keyword" '
        NR > 1 && tolower($1) ~ tolower(key) {
            gsub("%", "", $2); 
            print $2 "," $0  
        }' "$file" | sort -t',' -k1,1nr | cut -d',' -f2-
    }
    exit 0
fi
```

### Filter
- Pokémon dapat memiliki dua tipe, sehingga skrip memeriksa dua kolom ($4 dan $5).
- Data diurutkan berdasarkan Usage% tertinggi.

```sh
if [ "$perintah" == "--filter" ]; then
    if [ -z "$3" ]; then
        echo "Error: Tidak ada tipe Pokémon yang dimasukkan untuk filter!
        gunakan -h atau --help untuk bantuan""
        exit 1
    fi

    type_filter="$3"

    { 
        head -n 1 "$file"  
        tail -n +2 "$file" | awk -F',' -v type="$type_filter" '
        NR > 1 && (tolower($4) == tolower(type) || tolower($5) == tolower(type)) {
            gsub("%", "", $2); 
            print $2 "," $0    
        }' | sort -t',' -k1,1nr | cut -d',' -f2-
    }
    exit 0
fi
```

### Help
Menampilkan command bila error atau salah masukin

```sh
if [[ "$perintah" == "-h" || "$perintah" == "--help" ]]; then
    cat << EOF
Gunakan: ./pokemon_analysis.sh <file.csv> <perintah> [options]

perintah:
  --info           Menampilkan ringkasan Pokemon dengan Usage% dan RawUsage tertinggi.
  --sort <kolom>   Mengurutkan Pokemon berdasarkan kolom (usage, rawusage, name, hp, atk, def, spatk, spdef, speed).
  --grep <nama>    Mencari Pokemon berdasarkan nama.
  --filter <type>  Menampilkan Pokemon berdasarkan tipe (misalnya 'dark').
  -h, --help       Menampilkan bantuan list yang digunakan.
EOF
    exit 0
fi
```

### Cara Menjalankan

```sh
./pokemon_analysis.sh <file.csv> <perintah> [opsi]
```

### Revisi
Penambahan error handling berikut di setiap perintah

```sh
gunakan -h atau --help untuk bantuan
```

### Output
![Screenshot from 2025-03-20 21-47-14](https://github.com/user-attachments/assets/fa96b288-bc2e-48ed-b0d6-519068edafe1)

![Screenshot from 2025-03-20 21-48-05](https://github.com/user-attachments/assets/5e2115b0-86e7-4019-bdcb-48a580b3108a)

![Screenshot from 2025-03-20 21-48-05](https://github.com/user-attachments/assets/3cf65bd3-f6fc-42b9-97e8-f433468f6634)

![Screenshot from 2025-03-20 21-48-51](https://github.com/user-attachments/assets/f61156c3-2460-40af-a63d-3c28b727f8ca)

![Screenshot from 2025-03-20 21-50-00](https://github.com/user-attachments/assets/23d37a8e-2558-4b41-8e22-b2b0c71d9cd9)

![Screenshot from 2025-03-20 21-50-32](https://github.com/user-attachments/assets/eb0c61b4-c2cd-4692-88dc-7f2fbcfcca0e)

![Screenshot from 2025-03-20 21-51-06](https://github.com/user-attachments/assets/4a47c552-ab71-4256-9896-ef3b3b8c84f5)






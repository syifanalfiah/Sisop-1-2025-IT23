# Laporan Praktikum Modul 1

## Nama Anggota

| Nama                        | NRP        |
| --------------------------- | ---------- |
| Syifa Nurul Alfiah          | 5027241019 |
| Alnico Virendra Kitaro Diaz | 5027241081 |
| Hafiz Ramadhan              | 5027241096 |

## Soal No 1
#### 1.
![image](https://github.com/user-attachments/assets/49410aa1-42a5-46da-8133-a7afa38db491)

- mkdir soal_1 = untuk membuat directory baru bernama soal_1 
- cd soal_1 = untuk masuk ke directory yg Bernama soal_1 
- nano poppo_siroyo.sh = Berguna untuk mengedit skrip atau kode pemrograman di terminal. 
- wget "https://drive.usercontent.google.com/u/0/uc?id=1l8fsj5LZLwXBlHaqhfJVjz_T0p7EJjqV&export= download" -O reading_data.csv = untuk mendownload file yang ada di dalam drive 
- chmod +x poppo_siroyo.sh = untuk mengganti permission agar bisan di execute

![image](https://github.com/user-attachments/assets/94334484-8d28-410b-a8aa-f11f5eede2ee)

A. awk -F',' '$2 == "Chris Hemsworth" {count++}  END {print "Chris Hemsworth membaca " count " buku."}' "$CSV_FILE" = untuk mendapatkan jumlah buku yang telah dibaca chris hemswort 

B. awk -F',' '$8 == "Tablet" {sum += $6; count++} END {if (count > 0) print "Rata-rata durasi membaca dengan Tablet adalah " sum/count " menit."}' "$CSV_FILE" exit 0 = untuk mendapatkan rata – rata durasi membaca menggunakan tablet  

C. awk -F',' 'NR > 1 && $7 > max {max = $7; name = $2; title = $3} END {print "Pembaca dengan rating tertinggi: " name " - " title " - " max}' "$CSV_FILE exit 0 = untuk mendapatkan pembaca dengan rating tertinggi 

D. awk -F',' '$9 == "Asia" && $5 > "2023-12-31" {genre[$4]++} END {for (g in genre) if (genre[g] > max) {max = genre[g]; pop_genre = g} print "Genre paling populer di Asia setelah 2023: " pop_genre " - " max}' "$CSV_FILE" exit 0 = untuk mendapatkan genre apa yang paling popular setelah tahun 2023


#### output dari soal 1

![image](https://github.com/user-attachments/assets/83445d2a-2b3b-4691-b91e-ea426f56ae23)


## Soal No 2

### 1. register.sh
### Fungsi:
Mendaftarkan pengguna baru dengan validasi email dan password, lalu menyimpannya dalam file CSV.

### Penjelasan Kode:
#### 1. **Memvalidasi Format Email:**  
   ```bash
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
   }' || { exit 1; }
   ```
   - `awk` → Mengecek format email sesuai pola regex standar.  
   - `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$` → Pola regex untuk format email   
     - `[a-zA-Z0-9._%+-]+` → Karakter yang diizinkan sebelum `@`.  
     - `@` → Karakter pemisah email.  
     - `[a-zA-Z0-9.-]+` → Karakter yang diizinkan setelah `@`.  
     - `\.` → Titik setelah domain.  
     - `[a-zA-Z]{2,}$` → Minimal dua huruf untuk TLD.  
   - Jika format tidak sesuai, mencetak pesan error dan keluar dari skrip.  

#### 2. **Memeriksa Apakah Email Sudah Terdaftar:**  
   ```bash
   if grep -q "^$Email," data/player.csv; then
     echo -e "\033[31mCoba ganti email bang, yang ini udah ada.\033[0m"
     exit 1
   fi
   ```
   - `grep -q` → Mengecek apakah email sudah ada di file `data/player.csv` tanpa mencetak output.  
   - Jika email ditemukan, program akan mencetak pesan error dan keluar.  

#### 3. **Memvalidasi Format Password:**  
   ```bash
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
   ```
   - `length($0) < 8` → Minimal panjang password adalah 8 karakter.  
   - `/[A-Z]/` → Harus memiliki minimal satu huruf kapital.  
   - `/[a-z]/` → Harus memiliki minimal satu huruf kecil.  
   - `/[0-9]/` → Harus memiliki minimal satu angka.  
   - Jika tidak memenuhi syarat, akan mencetak pesan error dan keluar.  

#### 4. **Mengenkripsi Password dan Menyimpan Data:**  
   ```bash
   sSalt="V3st1@Zet4"
   HPword=$(echo -n "$Pword$sSalt" | sha256sum | awk '{print $1}')

   record="$Email,$username,$HPword"
   echo "$record" >> data/player.csv
   ```
   - `sSalt="V3st1@Zet4"` → Menambahkan salt untuk memperkuat keamanan password.  
   - `echo -n "$Pword$sSalt" | sha256sum` → Menghasilkan hash SHA-256 dari password + salt.  
   - `awk '{print $1}'` → Mengambil hasil hash (tanpa tanda `-`).  
   - `>> data/player.csv` → Menambahkan data ke akhir file tanpa menimpa data sebelumnya.

### 2. login.sh
### Fungsi:
Melakukan proses login dengan memvalidasi email dan password yang sudah terdaftar di file CSV.

### Penjelasan Kode:
#### 1. **Memvalidasi Format Email**
Proses validasi format email ini kurang lebih sama kayak yang ada di `register.sh`. Jika format email tidak sesuai, program akan mencetak pesan error dan keluar.

#### 2. **Memeriksa Apakah Email Terdaftar**
```bash
if ! grep -q "^$Email," data/player.csv; then
    echo -e "\033[31mEmail tidak ditemukan, kamu bohong, register dulu.\033[0m"
    exit 1
fi
```
- `grep -q` → Mencari email pada file `data/player.csv` tanpa mencetak output ke terminal.
- `^$Email,` → Pola regex untuk mencocokkan email di awal baris.
- Jika email tidak ditemukan, program akan mencetak pesan error dan keluar.


#### 3. **Membandingkan Password**
```bash
sSalt="V3st1@Zet4"
HPword=$(echo -n "$Pword$sSalt" | sha256sum | awk '{print $1}')

storedHPword=$(grep "^$Email," data/player.csv | head -n 1 | awk -F',' '{print $3}')

if [ "$HPword" = "$storedHPword" ]; then
    echo -e "\033[32mLogin berhasil!\033[0m"
else
    echo -e "\033[31mTolong diperhatikan lagi passwordnya\033[0m"
    exit 1
fi
```
- `sSalt="V3st1@Zet4"` → Salt yang sama persis kayak di register.sh digunakan untuk memastikan hashing konsisten.
- `echo -n "$Pword$sSalt" | sha256sum | awk '{print $1}'` → Mengenkripsi password dengan algoritma SHA-256.
- `storedHPword=$(grep "^$Email," data/player.csv | head -n 1 | awk -F',' '{print $3}')` → Mencari hash password yang tersimpan di file.
    - `grep "^$Email," data/player.csv` → Mencari baris dengan email yang sesuai.
    - `head -n 1` → Mengambil baris pertama yang cocok.
    - `awk -F',' '{print $3}'` → Mengambil kolom ketiga (hash password).
- `if [ "$HPword" = "$storedHPword" ]; then` → Membandingkan hasil hash password yang diinput dengan yang tersimpan di file.
    - Jika cocok, mencetak pesan sukses.
    - Jika tidak cocok, mencetak pesan error dan keluar.

### 3. core_monitor.sh
### Fungsi:
Memonitor penggunaan CPU dan menampilkan informasi tentang model CPU serta persentase penggunaan CPU saat ini.

### Penjelasan Kode:
#### 1. **Mendapatkan Model CPU**
```bash
cpu_model=$(grep "model name" /proc/cpuinfo | head -n 1 | cut -d ':' -f2- | sed 's/^[ \t]*//')
```
- `grep "model name" /proc/cpuinfo` → Mencari baris yang berisi informasi model CPU dari file `/proc/cpuinfo`.
- `head -n 1` → Mengambil hanya baris pertama (kalo ada lebih dari satu prosesor).
- `cut -d ':' -f2-` → Memotong teks setelah tanda `:` untuk mendapatkan nama model CPU.
- `sed 's/^[ \t]*//'` → Menghapus spasi atau tab yang ada di awal string.

#### 2. **Mendapatkan Waktu Sekarang**
```bash
timestamp=$(date '+%Y-%m-%d %H:%M:%S')
```
- `date '+%Y-%m-%d %H:%M:%S'` → Mengambil waktu sistem dalam format `YYYY-MM-DD HH:MM:SS`.

#### 3. **Menghitung Penggunaan CPU**
```bash
cpu_idle=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/")
cpu_usage=$(awk -v idle="$cpu_idle" 'BEGIN { usage=100 - idle; printf "%.0f", usage }')
```
- `top -bn1` → Menjalankan perintah `top` dalam mode batch dan hanya memperbarui satu kali.
- `grep "Cpu(s)"` → Mencari baris yang berisi informasi tentang CPU.
- `sed "s/.*, *\([0-9.]*\)%* id.*/\1/"` → Mengambil nilai `idle` dari hasil `top`.
- `awk -v idle="$cpu_idle" 'BEGIN { usage=100 - idle; printf "%.0f", usage }'` → Menghitung penggunaan CPU (100% - idle) dan menampilkan dalam format bulat.

#### 4. **Menampilkan Informasi**
```bash
echo "[$timestamp] - Core Usage [${cpu_usage}%] - Terminal Model [${cpu_model}]"
```
- `echo` → Mencetak informasi ke terminal dengan format:
    - `[timestamp]` → Waktu saat ini.
    - `Core Usage [${cpu_usage}%]` → Persentase penggunaan CPU.
    - `Terminal Model [${cpu_model}]` → Nama model CPU.

### 4. frag_monitor.sh
### Fungsi:
Memantau penggunaan memori (RAM) dalam sistem dan mencetak informasi jumlah memori yang digunakan, total memori, dan persentase penggunaan memori saat ini.

### Penjelasan Kode:
#### 1. **Membaca Data Penggunaan Memori**
```bash
read total used free shared buff_cache available < <(free -m | awk 'NR==2 {print $2, $3, $4, $5, $6, $7}')
```
- `free -m` → Menampilkan informasi penggunaan memori dalam satuan MB (megabyte).
- `awk 'NR==2 {print $2, $3, $4, $5, $6, $7}'` → Mengambil baris kedua (yang menunjukkan data memori fisik) dan mencetak kolom-kolom berikut:
    - `$2` → **total** → Total memori fisik yang tersedia di sistem.
    - `$3` → **used** → Jumlah memori yang sedang digunakan.
    - `$4` → **free** → Jumlah memori yang tidak digunakan.
    - `$5` → **shared** → Jumlah memori yang digunakan bersama antar proses.
    - `$6` → **buff/cache** → Jumlah memori yang digunakan sebagai buffer atau cache.
    - `$7` → **available** → Perkiraan memori yang masih bisa dialokasikan ke proses baru.

- `read total used free shared buff_cache available` → Menyimpan nilai yang diambil dari perintah `awk` ke dalam variabel yang bersangkutan.

#### 2. **Menghitung Penggunaan Memori (Fragment Usage)**
```bash
used_mem=$(echo "$total - $available" | bc)
usage=$(echo "scale=1; ($used_mem*100)/$total" | bc)
```
- `echo "$total - $available" | bc` → Menghitung jumlah memori yang sedang digunakan (dengan mengurangkan total memori dan memori yang tersedia).
- `bc` → **Basic Calculator**, digunakan untuk melakukan operasi matematika di bash.
- `scale=1` → Menentukan presisi hasil perhitungan hingga 1 angka desimal.
- `($used_mem*100)/$total` → Menghitung persentase memori yang digunakan.

#### 3. **Mengambil Timestamp Saat Ini**
```bash
timestamp=$(date '+%Y-%m-%d %H:%M:%S')
```
- `date '+%Y-%m-%d %H:%M:%S'` → Mengambil waktu saat ini dalam format `YYYY-MM-DD HH:MM:SS`.

#### 4. **Menampilkan Hasil ke Terminal**
```bash
echo "[$timestamp] - Fragment Usage [${usage}%] - Fragment Count [${used_mem} MB] - Details [Total: ${total} MB, Available: ${available} MB]"
```
- Mencetak informasi berikut ke terminal:
    - `[$timestamp]` → Waktu saat ini.
    - `Fragment Usage` → Persentase memori yang digunakan.
    - `Fragment Count` → Jumlah memori yang digunakan dalam satuan MB.
    - `Details` → Rincian total memori dan memori yang tersedia dalam MB.

### 5. manager.sh
### Fungsi:
Mengelola proses monitoring CPU dan RAM menggunakan `cron job`, serta menyediakan antarmuka untuk mengaktifkan, menonaktifkan, dan menampilkan status monitoring.

### Penjelasan Kode:
#### 1. **Deklarasi Warna, Direktori, dan Fungsi Menu**
- Kode di awal berfungsi untuk:
  - Deklarasi warna.
  - Fungsi `A_nexus()` menampilkan menu.

#### 2. **Inisialisasi Path Direktori**
- `project_dir="$(dirname "$(dirname "$(realpath "$0")")")"` → Mengatur path direktori utama dari lokasi `manager.sh` berada.
- `logs_dir="$project_dir/logs"` → Menentukan direktori untuk menyimpan file log.

#### 3. **Mengaktifkan atau Menonaktifkan Core Monitor dan Fragment Monitor**
```bash
if ! crontab -l | grep -q "core_monitor.sh"; then
   (crontab -l; echo "*/5 * * * * /bin/bash $project_dir/scripts/core_monitor.sh >> $logs_dir/core.log 2>&1") | crontab -
   echo -e "${GREEN}CPU [Core] Monitor meownyala!${NC}"
else
   crontab -l | grep -v "core_monitor.sh" | crontab -
   echo -e "${RED}CPU [Core] Monitor turu${NC}"
fi

if ! crontab -l | grep -q "frag_monitor.sh"; then
   (crontab -l; echo "*/10 * * * * /bin/bash $project_dir/scripts/frag_monitor.sh >> $logs_dir/fragment.log 2>&1") | crontab -
   echo -e "${GREEN}RAM [Fragment] Monitor meownyala!${NC}"
else
   crontab -l | grep -v "frag_monitor.sh" | crontab -
   echo -e "${RED}RAM [Fragment] Monitor turu${NC}"
fi
```
- `crontab -l` → Menampilkan daftar cron job aktif.
- `grep -q` → Mengecek apakah cron job untuk `core_monitor.sh` atau `frag_monitor.sh` sudah terdaftar.
- Jika belum terdaftar, cron job baru ditambahkan:
    - `*/5 * * * *` → Menjalankan `core_monitor.sh` setiap 5 menit.
    - `*/10 * * * *` → Menjalankan `frag_monitor.sh` setiap 10 menit.
    - `>> $logs_dir/core.log 2>&1` → Menyimpan output ke file log dan mencatat error jika ada.
- Jika sudah terdaftar, cron job akan dihapus menggunakan `grep -v`.

#### 4. **Menampilkan Cron Job yang Aktif dan Menangani Input Tidak Valid**
```bash
echo -e "${CYAN}Active Cron Jobs:${NC}"
crontab -l
read -r
```
- `crontab -l` → Menampilkan semua cron job yang sedang aktif.
- `read -r` → Menunggu input untuk kembali ke menu.

```bash
6)
    echo -e "${GREEN}Exiting ARCAEA MONITOR... じゃあね!${NC}"
    exit 0
    ;;
*)
    echo -e "${RED}Invalid option! Please try again.${NC}"
    sleep 1
    ;;
```
- `exit 0` → Menghentikan program dengan status sukses.
- Jika input tidak valid, program akan mencetak pesan kesalahan dan kembali ke menu.

### 6. terminal.sh
### Fungsi:
Mengelola proses utama aplikasi dengan menampilkan menu untuk melakukan registrasi, login, dan keluar dari program.

### Penjelasan Kode:
#### 1. **Deklarasi Warna dan Fungsi Menu**
- **Kode di awal berfungsi untuk:**
  - deklarasi warna.
  - `dirname "$0"` → Mengambil direktori tempat file `terminal.sh` berada.
  - Fungsi `show_menu()` nampilin menu .

#### 2. **Menangani Pilihan Menu**
```bash
read -p "$(echo -e ${ORANGE}Select an option [1-3]: ${NC})" choice
case $choice in
```
- `read -p` → Membaca input player.
- `case $choice in` → Menangani input berdasarkan pilihan pengguna.

#### 3. **Registrasi Pengguna**
```bash
1)
    "$script_dir/register.sh"
```
- `$script_dir/register.sh` → Menjalankan skrip `register.sh` untuk proses registrasi.

#### 4. **Login Pengguna dan Menjalankan Manager**
```bash
2)
    "$script_dir/login.sh"
    if [ $? -eq 0 ]; then
        bash "$script_dir/scripts/manager.sh"
    fi
```
- `$script_dir/login.sh` → Menjalankan skrip `login.sh` untuk proses login.
- `if [ $? -eq 0 ]; then` → Mengecek apakah `login.sh` dieksekusi dengan status sukses (kode 0).
    - Jika berhasil, maka akan menjalankan `manager.sh` untuk mengatur proses monitoring.

#### 5. **Keluar dari Program atau Menangani Input Tidak Valid**
```bash
3)
    echo -e "${RED}Exiting ARCAEA NEXUS... またね!!${NC}"
    exit 0
    ;;
*)
    echo -e "${RED}Invalid option! Please try again.${NC}"
    ;;
```
- `exit 0` → Menghentikan program dengan status sukses.
- Jika input tidak valid, program akan mencetak pesan kesalahan dan kembali ke menu.

### Error soal ini
#### 1.
![image](https://github.com/user-attachments/assets/bf719c4b-f6a7-40ae-8943-186288394b92)

bisa spam cron tab, jadi double.
![image](https://github.com/user-attachments/assets/69533a89-f1d5-4c4f-bd46-bf22b295264c)

Nambahin if, biar gak rusak/double lagi

#### 2.
![image](https://github.com/user-attachments/assets/1617a280-891b-430d-8f92-5c94c2a8b7cd)
![image](https://github.com/user-attachments/assets/1f2a4dc3-cf59-4ec1-988b-cda3f864ef3a)


Ada error
Hapus while yang ada di a_nexus, biar ga error lagi.


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






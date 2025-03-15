# Laporan Praktikum Modul 1

## Nama Anggota

| Nama                        | NRP        |
| --------------------------- | ---------- |
| Syifa Nurul Alfiah          | 5027241019 |
| Alnico Virendra Kitaro Diaz | 5027241081 |
| Hafizh Ramadhan             | 5027241096 |

## Soal No 3
##  🎵 The Dark Side of the Moon Script 🎵

### Deskripsi

Proyek ini dibuat untuk merayakan ulang tahun ke-52 album *The Dark Side of the Moon* milik Pink Floyd. Kami mengembangkan sebuah script Bash yang dapat dijalankan melalui terminal dengan memilih salah satu dari lima lagu dalam album tersebut:  

- **Speak to Me**: Menampilkan *word of affirmation* dari API setiap detik.  
- **On the Run**: Menampilkan *progress bar* dengan interval acak.  
- **Time**: Menampilkan *live clock* dengan pembaruan setiap detik.  
- **Money**: Menampilkan efek *matrix* dengan simbol mata uang.  
- **Brain Damage**: Menampilkan *task manager* sederhana yang diperbarui setiap detik.

## 📌 Cara Menjalankan  
Script ini dapat dijalankan dengan perintah berikut di terminal:  

```sh
./dsotm.sh --play="<Track>"
```
```sh
./dsotm.sh --play="Speak to Me"
./dsotm.sh --play="On the Run"
./dsotm.sh --play="Time"
./dsotm.sh --play="Money"
./dsotm.sh --play="Brain Damage"
```

## 📝 Kode Program

```sh
#!/bin/bash
```
Kode ini mendeklarasikan bahwa script ini menggunakan Bash sebagai interpreter.

🛠️ Fungsi speak_to_me()
```sh
speak_to_me() {
    echo -e "\e[1;34mSᑭᕮᗩK TO ᗰᕮ - ᗯOᖇᗪS Oᖴ ᗩᖴᖴIᖇᗰᗩTIOᑎ\e[0m"
    echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    
    while true; do
        curl -s https://www.affirmations.dev/ | jq -r '.affirmation'
        sleep 1
    done
}
```
- speak_to_me() { → Mendeklarasikan fungsi speak_to_me().
- echo -e "\e[1;34mSᑭᕮᗩK TO ᗰᕮ..." → Mencetak judul dengan warna biru.
- echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~" → Membuat pembatas agar tampilan lebih rapi.
- while true; do → Memulai loop tak terbatas untuk terus menampilkan afirmasi.
- curl -s https://www.affirmations.dev/ | jq -r '.affirmation' → Mengambil kata-kata afirmasi dari API menggunakan curl, lalu memproses JSON dengan jq.
- sleep 1 → Menunggu 1 detik sebelum mengambil afirmasi berikutnya.
- done → Menutup loop while.

🛠️ Fungsi on_the_run()
```sh
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
```
- panjang=$(tput cols) → Mengambil jumlah kolom terminal untuk menentukan panjang progress bar.
- progres=0 → Menginisialisasi progres ke 0.
- while [ $progres -le $panjang ]; do → Loop berjalan sampai progress mencapai panjang terminal.
- clear → Membersihkan layar setiap iterasi.
- echo -e "\e[1;32moᑎ Tᕼᕮ ᗯᗩY..." → Mencetak judul dengan warna hijau.
- echo -n "[" → Mencetak awal progress bar.
- for ((i = 0; i < progres; i++)); do echo -n "•"; done → Menampilkan titik progress.
- for ((i = progres; i < panjang; i++)); do echo -n " "; done → Mengisi sisa progress bar dengan spasi.
- echo "] $(($progres * 100 / $panjang))%" → Menampilkan persentase progress.
- progres=$((progres + 1)) → Menambah progress setiap iterasi.
- sleep $(awk -v min=0.1 -v max=1 'BEGIN{srand(); print min+rand()*(max-min)}') → Menunggu dengan interval acak antara 0.1 dan 1 detik untuk efek realistis.

🛠️ Fungsi time_display()
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
- while true; do ... done → Looping terus menerus.
- clear → Bersihkan terminal sebelum update jam.
- echo -e "\e[1;33mjam brp iyeah\e[0m" → Cetak teks warna kuning.
- date "+%Y-%m-%d %H:%M:%S" → Menampilkan waktu real-time.
- sleep 1 → Tunggu 1 detik sebelum update.

🛠️ Fungsi money()
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
- simbols=(...) → Array simbol mata uang.
- cols=$(tput cols), lines=$(tput lines) → Ambil ukuran terminal.
- declare -A positions → Simpan posisi simbol tiap kolom.
- Loop utama (while true) menjalankan efek terus.
- for ((i = 0; i < cols; i+=3)) → Cetak simbol tiap 3 kolom.
- shuf -i 1-$lines -n 1 → Ambil posisi awal acak.
- tput cup $row $i → Cetak simbol di posisi tertentu.
- sleep 0.1 → Buat efek jatuh lebih halus.

🛠️ Fungsi brain_damage()
```sh
brain_damage() {
    while true; do
        clear
        echo -e "\e[1;35mBʀᴀɪɴ Dᴀᴍᴀɢᴇ - Cᴜsᴛᴏᴍ Tᴀsᴋ Mᴀɴᴀɢᴇʀ\e[0m"
        echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
        ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -10
        sleep 1
    done
}
```
- clear → Bersihkan terminal setiap update.
- ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -10 → Ambil 10 proses dengan CPU tertinggi.
- free -h → Tampilkan penggunaan memori dengan format mudah dibaca.
- sleep 1 → Update setiap 1 detik.

🎛️ Switch-Case: Menjalankan Track Sesuai Input  
```sh
ccase "$1" in
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
```
- case "$1" adalah argumen pertama yang diberikan ke script saat dijalankan. Kita memeriksa apakah pengguna memasukkan --play=<Track> yang valid.
- Jika pengguna mengetik --play=SpeakToMe, maka fungsi speak_to_me dipanggil.
- menandakan akhir dari setiap case.

## Soal No 4


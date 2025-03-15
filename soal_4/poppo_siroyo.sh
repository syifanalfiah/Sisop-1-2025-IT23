#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <nama_file.csv>"
    exit 1
fi

CSV_FILE="$1"

if [ ! -f "$CSV_FILE" ]; then
    echo "Error: File '$CSV_FILE' tidak ditemukan!"
    exit 1
fi

echo "=== PETUALANGAN TABLET AJAIB ==="
echo "Pilih tugas yang ingin dijalankan:"
echo "1) Hitung jumlah buku yang dibaca Chris Hemsworth"
echo "2) Hitung rata-rata durasi membaca dengan Tablet"
echo "3) Cari pembaca dengan rating tertinggi"
echo "4) Cari genre paling populer di Asia setelah 2023"
echo "Masukkan pilihan (1-4):"
read pilihan

if [ "$pilihan" -eq 1 ]; then
    awk -F',' '$2 == "Chris Hemsworth" {count++} 
        END {print "Chris Hemsworth membaca " count " buku."}' "$CSV_FILE"
    exit 0

elif [ "$pilihan" -eq 2 ]; then
    awk -F',' '$8 == "Tablet" {sum += $6; count++} 
        END {if (count > 0) print "Rata-rata durasi membaca dengan Tablet adalah " sum/count " menit."}' "$CSV_FILE"
    exit 0

elif [ "$pilihan" -eq 3 ]; then
    awk -F',' 'NR > 1 && $7 > max {max = $7; name = $2; title = $3} 
        END {print "Pembaca dengan rating tertinggi: " name " - " title " - " max}' "$CSV_FILE"
    exit 0

elif [ "$pilihan" -eq 4 ]; then
    awk -F',' '$9 == "Asia" && $5 > "2023-12-31" {genre[$4]++} 
        END {for (g in genre) if (genre[g] > max) {max = genre[g]; pop_genre = g} 
        print "Genre paling populer di Asia setelah 2023: " pop_genre " - " max}' "$CSV_FILE"
    exit 0

else
    echo "Pilihan tidak valid!"
    exit 1
fi

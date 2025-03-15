#!/bin/bash

if [ $# -lt 2 ]; then
    echo "Gunakan: $0 <file.csv> <perintah>"
    exit 1
fi

file="$1"
perintah="$2"

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
        print "Highest Adjusted Usage:", max_pokemon, "with", max_usage "%"
        print "Highest Raw Usage:", max_raw_pokemon, "with", max_raw, "uses"
    }' "$file"
    exit 0
fi

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

    if [ "$column" == "usage" ]; then
        { head -n1 "$file"; awk -F',' 'NR>1 {gsub("%", "", $2); print $2 "," $0}' "$file" | sort -t',' -k1,1nr | cut -d',' -f2-; }
    elif [ "$column" == "rawusage" ]; then
        { head -n1 "$file"; awk -F',' 'NR>1 {print $3 "," $0}' "$file" | sort -t',' -k1,1nr | cut -d',' -f2-; }
    elif [ "$column" == "name" ]; then
        { head -n1 "$file"; tail -n +2 "$file" | sort -t',' -k1,1; }
    else
        { head -n1 "$file"; awk -F',' -v col="$sort_col" 'NR>1 {print $col+0 "," $0}' "$file" | sort -t',' -k1,1nr | cut -d',' -f2-; }
    fi
    exit 0
fi

if [ "$perintah" == "--grep" ]; then
    if [ -z "$3" ]; then
        echo "Error: tidak ada argumen untuk grep"
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

if [ "$perintah" == "--filter" ]; then
    if [ -z "$3" ]; then
        echo "Error: Tidak ada tipe Pokémon yang dimasukkan untuk filter!"
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

if [[ "$perintah" == "-h" || "$perintah" == "--help" ]]; then
    cat << EOF

.__  .__                              .__                     
|__| |  |   _______  __ ____     _____|__| __________ ______  
|  | |  |  /  _ \  \/ // __ \   /  ___/  |/  ___/  _ \\____ \ 
|  | |  |_(  <_> )   /\  ___/   \___ \|  |\___ (  <_> )  |_> >
|__| |____/\____/ \_/  \___  > /____  >__/____  >____/|   __/ 
                           \/       \/        \/      |__|    

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

echo "Error: Invalid perintah"
exit 1
#!/bin/bash

if [ $# -lt 2 ]; then
    echo "Gunakan: $0 <file.csv> <perintah>"
    exit 1
fi

file="$1"
perintah="$2"

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
        print "Highest Adjusted Usage:", max_pokemon, "with", max_usage "%"
        print "Highest Raw Usage:", max_raw_pokemon, "with", max_raw, "uses"
    }' "$file"
    exit 0
fi

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

    if [ "$column" == "usage" ]; then
        { head -n1 "$file"; awk -F',' 'NR>1 {gsub("%", "", $2); print $2 "," $0}' "$file" | sort -t',' -k1,1nr | cut -d',' -f2-; }
    elif [ "$column" == "rawusage" ]; then
        { head -n1 "$file"; awk -F',' 'NR>1 {print $3 "," $0}' "$file" | sort -t',' -k1,1nr | cut -d',' -f2-; }
    elif [ "$column" == "name" ]; then
        { head -n1 "$file"; tail -n +2 "$file" | sort -t',' -k1,1; }
    else
        { head -n1 "$file"; awk -F',' -v col="$sort_col" 'NR>1 {print $col+0 "," $0}' "$file" | sort -t',' -k1,1nr | cut -d',' -f2-; }
    fi
    exit 0
fi

if [ "$perintah" == "--grep" ]; then
    if [ -z "$3" ]; then
        echo "Error: tidak ada argumen untuk grep
        gunakan -h atau --help untuk bantuan"
        exit 1
    fi

    awk -F',' -v search="$3" 'NR==1 {print}
    tolower($1) ~ tolower(search) {print}' "$file"

    exit 0
fi

if [ "$perintah" == "--filter" ]; then
    if [ -z "$3" ]; then
        echo "Error: tidak ada argumen untuk filter
        gunakan -h atau --help untuk bantuan"
        exit 1
    fi

    type_filter="$3"

    { 
        head -n1 "$file"  
        awk -F',' -v type="$type_filter" '
        NR > 1 && (tolower($4) == tolower(type) || tolower($5) == tolower(type)) {
            gsub("%", "", $2); 
            print $2 "," $0    
        }' "$file" | sort -t',' -k1,1nr | cut -d',' -f2-
    }

    exit 0
fi

if [[ "$perintah" == "-h" || "$perintah" == "--help" ]]; then
    cat << EOF

.__  .__                              .__                     
|__| |  |   _______  __ ____     _____|__| __________ ______  
|  | |  |  /  _ \  \/ // __ \   /  ___/  |/  ___/  _ \\____ \ 
|  | |  |_(  <_> )   /\  ___/   \___ \|  |\___ (  <_> )  |_> >
|__| |____/\____/ \_/  \___  > /____  >__/____  >____/|   __/ 
                           \/       \/        \/      |__|    

Gunakan: ./pokemon_analysis.sh <file.csv> <perintah> [options]

perintahs:
  --info           Menampilkan ringkasan Pokemon dengan Usage% dan RawUsage tertinggi.
  --sort <kolom>   Mengurutkan Pokemon berdasarkan kolom (usage, rawusage, name, hp, atk, def, spatk, spdef, speed).
  --grep <nama>    Mencari Pokemon berdasarkan nama.
  --filter <type>  Menampilkan Pokemon berdasarkan tipe (misalnya 'dark').
  -h, --help       Menampilkan bantuan list yang digunakan.

EOF
    exit 0
fi

echo "Error: Invalid perintah"
exit 1

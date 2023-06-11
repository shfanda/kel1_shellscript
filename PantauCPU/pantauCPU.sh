#!/bin/bash
#Pencatatan log cpu usage pemakaian tertentu

# inisialisasi token, chat id, dan url untuk notifikasi telegram
TOKEN="6120074346:AAFR5WhCg9lrxc0Q3dokSU3Pg1iNOc-ZUNM"
CHAT_ID="-831292086"
URL="https://api.telegram.org/bot$TOKEN/sendMessage"

# inisialisasi file log
log_CPU_all="PantauCPU/pantauCPU.log"
log_CPU_highload=PantauCPU/highloadCPU.log 

# fungsi yang akan dijalankan di script kel1_start.sh
pantauCPU(){

    # mengambil status penggunaan CPU saat ini dengan perintah top
    top_val=$(top -bn1 | grep "Cpu(s)")

    # total penggunaan CPU = penggunaan oleh user + penggunaan oleh sistem
    cpu_usage=$(echo $top_val | awk '{print int($2 + $4)}')

    # jika penggunaan CPU lebih dari 90, maka kirim notifikasi
    if [ $cpu_usage -ge 20 ]; then

        # catat penggunaan CPU lebih dari 90 di log highloadCPU
        echo "[$(date +"%d/%b/%Y %H:%M:%S")] $top_val" >> $log_CPU_highload

        # pesan yang akan dikirim
        MESSAGE="[$(date +"%d/%b/%Y %H:%M:%S")]  ⚠️  CPU Usage : $cpu_usage%"

        # kirim notifikasi telegram, catat juga di log telegram
        curl -s -X POST $URL \
            -d "chat_id=$CHAT_ID" \
            -d "text=$MESSAGE" >> telegram.log
        echo "" >> telegram.log
    fi

    # catat semua penggunaan CPU di log pantauCPU
    echo "[$(date +"%d/%b/%Y %H:%M:%S")] $top_val" >> $log_CPU_all
}

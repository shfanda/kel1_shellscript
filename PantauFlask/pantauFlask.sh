#!/bin/bash
#Pencatatan log jika flask down

# inisialisasi token, chat id, dan url untuk notifikasi telegram
TOKEN="6120074346:AAFR5WhCg9lrxc0Q3dokSU3Pg1iNOc-ZUNM"
CHAT_ID="-831292086"
URL="https://api.telegram.org/bot$TOKEN/sendMessage"

# inisialisasi file log
log_flask_all="PantauFlask/flask_all.log"
log_flask_down="PantauFlask/flask_down.log"

# fungsi yang akan dijalankan di script kel1_start.sh
pantauFlask(){

    # jika Flask "sample.py" mati, maka kirim notifikasi
    if ! pgrep -f "sample.py" >/dev/null; then

        # catat ketika flask mati di log highloadCPU
        echo "[$(date +"%d/%b/%Y %H:%M:%S")] Flask mati" >> $log_flask_down

        # pesan yang akan dikirim
        MESSAGE="[$(date +"%d/%b/%Y %H:%M:%S")]  ⚠️  Flask mati"

        # kirim notifikasi telegram, catat juga di log telegram
        curl -s -X POST $URL \
            -d "chat_id=$CHAT_ID" \
            -d "text=$MESSAGE" >> telegram.log
        echo "" >> telegram.log

        #coba run flask secara otomatis
        python3 Flask/sample.py >> $log_flask_all 2>&1 &

        # kirim notifikasi lagi jika berhasil/gagal run flask secara otomatis
        if pgrep -f "sample.py" >/dev/null; then
            MESSAGE="[$(date +"%d/%b/%Y %H:%M:%S")]  ✅  Flask berhasil dinyalakan secara otomatis"
        else
            MESSAGE="[$(date +"%d/%b/%Y %H:%M:%S")]  ⚠️  Flask gagal dinyalakan secara otomatis"
        fi
        curl -s -X POST $URL \
             -d "chat_id=$CHAT_ID" \
             -d "text=$MESSAGE" >> telegram.log
        echo "" >> telegram.log
    fi
}
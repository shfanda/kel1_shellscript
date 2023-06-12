#!/bin/bash
#Pencatatan log jika 404

# inisialisasi token, chat id, dan url untuk notifikasi telegram
TOKEN="6120074346:AAFR5WhCg9lrxc0Q3dokSU3Pg1iNOc-ZUNM"
CHAT_ID="-831292086"
URL="https://api.telegram.org/bot$TOKEN/sendMessage"

# inisialisasi file log
log_flask="PantauFlask/flask_all.log"
log_checked="Pantau404/flask_checked.log"
log_unchecked="Pantau404/flask_unchecked.log"
log_404="Pantau404/flask_404.log"

# fungsi yang akan dijalankan di script kel1_start.sh
pantau404(){
    
    # cek perbedaan di log flask dengan di log flask_checked
    diff -u "$log_flask" "$log_checked" | grep '^-' | sed 's/^-//' > "$log_unchecked"

    # ambil error 404 dan URL-nya
    result_error=$(grep " 404 " "$log_unchecked" | awk '{print $7}')

    cat "$log_unchecked" | grep " 404 " >> "$log_404"

    # jika ada error, maka kirim notifikasi
    if [ -n "$result_error" ]; then

        # pesan yang akan dikirim
        MESSAGE="[$(date +"%d/%b/%Y %H:%M:%S")]  ⚠️  Flask 404 Error URL: $result_error"

        # kirim notifikasi telegram, catat juga di log telegram
        curl -s -X POST $URL \
            -d "chat_id=$CHAT_ID" \
            -d "text=$MESSAGE" >> telegram.log
    fi

    # pindahkan isi log temp ke log flask_checked
    cat $log_unchecked >> $log_checked

    # hapus log flask_unchecked
    rm $log_unchecked
}
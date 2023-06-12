#!/bin/bash

#1. pencatatan log cpu usage pemakaian tertentu
#2. pencatatan log jika flask down
#3. pencatatan log jika 404
#-by telegram-

# import script dari file lain
. PantauCPU/pantauCPU.sh
. PantauFlask/pantauFlask.sh
. Pantau404/pantau404.sh

# looping selamanya
while [ true ]; do
    # jalankan script pantau satu per satu
    pantauCPU
    pantauFlask
    pantau404

    # catat log bahwa script ini masih berjalan
    echo "[$(date +"%d/%b/%Y %H:%M:%S")] Monitoring berjalan" >> kel1.log

    # delay 60 detik
    sleep 60
done

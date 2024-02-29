#!/bin/bash

stop_nginx() {
    systemctl stop nginx
}

start_nginx() {
    systemctl start nginx
}

start_ngrok() {
    ngrok http http://localhost:80 > /dev/null &
    echo "NGROK iniciado."
}

get_ngrok_url() {
    ngrok_url=$(curl -s localhost:4040/api/tunnels | jq -r '.tunnels[0].public_url')
    echo "La URL de NGROK es: $ngrok_url"
}

main() {
    stop_nginx
    killall ngrok
    cd /var/www/PortafolioProfesional
    git pull
    start_nginx
    start_ngrok
    sleep 2
    get_ngrok_url
    echo "Presiona Ctrl+C para salir y detener NGROK"
    trap "killall ngrok" INT
    sleep infinity
}

main

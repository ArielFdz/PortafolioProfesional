#!/bin/bash

# Función para detener NGINX
stop_nginx() {
    systemctl stop nginx
}

# Función para iniciar NGINX
start_nginx() {
    systemctl start nginx
}

# Función para iniciar NGROK en segundo plano
start_ngrok() {
    ngrok http http://localhost:80 > /dev/null &
    echo "NGROK iniciado."
}

# Función para obtener la URL de NGROK
get_ngrok_url() {
    ngrok_url=$(curl -s localhost:4040/api/tunnels | jq -r '.tunnels[0].public_url')
    echo "La URL de NGROK es: $ngrok_url"
}

# Función principal
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

# Llamar a la función principal
main

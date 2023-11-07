#!/bin/bash

repo="bootcamp-devops-2023"
app="app-295devops-travel"

USERID=$(id -u)

LRED='\033[1;31m'
LGREEN='\033[1;32m'
NC='\033[0m'
LBLUE='\033[0;34m'
LYELLOW='\033[1;33m'

if [ "${USERID}" -ne 0 ]; then
    echo -e "\n${LRED}Correr con usuario ROOT${NC}"
    exit
fi

echo "====================================="
apt-get update
echo -e "\n${LGREEN}El Servidor se encuentra Actualizado ...${NC}"

# Ejecutar la etapa 1: [Init]
./01-init.sh

# Ejecutar la etapa 2: [Build]
./02-build.sh $repo $app

# STAGE 3: [Deploy]
# Es momento de probar la aplicación, recuerda hacer un reload de apache y acceder a la aplicacion DevOps Travel
# Aplicación disponible para el usuario final.
# Accede a la aplicación
read -s -p "Ingrese el host de la aplicación: " web_url
./03-discord.sh ~/$repo $web_url/$app

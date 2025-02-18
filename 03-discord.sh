#!/bin/bash

# Configura el token de acceso de tu bot de Discord
DISCORD="https://discord.com/api/webhooks/1154865920741752872/au1jkQ7v9LgQJ131qFnFqP-WWehD40poZJXRGEYUDErXHLQJ_BBszUFtVj8g3pu9bm7h"

# Verifica si se proporcionó el argumento del directorio del repositorio y el host
if [ $# -ne 2 ]; then
  echo "Uso: $0 <ruta_al_repositorio> <web_url>"
  exit 1
fi

# Cambia al directorio del repositorio
cd "$1"

# Obtiene el nombre del repositorio
REPO_NAME=$(basename $(git rev-parse --show-toplevel))
# Obtiene la URL remota del repositorio
REPO_URL=$(git remote get-url origin)
WEB_URL="$2"
# Realiza una solicitud HTTP GET a la URL
HTTP_STATUS=$(curl -Is "$WEB_URL" | head -n 1)

# Verifica si la respuesta es 200 OK (puedes ajustar esto según tus necesidades)
if [[ "$HTTP_STATUS" == *"200"* ]]; then
  # Obtén información del repositorio
  DEPLOYMENT_INFO2="Despliegue del repositorio $REPO_NAME: "
  DEPLOYMENT_INFO="La página web $WEB_URL está en línea."
  COMMIT="Commit: $(git rev-parse --short HEAD)"
  AUTHOR="Autor: $(git log -1 --pretty=format:'%an')"
  DESCRIPTION="Descripción: $(git log -1 --pretty=format:'%s')"
else
  DEPLOYMENT_INFO="La página web $WEB_URL no está en línea."
fi

# Construye el mensaje
MESSAGE="$DEPLOYMENT_INFO2\n$DEPLOYMENT_INFO\n$COMMIT\n$AUTHOR\n$REPO_URL\n$DESCRIPTION"
echo $MESSAGE
echo "Puedes acceder a la aplicación en $WEB_URL"

# Envía el mensaje a Discord utilizando la API de Discord
curl -X POST -H "Content-Type: application/json" \
  -d '{
       "content": "'"${MESSAGE}"'"
     }' "$DISCORD"

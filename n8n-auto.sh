#!/usr/bin/env bash
set -e

BASE_DIR="$HOME/n8n-compose"
DEFAULT_FILE="docker-compose.yml"
YML_FILE=""
DOCKER_COMPOSE_VERSION="v2.38.2"

function has_cmd { command -v "$1" &> /dev/null; }

function install_docker_compose {
  echo "Instalando Docker Compose..."
  sudo curl -SL "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
  echo "Docker Compose instalado correctamente."
}

function ensure_docker_and_compose {
  if ! has_cmd "docker"; then
    echo "Docker no está instalado. Por favor instálalo antes de ejecutar este script."
    exit 1
  else
    echo "Docker ya está instalado."
  fi

  if ! has_cmd "docker-compose"; then
    install_docker_compose
  else
    echo "Docker Compose ya está instalado."
  fi
}

function ensure_compose_v2 {
  if has_cmd "docker" && docker compose version &> /dev/null; then
    return 0
  fi
  cat <<EOF >&2
ERROR: No se ha encontrado 'docker compose' (Compose V2).

Para instalarlo, puedes usar el plugin oficial:
  sudo apt update
  sudo apt install docker-compose-plugin

O manualmente:
  mkdir -p ~/.docker/cli-plugins
  curl -SL "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" \
    -o ~/.docker/cli-plugins/docker-compose
  chmod +x ~/.docker/cli-plugins/docker-compose

Una vez instalado 'docker compose', vuelve a ejecutar este script.
EOF
  exit 1
}

if [[ "$1" == "-f" && -n "$2" ]]; then
  YML_FILE="$2"
  shift 2
else
  YML_FILE="$BASE_DIR/$DEFAULT_FILE"
fi

COMMAND="$1"
if [[ -z "$COMMAND" ]]; then
  echo "Uso: $0 [-f ruta/yml] {start|stop|status|logs}"
  exit 1
fi

function up {
  ensure_docker_and_compose
  ensure_compose_v2
  [[ -f "$YML_FILE" ]] || { echo "No se encontró $YML_FILE"; exit 1; }
  docker compose -f "$YML_FILE" up -d
}

function down {
  ensure_docker_and_compose
  ensure_compose_v2
  docker compose -f "$YML_FILE" down
}

function status {
  docker ps --filter name=n8n
}

function logs {
  ensure_docker_and_compose
  ensure_compose_v2
  docker compose -f "$YML_FILE" logs -f
}

case "$COMMAND" in
  start)  up ;;
  stop)   down ;;
  status) status ;;
  logs)   logs ;;
  *)
    echo "Uso: $0 [-f ruta/yml] {start|stop|status|logs}"
    exit 1
    ;;
esac

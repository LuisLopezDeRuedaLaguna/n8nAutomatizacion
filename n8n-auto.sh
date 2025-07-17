#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="${HOME}/n8n-compose"
DEFAULT_FILE="docker-compose.yml"
YML_FILE=""
USE_PLUGIN=true

function has_cmd { command -v "$1" &>/dev/null; }

function install_compose_plugin {
  echo "Instalando plugin Docker Compose v2 (docker compose)..."
  sudo apt-get update
  sudo apt-get install -y docker-compose-plugin
  echo "Plugin instalado correctamente."
}

function ensure_docker_and_compose {
  if ! has_cmd docker; then
    echo "ERROR: Docker no instalado."
    exit 1
  fi

  if docker compose version &>/dev/null; then
    echo "docker compose (v2) ya está disponible."
    USE_PLUGIN=true
  else
    echo "docker compose no disponible."
    if has_cmd docker-compose; then
      echo "Se detectó docker‑compose (v1). Se recomienda migrar."
      USE_PLUGIN=false
    else
      install_compose_plugin
      USE_PLUGIN=true
    fi
  fi
}

function fix_docker_permissions {
  echo "Ajustando permisos del socket Docker..."
  if ! groups "$USER" | grep -qw docker; then
    sudo usermod -aG docker "$USER"
    echo "📌 Usuario añadido al grupo 'docker'. Cierra y abre sesión o ejecuta 'newgrp docker' para aplicar cambios."
  fi
}

function compose_cmd {
  if $USE_PLUGIN; then
    docker compose "$@"
  else
    docker-compose "$@"
  fi
}

if [[ "$1" == "-f" && -n "${2:-}" ]]; then
  YML_FILE="$2"
  shift 2
else
  YML_FILE="${BASE_DIR}/${DEFAULT_FILE}"
fi

COMMAND="${1:-}"
case "$COMMAND" in
  start)
    ensure_docker_and_compose
    fix_docker_permissions
    [[ -f "$YML_FILE" ]] || { echo "ERROR: No se encontró $YML_FILE"; exit 1; }
    compose_cmd -f "$YML_FILE" up -d
    ;;
  stop)
    ensure_docker_and_compose
    fix_docker_permissions
    compose_cmd -f "$YML_FILE" down
    ;;
  status)
    docker ps --filter name=n8n
    ;;
  logs)
    ensure_docker_and_compose
    fix_docker_permissions
    compose_cmd -f "$YML_FILE" logs -f
    ;;
  *)
    echo "Uso: $0 [-f archivo.yml] {start|stop|status|logs}"
    exit 1
    ;;
esac

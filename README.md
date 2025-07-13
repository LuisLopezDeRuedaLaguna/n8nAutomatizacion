# 🚀 n8n Auto Deploy Script

Automatiza la instalación y gestión de **n8n** con **Docker Compose**, verificando los requisitos antes de iniciar.

---

## 🧠 ¿Qué hace este script?

- Verifica que tengas instalado `docker` y **Docker Compose V2** (`docker compose`).  
  Si no está, muestra instrucciones de cómo instalarlo.  
- Permite indicar un archivo `docker-compose.yml` con el flag `-f`.  
- Gestiona el contenedor `n8n` con los comandos:  
  - `start` (arranca o reinicia)  
  - `stop` (detiene)  
  - `status` (muestra estado)  
  - `logs` (ver logs en tiempo real)

---
<!--
## 📋 Requisitos

- `docker` instalado.  
- `docker compose` (versión V2):  
  - Con paquete oficial:
    ```bash
    sudo apt update
    sudo apt install docker-compose-plugin
    ```  
  - O instalando el plugin manualmente:
    ```bash
    mkdir -p ~/.docker/cli-plugins
    curl -SL "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" \
      -o ~/.docker/cli-plugins/docker-compose
    chmod +x ~/.docker/cli-plugins/docker-compose
    ```

---
-->
## ⚙️ Uso

En el caso de que se quierea usar un .yml se deberá usar el comando 
 ```bash
 ./n8n-auto.sh -f .yml start
 ```
Hazlo ejecutable:

```bash
chmod +x n8n-auto.sh

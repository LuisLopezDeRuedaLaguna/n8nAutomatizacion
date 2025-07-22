## 📖 Descripción  
Este proyecto automatiza la descarga de archivos desde Notion y lo sube a Google Drive, centralizando contenidos de forma transparente. Ideal para equipos que necesitan sincronizar activos sin intervención manual y mantener documentación.

---

## 🎯 Motivación  
En entornos DevOps y ciberseguridad, la consistencia de la documentación es crítica.  
La necesidad de un flujo automático surgió para evitar errores humanos y garantizar que los archivos compartidos en Drive estén siempre disponibles en Notion sin duplicar.

---

## 🛠️ Requisitos previos  
Antes de empezar, asegúrate de tener instalado en tu sistema lo siguiente:

- **Docker** (versión 20.10 o superior)  
- **Docker Compose** (versión 1.29 o superior)

Estos componentes son necesarios para ejecutar los contenedores y orquestar los servicios definidos en este proyecto.

---

## ⚙️ Instalación  
```bash
# Clona el repositorio
git clone https://github.com/LuisLopezDeRuedaLaguna/n8nAutomatizacion.git  
cd n8nAutomatizacion

# Arranca los servicios con Docker Compose
docker compose up -d

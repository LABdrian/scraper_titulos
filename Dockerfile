FROM python:3.11

# Definir el directorio de trabajo
WORKDIR /app

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    nano \
    curl \
    cron

# Limpiar cache de apt
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Instalar dependencias de Python
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Copiar el script de Python al contenedor
COPY scraper.py ./

# Dar permisos de ejecución al script de Python
RUN chmod +x scraper.py

# Crear un archivo de log para poder ver el output del cron
RUN touch /var/log/cron.log

# Agregar cron job (Asegúrate de crear este archivo en tu entorno local)
COPY crontab /etc/cron.d/my-crontab

# Dar permisos al archivo crontab y aplicarlo
RUN chmod 0644 /etc/cron.d/my-crontab && crontab /etc/cron.d/my-crontab

# Correr cron en el foreground
CMD ["cron", "-f"]





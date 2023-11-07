# Usa la imagen base de Ubuntu
FROM ubuntu:latest

# Evita preguntas al instalar paquetes
ARG DEBIAN_FRONTEND=noninteractive

# Actualizar el índice de paquetes e instalar dependencias
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    nano \
    curl \
    cron \
    && rm -rf /var/lib/apt/lists/*

# Configurar la zona horaria a Buenos Aires
ENV TZ=America/Argentina/Buenos_Aires
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Definir el directorio de trabajo
WORKDIR /app

# Instalar dependencias de Python
COPY requirements.txt ./
RUN python3 -m pip install --no-cache-dir -r requirements.txt

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

# Ejecutar cron en el foreground
CMD ["cron", "-f"]

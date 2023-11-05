FROM python:3.11

# Definir el directorio de trabajo
WORKDIR /app

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    nano \
    curl \
    cron

# Instalar dependencias de Python
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt










# Usa la imagen oficial de Python 3.12
FROM python:3.12-slim

# Establece variables de entorno
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PORT=80

# Establece el directorio de trabajo
WORKDIR /app

# Instala las dependencias del sistema necesarias
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copia los archivos de requerimientos
COPY pyproject.toml .

# Copia el código de la aplicación
COPY streamlit-n8n-chat/ ./streamlit-n8n-chat/

# Instala pip y las dependencias
RUN pip install --no-cache-dir pip --upgrade && \
    pip install --no-cache-dir .

# Expone el puerto 80
EXPOSE 80

# Comando para ejecutar la aplicación
CMD ["streamlit", "run", "streamlit-n8n-chat/chat_app.py", "--server.address=0.0.0.0", "--server.port=80"] 
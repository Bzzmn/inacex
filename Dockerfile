# Usa la imagen oficial de Python 3.12
FROM python:3.12-slim

# Establece el directorio de trabajo
WORKDIR /app

# Instala las dependencias del sistema necesarias
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copia los archivos de requerimientos
COPY pyproject.toml .
COPY .env .

# Copia el código de la aplicación
COPY streamlit-n8n-chat/ ./streamlit-n8n-chat/

# Instala pip y las dependencias
RUN pip install --no-cache-dir pip --upgrade
RUN pip install --no-cache-dir .

# Expone el puerto que usa Streamlit por defecto
EXPOSE 8501

# Comando para ejecutar la aplicación
CMD ["streamlit", "run", "streamlit-n8n-chat/chat_app.py", "--server.address=0.0.0.0"] 
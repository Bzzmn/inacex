import streamlit as st
import requests
import json
import uuid  # Añadimos la importación de uuid
import os
from dotenv import load_dotenv

load_dotenv()

# Configuración del webhook de n8n
WEBHOOK_URL = os.getenv("WEBHOOK_URL")
API_KEY = os.getenv("API_KEY")

# Inicializa el historial del chat en el estado de sesión
if "messages" not in st.session_state:
    st.session_state.messages = []

# Inicializa el session_id en el estado de sesión si no existe
if "session_id" not in st.session_state:
    st.session_state.session_id = str(uuid.uuid4())

# Título de la app
st.title("Chat con Agente INACEX 🤖")

# Muestra el historial de mensajes
for message in st.session_state.messages:
    with st.chat_message(message["role"]):
        st.markdown(message["content"])

# Input del usuario
user_input = st.chat_input("Escribe tu mensaje...")

if user_input:
    # Añade el mensaje del usuario al historial y lo muestra inmediatamente
    st.session_state.messages.append({"role": "user", "content": user_input})
    with st.chat_message("user"):
        st.markdown(user_input)
    
    # Muestra un mensaje de "pensando" con un spinner
    with st.chat_message("assistant"):
        with st.spinner("Pensando..."):
            try:
                response = requests.post(
                    WEBHOOK_URL,

                    json={
                        "text": user_input,
                        "session_id": st.session_state.session_id
                    },
                    headers={"Content-Type": "application/json", "X-API-Key": API_KEY}
                )
                # Imprimimos la respuesta completa para debug
                print("Respuesta de n8n:", response.text)
                
                # Verificamos el status code
                response.raise_for_status()
                
                # Intentamos obtener la respuesta del JSON
                response_data = response.json()
                print("JSON parseado:", response_data)  # Debug
                
                # Intentamos obtener la respuesta de diferentes formas posibles
                bot_response = (
                    response_data.get("output")   # Añadimos output como primera opción
                )
                
                # Si la respuesta es un string JSON, intentamos parsearlo
                if isinstance(bot_response, str) and bot_response.startswith("{"):
                    try:
                        bot_response = json.loads(bot_response)
                        if isinstance(bot_response, dict):
                            bot_response = bot_response.get("output", bot_response)
                    except json.JSONDecodeError:
                        pass
                
            except requests.exceptions.RequestException as e:
                bot_response = f"Error en la conexión: {str(e)}"
            except json.JSONDecodeError as e:
                bot_response = f"Error al procesar la respuesta: {str(e)}"
            except Exception as e:
                bot_response = f"Error inesperado: {str(e)}"

            # Muestra la respuesta
            st.markdown(bot_response)
            
    # Añade la respuesta del bot al historial
    st.session_state.messages.append({"role": "assistant", "content": bot_response})
    
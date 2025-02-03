# Variables
IMAGE_NAME = inacex-chat
CONTAINER_NAME = inacex-chat-container
PORT = 8501

# Construir la imagen Docker
build:
	docker build -t $(IMAGE_NAME) .

# Ejecutar el contenedor
run:
	docker run -p $(PORT):$(PORT) --env-file .env --name $(CONTAINER_NAME) $(IMAGE_NAME)

# Ejecutar en modo interactivo
run-interactive:
	docker run -it -p $(PORT):$(PORT) --env-file .env --name $(CONTAINER_NAME) $(IMAGE_NAME)

# Detener y eliminar el contenedor
stop:
	docker stop $(CONTAINER_NAME) || true
	docker rm $(CONTAINER_NAME) || true

# Reiniciar el contenedor
restart: stop run

# Construir y ejecutar
up: build run

# Limpiar imágenes y contenedores no utilizados
clean:
	docker system prune -f
	docker images -q -f dangling=true | xargs -r docker rmi

# Ver logs del contenedor
logs:
	docker logs $(CONTAINER_NAME)

.PHONY: build run run-interactive stop restart up clean logs 
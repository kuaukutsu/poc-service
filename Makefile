UID = $$(id -u)

# Main

build: _network-create app-build si-build

serve: app-serve si-serve

restart: si-restart

stop: si-stop app-stop

down: si-down app-down

# Application

app-build:
 	USER=$(UID) docker-compose -f ./docker-compose.yml build \
 	  	proxy \
 	  	agw

app-serve:
	USER=$(UID) docker-compose -f ./docker-compose.yml --profile serve up -d --remove-orphans

app-stop:
	USER=$(UID) docker-compose -f ./docker-compose.yml --profile serve stop

app-down: stop
	USER=$(UID) docker-compose -f ./docker-compose.yml down --remove-orphans

# Services INFO
si-build:
	USER=$(UID) docker-compose -f ./services/info/docker-compose.yml build \
	  	fpm \
	  	cli \
	  	nginx

si-serve:
	USER=$(UID) docker-compose \
		-f ./services/info/docker-compose.yml \
		--profile serve up -d --remove-orphans

si-stop:
	USER=$(UID) docker-compose \
		-f ./services/info/docker-compose.yml \
		--profile serve stop

si-down: si-stop
	USER=$(UID) docker-compose \
		-f ./services/info/docker-compose.yml \
		down --remove-orphans

si-cli:
	USER=$(UID) docker-compose \
		-f ./services/info/docker-compose.yml \
		run --rm -u $(UID) -w /src cli sh

si-composer:
	docker run --init -it --rm -u $(UID) -v "$$(pwd)/services/info:/src" -w /src \
		composer:latest \
		composer install

si-composer-up:
	docker run --init -it --rm -u $(UID) -v "$$(pwd)/services/info:/src" -w /src \
		composer:latest \
		composer update --no-cache

si-restart: _si-restart-fpm _si-restart-nginx

_si-restart-fpm:
	USER=$(UID) docker-compose -f ./services/info/docker-compose.yml \
		--profile serve restart fpm

_si-restart-nginx:
	USER=$(UID) docker-compose -f ./services/info/docker-compose.yml \
		--profile serve restart nginx

# Dependencies

_network-create:
	docker network create poc-service

_network-remove:
	docker network rm -f poc-service

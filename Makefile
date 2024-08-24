UID = $$(id -u)

# Main

build: _network-create app-build si-build sc-build

rebuild: down _network-remove _image_remove _container_remove _si-remove _sc-remove build

serve: app-serve si-serve sc-serve

restart: _si-restart _sc-restart

stop: si-stop sc-stop app-stop

down: si-down sc-down app-down

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

_si-restart: _si-restart-fpm _si-restart-nginx

_si-restart-fpm:
	USER=$(UID) docker-compose -f ./services/info/docker-compose.yml \
		--profile serve restart fpm

_si-restart-nginx:
	USER=$(UID) docker-compose -f ./services/info/docker-compose.yml \
		--profile serve restart nginx

_si-remove: _si_image_remove _si_container_remove

_si_image_remove:
	docker image rm -f \
		poc_service_info-fpm \
		poc_service_info-cli \
		poc_service_info-nginx

_si_container_remove:
	docker rm -f \
		poc_service_info_fpm \
		poc_service_info_cli \
		poc_service_info_nginx

# Services Compliance
sc-build:
	USER=$(UID) docker-compose -f ./services/compliance/docker-compose.yml build \
	  	fpm \
	  	cli \
	  	nginx

sc-serve:
	USER=$(UID) docker-compose \
		-f ./services/compliance/docker-compose.yml \
		--profile serve up -d --remove-orphans

sc-stop:
	USER=$(UID) docker-compose \
		-f ./services/compliance/docker-compose.yml \
		--profile serve stop

sc-down: sc-stop
	USER=$(UID) docker-compose \
		-f ./services/compliance/docker-compose.yml \
		down --remove-orphans

sc-cli:
	USER=$(UID) docker-compose \
		-f ./services/compliance/docker-compose.yml \
		run --rm -u $(UID) -w /src cli sh

sc-composer:
	docker run --init -it --rm -u $(UID) -v "$$(pwd)/services/compliance:/src" -w /src \
		composer:latest \
		composer install

sc-composer-up:
	docker run --init -it --rm -u $(UID) -v "$$(pwd)/services/compliance:/src" -w /src \
		composer:latest \
		composer update --no-cache

_sc-restart: _sc-restart-fpm _sc-restart-nginx

_sc-restart-fpm:
	USER=$(UID) docker-compose -f ./services/compliance/docker-compose.yml \
		--profile serve restart fpm

_sc-restart-nginx:
	USER=$(UID) docker-compose -f ./services/compliance/docker-compose.yml \
		--profile serve restart nginx

_sc-remove: _sc_image_remove _sc_container_remove

_sc_image_remove:
	docker image rm -f \
		poc_service_compliance-fpm \
		poc_service_compliance-cli \
		poc_service_compliance-nginx

_sc_container_remove:
	docker rm -f \
		poc_service_compliance_fpm \
		poc_service_compliance_cli \
		poc_service_compliance_nginx

# Dependencies

_network-create:
	docker network create poc-service

_network-remove:
	docker network rm -f poc-service

_image_remove:
	docker image rm -f poc_service-agw poc_service-proxy

_container_remove:
	docker rm -f poc_service_agw poc_service_proxy

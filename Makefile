USER = $$(id -u)

# Main

build: _network-create app-build si-build sc-build sa-build

rebuild: down _network-remove _image_remove _container_remove _si-remove _sc-remove _sa-remove build

service-rebuild: _si-remove _sc-remove _sa-remove si-build sc-build sa-build

remove: _image_remove _container_remove

serve: app-serve si-serve sc-serve sa-serve

restart: _app-restart-proxy _app-restart-agw _si-restart _sc-restart _sa-restart _app-restart-metrics

stop: si-stop sc-stop sa-stop app-stop

down: si-down sc-down sa-down app-down

# Application

app-build:
	USER=$(USER) docker-compose -f ./docker-compose.yml build \
 	  	agw \
		proxy \
		victoriametrics \
		victorialogs \
		fluentbit \
		vmagent \
		grafana

app-serve:
	USER=$(USER) docker-compose -f ./docker-compose.yml --profile serve up -d --remove-orphans

app-stop:
	USER=$(USER) docker-compose -f ./docker-compose.yml --profile serve stop

app-down: stop
	USER=$(USER) docker-compose -f ./docker-compose.yml down --remove-orphans

_app-restart-proxy:
	USER=$(USER) docker-compose -f ./docker-compose.yml --profile serve restart proxy

_app-restart-agw:
	USER=$(USER) docker-compose -f ./docker-compose.yml --profile serve restart agw

_app-restart-metrics:
	USER=$(USER) docker-compose -f ./docker-compose.yml --profile serve restart \
		victoriametrics \
		victorialogs \
		fluentbit \
		vmagent \
		grafana

# Services INFO
si-build:
	USER=$(USER) docker-compose -f ./services/info/docker-compose.yml build \
	  	fpm \
	  	cli \
	  	nginx

si-serve: si-composer
	USER=$(USER) docker-compose \
		-f ./services/info/docker-compose.yml \
		--profile serve up -d --remove-orphans

si-stop:
	USER=$(USER) docker-compose \
		-f ./services/info/docker-compose.yml \
		--profile serve stop

si-down: si-stop
	USER=$(USER) docker-compose \
		-f ./services/info/docker-compose.yml \
		down --remove-orphans

si-cli:
	USER=$(USER) docker-compose \
		-f ./services/info/docker-compose.yml \
		run --rm -u $(USER) -w /src cli sh

si-composer:
	docker run --init -it --rm -u $(USER) -v "$$(pwd)/services/info:/src" -w /src \
		composer:latest \
		composer install

si-composer-up:
	docker run --init -it --rm -u $(USER) -v "$$(pwd)/services/info:/src" -w /src \
		composer:latest \
		composer update --no-cache

_si-restart: _si-restart-fpm _si-restart-nginx

_si-restart-fpm:
	USER=$(USER) docker-compose -f ./services/info/docker-compose.yml \
		--profile serve restart fpm

_si-restart-nginx:
	USER=$(USER) docker-compose -f ./services/info/docker-compose.yml \
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
	USER=$(USER) docker-compose -f ./services/compliance/docker-compose.yml build \
	  	fpm \
	  	cli \
	  	nginx

sc-serve: sc-composer
	USER=$(USER) docker-compose \
		-f ./services/compliance/docker-compose.yml \
		--profile serve up -d --remove-orphans

sc-stop:
	USER=$(USER) docker-compose \
		-f ./services/compliance/docker-compose.yml \
		--profile serve stop

sc-down: sc-stop
	USER=$(USER) docker-compose \
		-f ./services/compliance/docker-compose.yml \
		down --remove-orphans

sc-cli:
	USER=$(USER) docker-compose \
		-f ./services/compliance/docker-compose.yml \
		run --rm -u $(USER) -w /src cli sh

sc-composer:
	docker run --init -it --rm -u $(USER) -v "$$(pwd)/services/compliance:/src" -w /src \
		composer:latest \
		composer install

sc-composer-up:
	docker run --init -it --rm -u $(USER) -v "$$(pwd)/services/compliance:/src" -w /src \
		composer:latest \
		composer update --no-cache

_sc-restart: _sc-restart-fpm _sc-restart-nginx

_sc-restart-fpm:
	USER=$(USER) docker-compose -f ./services/compliance/docker-compose.yml \
		--profile serve restart fpm

_sc-restart-nginx:
	USER=$(USER) docker-compose -f ./services/compliance/docker-compose.yml \
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

# Services Auth
sa-build:
	USER=$(USER) docker-compose -f ./services/auth/docker-compose.yml build \
	  	fpm \
	  	cli \
	  	nginx

sa-serve: sa-composer
	USER=$(USER) docker-compose \
		-f ./services/auth/docker-compose.yml \
		--profile serve up -d --remove-orphans

sa-stop:
	USER=$(USER) docker-compose \
		-f ./services/auth/docker-compose.yml \
		--profile serve stop

sa-down: sa-stop
	USER=$(USER) docker-compose \
		-f ./services/auth/docker-compose.yml \
		down --remove-orphans

sa-cli:
	USER=$(USER) docker-compose \
		-f ./services/auth/docker-compose.yml \
		run --rm -u $(USER) -w /src cli sh

sa-composer:
	docker run --init -it --rm -u $(USER) -v "$$(pwd)/services/auth:/src" -w /src \
		composer:latest \
		composer install

sa-composer-up:
	docker run --init -it --rm -u $(USER) -v "$$(pwd)/services/auth:/src" -w /src \
		composer:latest \
		composer update --no-cache

_sa-restart: _sa-restart-fpm _sa-restart-nginx

_sa-restart-fpm:
	USER=$(USER) docker-compose -f ./services/auth/docker-compose.yml \
		--profile serve restart fpm

_sa-restart-nginx:
	USER=$(USER) docker-compose -f ./services/auth/docker-compose.yml \
		--profile serve restart nginx

_sa-remove: _sa_image_remove _sa_container_remove

_sa_image_remove:
	docker image rm -f \
		poc_service_auth-fpm \
		poc_service_auth-cli \
		poc_service_auth-nginx

_sa_container_remove:
	docker rm -f \
		poc_service_auth_fpm \
		poc_service_auth_cli \
		poc_service_auth_nginx

# Dependencies

_network-create:
	docker network create poc-service

_network-remove:
	docker network rm -f poc-service

_image_remove:
	docker image rm -f poc_service-agw poc_service-proxy

_volume_remove:
	docker volume rm -f vmdata vldata vmagentdata grafanadata

_container_remove:
	docker rm -f poc_agw poc_proxy

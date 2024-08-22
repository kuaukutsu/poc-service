USER = $$(id -u)

app-build:
	USER=${USER} docker-compose -f ./docker-compose.yml build \
		cli \
	  	fpm \
	  	proxy \
	  	nginx \
	  	agw

serve:
	USER=${USER} docker-compose -f ./docker-compose.yml --profile serve up -d --remove-orphans

stop:
	docker-compose -f ./docker-compose.yml --profile serve stop

down: stop
	docker-compose -f ./docker-compose.yml down --remove-orphans

cli:
	docker-compose -f ./docker-compose.yml run --rm -u ${USER} -w /src \
		cli sh

composer:
	docker run --init -it --rm -u ${USER} -v "$$(pwd):/app" -w /app \
		composer:latest \
		composer install

composer-up:
	docker run --init -it --rm -u ${USER} -v "$$(pwd):/app" -w /app \
		composer:latest \
		composer update

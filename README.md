# Service topology [WIP]

API Gateway

`.docker/agw/krakend/conf/krakend.json`

### command

```shell
make build
```

```shell
make rebuild
```

```shell
make serve
```

```shell
make restart
```

```shell
make stop
```

```shell
make down
```

### examples

Merge

`GET /v1/info`

Client rate-limiting  
https://www.krakend.io/docs/endpoints/rate-limit/#client-rate-limiting-client_max_rate

`GET /v1/compliance`

# Service topology [WIP]

<img width="1204" alt="miro schema" src="https://github.com/user-attachments/assets/1ec6cf2b-70dd-4e48-b027-b5f103afbacf">

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

Authentication & Authorization

`GET /v1/compliance/protected` 401 Unauthorized

Login

`GET /v1/login` get **access_token**

`GET /v1/compliance/protected` Authorization Bearer **access_token**


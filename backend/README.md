# Backend

## TODOs

- finish system module
    - migrations 
    - seeds
    - use-cases
    - permissions
    - actions
    - errors
- finish user module
    - migrations 
    - seeds
    - use-cases
    - permissions
    - actions
    - errors
- hook up mail sender subsystem
- send out hardcoded email templates
- finish auth module
    - migrations 
    - seeds
    - use-cases
    - permissions
    - actions
    - errors
- auth middleware
- sliding token middleware

+ management api -> admin api rename (openapi generator)
- app api implementation
- admin api implementation
- server tests
- worker to send out emails
- web frontend


```sh
docker-compose up --build
docker-compose up --build web
docker build -t swift-docker-image . -f ./Dockerfile && docker run --rm swift-docker-image
```


```sh
curl --header "Content-Type: application/json" \
  --request POST \
  --data '{"title":"xyz"}' \
  http://localhost:8080/todos
```


```lua
work.method = "POST"
wrk.body = "foo.json"
wrk.headers["Content-Type"] = "application/json; charset=utf-8;"
```

```sh
wrk "http://localhost:8080/todos" -s ./test.lua --latency -t 8 -c 16 -d 10s
```

```sh
curl -i -X POST "http://localhost:8080/test" --data-raw "file.json"
```

```sh
curl -i -X POST \
-H "Content-Type: image/png" \
-H "File-Name: logo.png" \
-T ./logo.png \
http://localhost:8080/files
```

```sh
curl -OLJfs http://localhost:8080/files/logo.png
curl -LJfs http://localhost:8080/files/logo.png -o logo.png
```


```sh
curl -i -X 'POST' \
   'http://127.0.0.1:8080/api/v1/user/auth/login' \
   -H 'Accept: application/json' \ 
   -H 'Content-Type: application/json' \
   -d '{"email":"user@example.com","password":"user","isPersistent":true}'


curl -i -X 'GET' \
   'http://127.0.0.1:8080/api/v1/user/auth/me' \
   -H 'Accept: application/json' \
   -H 'Content-Type: application/json' \
   -H 'Cookie: session=aQhOaYxaEqPkf_-R13l2U1nRUkQJsga9Avd-RT8u3X4'

curl -i -X 'GET' \
   'http://127.0.0.1:8080/v1/management/user/accounts/me' \
   -H 'Accept: application/json' \
   -H 'Content-Type: application/json' \
   -H 'Authorization: Bearer oVjo8zmcj2GB-QCXOiiH2'
```

# GoMicroIM

based on:

- [kratos v2](https://github.com/go-kratos/kratos)
- [kratos-layout](https://github.com/go-kratos/kratos-layout)
- [kratos-cli](https://go-kratos.dev/docs/getting-started/usage)

## intro

api(BFF层):

- apiuser: user相关api接口

rpc(Service层):

- user: user相关rpc接口，对外只提供基础CRUD接口，无服务依赖

## API

### swagger ui

use kratos [swagger plugin](https://go-kratos.dev/docs/guide/openapi)

浏览器中访问服务的/api/swagger-ui/路径即可打开Swagger UI。如apiuser：

```shell
http://127.0.0.1:8000/api/swagger-ui/
```

### swagger.json

example user rpc:

```shell
$ protoc --proto_path=. \
        --proto_path=./third_party \
        --openapiv2_out . \
        --openapiv2_opt logtostderr=true \
        --openapiv2_opt json_names_for_fields=false \
        rpc/user/api/auth/auth.proto
```

## orm

### ent

example user rpc:

```shell
$ cd rpc/user/internal/data
$ ent generate ./schema --target=ent
```
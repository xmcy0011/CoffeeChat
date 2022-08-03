# GoMicroIM

## ent

example user rpc:
```shell
$ cd rpc/user/internal/data
$ ent generate ./schema --target=ent
```

## swagger.json

example user rpc:
```shell
$ protoc --proto_path=. \
        --proto_path=./third_party \
        --openapiv2_out . \
        --openapiv2_opt logtostderr=true \
        --openapiv2_opt json_names_for_fields=false \
        rpc/user/api/auth/auth.proto
```
# data

## ent

about ent, see: [https://entgo.io/docs/getting-started](https://entgo.io/docs/getting-started)

目录结构：
```text
├── ent     # ent 自动生成的代码
└── schema  # 模板文件，用来生成db curd 实际的go代码
```

ent根据 `schema` 生成curd代码：
```shell
$ cd rpc/message/internal/data
$ ent generate ./schema --target ent
```
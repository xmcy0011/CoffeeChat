<!-- TOC -->

- [install](#install)
    - [mysql](#mysql)
    - [redis](#redis)
    - [unable to deduce repository and source type for "google.golang.org/grpc"](#unable-to-deduce-repository-and-source-type-for-googlegolangorggrpc)
    - [](#)
    - [端口列表](#端口列表)

<!-- /TOC -->

# install

```bash
dep ensure -update
```

## mysql

1.本地用户访问

```sql
# 创建数据库coffeechat
create database coffeechat

# 创建cim用户，并授予cim对coffeechat操作的所有权限，localhost则代表这个用户只能在localhost进行登录
grant all on coffeechat.* to cim@localhost identified by '12345';

# 刷新系统权限表
flush privileges;
```

2.远程用户访问

```sql
# cim能够远程登录
GRANT ALL PRIVILEGES ON *.* TO 'cim'@'10.0.107.64' IDENTIFIED BY '12345' WITH GRANT OPTION;

# 给用户添加某个库的权限
grant all on coffeechat.* to cim;

# 刷新系统权限表
flush privileges;
```

3.如果需要删除用户

```sql
# 指定数据库
use mysql;

# 删除用户
delete from user where user='cim';

# 刷新系统权限表
flush privileges;
```

## redis

1. 更改配置

```bash
vim /etc/redis.conf

## 更改以下几项
daemonize yes           # 守护进程运行
requirepass coffeechat  # 访问密码
```

## unable to deduce repository and source type for "google.golang.org/grpc"

using proxy

```bash
env http_proxy=http://127.0.0.1:60339 https_proxy=http://127.0.0.1:60339 dep ensure -v
```

## 

## 端口列表

| 名称   | 分类 | 端口  | 备注                    |
| ------ | ---- | ----- | ----------------------- |
| gate   | 外部 | 8000  | TCP 端口                |
|        | 外部 | 8001  | WebSocket(ws) 端口      |
|        | 内部 | 7900  | 监听 logic 的 grpc 端口 |
| filegw | 外部 | 8500  | http 文件上传下载端口   |
|        | 内部 | 9000  | minio 对象存储服务端口  |
| logic  | 内部 | 10600 | grpc 接口               |
| http   | 外部 | 18080 | HTTP 接口               |

PS：

- 内部：不公开，服务端内部使用
- 外部：公开，客户端使用

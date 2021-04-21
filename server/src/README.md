# install

## 初始化

1. 安装依赖
~~dep ensure -update~~
```bash
go mod tidy
```

## 开发环境

**IDE强烈推荐跨平台的goland编辑器**
1. 从官网下载：https://www.jetbrains.com/go/
2. 安装，然后选择试用，自己搜索ide-eval-resetter-2.1.9补丁永久试用
3. 打开工程，选择/home/xmcy0011/repo/github/CoffeeChat/server/src
4. 打开app/im_gate/gate.go，此时报红，点击设置GOROOT
5. 在goland中设置go mod，settings->Go->Go Modules->打勾 Enable Go modules integration（地址可以使用https://goproxy.cn,direct）
6. 点击apply，对有些包报红的，鼠标悬停重新安装依赖。

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

for dep:
```bash
env http_proxy=http://127.0.0.1:60339 https_proxy=http://127.0.0.1:60339 dep ensure -v
```

for go mod:
```bash
export GO111MODULE=on
export GOPROXY=https://goproxy.io
go mod tidy
```


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

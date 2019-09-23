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

## unable to deduce repository and source type for "google.golang.org/grpc"

using proxy
```bash
env http_proxy=http://127.0.0.1:60339 https_proxy=http://127.0.0.1:60339 dep ensure
```
# CoffeeChat - Server

## 安装

### mysql

...

1. 增加权限
```sql
insert into mysql.user(Host,User,Password) values("localhost","cim",password("12345"));
grant all privileges on coffeechat.* to cim@127.0.0.1 identified by '12345';
flush privileges;
```

2. 增加2个内置用户
```sql
insert into coffeechat.im_user(user_id,user_nick_name,user_token,created) values(1008,'千夜小姐姐','12345',unix_timestamp(now()))
insert into coffeechat.im_user(user_id,user_nick_name,user_token,created) values(1009,'夏研小姐姐','12345',unix_timestamp(now()))
```

#### 支持 emoji 设置

参考https://blog.csdn.net/alinyua/article/details/79599540

1. 修改 mysql 配置文件

```bash
[client]
default-character-set = utf8mb4
[mysql]
default-character-set = utf8mb4
[mysqld]
character-set-client-handshake = FALSE
character-set-server = utf8mb4
collation-server = utf8mb4_unicode_ci
init_connect='SET NAMES utf8mb4'
```

2. 重启并检查变量

```bash
systemctl restart mariadb # 重启
mysql -uroot -p12345 # 进入mysql client

SHOW VARIABLES WHERE Variable_name LIKE 'character_set_%' OR Variable_name LIKE 'collation%';
```

其中以下需为 utf8mb4,其他没关系(不过实测只要 character_set_database 和 character_set_server 是 utf8mb4 即可正确存取)

| 系统变量                 | 描述                         |
| ------------------------ | ---------------------------- |
| character_set_client     | (客户端来源数据使用的字符集) |
| character_set_connection | (连接层字符集)               |
| character_set_database   | (当前选中数据库的默认字符集) |
| character_set_results    | (查询结果字符集)             |
| character_set_server     | (默认的内部操作字符集)       |

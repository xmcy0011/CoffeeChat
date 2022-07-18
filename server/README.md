<!-- TOC -->

- [CoffeeChat - Server](#coffeechat---server)
    - [Quick Start](#quick-start)
    - [编译](#编译)
        - [安装go](#安装go)
        - [go mod配置](#go-mod配置)
        - [git clone](#git-clone)
        - [build](#build)
    - [安装](#安装)
        - [etcd](#etcd)
        - [mysql](#mysql)
            - [支持 emoji 设置【可选】](#支持-emoji-设置可选)
        - [redis](#redis)
    - [运行](#运行)
    - [调试](#调试)
        - [goland](#goland)
        - [dlv](#dlv)
            - [生成core dump](#生成core-dump)

<!-- /TOC -->

# CoffeeChat - Server

## Quick Start

require: 
- docker desktop >= 4.0.1
- docker engine >= 20

使用docker compose（单机容器编排）可以一键启动Server，免去编译环境安装、程序编译、数据库初始化和环境等各种繁琐配置：

```bash
$ git clone https://github.com/xmcy0011/CoffeeChat.git
$ cd CoffeeChat/server

# 启动容器集群，所有服务的docke 镜像都是从代码编译而来，
# 改完代码，需要把compose容器删除，重新执行即可看到效果。
$ docker-compose.yml up -d
```

此时，在docker desktop中可以查看所有的日志：
![docker-desktop-log](../docs/images/docker-desktop-log.jpg)

当然，您也可以手动编译，具体步骤请参考下列章节。

## 编译

### 安装go

> 推荐安装go1.14（2020年），至少go1.11（2018年）

linux:

```bash
$ yum search golang 
$ yum install golang # 安装，截止到2020.08.17最新版1.13.14-1.el6
$ whereis golang     # 安装位置
golang: /usr/lib/golang /usr/lib64/golang

$ /usr/lib/golang/bin/go version # 查看go的版本
go version go1.13.14 linux/amd64

$ vim ~/.bash_profile            # 配置环境变量，加入以下2行
export PATH=$PATH:/usr/lib/go/bin
export GOPATH=/home/go

$ source ~/.bash_profile # 生效
$ go env                 # 确认goroot和gopath正确
```

mac:

```bash
$ brew isntall golang # 安装go
$ brew list golang    # 安装位置
$ vim ~/.bash_profile # 加入如下配置

export GOROOT=/usr/local/Cellar/go/1.12.5/libexec
export GOPATH="/Users/xmcy0011/repo/go" # 注意，这里很关键，是你存放代码的路径
export GOBIN=$GOROOT/bin
export PATH=$PATH:$GOBIN:$GOPATH/bin

$ source ~/.bash_profile # 生效
$ go env                 # 确认goroot和gopath正确
```

### go mod配置

目前go的包管理工具使用的go mod（之前使用go vendor），所以git clone的时候，代码 **不要** 放在 **GOPATH** 下。  

因为被墙的原因，有些包拉不下来，此时可以配置goproxy：

```bash
$ unset GOPROXY
$ go env -w GOPROXY=https://goproxy.cn,direct
```

PS: go mod至少需要**g1.11(2018.08.25)**以上，go1.13(2019.09.04)默认启用，目前go1.14(2020.02.26)都出来了！

>  https://studygolang.com/topics/10976
>
> Go 1.14 正式发布啦！
> 包含多项重大更新：
>
> Go Module 已经可用于生产环境
> 允许接口方法进行重叠
> 几乎零成本的 defer 语句
> 调度器支持非协作异步抢占
> 全新的页分配器实现
> 全新的计时器实现

### git clone

linux:

```bash
$ cd /home
$ git clone https://github.com/xmcy0011/CoffeeChat.git
```

mac:

```bash
$ cd ~ && mkdir -p repo/github # 创建github目录，注意不能是gopath目录
$ cd repo/github
$ git clone https://github.com/xmcy0011/CoffeeChat.git
```

### build

```bash
# 完整路径
# linux: /home/CoffeeChat/server/src
# mac: /Users/xmcy0011/repo/github/CoffeeChat/server/src

$ cd CoffeeChat/server/src 
$ chmod 777 build.sh
$ ./build.sh
$ ls # 生成 coffeechat.2020.04.14.tar.gz
```



## 安装

### etcd

see: [v3.5-quickstart](https://etcd.io/docs/v3.5/quickstart/)

```bash
$ chmod 777 /run/install_etcd.sh
$ /run/install_etcd.sh
```

### mysql

1. 安装mysql

   ```bash
   $ yum install mariadb       # 搜索mysql的mariadb分支
   $ systemctl enable mariadb  # 开机启动
   $ systemctl restart mariadb # 重启服务
   ```

   PS：注意，IM服务的logic模块里面logic-example.toml配置文件数据库端口是**13306**，请自己按需更改。

2. 增加权限

   ```bash
   $ mysql -uroot -p       # 使用mysqlclient
   $ insert into mysql.user(Host,User,Password) values("localhost","cim",password("12345")); # 增加cim用户
   $ grant all privileges on coffeechat.* to cim@127.0.0.1 identified by '12345'; # 授权，如果IM服务在其他机器，则增加IM服务器ip的授权即可
   $ flush privileges;    # 生效
   
   $ show databases;       # 【可选】显示所有数据库
   $ use mysql;            # 【可选】切换到mysql数据库
   $ select * from user;   # 【可选】查看所有授权
   ```

3. 初始化表

   ```bash
   $ mysql -u root -p # 登录
   $ show databases;  # 确认coffeechat数据库不存在，否执行：drop database coffeechat
   $ create database coffeechat; # 创建数据库
   $ use coffeechat;             # 切换
   
   # 创建表，参考完整路径如下：
   # linux: /home/CoffeeChat/server/setup
   # mac: /Users/xmcy0011/repo/github/CoffeeChat/server/setup
   $ source /home/CoffeeChat/server/setup/cim.sql
   
   # 目前send、recv、session和user用到了，群聊的未实现。
   $ show tables; 
   +----------------------+
   | Tables_in_coffeechat |
   +----------------------+
   | im_group             |
   | im_group_member      |
   | im_message_recv_0    |
   | im_message_recv_1    |
   | im_message_recv_2    |
   | im_message_recv_3    |
   | im_message_send_0    |
   | im_message_send_1    |
   | im_message_send_2    |
   | im_message_send_3    |
   | im_session           |
   | im_user              |
   +----------------------+
   12 rows in set (0.00 sec)
   ```

4. 导入数据

   ```bash
   # 插入2个用户，用以登录测试。
   # 注意：没有用户名而是使用用户ID（数字）代替，密码是12345
   $ INSERT INTO `im_user` (`id`, `user_id`, `user_nick_name`, `user_token`, `user_attach`, `created`, `updated`)
   VALUES
   	(1, 1008, '三生三世十里桃花', '12345', NULL, NULL, NULL),
   	(2, 1009, '夏研小姐姐', '12345', NULL, NULL, NULL);
   ```
#### 支持 emoji 设置【可选】

参考https://blog.csdn.net/alinyua/article/details/79599540

1. 修改 mysql 配置文件

```bash
$ vim /etc/my.cnf      # 一般在etc目录下，加入或确认以下配置项
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
$ systemctl restart mariadb # 重启
$ mysql -uroot -p12345 # 进入mysql client
$ SHOW VARIABLES WHERE Variable_name LIKE 'character_set_%' OR Variable_name LIKE 'collation%';
```

其中以下需为 utf8mb4,其他没关系(不过实测只要 character_set_database 和 character_set_server 是 utf8mb4 即可正确存取)

| 系统变量                 | 描述                         |
| ------------------------ | ---------------------------- |
| character_set_client     | (客户端来源数据使用的字符集) |
| character_set_connection | (连接层字符集)               |
| character_set_database   | (当前选中数据库的默认字符集) |
| character_set_results    | (查询结果字符集)             |
| character_set_server     | (默认的内部操作字符集)       |

### redis

```bash
$ yum install redis   # 安装
$ vim /etc/redis.conf # 设置密码
bind 0.0.0.0
port 16379
requirepass coffeechat
daemonize yes
$ systemctl enable redis  # 开机启动
$ systemctl restart redis # 启动服务
```

## 运行

```bash
$ cd / && mkdir data && cd data    # 创建一个data目录存放运行程序
$ cp /home/CoffeeChat/server/src/coffeechat.2020.04.14.tar.gz .
$ tar -czvf coffeechat.2020.04.14.tar.gz # 解压
$ cd coffeechat
$ chmod 777 *.sh
$ ./restart.sh im_logic # 启动业务服务
$ ./restart.sh im_gate  # 启动网关服务
$ ./restart.sh im_http  # 启动http服务
$ ps aux|grep im 		    # 查看是否启动成功
```

查看log：
```bash
tail -f im_logic/log/log.log
tail -f im_gate/log/log.log
tail -f im_http/log/log.log
```


## 调试

### goland

进入 **app/im_gate/main.go** 以调试模式运行即可。

### dlv

#### 生成core dump

1. 创建coredump.sh
```bash
#!/bin/bash

# Filename: coredumpshell.sh
# Description: enable coredump and format the name of core file on centos system

# enable coredump whith unlimited file-size for all users
echo -e "\n# enable coredump whith unlimited file-size for all users\n* soft core unlimited" >> /etc/security/limits.conf

# set the path of core file with permission 777
cd /data && mkdir imcorefile && chmod 777 imcorefile

# format the name of core file.   
# %% – 符号%
# %p – 进程号
# %u – 进程用户id
# %g – 进程用户组id
# %s – 生成core文件时收到的信号
# %t – 生成core文件的时间戳(seconds since 0:00h, 1 Jan 1970)
# %h – 主机名
# %e – 程序文件名    
# for centos7 system(update 2017.4.2 21:44)
echo -e "\nkernel.core_pattern=/data/imcorefile/core-%e-%s-%u-%g-%p-%t" >> /etc/sysctl.conf
echo -e "\nkernel.core_uses_pid = 1" >> /etc/sysctl.conf

sysctl -p /etc/sysctl.conf
```

2. 启用core dump功能
```bash
chmod 777 coredump.sh

./coredump.sh
```

3.重新打开终端后执行 **ulimit -a**
```bash
[root@10-0-59-231 robot_server]# ulimit -a
core file size          (blocks, -c) unlimited
data seg size           (kbytes, -d) unlimited
scheduling priority             (-e) 0
file size               (blocks, -f) unlimited
pending signals                 (-i) 63466
max locked memory       (kbytes, -l) 64
max memory size         (kbytes, -m) unlimited
open files                      (-n) 102400
pipe size            (512 bytes, -p) 8
POSIX message queues     (bytes, -q) 819200
real-time priority              (-r) 0
stack size              (kbytes, -s) 8192
cpu time               (seconds, -t) unlimited
max user processes              (-u) 63466
virtual memory          (kbytes, -v) unlimited
file locks                      (-x) unlimited
```

4. 验证
```bash
vim test.c  // 输入如下内容
```
```c++
#include <stdio.h>
int main( int argc, char * argv[] ) { char a[1]; scanf( "%s", a ); return 0; }
```
```bash
gcc test.c -o test  # 编译
./test              # 执行test，然后任意输入一串字符后按回车，如zhaogang.com
ls /tmp/corefile   # 在此目录下如果生成了相应的core文件core-test-*，代表成功

[root@10-0-59-231 imcorefile]# ls
core-robot_server-6-0-0-32402-1587555657
```

5.关闭core dump(不需要的时候执行
```bash
ulimit -c # 查看core dump状态，0代表关闭，unlimited代表打开
vim /etc/profile # 加入如下一句话
```

```text
# No core files by default
ulimit -S -c 0 > /dev/null 2>&1 
```

```bash
#重新打开终端
ulimit -c  # 如果输出0，代表关闭成功
# 如果要启用，把上面那句话注释ulimit -S -c 0, 重新打开终端即可
```
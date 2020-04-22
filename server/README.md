[TOC]

# CoffeeChat - Server

## 编译

1.go环境
```bash
brew isntall golang # 安装go
vim ~/.bash_profile # 加入如下配置

export GOROOT=/usr/local/Cellar/go/1.12.5/libexec
export GOPATH="/Users/xuyc/repo/go" # 注意，这里很关键，是你存放代码的路径
export GOBIN=$GOROOT/bin
export PATH=$PATH:$GOBIN:$GOROOT/bin

source ~/.bash_profile # 生效
go env # 确认goroot和gopath正确
```

2.git clone
```bash
cd /Users/xuyc/repo/go #注意gopath一定要和上面环境变量对应
mkdir -p src/github.com
cd src/github.com
git clone https://github.com/xmcy0011/CoffeeChat.git
```

3.build
```bash
# 完整路径/data/go/src/github.com/CoffeeChat/server/src
cd CoffeeChat/server/src 
chmod 777 build.sh
./build.sh
ls # 生成 coffeechat.2020.04.14.tar.gz
```

## 安装

### mysql

1. 增加权限
```sql
insert into mysql.user(Host,User,Password) values("localhost","cim",password("12345"));
grant all privileges on coffeechat.* to cim@127.0.0.1 identified by '12345';
flush privileges;
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

## 运行

```bash
tar -czvf coffeechat.2020.04.14.tar.gz # 解压
cd coffeechat
chmod 777 *.sh
./restart.sh im_gate  # 启动网关服务
./restart.sh im_logic # 启动业务服务
./restart.sh im_http  # 启动http服务
```

查看log：
```bash
tail -f im_gate/log/log.log
tail -f im_logic/log/log.log
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
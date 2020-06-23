<!-- TOC -->

- [install](#install)
    - [mysql](#mysql)
    - [redis](#redis)
    - [unable to deduce repository and source type for "google.golang.org/grpc"](#unable-to-deduce-repository-and-source-type-for-googlegolangorggrpc)
    - [rocketmq](#rocketmq)
        - [java8](#java8)
        - [maven](#maven)
        - [NTP校时](#ntp校时)
        - [rocketmq](#rocketmq-1)
        - [RocketMQ-Console](#rocketmq-console)
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

## rocketmq
### java8
1. 下载
```bash
$ 下载：https://www.oracle.com/java/technologies/javase/javase8u211-later-archive-downloads.html
$ mkdir -p /usr/local/java
$ tar -zxvf jdk-8u241-linux-x64.tar.gz -C /usr/local/java/ # 解压
```

2. 环境变量
```bash
$vim ~/.bash_profile

# 加入到末尾
export JAVA_HOME=/usr/local/java/jdk1.8.0_141
export JRE_HOME=${JAVA_HOME}/jre
export CLASSPATH=.:${JAVA_HOME}/lib:${JRE_HOME}/lib
export PATH=${JAVA_HOME}/bin:$PATH

$ source ~/.bash_profile
$ java -verison
```

### maven
参考 [链接](https://www.cnblogs.com/116970u/p/11211963.html)

1. 下载
```bash
$ wget https://mirror.bit.edu.cn/apache/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz
```

2. 安装
```bash
$ mkdir -p /usr/local/maven
$ tar -zxvf apache-maven-3.6.3-bin.tar.gz -C /usr/local/maven
$ vim ~/.bash_profile
# 加入
MAVEN_HOME=/usr/local/maven/apache-maven-3.6.1
export PATH=${MAVEN_HOME}/bin:${PATH}

$ source ~/.bash_profile
$ mvn -v
```

### NTP校时
如果是生产环境，建议使用NTP服务器+客户端模式（一台专用NTP服务器，所有服务器作为客户端向该机器同步时间，该机器从互联网同步时间），而不是所有机器都从互联网上同步最新时间。  

考虑到有些机器时间不准，建议安装RocketMQ的机器安装NTP校时服务，否则日志时间可能不准确：
```bash
$ yum install -y ntp
$ systemctl enable ntpd # 开机自启动
$ systemctl start ntpd # 启动
```

```bash
$ date
2020年 06月 03日 星期三 06:38:23 CST

# 启用之后
$ date
2020年 06月 16日 星期二 10:35:05 CST
```

### rocketmq
1. 编译，参考 [链接](https://rocketmq-1.gitbook.io/rocketmq-connector/quick-start/qian-qi-zhun-bei/dan-ji-huan-jing)
```bash
$ git clone https://github.com/apache/rocketmq.git
$ cd rocketmq

# maven打包编译
$ mvn -Prelease-all -DskipTests clean install -U 

# 这里的4.5.x是版本号，可能不同，请注意自己的版本
$ cd distribution/target/rocketmq-4.7.1-SNAPSHOT/

# 放到data目录
$ mv rocketmq-4.7.1-SNAPSHOT /data 
$ cd /data/rocketmq-4.7.1-SNAPSHOT
```

2. conf/broker.conf
```bash
$ mkdir store
$ vim broker.conf
# 加入以下配置

# namesrv地址，分号分隔
namesrvAddr=127.0.0.1:9876
# 存储路径根目录
storePathRootDir=./store
# commitlog存储路径
storePathCommitLog=./store/commitlog
# 消费队列存储路径
storePathConsumeQueue=./store/consumequeue
# 消费索引存储路径
storePathindex=/Users./store/index
# checkpoint文件存储路径
storeCheckpoint=./store/checkpoint
# abort文件存储路径
abortFile=./store/abort
```

3. 调整默认内存，[问题在这里](https://www.cnblogs.com/williamjie/p/9377163.html)
```bash
$ vim bin/runbroker.sh
# 替换
#-Xms8g -Xmx8g -Xmn4g # 默认需要内存空间
-Xms256m -Xmx256m -Xmn125m

#MaxDirectMemorySize=15g
MaxDirectMemorySize=600m

$ vim bin/run
# -Xms4g -Xmx4g -Xmn2g
-Xms256m -Xmx256m -Xmn125m
```

4. 启动namesrv（前台启动）
```bash
sh bin/mqnamesrv
```

5. 启动broker（前台启动）
```bash
sh bin/mqbroker
```

6. restart.sh
```bash
#!/bin/sh

echo 'start namesrv'
nohup sh bin/mqnamesrv > namqsrv.out &

sleep 2
echo 'start broker'
nohup sh bin/mqbroker -n localhost:9876 > broker.out &

sleep 2
echo 'start rocketmq-console-ng'
nohup java -jar rocketmq-console-ng-1.0.0.jar --rocketmq.config.namesrvAddr='10.0.107.218:9876' > console.out &
echo $! > ./console.pid
```

7. stop.sh
```bash
#!/bin/sh

bin/mqshutdown namesrv
bin/mqshutdown broker

# console
PID=$(cat ./console.pid)
kill -9 $PID
```

### RocketMQ-Console
请参考：[RocketMQ-Console安装](https://my.oschina.net/buru1kan/blog/1814356)

```bash
$ git clone -b release-rocketmq-console-1.0.0 https://github.com/apache/rocketmq-externals.git
$ cd rocketmq-externals/rocketmq-console/
$ vi src/main/resources/application.properties

# 更改以下配置项
server.contextPath=/rocketmq

$ mvn clean package -Dmaven.test.skip=true # 打包
$ java -jar target/rocketmq-console-ng-1.0.0.jar --rocketmq.config.namesrvAddr='10.0.74.198:9876;10.0.74.199:9876'
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

# k8s部署Mysql

## 创建资源对象

下面的步骤，来自于k8s官网：参考: [运行一个单实例有状态应用](https://kubernetes.io/zh-cn/docs/tasks/run-application/run-single-instance-stateful-application/#deploy-mysql)，如需了解详情，请移步。

### 创建文件 mysql-deployment.yml

该资源文件声明了 Service 和 Deployment 资源对象，Service的Type为NodePort类型，以方便从公网直接访问mysql。

```yaml
apiVersion: v1
kind: Service
metadata:
  name: mysql
spec:
  selector:
    app: mysql
  type: NodePort
  ports:
    - port: 3306
      nodePort: 30306
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mysql
spec:
  # pod数量
  replicas: 1
  selector:
    matchLabels:
      app: mysql
  template:
    metadata:
      labels:
        app: mysql
    spec:
      containers:
        - name: mysql
          image: mysql:5.7
          imagePullPolicy: IfNotPresent
          resources:
            limits:
              memory: "500Mi"
              cpu: "500m"
          # 这些环境变量5.7下都没生效？
          # env:
          # - name: MYSQL_ROOT_PASSWORD
          #   value: "123456"
          # - name: MYSQL_ROOT_HOST
          #   value: '%'
          # - name: LANG
          #   value: C.UTF-8 # 解决客户端连接中文乱码问题
          # - name: MYSQL_DATABASE
          #   value: coffeechat
          # - name: MYSQL_USER
          #   value: cim
          # - name: MYSQL_PASSWORD
          #   value: coffeechat2022
          ports:
            - containerPort: 3306
              name: mysql
          volumeMounts:
            - name: mysql-persistent-storage
              mountPath: /var/lib/mysql
      volumes:
        - name: mysql-persistent-storage
          persistentVolumeClaim:
            claimName: mysql-pv-claim
```

### 创建 mysql-pv.yaml 文件

为了使mysql数据持久化存储在宿主机磁盘中，需要创建pv和pvc资源对象（否则mysql pod删除后，数据也随之删除了）。PS：请确保hostPat.path路径正确。

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: mysql-pv-volume
  labels:
    type: local
spec:
  storageClassName: manual
  capacity:
    storage: 10Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    # 请确保data目录在宿主机存在
    path: "/data/mysql"
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mysql-pv-claim
spec:
  storageClassName: manual
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
```

### 部署 YAML 文件中定义的 PV 和 PVC

```bash
kubectl apply -f mysql-pv.yaml
```

### 部署 YAML 文件中定义的 Deployment

```bash
kubectl apply -f mysql-deployment.yaml
```

### 查看 Deployment 相关信息 和 查看 PersistentVolumeClaim

```bash
kubectl describe deployment mysql
kubectl describe pvc mysql-pv-claim
```

### 列举出 Deployment 创建的 pods

```bash
kubectl get pods -l app=mysql
```

输出：

```shell
NAME READY STATUS RESTARTS AGE
mysql-63082529-2z3ki 1/1 Running 0 3m
```

### 查看Service的信息

```shell
kubectl get svc
```

输出：

```shell
NAME TYPE CLUSTER-IP EXTERNAL-IP PORT(S)          AGE
kubernetes ClusterIP 10.96.0.1       <none>        443/TCP 74d
mysql NodePort 10.99.171.242   <none>        3306:30672/TCP 17h
```

确定Type为NodePort类型，外部Port是30672。那么此时从：公网mysql地址 = Node公网IP + 30672

### 查看k8s dashboard，输出mysql的容器组

在k8s dashboard中，看到多出一个mysql容器组

### 诊断MySQL

根据上面的步骤实施时，步骤6：列举出 Deployment 创建的 pods，可能会遇到Status不是Running的问题，说明mysql没有正常启动。此时可以查看mysql的日志排查问题。

查看mysql pod的日志输出：

```shell
kubectl logs mysql-63082529-2z3ki
```

或者：

```shell
kubectl logs -f mysql-63082529-2z3ki
```

## Mysql公网IP和端口如何计算？

步骤7中说了计算公式，但是如果k8s集群有多台机器(Node)，我要怎么确定这个 “Node公网IP” 到底是哪个机器？

通过这个命令找到 pod 所在node节点：

```shell
kubectl get pods -o wide
```

输出：

```shell
NAME READY STATUS RESTARTS AGE IP NODE NOMINATED NODE READINESS GATES
mysql-6974c66cdb-88f4m 1/1 Running 0 17h 10.244.0.9 master01   <none>           <none>
nginx-app 1/1 Running 0 74d 10.244.1.2 node01     <none>           <none>
```

我们看到，mysql被部署在master01的Node上，那 **最终公网IP**=master01公网IP + 30672

## k8s中连接Mysql和MySQL授权

此时，可以使用客户端连接下k8s中的mysql，测试下网络释放畅通，如下：

如果我们直接在k8s宿主机连接mysql server，也会提示这个问题：

```shell
$ mysql -u root -h 10.99.171.242 -P 3306
ERROR 1130 (HY000): Host '10.244.0.1' is not allowed to connect to this MySQL server
PS：10.99.171.242 是service的ip（kubectl get svc）
```

如果按照 运行一个单实例有状态应用 所说（此命令在集群内创建一个新的 Pod 并运行 MySQL 客户端，并通过 Service 连接到服务器。 如果连接成功，你就知道有状态的 MySQL 数据库正处于运行状态。）：

```shell
kubectl run -it --rm --image=mysql:5.7 --restart=Never mysql-client -- mysql -h mysql -uroot -ppassword
```

* -it：参考docker中的it，交互模式运行
* --rm：参考docker中的rm，pod停止后，自动删除本地容器
* --image：镜像，注意和mysql-deployment.yml中的版本一致，避免额外的镜像拉取。
* —restart：重启策略。
* mysql-client：搭配-it使用，指定容器运行后启动的进程，可以更换为 /bin/sh ，然后自己再手动执行 mysql-client 效果是一样的。
* -h：mysql客户端通过该参数指定ip地址。这里可以直接使用service名字，通过dns解析来连接。
* -p：密码
* -u：用户名

在公网环境下，因为hosts文件中配置的是公网IP，故会报 could not find the …的错误：

```shell
If you don't see a command prompt, try pressing enter.
Error attaching, falling back to logs: unable to upgrade connection: pod does not exist
pod "mysql-client" deleted
Error from server (NotFound): the server could not find the requested resource ( pods/log mysql-client)
```

hosts配置示例：

```shell
101.34.xxx.xx master01
81.xxx.xx.69 node01
81.xx.xx.49 node02
```


### 解决方案

mysql-deployment.yml增加：
```shell
...
env:

- name: MYSQL_ROOT_HOST
  value: "%"
```

重新创建后，通过kube exec进入pod容器：
```shell
$ kubectl exec -it mysql-59449cf565-st5rp /bin/sh
```

输出：

```shell
kubectl exec [POD] [COMMAND] is DEPRECATED and will be removed in a future version. Use kubectl exec [POD] -- [COMMAND]
instead.
sh-4.2# mysql -uroot
Welcome to the MySQL monitor. Commands end with ; or \g.
Your MySQL connection id is 9
Server version: 5.7.38 MySQL Community Server (GPL)

Copyright (c) 2000, 2022, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql>
```

授权：

```shell
CREATE USER 'root'@'%' IDENTIFIED BY 'coffeechat2022';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%';
FLUSH PRIVILEGES;
```

使用任意客户端连接即可！

## 删除mysql

有2种方式。

### 手动删除

* 删除名称为 mysql 的deployment 和 service（svc简写）资源对象

```shell
kubectl delete deployment,svc mysql
```

* 删除pv和pvc资源。此时，mysql的数据将从资盘中删除

```shell
  kubectl delete pvc mysql-pv-claim
  kubectl delete pv mysql-pv-volume
```

### 通过yml文件删除（建议）

相比手动删除，更建议通过yml文件来删除，特别是在早期mysql可能没有成功启动的时候，不容易出错。

```shell
kubectl delete -f mysql-deployment.yml
kubectl delete -f mysql-pv.yml
```

参考：

* [运行一个单实例有状态应用](https://kubernetes.io/zh-cn/docs/tasks/run-application/run-single-instance-stateful-application/#deploy-mysql)
* [k8s部署mysql](https://blog.csdn.net/qq_33036061/article/details/123501164)
* [mysql有状态服务部署](https://www.ucloud.cn/yun/32606.html)
* [k8s 提示Error from server (NotFound): the server could not find the requested resource ( pods/log](https://blog.csdn.net/u012972390/article/details/112853747)
* [Kubernetes: Host 'x.x.x.x' is not allowed to connect to this MySQL](https://stackoverflow.com/questions/56123011/kubernetes-host-x-x-x-x-is-not-allowed-to-connect-to-this-mysql)

# install

## minio对象存储服务

refer:  
https://www.jianshu.com/p/1c768a7802d1  
https://docs.min.io/cn/golang-client-quickstart-guide.html
https://docs.min.io/cn/minio-client-quickstart-guide.html

1.安装运行
```bash
# 下载
cd /data
mkdir minio && cd minio
wget https://dl.minio.io/server/minio/release/linux-amd64/minio

# 安装
chmod +x minio

# 启动，存储目录/data/minio/data
mk data
./minio server /data/minio/data #前台运行的，后面增加守护进程运行的readme
```

**输出以下信息代表成功:**

```bash
Endpoint:  http://10.0.59.231:9000  http://172.17.0.1:9000  http://127.0.0.1:9000
AccessKey: minioadmin
SecretKey: minioadmin

Browser Access:
   http://10.0.59.231:9000  http://172.17.0.1:9000  http://127.0.0.1:9000

Command-line Access: https://docs.min.io/docs/minio-client-quickstart-guide
   $ mc config host add myminio http://10.0.59.231:9000 minioadmin minioadmin

Object API (Amazon S3 compatible):
   Go:         https://docs.min.io/docs/golang-client-quickstart-guide
   Java:       https://docs.min.io/docs/java-client-quickstart-guide
   Python:     https://docs.min.io/docs/python-client-quickstart-guide
   JavaScript: https://docs.min.io/docs/javascript-client-quickstart-guide
   .NET:       https://docs.min.io/docs/dotnet-client-quickstart-guide
Detected default credentials 'minioadmin:minioadmin', please change the credentials immediately using 'MINIO_ACCESS_KEY' and 'MINIO_SECRET_KEY'
```

2.使用
```bash
# 浏览器打开
http://10.0.59.231:9000
# 输入minioadmin minioadmin，即可查看已有的文件
```

3.mc[可选]，暂时用不到，备忘
```text
# 更多参考：https://docs.min.io/cn/minio-client-quickstart-guide.html
cd /data/minio
wget https://dl.min.io/client/mc/release/linux-amd64/mc
chmod +x mc
./mc --help

# 查看文件
mc ls
```

## im_file

to do ...
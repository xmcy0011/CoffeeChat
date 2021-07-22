# 编译pb

## install

> 注意：CoffeeChat-Desktop 项目依赖的protobuf库版本要和这里的protoc版本一致，否则会导致编译错误，需要使用 CoffeeChat-Desktop 依赖的protoc 重新生成对应的pb文件。

### mac

1. protobuf3
```bash
$ brew install protobuf      # 安装protobuf
$ brew info protobuf         # 查看版本
$ vim ~/.bash_profile        # 加入protobuf的路径，上面info看到路径后面加/bin即可
export PATH=$PATH:/usr/local/Cellar/protobuf/3.14.0/bin

$ source ~/.bash_profile     # 编译
$ protoc --version           # protoc的版本
libprotoc 3.14.0
```

2. [go插件（编译protoc-gen-go）](https://www.jianshu.com/p/2bfc4edca326)
```bash 
# 先安装proto（用代理你懂的，否则就手动git clone吧：https://github.com/golang/protobuf）
$ env http_proxy=http://127.0.0.1:60339 https_proxy=http://127.0.0.1:60339 go get -v -u github.com/golang/protobuf/proto
# 再安装插件（依赖上面的包）
$ env http_proxy=http://127.0.0.1:60339 https_proxy=http://127.0.0.1:60339 go get -v -u github.com/golang/protobuf/protoc-gen-go
$ cd $GOPATH/src    # /Users/xmcy0011/go/src
$ cd github.com/golang/protobuf/protoc-gen-go/ 
$ ls
descriptor    generator     grpc          main.go       plugin
$ go build                                               # 编译protoc-gen-go
$ cp protoc-gen-go /usr/local/Cellar/protobuf/3.13.0/bin # 拷贝到上面protobuf配置的路径下去
$ protoc --go_out=. test.proto                           # 测试
```

3. [dart插件（protoc-gen-dart）](https://www.jianshu.com/p/aeae1274572b?from=groupmessage&isappinstalled=0)
```bash
$ brew tap dart-lang/dart  # 安装dart
$ brew install dart        # 安装好之后，就有pub命令了
$ pub global activate protoc_plugin # 安装 protoc-gen-dart插件
$ vim ~/.bash_profile      # 加入到PATH
export PATH=$PATH:$PWD/.pub-cache/bin
$ source ~/.bash_profile
$ protoc --dart_out=. test.proto # 测试
```
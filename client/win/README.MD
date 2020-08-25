# win

## 技术架构
1. 界面使用网易开源的duilib实现：[https://github.com/netease-im/NIM_Duilib_Framework](https://github.com/netease-im/NIM_Duilib_Framework)
2. 网络使用asio跨平台c++库
3. 协议使用protobuf3
4. 日志使用spdlog高性能跨平台组件：[https://github.com/gabime/spdlog](https://github.com/gabime/spdlog)

## 开发环境

1. 安装VS2017
2. 安装vcpkg
   ```bash
   $ git clone https://github.com/Microsoft/vcpkg.git
   $ cd vcpkg
   $ bootstrap-vcpkg.bat
   $ vcpkg integrate install
   ```
3. 安装asio网络库（非boost版）
   ```bash
   $ vcpkg install asio # 安装
   ```
4. 安装protobuf
   ```bash
   # 目前生成c++ pb的protoc版本为3.12.3，vcpkg不一定是这个版本，
   # 可以去github上下载成品的protoc的exe。
   $ vcpkg install protobuf 
   ```

## 编译

使用VS 2017打开all.sln，切换到release，然后编译即可。


## 源码请移步

See [CoffeeChat-Win](https://github.com/xmcy0011/CoffeeChat-Win)
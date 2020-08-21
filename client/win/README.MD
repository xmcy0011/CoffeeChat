# win

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

## 编译

使用VS 2017打开all.sln，切换到release，然后编译即可。
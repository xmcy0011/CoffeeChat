# Golang性能分析

参考：
https://www.cnblogs.com/yjf512/archive/2012/12/27/2835331.html  
golang cpu性能图形分析工具：https://blog.csdn.net/Vivid_110/article/details/100561459  
使用pprof分析cpu占用过高问题：https://studygolang.com/articles/21841?fr=sidebar
使用go tool pprof分析内存泄漏、CPU消耗：https://www.cnblogs.com/ghj1976/p/5473693.html

## CPU

### 生成profile文件

go中有pprof包来做代码的性能监控：
- net/http/pprof
- runtime/pprof

其实net/http/pprof中只是使用runtime/pprof包来进行封装了一下，并在http端口上暴露出来。对于非Web类应用，使用runtime/pprof包。

关键代码：  
```go
f, err := os.OpenFile("cpu.prof", os.O_RDWR|os.O_CREATE, 0644)
if err != nil {
    fmt.Fatal(err)
    return
}
pprof.StartCPUProfile(f)

// 退出时调用
f.Close()
pprof.StopCPUProfile()
```


完整代码如下：
```go
import "runtime/pprof"

var f *os.File

// 优雅退出
func waitExit(c chan os.Signal) {
    for i := range c {
        switch i {
        case syscall.SIGHUP, syscall.SIGINT, syscall.SIGTERM, syscall.SIGQUIT:
            logger.Sugar.Info("receive exit signal ", i.String(), ",exit...")

            // CPU 性能分析
            f.Close()
            pprof.StopCPUProfile()

            os.Exit(0)
        }
    }
}

func main(){
    //CPU 性能分析
    f, err := os.OpenFile("cpu.prof", os.O_RDWR|os.O_CREATE, 0644)
    if err != nil {
        logger.Sugar.Fatal(err)
        return
    }
    pprof.StartCPUProfile(f)

    // to do
    // your code

    // before exit, cleanup something ...
    c := make(chan os.Signal)
    signal.Notify(c, syscall.SIGHUP, syscall.SIGINT, syscall.SIGTERM,   syscall.SIGQUIT)
    waitExit(c)
}
```

按住Ctrl+C(linux/mac)后，在同目录下应该生成了cpu.prof的文件。

```bash
meki-mac-pro:im_gate xmcy0011$ ls
cpu.prof          gate.go           log
gate-example.toml im_gate           server.pid
```

### 使用pprof工具分析

go自带了pprof工具，使用如下命令查看：
```bash
go tool pprof im_gate cpu.prof # im_gate 是程序名字
```

然后输入**top**命令（**help**命令查看更多功能），查看前CPU占用率TOP10，如下：
```bash
meki-mac-pro:im_gate xmcy0011$ go tool pprof im_gate cpu.prof
File: im_gate
Type: cpu
Time: Jan 11, 2020 at 6:58pm (CST)
Duration: 4.66s, Total samples = 4.26s (91.38%)
Entering interactive mode (type "help" for commands, "o" for options)

(pprof) top # 这里是输入的top命令
Showing nodes accounting for 4250ms, 99.77% of 4260ms total
Dropped 5 nodes (cum <= 21.30ms)
      flat  flat%   sum%        cum   cum%
    1520ms 35.68% 35.68%     1520ms 35.68%  runtime.chanrecv
    1470ms 34.51% 70.19%     4030ms 94.60%  github.com/CoffeeChat/server/src/internal/gate/tcpserver.init.0.func1
    1040ms 24.41% 94.60%     2560ms 60.09%  runtime.selectnbrecv
     220ms  5.16% 99.77%      220ms  5.16%  runtime.nanotime
         0     0% 99.77%      220ms  5.16%  runtime.mstart
         0     0% 99.77%      220ms  5.16%  runtime.mstart1
         0     0% 99.77%      220ms  5.16%  runtime.sysmon
(pprof)
```

当然也可以使用**png**命令生成图片，使用前需安装graphviz：
```bash
brew install graphviz # mac 安装 graphviz
```

输出：
```bash
(pprof)
(pprof) png  # 这里 在pprof命令行中输入的web命令
(pprof) exit
meki-mac-pro:im_gate xmcy0011$ ls
cpu.prof          gate.go           log               server.pid
gate-example.toml im_gate           profile001.png
```

效果如下：
![profile](https://raw.githubusercontent.com/xmcy0011/CoffeeChat/master/images/profile/profile001.png)

一目了然找到了CPU空转的地方：
> github.com/CoffeeChat/server/src/internal/gate/tcpserver.init.0.func1
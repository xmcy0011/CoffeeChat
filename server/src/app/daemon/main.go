package main

import (
	"flag"
	"fmt"
	"os/exec"
	"path/filepath"
	"time"
)

var appPath string

func main() {
	flag.Parse()

	args := make([]string, 0)
	for i := range flag.Args() {
		if i == 0 {
			appPath = flag.Arg(i)
		} else {
			args = append(args, flag.Arg(i))
		}
	}

	//fmt.Println(flag.Args())
	if appPath == "" {
		fmt.Println("Usage:./daemon [appPath] [args]")
		return
	}

	fullPath, _ := filepath.Abs(appPath)
	cmd := exec.Command(fullPath, args...)
	// 启用go core dump功能，进程崩溃后会生成core文件，便于问题排查
	// 使用dlv查看，gdb看不到go文件内的内容，不是很方便
	cmd.Env = append(cmd.Env,"GOTRACEBACK=crash")
	err := cmd.Start()
	time.Sleep(time.Second)
	if err != nil {
		fmt.Printf("daemon error:%s \n", err.Error())
	} else {
		fmt.Println("daemon success")
	}
}

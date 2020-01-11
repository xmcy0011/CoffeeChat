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
	err := cmd.Start()
	time.Sleep(time.Second)
	if err != nil {
		fmt.Printf("daemon error:%s \n", err.Error())
	} else {
		fmt.Println("daemon success")
	}
}

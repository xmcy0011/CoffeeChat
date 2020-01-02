package helper

import (
	"os"
	"strconv"
)

func IsExist(fileName string) bool {
	_, err := os.Stat(fileName)
	return err == nil || os.IsExist(err)
}

func WritePid(pidFileName string) error {
	// 记录进程id
	var pid = os.Getpid()
	var err error

	//const pidFile = "server.pid"
	var fileHandle *os.File
	if !IsExist(pidFileName) {
		fileHandle, err = os.Create(pidFileName)
	} else {
		fileHandle, err = os.OpenFile(pidFileName, os.O_RDWR, os.ModePerm)
	}

	if err != nil {
		return err
	}

	_, err = fileHandle.Write([]byte(strconv.Itoa(pid)))
	if err != nil {
		return err
	}

	err = fileHandle.Close()
	if err != nil {
		return err
	}
	return nil
}

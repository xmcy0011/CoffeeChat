package main

import (
	"encoding/json"
	"github.com/CoffeeChat/server/src/pkg/logger"
	uuid "github.com/satori/go.uuid"
	"math/rand"
	"net/http"
	"strconv"
	"strings"
	"time"
)

type HttpResCode int

const (
	HttpResCodeSuccess HttpResCode = 0
	HttpResCodeError   HttpResCode = 2000
	HttpResCodeUnknown HttpResCode = 2001

	MaxFileSize = 4 * 1024 * 1024 // 1 MB,test
)

type Response struct {
	ErrorCode HttpResCode `json:"error_code"`
	ErrorMsg  string      `json:"error_msg"`
}

type HttpUploadInfo struct {
	Response
	Data      string `json:"data"`
	TimeStamp int64  `json:"time_stamp"`
}

var defaultIoClient *IoClient

const minioServerEndpoint = "10.0.59.231:9000"

func printError(w http.ResponseWriter, v interface{}) {
	data, err := json.Marshal(v)
	if err != nil {
		return
	}

	_, err = w.Write(data)
	if err != nil {
		return
	}
}

func getContentType(fileName string) (extension, contentType string) {
	arr := strings.Split(fileName, ".")

	// see: https://tool.oschina.net/commons/
	if len(arr) >= 2 {
		extension = arr[len(arr)-1]
		switch extension {
		case "jpeg", "jpe", "jpg":
			contentType = "image/jpeg"
		case "png":
			contentType = "image/png"
		case "gif":
			contentType = "image/gif"
		case "mp4":
			contentType = "video/mpeg4"
		case "mp3":
			contentType = "audio/mp3"
		case "wav":
			contentType = "audio/wav"
		case "pdf":
			contentType = "application/pdf"
		case "doc", "":
			contentType = "application/msword"
		}
	}
	// .*（ 二进制流，不知道下载文件类型）
	contentType = "application/octet-stream"
	return
}

func upload(w http.ResponseWriter, req *http.Request) {
	contentType := req.Header.Get("content-type")
	contentLen := req.ContentLength

	logger.Sugar.Debugf("upload content-type:%s,content-length:%d", contentType, contentLen)
	if !strings.Contains(contentType, "multipart/form-data") {
		printError(w, &Response{
			ErrorCode: HttpResCodeError,
			ErrorMsg:  "content-type must be multipart/form-data",
		})
		return
	}
	if contentLen >= MaxFileSize {
		printError(w, &Response{
			ErrorCode: HttpResCodeError,
			ErrorMsg:  "file to large,limit " + strconv.Itoa(MaxFileSize/1024/1024) + "MB",
		})
		return
	}

	err := req.ParseMultipartForm(MaxFileSize)
	if err != nil {
		printError(w, &Response{
			ErrorCode: HttpResCodeUnknown,
			ErrorMsg:  "ParseMultipartForm error:" + err.Error(),
		})
		return
	}

	if len(req.MultipartForm.File) == 0 {
		logger.Sugar.Errorf("not have any file")
		printError(w, &Response{
			ErrorCode: HttpResCodeUnknown,
			ErrorMsg:  "not have any file",
		})
	}

	for name, files := range req.MultipartForm.File {
		logger.Sugar.Debugf("req.MultipartForm.File,name=%s", name)

		if len(files) != 1 {
			logger.Sugar.Errorf("not have any file")
			printError(w, &Response{
				ErrorCode: HttpResCodeUnknown,
				ErrorMsg:  "too many files",
			})
			return
		}

		f := files[0]
		handle, err := f.Open()
		if err != nil {
			printError(w, &Response{
				ErrorCode: HttpResCodeUnknown,
				ErrorMsg:  "unknown error: " + err.Error(),
			})
			logger.Sugar.Errorf("unknown error,fileName=%s,fileSize=%d,err:%s", f.Filename, f.Size, err.Error())
			return
		}

		extension, contentType := getContentType(f.Filename)

		// fixed me
		objectName := uuid.NewV4().String() + "." + extension
		length, err := defaultIoClient.upload(objectName, contentType, handle, f.Size)
		if err != nil {
			printError(w, &Response{
				ErrorCode: HttpResCodeUnknown,
				ErrorMsg:  "unknown error: " + err.Error(),
			})
			logger.Sugar.Errorf("upload error,fileName=%s,fileSize=%d,err:%s", f.Filename, f.Size, err.Error())
			return
		} else {
			filePath := defaultIoClient.getPath(objectName)
			logger.Sugar.Infof("successful uploaded,fileName=%s,fileSize=%.2f MB,savePath=%s", f.Filename, float64(length)/1024/1024, filePath)

			info := &HttpUploadInfo{
				Response: Response{
					ErrorCode: HttpResCodeSuccess,
					ErrorMsg:  "success",
				},
				Data:      filePath,
				TimeStamp: time.Now().Unix(),
			}
			printError(w, info)
			return
		}
	}
}

func main() {
	logger.InitLogger("log.log", "debug")
	rand.Seed(time.Now().Unix())

	logger.Sugar.Infof("connect minio server:%s", minioServerEndpoint)
	defaultIoClient = &IoClient{}
	if err := defaultIoClient.init(minioServerEndpoint); err != nil {
		logger.Sugar.Fatal("init IoClient error:%s", err.Error())
		return
	}

	const listenEndPoint = "10.0.106.117:8500"
	logger.Sugar.Infof("start http server and listen on:%s", listenEndPoint)

	http.HandleFunc("/file/upload", upload)
	http.ListenAndServe(listenEndPoint, nil)
}

package filegw

import (
	"coffeechat/internal/filegw/conf"
	"coffeechat/pkg/logger"
	"encoding/json"
	"fmt"
	uuid "github.com/satori/go.uuid"
	"io"
	"net/http"
	"net/url"
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

func getFilenameFromUrl(req *http.Request) (string, error) {
	name := req.RequestURI[1:] // 去除/
	enEscapeUrl, err := url.QueryUnescape(name)
	if err != nil {
		return "", err
	}
	arr := strings.Split(enEscapeUrl, ".")
	if len(arr) == 2 {
		//ignore
		//extension := arr[1]
		encrypt := arr[0]
		// 去除扩展名后解密，得到完整路径，包括后缀名
		decrypt, err := AesDecryptWithString(encrypt, conf.DefaultConfig.UrlAesKey)
		if err != nil {
			return "", err
		}
		return decrypt, nil
	}
	return "", nil
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
			logger.Sugar.Errorf("too many files")
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
		bucketName := strconv.Itoa(time.Now().Year())

		length, err := defaultIoClient.upload(bucketName, objectName, contentType, handle, f.Size)
		if err != nil {
			printError(w, &Response{
				ErrorCode: HttpResCodeUnknown,
				ErrorMsg:  "unknown error: " + err.Error(),
			})
			logger.Sugar.Errorf("upload error,fileName=%s,fileSize=%d,err:%s", f.Filename, f.Size, err.Error())
			return
		} else {
			filePath := defaultIoClient.getPath(objectName)
			//name := filePath[0:strings.LastIndex(filePath, ".")]
			// 对url进行Aes加密，防止泄露服务器目录结构
			// 保留后缀名，便于客户端判断
			encrypt, err := AesEncryptWithString(filePath, conf.DefaultConfig.UrlAesKey)
			if err != nil {
				http.Error(w, err.Error(), http.StatusInternalServerError)
				return
			}
			logger.Sugar.Infof("successful uploaded,fileName=%s,fileSize=%.2f MB,savePath=%s", f.Filename, float64(length)/1024/1024, filePath)

			info := &HttpUploadInfo{
				Response: Response{
					ErrorCode: HttpResCodeSuccess,
					ErrorMsg:  "success",
				},
				Data:      url.QueryEscape(encrypt + "." + extension),
				TimeStamp: time.Now().Unix(),
			}
			printError(w, info)
			return
		}
	}
}

//绑定域名后，可以在浏览器直接查看图片
//
//参考：
//短视频文件
//http://180.163.22.25:80/qqdownload?ver=1&rkey=3081f00201010481e83081e50201010201000204a61ae1ba0481a63330353130323031303030343336333033343032303130303032303461363161653162613032303337613161666430323034313031366133623430323034356535663463343430343130383330326330353866616562383730656462653064643264633762656637306430323033376131646239303230313030303431343030303030303038363636393663363537343739373036353030303030303034333133303330333102045e5f4c5c04280000000866696c657479706500000004313030310000000b646f776e656e637279707400000001300400
//&filetype=1001&videotype=1&subvideotype=0&term=pc
//
//语音
//ver=1&rkey=dea801e9847bbff36b21b7be0e5361852d0ca2779733bc55d5d3ef04f5e32584706e6272a4d379be0518b13231738aac8a0a365ca900b647ca7efe651de9ef82
//
//某云存储下载url（视频截帧）:
//<原视频URL>?x-oss-process=video/snapshot,t_7000,f_jpg,w_800,h_600,m_fast
//t:指定截图时间,ms
//w:指定截图宽度，如果指定为0，则自动计算，px
//h:指定截图高度，如果指定为0,则自动计算。如果w和h都为0，则输出为原视频宽高，px
//m:指定截图模式，不指定则为默认模式，根据时间精确截图。如果指定为fast，则截取该时间点之前的最近的一个关键帧，枚举值fast
//f:指定输出图片的格式，jpg/png
//ar:指定是否根据视频信息自动旋转图片。如果指定为auto，则会在截图生成之后根据视频旋转信息进行自动旋转。枚举值auto
//
//现在版本：
//Sf1p16npgvFwi0VPS9IgaA==.png
func download(w http.ResponseWriter, req *http.Request) {
	if req.RequestURI == "/favicon.ico" {
		return
	}

	logger.Sugar.Debugf("download url=%s", req.RequestURI)

	filename, err := getFilenameFromUrl(req)
	if err != nil {
		printError(w, &Response{
			ErrorCode: HttpResCodeError,
			ErrorMsg:  "url error",
		})
		logger.Sugar.Errorf("url error,url=%s,error=%s", req.RequestURI, err.Error())
		return
	}
	logger.Sugar.Debugf("decrypt fileName=%s,url=%s", filename, req.RequestURI)

	// 2020/1.png
	bucketName := filename[0:4]
	objectName := filename[5:]

	reader, err := defaultIoClient.download(bucketName, objectName)
	if err != nil {
		printError(w, &Response{
			ErrorCode: HttpResCodeError,
			ErrorMsg:  err.Error(),
		})
		logger.Sugar.Errorf("read error,url=%s,error=%s", req.RequestURI, err.Error())
		return
	}

	info, err := reader.Stat()
	if err != nil {
		printError(w, &Response{
			ErrorCode: HttpResCodeError,
			ErrorMsg:  "read error",
		})
		logger.Sugar.Errorf("read error,url=%s,error=%s", req.RequestURI, err.Error())
		return
	}

	_, contentType := getContentType(filename)
	w.Header().Set("Content-Disposition", "attachment; filename="+filename)
	//w.Header().Set("Content-Type", http.DetectContentType(fileHeader))
	w.Header().Set("Content-Type", contentType)
	w.Header().Set("Content-Length", strconv.FormatInt(info.Size, 10))

	reader.Seek(0, 0)
	io.Copy(w, reader)
}

func StartHttpFileServer() error {
	listenEndpoint := fmt.Sprintf("%s:%d", conf.DefaultConfig.ListenIp, conf.DefaultConfig.ListenPort)
	minIoServerEndpoint := fmt.Sprintf("%s:%d", conf.DefaultConfig.MinIo.Ip, conf.DefaultConfig.MinIo.Port)
	minIoConfig := conf.DefaultConfig.MinIo

	// connect minio server
	logger.Sugar.Infof("connect minio server:%s", minIoServerEndpoint)
	defaultIoClient = &IoClient{}
	if err := defaultIoClient.init(minIoServerEndpoint, minIoConfig.AccessKeyID, minIoConfig.SecretAccessKey,
		minIoConfig.Location, minIoConfig.UseSSL); err != nil {
		logger.Sugar.Fatalf("init IoClient error:%s", err.Error())
		return err
	}

	// start http server
	logger.Sugar.Infof("start http server and listen on:%s", listenEndpoint)
	http.HandleFunc("/file/upload", upload)
	http.HandleFunc("/", download)
	return http.ListenAndServe(listenEndpoint, nil)
}

package main

import (
	"fmt"
	"io"
	"net/http"
	"os"
	"strings"
)

func upload(w http.ResponseWriter, req *http.Request) {
	contentType := req.Header.Get("content-type")
	contentLen := req.ContentLength

	fmt.Printf("upload content-type:%s,content-length:%d", contentType, contentLen)
	if !strings.Contains(contentType, "multipart/form-data") {
		w.Write([]byte("content-type must be multipart/form-data"))
		return
	}
	if contentLen >= 4*1024*1024 { // 10 MB
		w.Write([]byte("file to large,limit 4MB"))
		return
	}

	err := req.ParseMultipartForm(4 * 1024 * 1024)
	if err != nil {
		//http.Error(w, err.Error(), http.StatusInternalServerError)
		w.Write([]byte("ParseMultipartForm error:" + err.Error()))
		return
	}

	if len(req.MultipartForm.File) == 0 {
		w.Write([]byte("not have any file"))
		return
	}

	for name, files := range req.MultipartForm.File {
		fmt.Printf("req.MultipartForm.File,name=%s", name)

		if len(files) != 1 {
			w.Write([]byte("too many files"))
			return
		}
		if name == "" {
			w.Write([]byte("is not FileData"))
			return
		}

		for _, f := range files {
			handle, err := f.Open()
			if err != nil {
				w.Write([]byte(fmt.Sprintf("unknown error,fileName=%s,fileSize=%d,err:%s", f.Filename, f.Size, err.Error())))
				return
			}

			path := "./" + f.Filename
			dst, _ := os.Create(path)
			io.Copy(dst, handle)
			dst.Close()
			fmt.Printf("successful uploaded,fileName=%s,fileSize=%.2f MB,savePath=%s", f.Filename, float64(contentLen)/1024/1024, path)
		}
	}

	w.Write([]byte("successful"))
}

func main2() {
	http.HandleFunc("/file/upload", upload)
	http.ListenAndServe(":8080", nil)
}

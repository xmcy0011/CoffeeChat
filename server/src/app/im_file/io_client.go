package main

import (
	"context"
	"github.com/CoffeeChat/server/src/pkg/logger"
	"github.com/minio/minio-go"
	"io"
	"strconv"
	"time"
)

const (
	accessKeyID     = "minioadmin"
	secretAccessKey = "minioadmin"
	useSSL          = false

	//bucketName = "testBucket"
	location = "us-east-1" // default,see more:https://docs.min.io/docs/golang-client-api-reference#MakeBucket
)

var clientPool map[int]*IoClient
var clientPoolSize int

type IoClient struct {
	client     *minio.Client
	bucketName string
}

/*
func InitPool(size int, endpoint string) error {
	clientPoolSize = size
	clientPool = make(map[int]*IoClient, 0)

	for i := 0; i < size; i++ {
		client := &IoClient{}
		if err := client.init(endpoint); err != nil {
			return err
		}
		clientPool[i] = client // added
	}
	return nil
}

func GetRandomPool() *IoClient {
	index := rand.Int() % clientPoolSize
	return clientPool[index]
}
*/

func (i *IoClient) init(endpoint string) error {
	// Initialize minio client object.
	minIOClient, err := minio.New(endpoint, accessKeyID, secretAccessKey, useSSL)
	if err != nil {
		logger.Sugar.Error(err)
		return err
	}
	logger.Sugar.Infof("client init success,endpoint=%s", endpoint)

	// bucketName:2019 2020 2021 ....etc
	i.bucketName = strconv.Itoa(time.Now().Year())

	// 存储桶不存在则创建
	err = minIOClient.MakeBucket(i.bucketName, location)
	if err != nil {
		// 检查存储桶是否已经存在。
		exists, err := minIOClient.BucketExists(i.bucketName)
		if err == nil && exists {
			logger.Sugar.Infof("We already own %s", i.bucketName)
		} else {
			logger.Sugar.Error(err)
			return err
		}
	} else {
		logger.Sugar.Infof("Successfully created %s", i.bucketName)
	}

	i.client = minIOClient
	return nil
}

func (i *IoClient) getPath(objectName string) string {
	return i.bucketName + "/" + objectName
}

func (i *IoClient) upload(objectName string, contentType string, reader io.Reader, fileSize int64) (int64, error) {
	// 上传一个zip文件。
	//objectName := "头像.jpg"
	//filePath := "/Users/xuyc/头像.jpg"
	//contentType := "application/jpeg"

	// 使用FPutObject上传一个zip文件。
	//n, err := i.client.FPutObject(bucketName, objectName, filePath, minio.PutObjectOptions{ContentType: contentType})
	//if err != nil {
	//	log.Fatalln(err)
	//}

	//context.WithTimeout(context.Background(), time.Minute*10)
	length, err := i.client.PutObjectWithContext(context.Background(), i.bucketName, objectName, reader, fileSize, minio.PutObjectOptions{ContentType: contentType})
	//if err != nil {
	//}else{
	//	log.Printf("Successfully uploaded %s of size %d\n", objectName, length)
	//}
	return length, err
}

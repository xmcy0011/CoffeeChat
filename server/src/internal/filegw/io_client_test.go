package filegw

import (
	"github.com/minio/minio-go"
	"log"
)

// 测试使用minio的go sdk
// see more:https://docs.min.io/cn/golang-client-quickstart-guide.html
func UploadTest() {
	endpoint := "10.0.59.231:9000"
	accessKeyID := "minioadmin"
	secretAccessKey := "minioadmin"
	useSSL := false

	// Initialize minio client object.
	minIOClient, err := minio.New(endpoint, accessKeyID, secretAccessKey, useSSL)
	if err != nil {
		log.Fatalln(err)
	}

	log.Printf("client init success,%#v\n", minIOClient) // minioClient is now setup

	// 创建一个叫mymusic的存储桶。
	bucketName := "testBucket"
	location := "us-east-1" // default,see more:https://docs.min.io/docs/golang-client-api-reference#MakeBucket

	err = minIOClient.MakeBucket(bucketName, location)
	if err != nil {
		// 检查存储桶是否已经存在。
		exists, err := minIOClient.BucketExists(bucketName)
		if err == nil && exists {
			log.Printf("We already own %s\n", bucketName)
		} else {
			log.Fatalln(err)
		}
	}else{
		log.Printf("Successfully created %s\n", bucketName)
	}

	// 上传一个zip文件。
	objectName := "头像.jpg"
	filePath := "/Users/xmcy0011/头像.jpg"
	contentType := "application/jpeg"

	// 使用FPutObject上传一个zip文件。
	n, err := minIOClient.FPutObject(bucketName, objectName, filePath, minio.PutObjectOptions{ContentType:contentType})
	if err != nil {
		log.Fatalln(err)
	}

	log.Printf("Successfully uploaded %s of size %d\n", objectName, n)
}
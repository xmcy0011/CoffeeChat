package filegw

import (
	"bytes"
	"crypto/aes"
	"crypto/cipher"
	"encoding/base64"
)

//@brief: 填充明文
func pKCS5Padding(plaintext []byte, blockSize int) []byte {
	padding := blockSize - len(plaintext)%blockSize
	padtext := bytes.Repeat([]byte{byte(padding)}, padding)
	return append(plaintext, padtext...)
}

//@brief: 去除填充数据
func pKCS5UnPadding(origData []byte) []byte {
	length := len(origData)
	unpadding := int(origData[length-1])
	return origData[:(length - unpadding)]
}

//@brief: AES加密
func AesEncrypt(origData, key []byte) ([]byte, error) {
	block, err := aes.NewCipher(key)
	if err != nil {
		return nil, err
	}

	//AES分组长度为 128 位，所以 blockSize=16 字节
	blockSize := block.BlockSize()
	origData = pKCS5Padding(origData, blockSize)
	blockMode := cipher.NewCBCEncrypter(block, key[:blockSize]) //初始向量的长度必须等于块block的长度16字节
	crypted := make([]byte, len(origData))
	blockMode.CryptBlocks(crypted, origData)
	return crypted, nil
}

//@brief: AES加密
func AesEncryptWithString(origData, key string) (string, error) {
	var aesKey = []byte(key)
	data, err := AesEncrypt([]byte(origData), aesKey)
	if err != nil {
		return "", err
	}
	return base64.StdEncoding.EncodeToString(data), nil
}

//@brief:AES解密
func AesDecrypt(crypto, key []byte) ([]byte, error) {
	block, err := aes.NewCipher(key)
	if err != nil {
		return nil, err
	}

	// AES分组长度为 128 位，所以 blockSize=16 字节
	blockSize := block.BlockSize()
	blockMode := cipher.NewCBCDecrypter(block, key[:blockSize]) //初始向量的长度必须等于块block的长度16字节
	origData := make([]byte, len(crypto))
	blockMode.CryptBlocks(origData, crypto)
	origData = pKCS5UnPadding(origData)
	return origData, nil
}

//@brief:AES解密
func AesDecryptWithString(crypto, key string) (string, error) {
	bytesPass, err := base64.StdEncoding.DecodeString(crypto)
	if err != nil {
		return "", err
	}
	data, err := AesDecrypt(bytesPass, []byte(key))
	if err != nil {
		return "", err
	}
	return string(data), nil
}
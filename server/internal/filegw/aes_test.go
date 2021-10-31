package filegw

import "testing"

func TestAesDecryptWithString(t *testing.T) {
	key := "12345678abcdefgh"
	data := "2020/1.png"

	encrypt, err := AesEncryptWithString(data, key)
	if err != nil {
		t.Fatal(err)
	}
	t.Logf("加密前：%s，加密后：%s", data, encrypt)

	decrypt, err := AesDecryptWithString(encrypt, key)
	if err != nil {
		t.Fatal(err)
	}

	t.Logf("解密前：%s，解密后：%s", encrypt, decrypt)

	// 加密后 Sf1p16npgvFwi0VPS9IgaA==
	// 解密后 2020/1.png
}

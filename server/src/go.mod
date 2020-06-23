module coffeechat

go 1.12

require (
	github.com/BurntSushi/toml v0.3.1
	github.com/apache/rocketmq-client-go/v2 v2.1.0-rc3
	github.com/dgrijalva/jwt-go v3.2.0+incompatible
	github.com/go-ini/ini v1.57.0 // indirect
	github.com/go-redis/redis v6.15.8+incompatible
	github.com/go-sql-driver/mysql v1.5.0
	github.com/golang/mock v1.4.3 // indirect
	github.com/golang/protobuf v1.4.2
	github.com/json-iterator/go v1.1.10 // indirect
	github.com/minio/minio-go v6.0.14+incompatible
	github.com/mitchellh/go-homedir v1.1.0 // indirect
	github.com/modern-go/concurrent v0.0.0-20180306012644-bacd9c7ef1dd // indirect
	github.com/modern-go/reflect2 v1.0.1 // indirect
	github.com/onsi/ginkgo v1.12.3 // indirect
	github.com/pkg/errors v0.9.1 // indirect
	github.com/satori/go.uuid v1.2.0
	github.com/sirupsen/logrus v1.6.0 // indirect
	github.com/smartystreets/goconvey v1.6.4 // indirect
	github.com/tidwall/gjson v1.6.0 // indirect
	github.com/tidwall/pretty v1.0.1 // indirect
	go.uber.org/atomic v1.6.0
	go.uber.org/zap v1.15.0
	golang.org/x/sys v0.0.0-20200615200032-f1bc736245b1 // indirect
	google.golang.org/grpc v1.29.1
	gopkg.in/ini.v1 v1.57.0 // indirect
	gopkg.in/natefinch/lumberjack.v2 v2.0.0
)

replace golang.org/x/crypto v0.0.0-20190313024323-a1f597ede03a => github.com/golang/crypto v0.0.0-20190313024323-a1f597ede03a

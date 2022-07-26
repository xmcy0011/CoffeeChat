package log

import (
	"go.uber.org/zap"
)

// newZapLogger new zap logger
func newZapLogger(serviceId, serviceName, serviceVersion string, development bool, callerSkip int) (*zap.Logger, error) {
	var config zap.Config
	var encoding = "json"
	if development {
		config = zap.NewDevelopmentConfig()
		encoding = "console"
	} else {
		config = zap.NewProductionConfig()
	}
	config.Encoding = encoding

	l, err := config.Build(
		//zap.AddCaller(),
		zap.AddCallerSkip(callerSkip), //解决kratos 使用zap后 堆栈不正确的问题
		zap.Fields(
			zap.String("service.id", serviceId),
			zap.String("service.name", serviceName),
			zap.String("service.version", serviceVersion),
		),
	)

	return l, err
}

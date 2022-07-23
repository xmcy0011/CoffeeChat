package zap

import "go.uber.org/zap"

// NewLogger new zap logger
func NewLogger(development bool) (*zap.Logger, error) {
	var config zap.Config
	var encoding = "json"
	if development {
		config = zap.NewDevelopmentConfig()
		encoding = "console"
	} else {
		config = zap.NewProductionConfig()
	}
	config.Encoding = encoding

	l, err := config.Build(zap.AddCaller(),
		zap.Fields(
			zap.String("service", "ddd"),
		),
	)
	return l, err
}

package log

import (
	"context"
	"fmt"
	v2 "github.com/go-kratos/kratos/v2/log"
	"go.uber.org/zap"
)

type Logger struct {
	// 为什么不直接把zap.Logger放出来，而是自己再对其Debug等函数再包装?
	// 主要是因为 kratos 切换到zap后，都是同一个堆栈调用的问题
	logger *zap.Logger
	ctx    context.Context
}

// Log is kratos log wrapper
func (l *Logger) Log(level v2.Level, keyvals ...interface{}) error {
	if len(keyvals) == 0 || len(keyvals)%2 != 0 {
		l.logger.Warn(fmt.Sprint("Keyvalues must appear in pairs: ", keyvals))
		return nil
	}

	var msgValue = ""
	var data []zap.Field
	for i := 0; i < len(keyvals); i += 2 {
		if keyvals[i] == "msg" {
			msgValue = keyvals[i+1].(string)
			continue
		}
		data = append(data, zap.Any(fmt.Sprint(keyvals[i]), keyvals[i+1]))
	}

	switch level {
	case v2.LevelDebug:
		l.logger.Debug(msgValue, data...)
	case v2.LevelInfo:
		l.logger.Info(msgValue, data...)
	case v2.LevelWarn:
		l.logger.Warn(msgValue, data...)
	case v2.LevelError:
		l.logger.Error(msgValue, data...)
	case v2.LevelFatal:
		l.logger.Fatal(msgValue, data...)
	}
	return nil
}

func (l *Logger) Debug(msg string, fields ...zap.Field) {
	l.logger.Debug(msg, fields...)
}

func (l *Logger) Info(msg string, fields ...zap.Field) {
	l.logger.Info(msg, fields...)
}

func (l *Logger) Warn(msg string, fields ...zap.Field) {
	l.logger.Warn(msg, fields...)
}

func (l *Logger) Fatal(msg string, fields ...zap.Field) {
	l.logger.Fatal(msg, fields...)
}

func (l *Logger) With(fields ...zap.Field) *Logger {
	zapLogger := l.logger.With(fields...)
	return &Logger{logger: zapLogger}
}

// ------------ global ------------

var defaultLogger = MustNewLogger("", "", "", true, 0)

// MustNewLogger new zap Logger
func MustNewLogger(serviceId, serviceName, serviceVersion string, development bool, callerSkip int) *Logger {
	l, err := newZapLogger(serviceId, serviceName, serviceVersion, development, callerSkip)
	if err != nil {
		panic(err)
	}

	helper := &Logger{
		logger: l,
	}

	//l2 := v2.With(helper,
	//	"caller", v2.DefaultCaller,
	//	"service.id", "f3g034",
	//	"service.name", "test",
	//	"service.version", "0.1",
	//	"trace.id", tracing.TraceID(),
	//	"span.id", tracing.SpanID(),
	//)
	//v2.SetLogger(l2)

	return helper
}

// SetDefaultLogger set the global default logger
func SetDefaultLogger(helper *Logger) {
	defaultLogger = helper
}

func Debug(msg string, fields ...zap.Field) {
	defaultLogger.Debug(msg, fields...)
}

func Info(msg string, field ...zap.Field) {
	defaultLogger.Info(msg, field...)
}

func Warn(msg string, fields ...zap.Field) {
	defaultLogger.Warn(msg, fields...)
}

func Fatal(msg string, fields ...zap.Field) {
	defaultLogger.Fatal(msg, fields...)
}

// With creates a child logger and adds structured context to it. Fields added
// to the child don't affect the parent, and vice versa.
func With(fields ...zap.Field) *Logger {
	return defaultLogger.With(fields...)
}

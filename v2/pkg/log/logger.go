package log

import (
	"context"
	"fmt"
	v2 "github.com/go-kratos/kratos/v2/log"
	"github.com/go-kratos/kratos/v2/middleware/tracing"
	"go.uber.org/zap"
)

type Logger struct {
	// 为什么不直接把zap.Logger放出来，而是自己再对其Debug等函数再包装?
	// 主要是因为 kratos 切换到zap后，都是同一个堆栈调用的问题
	*zap.Logger
	ctx context.Context
}

// Log is kratos log wrapper
func (l *Logger) Log(level v2.Level, keyvals ...interface{}) error {
	if len(keyvals) == 0 || len(keyvals)%2 != 0 {
		l.Logger.Warn(fmt.Sprint("Keyvalues must appear in pairs: ", keyvals))
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
		l.Logger.Debug(msgValue, data...)
	case v2.LevelInfo:
		l.Logger.Info(msgValue, data...)
	case v2.LevelWarn:
		l.Logger.Warn(msgValue, data...)
	case v2.LevelError:
		l.Logger.Error(msgValue, data...)
	case v2.LevelFatal:
		l.Logger.Fatal(msgValue, data...)
	}
	return nil
}

func (l *Logger) Trace(ctx context.Context) *Logger {
	tid := tracing.TraceID()(ctx).(string)
	sid := tracing.SpanID()(ctx).(string)
	return With(l, zap.String("trace.id", tid), zap.String("span.id", sid))
}

// ------------ global ------------

var L = MustNewLogger("", "", "", true, 0)

// MustNewLogger new zap Logger
func MustNewLogger(serviceId, serviceName, serviceVersion string, development bool, callerSkip int) *Logger {
	l, err := newZapLogger(serviceId, serviceName, serviceVersion, development, callerSkip)
	if err != nil {
		panic(err)
	}

	logger := &Logger{
		Logger: l,
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

	return logger
}

// SetGlobalLogger set the global default logger
func SetGlobalLogger(helper *Logger) {
	L = helper
}

// With creates a child logger and adds structured context to it. Fields added
// to the child don't affect the parent, and vice versa.
func With(logger *Logger, fields ...zap.Field) *Logger {
	zapCore := logger.Logger.With(fields...)
	return &Logger{
		Logger: zapCore,
	}
}

// Trace creates a child logger and adds trace&span id to it. Fields added
// to the child don't affect the parent, and vice versa.
func Trace(ctx context.Context) *Logger {
	tid := tracing.TraceID()(ctx).(string)
	sid := tracing.SpanID()(ctx).(string)
	return With(L, zap.String("trace.id", tid), zap.String("span.id", sid))
}

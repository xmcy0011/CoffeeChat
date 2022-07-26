package log

import (
	kratoslog "github.com/go-kratos/kratos/v2/log"
	"github.com/go-kratos/kratos/v2/middleware/tracing"
	"testing"
)

func TestMustInitLogger(t *testing.T) {
	MustNewLogger("", "", "", true, 0)

	Info("hello")
}

func TestKratosLogHelper(t *testing.T) {
	MustNewLogger("", "", "", true, 0)

	kratoslog.SetLogger(defaultLogger)
	kratoslog.Info("TestNewLogger", "userName", "admin")
}

func TestLogContext(t *testing.T) {
	MustNewLogger("", "", "", true, 0)

	l := kratoslog.With(defaultLogger,
		"service.id", "f3g034",
		"service.name", "test",
		"service.version", "0.1",
		"trace.id", tracing.TraceID(),
		"span.id", tracing.SpanID(),
	)

	l.Log(kratoslog.LevelInfo, "msg", "hello")
}

package log

import (
	"github.com/go-kratos/kratos/v2/log"
	"github.com/go-kratos/kratos/v2/middleware/tracing"
	"github.com/stretchr/testify/require"
	"testing"
)

func TestNewLogger(t *testing.T) {
	l, err := NewZapLogger(true)
	require.Equal(t, err, nil)

	l.Log(log.LevelInfo, "msg", "TestNewLogger", "userName", "admin")
}

func TestKratosLogHelper(t *testing.T) {
	l, err := NewZapLogger(true)
	require.Equal(t, err, nil)

	helper := log.NewHelper(l)
	helper.Info("TestNewLogger", "userName", "admin")
}

func TestLogContext(t *testing.T) {
	l, _ := NewZapLogger(true)

	l = log.With(l,
		"service.id", "f3g034",
		"service.name", "test",
		"service.version", "0.1",
		"trace.id", tracing.TraceID(),
		"span.id", tracing.SpanID(),
	)

	l.Log(log.LevelInfo, "msg", "hello")
}

func TestNewZapLogger(t *testing.T) {
	l, err := NewZapLogger(true)
	require.Equal(t, err, nil)

	logger := l.(*Logger)

	logger.log.Info("hello world")
	logger.log.Warn("warn msg")
}

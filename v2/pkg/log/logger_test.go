package log

import (
	"context"
	kratoslog "github.com/go-kratos/kratos/v2/log"
	"github.com/go-kratos/kratos/v2/middleware/tracing"
	"github.com/stretchr/testify/require"
	"go.opentelemetry.io/otel/trace"
	"testing"
)

func TestMustInitLogger(t *testing.T) {
	l := MustNewLogger("", "", "", true, 0)
	l.Info("hello")
}

func TestKratosLogHelper(t *testing.T) {
	l := MustNewLogger("", "", "", true, 2)

	kratoslog.SetLogger(l)
	kratoslog.Info("TestNewLogger", "userName", "admin")
}

func TestLogContext(t *testing.T) {
	logger := MustNewLogger("", "", "", true, 2)

	l := kratoslog.With(logger,
		"service.id", "f3g034",
		"service.name", "test",
		"service.version", "0.1",
		"trace.id", tracing.TraceID(),
		"span.id", tracing.SpanID(),
	)

	l.Log(kratoslog.LevelInfo, "msg", "hello")
}

func TestTrace(t *testing.T) {
	ctx := context.Background()
	L.Trace(ctx).Info("hello empty trace")

	tid, err := trace.TraceIDFromHex("42ea300a7123568cedcc736db3c52bbb")
	sid, err := trace.SpanIDFromHex("af99bcb398b7a3ba")

	require.Equal(t, err, nil)
	spanCtx := trace.NewSpanContext(trace.SpanContextConfig{
		TraceID: tid,
		SpanID:  sid,
	})
	ctx = trace.ContextWithSpanContext(context.Background(), spanCtx)
	L.Trace(ctx).Info("hello trace")
}

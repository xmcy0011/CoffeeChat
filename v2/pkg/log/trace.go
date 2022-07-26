package log

import (
	"context"
	"github.com/go-kratos/kratos/v2/middleware/tracing"
	"go.uber.org/zap"
)

// Trace creates a child logger and adds trace&span id to it. Fields added
// to the child don't affect the parent, and vice versa.
func Trace(ctx context.Context) *Logger {
	tid := tracing.TraceID()(ctx).(string)
	sid := tracing.SpanID()(ctx).(string)
	return With(zap.String("trace.id", tid), zap.String("span.id", sid))
}

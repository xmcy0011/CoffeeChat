package log

import (
	"go.opentelemetry.io/otel"
	"testing"
	"github.com/go-kratos/kratos/v2/middleware/tracing"
)

func TestTrace(t *testing.T) {
	trace := otel.Tracer("TestTrace")

}

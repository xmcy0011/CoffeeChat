package log

import (
	"github.com/stretchr/testify/require"
	"testing"
)

func TestNewZapLogger(t *testing.T) {
	l, err := newZapLogger("", "test", "", true, 0)
	require.Equal(t, err, nil)

	l.Info("hello world")
	l.Warn("warn msg")
}

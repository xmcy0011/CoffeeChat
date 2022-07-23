package zap

import (
	"github.com/stretchr/testify/require"
	"testing"
)

func TestNewLogger(t *testing.T) {
	l, err := NewLogger(true)
	require.Equal(t, err, nil)

	l.Info("hello world")
	l.Warn("warn msg")
}

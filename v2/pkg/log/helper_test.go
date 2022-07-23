package log

import "testing"

func TestMustInitLogger(t *testing.T) {
	MustInitLogger(true)

	CC.Info("hello")
}

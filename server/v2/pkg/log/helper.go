package log

import v2 "github.com/go-kratos/kratos/v2/log"

var CC *Helper

type Helper struct {
	*v2.Helper
}

func MustInitLogger(development bool) {
	l, err := NewZapLogger(development)
	if err != nil {
		panic(err)
	}

	CC = &Helper{
		Helper: v2.NewHelper(l),
	}
}

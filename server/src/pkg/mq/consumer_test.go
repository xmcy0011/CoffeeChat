package mq

import (
	"coffeechat/pkg/logger"
	"testing"
	"time"
)

func TestMsgConsumer_StartConsumer(t *testing.T) {
	logger.InitLogger("log.log", "info")

	err := DefaultMsgConsumer.StartConsumer("group1", []string{"10.0.107.218:9876"})
	if err != nil {
		t.Error(err)
		return
	}

	go func() {
		for i := 0; i < 10; i++ {
			time.Sleep(time.Second)
		}
		DefaultMsgConsumer.Shutdown()
	}()

	for {
		select {
		case msg, ok := <-DefaultMsgConsumer.Messages():
			if !ok {
				t.Log("chan closed")
				return
			}
			t.Logf("%v \n", msg)
		}
	}
}

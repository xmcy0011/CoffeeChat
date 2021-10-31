package logger

import (
	"fmt"
	"os"
	"time"

	"go.uber.org/zap"
	"go.uber.org/zap/zapcore"
	"gopkg.in/natefinch/lumberjack.v2"
)

var Logger *zap.Logger
var Sugar *zap.SugaredLogger

func timeEncoder(t time.Time, enc zapcore.PrimitiveArrayEncoder) {
	enc.AppendString(t.Format("2006-01-02 15:04:05.000"))
}

func levelEncoder(l zapcore.Level, enc zapcore.PrimitiveArrayEncoder) {
	var level string
	switch l {
	case zapcore.DebugLevel:
		level = "[DEBUG]"
	case zapcore.InfoLevel:
		level = "[INFO]"
	case zapcore.WarnLevel:
		level = "[WARN]"
	case zapcore.ErrorLevel:
		level = "[ERROR]"
	case zapcore.DPanicLevel:
		level = "[DPANIC]"
	case zapcore.PanicLevel:
		level = "[PANIC]"
	case zapcore.FatalLevel:
		level = "[FATAL]"
	default:
		level = fmt.Sprintf("[LEVEL(%d)]", l)
	}
	enc.AppendString(level)
}

func shortCallerEncoder(caller zapcore.EntryCaller, enc zapcore.PrimitiveArrayEncoder) {
	enc.AppendString(fmt.Sprintf("[%s]", caller.TrimmedPath()))
}

func NewEncoderConfig() zapcore.EncoderConfig {
	return zapcore.EncoderConfig{
		// Keys can be anything except the empty string.
		TimeKey:        "T",
		LevelKey:       "L",
		NameKey:        "N",
		CallerKey:      "C",
		MessageKey:     "M",
		StacktraceKey:  "S",
		LineEnding:     zapcore.DefaultLineEnding,
		EncodeLevel:    levelEncoder, //zapcore.CapitalLevelEncoder,
		EncodeTime:     timeEncoder,
		EncodeDuration: zapcore.StringDurationEncoder,
		EncodeCaller:   shortCallerEncoder, //zapcore.ShortCallerEncoder,
	}
}

// filename: like "log/log.log"
// level:debug,info,warn,error,dpanic,panic,fatal
func InitLogger(log string, level string) {
	w := zapcore.AddSync(&lumberjack.Logger{
		Filename:   log,
		MaxSize:    500, // megabytes
		MaxBackups: 3,
		MaxAge:     28, // days
		Compress:   true,
	})

	var lv zapcore.Level
	err := lv.UnmarshalText([]byte(level))
	if err != nil {
		fmt.Println("level ", level, ", error:", err.Error())
		lv = zapcore.InfoLevel
	}

	// level级别以上的一个文件，如果是info，则warn\error\painc等包含
	core := zapcore.NewCore(
		zapcore.NewConsoleEncoder(NewEncoderConfig()),
		zapcore.NewMultiWriteSyncer(zapcore.AddSync(os.Stdout), w),
		lv,
	)

	Logger = zap.New(core, zap.AddCaller())
	Sugar = Logger.Sugar()
}

func InitLoggerEx(infoLog, warnLog string, level string) {
	w1 := zapcore.AddSync(&lumberjack.Logger{
		Filename:   infoLog,
		MaxSize:    500, // megabytes
		MaxBackups: 3,
		MaxAge:     28, // days
		Compress:   true,
	})
	w2 := zapcore.AddSync(&lumberjack.Logger{
		Filename:   warnLog,
		MaxSize:    500, // megabytes
		MaxBackups: 3,
		MaxAge:     28, // days
		Compress:   true,
	})

	var lv zapcore.Level
	err := lv.UnmarshalText([]byte(level))
	if err != nil {
		fmt.Println("level ", level, ", error:", err.Error())
		lv = zapcore.InfoLevel
	}

	// level级别以上的一个文件，如果是info，则warn\error\painc等包含
	coreInfo := zapcore.NewCore(
		zapcore.NewConsoleEncoder(NewEncoderConfig()),
		zapcore.NewMultiWriteSyncer(zapcore.AddSync(os.Stdout), w1),
		lv,
	)
	// warn级别以上的一个文件，便于排查问题
	coreWarn := zapcore.NewCore(
		zapcore.NewConsoleEncoder(NewEncoderConfig()),
		zapcore.NewMultiWriteSyncer( /*zapcore.AddSync(os.Stdout),*/ w2), // 因为info以及输出到stdout了，不再重复输出
		zapcore.WarnLevel,
	)
	tee := zapcore.NewTee(coreInfo, coreWarn)

	Logger = zap.New(tee, zap.AddCaller())
	Sugar = Logger.Sugar()
}

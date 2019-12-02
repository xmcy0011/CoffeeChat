/// 日志
class LogUtil {
  /// info级别
  static void info(String tag, String content) {
    print("[info][$tag] $content");
  }

  /// error级别
  static void error(String tag, String content) {
    print("[error][$tag] $content");
  }
}

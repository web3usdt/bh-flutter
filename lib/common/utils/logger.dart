import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class ConsoleOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    for (var line in event.lines) {
      _printLong(line);
    }
  }

  void _printLong(String text) {
    const int chunkSize = 800; // 防止 logcat 截断
    for (int i = 0; i < text.length; i += chunkSize) {
      final chunk = text.substring(i, i + chunkSize > text.length ? text.length : i + chunkSize);
      print(chunk); // 👈 打印到调试终端
    }
  }
}

// logger
final log = Logger(
  output: ConsoleOutput(),
  level: kDebugMode ? Level.verbose : Level.info,
);

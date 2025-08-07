import 'package:intl/intl.dart';

class DateCommonUtils {
  // 年月日时分
  static String formatYMDHM(DateTime? dateTime) {
    if (dateTime == null) return '';
    return DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
  }

  // 年月日时分秒
  static String formatYMDHMS(DateTime? dateTime) {
    if (dateTime == null) return '';
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }

  // 年月日
  static String formatYMD(DateTime? dateTime) {
    if (dateTime == null) return '';
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  // 时分秒
  static String formatHMS(int dateTime) {
    if (dateTime == 0) return '';
    final date = DateTime.fromMillisecondsSinceEpoch(dateTime);
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(date.hour)}:${twoDigits(date.minute)}:${twoDigits(date.second)}';
  }

  // 获取当前时间
  static String getCurrentTime() {
    return formatYMDHM(DateTime.now());
  }
}

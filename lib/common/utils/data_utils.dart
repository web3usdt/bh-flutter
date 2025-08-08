import 'package:BBIExchange/common/index.dart';
import 'package:decimal/decimal.dart';

// 辅助函数，用于安全地格式化Decimal字符串
String formatDecimal(String? value, {int? toFixed}) {
  if (value == null) {
    return '--';
  }
  final decimalValue = Decimal.tryParse(value);
  if (decimalValue == null) {
    return '--';
  }
  if (toFixed != null) {
    // 检查是否需要补零
    var stringValue = decimalValue.toString();
    if (stringValue.contains('.')) {
      var parts = stringValue.split('.');
      if (parts[1].length > toFixed) {
        return decimalValue.toStringAsFixed(toFixed);
      }
    }
  }
  return decimalValue.toString();
}

class DataUtils {
  /// 将任意值转换为int类型
  static int? toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      return int.tryParse(value.replaceAll(RegExp(r'[^0-9-]'), ''));
    }
    return 0;
  }

  /// 将任意值转换为double类型
  static double? toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value.replaceAll(RegExp(r'[^0-9.-]'), ''));
    }
    return 0.0;
  }

  /// 将任意值转换为String类型
  static String? toStr(dynamic value) {
    // 改名为 toStr
    if (value == null) return '--';
    return value.toString();
  }

  static String toDateTimeStr(dynamic value) {
    if (value == null) return '--';
    return DateTime.fromMillisecondsSinceEpoch((value ?? 0) * 1000).toString().substring(0, 19);
  }

  /// 将任意值转换为bool类型
  static bool? toBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is int) return value != 0;
    if (value is String) {
      value = value.toLowerCase().trim();
      if (value == 'true' || value == '1') return true;
      if (value == 'false' || value == '0') return false;
    }
    return false;
  }

  /// 检查字符串是否有效（非空且长度大于0）
  static bool isValidString(dynamic value) {
    return toStr(value)?.isNotEmpty == true;
  }

  /// 截取地址/字符串，保留头尾，显示  0xff****hide
  static String formatAddress(String? address, {int prefixLength = 4, int suffixLength = 4}) {
    if (address == null || address.isEmpty) return '';
    if (address.length <= prefixLength + suffixLength) return address;

    String prefix = address.substring(0, prefixLength);
    String suffix = address.substring(address.length - suffixLength);
    return '$prefix****$suffix';
  }

  /// 格式化数字为固定小数位，不进行四舍五入
  /// [value] 需要格式化的数值
  /// [places] 小数位数，默认2位
  static String formatNumber(dynamic value, {int places = 2}) {
    if (value == null) return '0.${List.filled(places, '0').join()}';

    // 判断是否为科学计数法
    if (isScientific(value)) {
      // 用 MathUtils.omitTo 转换为普通数字并保留指定位数
      return MathUtils.omitTo(value, places);
    }

    // 原有逻辑
    String numStr = value.toString();

    if (numStr.contains('.')) {
      List<String> parts = numStr.split('.');
      String intPart = parts[0];
      String decimalPart = parts[1];

      if (decimalPart.length > places) {
        decimalPart = decimalPart.substring(0, places);
      } else if (decimalPart.length < places) {
        decimalPart = decimalPart.padRight(places, '0');
      }

      return '$intPart.$decimalPart';
    } else {
      return '$numStr.${'0' * places}';
    }
  }

  static bool isScientific(dynamic value) {
    if (value == null) return false;
    String str = value.toString();
    return RegExp(r'^\-?\d+(\.\d+)?[eE][\+\-]?\d+$').hasMatch(str);
  }
}

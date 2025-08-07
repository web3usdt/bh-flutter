import 'dart:math';
import 'package:decimal/decimal.dart';

class MathUtils {
  /// 检测小数点精度
  static int countDecimals(dynamic num) {
    try {
      String str = num.toString();
      if (str.contains('.')) {
        return str.split('.')[1].length;
      }
    } catch (e) {}
    return 0;
  }

  /// 将科学计数法转换为普通数字
  static String scientific2No(dynamic val) {
    String str = val.toString();
    if (RegExp(r'\d+\.?\d*e[+-]*\d+', caseSensitive: false).hasMatch(str)) {
      double d = double.parse(str);
      str = d.toStringAsFixed(20);
      // 去除多余的0
      str = str.replaceFirst(RegExp(r'([0-9]+\.[0-9]*[1-9])0+'), r'$1');
      str = str.replaceFirst(RegExp(r'\.0+'), '');
      str = str.replaceAll('', '').replaceAll('', '');
      // 防止出现科学计数法
      if (str.contains('e') || str.contains('E')) {
        // 兜底
        return d.toString();
      }
      return str;
    }
    return str;
  }

  /// 截取小数点后n位（不四舍五入，直接截断）
  static String omitTo(dynamic val, int scale) {
    String value = scientific2No(val);
    if (!value.contains('.')) {
      return value + '.' + '0' * scale;
    }
    List<String> parts = value.split('.');
    String entity = parts[0];
    String precisionVal = parts[1];
    if (precisionVal.length > scale) {
      // 截断多余小数位
      precisionVal = precisionVal.substring(0, scale);
    } else if (precisionVal.length < scale) {
      // 补零
      precisionVal = precisionVal.padRight(scale, '0');
    }
    return entity + '.' + precisionVal;
  }

  /// 计算两个数的和
  static String add(dynamic num1, dynamic num2, [int? scale]) {
    num1 = scientific2No(num1);
    num2 = scientific2No(num2);
    int precision1 = countDecimals(num1);
    int precision2 = countDecimals(num2);
    int amplification = pow(10, max(precision1, precision2)).toInt();
    double val = (double.parse(num1) * amplification + double.parse(num2) * amplification) / amplification;
    String result = scientific2No(val);
    if (scale != null) result = omitTo(result, scale);
    return result;
  }

  /// 计算两个数的差值
  static String subtr(dynamic num1, dynamic num2, [int? scale]) {
    num1 = scientific2No(num1);
    num2 = scientific2No(num2);
    int precision1 = countDecimals(num1);
    int precision2 = countDecimals(num2);
    int precision = max(precision1, precision2);
    int amplification = pow(10, precision).toInt();
    double val = ((double.parse(num1) * amplification - double.parse(num2) * amplification) / amplification);
    String result = scientific2No(val);
    if (scale != null) result = omitTo(result, scale);
    return result;
  }

  /// 计算两个数的乘积
  static String multiple(dynamic num1, dynamic num2, [int? scale]) {
    double d1 = double.tryParse(num1.toString()) ?? 0;
    double d2 = double.tryParse(num2.toString()) ?? 0;
    double val = d1 * d2;
    String result = scientific2No(val);
    print('测试1=$result');
    if (scale != null) result = omitTo(result, scale);
    print('测试2=$result');
    return result;
  }

  /// 两个数相除
  static String division(dynamic num1, dynamic num2, [int? scale]) {
    num1 = scientific2No(num1);
    num2 = scientific2No(num2);
    int precision1 = countDecimals(num1);
    int precision2 = countDecimals(num2);
    int m = precision1 > precision2 ? precision1 : precision2;
    if (m <= 1) m = 1;
    double val = double.parse(multiple(num1, m)) / double.parse(multiple(num2, m));
    String result = scientific2No(val);
    if (scale != null) result = omitTo(result, scale);
    return result;
  }

  // 使用decimal库计算两个数的乘积，并指定保留小数位,不进行四舍五入
  static String multipleDecimal(dynamic num1, dynamic num2, [int? scale]) {
    // 处理空字符串或null值
    String str1 = (num1?.toString() ?? '').trim();
    String str2 = (num2?.toString() ?? '').trim();
    if (str1.isEmpty || str1 == 'null') str1 = '0';
    if (str2.isEmpty || str2 == 'null') str2 = '0';

    Decimal d1 = Decimal.parse(str1);
    Decimal d2 = Decimal.parse(str2);
    Decimal result = d1 * d2;
    int decimalPlaces = scale ?? 10;
    String str = result.toString();

    // 判断是否有小数点
    if (str.contains('.')) {
      var parts = str.split('.');
      var intPart = parts[0];
      var decPart = parts[1];
      if (decPart.length > decimalPlaces) {
        decPart = decPart.substring(0, decimalPlaces);
      } else {
        decPart = decPart.padRight(decimalPlaces, '0');
      }
      return '$intPart.$decPart';
    } else {
      // 没有小数点，补零
      return '$str.${'0' * decimalPlaces}';
    }
  }

  // 使用decimal库计算两个数的加减，并指定保留小数位,不进行四舍五入
  static String addDecimal(dynamic num1, dynamic num2, [int? scale]) {
    // 处理空字符串或null值
    String str1 = (num1?.toString() ?? '').trim();
    String str2 = (num2?.toString() ?? '').trim();
    if (str1.isEmpty || str1 == 'null') str1 = '0';
    if (str2.isEmpty || str2 == 'null') str2 = '0';

    Decimal d1 = Decimal.parse(str1);
    Decimal d2 = Decimal.parse(str2);
    Decimal result = d1 + d2;
    int decimalPlaces = scale ?? 10;
    String str = result.toString();
    if (str.contains('.')) {
      var parts = str.split('.');
      var intPart = parts[0];
      var decPart = parts[1];
      if (decPart.length > decimalPlaces) {
        decPart = decPart.substring(0, decimalPlaces);
      } else {
        decPart = decPart.padRight(decimalPlaces, '0');
      }
      return '$intPart.$decPart';
    } else {
      // 没有小数点，补零
      return '$str.${'0' * decimalPlaces}';
    }
  }

  // 使用decimal库计算两个数的减，并指定保留小数位,不进行四舍五入
  static String subtrDecimal(dynamic num1, dynamic num2, [int? scale]) {
    // 处理空字符串或null值
    String str1 = (num1?.toString() ?? '').trim();
    String str2 = (num2?.toString() ?? '').trim();
    if (str1.isEmpty || str1 == 'null') str1 = '0';
    if (str2.isEmpty || str2 == 'null') str2 = '0';

    Decimal d1 = Decimal.parse(str1);
    Decimal d2 = Decimal.parse(str2);
    Decimal result = d1 - d2;
    int decimalPlaces = scale ?? 10;
    String str = result.toString();
    if (str.contains('.')) {
      var parts = str.split('.');
      var intPart = parts[0];
      var decPart = parts[1];
      if (decPart.length > decimalPlaces) {
        decPart = decPart.substring(0, decimalPlaces);
      } else {
        decPart = decPart.padRight(decimalPlaces, '0');
      }
      return '$intPart.$decPart';
    } else {
      // 没有小数点，补零
      return '$str.${'0' * decimalPlaces}';
    }
  }
}

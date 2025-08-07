import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dart_ping/dart_ping.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:happy/common/index.dart';

class NetworkDiagnosisController extends GetxController {
  final diagnosisLog = ''.obs;
  final isTesting = false.obs;
  StreamSubscription<PingData>? _pingStream;

  @override
  void onClose() {
    _pingStream?.cancel();
    super.onClose();
  }

  // 脱敏主机
  String _maskHost(String host) {
    if (RegExp(r'^\\d{1,3}(\\.\\d{1,3}){3}$').hasMatch(host)) {
      return _maskIp(host);
    }
    var parts = host.split('.');
    if (parts.length > 2) {
      return '***.${parts.sublist(1).join('.')}';
    }
    if (parts.length == 2) {
      var firstPart = parts.first;
      if (firstPart.length > 2) {
        return '${firstPart.substring(0, 1)}***${firstPart.substring(firstPart.length - 1)}.${parts.last}';
      }
      return '***.${parts.last}';
    }
    return '******';
  }

  // 脱敏IP
  String _maskIp(String ip) {
    // IPv4
    if (ip.contains('.')) {
      var parts = ip.split('.');
      if (parts.length == 4) {
        return '${parts.first}.***.***.${parts.last}';
      }
    }
    // IPv6
    if (ip.contains(':')) {
      var parts = ip.split(':');
      if (parts.length > 2) {
        return '${parts.first}:...:${parts.last}';
      }
    }
    // Fallback for unexpected formats
    return '******';
  }

  void startDiagnosis() async {
    isTesting.value = true;
    diagnosisLog.value = '开始网络诊断...\n\n';

    try {
      // 从配置中获取API域名
      final apiUri = Uri.parse(ConfigService.to.curEnv.value.apiBaseUrl);
      final host = apiUri.host;

      diagnosisLog.value += '诊断目标: ${_maskHost(host)}\n\n';

      // 1. 网络状态检查
      await _checkConnectivity();

      // 2. DNS 解析测试
      await _checkDns(host);

      // 3. Ping 测试
      await _startPing(host);

      // 4. HTTPS 连通性测试

      await _checkHttps('https://www.baidu.com', 'Baidu');
      await _checkHttps('https://www.google.com', 'Google');
      await _checkHttps(apiUri.toString(), '项目服务器');

      // 5. Ping Baidu
      const baiduHost = 'www.baidu.com';
      diagnosisLog.value += '--- 开始 Ping Baidu ($baiduHost) ---\n';
      await _startPing(baiduHost);
      diagnosisLog.value += '--- Ping Baidu ($baiduHost) 结束 ---\n\n';

      // 6. Ping Google
      const googleHost = 'www.google.com';
      diagnosisLog.value += '--- 开始 Ping Google ($googleHost) ---\n';
      await _startPing(googleHost);
      diagnosisLog.value += '--- Ping Google ($googleHost) 结束 ---\n\n';

      diagnosisLog.value += '诊断完成！';
    } catch (e) {
      diagnosisLog.value += '诊断过程中出现未知错误: $e\n';
    } finally {
      isTesting.value = false;
    }
  }

  Future<void> _checkConnectivity() async {
    diagnosisLog.value += '--- 开始网络状态检查 ---\n';
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.wifi)) {
      diagnosisLog.value += '当前网络: Wi-Fi\n';
    } else if (connectivityResult.contains(ConnectivityResult.mobile)) {
      diagnosisLog.value += '当前网络: 移动数据\n';
    } else if (connectivityResult.contains(ConnectivityResult.none)) {
      diagnosisLog.value += '当前网络: 无网络连接\n';
    }
    diagnosisLog.value += '--- 网络状态检查结束 ---\n\n';
  }

  Future<void> _checkDns(String host) async {
    diagnosisLog.value += '--- 开始 DNS 解析测试 ---\n';
    try {
      final addresses = await InternetAddress.lookup(host);
      diagnosisLog.value += 'DNS 解析成功:\n';
      for (var addr in addresses) {
        diagnosisLog.value += '  - ${_maskIp(addr.address)}\n';
      }
    } on SocketException catch (e) {
      diagnosisLog.value += 'DNS 解析失败: ${e.message}\n';
      throw Exception('DNS 解析失败');
    }
    diagnosisLog.value += '--- DNS 解析测试结束 ---\n\n';
  }

  Future<void> _startPing(String host) async {
    final completer = Completer<void>();
    final ping = Ping(host, count: 10, timeout: 5);

    _pingStream = ping.stream.listen((event) {
      if (event.response != null) {
        final response = event.response!;
        final ip = response.ip;
        final time = response.time?.inMilliseconds;
        if (ip != null) {
          diagnosisLog.value += '来自 ${_maskIp(ip)} 的回复: time=${time}ms\n';
        } else {
          // Fallback for responses without an IP
          diagnosisLog.value += 'Ping 响应: ${response.toString()}\n';
        }
      }
      if (event.summary != null) {
        final summary = event.summary!;
        diagnosisLog.value += 'Ping 统计: ${summary.transmitted} 已发送, ${summary.received} 已接收, 耗时 ${summary.time?.inMilliseconds}ms\n';
      }
      if (event.error != null) {
        diagnosisLog.value += 'Ping 错误: ${event.error}\n';
      }
    }, onDone: () {
      _pingStream?.cancel();
      completer.complete();
    }, onError: (e) {
      diagnosisLog.value += 'Ping 错误: ${e.toString()}\n';
      _pingStream?.cancel();
      completer.completeError(e);
    });

    return completer.future;
  }

  Future<void> _checkHttps(String url, String targetName) async {
    diagnosisLog.value += '--- 开始 HTTPS 连通性测试 ($targetName) ---\n';
    final dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 60),
      sendTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
    ));

    try {
      final response = await dio.get(url);
      diagnosisLog.value += '✅ HTTPS 请求成功 (状态码: ${response.statusCode})\n';
      diagnosisLog.value += '响应头: \n${response.headers}\n';
      var responseBody = response.data?.toString() ?? 'N/A';
      if (responseBody.length > 200) {
        responseBody = responseBody.substring(0, 200) + '...';
      }
      diagnosisLog.value += '响应内容(部分): \n$responseBody\n';
    } on DioException catch (e) {
      var errorMsg = '❌ HTTPS 请求失败: ';
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
          errorMsg += '连接超时';
          break;
        case DioExceptionType.sendTimeout:
          errorMsg += '发送超时';
          break;
        case DioExceptionType.receiveTimeout:
          errorMsg += '接收超时';
          break;
        case DioExceptionType.badResponse:
          errorMsg += '服务器响应错误 (状态码: ${e.response?.statusCode})';
          break;
        case DioExceptionType.badCertificate:
          errorMsg += '证书验证失败';
          break;
        case DioExceptionType.cancel:
          errorMsg += '请求被取消';
          break;
        case DioExceptionType.connectionError:
          errorMsg += '连接错误 (请检查网络或DNS)';
          if (e.error is SocketException) {
            final socketErr = e.error as SocketException;
            errorMsg += '\n  - 底层错误: ${socketErr.osError?.message ?? socketErr.message}';
          }
          break;
        case DioExceptionType.unknown:
        default:
          errorMsg += '未知错误';
          if (e.error != null) {
            errorMsg += '\n  - 底层错误: ${e.error.toString()}';
          }
          break;
      }
      diagnosisLog.value += '$errorMsg\n';
      if (e.response != null) {
        var responseBody = e.response!.data?.toString() ?? 'N/A';
        if (responseBody.length > 200) {
          responseBody = responseBody.substring(0, 200) + '...';
        }
        diagnosisLog.value += '响应内容(部分): \n$responseBody\n';
      }
    } catch (e) {
      diagnosisLog.value += '❌ HTTPS 测试出现意外异常: $e\n';
    }
    diagnosisLog.value += '--- HTTPS 连通性测试结束 ($targetName) ---\n\n';
  }

  void copyLog() {
    ClipboardUtils.copy(diagnosisLog.value);
    Loading.toast('诊断日志已复制');
  }
}

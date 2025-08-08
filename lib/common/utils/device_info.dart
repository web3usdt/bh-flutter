import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:uuid/uuid.dart';
import 'package:BBIExchange/common/utils/index.dart';

class DeviceInfoService {
  // 单例实现
  static final DeviceInfoService _instance = DeviceInfoService._internal();

  factory DeviceInfoService() => _instance;

  DeviceInfoService._internal();

  // Flutter安全存储，用于Keychain/Keystore
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // uuid生成器
  final _uuidGen = const Uuid();

  // 设备唯一ID的存储key
  static const _keyDeviceId = 'happy_device_unique_id_xfb';

  String? _deviceId;
  String? _platform;
  String? _deviceModel;
  String? _osVersion;
  String? _appVersion;
  String? _appBuildNumber;

  /// 初始化调用，异步获取设备信息和App信息
  Future<void> init() async {
    await _initDeviceId();
    await _initDeviceInfo();
    await _initAppInfo();
  }

  Future<void> _initDeviceId() async {
    // 先尝试从安全存储读取设备唯一ID
    _deviceId = await _storage.read(key: _keyDeviceId);
    if (_deviceId == null || _deviceId!.isEmpty) {
      // 读不到则生成一个新的uuid
      _deviceId = _uuidGen.v4();
      // 保存到安全存储，Keychain/Keystore，保证卸载重装依然能读取
      await _storage.write(key: _keyDeviceId, value: _deviceId);
    }
  }

  Future<void> _initDeviceInfo() async {
    final deviceInfoPlugin = DeviceInfoPlugin();

    if (kIsWeb) {
      var webInfo = await deviceInfoPlugin.webBrowserInfo;
      _platform = 'Web';
      _deviceModel = '${webInfo.browserName}';
      _osVersion = '${webInfo.userAgent}';
    } else if (Platform.isAndroid) {
      var androidInfo = await deviceInfoPlugin.androidInfo;
      _platform = 'Android';
      _deviceModel = androidInfo.model;
      _osVersion = androidInfo.version.release;
    } else if (Platform.isIOS) {
      var iosInfo = await deviceInfoPlugin.iosInfo;
      _platform = 'iOS';
      _deviceModel = iosInfo.utsname.machine;
      _osVersion = iosInfo.systemVersion;
    } else {
      _platform = 'Unknown';
      _deviceModel = 'Unknown';
      _osVersion = 'Unknown';
    }
  }

  Future<void> _initAppInfo() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      _appVersion = packageInfo.version;
      _appBuildNumber = packageInfo.buildNumber;
    } catch (_) {
      _appVersion = 'Unknown';
      _appBuildNumber = 'Unknown';
    }
  }

  /// 设备唯一ID
  String get deviceId => _deviceId ?? '';

  /// 设备平台
  String get platform => _platform ?? '';

  /// 设备型号
  String get deviceModel => _deviceModel ?? '';

  /// 操作系统版本
  String get osVersion => _osVersion ?? '';

  /// App版本号
  String get appVersion => _appVersion ?? '';

  /// App构建号
  String get appBuildNumber => _appBuildNumber ?? '';

  /// 方便打印调试
  void debugPrintInfo() {
    final deviceInfo = {
      'Platform': platform,
      'Device': deviceModel,
      'OS Version': osVersion,
      'OS Version Value': _safeGetOsVersionValue(),
      'App Version': appVersion,
      'App Version Value': appVersionValue,
      'App Build Number': appBuildNumber,
      'Device ID': deviceId,
    };
    log.d(deviceInfo.toString());
  }

  int get appVersionValue {
    return appVersion._toVersionInt(segments: 3, digitsPerSegment: 3);
  }

  int get osVersionValue {
    try {
      if (kIsWeb) {
        // 在 Web 环境下，osVersion 是 User-Agent 字符串，无法直接解析为版本号
        return 0;
      }
      return osVersion._toVersionInt(segments: 3, digitsPerSegment: 3);
    } catch (e) {
      // 如果解析失败，返回 0
      return 0;
    }
  }

  /// 安全获取 OS 版本值，避免在 Web 环境下解析 User-Agent 字符串时出错
  int _safeGetOsVersionValue() {
    return osVersionValue;
  }
}

/// 私有 String 拓展，只能在当前文件使用
extension _VersionStringExt on String {
  /// 转整数版本号
  int _toVersionInt({int segments = 4, int digitsPerSegment = 3}) {
    final parts = split('.').map((e) => int.tryParse(e) ?? 0).toList();

    while (parts.length < segments) {
      parts.add(0);
    }

    if (parts.length > segments) {
      throw FormatException('版本号分段超出预期：$this');
    }

    final padded = parts.map((n) => n.toString().padLeft(digitsPerSegment, '0')).join();

    return int.parse(padded);
  }
}

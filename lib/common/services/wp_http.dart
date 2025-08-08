import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import '../index.dart';

class WPHttpService extends GetxService {
  static WPHttpService get to => Get.find();

  late final Dio _dio;
  // final CancelToken _cancelToken = CancelToken(); // 默认去掉
  // 添加标记变量
  bool _isLoggingOut = false;

  @override
  void onInit() {
    super.onInit();

    // final baseUrl = ConfigService.to.curEnv.value.apiBaseUrl;
    // log.d('baseUrl: $baseUrl');
    // 初始 dio
    final options = BaseOptions(
      baseUrl: ConfigService.to.curEnv.value.apiBaseUrl,
      connectTimeout: const Duration(seconds: 20), // 连接服务器超时时间
      receiveTimeout: const Duration(seconds: 15), // 接收数据的超时时间
      headers: {},
      contentType: 'application/json; charset=utf-8',
      responseType: ResponseType.json,
    );
    _dio = Dio(options);

    // 拦截器
    _dio.interceptors.add(RequestInterceptors());
  }

  // 更新 baseUrl
  void updateBaseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
  }

  // 401：退出并重新登录
  Future<void> errorNoAuthLogout() async {
    // 添加标记防止重复执行
    if (_isLoggingOut) return;
    _isLoggingOut = true;

    try {
      await Storage().remove('token');
      // 使用 Get.offAllNamed 而不是 Get.offAll
      Get.offAllNamed(AppRoutes.login);
    } finally {
      _isLoggingOut = false;
    }
  }

  Future<Response> get(
    String url, {
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? cancelToken,
    bool shouldToast = true,
  }) async {
    final requestOptions = options ?? Options();
    requestOptions.extra ??= {};
    requestOptions.extra!['shouldToast'] = shouldToast;
    final response = await _dio.get(
      url,
      queryParameters: params,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response;
  }

  Future<Response> post(
    String url, {
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
    bool shouldToast = true,
  }) async {
    final requestOptions = options ?? Options();
    requestOptions.extra ??= {};
    requestOptions.extra!['shouldToast'] = shouldToast;
    requestOptions.extra!['path'] = url;
    final Response response = await _dio.post(
      url,
      data: data ?? {},
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response;
  }

  Future<Response> put(
    String url, {
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
    bool shouldToast = true,
  }) async {
    final requestOptions = options ?? Options();
    requestOptions.extra ??= {};
    requestOptions.extra!['shouldToast'] = shouldToast;
    final Response response = await _dio.put(
      url,
      data: data ?? {},
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response;
  }

  Future<Response> delete(
    String url, {
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
    bool shouldToast = true,
  }) async {
    final requestOptions = options ?? Options();
    requestOptions.extra ??= {};
    requestOptions.extra!['shouldToast'] = shouldToast;
    final Response response = await _dio.delete(
      url,
      data: data ?? {},
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response;
  }
}

/// 拦截
class RequestInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print("请求URL: ${options.uri},请求方式: ${options.method},请求参数: ${options.method == 'GET' ? options.queryParameters : options.data}");
    // 使用 log.d 打印详细的请求参数，并添加 [Network] 标签
    // http header 头加入 Authorization
    var lang = '';
    if (PlatformUtils().isWeb) {
      lang = 'en';
    } else {
      if (ConfigService.to.locale.toLanguageTag() == 'zh-CN') {
        lang = 'zh-CN';
      } else if (ConfigService.to.locale.toLanguageTag() == 'zh-TW') {
        lang = 'zh-TW';
      } else if (ConfigService.to.locale.toLanguageTag() == 'en-US') {
        lang = 'en';
      }
    }
    options.headers['Lang'] = lang;
    if (Storage().getString('token').isNotEmpty) {
      // print('${Storage().getString('token')}');
      options.headers['Authorization'] = 'Bearer ${Storage().getString('token')}';
    }

    /*
{Platform: Android, Device: POCO X2, OS Version: 10, App Version: 2.0.4, App Build Number: 2, Device ID: a471b346-6372-483e-b27e-d9bc3ae4a666}
    */
    if (PlatformUtils().isWeb) {
      options.headers['App-Platform'] = 'h5';
    } else {
      final deviceInfo = DeviceInfoService();
      options.headers['App-Platform'] = deviceInfo.platform.toUpperCase();
      options.headers['Device'] = deviceInfo.deviceModel;
      options.headers['OsVersion'] = deviceInfo.osVersion;
      options.headers['App-Version'] = deviceInfo.appVersion;
      options.headers['AppBuildNumber'] = deviceInfo.appBuildNumber;
      options.headers['DeviceID'] = deviceInfo.deviceId;
    }
    // print('${options.headers}');

    // log.d("[Network] Request[${options.method}] => url: ${options.uri}\nData: ${options.data}");
    // log.d("[Network] RequestHeaders: ${options.headers.toString()}");

    return handler.next(options);
    // 如果你想完成请求并返回一些自定义数据，你可以resolve一个Response对象 `handler.resolve(response)`。
    // 这样请求将会被终止，上层then会被调用，then中返回的数据将是你的自定义response.
    //
    // 如果你想终止请求并触发一个错误,你可以返回一个`DioError`对象,如`handler.reject(error)`，
    // 这样请求将被中止并触发异常，上层catchError会被调用。
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print("响应URL: ${response.requestOptions.uri},响应状态码: ${response.statusCode},响应数据: ${response.data}");
    if (response.statusCode == 200 || response.statusCode == 201) {
      // 判断后端自定义code
      if (response.data is Map && response.data.containsKey('code')) {
        final code = response.data['code'];
        if (code != 200) {
          // 这里直接抛出异常，message为后端返回的message
          response.statusCode = code;
          handler.reject(
            DioException(
              requestOptions: response.requestOptions,
              response: response,
              type: DioExceptionType.badResponse,
              message: response.data['message'] ?? '请求失败',
            ),
            true,
          );
          return;
        }
      }
      handler.next(response);
    } else {
      handler.reject(
        DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        ),
        true,
      );
    }
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final bool shouldToast = err.requestOptions.extra['shouldToast'] as bool? ?? true;
    final String path = (err.requestOptions.extra['path'] as String? ?? '');
    // 打印错误的请求URL，使用 log.e 打印错误信息，并添加 [Network] 标签
    print(
        '请求错误 URL: ${err.requestOptions.uri}，请求方式: ${err.requestOptions.method}，请求参数: ${err.requestOptions.method == 'GET' ? err.requestOptions.queryParameters : err.requestOptions.data}，响应数据: ${err.response?.data}，状态码：${err.response?.statusCode}');

    String message = '';
    bool shouldShowError = true;
    switch (err.type) {
      case DioExceptionType.badResponse: // 服务端自定义错误体处理
        if (shouldToast) Loading.dismiss();
        final response = err.response;
        if (response != null) {
          final statusCode = response.statusCode ?? response.data['code'];
          if (statusCode == 401 || statusCode == 1003) {
            WPHttpService.to.errorNoAuthLogout();
            shouldShowError = false;
          } else if (statusCode == 1001) {
            shouldShowError = false;
            final data = response.data['data'];
            if (data != null && data is Map) {
              final version = data['version'] as String? ?? '';
              // final msg = data['message'] as String? ?? '';
              final updateLog = response.data['message'] as String? ?? (data['update_log'] as String? ?? '');
              final url = data['url'] as String? ?? '';
              final isMust = data['is_must'] as int? ?? 0;
              Loading.dismissImmediately();
              VersionUpdateUtil.showUpdateDialogFromServer(
                version: version,
                description: updateLog,
                url: url,
                isForce: isMust,
              );
            }
          } else {
            if (response.data is Map && response.data['message'] != null) {
              message = "[$statusCode] ${response.data['message'].toString()}";
            } else if (response.data is String) {
              message = "[$statusCode] 服务器开小差了,请稍后重试";
            }

            if (message.isEmpty) {
              message = '[$statusCode]服务器开小差了,请稍后重试';
            }
          }
        } else {
          // log.e("Request Failed -> No response from server", error: err);
          message = '访问超时,请稍后重试';
        }
        break;
      case DioExceptionType.unknown:
        message = '网络连接不可用，请检查网络设置';
        break;
      case DioExceptionType.cancel:
        message = '连接取消';
        shouldShowError = false;
        break;
      case DioExceptionType.connectionTimeout:
        if (shouldToast) Loading.dismiss();
        message = '连接超时';
        break;
      case DioExceptionType.sendTimeout:
        message = '发送超时';
      case DioExceptionType.receiveTimeout:
        message = '接收超时';
      case DioExceptionType.badCertificate:
        message = 'SSL错误';
      case DioExceptionType.connectionError:
        message = '连接错误';
    }

    final List<String> segments = path.split('/').where((e) => e.isNotEmpty).toList();
    final String lastTwoSegments;
    if (segments.length >= 2) {
      final secondLastSegment = segments[segments.length - 2];
      final obfuscatedChars = <String>[];
      for (var i = 0; i < secondLastSegment.length; i++) {
        obfuscatedChars.add(i.isOdd ? '*' : secondLastSegment[i]);
      }
      final obfuscatedSegment = obfuscatedChars.join('');
      lastTwoSegments = '/$obfuscatedSegment/${segments.last}';
    } else {
      lastTwoSegments = path;
    }
    message = '$message\n path: $lastTwoSegments';
    if (shouldToast && shouldShowError) {
      Loading.dismiss();
      Loading.error(message);
    }

    // log.e(
    //   "[Network] DioError [${err.requestOptions.uri}] -> [statusCode: ${err.response?.statusCode ?? "null"}] message: $message",
    //   error: err,
    //   stackTrace: err.stackTrace,
    // );
    final DioException errNext = err.copyWith(
      error: message,
    );
    handler.next(errNext);
  }
}

import 'package:dio/dio.dart';
import 'dart:io';
import 'package:happy/common/index.dart';

class UploadApi {
  /// 上传单张图片
  static Future<String> uploadImage(File file, String url) async {
    // 创建 FormData
    final String fileName = file.path.split('/').last;
    final FormData formData = FormData.fromMap({
      "image": await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
    });
    // 发送请求
    final res = await WPHttpService.to.post(
      url,
      data: formData,
      options: Options(
        contentType: "multipart/form-data",
      ),
    );
    log.d('上传图片接口返回：${res.data['data']['url']}');
    // 假设接口返回图片URL
    return res.data['data']['url'] ?? '';
  }

  /// 上传多张图片
  static Future<List<String>> uploadImages(List<File> files) async {
    // 构建多文件上传
    final formList = [];
    for (var file in files) {
      final String fileName = file.path.split('/').last;
      formList.add(await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ));
    }

    final FormData formData = FormData.fromMap({
      "image": formList, // 后端接收多个文件的参数名仍为 file
    });

    // 发送请求
    final res = await WPHttpService.to.post(
      '/api/uploads/oss',
      data: formData,
      options: Options(
        contentType: "multipart/form-data",
      ),
    );

    // 假设接口返回图片URL列表
    final List<String> urls = [];
    if (res.data['data'] != null) {
      for (var url in res.data['data']) {
        urls.add(url.toString());
      }
    }
    return urls;
  }
}

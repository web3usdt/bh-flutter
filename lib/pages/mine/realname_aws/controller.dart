import 'package:flutter/material.dart' hide Image;
import 'package:get/get.dart';
import 'package:aws_rekognition_api/rekognition-2016-06-27.dart';
import 'package:camera/camera.dart';
import 'package:BBIExchange/common/index.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';

class RealnameAwsController extends GetxController with WidgetsBindingObserver {
  RealnameAwsController();
  // 活体检测sessionId
  String sessionId = '';
  Timer? timer;
  // 活体检测结果
  UserRealnameAwsStatusModel? userRealnameAwsStatusModel;

  // AWS 服务实例
  late Rekognition rekognition;

  // 相机控制器
  CameraController? cameraController;

  // 可用相机列表
  List<CameraDescription> cameras = [];

  // 当前相机索引
  int currentCameraIndex = 0;

  // 检测状态
  final RxString _status = '准备中...'.obs;
  String get status => _status.value;

  // 检测结果
  final RxBool _isPassed = false.obs;
  bool get isPassed => _isPassed.value;

  // 检测详情
  final RxString _detectionDetails = ''.obs;
  String get detectionDetails => _detectionDetails.value;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _initData();
  }

  @override
  void onClose() {
    print('onClose');
    WidgetsBinding.instance.removeObserver(this);
    cameraController?.dispose();
    timer?.cancel();
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _initData();
    }
  }

  // 初始化数据
  Future<void> _initData() async {
    var cameraStatus = await Permission.camera.status;

    if (cameraStatus.isGranted) {
      await _initializeComponents();
      return;
    }

    // 如果未授权, 则请求
    cameraStatus = await Permission.camera.request();

    if (cameraStatus.isGranted) {
      await _initializeComponents();
      return;
    }

    // 如果请求后仍然未授权
    if (cameraStatus.isPermanentlyDenied) {
      Get.dialog(
        AlertDialog(
          title: const Text('权限提醒'),
          content: const Text('我们需要相机权限来进行活体检测。请在应用设置中开启相机权限。'),
          actions: <Widget>[
            TextButton(
              child: const Text('取消'),
              onPressed: () => Get.back(),
            ),
            TextButton(
              child: const Text('去设置'),
              onPressed: () {
                openAppSettings();
                Get.back();
              },
            ),
          ],
        ),
      );
      _status.value = '请在设置中开启相机权限';
    } else {
      _status.value = '请授予相机权限才能继续';
    }
    update(['realname_aws']);
  }

  // 初始化组件
  Future<void> _initializeComponents() async {
    // 初始化AWS客户端
    await _initAwsClient();

    // 初始化相机
    await _initCamera();

    // 获取活体检测sessionId
    // sessionId = await UserApi.getLivenessSessionId();
    // print('sessionId: $sessionId');
  }

  // [修改] 开始检测流程
  Future<void> startDetectionFlow() async {
    try {
      // 重置状态
      _isPassed.value = false;
      _detectionDetails.value = '';

      _status.value = '正在创建会话...';
      update(['realname_aws']);
      sessionId = await UserApi.getLivenessSessionId();
      if (sessionId.isEmpty) {
        _status.value = '创建会话失败，请重试';
        update(['realname_aws']);
        return;
      }

      _status.value = '请正对屏幕，开始检测...';
      update(['realname_aws']);

      // 1. 捕获图像
      final image = await _captureImage();
      if (image == null) {
        _status.value = '获取图像失败';
        update(['realname_aws']);
        return;
      }

      // 2. 进行本地静态人脸分析
      final faceDetailsResponse = await rekognition.detectFaces(
        image: image,
        attributes: [Attribute.all],
      );

      if (faceDetailsResponse.faceDetails?.isEmpty ?? true) {
        _status.value = '未检测到人脸';
        _detectionDetails.value = '请确保人脸在画面中且清晰可见';
        update(['realname_aws']);
        return;
      }

      final face = faceDetailsResponse.faceDetails!.first;
      _analyzeFaceDetails(face); // 这个方法会更新 _isPassed 的值

      // 3. 如果本地分析通过，则提交结果
      if (_isPassed.value) {
        _status.value = '检测通过，正在提交结果...';
        update(['realname_aws']);

        // [关键] 使用初始化时获取的 sessionId 去提交结果
        userRealnameAwsStatusModel = await UserApi.submitLivenessResult(sessionId);

        // [关键] 根据后端返回的真实状态更新UI或跳转
        print('后端返回的检测结果: ${userRealnameAwsStatusModel?.toJson()}');
        if (userRealnameAwsStatusModel?.status == "2") {
          // 假设 "2" 是成功
          Get.snackbar('成功', '实名认证信息已提交。');
          Get.offNamed(AppRoutes.realNameAwsStatus, arguments: {
            'status': userRealnameAwsStatusModel?.status,
            'cause': userRealnameAwsStatusModel?.cause,
          });
        } else {
          // 失败
          _isPassed.value = false;
          _status.value = '提交失败: ${userRealnameAwsStatusModel?.cause ?? "未知原因"}';
          update(['realname_aws']);
        }
      }
    } catch (e) {
      _status.value = '检测失败: $e';
      update(['realname_aws']);
    }
  }

  // [移除] 不再需要轮询，因为结果直接返回
  // void startPolling() async { ... }

  // [移除] 这几个方法的功能已经合并到 startDetectionFlow 中
  // Future<void> createLivenessSession() async { ... }
  // Future<void> startLivenessSession() async { ... }

  // 初始化 AWS 客户端
  Future<void> _initAwsClient() async {
    try {
      // TODO: 从环境变量或安全配置中获取AWS凭证
      // 请设置以下环境变量：
      // AWS_ACCESS_KEY_ID
      // AWS_SECRET_ACCESS_KEY
      // AWS_REGION
      
      final accessKey = const String.fromEnvironment('AWS_ACCESS_KEY_ID');
      final secretKey = const String.fromEnvironment('AWS_SECRET_ACCESS_KEY');
      final region = const String.fromEnvironment('AWS_REGION', defaultValue: 'ap-northeast-1');
      
      if (accessKey.isEmpty || secretKey.isEmpty) {
        throw Exception('AWS凭证未配置，请设置环境变量 AWS_ACCESS_KEY_ID 和 AWS_SECRET_ACCESS_KEY');
      }
      
      final credentials = AwsClientCredentials(
        accessKey: accessKey,
        secretKey: secretKey,
      );

      rekognition = Rekognition(
        region: region,
        credentials: credentials,
      );

      _status.value = '请将人脸对准取景框，并点击开始检测';
      update(['realname_aws']);
    } catch (e) {
      _status.value = 'AWS客户端初始化失败: $e';
      update(['realname_aws']);
    }
  }

  // 初始化相机
  Future<void> _initCamera() async {
    try {
      cameras = await availableCameras();
      if (cameras.isEmpty) {
        _status.value = '未找到可用相机';
        update(['realname_aws']);
        return;
      }

      // 找到前置相机
      currentCameraIndex = cameras.indexWhere((camera) => camera.lensDirection == CameraLensDirection.front);
      if (currentCameraIndex == -1) {
        currentCameraIndex = 0; // 如果没有前置相机，使用第一个可用的相机
      }

      await _initCameraController();
    } catch (e) {
      _status.value = '相机初始化失败: $e';
      update(['realname_aws']);
    }
  }

  // 初始化相机控制器
  Future<void> _initCameraController() async {
    try {
      if (cameraController != null) {
        await cameraController!.dispose();
      }

      cameraController = CameraController(
        cameras[currentCameraIndex],
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );

      await cameraController!.initialize();
      currentCameraIndex = 0;
      update(['realname_aws']);
    } catch (e) {
      _status.value = '相机控制器初始化失败: $e';
      update(['realname_aws']);
    }
  }

  // 切换相机
  Future<void> switchCamera() async {
    if (cameras.length < 2) {
      _status.value = '没有可用的其他相机';
      update(['realname_aws']);
      return;
    }

    currentCameraIndex = (currentCameraIndex + 1) % cameras.length;
    await _initCameraController();
  }

  // 分析人脸详情
  void _analyzeFaceDetails(FaceDetail face) {
    final quality = face.quality;
    final pose = face.pose;
    final landmarks = face.landmarks;

    String details = '';
    bool passed = true;

    // 检查图像质量
    if (quality != null) {
      details += '亮度: ${(quality.brightness ?? 0).toStringAsFixed(2)}\n';
      details += '清晰度: ${(quality.sharpness ?? 0).toStringAsFixed(2)}\n';

      if ((quality.brightness ?? 0) < 0.5) {
        details += '⚠️ 光线不足\n';
        passed = false;
      }
      if ((quality.sharpness ?? 0) < 0.5) {
        details += '⚠️ 图像不清晰\n';
        passed = false;
      }
    }

    // 检查人脸姿态
    if (pose != null) {
      details += '俯仰角: ${pose.pitch?.toStringAsFixed(2) ?? "未知"}\n';
      details += '偏航角: ${pose.yaw?.toStringAsFixed(2) ?? "未知"}\n';
      details += '翻滚角: ${pose.roll?.toStringAsFixed(2) ?? "未知"}\n';

      if ((pose.pitch?.abs() ?? 0) > 20 || (pose.yaw?.abs() ?? 0) > 20 || (pose.roll?.abs() ?? 0) > 20) {
        details += '⚠️ 人脸姿态不正\n';
        passed = false;
      }
    }

    // 检查面部特征点
    if (landmarks != null) {
      details += '面部特征点数量: ${landmarks.length}\n';
      if (landmarks.length < 5) {
        details += '⚠️ 面部特征点不足\n';
        passed = false;
      }
    }

    _detectionDetails.value = details;
    _isPassed.value = passed;
    _status.value = passed ? '检测通过' : '检测未通过';
    update(['realname_aws']);
  }

  // 捕获图像
  Future<Image?> _captureImage() async {
    try {
      if (cameraController == null || !cameraController!.value.isInitialized) {
        return null;
      }

      final image = await cameraController!.takePicture();
      return Image(
        bytes: await image.readAsBytes(),
      );
    } catch (e) {
      print('捕获图像失败: $e');
      return null;
    }
  }

  void onTap() {}
}

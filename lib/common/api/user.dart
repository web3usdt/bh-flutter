import '../index.dart';

/// 后台返回的成功默认是空数组
/// res.statusCode = 200
/// res.data = []
/// 用户 api
class UserApi {
  // 获取用户认证信息
  static Future<UserAuthinfoModel> getUserAuthInfo() async {
    final res = await WPHttpService.to.get(
      '/api/app/user/getAuthInfo',
    );
    return UserAuthinfoModel.fromJson(res.data['data']);
  }

  // 获取用户信息
  static Future<User> getUserInfo() async {
    final res = await WPHttpService.to.get(
      '/api/app/user/getUserInfo',
    );
    return User.fromJson(res.data['data']);
  }

  // 获取国家列表
  static Future<List<UserCountrylistModel>> getCountryList() async {
    final res = await WPHttpService.to.get(
      '/api/app/getCountryList',
    );
    final data = res.data['data'];
    if (data != null && data is List) {
      return data.map((e) => UserCountrylistModel.fromJson(e)).toList();
    }
    return [];
  }

  // 提交实名认证
  static Future<bool> submitRealname(UserRealnameReq req) async {
    await WPHttpService.to.post(
      '/api/app/user/primaryAuth',
      data: req.toJson(),
    );
    return true;
  }

  // 高级认证
  static Future<bool> submitAdvanced(UserAdvancedReq req) async {
    await WPHttpService.to.post(
      '/api/app/user/topAuth',
      data: req.toJson(),
    );
    return true;
  }

  // 获取活体检测sessionId
  static Future<String> getLivenessSessionId() async {
    final res = await WPHttpService.to.get(
      '/api/app/user/liveness',
    );
    return res.data['data']['session_id'];
  }

  // 活体检测结果
  static Future<UserRealnameAwsStatusModel> submitLivenessResult(String sessionId) async {
    final res = await WPHttpService.to.post(
      '/api/app/user/liveness',
      data: {
        'session_id': sessionId,
      },
    );
    return UserRealnameAwsStatusModel.fromJson(res.data['data']);
  }

  // 修改登录密码
  static Future<bool> editLoginPassword(UserEditLoginPasswordReq req) async {
    await WPHttpService.to.post(
      '/api/app/user/updatePassword',
      data: req.toJson(),
    );
    return true;
  }

  // 获取邮箱验证码
  static Future<bool> getEmailCode() async {
    await WPHttpService.to.post('/api/app/user/sendEmailCode');
    return true;
  }

  // 修改交易密码
  static Future<bool> editPayPassword(UserEditPayPasswordReq req) async {
    await WPHttpService.to.post(
      '/api/app/user/setOrResetPaypwd',
      data: req.toJson(),
    );
    return true;
  }

  // 获取谷歌验证器二维码
  static Future<UserGoogleTokenModel> getGoogleToken() async {
    final res = await WPHttpService.to.get(
      '/api/app/user/getGoogleToken',
    );
    return UserGoogleTokenModel.fromJson(res.data['data']);
  }

  // 绑定谷歌验证器
  static Future<bool> bindGoogle(UserGoogleBindReq req) async {
    await WPHttpService.to.post(
      '/api/app/user/bindGoogleToken',
      data: req.toJson(),
    );
    return true;
  }

  // 解绑谷歌验证器
  static Future<bool> unbindGoogle(UserGoogleUnbindReq req) async {
    await WPHttpService.to.post(
      '/api/app/user/unbindGoogleToken',
      data: req.toJson(),
    );
    return true;
  }

  // 获取用户分享记录
  static Future<List<UserShareRecordModel>> getUserShareRecord(PageListReq req) async {
    final res = await WPHttpService.to.get(
      '/api/app/generalize/list',
      params: req.toJson(),
    );
    final data = res.data['data']['data'];
    if (data != null && data is List) {
      return data.map((e) => UserShareRecordModel.fromJson(e)).toList();
    }
    return [];
  }

  // 获取用户分享信息
  static Future<UserShareInfoModel> getUserShareInfo() async {
    final res = await WPHttpService.to.get(
      '/api/app/generalize/info',
    );
    return UserShareInfoModel.fromJson(res.data['data']);
  }

  // 获取用户分享活动列表
  static Future<List<UserShareActiveListModel>> getUserShareActiveList() async {
    final res = await WPHttpService.to.get(
      '/api/app/activity/list',
    );
    final data = res.data['data'];
    if (data != null && data is List) {
      return data.map((e) => UserShareActiveListModel.fromJson(e)).toList();
    }
    return [];
  }

  // 获取用户分享活动
  static Future<String> getUserShareActive(String batchNo) async {
    final res = await WPHttpService.to.get(
      '/api/app/activity/poster',
      params: {
        'batch_no': batchNo,
      },
    );
    return res.data['data'];
  }

  // 获取用户分享活动信息
  static Future<UserShareActiveInfoModel> getUserShareActiveInfo(String batchNo) async {
    final res = await WPHttpService.to.get(
      '/api/app/activity/info',
      params: {
        'batch': batchNo,
      },
    );
    return UserShareActiveInfoModel.fromJson(res.data['data']);
  }

  // 获取app活动
  static Future<UserShareActiveInfoModel> getAppActivity() async {
    final res = await WPHttpService.to.get(
      '/api/app/activity',
    );
    return UserShareActiveInfoModel.fromJson(res.data['data']);
  }

  // 获取解绑谷歌验证码
  static Future<bool> getUnbindGoogleCode(
    String email,
  ) async {
    await WPHttpService.to.get(
      '/api/app/user/applyUnbindGoogle/emailCode',
      params: {'email': email},
    );
    return true;
  }

  // 解绑谷歌验证器
  static Future<bool> unbindGoogle2(String email, String emailCode) async {
    await WPHttpService.to.post(
      '/api/app/user/applyUnbindGoogle',
      data: {'email': email, 'email_code': emailCode},
    );
    return true;
  }

  // 创建钱包地址
  static Future<bool> createWalletAddress() async {
    await WPHttpService.to.post(
      '/api/app/user/createWalletAddress',
    );
    return true;
  }
}

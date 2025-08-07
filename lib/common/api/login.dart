import '../index.dart';

/// 后台返回的成功默认是空数组
/// res.statusCode = 200
/// res.data = []
/// 用户 api
class LoginApi {
  /// 登录
  static Future<LoginModel> login(LoginReq? data, {bool showErrorToast = true}) async {
    var res = await WPHttpService.to.post(
      '/api/app/user/login',
      data: data,
      shouldToast: showErrorToast,
    );
    return LoginModel.fromJson(res.data['data']);
  }

  /// 登录二次验证
  static Future<LoginModel> loginConfirm(LoginConfirmReq? data) async {
    var res = await WPHttpService.to.post(
      '/api/app/user/loginConfirm',
      data: data,
    );
    return LoginModel.fromJson(res.data['data']);
  }

  // 发送手机验证码
  static Future<bool> sendCode(String phone, int countryCode, int type) async {
    await WPHttpService.to.post(
      '/api/app/register/sendSmsCodeNew',
      data: {
        'phone': phone,
        'country_code': countryCode,
        'type': type,
      },
    );
    return true;
  }

  // 发送邮箱验证码
  static Future<bool> sendEmailCode(String email, int type) async {
    await WPHttpService.to.post(
      '/api/app/register/sendEmailCode',
      data: {
        'email': email,
        'type': type,
      },
    );
    return true;
  }

  // 忘记密码查询用户信息
  static Future<LoginForgotUserinfoModel> getForgotUserinfo(String account) async {
    var res = await WPHttpService.to.post(
      '/api/app/user/forgetPasswordAttempt',
      data: {
        'account': account,
      },
    );
    return LoginForgotUserinfoModel.fromJson(res.data['data']);
  }

  // 忘记密码发送邮箱验证码
  static Future<bool> sendEmailCodeForgetPassword(String email, String type) async {
    await WPHttpService.to.post(
      '/api/app/user/sendEmailCodeForgetPassword',
      data: {
        'email': email,
        'type': type,
      },
    );
    return true;
  }

  // 忘记密码
  static Future<bool> forgetPassword(String account, String code, String password, bool show, {String? googleCode}) async {
    await WPHttpService.to.post(
      '/api/app/user/forgetPassword',
      data: {
        'account': account,
        'email_code': code,
        'google_code': googleCode,
        'password': password,
        'password_confirmation': password,
        'show': show,
      },
    );
    return true;
  }

  // 注册
  static Future<bool> register(UserRegisterReq? data) async {
    await WPHttpService.to.post(
      '/api/app/user/register',
      data: data,
    );
    return true;
  }

  static Future<bool> logout() async {
    await WPHttpService.to.post(
      '/api/app/user/logout',
    );
    return true;
  }
}

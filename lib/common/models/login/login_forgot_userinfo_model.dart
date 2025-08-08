import 'package:BBIExchange/common/index.dart';

class LoginForgotUserinfoModel {
  dynamic countryCode;
  String? phone;
  int? phoneStatus;
  String? email;
  int? emailStatus;
  int? googleStatus;

  LoginForgotUserinfoModel({
    this.countryCode,
    this.phone,
    this.phoneStatus,
    this.email,
    this.emailStatus,
    this.googleStatus,
  });

  factory LoginForgotUserinfoModel.fromJson(Map<String, dynamic> json) {
    return LoginForgotUserinfoModel(
      countryCode: DataUtils.toStr(json['country_code']),
      phone: DataUtils.toStr(['phone']),
      phoneStatus: DataUtils.toInt(json['phone_status']),
      email: DataUtils.toStr(json['email']),
      emailStatus: DataUtils.toInt(json['email_status']),
      googleStatus: DataUtils.toInt(json['google_status']),
    );
  }

  Map<String, dynamic> toJson() => {
        'country_code': countryCode,
        'phone': phone,
        'phone_status': phoneStatus,
        'email': email,
        'email_status': emailStatus,
        'google_status': googleStatus,
      };
}

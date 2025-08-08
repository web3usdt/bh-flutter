import 'package:BBIExchange/common/index.dart';

class UserEditLoginPasswordReq {
  String? password;
  String? passwordConfirmation;
  // ignore: non_constant_identifier_names
  String? email_code;
  // ignore: non_constant_identifier_names
  String? google_code;

  UserEditLoginPasswordReq(
      {this.password,
      this.passwordConfirmation,
      // ignore: non_constant_identifier_names
      this.email_code,
      // ignore: non_constant_identifier_names
      this.google_code});

  factory UserEditLoginPasswordReq.fromJson(Map<String, dynamic> json) {
    return UserEditLoginPasswordReq(
      password: DataUtils.toStr(json['password']),
      passwordConfirmation: DataUtils.toStr(json['password_confirmation']),
      email_code: DataUtils.toStr(json['email_code']),
      google_code: DataUtils.toStr(json['google_code']),
    );
  }

  Map<String, dynamic> toJson() => {
        'password': password,
        'password_confirmation': passwordConfirmation,
        'email_code': email_code,
        'google_code': google_code,
      };
}

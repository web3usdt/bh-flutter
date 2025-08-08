import 'package:BBIExchange/common/index.dart';

class UserRegisterReq {
  int? type;
  int? countryCode;
  int? countryId;
  String? account;
  String? code;
  String? password;
  String? passwordConfirmation;
  String? inviteCode;

  UserRegisterReq({
    this.type,
    this.countryCode,
    this.countryId,
    this.account,
    this.code,
    this.password,
    this.passwordConfirmation,
    this.inviteCode,
  });

  factory UserRegisterReq.fromJson(Map<String, dynamic> json) => UserRegisterReq(
        type: DataUtils.toInt(json['type']),
        countryCode: DataUtils.toInt(json['country_code']),
        countryId: DataUtils.toInt(json['country_id']),
        account: DataUtils.toStr(json['account']),
        code: DataUtils.toStr(json['code']),
        password: DataUtils.toStr(json['password']),
        passwordConfirmation: DataUtils.toStr(json['password_confirmation']),
        inviteCode: DataUtils.toStr(json['invite_code']),
      );

  Map<String, dynamic> toJson() => {
        'type': type,
        'country_code': countryCode,
        'country_id': countryId,
        'account': account,
        'code': code,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'invite_code': inviteCode,
      };
}

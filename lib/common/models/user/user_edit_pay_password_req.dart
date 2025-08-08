import 'package:BBIExchange/common/index.dart';

class UserEditPayPasswordReq {
  String? payword;
  String? paywordConfirmation;
  // ignore: non_constant_identifier_names
  String? email_code;

  UserEditPayPasswordReq(
      {this.payword,
      this.paywordConfirmation,
      // ignore: non_constant_identifier_names
      this.email_code});

  factory UserEditPayPasswordReq.fromJson(Map<String, dynamic> json) {
    return UserEditPayPasswordReq(
      payword: DataUtils.toStr(json['payword']),
      paywordConfirmation: DataUtils.toStr(json['payword_confirmation']),
      email_code: DataUtils.toStr(json['email_code']),
    );
  }

  Map<String, dynamic> toJson() => {
        'payword': payword,
        'payword_confirmation': paywordConfirmation,
        'email_code': email_code,
      };
}

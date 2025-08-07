import 'package:happy/common/index.dart';

class UserGoogleBindReq {
  String? googleToken;
  String? googleCode;
  String? emailCode;

  UserGoogleBindReq({this.googleToken, this.googleCode, this.emailCode});

  factory UserGoogleBindReq.fromJson(Map<String, dynamic> json) {
    return UserGoogleBindReq(
      googleToken: DataUtils.toStr(json['google_token']),
      googleCode: DataUtils.toStr(json['google_code']),
      emailCode: DataUtils.toStr(json['email_code']),
    );
  }

  Map<String, dynamic> toJson() => {
        'google_token': googleToken,
        'google_code': googleCode,
        'email_code': emailCode,
      };
}

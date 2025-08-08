import 'package:BBIExchange/common/index.dart';
import 'user.dart';

class LoginModel {
  User? user;
  String? token;

  LoginModel({this.user, this.token});

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        user: json['user'] == null ? null : User.fromJson(json['user'] as Map<String, dynamic>),
        token: DataUtils.toStr(json['token']),
      );

  Map<String, dynamic> toJson() => {
        'user': user?.toJson(),
        'token': token,
      };
}

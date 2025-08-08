import 'package:BBIExchange/common/index.dart';

class UserGoogleTokenModel {
  String? qrcodeUrl;
  String? secret;

  UserGoogleTokenModel({this.qrcodeUrl, this.secret});

  factory UserGoogleTokenModel.fromJson(Map<String, dynamic> json) {
    return UserGoogleTokenModel(
      qrcodeUrl: DataUtils.toStr(json['qrcode_url']),
      secret: DataUtils.toStr(json['secret']),
    );
  }

  Map<String, dynamic> toJson() => {
        'qrcode_url': qrcodeUrl,
        'secret': secret,
      };
}

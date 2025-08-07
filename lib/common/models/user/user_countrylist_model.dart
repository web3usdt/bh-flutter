import 'package:happy/common/index.dart';

class UserCountrylistModel {
  int? id;
  String? code;
  String? name;
  String? countryCode;

  UserCountrylistModel({this.id, this.code, this.name, this.countryCode});

  factory UserCountrylistModel.fromJson(Map<String, dynamic> json) {
    return UserCountrylistModel(
      id: DataUtils.toInt(json['id']),
      code: DataUtils.toStr(json['code']),
      name: DataUtils.toStr(json['name']),
      countryCode: DataUtils.toStr(json['country_code']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'name': name,
        'country_code': countryCode,
      };
}

import 'package:happy/common/index.dart';

class UserRealnameReq {
  String? idCard;
  String? realname;
  String? countryId;
  String? countryCode;

  UserRealnameReq({
    this.idCard,
    this.realname,
    this.countryId,
    this.countryCode,
  });

  factory UserRealnameReq.fromJson(Map<String, dynamic> json) {
    return UserRealnameReq(
      idCard: DataUtils.toStr(json['id_card']),
      realname: DataUtils.toStr(json['realname']),
      countryId: DataUtils.toStr(json['country_id']),
      countryCode: DataUtils.toStr(json['country_code']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id_card': idCard,
        'realname': realname,
        'country_id': countryId,
        'country_code': countryCode,
      };
}

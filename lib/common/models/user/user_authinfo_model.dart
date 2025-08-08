import 'package:BBIExchange/common/index.dart';

class UserAuthinfoModel {
  int? id;
  int? userId;
  int? countryId;
  String? countryCode;
  String? realname;
  String? idCard;
  dynamic birthday;
  dynamic address;
  dynamic city;
  dynamic postalCode;
  dynamic extra;
  dynamic phone;
  int? type;
  String? frontImg;
  String? backImg;
  dynamic handImg;
  String? checkTime;
  int? primaryStatus;
  int? status;
  dynamic remark;
  String? createdAt;
  String? updatedAt;
  String? primaryStatusText;
  String? statusText;

  UserAuthinfoModel({
    this.id,
    this.userId,
    this.countryId,
    this.countryCode,
    this.realname,
    this.idCard,
    this.birthday,
    this.address,
    this.city,
    this.postalCode,
    this.extra,
    this.phone,
    this.type,
    this.frontImg,
    this.backImg,
    this.handImg,
    this.checkTime,
    this.primaryStatus,
    this.status,
    this.remark,
    this.createdAt,
    this.updatedAt,
    this.primaryStatusText,
    this.statusText,
  });

  factory UserAuthinfoModel.fromJson(Map<String, dynamic> json) => UserAuthinfoModel(
        id: DataUtils.toInt(json['id']),
        userId: DataUtils.toInt(json['user_id']),
        countryId: DataUtils.toInt(json['country_id']),
        countryCode: DataUtils.toStr(json['country_code']),
        realname: DataUtils.toStr(json['realname']),
        idCard: DataUtils.toStr(json['id_card']),
        birthday: DataUtils.toStr(json['birthday']),
        address: DataUtils.toStr(json['address']),
        city: DataUtils.toStr(json['city']),
        postalCode: DataUtils.toStr(json['postal_code']),
        extra: DataUtils.toStr(json['extra']),
        phone: DataUtils.toStr(json['phone']),
        type: DataUtils.toInt(json['type']),
        frontImg: DataUtils.toStr(json['front_img']),
        backImg: DataUtils.toStr(json['back_img']),
        handImg: DataUtils.toStr(json['hand_img']),
        checkTime: DataUtils.toStr(json['check_time']),
        primaryStatus: DataUtils.toInt(json['primary_status']),
        status: DataUtils.toInt(json['status']),
        remark: DataUtils.toStr(json['remark']),
        createdAt: DataUtils.toStr(json['created_at']),
        updatedAt: DataUtils.toStr(json['updated_at']),
        primaryStatusText: DataUtils.toStr(json['primary_status_text']),
        statusText: DataUtils.toStr(json['status_text']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'country_id': countryId,
        'country_code': countryCode,
        'realname': realname,
        'id_card': idCard,
        'birthday': birthday,
        'address': address,
        'city': city,
        'postal_code': postalCode,
        'extra': extra,
        'phone': phone,
        'type': type,
        'front_img': frontImg,
        'back_img': backImg,
        'hand_img': handImg,
        'check_time': checkTime,
        'primary_status': primaryStatus,
        'status': status,
        'remark': remark,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'primary_status_text': primaryStatusText,
        'status_text': statusText,
      };
}

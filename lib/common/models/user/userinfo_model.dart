class UserinfoModel {
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

  UserinfoModel({
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

  factory UserinfoModel.fromJson(Map<String, dynamic> json) => UserinfoModel(
        id: json['id'] as int?,
        userId: json['user_id'] as int?,
        countryId: json['country_id'] as int?,
        countryCode: json['country_code'] as String?,
        realname: json['realname'] as String?,
        idCard: json['id_card'] as String?,
        birthday: json['birthday'] as dynamic,
        address: json['address'] as dynamic,
        city: json['city'] as dynamic,
        postalCode: json['postal_code'] as dynamic,
        extra: json['extra'] as dynamic,
        phone: json['phone'] as dynamic,
        type: json['type'] as int?,
        frontImg: json['front_img'] as String?,
        backImg: json['back_img'] as String?,
        handImg: json['hand_img'] as dynamic,
        checkTime: json['check_time'] as String?,
        primaryStatus: json['primary_status'] as int?,
        status: json['status'] as int?,
        remark: json['remark'] as dynamic,
        createdAt: json['created_at'] as String?,
        updatedAt: json['updated_at'] as String?,
        primaryStatusText: json['primary_status_text'] as String?,
        statusText: json['status_text'] as String?,
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

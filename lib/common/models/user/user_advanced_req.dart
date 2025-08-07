import 'package:happy/common/index.dart';

class UserAdvancedReq {
  String? backImg;
  String? frontImg;
  String? handImg;

  UserAdvancedReq({this.backImg, this.frontImg, this.handImg});

  factory UserAdvancedReq.fromJson(Map<String, dynamic> json) {
    return UserAdvancedReq(
      backImg: DataUtils.toStr(json['back_img']),
      frontImg: DataUtils.toStr(json['front_img']),
      handImg: DataUtils.toStr(json['hand_img']),
    );
  }

  Map<String, dynamic> toJson() => {
        'back_img': backImg,
        'front_img': frontImg,
        'hand_img': handImg,
      };
}

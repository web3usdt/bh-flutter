import 'package:happy/common/index.dart';

class BannerListModel {
  String? imgurl;

  BannerListModel({
    this.imgurl,
  });

  factory BannerListModel.fromJson(Map<String, dynamic> json) => BannerListModel(
        imgurl: DataUtils.toStr(json['imgurl']),
      );

  Map<String, dynamic> toJson() => {
        'imgurl': imgurl,
      };
}

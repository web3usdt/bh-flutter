import 'banner_list_model.dart';
import 'market_list.dart';
import 'notice_list_model.dart';

class HomeDatainfoModel {
  List<NoticeListModel>? noticeList;
  List<MarketList>? marketList;
  List<BannerListModel>? bannerList;

  HomeDatainfoModel({this.noticeList, this.marketList, this.bannerList});

  factory HomeDatainfoModel.fromJson(Map<String, dynamic> json) {
    return HomeDatainfoModel(
      noticeList: (json['noticeList'] as List<dynamic>?)?.map((e) => NoticeListModel.fromJson(e as Map<String, dynamic>)).toList(),
      marketList: (json['marketList'] as List<dynamic>?)?.map((e) => MarketList.fromJson(e as Map<String, dynamic>)).toList(),
      bannerList: (json['bannerList'] as List<dynamic>?)?.map((e) => BannerListModel.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'noticeList': noticeList?.map((e) => e.toJson()).toList(),
        'marketList': marketList?.map((e) => e.toJson()).toList(),
        'bannerList': bannerList?.map((e) => e.toJson()).toList(),
      };
}

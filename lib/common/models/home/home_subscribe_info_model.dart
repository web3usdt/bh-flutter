import 'package:BBIExchange/common/index.dart';

class HomeSubscribeInfoModel {
  int? id;
  String? coinName;
  String? issuePrice;
  String? subscribeCurrency;
  String? expectedTimeOnline;
  String? startSubscriptionTime;
  String? endSubscriptionTime;
  String? announceTime;
  int? totalSubscribeNum;
  int? status;
  String? projectDetails;
  int? maximumPurchase;
  int? minimumPurchase;
  int? minUsdt;
  int? maxUsdt;

  HomeSubscribeInfoModel({
    this.id,
    this.coinName,
    this.issuePrice,
    this.subscribeCurrency,
    this.expectedTimeOnline,
    this.startSubscriptionTime,
    this.endSubscriptionTime,
    this.announceTime,
    this.totalSubscribeNum,
    this.status,
    this.projectDetails,
    this.maximumPurchase,
    this.minimumPurchase,
    this.minUsdt,
    this.maxUsdt,
  });

  factory HomeSubscribeInfoModel.fromJson(Map<String, dynamic> json) {
    return HomeSubscribeInfoModel(
      id: DataUtils.toInt(json['id']),
      coinName: DataUtils.toStr(json['coin_name']),
      issuePrice: DataUtils.toStr(json['issue_price']),
      subscribeCurrency: DataUtils.toStr(json['subscribe_currency']),
      expectedTimeOnline: DataUtils.toStr(json['expected_time_online']),
      startSubscriptionTime: DataUtils.toStr(json['start_subscription_time']),
      endSubscriptionTime: DataUtils.toStr(json['end_subscription_time']),
      announceTime: DataUtils.toStr(json['announce_time']),
      totalSubscribeNum: DataUtils.toInt(json['total_subscribe_num']),
      status: DataUtils.toInt(json['status']),
      projectDetails: DataUtils.toStr(json['project_details']),
      maximumPurchase: DataUtils.toInt(json['maximum_purchase']),
      minimumPurchase: DataUtils.toInt(json['minimum_purchase']),
      minUsdt: DataUtils.toInt(json['min_usdt']),
      maxUsdt: DataUtils.toInt(json['max_usdt']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'coin_name': coinName,
        'issue_price': issuePrice,
        'subscribe_currency': subscribeCurrency,
        'expected_time_online': expectedTimeOnline,
        'start_subscription_time': startSubscriptionTime,
        'end_subscription_time': endSubscriptionTime,
        'announce_time': announceTime,
        'total_subscribe_num': totalSubscribeNum,
        'status': status,
        'project_details': projectDetails,
        'maximum_purchase': maximumPurchase,
        'minimum_purchase': minimumPurchase,
        'min_usdt': minUsdt,
        'max_usdt': maxUsdt,
      };
}

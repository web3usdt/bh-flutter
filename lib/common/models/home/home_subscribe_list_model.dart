import 'package:BBIExchange/common/index.dart';

class HomeSubscribeListModel {
  int? id;
  String? coinName;
  String? issuePrice;
  String? subscribeCurrency;
  String? expectedTimeOnline;
  String? startSubscriptionTime;
  String? endSubscriptionTime;
  String? announceTime;
  int? status;
  dynamic projectDetails;
  dynamic enProjectDetails;
  int? maximumPurchase;
  int? minimumPurchase;
  int? totalPurchaseCurrency;
  int? hashRate;
  dynamic package;
  double? proportionAmount;
  int? qtyDecimals;
  int? priceDecimals;
  double? usableBalance;
  String? preheatTime;

  HomeSubscribeListModel({
    this.id,
    this.coinName,
    this.issuePrice,
    this.subscribeCurrency,
    this.expectedTimeOnline,
    this.startSubscriptionTime,
    this.endSubscriptionTime,
    this.announceTime,
    this.status,
    this.projectDetails,
    this.enProjectDetails,
    this.maximumPurchase,
    this.minimumPurchase,
    this.totalPurchaseCurrency,
    this.hashRate,
    this.package,
    this.proportionAmount,
    this.qtyDecimals,
    this.priceDecimals,
    this.usableBalance,
    this.preheatTime,
  });

  factory HomeSubscribeListModel.fromJson(Map<String, dynamic> json) {
    return HomeSubscribeListModel(
      id: DataUtils.toInt(json['id']),
      coinName: DataUtils.toStr(json['coin_name']),
      issuePrice: DataUtils.toStr(json['issue_price']),
      subscribeCurrency: DataUtils.toStr(json['subscribe_currency']),
      expectedTimeOnline: DataUtils.toStr(json['expected_time_online']),
      startSubscriptionTime: DataUtils.toStr(json['start_subscription_time']),
      endSubscriptionTime: DataUtils.toStr(json['end_subscription_time']),
      announceTime: DataUtils.toStr(json['announce_time']),
      status: DataUtils.toInt(json['status']),
      projectDetails: json['project_details'] as dynamic,
      enProjectDetails: json['en_project_details'] as dynamic,
      maximumPurchase: DataUtils.toInt(json['maximum_purchase']),
      minimumPurchase: DataUtils.toInt(json['minimum_purchase']),
      totalPurchaseCurrency: DataUtils.toInt(json['total_purchase_currency']),
      hashRate: DataUtils.toInt(json['hash_rate']),
      package: (json['package'] is List) ? (json['package'] as List<dynamic>?)?.map((e) => DataUtils.toInt(e) ?? 0).toList() : [],
      proportionAmount: DataUtils.toDouble(json['proportion_amount']),
      qtyDecimals: DataUtils.toInt(json['qtyDecimals']),
      priceDecimals: DataUtils.toInt(json['priceDecimals']),
      usableBalance: DataUtils.toDouble(json['usable_balance']),
      preheatTime: DataUtils.toStr(json['preheat_time']),
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
        'status': status,
        'project_details': projectDetails,
        'en_project_details': enProjectDetails,
        'maximum_purchase': maximumPurchase,
        'minimum_purchase': minimumPurchase,
        'total_purchase_currency': totalPurchaseCurrency,
        'hash_rate': hashRate,
        'package': package,
        'proportion_amount': proportionAmount,
        'qtyDecimals': qtyDecimals,
        'priceDecimals': priceDecimals,
        'usable_balance': usableBalance,
        'preheat_time': preheatTime,
      };
}

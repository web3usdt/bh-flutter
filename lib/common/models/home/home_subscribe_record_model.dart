import 'package:BBIExchange/common/index.dart';

class HomeSubscribeRecordModel {
  int? id;
  int? userId;
  String? paymentAmount;
  String? paymentCurrency;
  int? subscriptionTime;
  String? subscriptionCurrencyName;
  String? subscriptionCurrencyAmount;

  HomeSubscribeRecordModel({
    this.id,
    this.userId,
    this.paymentAmount,
    this.paymentCurrency,
    this.subscriptionTime,
    this.subscriptionCurrencyName,
    this.subscriptionCurrencyAmount,
  });

  factory HomeSubscribeRecordModel.fromJson(Map<String, dynamic> json) {
    return HomeSubscribeRecordModel(
      id: DataUtils.toInt(json['id']),
      userId: DataUtils.toInt(json['user_id']),
      paymentAmount: DataUtils.toStr(json['payment_amount']),
      paymentCurrency: DataUtils.toStr(json['payment_currency']),
      subscriptionTime: DataUtils.toInt(json['subscription_time']),
      subscriptionCurrencyName: DataUtils.toStr(json['subscription_currency_name']),
      subscriptionCurrencyAmount: DataUtils.toStr(json['subscription_currency_amount']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'payment_amount': paymentAmount,
        'payment_currency': paymentCurrency,
        'subscription_time': subscriptionTime,
        'subscription_currency_name': subscriptionCurrencyName,
        'subscription_currency_amount': subscriptionCurrencyAmount,
      };
}

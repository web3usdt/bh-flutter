import 'package:happy/common/index.dart';

class AssetsWdithdrawBalanceModel {
  int? usableBalance;
  String? withdrawalFee;
  String? withdrawalMin;
  String? withdrawalMax;
  String? withdrawalFeeRate;
  String? withdrawSwitch;
  int? userId;
  String? countryCode;
  String? phone;
  int? phoneStatus;
  String? email;
  int? emailStatus;
  dynamic googleToken;
  int? googleStatus;

  AssetsWdithdrawBalanceModel({
    this.usableBalance,
    this.withdrawalFee,
    this.withdrawalMin,
    this.withdrawalMax,
    this.withdrawalFeeRate,
    this.withdrawSwitch,
    this.userId,
    this.countryCode,
    this.phone,
    this.phoneStatus,
    this.email,
    this.emailStatus,
    this.googleToken,
    this.googleStatus,
  });

  factory AssetsWdithdrawBalanceModel.fromJson(Map<String, dynamic> json) {
    return AssetsWdithdrawBalanceModel(
      usableBalance: DataUtils.toInt(json['usable_balance']),
      withdrawalFee: DataUtils.toStr(json['withdrawal_fee']),
      withdrawalMin: DataUtils.toStr(json['withdrawal_min']),
      withdrawalMax: DataUtils.toStr(json['withdrawal_max']),
      withdrawalFeeRate: DataUtils.toStr(json['withdrawal_fee_rate']),
      withdrawSwitch: DataUtils.toStr(json['withdraw_switch']),
      userId: DataUtils.toInt(json['user_id']),
      countryCode: DataUtils.toStr(json['country_code']),
      phone: DataUtils.toStr(json['phone']),
      phoneStatus: DataUtils.toInt(json['phone_status']),
      email: DataUtils.toStr(json['email']),
      emailStatus: DataUtils.toInt(json['email_status']),
      googleToken: DataUtils.toStr(json['google_token']),
      googleStatus: DataUtils.toInt(json['google_status']),
    );
  }

  Map<String, dynamic> toJson() => {
        'usable_balance': usableBalance,
        'withdrawal_fee': withdrawalFee,
        'withdrawal_min': withdrawalMin,
        'withdrawal_max': withdrawalMax,
        'withdrawal_fee_rate': withdrawalFeeRate,
        'withdraw_switch': withdrawSwitch,
        'user_id': userId,
        'country_code': countryCode,
        'phone': phone,
        'phone_status': phoneStatus,
        'email': email,
        'email_status': emailStatus,
        'google_token': googleToken,
        'google_status': googleStatus,
      };
}

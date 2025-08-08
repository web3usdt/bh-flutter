import 'package:BBIExchange/common/index.dart';

import 'list.dart';

class AssetsWithdrawAddressListModel {
  String? coinName;
  int? coinId;
  String? fullName;
  String? coinIcon;
  String? withdrawalFee;
  int? totalAddress;
  List<AssetsWithdrawAddressListModelList> list;

  AssetsWithdrawAddressListModel({
    this.coinName,
    this.coinId,
    this.fullName,
    this.coinIcon,
    this.withdrawalFee,
    this.totalAddress,
    List<AssetsWithdrawAddressListModelList>? list,
  }) : list = list ?? [];

  factory AssetsWithdrawAddressListModel.fromJson(Map<String, dynamic> json) {
    return AssetsWithdrawAddressListModel(
      coinName: DataUtils.toStr(json['coin_name']),
      coinId: DataUtils.toInt(json['coin_id']),
      fullName: DataUtils.toStr(json['full_name']),
      coinIcon: DataUtils.toStr(json['coin_icon']),
      withdrawalFee: DataUtils.toStr(json['withdrawal_fee']),
      totalAddress: DataUtils.toInt(json['total_address']),
      list: (json['list'] as List<dynamic>?)?.map((e) => AssetsWithdrawAddressListModelList.fromJson(e as Map<String, dynamic>)).toList() ??
          <AssetsWithdrawAddressListModelList>[],
    );
  }

  Map<String, dynamic> toJson() => {
        'coin_name': coinName,
        'coin_id': coinId,
        'full_name': fullName,
        'coin_icon': coinIcon,
        'withdrawal_fee': withdrawalFee,
        'total_address': totalAddress,
        'list': list.map((e) => e.toJson()).toList(),
      };
}

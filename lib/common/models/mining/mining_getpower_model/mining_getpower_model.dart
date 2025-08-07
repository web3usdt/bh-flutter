import 'package:happy/common/index.dart';

import 'data.dart';
import 'wallet.dart';

class MiningGetpowerModel {
  MiningGetpowerModelWallet? wallet;
  String? peToPower;
  String? peToUsdt;
  String? currentPrice;
  String? minerAccount;
  MiningGetpowerModelData? data;

  MiningGetpowerModel({
    this.wallet,
    this.peToPower,
    this.peToUsdt,
    this.currentPrice,
    this.minerAccount,
    this.data,
  });

  factory MiningGetpowerModel.fromJson(Map<String, dynamic> json) {
    return MiningGetpowerModel(
      wallet: json['wallet'] == null ? null : MiningGetpowerModelWallet.fromJson(json['wallet'] as Map<String, dynamic>),
      peToPower: DataUtils.toStr(json['peToPower']),
      peToUsdt: DataUtils.toStr(json['peToUsdt']),
      currentPrice: DataUtils.toStr(json['currentPrice']),
      minerAccount: DataUtils.toStr(json['miner_account']),
      data: json['data'] == null ? null : MiningGetpowerModelData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
        'wallet': wallet?.toJson(),
        'peToPower': peToPower,
        'peToUsdt': peToUsdt,
        'currentPrice': currentPrice,
        'miner_account': minerAccount,
        'data': data?.toJson(),
      };
}

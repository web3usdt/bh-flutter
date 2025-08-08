import 'package:BBIExchange/common/index.dart';

class AssetsTransferCoinlistModel {
  int? coinId;
  String? coinName;
  String? coinIcon;

  AssetsTransferCoinlistModel({this.coinId, this.coinName, this.coinIcon});

  factory AssetsTransferCoinlistModel.fromJson(Map<String, dynamic> json) {
    return AssetsTransferCoinlistModel(
      coinId: DataUtils.toInt(json['coin_id']),
      coinName: DataUtils.toStr(json['coin_name']),
      coinIcon: DataUtils.toStr(json['coin_icon']),
    );
  }

  Map<String, dynamic> toJson() => {
        'coin_id': coinId,
        'coin_name': coinName,
        'coin_icon': coinIcon,
      };
}

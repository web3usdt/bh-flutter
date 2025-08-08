import 'package:BBIExchange/common/index.dart';

class AssetsFundAccountListModelSymbol {
  String? coinName;
  int? coinId;

  AssetsFundAccountListModelSymbol({this.coinName, this.coinId});

  factory AssetsFundAccountListModelSymbol.fromJson(Map<String, dynamic> json) => AssetsFundAccountListModelSymbol(
        coinName: DataUtils.toStr(json['coin_name']),
        coinId: DataUtils.toInt(json['coin_id']),
      );

  Map<String, dynamic> toJson() => {
        'coin_name': coinName,
        'coin_id': coinId,
      };
}

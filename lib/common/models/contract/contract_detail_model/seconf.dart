import 'package:BBIExchange/common/index.dart';

class ContractDetailModelSeconf {
  int? id;
  int? seconds;
  String? profitRate;
  int? minAmount;

  ContractDetailModelSeconf({this.id, this.seconds, this.profitRate, this.minAmount});

  factory ContractDetailModelSeconf.fromJson(Map<String, dynamic> json) => ContractDetailModelSeconf(
        id: DataUtils.toInt(json['id']),
        seconds: DataUtils.toInt(json['seconds']),
        profitRate: DataUtils.toStr(json['profit_rate']),
        minAmount: DataUtils.toInt(json['min_amount']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'seconds': seconds,
        'profit_rate': profitRate,
        'min_amount': minAmount,
      };
}

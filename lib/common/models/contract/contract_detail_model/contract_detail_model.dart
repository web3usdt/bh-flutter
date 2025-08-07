import 'package:happy/common/index.dart';

class ContractDetailModel {
  int? id;
  String? symbol;
  int? contractCoinId;
  String? contractCoinName;
  int? marginCoinId;
  String? type;
  String? unitAmount;
  double? makerFeeRate;
  double? takerFeeRate;
  int? status;
  int? tradeStatus;
  List<String>? leverRage;
  String? defaultLever;
  int? minQty;
  int? maxQty;
  int? totalMaxQty;
  String? buySpread;
  String? sellSpread;
  String? settleSpread;
  String? createdAt;
  String? updatedAt;
  List<ContractDetailModelSeconf>? seconf;

  ContractDetailModel({
    this.id,
    this.symbol,
    this.contractCoinId,
    this.contractCoinName,
    this.marginCoinId,
    this.type,
    this.unitAmount,
    this.makerFeeRate,
    this.takerFeeRate,
    this.status,
    this.tradeStatus,
    this.leverRage,
    this.defaultLever,
    this.minQty,
    this.maxQty,
    this.totalMaxQty,
    this.buySpread,
    this.sellSpread,
    this.settleSpread,
    this.createdAt,
    this.updatedAt,
    this.seconf,
  });

  factory ContractDetailModel.fromJson(Map<String, dynamic> json) {
    return ContractDetailModel(
      id: DataUtils.toInt(json['id']),
      symbol: DataUtils.toStr(json['symbol']),
      contractCoinId: DataUtils.toInt(json['contract_coin_id']),
      contractCoinName: DataUtils.toStr(json['contract_coin_name']),
      marginCoinId: DataUtils.toInt(json['margin_coin_id']),
      type: DataUtils.toStr(json['type']),
      unitAmount: DataUtils.toStr(json['unit_amount']),
      makerFeeRate: DataUtils.toDouble(json['maker_fee_rate']),
      takerFeeRate: DataUtils.toDouble(json['taker_fee_rate']),
      status: DataUtils.toInt(json['status']),
      tradeStatus: DataUtils.toInt(json['trade_status']),
      leverRage: (json['lever_rage'] is List) ? (json['lever_rage'] as List).map((e) => e.toString()).toList() : [],
      defaultLever: DataUtils.toStr(json['default_lever']),
      minQty: DataUtils.toInt(json['min_qty']),
      maxQty: DataUtils.toInt(json['max_qty']),
      totalMaxQty: DataUtils.toInt(json['total_max_qty']),
      buySpread: DataUtils.toStr(json['buy_spread']),
      sellSpread: DataUtils.toStr(json['sell_spread']),
      settleSpread: DataUtils.toStr(json['settle_spread']),
      createdAt: DataUtils.toStr(json['created_at']),
      updatedAt: DataUtils.toStr(json['updated_at']),
      seconf: (json['seconf'] as List<dynamic>?)?.map((e) => ContractDetailModelSeconf.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'symbol': symbol,
        'contract_coin_id': contractCoinId,
        'contract_coin_name': contractCoinName,
        'margin_coin_id': marginCoinId,
        'type': type,
        'unit_amount': unitAmount,
        'maker_fee_rate': makerFeeRate,
        'taker_fee_rate': takerFeeRate,
        'status': status,
        'trade_status': tradeStatus,
        'lever_rage': leverRage,
        'default_lever': defaultLever,
        'min_qty': minQty,
        'max_qty': maxQty,
        'total_max_qty': totalMaxQty,
        'buy_spread': buySpread,
        'sell_spread': sellSpread,
        'settle_spread': settleSpread,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'seconf': seconf?.map((e) => e.toJson()).toList(),
      };
}

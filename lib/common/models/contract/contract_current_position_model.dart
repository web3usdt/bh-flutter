import 'package:BBIExchange/common/index.dart';

class ContractCurrentPositionModel {
  int? id;
  int? userId;
  int? side;
  int? contractId;
  String? symbol;
  String? unitAmount;
  int? contractCoinId;
  int? marginCoinId;
  int? marginMode;
  String? leverRate;
  String? liquidationPrice;
  int? holdPosition;
  int? availPosition;
  int? freezePosition;
  int? positionMargin;
  String? fee;
  double? avgPrice;
  String? settlementPrice;
  dynamic maintainMarginRate;
  dynamic settledPnl;
  dynamic realizedPnl;
  String? unrealizedPnl;
  String? createdAt;
  String? updatedAt;
  String? pairName;
  String? unRealProfit;
  String? profitRate;
  String? flatPrice;
  double? realtimePrice;
  int? tpPrice;
  int? slPrice;
  String? marginModeText;

  ContractCurrentPositionModel({
    this.id,
    this.userId,
    this.side,
    this.contractId,
    this.symbol,
    this.unitAmount,
    this.contractCoinId,
    this.marginCoinId,
    this.marginMode,
    this.leverRate,
    this.liquidationPrice,
    this.holdPosition,
    this.availPosition,
    this.freezePosition,
    this.positionMargin,
    this.fee,
    this.avgPrice,
    this.settlementPrice,
    this.maintainMarginRate,
    this.settledPnl,
    this.realizedPnl,
    this.unrealizedPnl,
    this.createdAt,
    this.updatedAt,
    this.pairName,
    this.unRealProfit,
    this.profitRate,
    this.flatPrice,
    this.realtimePrice,
    this.tpPrice,
    this.slPrice,
    this.marginModeText,
  });

  factory ContractCurrentPositionModel.fromJson(Map<String, dynamic> json) {
    return ContractCurrentPositionModel(
      id: DataUtils.toInt(json['id']),
      userId: DataUtils.toInt(json['user_id']),
      side: DataUtils.toInt(json['side']),
      contractId: DataUtils.toInt(json['contract_id']),
      symbol: DataUtils.toStr(json['symbol']),
      unitAmount: DataUtils.toStr(json['unit_amount']),
      contractCoinId: DataUtils.toInt(json['contract_coin_id']),
      marginCoinId: DataUtils.toInt(json['margin_coin_id']),
      marginMode: DataUtils.toInt(json['margin_mode']),
      leverRate: DataUtils.toStr(json['lever_rate']),
      liquidationPrice: DataUtils.toStr(json['liquidation_price']),
      holdPosition: DataUtils.toInt(json['hold_position']),
      availPosition: DataUtils.toInt(json['avail_position']),
      freezePosition: DataUtils.toInt(json['freeze_position']),
      positionMargin: DataUtils.toInt(json['position_margin']),
      fee: DataUtils.toStr(json['fee']),
      avgPrice: DataUtils.toDouble(json['avg_price']),
      settlementPrice: DataUtils.toStr(json['settlement_price']),
      maintainMarginRate: DataUtils.toStr(json['maintain_margin_rate']),
      settledPnl: DataUtils.toStr(json['settled_pnl']),
      realizedPnl: DataUtils.toStr(json['realized_pnl']),
      unrealizedPnl: DataUtils.toStr(json['unrealized_pnl']),
      createdAt: DataUtils.toStr(json['created_at']),
      updatedAt: DataUtils.toStr(json['updated_at']),
      pairName: DataUtils.toStr(json['pair_name']),
      unRealProfit: DataUtils.toStr(json['unRealProfit']),
      profitRate: DataUtils.toStr(json['profitRate']),
      flatPrice: DataUtils.toStr(json['flatPrice']),
      realtimePrice: DataUtils.toDouble(json['realtimePrice']),
      tpPrice: DataUtils.toInt(json['tpPrice']),
      slPrice: DataUtils.toInt(json['slPrice']),
      marginModeText: DataUtils.toStr(json['margin_mode_text']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'side': side,
        'contract_id': contractId,
        'symbol': symbol,
        'unit_amount': unitAmount,
        'contract_coin_id': contractCoinId,
        'margin_coin_id': marginCoinId,
        'margin_mode': marginMode,
        'lever_rate': leverRate,
        'liquidation_price': liquidationPrice,
        'hold_position': holdPosition,
        'avail_position': availPosition,
        'freeze_position': freezePosition,
        'position_margin': positionMargin,
        'fee': fee,
        'avg_price': avgPrice,
        'settlement_price': settlementPrice,
        'maintain_margin_rate': maintainMarginRate,
        'settled_pnl': settledPnl,
        'realized_pnl': realizedPnl,
        'unrealized_pnl': unrealizedPnl,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'pair_name': pairName,
        'unRealProfit': unRealProfit,
        'profitRate': profitRate,
        'flatPrice': flatPrice,
        'realtimePrice': realtimePrice,
        'tpPrice': tpPrice,
        'slPrice': slPrice,
        'margin_mode_text': marginModeText,
      };
}

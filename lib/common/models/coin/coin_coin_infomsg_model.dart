import 'package:happy/common/index.dart';

class CoinCoinInfomsgModel {
  int? coinId;
  String? coinName;
  dynamic symbol;
  int? qtyDecimals;
  int? priceDecimals;
  String? fullName;
  String? withdrawalFee;
  int? withdrawalMin;
  int? withdrawalMax;
  String? coinWithdrawMessage;
  String? coinRechargeMessage;
  String? coinTransferMessage;
  String? coinContent;
  String? coinIcon;
  int? status;
  dynamic appKey;
  dynamic appSecret;
  String? officialWebsiteLink;
  String? whitePaperLink;
  dynamic blockQueryLink;
  String? publishTime;
  int? totalIssuance;
  int? totalCirculation;
  String? crowdfundingPrice;
  int? order;
  int? isWithdraw;
  int? isRecharge;
  int? canRecharge;
  String? createdAt;
  String? updatedAt;

  CoinCoinInfomsgModel({
    this.coinId,
    this.coinName,
    this.symbol,
    this.qtyDecimals,
    this.priceDecimals,
    this.fullName,
    this.withdrawalFee,
    this.withdrawalMin,
    this.withdrawalMax,
    this.coinWithdrawMessage,
    this.coinRechargeMessage,
    this.coinTransferMessage,
    this.coinContent,
    this.coinIcon,
    this.status,
    this.appKey,
    this.appSecret,
    this.officialWebsiteLink,
    this.whitePaperLink,
    this.blockQueryLink,
    this.publishTime,
    this.totalIssuance,
    this.totalCirculation,
    this.crowdfundingPrice,
    this.order,
    this.isWithdraw,
    this.isRecharge,
    this.canRecharge,
    this.createdAt,
    this.updatedAt,
  });

  factory CoinCoinInfomsgModel.fromJson(Map<String, dynamic> json) {
    return CoinCoinInfomsgModel(
      coinId: DataUtils.toInt(json['coin_id']),
      coinName: DataUtils.toStr(json['coin_name']),
      symbol: DataUtils.toStr(json['symbol']),
      qtyDecimals: DataUtils.toInt(json['qty_decimals']),
      priceDecimals: DataUtils.toInt(json['price_decimals']),
      fullName: DataUtils.toStr(json['full_name']),
      withdrawalFee: DataUtils.toStr(json['withdrawal_fee']),
      withdrawalMin: DataUtils.toInt(json['withdrawal_min']),
      withdrawalMax: DataUtils.toInt(json['withdrawal_max']),
      coinWithdrawMessage: DataUtils.toStr(json['coin_withdraw_message']),
      coinRechargeMessage: DataUtils.toStr(json['coin_recharge_message']),
      coinTransferMessage: DataUtils.toStr(json['coin_transfer_message']),
      coinContent: DataUtils.toStr(json['coin_content']),
      coinIcon: DataUtils.toStr(json['coin_icon']),
      status: DataUtils.toInt(json['status']),
      appKey: DataUtils.toStr(json['appKey']),
      appSecret: DataUtils.toStr(json['appSecret']),
      officialWebsiteLink: DataUtils.toStr(json['official_website_link']),
      whitePaperLink: DataUtils.toStr(json['white_paper_link']),
      blockQueryLink: DataUtils.toStr(json['block_query_link']),
      publishTime: DataUtils.toStr(json['publish_time']),
      totalIssuance: DataUtils.toInt(json['total_issuance']),
      totalCirculation: DataUtils.toInt(json['total_circulation']),
      crowdfundingPrice: DataUtils.toStr(json['crowdfunding_price']),
      order: DataUtils.toInt(json['order']),
      isWithdraw: DataUtils.toInt(json['is_withdraw']),
      isRecharge: DataUtils.toInt(json['is_recharge']),
      canRecharge: DataUtils.toInt(json['can_recharge']),
      createdAt: DataUtils.toStr(json['created_at']),
      updatedAt: DataUtils.toStr(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() => {
        'coin_id': coinId,
        'coin_name': coinName,
        'symbol': symbol,
        'qty_decimals': qtyDecimals,
        'price_decimals': priceDecimals,
        'full_name': fullName,
        'withdrawal_fee': withdrawalFee,
        'withdrawal_min': withdrawalMin,
        'withdrawal_max': withdrawalMax,
        'coin_withdraw_message': coinWithdrawMessage,
        'coin_recharge_message': coinRechargeMessage,
        'coin_transfer_message': coinTransferMessage,
        'coin_content': coinContent,
        'coin_icon': coinIcon,
        'status': status,
        'appKey': appKey,
        'appSecret': appSecret,
        'official_website_link': officialWebsiteLink,
        'white_paper_link': whitePaperLink,
        'block_query_link': blockQueryLink,
        'publish_time': publishTime,
        'total_issuance': totalIssuance,
        'total_circulation': totalCirculation,
        'crowdfunding_price': crowdfundingPrice,
        'order': order,
        'is_withdraw': isWithdraw,
        'is_recharge': isRecharge,
        'can_recharge': canRecharge,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}

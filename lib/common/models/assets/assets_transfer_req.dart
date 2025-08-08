import 'package:BBIExchange/common/index.dart';

class AssetsTransferReq {
  String? fromAccount;
  String? toAccount;
  String? amount;
  String? coinName;

  AssetsTransferReq({
    this.fromAccount,
    this.toAccount,
    this.amount,
    this.coinName,
  });

  factory AssetsTransferReq.fromJson(Map<String, dynamic> json) {
    return AssetsTransferReq(
      fromAccount: DataUtils.toStr(json['from_account']),
      toAccount: DataUtils.toStr(json['to_account']),
      amount: DataUtils.toStr(json['amount']),
      coinName: DataUtils.toStr(json['coin_name']),
    );
  }

  Map<String, dynamic> toJson() => {
        'from_account': fromAccount,
        'to_account': toAccount,
        'amount': amount,
        'coin_name': coinName,
      };
}

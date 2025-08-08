import 'package:BBIExchange/common/index.dart';

class AssetsTransferCoinlistReq {
  String? fromAccount;
  String? toAccount;

  AssetsTransferCoinlistReq({this.fromAccount, this.toAccount});

  factory AssetsTransferCoinlistReq.fromJson(Map<String, dynamic> json) {
    return AssetsTransferCoinlistReq(
      fromAccount: DataUtils.toStr(json['from_account']),
      toAccount: DataUtils.toStr(json['to_account']),
    );
  }

  Map<String, dynamic> toJson() => {
        'from_account': fromAccount,
        'to_account': toAccount,
      };
}

import 'package:happy/common/index.dart';

class AssetsTransferBalanceReq {
  String? account;
  String? coinName;

  AssetsTransferBalanceReq({this.account, this.coinName});

  factory AssetsTransferBalanceReq.fromJson(Map<String, dynamic> json) {
    return AssetsTransferBalanceReq(
      account: DataUtils.toStr(json['account']),
      coinName: DataUtils.toStr(json['coin_name']),
    );
  }

  Map<String, dynamic> toJson() => {
        'account': account,
        'coin_name': coinName,
      };
}

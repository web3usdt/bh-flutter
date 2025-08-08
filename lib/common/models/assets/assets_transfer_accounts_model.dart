import 'package:BBIExchange/common/index.dart';

class AssetsTransferAccountsModel {
  int? id;
  String? name;
  String? account;
  int? isNeedPair;
  String? pairKey;
  String? model;

  AssetsTransferAccountsModel({
    this.id,
    this.name,
    this.account,
    this.isNeedPair,
    this.pairKey,
    this.model,
  });

  factory AssetsTransferAccountsModel.fromJson(Map<String, dynamic> json) {
    return AssetsTransferAccountsModel(
      id: DataUtils.toInt(json['id']),
      name: DataUtils.toStr(json['name']),
      account: DataUtils.toStr(json['account']),
      isNeedPair: DataUtils.toInt(json['is_need_pair']),
      pairKey: DataUtils.toStr(json['pair_key']),
      model: DataUtils.toStr(json['model']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'account': account,
        'is_need_pair': isNeedPair,
        'pair_key': pairKey,
        'model': model,
      };
}

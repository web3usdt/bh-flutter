import 'package:happy/common/index.dart';

class MoneyGameEditMoneyListReq {
  int? label;
  int? value;

  MoneyGameEditMoneyListReq({this.label, this.value});

  factory MoneyGameEditMoneyListReq.fromJson(Map<String, dynamic> json) => MoneyGameEditMoneyListReq(
        label: DataUtils.toInt(json['label']),
        value: DataUtils.toInt(json['value']),
      );

  Map<String, dynamic> toJson() => {
        'label': label,
        'value': value,
      };
}

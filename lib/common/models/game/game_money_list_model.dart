import 'package:BBIExchange/common/index.dart';

class GameMoneyListModel {
  int? label;
  int? value;

  GameMoneyListModel({this.label, this.value});

  factory GameMoneyListModel.fromJson(Map<String, dynamic> json) {
    return GameMoneyListModel(
      label: DataUtils.toInt(json['label']),
      value: DataUtils.toInt(json['value']),
    );
  }

  Map<String, dynamic> toJson() => {
        'label': label,
        'value': value,
      };
}

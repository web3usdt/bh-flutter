import 'package:happy/common/index.dart';

class AssetsRechargeNetworkListModel {
  String? name;
  int? maxTime;

  AssetsRechargeNetworkListModel({this.name, this.maxTime});

  factory AssetsRechargeNetworkListModel.fromJson(Map<String, dynamic> json) {
    return AssetsRechargeNetworkListModel(
      name: DataUtils.toStr(json['name']),
      maxTime: DataUtils.toInt(json['max_time']),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'max_time': maxTime,
      };
}

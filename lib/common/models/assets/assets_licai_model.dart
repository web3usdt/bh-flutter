import 'package:BBIExchange/common/index.dart';

class AssetsLicaiModel {
  String? totalAssetsUsdt;
  List<AssetsFundAccountListModel> list;

  AssetsLicaiModel({
    this.totalAssetsUsdt,
    List<AssetsFundAccountListModel>? list,
  }) : list = list ?? [];

  factory AssetsLicaiModel.fromJson(Map<String, dynamic> json) {
    return AssetsLicaiModel(
      totalAssetsUsdt: DataUtils.toStr(json['total_assets_usdt']),
      list: (json['list'] as List<dynamic>?)?.map((e) => AssetsFundAccountListModel.fromJson(e as Map<String, dynamic>)).toList() ??
          <AssetsFundAccountListModel>[],
    );
  }

  Map<String, dynamic> toJson() => {
        'total_assets_usdt': totalAssetsUsdt,
        'list': list.map((e) => e.toJson()).toList(),
      };
}

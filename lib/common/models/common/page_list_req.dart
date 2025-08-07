import 'package:happy/common/index.dart';

class PageListReq {
  int? page;
  String? type;
  String? coinName;
  String? accountType;

  PageListReq({this.page, this.type, this.coinName, this.accountType});

  factory PageListReq.fromJson(Map<String, dynamic> json) {
    return PageListReq(
      page: DataUtils.toInt(json['page']),
      type: DataUtils.toStr(json['type']),
      coinName: DataUtils.toStr(json['coin_name']),
      accountType: DataUtils.toStr(json['account_type']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (page != null) data['page'] = page;
    if (type != null) data['type'] = type;
    if (coinName != null) data['coin_name'] = coinName;
    if (accountType != null) data['account_type'] = accountType;
    return data;
  }
}

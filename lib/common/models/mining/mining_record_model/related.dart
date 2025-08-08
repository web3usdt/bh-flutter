import 'package:BBIExchange/common/index.dart';

class MinineRecordModelRelated {
  String? account;

  MinineRecordModelRelated({this.account});

  factory MinineRecordModelRelated.fromJson(Map<String, dynamic> json) => MinineRecordModelRelated(
        account: DataUtils.toStr(json['account']),
      );

  Map<String, dynamic> toJson() => {
        'account': account,
      };
}

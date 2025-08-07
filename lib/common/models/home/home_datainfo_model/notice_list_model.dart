import 'package:happy/common/index.dart';

class NoticeListModel {
  int? id;
  String? title;

  NoticeListModel({
    this.id,
    this.title,
  });

  factory NoticeListModel.fromJson(Map<String, dynamic> json) => NoticeListModel(
        id: DataUtils.toInt(json['id']),
        title: DataUtils.toStr(json['title']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
      };
}

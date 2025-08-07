import 'package:happy/common/index.dart';

class HomeSystemMessageListModelData {
  String? title;
  String? content;

  HomeSystemMessageListModelData({this.title, this.content});

  factory HomeSystemMessageListModelData.fromJson(Map<String, dynamic> json) => HomeSystemMessageListModelData(
        title: DataUtils.toStr(json['title']),
        content: DataUtils.toStr(json['content']),
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'content': content,
      };
}

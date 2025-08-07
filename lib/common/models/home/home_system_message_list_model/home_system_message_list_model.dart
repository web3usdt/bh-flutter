import 'package:happy/common/index.dart';

import 'data.dart';

class HomeSystemMessageListModel {
  String? id;
  String? type;
  String? notifiableType;
  int? notifiableId;
  HomeSystemMessageListModelData? data;
  String? readAt;
  String? createdAt;
  String? updatedAt;

  HomeSystemMessageListModel({
    this.id,
    this.type,
    this.notifiableType,
    this.notifiableId,
    this.data,
    this.readAt,
    this.createdAt,
    this.updatedAt,
  });

  factory HomeSystemMessageListModel.fromJson(Map<String, dynamic> json) {
    return HomeSystemMessageListModel(
      id: DataUtils.toStr(json['id']),
      type: DataUtils.toStr(json['type']),
      notifiableType: DataUtils.toStr(json['notifiable_type']),
      notifiableId: DataUtils.toInt(json['notifiable_id']),
      data: json['data'] == null ? null : HomeSystemMessageListModelData.fromJson(json['data'] as Map<String, dynamic>),
      readAt: DataUtils.toStr(json['read_at']),
      createdAt: DataUtils.toStr(json['created_at']),
      updatedAt: DataUtils.toStr(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'notifiable_type': notifiableType,
        'notifiable_id': notifiableId,
        'data': data?.toJson(),
        'read_at': readAt,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}

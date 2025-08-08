import 'package:BBIExchange/common/index.dart';

class UserShareActiveListModel {
  int? id;
  String? title;
  String? image;
  String? startTime;
  String? endTime;
  int? userNum;
  String? reward;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? batchNo;
  String? inviteImage;
  String? defaultNum;
  int? levelUser;
  String? levelProgress;
  String? progress;

  UserShareActiveListModel({
    this.id,
    this.title,
    this.image,
    this.startTime,
    this.endTime,
    this.userNum,
    this.reward,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.batchNo,
    this.inviteImage,
    this.defaultNum,
    this.levelUser,
    this.levelProgress,
    this.progress,
  });

  factory UserShareActiveListModel.fromJson(Map<String, dynamic> json) {
    return UserShareActiveListModel(
      id: DataUtils.toInt(json['id']),
      title: DataUtils.toStr(json['title']),
      image: DataUtils.toStr(json['image']),
      startTime: DataUtils.toStr(json['start_time']),
      endTime: DataUtils.toStr(json['end_time']),
      userNum: DataUtils.toInt(json['user_num']),
      reward: DataUtils.toStr(json['reward']),
      status: DataUtils.toInt(json['status']),
      createdAt: DataUtils.toStr(json['created_at']),
      updatedAt: DataUtils.toStr(json['updated_at']),
      batchNo: DataUtils.toStr(json['batch_no']),
      inviteImage: DataUtils.toStr(json['invite_image']),
      defaultNum: DataUtils.toStr(json['default_num']),
      levelUser: DataUtils.toInt(json['level_user']),
      levelProgress: DataUtils.toStr(json['level_progress']),
      progress: DataUtils.toStr(json['progress']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'image': image,
        'start_time': startTime,
        'end_time': endTime,
        'user_num': userNum,
        'reward': reward,
        'status': status,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'batch_no': batchNo,
        'invite_image': inviteImage,
        'default_num': defaultNum,
        'level_user': levelUser,
        'level_progress': levelProgress,
        'progress': progress,
      };
}

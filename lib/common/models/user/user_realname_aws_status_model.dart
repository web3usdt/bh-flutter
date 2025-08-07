import 'package:happy/common/index.dart';

class UserRealnameAwsStatusModel {
  String? status;
  String? cause;

  UserRealnameAwsStatusModel({this.status, this.cause});

  factory UserRealnameAwsStatusModel.fromJson(Map<String, dynamic> json) {
    return UserRealnameAwsStatusModel(
      status: DataUtils.toStr(json['status']),
      cause: DataUtils.toStr(json['cause']),
    );
  }

  Map<String, dynamic> toJson() => {
        'status': status,
        'cause': cause,
      };
}

import 'package:happy/common/index.dart';

class UserShareInfoModel {
  int? inviteUserNum;
  int? inviteDirectUserNum;
  int? inviteIndirectNum;
  int? inviteDividend;
  String? inviteCode;
  String? inviteUrl;
  int? inviteEffectiveHelpNum;

  UserShareInfoModel({
    this.inviteUserNum,
    this.inviteDirectUserNum,
    this.inviteIndirectNum,
    this.inviteDividend,
    this.inviteCode,
    this.inviteUrl,
    this.inviteEffectiveHelpNum,
  });

  factory UserShareInfoModel.fromJson(Map<String, dynamic> json) {
    return UserShareInfoModel(
      inviteUserNum: DataUtils.toInt(json['invite_user_num']),
      inviteDirectUserNum: json['invite_direct_user_num'] as int?,
      inviteIndirectNum: DataUtils.toInt(json['invite_indirect_num']),
      inviteDividend: DataUtils.toInt(json['invite_dividend']),
      inviteCode: DataUtils.toStr(json['invite_code']),
      inviteUrl: DataUtils.toStr(json['invite_url']),
      inviteEffectiveHelpNum: DataUtils.toInt(json['invite_effective_help_num']),
    );
  }

  Map<String, dynamic> toJson() => {
        'invite_user_num': inviteUserNum,
        'invite_direct_user_num': inviteDirectUserNum,
        'invite_indirect_num': inviteIndirectNum,
        'invite_dividend': inviteDividend,
        'invite_code': inviteCode,
        'invite_url': inviteUrl,
        'invite_effective_help_num': inviteEffectiveHelpNum,
      };
}

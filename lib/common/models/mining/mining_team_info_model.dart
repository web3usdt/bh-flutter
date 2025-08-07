import 'package:happy/common/index.dart';

class MiningTeamInfoModel {
  int? inviteUserNum;
  int? inviteDirectUserNum;
  int? inviteIndirectNum;
  int? inviteDividend;
  String? inviteCode;
  String? inviteUrl;
  int? inviteEffectiveHelpNum;
  int? validRef;
  double? destroyDayXfb;
  int? destroyDayU;
  double? destroyMonthXfb;
  int? destroyMonthU;
  int? teamMiner;

  MiningTeamInfoModel({
    this.inviteUserNum,
    this.inviteDirectUserNum,
    this.inviteIndirectNum,
    this.inviteDividend,
    this.inviteCode,
    this.inviteUrl,
    this.inviteEffectiveHelpNum,
    this.validRef,
    this.destroyDayXfb,
    this.destroyDayU,
    this.destroyMonthXfb,
    this.destroyMonthU,
    this.teamMiner,
  });

  factory MiningTeamInfoModel.fromJson(Map<String, dynamic> json) {
    return MiningTeamInfoModel(
      inviteUserNum: DataUtils.toInt(json['invite_user_num']),
      inviteDirectUserNum: DataUtils.toInt(json['invite_direct_user_num']),
      inviteIndirectNum: DataUtils.toInt(json['invite_indirect_num']),
      inviteDividend: DataUtils.toInt(json['invite_dividend']),
      inviteCode: DataUtils.toStr(json['invite_code']),
      inviteUrl: DataUtils.toStr(json['invite_url']),
      inviteEffectiveHelpNum: DataUtils.toInt(json['invite_effective_help_num']),
      validRef: DataUtils.toInt(json['valid_ref']),
      destroyDayXfb: DataUtils.toDouble(json['destroy_day_xfb']),
      destroyDayU: DataUtils.toInt(json['destroy_day_u']),
      destroyMonthXfb: DataUtils.toDouble(json['destroy_month_xfb']),
      destroyMonthU: DataUtils.toInt(json['destroy_month_u']),
      teamMiner: DataUtils.toInt(json['team_miner']),
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
        'valid_ref': validRef,
        'destroy_day_xfb': destroyDayXfb,
        'destroy_day_u': destroyDayU,
        'destroy_month_xfb': destroyMonthXfb,
        'destroy_month_u': destroyMonthU,
        'team_miner': teamMiner,
      };
}

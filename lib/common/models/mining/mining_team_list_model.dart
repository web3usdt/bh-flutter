import 'package:BBIExchange/common/index.dart';

class MiningTeamListModel {
  int? userId;
  int? id;
  String? name;
  String? account;
  int? accountType;
  String? username;
  int? referrer;
  int? pid;
  int? deep;
  dynamic path;
  dynamic countryId;
  dynamic countryCode;
  String? phone;
  int? phoneStatus;
  String? email;
  int? emailStatus;
  String? avatar;
  dynamic googleToken;
  int? googleStatus;
  int? secondVerify;
  String? inviteCode;
  String? purchaseCode;
  int? userGrade;
  int? userIdentity;
  int? isAgency;
  int? isPlace;
  int? userAuthLevel;
  int? isSystem;
  int? contractDeal;
  int? status;
  int? tradeStatus;
  int? tradeVerify;
  int? contractAnomaly;
  String? regIp;
  String? lastLoginTime;
  String? lastLoginIp;
  String? createdAt;
  String? updatedAt;
  dynamic rememberToken;
  dynamic subscribeRebateRate;
  dynamic contractRebateRate;
  dynamic optionRebateRate;
  dynamic remark;
  int? level;
  String? levelName;
  String? totalPower;
  int? minerCount;
  int? minerNoactiveCount;
  String? destroyAmount;
  String? teamPath;
  int? riskLevel;
  String? totalRecharge;
  String? totalWithdraw;
  int? teamStatus;
  int? teamDealStatus;
  int? isSetPayword;
  String? statusText;
  String? userAuthLevelText;
  String? userGradeName;
  String? userIdentityText;
  double? produceNum;

  MiningTeamListModel({
    this.userId,
    this.id,
    this.name,
    this.account,
    this.accountType,
    this.username,
    this.referrer,
    this.pid,
    this.deep,
    this.path,
    this.countryId,
    this.countryCode,
    this.phone,
    this.phoneStatus,
    this.email,
    this.emailStatus,
    this.avatar,
    this.googleToken,
    this.googleStatus,
    this.secondVerify,
    this.inviteCode,
    this.purchaseCode,
    this.userGrade,
    this.userIdentity,
    this.isAgency,
    this.isPlace,
    this.userAuthLevel,
    this.isSystem,
    this.contractDeal,
    this.status,
    this.tradeStatus,
    this.tradeVerify,
    this.contractAnomaly,
    this.regIp,
    this.lastLoginTime,
    this.lastLoginIp,
    this.createdAt,
    this.updatedAt,
    this.rememberToken,
    this.subscribeRebateRate,
    this.contractRebateRate,
    this.optionRebateRate,
    this.remark,
    this.level,
    this.levelName,
    this.totalPower,
    this.minerCount,
    this.minerNoactiveCount,
    this.destroyAmount,
    this.teamPath,
    this.riskLevel,
    this.totalRecharge,
    this.totalWithdraw,
    this.teamStatus,
    this.teamDealStatus,
    this.isSetPayword,
    this.statusText,
    this.userAuthLevelText,
    this.userGradeName,
    this.userIdentityText,
    this.produceNum,
  });

  factory MiningTeamListModel.fromJson(Map<String, dynamic> json) {
    return MiningTeamListModel(
      userId: DataUtils.toInt(json['user_id']),
      id: DataUtils.toInt(json['id']),
      name: DataUtils.toStr(json['name']),
      account: DataUtils.toStr(json['account']),
      accountType: DataUtils.toInt(json['account_type']),
      username: DataUtils.toStr(json['username']),
      referrer: DataUtils.toInt(json['referrer']),
      pid: DataUtils.toInt(json['pid']),
      deep: DataUtils.toInt(json['deep']),
      path: DataUtils.toStr(json['path']),
      countryId: DataUtils.toStr(json['country_id']),
      countryCode: DataUtils.toStr(json['country_code']),
      phone: DataUtils.toStr(json['phone']),
      phoneStatus: DataUtils.toInt(json['phone_status']),
      email: DataUtils.toStr(json['email']),
      emailStatus: DataUtils.toInt(json['email_status']),
      avatar: DataUtils.toStr(json['avatar']),
      googleToken: DataUtils.toStr(json['google_token']),
      googleStatus: DataUtils.toInt(json['google_status']),
      secondVerify: DataUtils.toInt(json['second_verify']),
      inviteCode: DataUtils.toStr(json['invite_code']),
      purchaseCode: DataUtils.toStr(json['purchase_code']),
      userGrade: DataUtils.toInt(json['user_grade']),
      userIdentity: DataUtils.toInt(json['user_identity']),
      isAgency: DataUtils.toInt(json['is_agency']),
      isPlace: DataUtils.toInt(json['is_place']),
      userAuthLevel: DataUtils.toInt(json['user_auth_level']),
      isSystem: DataUtils.toInt(json['is_system']),
      contractDeal: DataUtils.toInt(json['contract_deal']),
      status: DataUtils.toInt(json['status']),
      tradeStatus: DataUtils.toInt(json['trade_status']),
      tradeVerify: DataUtils.toInt(json['trade_verify']),
      contractAnomaly: DataUtils.toInt(json['contract_anomaly']),
      regIp: DataUtils.toStr(json['reg_ip']),
      lastLoginTime: DataUtils.toStr(json['last_login_time']),
      lastLoginIp: DataUtils.toStr(json['last_login_ip']),
      createdAt: DataUtils.toStr(json['created_at']),
      updatedAt: DataUtils.toStr(json['updated_at']),
      rememberToken: DataUtils.toStr(json['remember_token']),
      subscribeRebateRate: DataUtils.toStr(json['subscribe_rebate_rate']),
      contractRebateRate: DataUtils.toStr(json['contract_rebate_rate']),
      optionRebateRate: DataUtils.toStr(json['option_rebate_rate']),
      remark: DataUtils.toStr(json['remark']),
      level: DataUtils.toInt(json['level']),
      levelName: DataUtils.toStr(json['level_name']),
      totalPower: DataUtils.toStr(json['total_power']),
      minerCount: DataUtils.toInt(json['miner_count']),
      minerNoactiveCount: DataUtils.toInt(json['miner_noactive_count']),
      destroyAmount: DataUtils.toStr(json['destroy_amount']),
      teamPath: DataUtils.toStr(json['team_path']),
      riskLevel: DataUtils.toInt(json['risk_level']),
      totalRecharge: DataUtils.toStr(json['total_recharge']),
      totalWithdraw: DataUtils.toStr(json['total_withdraw']),
      teamStatus: DataUtils.toInt(json['team_status']),
      teamDealStatus: DataUtils.toInt(json['team_deal_status']),
      isSetPayword: DataUtils.toInt(json['is_set_payword']),
      statusText: DataUtils.toStr(json['status_text']),
      userAuthLevelText: DataUtils.toStr(json['user_auth_level_text']),
      userGradeName: DataUtils.toStr(json['user_grade_name']),
      userIdentityText: DataUtils.toStr(json['user_identity_text']),
      produceNum: DataUtils.toDouble(json['produce_num']),
    );
  }

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'id': id,
        'name': name,
        'account': account,
        'account_type': accountType,
        'username': username,
        'referrer': referrer,
        'pid': pid,
        'deep': deep,
        'path': path,
        'country_id': countryId,
        'country_code': countryCode,
        'phone': phone,
        'phone_status': phoneStatus,
        'email': email,
        'email_status': emailStatus,
        'avatar': avatar,
        'google_token': googleToken,
        'google_status': googleStatus,
        'second_verify': secondVerify,
        'invite_code': inviteCode,
        'purchase_code': purchaseCode,
        'user_grade': userGrade,
        'user_identity': userIdentity,
        'is_agency': isAgency,
        'is_place': isPlace,
        'user_auth_level': userAuthLevel,
        'is_system': isSystem,
        'contract_deal': contractDeal,
        'status': status,
        'trade_status': tradeStatus,
        'trade_verify': tradeVerify,
        'contract_anomaly': contractAnomaly,
        'reg_ip': regIp,
        'last_login_time': lastLoginTime,
        'last_login_ip': lastLoginIp,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'remember_token': rememberToken,
        'subscribe_rebate_rate': subscribeRebateRate,
        'contract_rebate_rate': contractRebateRate,
        'option_rebate_rate': optionRebateRate,
        'remark': remark,
        'level': level,
        'level_name': levelName,
        'total_power': totalPower,
        'miner_count': minerCount,
        'miner_noactive_count': minerNoactiveCount,
        'destroy_amount': destroyAmount,
        'team_path': teamPath,
        'risk_level': riskLevel,
        'total_recharge': totalRecharge,
        'total_withdraw': totalWithdraw,
        'team_status': teamStatus,
        'team_deal_status': teamDealStatus,
        'is_set_payword': isSetPayword,
        'status_text': statusText,
        'user_auth_level_text': userAuthLevelText,
        'user_grade_name': userGradeName,
        'user_identity_text': userIdentityText,
        'produce_num': produceNum,
      };
}

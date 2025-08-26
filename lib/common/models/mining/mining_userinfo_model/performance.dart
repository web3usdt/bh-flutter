import 'package:BBIExchange/common/index.dart';

class Performance {
  String? destroyPowerU;
  String? teamRewardU;
  String? teamIncomePowerU;
  String? daquDestoryCoinU;
  String? xiaoquDestoryCoinU;
  String? teamDestroyDayU;
  String? teamDestroyMonthU;
  String? teamDestroyAllU;
  String? totalIncomeU;
  String? destoryIncomeU;
  String? totalIncome;

  Performance({
    this.destroyPowerU,
    this.teamRewardU,
    this.teamIncomePowerU,
    this.daquDestoryCoinU,
    this.xiaoquDestoryCoinU,
    this.teamDestroyDayU,
    this.teamDestroyMonthU,
    this.teamDestroyAllU,
    this.totalIncomeU,
    this.destoryIncomeU,
    this.totalIncome,
  });

  factory Performance.fromJson(Map<String, dynamic> json) => Performance(
        destroyPowerU: DataUtils.toStr(json['destroy_power_u']),
        totalIncomeU: DataUtils.toStr(json['total_income_u']),
        teamRewardU: DataUtils.toStr(json['team_reward_u']),
        teamIncomePowerU: DataUtils.toStr(json['team_income_power_u']),
        daquDestoryCoinU: DataUtils.toStr(json['daqu_destory_coin_u']),
        xiaoquDestoryCoinU: DataUtils.toStr(json['xiaoqu_destroy_coin_u']),
        teamDestroyDayU: DataUtils.toStr(json['team_destroy_daily_u']),
        teamDestroyMonthU: DataUtils.toStr(json['team_destroy_monthly_u']),
        teamDestroyAllU: DataUtils.toStr(json['team_destroy_all_u']),
        destoryIncomeU: DataUtils.toStr(json['destory_income_u']),
        totalIncome: DataUtils.toStr(json['total_income']),
      );

  Map<String, dynamic> toJson() => {
        'destroy_power_u': destroyPowerU,
        'reward_power_u': teamRewardU,
        'team_income_power_u': teamIncomePowerU,
        'daqu_destory_coin_u': daquDestoryCoinU,
        'xiaoqu_destory_coin_u': xiaoquDestoryCoinU,
        'team_destroy_day_u': teamDestroyDayU,
        'team_destroy_month_u': teamDestroyMonthU,
        'team_destroy_all_u': teamDestroyAllU,
        'total_income_u': totalIncomeU,
        'destory_income_u': destoryIncomeU,
        'total_income': totalIncome,
      };
}

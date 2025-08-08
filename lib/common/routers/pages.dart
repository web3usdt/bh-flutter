import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:BBIExchange/pages/assets/withdraw_setup/index.dart';
import 'package:BBIExchange/pages/game/game_assets_record/index.dart';
import 'package:BBIExchange/pages/game/game_detail/index.dart';
import 'package:BBIExchange/pages/game/hash_game/index.dart';
import 'package:BBIExchange/pages/game/hash_game_detail/index.dart';
import 'package:BBIExchange/pages/login/remove_google/index.dart';

// 各模块页面引入（可按模块折叠管理）
import 'package:BBIExchange/pages/login/start/index.dart';
import 'package:BBIExchange/pages/login/login/index.dart';
import 'package:BBIExchange/pages/login/register/index.dart';
import 'package:BBIExchange/pages/login/download_app/index.dart';
import 'package:BBIExchange/pages/login/forgot_password/index.dart';
import 'package:BBIExchange/pages/login/forgot_password/bindings.dart';
import 'package:BBIExchange/pages/login/network_diagnosis/index.dart';

import 'package:BBIExchange/pages/tab/main/index.dart';
import 'package:BBIExchange/pages/tab/main/binding.dart';

import 'package:BBIExchange/pages/home/notice_list/index.dart';
import 'package:BBIExchange/pages/home/notice_detail/index.dart';
import 'package:BBIExchange/pages/home/k_chart_socket/index.dart';
import 'package:BBIExchange/pages/home/contract_k_chart_socket/index.dart';
import 'package:BBIExchange/pages/home/subscribe/index.dart';
import 'package:BBIExchange/pages/home/subscribe_record/index.dart';

import 'package:BBIExchange/pages/assets/recharge/index.dart';
import 'package:BBIExchange/pages/assets/withdraw/index.dart';
import 'package:BBIExchange/pages/assets/transfer/index.dart';
import 'package:BBIExchange/pages/assets/assets_record/index.dart';
import 'package:BBIExchange/pages/assets/withdraw_address/index.dart';
import 'package:BBIExchange/pages/assets/withdraw_address_edit/index.dart';

import 'package:BBIExchange/pages/mine/userinfo/index.dart';
import 'package:BBIExchange/pages/mine/setup/index.dart';
import 'package:BBIExchange/pages/mine/switch_account/index.dart';
import 'package:BBIExchange/pages/mine/edit_password/index.dart';
import 'package:BBIExchange/pages/mine/share/index.dart';
import 'package:BBIExchange/pages/mine/theme/index.dart';
import 'package:BBIExchange/pages/mine/customer_server/view.dart';
import 'package:BBIExchange/pages/mine/customer_server/index.dart';
import 'package:BBIExchange/pages/mine/google/index.dart';
import 'package:BBIExchange/pages/mine/google_bind/index.dart';
import 'package:BBIExchange/pages/mine/google_unbind/index.dart';
import 'package:BBIExchange/pages/mine/realname/index.dart';
import 'package:BBIExchange/pages/mine/realname_aws/index.dart';
import 'package:BBIExchange/pages/mine/realname_aws_status/index.dart';
import 'package:BBIExchange/pages/mine/realname_list/index.dart';
import 'package:BBIExchange/pages/mine/develop_mode/index.dart';

import 'package:BBIExchange/pages/coin/my_authorize/index.dart';
import 'package:BBIExchange/pages/contract/my_authorize/index.dart';
import 'package:BBIExchange/pages/option/option_buy/index.dart';
import 'package:BBIExchange/pages/option/option_buy_record/index.dart';

import 'package:BBIExchange/pages/mining/my_mining/index.dart';
import 'package:BBIExchange/pages/mining/mining_output/index.dart';
import 'package:BBIExchange/pages/mining/mining_record/index.dart';
import 'package:BBIExchange/pages/mining/team/index.dart';
import 'package:BBIExchange/pages/mining/network/index.dart';
import 'package:BBIExchange/pages/mining/get_power/index.dart';

import 'observers.dart';

class AppRoutes {
  // 登录流程
  /// 启动页
  static const start = '/startPage';

  /// 登录页
  static const login = '/loginPage';

  /// 注册页
  static const register = '/registerPage';

  /// 忘记密码
  static const forgotPassword = '/forgotPasswordPage';

  /// 下载app
  static const downloadApp = '/downloadAppPage';

  /// 网络诊断
  static const networkDiagnosis = '/networkDiagnosisPage';

  /// 首页
  static const home = '/homePage';

  /// 公告列表
  static const noticeList = '/noticeListPage';

  /// 公告详情
  static const noticeDetail = '/noticeDetailPage';

  /// K线
  static const kChart = '/kChartPage';

  /// 合约K线
  static const contractKChart = '/contractKChartPage';

  /// 订阅
  static const subscribe = '/subscribePage';

  /// 订阅记录
  static const subscribeRecord = '/subscribeRecordPage';

  /// 个人中心
  static const setup = '/setupPage';

  /// 用户信息
  static const userinfo = '/userinfoPage';

  /// 切换账号
  static const switchAccount = '/switchAccountPage';

  /// 修改密码
  static const editPassword = '/editPasswordPage';

  /// 分享
  static const share = '/sharePage';

  /// 主题
  static const theme = '/themePage';

  /// 客服
  static const customerService = '/customerServicePage';

  /// 谷歌验证器具
  static const google = '/googlePage';

  /// 谷歌绑定
  static const googleBind = '/googleBindPage';

  /// 谷歌解绑
  static const googleUnbind = '/googleUnbindPage';

  /// 解绑谷歌验证
  static const removeGoogle = '/removeGooglePage';

  /// 实名认证
  static const realName = '/realNamePage';

  /// 实名认证列表
  static const realNameList = '/realNameListPage';

  /// 实名认证AWS
  static const realNameAws = '/realNameAwsPage';

  /// 实名认证AWS状态
  static const realNameAwsStatus = '/realnameAwsStatusPage';

  /// 开发模式
  static const developMode = '/developModePage';

  // 资产
  /// 充值
  static const recharge = '/rechargePage';

  /// 提现
  static const withdraw = '/withdrawPage';

  /// 提现设置
  static const withdrawSetup = '/withdrawSetupPage';

  /// 转账
  static const transfer = '/transferPage';

  /// 资产记录
  static const assetsRecord = '/assetsRecordPage';

  /// 提现地址
  static const withdrawAddress = '/withdrawAddressPage';

  /// 提现地址编辑
  static const withdrawAddressEdit = '/withdrawAddressEditPage';

  // 交易
  /// 我的授权
  static const myAuthorize = '/myAuthorizePage';

  /// 我的授权合约
  static const myAuthorizeContract = '/myAuthorizeContractPage';

  // 期权
  /// 期权购买
  static const optionBuy = '/optionBuyPage';

  /// 期权购买记录
  static const optionBuyRecord = '/optionBuyRecordPage';

  // 矿机
  /// 我的矿机
  static const myMining = '/myMiningPage';

  /// 矿机产出
  static const miningOutput = '/miningOutputPage';

  /// 矿机记录
  static const miningRecord = '/miningRecordPage';

  /// 团队
  static const team = '/teamPage';

  /// 全网算力
  static const network = '/networkPage';

  /// 获取算力
  static const getPower = '/getPowerPage';

  /// 哈希游戏
  static const hashGame = '/hashGamePage';

  /// 游戏资产记录
  static const gameAssetRecord = '/gameAssetRecordPage';

  // 游戏详情
  static const gameDetail = '/gameDetailPage';

  static const hashGameDetail = '/hashGameDetailPage';
}

class RoutePages {
  static final RouteObserver<Route> observer = RouteObservers();
  static final List<String> history = [];

  static final List<GetPage> list = [
    // 登录流程
    GetPage(name: AppRoutes.start, page: () => const StartPage()),
    GetPage(name: AppRoutes.login, page: () => const LoginPage()),
    GetPage(name: AppRoutes.register, page: () => const RegisterPage()),
    GetPage(name: AppRoutes.forgotPassword, page: () => const ForgotPasswordPage(), binding: ForgotPasswordBinding()),
    GetPage(name: AppRoutes.downloadApp, page: () => const DownloadAppPage()),
    GetPage(name: AppRoutes.networkDiagnosis, page: () => const NetworkDiagnosisPage()),

    // 首页
    GetPage(name: AppRoutes.home, page: () => const MainPage(), binding: MainBinding()),
    GetPage(name: AppRoutes.noticeList, page: () => const NoticeListPage()),
    GetPage(name: AppRoutes.noticeDetail, page: () => const NoticeDetailPage()),
    GetPage(name: AppRoutes.kChart, page: () => const KChartPage()),
    GetPage(name: AppRoutes.contractKChart, page: () => const ContractKChartPage()),
    GetPage(name: AppRoutes.subscribe, page: () => const SubscribePage()),
    GetPage(name: AppRoutes.subscribeRecord, page: () => const SubscribeRecordPage()),

    // 我的
    GetPage(name: AppRoutes.setup, page: () => const SetupPage()),
    GetPage(name: AppRoutes.userinfo, page: () => const UserinfoPage()),
    GetPage(name: AppRoutes.switchAccount, page: () => const SwitchAccountPage()),
    GetPage(name: AppRoutes.editPassword, page: () => const EditPasswordPage()),
    GetPage(name: AppRoutes.share, page: () => const SharePage()),
    GetPage(name: AppRoutes.theme, page: () => const ThemePage()),
    GetPage(name: AppRoutes.customerService, page: () => const CustomerServerPage()),
    GetPage(name: AppRoutes.google, page: () => const GooglePage()),
    GetPage(name: AppRoutes.googleBind, page: () => const GoogleBindPage()),
    GetPage(name: AppRoutes.googleUnbind, page: () => const GoogleUnbindPage()),
    GetPage(name: AppRoutes.removeGoogle, page: () => const RemoveGooglePage()),
    GetPage(name: AppRoutes.realName, page: () => const RealnamePage()),
    GetPage(name: AppRoutes.realNameList, page: () => const RealnameListPage()),
    GetPage(name: AppRoutes.realNameAws, page: () => const RealnameAwsPage()),
    GetPage(name: AppRoutes.realNameAwsStatus, page: () => const RealnameAwsStatusPage()),
    GetPage(name: AppRoutes.developMode, page: () => const DevelopModePage()),

    // 资产
    GetPage(name: AppRoutes.recharge, page: () => const RechargePage()),
    GetPage(name: AppRoutes.withdraw, page: () => const WithdrawPage()),
    GetPage(name: AppRoutes.transfer, page: () => const TransferPage()),
    GetPage(name: AppRoutes.assetsRecord, page: () => const AssetsRecordPage()),
    GetPage(name: AppRoutes.withdrawAddress, page: () => const WithdrawAddressPage()),
    GetPage(name: AppRoutes.withdrawAddressEdit, page: () => const WithdrawAddressEditPage()),
    GetPage(name: AppRoutes.withdrawSetup, page: () => const WithdrawSetupPage()),
    // 交易
    GetPage(name: AppRoutes.myAuthorize, page: () => const MyAuthorizePage()),
    GetPage(name: AppRoutes.myAuthorizeContract, page: () => const MyAuthorizeContractPage()),

    // 期权
    GetPage(name: AppRoutes.optionBuy, page: () => const OptionBuyPage()),
    GetPage(name: AppRoutes.optionBuyRecord, page: () => const OptionBuyRecordPage()),

    // 矿机
    GetPage(name: AppRoutes.myMining, page: () => const MyMiningPage()),
    GetPage(name: AppRoutes.miningOutput, page: () => const MiningOutputPage()),
    GetPage(name: AppRoutes.miningRecord, page: () => const MiningRecordPage()),
    GetPage(name: AppRoutes.team, page: () => const TeamPage()),
    GetPage(name: AppRoutes.network, page: () => const NetworkPage()),
    GetPage(name: AppRoutes.getPower, page: () => const GetPowerPage()),

    // 游戏
    GetPage(name: AppRoutes.hashGame, page: () => const HashGamePage()),
    GetPage(name: AppRoutes.gameAssetRecord, page: () => const GameAssetsRecordPage()),
    GetPage(name: AppRoutes.gameDetail, page: () => const GameDetailPage()),
    GetPage(name: AppRoutes.hashGameDetail, page: () => const HashGameDetailPage()),
  ];
}

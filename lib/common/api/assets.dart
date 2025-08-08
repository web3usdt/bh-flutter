import '../index.dart';

class AssetsApi {
  // 获取资金账户币种余额
  static Future<AssetsRecordBalanceModel> getRecordBalance(String symbol, String type) async {
    final res = await WPHttpService.to.post(
      '/api/app/user/appTokenAssets',
      data: {'coin_name': symbol, 'account_type': type},
    );
    return AssetsRecordBalanceModel.fromJson(res.data['data']);
  }

  // 获取资金账户币种流水列表
  static Future<List<AssetsRecordListModel>> getRecordList(PageListReq req) async {
    print('获取资金账户币种流水列表: ${req.toJson()}');
    final res = await WPHttpService.to.get(
      '/api/app/user/getWalletLogs',
      params: req.toJson(),
    );
    final data = res.data['data']['data'];
    if (data != null && data is List && data.isNotEmpty) {
      return data.map((e) => AssetsRecordListModel.fromJson(e)).toList();
    }
    return [];
  }

  // 获取合约账户流水
  static Future<List<AssetsRecordListModel>> getContractRecordList(PageListReq req) async {
    final res = await WPHttpService.to.get(
      '/api/app/contract/accountFlow',
      params: req.toJson(),
    );
    final data = res.data['data']['data'];
    if (data != null && data is List && data.isNotEmpty) {
      return data.map((e) => AssetsRecordListModel.fromJson(e)).toList();
    }
    return [];
  }

  // 获取理财账户币种流水
  static Future<List<AssetsRecordListModel>> getLicaiRecordList(PageListReq req) async {
    print('获取理财账户币种流水: ${req.toJson()}');
    final res = await WPHttpService.to.get(
      '/api/app/user/getEarnLogs',
      params: req.toJson(),
    );
    final data = res.data['data']['data'];
    if (data != null && data is List && data.isNotEmpty) {
      return data.map((e) => AssetsRecordListModel.fromJson(e)).toList();
    }
    return [];
  }

  // 获取提现地址列表
  static Future<List<AssetsWithdrawAddressListModel>> getWithdrawAddressList() async {
    final res = await WPHttpService.to.post(
      '/api/app/user/withdrawalAddressManagement',
    );
    final data = res.data['data'];
    if (data != null && data is List && data.isNotEmpty) {
      return data.map((e) => AssetsWithdrawAddressListModel.fromJson(e)).toList();
    }
    return [];
  }

  // 添加提币地址
  static Future<bool> addWithdrawAddress(AssetsWithdrawAddReq req) async {
    await WPHttpService.to.post(
      '/api/app/user/withdrawalAddressAdd',
      data: req.toJson(),
    );
    return true;
  }

  // 删除提币地址
  static Future<bool> deleteWithdrawAddress(id) async {
    await WPHttpService.to.post(
      '/api/app/user/withdrawalAddressDeleted',
      data: {'id': id},
    );
    return true;
  }

  // 编辑提币地址
  static Future<bool> editWithdrawAddress(AssetsWithdrawAddReq req) async {
    await WPHttpService.to.post(
      '/api/app/user/withdrawalAddressModify',
      data: req.toJson(),
    );
    return true;
  }

  // 获取币种列表
  static Future<List<AssetsFundAccountListModel>> getFundAccountList() async {
    final res = await WPHttpService.to.post(
      '/api/app/user/fundAccount',
    );
    final data = res.data['data']['list'];
    if (data != null && data is List && data.isNotEmpty) {
      return data.map((e) => AssetsFundAccountListModel.fromJson(e)).toList();
    }
    return [];
  }

  // 获取提币余额
  static Future<AssetsWdithdrawBalanceModel> getWithdrawBalance(AssetsWidthdrawBalanceReq req) async {
    final res = await WPHttpService.to.post(
      '/api/app/user/withdrawalBalance',
      data: req.toJson(),
    );
    print('提币余额原始数据: ${res.data}');
    return AssetsWdithdrawBalanceModel.fromJson(res.data['data']);
  }

  // 提币
  static Future<bool> withdraw(AssetsWidthdrawReq req) async {
    await WPHttpService.to.post(
      '/api/app/user/withdraw',
      data: req.toJson(),
    );
    return true;
  }

  // 获取提币记录
  static Future<List<AssetsWithdrawRecordModel>> getWithdrawRecord(PageListReq req) async {
    final res = await WPHttpService.to.post(
      '/api/app/user/withdrawalRecord',
      data: req.toJson(),
    );
    final data = res.data['data']['data'];
    if (data != null && data is List && data.isNotEmpty) {
      return data.map((e) => AssetsWithdrawRecordModel.fromJson(e)).toList();
    }
    return [];
  }

  // 撤销提币
  static Future<bool> cancelWithdraw(id) async {
    await WPHttpService.to.post(
      '/api/app/user/cancelWithdraw',
      data: {'withdraw_id': id},
    );
    return true;
  }

  // 获取充值记录
  static Future<List<AssetsRechargeRecordModel>> getRechargeRecord(PageListReq req) async {
    final res = await WPHttpService.to.post(
      '/api/app/user/depositHistory',
      data: req.toJson(),
    );
    final data = res.data['data']['data'];
    if (data != null && data is List && data.isNotEmpty) {
      return data.map((e) => AssetsRechargeRecordModel.fromJson(e)).toList();
    }
    return [];
  }

  // 获取充值网络列表
  static Future<List<AssetsRechargeNetworkListModel>> getRechargeNetworkList() async {
    final res = await WPHttpService.to.post(
      '/api/app/user/rechargeNetworkList',
    );
    final data = res.data['data'];
    if (data != null && data is List && data.isNotEmpty) {
      return data.map((e) => AssetsRechargeNetworkListModel.fromJson(e)).toList();
    }
    return [];
  }

  // 获取充值地址
  static Future<String?> getRechargeAddress(AssetsRechargeAddressReq req) async {
    final res = await WPHttpService.to.post(
      '/api/app/user/walletImage',
      data: req.toJson(),
    );
    print('充值地址原始数据: ${res.data}');
    return DataUtils.toStr(res.data['data']['address']);
  }

  // 获取转账账户
  static Future<List<AssetsTransferAccountsModel>> getTransferAccounts() async {
    final res = await WPHttpService.to.get(
      '/api/app/wallet/accounts',
    );
    final data = res.data['data'];
    if (data != null && data is List && data.isNotEmpty) {
      return data.map((e) => AssetsTransferAccountsModel.fromJson(e)).toList();
    }
    return [];
  }

  // 获取转账币种列表
  static Future<List<AssetsTransferCoinlistModel>> getTransferCoinlist(AssetsTransferCoinlistReq req) async {
    final res = await WPHttpService.to.get(
      '/api/app/wallet/coinList',
      params: req.toJson(),
    );
    final data = res.data['data'];
    if (data != null && data is List && data.isNotEmpty) {
      return data.map((e) => AssetsTransferCoinlistModel.fromJson(e)).toList();
    }
    return [];
  }

  // 获取转账余额
  static Future<AssetsTransferBalanceModel> getTransferBalance(AssetsTransferBalanceReq req) async {
    final res = await WPHttpService.to.get(
      '/api/app/wallet/getBalance',
      params: req.toJson(),
    );
    return AssetsTransferBalanceModel.fromJson(res.data['data']);
  }

  // 转账
  static Future<bool> transfer(AssetsTransferReq req) async {
    await WPHttpService.to.post(
      '/api/app/wallet/transfer',
      data: req.toJson(),
    );
    return true;
  }

  // 获取转账记录
  static Future<List<AssetsTransferRecordModel>> getTransferRecord(PageListReq req) async {
    final res = await WPHttpService.to.post(
      '/api/app/user/transferRecord',
      data: req.toJson(),
    );
    final data = res.data['data']['data'];
    if (data != null && data is List && data.isNotEmpty) {
      return data.map((e) => AssetsTransferRecordModel.fromJson(e)).toList();
    }
    return [];
  }

  // 获取资金账户总资产usdt
  static Future<AssetsPersonalAccountModel> getPersonalAccount() async {
    final res = await WPHttpService.to.post(
      '/api/app/user/personalAssets',
    );
    return AssetsPersonalAccountModel.fromJson(res.data['data']);
  }

  // 获取挖矿账户总资产usdt
  static Future<List<AssetsMinerAccountModel>> getMinerAccount() async {
    final res = await WPHttpService.to.get(
      '/api/app/user/minerAccount',
    );
    final data = res.data['data'];
    if (data != null && data is List && data.isNotEmpty) {
      return data.map((e) => AssetsMinerAccountModel.fromJson(e)).toList();
    }
    return [];
  }

  // 获取理财账户总资产usdt
  static Future<AssetsLicaiModel> getlicaiAccount() async {
    final res = await WPHttpService.to.get(
      '/api/app/user/earnAccount',
    );
    return AssetsLicaiModel.fromJson(res.data['data']);
  }
}

import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:BBIExchange/common/index.dart';
import 'package:decimal/decimal.dart';

class AssetsController extends GetxController {
  AssetsController();
  // 是否显示搜索框
  bool isShowSearch = false;
  // 是否隐藏资产页面余额为0的资产
  bool isHideAssetsPageBalance = false;
  // 总资产折合显示/隐藏
  bool isShowTotalAssetsBtc = true;
  // 当前tab
  int currentTab = 0;
  // 搜索框
  TextEditingController searchController = TextEditingController();
  // 币种列表
  List<AssetsFundAccountListModel> assetsCoinList = [];
  // 过滤后的币种列表
  List<AssetsFundAccountListModel> filteredCoinList = [];
  // 挖矿账户列表
  List<AssetsMinerAccountModel> minerAccountList = [];
  // 个人账户
  AssetsPersonalAccountModel personalAccount = AssetsPersonalAccountModel();
  // 理财余额
  String? licaiBalance;
  // 理财币种列表
  List<AssetsFundAccountListModel> licaiCoinList = [];

  // 游戏，资产切换
  bool isShowGame = false;
  void changeShowGame(bool value) {
    isShowGame = value;
    update(["assets"]);
  }

  // 切换搜索框显示/隐藏
  changeShowSearch(bool value) {
    isShowSearch = value;
    update(["assets"]);
  }

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  _initData() async {
    isHideAssetsPageBalance = Storage().getBool('isHideAssetsPageBalance');
    isShowTotalAssetsBtc = Storage().getBool('isShowTotalAssetsBtc');
    update(["assets"]);

    // 获取币种列表
    assetsCoinList = await AssetsApi.getFundAccountList();
    filteredCoinList = assetsCoinList;
    Storage().setJson('assetsCoinList', assetsCoinList);

    // 获取个人账户
    personalAccount = await AssetsApi.getPersonalAccount();
    Storage().setJson('personalAccount', personalAccount);

    // 获取挖矿账户列表
    minerAccountList = await AssetsApi.getMinerAccount();
    Storage().setJson('minerAccountList', minerAccountList);

    // 获取理财账户
    var res = await AssetsApi.getlicaiAccount();
    licaiBalance = res.totalAssetsUsdt;
    licaiCoinList = res.list;
    Storage().setJson('licaiCoinList', licaiCoinList);
    update(["assets"]);
  }

  @override
  void onInit() {
    super.onInit();
    _loadCacheData();
    // 监听搜索框输入
    searchController.addListener(() {
      _filterList();
    });
  }

  // 过滤列表
  void _filterList() {
    if (searchController.text.isEmpty) {
      filteredCoinList = assetsCoinList;
    } else {
      filteredCoinList = assetsCoinList.where((item) {
        return item.coinName?.toLowerCase().contains(searchController.text.toLowerCase()) ?? false;
      }).toList();
    }
    update(["assets"]);
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // 加载缓存数据
  _loadCacheData() async {
    var stringAssetsCoinList = Storage().getString('assetsCoinList');
    assetsCoinList = stringAssetsCoinList != ""
        ? jsonDecode(stringAssetsCoinList).map<AssetsFundAccountListModel>((item) {
            return AssetsFundAccountListModel.fromJson(item);
          }).toList()
        : [];
    filteredCoinList = assetsCoinList;

    var stringMinerAccountList = Storage().getString('minerAccountList');
    minerAccountList = stringMinerAccountList != ""
        ? jsonDecode(stringMinerAccountList).map<AssetsMinerAccountModel>((item) {
            return AssetsMinerAccountModel.fromJson(item);
          }).toList()
        : [];

    var stringPersonalAccount = Storage().getString('personalAccount');
    personalAccount =
        stringPersonalAccount != "" ? AssetsPersonalAccountModel.fromJson(jsonDecode(stringPersonalAccount)) : AssetsPersonalAccountModel();

    var stringLicaiCoinList = Storage().getString('licaiCoinList');
    licaiCoinList = stringLicaiCoinList != ""
        ? jsonDecode(stringLicaiCoinList).map<AssetsFundAccountListModel>((item) {
            return AssetsFundAccountListModel.fromJson(item);
          }).toList()
        : [];

    update(["assets"]);
  }

  // 切换总资产折合显示/隐藏
  changeShowTotalAssetsBtc() {
    isShowTotalAssetsBtc = !isShowTotalAssetsBtc;
    Storage().setBool('isShowTotalAssetsBtc', isShowTotalAssetsBtc);
    update(["assets"]);
  }

  // 隐藏0余额资产
  hideAssetsPageBalance() {
    isHideAssetsPageBalance = !isHideAssetsPageBalance;
    Storage().setBool('isHideAssetsPageBalance', isHideAssetsPageBalance);
    if (isHideAssetsPageBalance) {
      filteredCoinList = assetsCoinList.where((item) {
        final usableBalance = Decimal.tryParse(item.usableBalance ?? '0') ?? Decimal.zero;
        return usableBalance > Decimal.zero;
      }).toList();
    } else {
      filteredCoinList = assetsCoinList;
    }
    update(["assets"]);
  }

  // 切换tab
  changeTab(int index) {
    currentTab = index;
    update(["assets"]);
  }
}

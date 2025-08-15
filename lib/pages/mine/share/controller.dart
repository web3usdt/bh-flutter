import 'dart:convert';

import 'package:BBIExchange/common/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class ShareController extends GetxController {
  ShareController();
  // 分享信息
  UserShareInfoModel shareInfo = UserShareInfoModel();
  // 列表
  List<UserShareRecordModel> items = [];
  // 二维码key
  final GlobalKey qrKey = GlobalKey();
  // 二维码内容
  String qrCodeContent = '';

  @override
  void onReady() {
    super.onReady();
    _initData();
  }

  _initData() async {
    shareInfo = await UserApi.getUserShareInfo();
    Storage().setJson('shareInfo', shareInfo.toJson());
    update(["share"]);
  }

  @override
  void onInit() {
    super.onInit();
    _loadCacheData();
  }

  // 加载缓存数据
  _loadCacheData() async {
    var stringUserShareRecordItems = Storage().getString('userShareRecordItems');
    items = stringUserShareRecordItems != ""
        ? jsonDecode(stringUserShareRecordItems).map<UserShareRecordModel>((item) {
            return UserShareRecordModel.fromJson(item);
          }).toList()
        : [];

    var stringShareInfo = Storage().getString('shareInfo');
    shareInfo = stringShareInfo != "" ? UserShareInfoModel.fromJson(jsonDecode(stringShareInfo)) : UserShareInfoModel();
    update(["share"]);
  }

  // 长按保存二维码
  Future<void> saveQrCode() async {
    // await ImageSaverHelper.saveNetworkImage(
    //   poster,
    //   fileName: "poster_${DateTime.now().millisecondsSinceEpoch}",
    // );
  }

  /*
  * 分页
  * refreshController：分页控制器
  * _page：分页
  * _limit：每页条数
  * _loadNewsSell:拉取数据（是否刷新）
  * onLoading：上拉加载新商品
  * onRefresh：下拉刷新
  * */
  final RefreshController refreshController = RefreshController(
    initialRefresh: true,
  );
  int _page = 1;
  Future<bool> _loadNewsSell(bool isRefresh) async {
    var result = await UserApi.getUserShareRecord(PageListReq(
      page: isRefresh ? 1 : _page,
    ));
    if (isRefresh) {
      _page = 1;
      items.clear();
    }
    if (result.isNotEmpty) {
      _page++;
      items.addAll(result);
      if (_page <= 2) {
        Storage().setJson('userShareRecordItems', items);
      }
    } else {
      Storage().remove('userShareRecordItems');
    }
    // 是否是空
    return result.isEmpty;
  }

  // 上拉载入新商品
  void onLoading() async {
    if (items.isNotEmpty) {
      try {
        // 拉取数据是否为空 ? 设置暂无数据 ： 加载完成
        var isEmpty = await _loadNewsSell(false);
        isEmpty ? refreshController.loadNoData() : refreshController.loadComplete();
      } catch (e) {
        refreshController.loadFailed(); // 加载失败
      }
    } else {
      refreshController.loadNoData(); // 设置无数据
    }
    update(["share"]);
  }

  // 下拉刷新
  void onRefresh() async {
    try {
      await _loadNewsSell(true);
      refreshController.refreshCompleted();
    } catch (e) {
      refreshController.refreshFailed();
    }
    update(["share"]);
  }
}

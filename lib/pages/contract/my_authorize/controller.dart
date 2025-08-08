import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:BBIExchange/common/index.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class MyAuthorizeContractController extends GetxController with GetSingleTickerProviderStateMixin {
  MyAuthorizeContractController();
  // 活动列表
  List<UserShareActiveListModel> activeList = [];
  // 活动信息
  UserShareActiveInfoModel activeInfo = UserShareActiveInfoModel();
  // 海报
  String poster = '';

  // 当前委托
  List<ContractMyAuthorizeModel> currentAuthorizeItems = [];
  // 历史委托
  List<ContractMyAuthorizeModel> historyListItems = [];

  // tab 控制器
  late TabController tabController;
  // tab 索引
  int tabIndex = 0;
  // tab 名称
  List<String> tabNames = [
    '当前委托'.tr,
    '历史委托'.tr,
  ];

  @override
  void onClose() {
    super.onClose();
    refreshController.dispose();
  }

  @override
  void onInit() {
    super.onInit();
    // 初始化时设置当前索引
    tabController = TabController(
      length: tabNames.length,
      vsync: this,
      initialIndex: tabIndex, // 设置初始索引
    );
    // 监听 tab 切换
    tabController.addListener(() {
      if (tabController.indexIsChanging) {
        tabIndex = tabController.index;
        update(["my_authorize_contract"]);
      }
    });
    _loadCacheData();
  }

  // 加载缓存数据
  _loadCacheData() async {
    var stringCurrentAuthorizeItems = Storage().getString('ContractCurrentAuthorizeItems');
    currentAuthorizeItems = stringCurrentAuthorizeItems != ""
        ? jsonDecode(stringCurrentAuthorizeItems).map<ContractMyAuthorizeModel>((item) {
            return ContractMyAuthorizeModel.fromJson(item);
          }).toList()
        : [];

    var stringHistoryListItems = Storage().getString('ContractHistoryListItems');
    historyListItems = stringHistoryListItems != ""
        ? jsonDecode(stringHistoryListItems).map<ContractMyAuthorizeModel>((item) {
            return ContractMyAuthorizeModel.fromJson(item);
          }).toList()
        : [];
    update(["my_authorize_contract"]);
  }

  // 订单状态改变
  changeTabIndex(int index) {
    tabIndex = index;
    // 刷新订单列表
    refreshController.requestRefresh();
    update(["my_authorize_contract"]);
  }

  // 撤销
  void onCancel(ContractMyAuthorizeModel item) {
    showGeneralDialog(
      context: Get.context!,
      pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
        return DialogWidget(
          title: '撤销'.tr,
          description: '确定撤销委托吗？'.tr,
          onConfirm: () async {
            Get.back();
            Loading.show();
            var req = CoinCancelAuthorizeReq(
              entrustId: item.id,
              symbol: item.symbol,
            );
            var res = await ContractApi.cancelAuthorize(req);
            if (res) {
              Loading.success('撤销成功'.tr);
              refreshController.requestRefresh();
            }
          },
        );
      },
    );
  }

  String cals(int side, int orderType) {
    // side - order_type
    Map<String, String> map = {
      "1-1": '开多'.tr,
      "1-2": '平空'.tr,
      "2-1": '开空'.tr,
      "2-2": '平多'.tr,
    };
    return map['$side-$orderType'] ?? '';
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
    var result1 = <ContractMyAuthorizeModel>[];
    var result2 = <ContractMyAuthorizeModel>[];
    if (tabIndex == 0) {
      result1 = await ContractApi.myAuthorizeList(PageListReq(
        page: isRefresh ? 1 : _page,
      ));
    } else {
      result2 = await ContractApi.historyAuthorizeList(PageListReq(
        page: isRefresh ? 1 : _page,
      ));
    }
    if (isRefresh) {
      _page = 1;
      if (tabIndex == 0) {
        currentAuthorizeItems.clear();
      } else {
        historyListItems.clear();
      }
    }
    if (tabIndex == 0) {
      if (result1.isNotEmpty) {
        _page++;
        currentAuthorizeItems.addAll(result1);
        if (_page <= 2) {
          Storage().setJson('ContractCurrentAuthorizeItems', currentAuthorizeItems);
        }
      } else {
        Storage().remove('ContractCurrentAuthorizeItems');
      }
    } else {
      if (result2.isNotEmpty) {
        _page++;
        historyListItems.addAll(result2);
        if (_page <= 2) {
          Storage().setJson('ContractHistoryListItems', historyListItems);
        }
      } else {
        Storage().remove('ContractHistoryListItems');
      }
    }

    // 是否是空
    return tabIndex == 0 ? currentAuthorizeItems.isEmpty : historyListItems.isEmpty;
  }

  // 上拉载入新商品
  void onLoading() async {
    if (tabIndex == 0 ? currentAuthorizeItems.isNotEmpty : historyListItems.isNotEmpty) {
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
    update(["my_authorize_contract"]);
  }

  // 下拉刷新
  void onRefresh() async {
    try {
      await _loadNewsSell(true);
      refreshController.refreshCompleted();
    } catch (e) {
      refreshController.refreshFailed();
    }
    update(["my_authorize_contract"]);
  }

  // 邀请助力弹窗
  void showInviteFriendDialog() async {
    if (poster.isEmpty) {
      Loading.show();
      activeList = await UserApi.getUserShareActiveList();
      var batchNo = activeList.first.batchNo;
      activeInfo = await UserApi.getUserShareActiveInfo(batchNo ?? '');
      poster = await UserApi.getUserShareActive(activeInfo.batchNo ?? '');
      Loading.dismiss();
    }

    Get.dialog(
      barrierColor: Colors.black.withOpacity(0.7),
      Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: <Widget>[
            // 弹窗内容
            <Widget>[
              ImgWidget(
                path: poster,
                width: 590.w,
                height: 1080.w,
              ),
              SizedBox(height: 30.w),
              <Widget>[
                ButtonWidget(
                  text: '保存海报分享'.tr,
                  width: 240,
                  height: 88,
                  borderRadius: 44,
                  backgroundColor: AppTheme.colorfff,
                  textColor: AppTheme.color000,
                  onTap: () {
                    saveQrCode();
                  },
                ),
                ButtonWidget(
                  text: '复制活动邀请链接'.tr,
                  width: 240,
                  height: 88,
                  borderRadius: 44,
                  backgroundColor: AppTheme.colorfff,
                  textColor: AppTheme.color000,
                  onTap: () {
                    ClipboardUtils.copy(activeInfo.inviteUrl ?? '');
                  },
                ),
              ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
              SizedBox(height: 60.w),
              const Icon(
                Icons.close,
                size: 32,
                color: Colors.white,
              ).onTap(() {
                Get.back();
              }),
            ].toColumn().paddingAll(30.w),
          ].toColumn()),
    );
  }

  // 长按保存二维码
  Future<void> saveQrCode() async {
    await ImageSaverHelper.saveNetworkImage(
      poster,
      fileName: "poster_${DateTime.now().millisecondsSinceEpoch}",
    );
  }
}

import 'dart:convert';

import 'package:get/get.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:happy/common/index.dart';

class NoticeListController extends GetxController {
  NoticeListController();
  // 公告
  List<HomeNoticeListModel> noticeItems = [];
  // 系统消息
  List<HomeSystemMessageListModel> messageItems = [];
  // tab 索引
  int tabIndex = 0;
  // 切换tab
  changeTabIndex(int index) {
    if (tabIndex == index) return;
    tabIndex = index;
    refreshController.requestRefresh();
    update(["notice_list"]);
  }

  @override
  void onClose() {
    super.onClose();
    refreshController.dispose();
  }

  @override
  void onInit() {
    super.onInit();
    _loadCacheData();
  }

  // 加载缓存数据
  _loadCacheData() async {
    var stringNoticeItems = Storage().getString('noticeItems');
    noticeItems = stringNoticeItems != ""
        ? jsonDecode(stringNoticeItems).map<HomeNoticeListModel>((item) {
            return HomeNoticeListModel.fromJson(item);
          }).toList()
        : [];

    var stringMessageItems = Storage().getString('messageItems');
    messageItems = stringMessageItems != ""
        ? jsonDecode(stringMessageItems).map<HomeSystemMessageListModel>((item) {
            return HomeSystemMessageListModel.fromJson(item);
          }).toList()
        : [];
    update(["notice_list"]);
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
    var result1 = <HomeNoticeListModel>[];
    var result2 = <HomeSystemMessageListModel>[];
    if (tabIndex == 0) {
      result1 = await HomeApi.noticesList(PageListReq(page: isRefresh ? 1 : _page, type: 'notice'));
    } else {
      result2 = await HomeApi.systemMessageList(PageListReq(
        page: isRefresh ? 1 : _page,
      ));
    }

    if (isRefresh) {
      _page = 1;
      if (tabIndex == 0) {
        noticeItems.clear();
      } else {
        messageItems.clear();
      }
    }
    if (tabIndex == 0) {
      if (result1.isNotEmpty) {
        _page++;
        noticeItems.addAll(result1);
        if (_page <= 2) {
          Storage().setJson('noticeItems', noticeItems);
        }
      } else {
        Storage().remove('noticeItems');
      }
    } else {
      if (result2.isNotEmpty) {
        _page++;
        messageItems.addAll(result2);
        if (_page <= 2) {
          Storage().setJson('messageItems', messageItems);
        }
      } else {
        Storage().remove('messageItems');
      }
    }

    // 是否是空
    return tabIndex == 0 ? noticeItems.isEmpty : messageItems.isEmpty;
  }

  // 上拉载入新商品
  void onLoading() async {
    if (tabIndex == 0 ? noticeItems.isNotEmpty : messageItems.isNotEmpty) {
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
    update(["notice_list"]);
  }

  // 下拉刷新
  void onRefresh() async {
    try {
      await _loadNewsSell(true);
      refreshController.refreshCompleted();
    } catch (e) {
      refreshController.refreshFailed();
    }
    update(["notice_list"]);
  }
}

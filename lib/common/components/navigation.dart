import 'package:ducafe_ui_core/ducafe_ui_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../index.dart';

/// 导航栏数据模型
/// 导航栏数据模型
class NavigationItemModel {
  final String label;
  final Image icon; // 普通状态图标
  final Image activeIcon; // 选中状态图标
  final int count;

  NavigationItemModel({
    required this.label,
    required this.icon,
    required this.activeIcon,
    this.count = 0,
  });
}

/// 导航栏
class BuildNavigation extends StatelessWidget {
  final int currentIndex;
  final List<NavigationItemModel> items;
  final Function(int) onTap;

  const BuildNavigation({
    super.key,
    required this.currentIndex,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ws = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      final item = items[i];
      final isSelected = i == currentIndex;

      ws.add(
        <Widget>[
          // 图标
          Stack(
            children: [
              SizedBox(
                width: 36.w,
                height: 36.w,
                child: isSelected ? item.activeIcon : item.icon,
              ),
              if (item.count > 0)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w),
                    height: 28.w,
                    constraints: BoxConstraints(
                      minWidth: 28.w,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(14.w),
                    ),
                    child: Center(
                      child: Text(
                        item.count.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ).paddingBottom(2),

          // 文字
          TextWidget.body(
            item.label.tr,
            color: isSelected ? const Color(0xff000000) : const Color(0xffADAFB3),
            size: 20.sp,
          ),
        ]
            .toColumn(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
            )
            .onTap(() => onTap(i))
            .expanded(),
      );
    }

    return BottomAppBar(
      color: AppTheme.navBgColor,
      elevation: 0,
      child: ws
          .toRow(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
          )
          .height(kBottomNavigationBarHeight),
    );
  }
}

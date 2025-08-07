import 'package:flutter/material.dart';

class SubscribeStepWidget extends StatelessWidget {
  final List<Map<String, dynamic>> steps;
  final int current;
  final Axis axis;
  final Color? themeColor;

  const SubscribeStepWidget({
    Key? key,
    required this.steps,
    required this.current,
    this.axis = Axis.vertical, // 默认竖向
    this.themeColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (axis == Axis.horizontal) {
      // 横向略
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _buildHorizontalSteps(),
      );
    }
    // 竖向
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _buildVerticalSteps(context),
    );
  }

  List<Widget> _buildVerticalSteps(BuildContext context) {
    final Color mainColor = themeColor ?? Colors.blue;
    List<Widget> widgets = [];
    for (int i = 0; i < steps.length; i++) {
      final step = steps[i];
      final isActive = i + 1 == current;
      final isFinished = i + 1 < current;

      widgets.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 步骤圆圈和竖线
              Column(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isActive
                          ? mainColor
                          : isFinished
                              ? mainColor.withOpacity(0.3)
                              : Colors.white,
                      border: Border.all(
                        color: isActive
                            ? mainColor
                            : isFinished
                                ? mainColor.withOpacity(0.3)
                                : Colors.grey,
                        width: 2,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: isFinished
                          ? Icon(Icons.check, size: 16, color: Colors.white)
                          : Text(
                              '${step['index']}',
                              style: TextStyle(
                                color: isActive
                                    ? Colors.white
                                    : isFinished
                                        ? Colors.white
                                        : Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  // 竖线自适应
                  if (i != steps.length - 1)
                    Expanded(
                      child: Container(
                        width: 2,
                        color: isFinished || isActive ? mainColor.withOpacity(0.3) : Colors.grey[300],
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              // 标题和内容
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step['title'] ?? '',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                          color: isActive ? mainColor : Colors.black87,
                        ),
                      ),
                      if (step['desc'] != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4, bottom: 8),
                          child: Text(
                            step['desc'],
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      if (step['time'] != null)
                        Text(
                          step['time'],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[400],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return widgets;
  }

  // 横向略（如需可补充）
  List<Widget> _buildHorizontalSteps() => [];
}

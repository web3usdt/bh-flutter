import 'dart:async';
import 'package:flutter/material.dart';

class _MultiClickFlashWrapper extends StatefulWidget {
  final Widget child;
  final int clickTimes;
  final Duration interval;
  final VoidCallback onTrigger;

  const _MultiClickFlashWrapper({
    required this.child,
    required this.clickTimes,
    required this.interval,
    required this.onTrigger,
  });

  @override
  State<_MultiClickFlashWrapper> createState() => _MultiClickFlashWrapperState();
}

class _MultiClickFlashWrapperState extends State<_MultiClickFlashWrapper> with SingleTickerProviderStateMixin {
  int _clickCount = 0;
  Timer? _timer;
  late AnimationController _flashController;

  @override
  void initState() {
    super.initState();
    _flashController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      lowerBound: 0.5,
      upperBound: 1.0,
    )..value = 1.0;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _flashController.dispose();
    super.dispose();
  }

  void _onTap() {
    _clickCount++;

    _flashController.forward(from: 0.5); // 开始闪烁动画

    _timer?.cancel();
    _timer = Timer(widget.interval, () {
      _clickCount = 0;
    });

    if (_clickCount >= widget.clickTimes) {
      _clickCount = 0;
      _timer?.cancel();
      widget.onTrigger();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      behavior: HitTestBehavior.translucent,
      child: FadeTransition(
        opacity: _flashController.drive(CurveTween(curve: Curves.easeOut)),
        child: widget.child,
      ),
    );
  }
}

extension MultiClickFlashExtension on Widget {
  Widget onContinuousClick({
    int clickTimes = 5,
    Duration interval = const Duration(seconds: 3),
    required VoidCallback onTrigger,
  }) {
    return _MultiClickFlashWrapper(
      clickTimes: clickTimes,
      interval: interval,
      onTrigger: onTrigger,
      child: this,
    );
  }
}

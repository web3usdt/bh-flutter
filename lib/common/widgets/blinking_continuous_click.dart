import 'dart:async';
import 'package:flutter/material.dart';

class BlinkingContinuousClick extends StatefulWidget {
  final Widget child;
  final VoidCallback onTrigger;
  final int tapCount;
  final Duration timeout;

  const BlinkingContinuousClick({
    Key? key,
    required this.child,
    required this.onTrigger,
    this.tapCount = 5,
    this.timeout = const Duration(seconds: 2),
  }) : super(key: key);

  @override
  _BlinkingContinuousClickState createState() => _BlinkingContinuousClickState();
}

class _BlinkingContinuousClickState extends State<BlinkingContinuousClick> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _taps = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _onTap() {
    _controller.forward();

    _taps++;
    if (_taps >= widget.tapCount) {
      _taps = 0;
      _timer?.cancel();
      widget.onTrigger();
    } else {
      _timer?.cancel();
      _timer = Timer(widget.timeout, () {
        _taps = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: FadeTransition(
        opacity: Tween<double>(begin: 1.0, end: 0.5).animate(_controller),
        child: widget.child,
      ),
    );
  }
}

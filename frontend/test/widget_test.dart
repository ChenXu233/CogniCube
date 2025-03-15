import 'dart:math' as math;

import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: Scaffold(body: AnimationTest())));

class AnimationTest extends StatefulWidget {
  @override
  _AnimationTestState createState() => _AnimationTestState();
}

class _AnimationTestState extends State<AnimationTest>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder:
          (context, child) => Transform.rotate(
            angle: _controller.value * 2 * math.pi,
            child: child,
          ),
      child: const FlutterLogo(size: 200),
    );
  }
}

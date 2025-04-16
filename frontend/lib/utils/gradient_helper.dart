import 'package:flutter/material.dart';

const Color primaryColor = Color.fromARGB(136, 244, 128, 146);
const Color primaryGradientColor = Color.fromARGB(168, 102, 178, 241);

RadialGradient createPrimaryGradient({
  required Offset center,
  required double radius,
  required List<Color> colors,
}) {
  return RadialGradient(
    center: Alignment(
      (center.dx * 2 - 1), // 将 Offset 转换为 Alignment 的范围 [-1, 1]
      (center.dy * 2 - 1),
    ),
    radius: radius,
    colors: colors,
    stops: const [0.2, 1.0],
  );
}

import 'dart:math';
import 'package:flutter/material.dart';

const Color primaryColor = Color.fromRGBO(255, 105, 120, 0.6);
const Color secondaryColor = Color.fromRGBO(252, 171, 64, 0.6);
const Color primaryGradientColor = Color.fromRGBO(114, 194, 255, 0.6);
const Color secondaryGradientColor = Color.fromRGBO(128, 247, 221, 0.6);

RadialGradient createPrimaryGradient(double animationValue) {
  final angle = animationValue * 2 * pi;
  final x = 0.5 + 0.3 * cos(angle);
  final y = 0.5 + 0.3 * sin(angle * 0.8);

  return RadialGradient(
    center: Alignment(x, y),
    radius: 1.2,
    colors: const [primaryColor, primaryGradientColor],
    stops: const [0.3, 1.0],
    transform: GradientRotation(angle),
  );
}

RadialGradient createSecondaryGradient(double animationValue) {
  final angle = animationValue * 2 * pi + pi;
  final x = 0.5 + 0.25 * cos(angle * 1.2);
  final y = 0.5 + 0.25 * sin(angle);

  return RadialGradient(
    center: Alignment(x, y),
    radius: 0.8,
    colors: const [secondaryColor, secondaryGradientColor],
    stops: const [0.4, 1.0],
    transform: GradientRotation(-angle),
  );
}

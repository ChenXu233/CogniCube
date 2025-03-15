import 'package:flutter/material.dart';

const Color primaryColor = Color.fromRGBO(255, 105, 120, 0.6);
const Color primaryGradientColor = Color.fromRGBO(114, 194, 255, 0.6);

RadialGradient createPrimaryGradient() {
  return RadialGradient(
    center: Alignment(0.5, 0.5), // 静态的中心点
    radius: 1.2,
    colors: const [primaryColor, primaryGradientColor],
    stops: const [0.3, 1.0],
  );
}

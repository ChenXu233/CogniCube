import 'package:flutter/material.dart';

const Color primaryColor = Color.fromARGB(136, 244, 128, 146);
const Color primaryGradientColor = Color.fromARGB(168, 102, 178, 241);

RadialGradient createPrimaryGradient() {
  return RadialGradient(
    center: Alignment(0.5, 0.5), // 静态的中心点
    radius: 1.2,
    colors: const [
      Color.fromARGB(136, 244, 128, 146),
      Color.fromARGB(168, 102, 178, 241),
    ],
    stops: const [0.2, 1.0],
  );
}

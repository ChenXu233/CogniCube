import 'package:flutter/material.dart';

const Color primaryColor = Color.fromRGBO(253, 92, 108, 0.6);
const Color primaryGradientColor = Color.fromRGBO(133, 200, 251, 0.6);

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

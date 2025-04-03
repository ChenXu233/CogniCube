import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  int _currentIndex = 0;
  late AnimationController _gradientController;
  final List<String> _weatherData = ['晴天', '多云', '雨天'];
  final List<String> _weatherImages = [
    // 'https://example.com/sunny.jpg',
    // 'https://example.com/cloudy.jpg',
    // 'https://example.com/rainy.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 1);
    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _gradientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // 设置背景为透明
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                top: kToolbarHeight + 16,
                bottom: kBottomNavigationBarHeight + 16,
              ),
              child: Text("wenzi"),
            ),
          ),
        Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () => context.push('/chat'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                '聊天',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../utils/gradient_helper.dart';
import 'dart:ui' as ui;

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
    'https://example.com/sunny.jpg',
    'https://example.com/cloudy.jpg',
    'https://example.com/rainy.jpg',
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          _pageController.jumpToPage(index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.sunny_snowing), label: '晴天'),
          BottomNavigationBarItem(icon: Icon(Icons.cloud), label: '多云'),
          BottomNavigationBarItem(icon: Icon(Icons.beach_access), label: '雨天'),
        ],
      ),
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _gradientController,
            builder: (context, _) {
              return Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: createPrimaryGradient(),
                    ),
                  ),
                ],
              );
            },
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(color: const Color.fromARGB(150, 255, 255, 255)),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                top: kToolbarHeight + 16,
                bottom: kBottomNavigationBarHeight + 16,
              ),
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentIndex = index),
                children:
                    _weatherData
                        .asMap()
                        .entries
                        .map(
                          (entry) => Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.network(
                                  _weatherImages[entry.key],
                                  width: 100,
                                  height: 100,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  entry.value,
                                  style: TextStyle(fontSize: 24),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

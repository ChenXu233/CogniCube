import 'dart:ui';

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
    final primaryColor = Theme.of(context).primaryColor; // 获取主题主色

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const SafeArea(
            child: Padding(
              padding: EdgeInsets.only(top: 40),
              child: Center(child: Text("wenzi")),
            ),
          ),

          // 修改后的卡片容器
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Align(
              alignment: Alignment.center,
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth: double.infinity,
                  maxHeight: 300,
                  minHeight: 280,
                ),
                child: _buildAIChatCard(primaryColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIChatCard(Color primaryColor) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
      child: ClipRRect(
        // 添加圆角裁剪
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: const Color.fromARGB(255, 176, 175, 175).withOpacity(0.35),
          child: Container(
            child: Stack(
              children: [
                // 内容容器
                Container(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // 图标部分保持不变...
                      Align(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.chat_bubble_rounded,
                            color: primaryColor,
                            size: 40,
                          ),
                        ),
                      ),

                      // 文字内容保持不变...
                      Column(
                        children: [
                          Text(
                            "情绪助手",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "点击开始对话",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color.fromARGB(255, 20, 20, 20),
                              fontSize: 15,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),

                      // 按钮部分保持不变...
                      InkWell(
                        onTap: () => context.push('/chat'),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "立即与我对话",
                                style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.arrow_forward_rounded,
                                color: primaryColor,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

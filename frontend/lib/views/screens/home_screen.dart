import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late PageController _pageController;
  int _currentIndex = 0;
  late AnimationController _gradientController;
  late Animation<double> _animation;

  final List<Color> _primaryColors = [
    const Color(0xFFBAE1FF).withOpacity(0.6),
    const Color(0xFFFFB3BA).withOpacity(0.6),
  ];

  final List<Color> _secondaryColors = [
    const Color(0xFFD9BAFF).withOpacity(0.6),
    const Color(0xFFBAFFC9).withOpacity(0.6),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 1).animate(_gradientController)
      ..addListener(() => setState(() {}));
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
      backgroundColor: Colors.grey[50],
      body: Stack(
        children: [
          // 双渐变背景层
          AnimatedBuilder(
            animation: _gradientController,
            builder: (context, _) {
              return Stack(
                children: [
                  // 主渐变球体
                  Container(
                    decoration: BoxDecoration(
                      gradient: _createPrimaryGradient(),
                    ),
                  ),
                  // 次级渐变球体
                  Container(
                    decoration: BoxDecoration(
                      gradient: _createSecondaryGradient(),
                    ),
                  ),
                ],
              );
            },
          ),

          // 页面内容
          PageView(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            children: const [
              Center(child: Text('聊天页面')),
              Center(child: Text('个人资料页面')),
              Center(child: Text('设置页面')),
              Center(child: Text('统计数据页面')),
            ],
          ),

          // 自定义静态模糊AppBar
          _buildStaticBlurAppBar(),

          // 自定义静态模糊导航栏
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildStaticBlurNavigationBar(),
          ),
        ],
      ),
    );
  }

  // 主渐变（蓝色系）
  RadialGradient _createPrimaryGradient() {
    final angle = _animation.value * 2 * pi;
    final x = 0.5 + 0.3 * cos(angle);
    final y = 0.5 + 0.3 * sin(angle * 0.8);

    return RadialGradient(
      center: Alignment(x, y),
      radius: 1.2,
      colors: _primaryColors,
      stops: const [0.3, 1.0],
      transform: GradientRotation(angle),
    );
  }

  // 次级渐变（紫色系）
  RadialGradient _createSecondaryGradient() {
    final angle = _animation.value * 2 * pi + pi;
    final x = 0.5 + 0.25 * cos(angle * 1.2);
    final y = 0.5 + 0.25 * sin(angle);

    return RadialGradient(
      center: Alignment(x, y),
      radius: 0.8,
      colors: _secondaryColors,
      stops: const [0.4, 1.0],
      transform: GradientRotation(-angle),
    );
  }

  // 静态模糊AppBar（保持原有实现）
  Widget _buildStaticBlurAppBar() {
    return ClipRect(
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          height: kToolbarHeight + MediaQuery.of(context).padding.top,
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0)),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.person, color: Colors.black),
                onPressed: () => _pageController.jumpToPage(1),
              ),
              const Expanded(child: Center()),
              IconButton(
                icon: const Icon(Icons.settings, color: Colors.black),
                onPressed: () => _pageController.jumpToPage(2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 静态模糊导航栏（保持原有实现）
  Widget _buildStaticBlurNavigationBar() {
    return ClipRect(
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          height:
              kBottomNavigationBarHeight +
              MediaQuery.of(context).padding.bottom,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom,
          ),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.3)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.chat, 0),
              _buildNavItem(Icons.insert_chart, 3),
            ],
          ),
        ),
      ),
    );
  }

  // 导航项组件（保持原有实现）
  Widget _buildNavItem(IconData icon, int index) {
    final isActive = _currentIndex == index;
    return GestureDetector(
      onTap:
          () => _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isActive ? Colors.white.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: isActive ? Colors.black : Colors.black87,
          size: 28,
        ),
      ),
    );
  }
}

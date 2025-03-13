import 'package:flutter/material.dart';
import '../components/app_bar.dart';
import '../components/navigation_bar.dart';
import '../../utils/gradient_helper.dart';

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
          AnimatedBuilder(
            animation: _gradientController,
            builder: (context, _) {
              return Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: createPrimaryGradient(_animation.value),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: createSecondaryGradient(_animation.value),
                    ),
                  ),
                ],
              );
            },
          ),
          PageView(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            children: const [
              Center(child: Text('聊天页面')),
              Center(child: Text('统计数据页面')),
              Center(child: Text('个人资料页面')),
              Center(child: Text('设置页面')),
            ],
          ),
          buildStaticBlurAppBar(context, _pageController),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: buildStaticBlurNavigationBar(context, _currentIndex, (
              index,
            ) {
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }),
          ),
        ],
      ),
    );
  }
}

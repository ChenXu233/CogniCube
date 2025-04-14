import 'package:flutter/material.dart';
import '../components/navigation_bar.dart';
import '../../utils/gradient_helper.dart';
import '../../view_models/home_view_model.dart';
import '../../views/screens/CBT/CBT_screen.dart';
import './statistics/statistics_screen.dart';
import '../../views/screens/user/profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui' as ui;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late PageController _pageController;
  int _currentIndex = 1;
  late AnimationController _gradientController;
  late final HomeViewModel vm;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: _currentIndex);
    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat(reverse: true);

    // 初始化 vm
    vm = context.read<HomeViewModel>();

    // 👇 延迟读取 extra 参数（pageIndex）
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final extra =
          GoRouter.of(context).routerDelegate.currentConfiguration.extra;

      if (extra != null &&
          extra is Map &&
          extra.containsKey('pageIndex') &&
          extra['pageIndex'] != null &&
          extra['pageIndex'] is int) {
        final index = extra['pageIndex'] as int;
        setState(() {
          _currentIndex = index;
          _pageController.jumpToPage(index);
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _gradientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(vm.prefs.getBool("is_admin"));
    return Scaffold(
      body: Stack(
        children: [
          // 渐变背景动画
          AnimatedBuilder(
            animation: _gradientController,
            builder: (context, _) {
              return Container(
                decoration: BoxDecoration(gradient: createPrimaryGradient()),
              );
            },
          ),

          // 毛玻璃模糊效果
          Positioned.fill(
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(color: const Color.fromARGB(150, 255, 255, 255)),
            ),
          ),

          // 主内容区域
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  // 🟢 用 Expanded 包裹 PageView，避免内容溢出
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() => _currentIndex = index);
                    },
                    children: const [
                      CBTScreen(key: PageStorageKey('cbt')),
                      WeatherScreen(key: PageStorageKey('weather')),
                      ProfileScreen(key: PageStorageKey('profile')),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // 🟣 悬浮的 Admin 按钮（只对管理员显示）
          if (vm.prefs.getBool("is_admin") == true)
            Positioned(
              bottom: kBottomNavigationBarHeight + 80,
              right: 20,
              child: ElevatedButton(
                onPressed: () {
                  context.go('/admin');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purpleAccent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Admin",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),

          // 底部导航栏
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: buildStaticBlurNavigationBar(context, _currentIndex, (
              index,
            ) {
              setState(() => _currentIndex = index);
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

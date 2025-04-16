import 'package:flutter/material.dart';
import '../components/navigation_bar.dart';
import '../../view_models/home_view_model.dart';
import '../../views/screens/CBT/CBT_screen.dart';
import './statistics/statistics_screen.dart';
import '../../views/screens/user/profile_screen.dart';
import '../components/ball_animation_widget.dart';
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
  late final HomeViewModel vm;

  // 初始按钮位置（右下角）
  double _buttonX = 20;
  double _buttonY = 20;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: _currentIndex);
    vm = context.read<HomeViewModel>();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BallAnimationWidget(), // 使用抽象的小球组件
          Positioned.fill(
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(color: const Color.fromARGB(150, 255, 255, 255)),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: kBottomNavigationBarHeight + 16,
              ),
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
          ),

          // 👇 可拖动的 Admin 按钮（仅管理员显示）
          if (vm.prefs.getBool("is_admin") == true)
            Positioned(
              left: _buttonX,
              top: _buttonY,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    // 确保按钮不会超出屏幕边界
                    _buttonX = (_buttonX + details.delta.dx).clamp(
                      0.0,
                      MediaQuery.of(context).size.width - 110, // 按钮宽度限制
                    );
                    _buttonY = (_buttonY + details.delta.dy).clamp(
                      0.0,
                      MediaQuery.of(context).size.height - 100, // 按钮高度限制
                    );
                  });
                },
                onPanEnd: (_) {
                  setState(() {
                    // 确保按钮在拖动结束后仍在屏幕内
                    _buttonX = _buttonX.clamp(
                      0.0,
                      MediaQuery.of(context).size.width - 110,
                    );
                    _buttonY = _buttonY.clamp(
                      0.0,
                      MediaQuery.of(context).size.height - 100,
                    );
                  });
                },
                child: ElevatedButton.icon(
                  onPressed: () {
                    context.go('/admin');
                  },
                  icon: const Icon(Icons.admin_panel_settings_rounded),
                  label: const Text(
                    "管理员",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(124, 186, 92, 241),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    elevation: 6,
                  ),
                ),
              ),
            ),

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

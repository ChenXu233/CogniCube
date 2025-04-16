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

  // 初始按钮位置（右下角）
  double _buttonX = 600;
  double _buttonY = 600;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: _currentIndex);
    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat(reverse: true);

    vm = context.read<HomeViewModel>();

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
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _gradientController,
            builder: (context, _) {
              return Container(
                decoration: BoxDecoration(gradient: createPrimaryGradient()),
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
                    _buttonX = (_buttonX + details.delta.dx).clamp(
                      0,
                      screenSize.width - 110,
                    ); // 限制按钮宽度
                    _buttonY = (_buttonY + details.delta.dy).clamp(
                      0,
                      screenSize.height - 100,
                    ); // 限制按钮高度
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

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
  Offset _adminButtonOffset = const Offset(300, 500); // 初始位置

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
    final isAdmin = vm.prefs.getBool("is_admin") == true;

    return Scaffold(
      body: Stack(
        children: [
          // 🌈 背景渐变 + 毛玻璃
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

          // 📄 页面主内容
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

          // ⬇️ 底部导航栏
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

          // 👑 Admin 按钮（仅管理员）
          if (isAdmin)
            Positioned(
              left: _adminButtonOffset.dx,
              top: _adminButtonOffset.dy,
              child: Draggable(
                feedback: _buildAdminButton(),
                childWhenDragging: const SizedBox.shrink(),
                onDragEnd: (details) {
                  setState(() {
                    _adminButtonOffset = details.offset;
                  });
                },
                child: _buildAdminButton(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAdminButton() {
    return GestureDetector(
      onTap: () {
        context.go('/admin');
      },
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Colors.purpleAccent, Colors.deepPurple],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(2, 3),
            ),
          ],
        ),
        child: const Icon(Icons.admin_panel_settings, color: Colors.white),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/navigation_bar.dart';
import '../../view_models/home_view_model.dart';
import '../../views/screens/CBT/CBT_screen.dart';
import './statistics/statistics_screen.dart';
import '../../views/screens/user/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // 确保在 HomeScreen 初始化时调用 HomeViewModel 中的 initController 方法
    final viewModel = Provider.of<HomeViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, viewModel, _) {
        return Scaffold(
          body: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFFFF0F5), Color(0xFFFFF8E1)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: kBottomNavigationBarHeight + 16,
                  ),
                  child: PageView(
                    controller:
                        viewModel
                            .pageController, // 使用 ViewModel 中的 PageController
                    onPageChanged: (index) => viewModel.navigateToPage(index),
                    children: const [
                      CBTScreen(key: PageStorageKey('cbt')),
                      WeatherScreen(key: PageStorageKey('weather')),
                      ProfileScreen(key: PageStorageKey('profile')),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: buildStaticBlurNavigationBar(
                  context,
                  viewModel.currentIndex,
                  (index) => viewModel.navigateToPage(index),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

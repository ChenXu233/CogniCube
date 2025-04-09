import 'package:flutter/material.dart';
import '../../../utils/gradient_helper.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui' as ui;

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with TickerProviderStateMixin {
  late AnimationController _gradientController;

  @override
  void initState() {
    super.initState();
    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _gradientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                top: kToolbarHeight,
                bottom: kBottomNavigationBarHeight + 16,
              ),
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text('编辑个人信息'),
                    onTap: () {
                      // 导航到编辑个人信息页面
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.notifications),
                    title: Text('通知设置'),
                    onTap: () {
                      // 导航到通知设置页面
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.lock),
                    title: Text('隐私设置'),
                    onTap: () {
                      // 导航到隐私设置页面
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.help),
                    title: Text('帮助与反馈'),
                    onTap: () {
                      // 导航到帮助与反馈页面
                    },
                  ),
                ],
              ),
            ),
          ),
          ClipRect(
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                height: kToolbarHeight + MediaQuery.of(context).padding.top,
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top,
                ),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0)),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => context.pop(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

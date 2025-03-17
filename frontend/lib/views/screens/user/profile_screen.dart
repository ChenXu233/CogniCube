import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../view_models/auth_view_model.dart';
import 'dart:ui' as ui;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Color> _ballColors = [
    Colors.lightBlueAccent.withOpacity(0.4),
    Colors.lightGreenAccent.withOpacity(0.4),
    Colors.cyanAccent.withOpacity(0.4),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildBlurBall(double size, Color color, Offset offset) {
    return Positioned(
      left: offset.dx,
      top: offset.dy,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: 1 + 0.2 * _controller.value,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [color, color.withOpacity(0.1)],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 26, 25, 25),
          ),
          onPressed: () => context.pop(),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // 背景渐变层
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color.fromARGB(255, 252, 202, 179),
                    Colors.lightGreen.shade100,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),

          // 动态模糊小球
          ..._ballColors.map(
            (color) => _buildBlurBall(
              200,
              color,
              Offset(
                screenSize.width * 0.3 * (_ballColors.indexOf(color) + 1),
                screenSize.height * 0.2 * (_ballColors.indexOf(color) + 1),
              ),
            ),
          ),

          // 高斯模糊层
          Positioned.fill(
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(color: Colors.transparent),
            ),
          ),

          // 内容层
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.4),
                        spreadRadius: 8,
                        blurRadius: 15,
                      ),
                    ],
                  ),
                  child: const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white70,
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'USER PROFILE',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 40),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 90),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                          255,
                          236,
                          171,
                          171,
                        ).withOpacity(0.8),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        if (authViewModel.isAuthenticated) {
                          authViewModel.logout();
                        }
                        context.go('/login');
                      },
                      child: Text(
                        authViewModel.isAuthenticated ? '退出登录' : '立即登录',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

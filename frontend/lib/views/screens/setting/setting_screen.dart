import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../utils/gradient_helper.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with TickerProviderStateMixin {
  late AnimationController _gradientController;
  String _birthday = '';
  String _gender = '';

  @override
  void initState() {
    super.initState();
    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat(reverse: true);
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _birthday = prefs.getString('birthday') ?? '未填写';
      _gender = prefs.getString('gender') ?? '未填写';
    });
  }

  @override
  void dispose() {
    _gradientController.dispose();
    super.dispose();
  }

  Widget buildUserInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: const Icon(Icons.cake),
          title: const Text('生日'),
          subtitle: Text(_birthday),
        ),
        ListTile(
          leading: const Icon(Icons.wc),
          title: const Text('性别'),
          subtitle: Text(_gender),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
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
                top: kToolbarHeight,
                bottom: kBottomNavigationBarHeight + 16,
              ),
              child: ListView(
                children: [
                  buildUserInfo(),
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('编辑个人信息'),
                    onTap: () => context.push('/edit-profile'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.notifications),
                    title: const Text('通知设置'),
                    onTap: () {
                      // TODO
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.lock),
                    title: const Text('隐私设置'),
                    onTap: () {
                      // TODO
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.help),
                    title: const Text('帮助与反馈'),
                    onTap: () {
                      // TODO
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

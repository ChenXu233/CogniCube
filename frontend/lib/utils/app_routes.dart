// utils/app_routes.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../views/screens/CBT/moodtracker_screen.dart'; // 保持大小写一致性
import '../../views/screens/CBT/target_screen.dart';
// 示例路径

final GoRouter appRoutes = GoRouter(
  initialLocation: '/',
  routes: [
    // 合并到原有路由结构中
    GoRoute(
      path: '/cbt',
      routes: [
        // 情绪追踪子路由
        GoRoute(
          path: 'mood',
          pageBuilder:
              (context, state) => MaterialPage(
                key: state.pageKey,
                child: const MoodTrackerScreen(),
              ),
        ),
        // 新增目标页面子路由
        GoRoute(
          path: 'target',
          pageBuilder:
              (context, state) =>
                  MaterialPage(key: state.pageKey, child: const TargetScreen()),
        ),
      ],
    ),
  ],
  errorBuilder:
      (context, state) =>
          Scaffold(body: Center(child: Text('路由错误: ${state.error}'))),
);

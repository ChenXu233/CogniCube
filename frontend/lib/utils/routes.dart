import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// View Models

// Screens
import '../views/screens/chat/chat_screen.dart';
import '../views/screens/auth/login_screen.dart';
import '../views/screens/auth/registration_screen.dart';
import '../views/screens/home_screen.dart';
import '../views/screens/CBT/CBT_screen.dart';
import '../views/screens/CBT/tests_assessment_screen.dart';
import '../views/screens/user/profile_screen.dart';

final goRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => const MaterialPage(child: LoginScreen()),
      routes: [
        GoRoute(
          path: '/home',
          pageBuilder:
              (context, state) => const MaterialPage(child: HomeScreen()),
        ),
      ],
    ),

    GoRoute(
      path: '/profile',
      pageBuilder:
          (context, state) => const MaterialPage(child: ProfileScreen()),
    ),

    GoRoute(
      path: '/home',
      pageBuilder: (context, state) => const MaterialPage(child: HomeScreen()),
    ),
    // 认证模块
    GoRoute(
      path: '/login',
      pageBuilder: (context, state) => const MaterialPage(child: LoginScreen()),
    ),
    GoRoute(
      path: '/register',
      pageBuilder:
          (context, state) => const MaterialPage(child: RegistrationScreen()),
    ),
    // 功能模块
    GoRoute(
      path: '/chat',
      pageBuilder: (context, state) => const MaterialPage(child: ChatScreen()),
    ),
    // CBT功能模块（嵌套路由）
    GoRoute(
      path: '/cbt',
      pageBuilder: (context, state) => MaterialPage(child: CBTScreen()),
      routes: [
        GoRoute(
          path: '/cbt/tests/:assessmentId',
          pageBuilder:
              (context, state) => MaterialPage(
                child: AssessmentScreen(
                  assessmentId: state.pathParameters['assessmentId']!,
                ),
              ),
        ),
      ],
    ),
  ],
);

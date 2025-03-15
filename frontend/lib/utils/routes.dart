import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// View Models

// Screens
import '../views/screens/chat/chat_screen.dart';
import '../views/screens/auth/login_screen.dart';
import '../views/screens/auth/registration_screen.dart';
import '../views/screens/home_screen.dart';

final goRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => const MaterialPage(child: LoginScreen()),
    ),
    GoRoute(
      path: '/home',
      pageBuilder: (context, state) => const MaterialPage(child: HomeScreen()),
    ),
    GoRoute(
      path: '/login',
      pageBuilder: (context, state) => const MaterialPage(child: LoginScreen()),
    ),
    GoRoute(
      path: '/register',
      pageBuilder:
          (context, state) => const MaterialPage(child: RegistrationScreen()),
    ),
    GoRoute(
      path: '/chat',
      pageBuilder: (context, state) => const MaterialPage(child: ChatScreen()),
    ),
  ],
  // redirect: (context, state) {
  //   final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
  //   final isLoggedIn = authViewModel.isAuthenticated;

  //   if (!isLoggedIn && state.fullPath != '/login') {
  //     return '/login'; // 未登录跳转登录页
  //   }
  //   return null; // 允许访问
  // },
);

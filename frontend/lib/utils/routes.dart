import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// View Models
import '../view_models/auth_view_model.dart';
import 'package:provider/provider.dart';

// Screens
import '../views/screens/chat/chat_screen.dart';
import '../views/screens/auth/login_screen.dart';
import '../views/screens/auth/registration_screen.dart';
import '../views/screens/home_screen.dart';
import '../views/screens/user/profile_screen.dart';

final goRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => const MaterialPage(child: LoginScreen()),
      routes: [
        GoRoute(
          path: '/home',
          pageBuilder: (context, state) => const MaterialPage(child: HomeScreen()),
        ),
      ],
    ),
    
    GoRoute(
      path: '/profile',
      pageBuilder: (context, state) => const MaterialPage(child: ProfileScreen()),
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
  redirect: (context, state) {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final isLoggedIn = authViewModel.isAuthenticated;
    final currentPath = state.fullPath;

    // 允许未登录访问的路径
    const allowedPaths = ['/login', '/register', '/profile'];

    if (!isLoggedIn && !allowedPaths.contains(currentPath)) {
      return '/login';
    }

    // 已登录用户禁止访问登录/注册页
    if (isLoggedIn && (currentPath == '/login' || currentPath == '/register')) {
      return '/home';
    }

    return null;
  },
);
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';

// // View Models
// import '../view_models/auth_view_model.dart';

// // Screens
// import '../views/screens/chat/chat_screen.dart';
// import '../views/screens/auth/login_screen.dart';
// import '../views/screens/auth/registration_screen.dart';
// import '../views/screens/home_screen.dart';
// import '../views/screens/user/profile_screen.dart';

// final goRouter = GoRouter(
//   initialLocation: '/',
//   routes: [
//     // Modified: 根路由重定向到登录状态检查
//     GoRoute(
//       path: '/',
//       redirect: (context, state) =>
//           Provider.of<AuthViewModel>(context, listen: false).isAuthenticated
//               ? '/home'   // 已认证用户跳转主页
//               : '/login', // 未认证用户跳转登录
//     ),

//     // Modified: 合并重复路由配置
//     GoRoute(
//       path: '/login',
//       pageBuilder: (context, state) => const MaterialPage(child: LoginScreen()),
//     ),
//     GoRoute(
//       path: '/register',
//       pageBuilder: (context, state) => const MaterialPage(child: RegistrationScreen()),
//     ),

//     // Modified: 使用嵌套路由重构主界面
//     GoRoute(
//       path: '/home',
//       pageBuilder: (context, state) => const MaterialPage(child: HomeScreen()),
//       routes: [
//         // Modified: 个人资料子路由
//         GoRoute(
//           path: 'profile',
//           pageBuilder: (context, state) => const MaterialPage(child: ProfileScreen()),
//         ),
//         // Modified: 聊天子路由
//         GoRoute(
//           path: 'chat',
//           pageBuilder: (context, state) => const MaterialPage(child: ChatScreen()),
//         ),
//       ],
//     ),
//   ],
  
//   // Modified: 增强路由守卫逻辑
//   redirect: (context, state) {
//     final authVM = Provider.of<AuthViewModel>(context, listen: false);
//     final isLoggedIn = authVM.isAuthenticated;
//     final currentPath = state.location ?? '';

//     // 已登录用户访问认证页面时重定向
//     if (isLoggedIn && _isAuthRoute(currentPath)) {
//       return '/home';
//     }

//     // 未登录用户访问受保护页面时重定向
//     if (!isLoggedIn && !_isAuthRoute(currentPath)) {
//       return '/login';
//     }

//     return null;
//   },
// );

// // New: 新增辅助方法判断认证相关路由
// bool _isAuthRoute(String path) {
//   return ['/login', '/register'].contains(path);
// }

// class AppRouter {
//   static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
//     switch (settings.name) {
//       case '/':
//         return MaterialPageRoute(
//           builder:
//               (_) => Consumer<AuthViewModel>(
//                 builder:
//                     (ctx, authVM, _) =>
//                         authVM.isAuthenticated
//                             ? const ChatScreen()
//                             : const LoginScreen(),
//               ),
//         );
//       case '/login':
//         return MaterialPageRoute(builder: (_) => const LoginScreen());
//       case '/register':
//         return MaterialPageRoute(builder: (_) => const RegistrationScreen());
//       case '/chat':
//         return MaterialPageRoute(
//           builder:
//               (_) => Consumer<AuthViewModel>(
//                 builder:
//                     (ctx, authVM, _) =>
//                         authVM.isAuthenticated
//                             ? const ChatScreen()
//                             : const LoginScreen(),
//               ),
//         );
//       default:
//         return null;
//     }
//   }
// }

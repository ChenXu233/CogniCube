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

    if (!isLoggedIn && state.fullPath != '/login') {
      return '/login'; // 未登录跳转登录页
    }
    return null; // 允许访问
  },
);

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

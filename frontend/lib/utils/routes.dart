import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// View Models
import '../view_models/auth_view_model.dart';

// Screens
import '../views/screens/chat/chat_screen.dart';
import '../views/screens/auth/login_screen.dart';
import '../views/screens/auth/registration_screen.dart'; // 新增注册页导入

class AppRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => Consumer<AuthViewModel>(
            builder: (ctx, authVM, _) => authVM.isAuthenticated 
                ? const ChatScreen() 
                : const LoginScreen()
          )
        );
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/register':
        return MaterialPageRoute(builder: (_) => const RegistrationScreen());
      case '/chat':
        return MaterialPageRoute(
          builder: (_) => Consumer<AuthViewModel>(
            builder: (ctx, authVM, _) => authVM.isAuthenticated 
                ? const ChatScreen()
                : const LoginScreen()
          )
        );
      default:
        return null;
    }
  }
}
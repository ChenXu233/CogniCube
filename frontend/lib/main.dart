import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// View Models
import 'view_models/auth_view_model.dart';
import 'view_models/chat_view_model.dart';

// Screens
import 'views/screens/chat/chat_screen.dart';
import 'views/screens/auth/login_screen.dart';
import 'views/screens/auth/registration_screen.dart'; // 新增注册页导入

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final prefs = await SharedPreferences.getInstance();
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => AuthViewModel(prefs: prefs)),
        ChangeNotifierProvider(create: (_) => ChatViewModel()),
      ],
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Chat',
      theme: _buildTheme(),
      initialRoute: '/',
      routes: {
        '/': (ctx) => Consumer<AuthViewModel>(
          builder: (ctx, authVM, _) => authVM.isAuthenticated 
              ? const ChatScreen() 
              : const LoginScreen()
        ),
        '/login': (ctx) => const LoginScreen(),
        '/register': (ctx) => const RegistrationScreen(),
        '/chat': (ctx) => const ChatScreen(),
      },
      onGenerateRoute: (settings) {
        // 路由守卫：未认证用户访问/chat时跳转登录
        if (settings.name == '/chat') {
          return MaterialPageRoute(
            builder: (_) => Consumer<AuthViewModel>(
              builder: (ctx, authVM, _) => authVM.isAuthenticated 
                  ? const ChatScreen()
                  : const LoginScreen()
            )
          );
        }
        return null;
      },
      debugShowCheckedModeBanner: false,
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        primary: Colors.blue,
        secondary: Colors.blueAccent,
      ),
      scaffoldBackgroundColor: Colors.grey[50],
      appBarTheme: const AppBarTheme(
        elevation: 1,
        centerTitle: true,
        color: Colors.white,
        foregroundColor: Colors.black,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
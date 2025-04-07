import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

// View Models
import 'view_models/auth_view_model.dart';
import 'view_models/chat_view_model.dart';
import 'view_models/home_view_model.dart'; // 新增 HomeViewModel 引入

// Routes
import 'utils/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化 SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  // 提前初始化 AuthViewModel（注意异步操作）
  final authViewModel = AuthViewModel(prefs: prefs);
  await authViewModel.initialize();

  // 系统 UI 配置
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
  );

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarContrastEnforced: false,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // 全局状态管理
  runApp(
    MultiProvider(
      providers: [
        // 使用已初始化的 AuthViewModel 实例
        ChangeNotifierProvider.value(value: authViewModel), // 关键改动
        // 其他 ViewModel
        ChangeNotifierProvider(create: (_) => HomeViewModel()), // 新增全局注册
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
    return MaterialApp.router(
      title: 'CogniCube',
      theme: _buildTheme(),
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return MediaQuery(
          // 保持一致的媒体查询
          data: MediaQuery.of(context),
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: child,
            ),
          ),
        );
      },
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        elevation: 8,
        selectedItemColor: Colors.blue[700],
        unselectedItemColor: Colors.grey[600],
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
    );
  }
}

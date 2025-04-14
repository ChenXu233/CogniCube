import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 添加以下导入
import 'dart:io';
import 'package:window_size/window_size.dart';

// View Models
import 'view_models/auth_view_model.dart';
import 'view_models/chat_view_model.dart';
import 'view_models/home_view_model.dart';

// Routes
import 'utils/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 设置窗口大小（仅限桌面平台）
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    setWindowTitle('CogniCube');
    setWindowFrame(const Rect.fromLTWH(100, 100, 1280, 720)); // 默认窗口大小和位置
  }

  // 初始化 SharedPreferences
  final prefs = await SharedPreferences.getInstance();

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
        ChangeNotifierProvider.value(value: authViewModel),
        ChangeNotifierProvider(create: (_) => HomeViewModel(prefs: prefs)),
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

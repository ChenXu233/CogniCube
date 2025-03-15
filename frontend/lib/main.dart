import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

// View Models
import 'view_models/auth_view_model.dart';
import 'view_models/chat_view_model.dart';

import 'utils/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  // 合并系统 UI 配置（原代码有重复设置）
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: [
      SystemUiOverlay.top, // 保留状态栏
      SystemUiOverlay.bottom, // 保留导航栏（透明模式需要）
    ],
  );

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark, // 状态栏图标颜色
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent, // 新增配置
      systemNavigationBarIconBrightness: Brightness.dark, // 导航栏图标颜色
    ),
  );

  // 添加屏幕方向锁定（可选）
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

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
    return MaterialApp.router(
      title: 'CogniCube',
      theme: _buildTheme(),
      routerConfig: goRouter,
      debugShowCheckedModeBanner: false,
      // 添加全局布局配置
      builder: (context, child) {
        return MediaQuery(
          // 保留系统默认的 padding（关键修改）
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
      // 保持原有主题配置
      // 添加 material 组件密度配置
      visualDensity: VisualDensity.adaptivePlatformDensity,
      // 修改底部导航栏主题
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

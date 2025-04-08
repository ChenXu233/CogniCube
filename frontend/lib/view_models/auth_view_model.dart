import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth.dart';

class AuthViewModel with ChangeNotifier {
  final SharedPreferences prefs;
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _errorMessage;

  AuthViewModel({required this.prefs}) {
    _checkAuthStatus();
  }

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> initialize() async {
    await _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    print(prefs.getString('auth_token'));
    _isAuthenticated = prefs.getString('auth_token') != null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> register(String username, String email, String password) async {
    try {
      _validateRegistrationFields(username, email, password);

      _isLoading = true;
      notifyListeners();

      final token = await AuthService.register(username, email, password);

      // 保存token到SharedPreferences
      await prefs.setString('auth_token', token);

      // 更新认证状态
      await _checkAuthStatus();

      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _isAuthenticated = false;
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _validateRegistrationFields(
    String username,
    String email,
    String password,
  ) {
    // TODO：增加正则表达式验证
    // final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    // final passwordRegex = RegExp(r'^(?=.*[A-Za-z])(?=.*\d).{8,}$');

    // if (username.trim().isEmpty) throw '用户名不能为空';
    // if (username.trim().length < 3) throw '用户名至少需要3个字符';
    // if (!emailRegex.hasMatch(email)) throw '请输入有效的邮箱地址';
    // if (!passwordRegex.hasMatch(password)) throw '密码需至少8位且包含字母和数字';
  }

  Future<void> login(String username, String password) async {
    // 参数改为username
    try {
      _validateLoginFields(username, password); // 修改验证方法

      _isLoading = true;
      notifyListeners();
      // 修改为获取返回的token
      final token = await AuthService.login(username, password);

      // 保存token到SharedPreferences
      await prefs.setString('auth_token', token);

      // 更新认证状态
      await _checkAuthStatus();

      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _isAuthenticated = false;
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _validateLoginFields(String username, String password) {
    // 改为username验证
    if (username.isEmpty || password.isEmpty) throw '请填写所有字段';
  }

  Future<void> logout() async {
    await prefs.remove('auth_token');
    await prefs.remove('userData');
    _isAuthenticated = false;
    notifyListeners();
  }
}

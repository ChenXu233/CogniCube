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

  // 通过 is_admin 判断是否是管理员
  bool get isAdmin => prefs.getBool("is_admin") ?? false;

  Future<void> initialize() async {
    await _checkAuthStatus();
  }

  // 检查认证状态
  Future<void> _checkAuthStatus() async {
    final token = prefs.getString('auth_token');
    _isAuthenticated = token != null;
    notifyListeners();
  }

  // 清除错误信息
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // 注册功能
  Future<void> register(String username, String email, String password) async {
    try {
      _validateRegistrationFields(username, email, password);

      _isLoading = true;
      notifyListeners();

      final token = await AuthService.register(username, password, email);

      // 注册完成后不自动登录
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

  // 注册字段验证
  void _validateRegistrationFields(
    String username,
    String email,
    String password,
  ) {
    if (username.trim().isEmpty) throw '用户名不能为空';
    if (username.trim().length < 3) throw '用户名至少需要3个字符';
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      throw '请输入有效的邮箱地址';
    }
    if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d).{8,}$').hasMatch(password)) {
      throw '密码需至少8位，包含字母和数字';
    }
  }

  // 登录功能
  Future<void> login(String username, String password) async {
    try {
      _validateLoginFields(username, password);

      _isLoading = true;
      notifyListeners();

      final token = await AuthService.login(username, password);

      // 保存成功后更新状态
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

  // 登录字段验证
  void _validateLoginFields(String username, String password) {
    if (username.isEmpty || password.isEmpty) throw '请填写所有字段';
  }

  // 登出功能
  Future<void> logout() async {
    await AuthService.logout();
    _isAuthenticated = false;
    notifyListeners();
  }
}

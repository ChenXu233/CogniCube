import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<void> _checkAuthStatus() async {
    _isAuthenticated = prefs.getString('auth_token') != null;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      _errorMessage = 'Please fill all fields';
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      await Future.delayed(const Duration(seconds: 1)); // 模拟API调用

      if (email == 'test@example.com' && password == 'password') {
        await prefs.setString('auth_token', 'fake_jwt_token');
        _isAuthenticated = true;
        _errorMessage = null;
      } else {
        _errorMessage = 'Invalid credentials';
      }
    } catch (e) {
      _errorMessage = 'Login failed: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await prefs.remove('auth_token');
    _isAuthenticated = false;
    notifyListeners();
  }
}
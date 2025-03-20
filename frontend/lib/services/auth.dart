import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/dio_util.dart';

class AuthService {
  static final Dio _dio = DioUtil().dio;
  static final SharedPreferences _prefs = DioUtil().prefs;

  static Future<String> login(String username, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'username': username, 'password': password},
      );

      await _prefs.setString("auth_token", response.data['access_token']);
      return response.data['response'] ?? "登录成功";
    } on DioException catch (e) {
      throw Exception('登录失败: ${e.response?.statusCode}');
    }
  }

  static Future<String> register(
    String username,
    String password,
    String email,
  ) async {
    try {
      final response = await _dio.post(
        '/auth/register',
        data: {'email': email, 'username': username, 'password': password},
      );

      return response.data['message'] ?? "注册成功";
    } on DioException catch (e) {
      throw Exception('注册失败: ${e.response?.statusCode}');
    }
  }
}

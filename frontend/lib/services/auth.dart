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
      final serverMessage = e.response?.data?['message'];
      final statusCode = e.response?.statusCode;
      String errorMessage = '登录失败';

      if (statusCode == 401) {
        errorMessage = serverMessage ?? '用户名或密码错误';
      } else if (statusCode == 400) {
        errorMessage = serverMessage ?? '请求参数错误';
      } else if (statusCode == 500) {
        errorMessage = '服务器内部错误，请稍后重试';
      }

      throw Exception(errorMessage);
    } catch (e) {
      throw Exception('登录失败: ${e.toString()}');
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

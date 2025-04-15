import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/dio_util.dart';

class AuthService {
  static final Dio _dio = DioUtil().dio;
  static final SharedPreferences _prefs = DioUtil().prefs;

  // 登录功能
  static Future<String> login(String username, String password) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'username': username, 'password': password},
      );

      final token = response.data['access_token'];
      final isAdmin = response.data['is_admin'];

      // 保存 Token 和 is_admin 标志
      await _prefs.setString("auth_token", token);
      await _prefs.setBool("is_admin", isAdmin);

      return token;
    } on DioException catch (e) {
      final serverMessage = e.response?.data?['message'];
      final statusCode = e.response?.statusCode;
      String errorMessage = '登录失败';

      if (statusCode == 401) {
        errorMessage = serverMessage ?? '用户名或密码错误';
      } else if (statusCode == 400) {
        errorMessage = serverMessage ?? '请求参数格式错误';
      } else if (statusCode == 429) {
        errorMessage = '尝试次数过多，请稍后再试';
      } else if (statusCode == 500) {
        errorMessage = '服务器内部错误，请联系管理员';
      }

      throw DioException(
        requestOptions: e.requestOptions,
        response: e.response,
        error: errorMessage,
        type: e.type,
      );
    } catch (e) {
      throw Exception('登录失败: ${e.toString()}');
    }
  }

  // 注册功能
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

  // 判断是否是管理员
  static Future<bool> isAdmin() async {
    return _prefs.getBool("is_admin") ?? false;
  }

  // 获取Token
  static Future<String?> getToken() async {
    return _prefs.getString("auth_token");
  }

  // 注销
  static Future<void> logout() async {
    await _prefs.remove("auth_token");
    await _prefs.remove("is_admin");
  }
}

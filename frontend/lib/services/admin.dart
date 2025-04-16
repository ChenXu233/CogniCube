import 'package:dio/dio.dart';
import '../utils/dio_util.dart';
import '../models/admin_model.dart';

class AdminService {
  static final Dio _dio = DioUtil().dio;

  /// 获取用户分页列表
  static Future<PaginatedUsers> getUsers(int page, int size) async {
    try {
      Response response = await _dio.get(
        '/admin/users',
        queryParameters: {'page': page, 'per_page': size},
      );
      return PaginatedUsers.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        throw _handleDioError(e);
      } else {
        rethrow;
      }
    }
  }

  /// 创建新用户
  static Future<String> createUser(UserCreate user) async {
    try {
      final response = await _dio.post('/admin/users', data: user.toJson());
      return "创建成功";
    } catch (e) {
      if (e is DioException) {
        throw _handleDioError(e);
      } else {
        rethrow;
      }
    }
  }

  /// 删除指定用户
  static Future<void> deleteUser(int userId) async {
    try {
      await _dio.delete('/admin/users/$userId');
    } catch (e) {
      if (e is DioException) {
        throw _handleDioError(e);
      } else {
        rethrow;
      }
    }
  }

  /// 统一处理 Dio 错误
  static Exception _handleDioError(DioException e) {
    final statusCode = e.response?.statusCode ?? '未知错误';
    final message = e.response?.data['detail'] ?? '请求失败';
    return Exception('网络请求失败 [$statusCode]: $message');
  }
}

// 🔁 用户信息转 JSON，字段与后端保持一致
extension UserInfoToJson on UserInfo {
  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "email": email,
      "password": "123456", // 示例密码，后续可以改为输入字段
      "is_admin": is_admin,
    };
  }
}

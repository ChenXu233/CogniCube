import 'package:dio/dio.dart';
import '../utils/dio_util.dart';
import '../models/admin_model.dart';

class AdminService {
  static final Dio _dio = DioUtil().dio;

  static Future<PaginatedUsers> getUsers(int page, int size) async {
    try {
      Response response = await _dio.get(
        '/admin/users',
        queryParameters: {'page': page, 'per_page': size},
      );
      return PaginatedUsers.fromJson(response.data);
    } catch (e) {
      if (e is DioException) {
        throw Exception('网络请求失败: ${e.response?.statusCode}');
      } else {
        rethrow;
      }
    }
  }

  static Future<String> createUser(UserCreate user) async {
    try {
      final response = await _dio.post('/admin/users', data: user.toJson());
      return "创建成功";
    } catch (e) {
      if (e is DioException) {
        throw Exception('网络请求失败: ${e.response?.statusCode}');
      } else {
        rethrow;
      }
    }
  }
}

import 'package:flutter/material.dart';
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
        throw _handleDioError(e);
      } else {
        rethrow;
      }
    }
  }

  static Future<String> creatUser(UserInfo user) async {
    try {
      Response response = await _dio.post('/admin/users', data: user.toJson());
      return "创建成功";
    } catch (e) {
      if (e is DioException) {
        throw _handleDioError(e);
      } else {
        rethrow;
      }
    }
  }

  static Exception _handleDioError(DioException e) {
    return Exception('网络请求失败: ${e.response?.statusCode}');
  }
}

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  late Future<PaginatedUsers> _userFuture;
  final int _page = 1;
  final int _perPage = 10;

  @override
  void initState() {
    super.initState();
    _userFuture = AdminService.getUsers(_page, _perPage);
  }

  void _createUser() async {
    // 示例用户数据，可改成弹窗表单
    final newUser = UserInfo(
      id: 0,
      username: '新用户',
      email: 'newuser@example.com',
      is_admin: true,
      recent_emotion_level: 0,
      is_verified: true,
    );

    try {
      final msg = await AdminService.creatUser(newUser);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));

      // 刷新列表
      setState(() {
        _userFuture = AdminService.getUsers(_page, _perPage);
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Widget _buildUserList(List<UserInfo> users) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return ListTile(
          title: Text(user.username),
          subtitle: Text('${user.email} • ${user.is_admin}'),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('用户管理'),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: _createUser),
        ],
      ),
      body: FutureBuilder<PaginatedUsers>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('出错了：${snapshot.error}'));
          } else if (snapshot.hasData) {
            final users = snapshot.data!.items;
            return _buildUserList(users);
          } else {
            return const Center(child: Text('没有用户数据'));
          }
        },
      ),
    );
  }
}

// 扩展函数：UserInfo.toJson()
extension UserInfoToJson on UserInfo {
  Map<String, dynamic> toJson() {
    return {"name": username, "email": email, "is_admin": is_admin};
  }
}

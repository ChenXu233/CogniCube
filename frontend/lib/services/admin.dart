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

  static Future<String> createUser(UserInfo user) async {
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
    _loadUsers();
  }

  void _loadUsers() {
    _userFuture = AdminService.getUsers(_page, _perPage);
  }

  Future<void> _createUserDialog() async {
    final usernameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    bool isAdmin = false;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("创建新用户"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: "用户名"),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: "邮箱"),
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: "密码"),
              ),
              Row(
                children: [
                  const Text("管理员权限"),
                  const Spacer(),
                  Switch(
                    value: isAdmin,
                    onChanged: (val) {
                      setState(() {
                        isAdmin = val;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("取消"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("创建"),
            ),
          ],
        );
      },
    );

    if (result == true) {
      final newUser = UserInfo(
        id: 0,
        username: usernameController.text,
        email: emailController.text,
        is_admin: isAdmin,
        is_verified: true,
      );

      try {
        final msg = await AdminService.createUser(newUser);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(msg)));
        setState(() => _loadUsers());
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  Widget _buildUserList(List<UserInfo> users) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() => _loadUsers());
      },
      child: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            leading: CircleAvatar(child: Text(user.username[0])),
            title: Text(user.username),
            subtitle: Text('${user.email} • ${user.is_admin ? "管理员" : "普通用户"}'),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('用户管理'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _createUserDialog,
            tooltip: "创建用户",
          ),
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

// 🔁 修正字段映射，和后端一致
extension UserInfoToJson on UserInfo {
  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "email": email,
      "password": "123456", // 示例密码或后续改为输入字段
      "is_admin": is_admin,
    };
  }
}

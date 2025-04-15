import 'package:flutter/material.dart';
import '../../../services/admin.dart'; // 引入 AdminService
import '../../../models/admin_model.dart'; // 如果模型单独放在 models 文件夹

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
    final _usernameController = TextEditingController();
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();
    bool _isAdmin = false;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("创建新用户"),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(labelText: "用户名"),
                    ),
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: "邮箱"),
                    ),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: "密码"),
                    ),
                    Row(
                      children: [
                        const Text("管理员权限"),
                        const Spacer(),
                        Switch(
                          value: _isAdmin,
                          onChanged: (val) {
                            setState(() {
                              _isAdmin = val;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
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
      },
    );

    if (result == true) {
      final newUser = UserCreate(
        username: _usernameController.text,
        email: _emailController.text,
        password: _passwordController.text,
        is_admin: _isAdmin,
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

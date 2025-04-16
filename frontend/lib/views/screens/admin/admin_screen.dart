import 'package:flutter/material.dart';
import '/services/admin.dart';
import '/models/admin_model.dart';
import 'package:go_router/go_router.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  int _currentPage = 1;
  final int _pageSize = 10;
  late Future<PaginatedUsers> _userFuture;
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController(); // 新增密码输入框
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  void _loadUsers() {
    setState(() {
      _userFuture = AdminService.getUsers(_currentPage, _pageSize);
    });
  }

  void _createUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        await AdminService.createUser(
          UserCreate(
            username: _usernameController.text,
            email: _emailController.text,
            password: _passwordController.text, // 使用用户输入的密码
            is_admin: _isAdmin,
          ),
        );
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("用户创建成功")));
        _usernameController.clear();
        _emailController.clear();
        _passwordController.clear(); // 清空密码输入框
        _isAdmin = false;
        _loadUsers(); // 刷新用户列表
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  void _deleteUser(int userId) async {
    try {
      await AdminService.deleteUser(userId); // 调用删除接口
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("用户已删除")));
      _loadUsers(); // 删除后重新加载用户列表
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("管理员界面"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: FutureBuilder<PaginatedUsers>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("加载失败: ${snapshot.error}"));
          }

          final users = snapshot.data!.items;
          final total = snapshot.data!.total;
          final pageCount = (total / _pageSize).ceil();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text(
                  "👥 用户管理",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ListView.builder(
                  itemCount: users.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return ListTile(
                      title: Text(user.username),
                      subtitle: Text(user.email),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteUser(user.id), // 删除用户
                      ),
                    );
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed:
                          _currentPage > 1
                              ? () {
                                setState(() {
                                  _currentPage--;
                                  _loadUsers();
                                });
                              }
                              : null,
                      child: const Text("上一页"),
                    ),
                    Text("第 $_currentPage 页，共 $pageCount 页"),
                    ElevatedButton(
                      onPressed:
                          _currentPage < pageCount
                              ? () {
                                setState(() {
                                  _currentPage++;
                                  _loadUsers();
                                });
                              }
                              : null,
                      child: const Text("下一页"),
                    ),
                  ],
                ),
                const Divider(height: 32),
                const Text(
                  "➕ 添加新用户",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _usernameController,
                        decoration: const InputDecoration(labelText: "用户名"),
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? "请输入用户名"
                                    : null,
                      ),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: "邮箱"),
                        validator:
                            (value) =>
                                value == null || value.isEmpty ? "请输入邮箱" : null,
                      ),
                      TextFormField(
                        controller: _passwordController, // 密码输入框
                        decoration: const InputDecoration(labelText: "密码"),
                        obscureText: true, // 密码字符隐藏
                        validator:
                            (value) =>
                                value == null || value.isEmpty ? "请输入密码" : null,
                      ),
                      SwitchListTile(
                        title: const Text("是否管理员"),
                        value: _isAdmin,
                        onChanged: (value) => setState(() => _isAdmin = value),
                      ),
                      ElevatedButton.icon(
                        onPressed: _createUser,
                        icon: const Icon(Icons.person_add),
                        label: const Text("创建用户"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

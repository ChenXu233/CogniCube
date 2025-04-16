import 'package:flutter/material.dart';
import '/services/admin.dart';
import '/models/admin_model.dart';
import 'package:go_router/go_router.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _currentPage = 1;
  final int _pageSize = 10;
  late Future<PaginatedUsers> _userFuture;
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
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
            password: _passwordController.text,
            is_admin: _isAdmin,
          ),
        );
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("用户创建成功")));
        _usernameController.clear();
        _emailController.clear();
        _passwordController.clear();
        _isAdmin = false;
        _loadUsers();
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  void _deleteUser(int userId) async {
    try {
      await AdminService.deleteUser(userId);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("用户已删除")));
      _loadUsers();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F1FF), // 柔和淡紫背景
      appBar: AppBar(
        title: const Text("管理员界面"),
        backgroundColor: Colors.deepPurple.shade300,
        foregroundColor: Colors.white,
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
            padding: const EdgeInsets.all(20),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "💼 用户管理",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                        color: Colors.deepPurple,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF6EEFF),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.deepPurple.shade100),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          ListView.builder(
                            itemCount: users.length,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              final user = users[index];
                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.purple.shade50,
                                      blurRadius: 4,
                                      offset: const Offset(1, 2),
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  title: Text(user.username),
                                  subtitle: Text(user.email),
                                  trailing: IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () => _deleteUser(user.id),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 12),
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
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurple.shade200,
                                ),
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
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurple.shade200,
                                ),
                                child: const Text("下一页"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),
                    const Text(
                      "📝 添加新用户",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                        color: Colors.deepPurple,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.deepPurple.shade100),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            _buildTextField(_usernameController, "用户名"),
                            const SizedBox(height: 16),
                            _buildTextField(_emailController, "邮箱"),
                            const SizedBox(height: 16),
                            _buildTextField(
                              _passwordController,
                              "密码",
                              isPassword: true,
                            ),
                            const SizedBox(height: 16),
                            SwitchListTile(
                              title: const Text("是否为管理员"),
                              value: _isAdmin,
                              activeColor: Colors.deepPurple,
                              onChanged:
                                  (value) => setState(() => _isAdmin = value),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                              onPressed: _createUser,
                              icon: const Icon(Icons.add_circle_outline),
                              label: const Text("创建用户"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 36,
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                textStyle: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    bool isPassword = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
        ),
      ),
      validator: (value) => value == null || value.isEmpty ? "请输入$label" : null,
    );
  }
}

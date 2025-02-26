import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../view_models/auth_view_model.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final usernameController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(title: const Text('注册')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: '用户名'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入用户名';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: '邮箱'),
                validator: (value) {
                  if (value == null || !value.contains('@')) {
                    return '请输入有效邮箱';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: '密码'),
                validator: (value) {
                  if (value == null || value.length < 8) {
                    return '密码至少8位';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Consumer<AuthViewModel>(
                builder: (ctx, authVM, _) {
                  if (authVM.isLoading) {
                    return const CircularProgressIndicator();
                  }
                  return ElevatedButton(
                    onPressed: () => _register(context, usernameController.text, emailController.text, passwordController.text, _formKey),
                    child: const Text('注册'),
                  );
                }
              ),
              TextButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                child: const Text('已有账号？去登录'),
              ),
              Consumer<AuthViewModel>(
                builder: (ctx, authVM, _) {
                  if (authVM.errorMessage != null) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        authVM.errorMessage!,
                        style: TextStyle(color: Colors.red[600]),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }
              )
            ],
          ),
        ),
      ),
    );
  }

  void _register(BuildContext context, String username, String email, String password, GlobalKey<FormState> formKey) async {
    if (!formKey.currentState!.validate()) return;

    final authVM = Provider.of<AuthViewModel>(context, listen: false);
    try {
      await authVM.register(username, email, password);
      if (authVM.isAuthenticated) {
        Navigator.pushNamedAndRemoveUntil(context, '/chat', (route) => false);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('注册失败: ${e.toString()}')),
        );
      }
    }
  }
}
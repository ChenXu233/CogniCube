import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../view_models/auth_view_model.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('注册')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildUsernameField(),
              const SizedBox(height: 20),
              _buildEmailField(),
              const SizedBox(height: 20),
              _buildPasswordField(),
              const SizedBox(height: 20),
              _buildConfirmPasswordField(),
              const SizedBox(height: 30),
              _buildSubmitButton(),
              const SizedBox(height: 15),
              _buildLoginLink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUsernameField() {
    return TextFormField(
      controller: _usernameController,
      decoration: const InputDecoration(
        labelText: '用户名',
        prefixIcon: Icon(Icons.person_outline),
        border: OutlineInputBorder(),
      ),
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value == null || value.trim().isEmpty) return '请输入用户名';
        if (value.trim().length < 3) return '至少3个字符';
        return null;
      },
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      decoration: const InputDecoration(
        labelText: '邮箱',
        prefixIcon: Icon(Icons.email_outlined),
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value == null || value.isEmpty) return '请输入邮箱';
        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
          return '邮箱格式不正确';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: true,
      decoration: const InputDecoration(
        labelText: '密码',
        prefixIcon: Icon(Icons.lock_outlined),
        border: OutlineInputBorder(),
      ),
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value == null || value.isEmpty) return '请输入密码';
        if (value.length < 8) return '至少8位';
        if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d).+$').hasMatch(value)) {
          return '需包含字母和数字';
        }
        return null;
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      controller: _confirmPasswordController,
      obscureText: true,
      decoration: const InputDecoration(
        labelText: '确认密码',
        prefixIcon: Icon(Icons.lock_reset),
        border: OutlineInputBorder(),
      ),
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => _submitForm(),
      validator: (value) {
        if (value != _passwordController.text) return '密码不一致';
        return null;
      },
    );
  }

  Widget _buildSubmitButton() {
    return Consumer<AuthViewModel>(
      builder: (context, authVM, _) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: authVM.isLoading ? null : _submitForm,
          child:
              authVM.isLoading
                  ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                  : const Text('注册账号'),
        );
      },
    );
  }

  Widget _buildLoginLink() {
    return TextButton(
      onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
      child: RichText(
        text: TextSpan(
          style: Theme.of(context).textTheme.bodyMedium,
          children: const [
            TextSpan(text: '已有账号？'),
            TextSpan(
              text: '立即登录',
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final authVM = context.read<AuthViewModel>();
    authVM.clearError();

    try {
      await authVM.register(
        _usernameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (authVM.isAuthenticated && mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    }
  }
}

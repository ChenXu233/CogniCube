import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../view_models/auth_view_model.dart';
import '../../../utils/gradient_helper.dart';
import 'dart:ui' as ui;

class LoginScreen extends StatefulWidget {
  final String? redirectMessage; // 新增重定向消息参数
  final String? fromLocation; // 新增来源路径参数

  const LoginScreen({super.key, this.redirectMessage, this.fromLocation});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  late AnimationController _gradientController;

  @override
  void initState() {
    super.initState();
    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat(reverse: true);

    // 显示重定向提示消息
    if (widget.redirectMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.redirectMessage!),
            backgroundColor: Colors.orange[700],
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    _gradientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _gradientController,
            builder: (context, _) {
              return Container(
                decoration: BoxDecoration(gradient: createPrimaryGradient()),
              );
            },
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(color: const Color.fromARGB(150, 255, 255, 255)),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(
                    top: 100,
                    left: 20,
                    right: 20,
                    bottom: 40,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          '欢迎回来',
                          style: Theme.of(
                            context,
                          ).textTheme.headlineMedium?.copyWith(
                            color: const Color.fromARGB(255, 238, 175, 175),
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 50),
                        _buildUsernameField(),
                        const SizedBox(height: 25),
                        _buildPasswordField(),
                        const SizedBox(height: 35),
                        _buildSubmitButton(),
                        const SizedBox(height: 25),
                        _buildRegisterLink(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUsernameField() {
    return TextFormField(
      controller: _usernameController,
      style: const TextStyle(
        color: Color.fromARGB(255, 21, 21, 21),
        fontSize: 16,
      ),
      decoration: InputDecoration(
        labelText: '用户名',
        labelStyle: const TextStyle(
          color: Color.fromARGB(179, 43, 43, 43),
          fontSize: 15,
        ),
        prefixIcon: const Icon(
          Icons.person_outlined,
          color: Color.fromARGB(179, 43, 43, 43),
          size: 22,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.35), // 透明度调整为35%
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 22,
        ),
      ),
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value == null || value.isEmpty) return '请输入用户名';
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      style: const TextStyle(
        color: Color.fromARGB(255, 21, 21, 21),
        fontSize: 16,
      ),
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: '密码',
        labelStyle: const TextStyle(
          color: Color.fromARGB(179, 43, 43, 43),
          fontSize: 15,
        ),
        prefixIcon: const Icon(
          Icons.lock_outlined,
          color: Color.fromARGB(179, 43, 43, 43),
          size: 22,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: const Color.fromARGB(179, 94, 47, 47),
            size: 22,
          ),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.35), // 透明度调整为35%
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 22,
        ),
      ),
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => _submitForm(),
      validator: (value) {
        if (value == null || value.isEmpty) return '请输入密码';
        if (value.length < 8) return '密码至少需要8位';
        return null;
      },
    );
  }

  Widget _buildRegisterLink() {
    return TextButton(
      onPressed: () => context.go('/register'),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 16),
          children: [
            const TextSpan(
              text: '没有账号？',
              style: TextStyle(color: Color.fromARGB(179, 59, 59, 59)),
            ),
            TextSpan(
              text: '注册新账号',
              style: TextStyle(
                color: const Color.fromARGB(255, 71, 164, 252).withOpacity(0.5),
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.underline,
                fontSize: 16.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Consumer<AuthViewModel>(
      builder: (context, authVM, _) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            backgroundColor: const Color.fromARGB(
              255,
              238,
              175,
              175,
            ).withOpacity(0.8),
            elevation: 4,
            shadowColor: Colors.black.withOpacity(0.3),
          ),
          onPressed: authVM.isLoading ? null : _submitForm,
          child:
              authVM.isLoading
                  ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Color.fromARGB(255, 53, 53, 53),
                    ),
                  )
                  : const Text(
                    '立即登录',
                    style: TextStyle(
                      color: Color.fromARGB(255, 53, 53, 53),
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
        );
      },
    );
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final authVM = context.read<AuthViewModel>();
    authVM.clearError();

    try {
      await authVM.login(
        _usernameController.text.trim(),
        _passwordController.text,
      );

      if (authVM.isAuthenticated && mounted) {
        // 修改跳转逻辑：优先跳转来源页面
        final targetLocation = widget.fromLocation ?? '/';
        if (mounted) context.go(targetLocation);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.red[700],
          ),
        );
      }
    }
  }
}

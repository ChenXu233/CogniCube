// 修改后的登录页面完整代码
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../view_models/auth_view_model.dart';
import 'dart:ui' as ui;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  late AnimationController _controller;
  final List<Color> _ballColors = [
    Colors.blueAccent.withOpacity(0.5),  // 加深小球颜色
    Colors.purpleAccent.withOpacity(0.5),
    Colors.cyanAccent.withOpacity(0.5),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildBlurBall(double size, Color color, Offset offset) {
    return Positioned(
      left: offset.dx,
      top: offset.dy,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: 1 + 0.2 * _controller.value,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [color, color.withOpacity(0.3)],  // 增加渐变对比
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // 更深的渐变背景
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF2A2A72),  // 深蓝色
                    Color(0xFF009FFD),  // 亮蓝色
                  ],
                ),
              ),
            ),
          ),

          // 动态模糊小球
          ..._ballColors.map(
            (color) => _buildBlurBall(
              220,  // 增大小球尺寸
              color,
              Offset(
                screenSize.width * 0.2 * (_ballColors.indexOf(color) + 1),
                screenSize.height * 0.25 * (_ballColors.indexOf(color) + 1),
              ),
            ),
          ),

          // 高斯模糊层
          Positioned.fill(
            child: BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 40, sigmaY: 40),  // 增强模糊
              child: Container(color: Colors.black.withOpacity(0.2)),
            ),
          ),

          // 内容层（使用Column代替Padding实现满屏布局）
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 100, left: 20, right: 20, bottom: 40),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('欢迎回来',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,  // 加粗字体
                                shadows: [Shadow(color: Colors.black.withOpacity(0.2), blurRadius: 6)])),
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
      style: const TextStyle(color: Colors.white, fontSize: 16),
      decoration: InputDecoration(
        labelText: '用户名',
        labelStyle: const TextStyle(color: Colors.white70, fontSize: 15),
        prefixIcon: const Icon(Icons.person_outlined, color: Colors.white70, size: 22),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.25),  // 更实心的填充色
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 22),
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
      style: const TextStyle(color: Colors.white, fontSize: 16),
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: '密码',
        labelStyle: const TextStyle(color: Colors.white70, fontSize: 15),
        prefixIcon: const Icon(Icons.lock_outlined, color: Colors.white70, size: 22),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: Colors.white70,
            size: 22,
          ),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.25),
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 22),
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

  Widget _buildSubmitButton() {
    return Consumer<AuthViewModel>(
      builder: (context, authVM, _) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            backgroundColor: Colors.white.withOpacity(0.3),
            elevation: 4,  // 增加阴影
            shadowColor: Colors.black.withOpacity(0.3),
          ),
          onPressed: authVM.isLoading ? null : _submitForm,
          child: authVM.isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Colors.white,
                  ),
                )
              : const Text('立即登录', 
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w600
                  )),
        );
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
              style: TextStyle(color: Colors.white70),
            ),
            TextSpan(
              text: '注册新账号',
              style: TextStyle(
                color: Colors.cyanAccent.shade200,  // 更亮的链接色
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
        context.push('/home');
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
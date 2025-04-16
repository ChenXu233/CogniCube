import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../view_models/auth_view_model.dart';
import '../../components/ball_animation_widget.dart';
import 'dart:ui' as ui;

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  late AnimationController _gradientController;

  @override
  void initState() {
    super.initState();
    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat(reverse: true);
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
          const BallAnimationWidget(),
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
                          '创建账号',
                          style: Theme.of(
                            context,
                          ).textTheme.headlineMedium?.copyWith(
                            color: const Color.fromARGB(255, 255, 140, 140),
                            fontWeight: FontWeight.w800,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 50),
                        _buildUsernameField(),
                        const SizedBox(height: 20),
                        _buildEmailField(),
                        const SizedBox(height: 20),
                        _buildPasswordField(),
                        const SizedBox(height: 20),
                        _buildConfirmPasswordField(context),
                        const SizedBox(height: 35),
                        _buildSubmitButton(context),
                        const SizedBox(height: 25),
                        _buildLoginLink(context),
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
          Icons.person_outline,
          color: Color.fromARGB(179, 43, 43, 43),
          size: 22,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.35),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 22,
        ),
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
      style: const TextStyle(
        color: Color.fromARGB(255, 21, 21, 21),
        fontSize: 16,
      ),
      decoration: InputDecoration(
        labelText: '邮箱',
        labelStyle: const TextStyle(
          color: Color.fromARGB(179, 43, 43, 43),
          fontSize: 15,
        ),
        prefixIcon: const Icon(
          Icons.email_outlined,
          color: Color.fromARGB(179, 43, 43, 43),
          size: 22,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.35),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 22,
        ),
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
        fillColor: Colors.white.withOpacity(0.35),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 22,
        ),
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

  Widget _buildConfirmPasswordField(BuildContext context) {
    return TextFormField(
      controller: _confirmPasswordController,
      style: const TextStyle(
        color: Color.fromARGB(255, 21, 21, 21),
        fontSize: 16,
      ),
      obscureText: _obscureConfirmPassword,
      decoration: InputDecoration(
        labelText: '确认密码',
        labelStyle: const TextStyle(
          color: Color.fromARGB(179, 43, 43, 43),
          fontSize: 15,
        ),
        prefixIcon: const Icon(
          Icons.lock_reset,
          color: Color.fromARGB(179, 43, 43, 43),
          size: 22,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
            color: const Color.fromARGB(179, 94, 47, 47),
            size: 22,
          ),
          onPressed:
              () => setState(
                () => _obscureConfirmPassword = !_obscureConfirmPassword,
              ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.35),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
          horizontal: 22,
        ),
      ),
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => _submitForm(context),
      validator: (value) {
        if (value != _passwordController.text) return '密码不一致';
        return null;
      },
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
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
              255,
              102,
              102,
            ).withOpacity(0.8),
            elevation: 4,
            shadowColor: Colors.black.withOpacity(0.3),
          ),
          onPressed: authVM.isLoading ? null : () => _submitForm(context),
          child:
              authVM.isLoading
                  ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Color.fromARGB(255, 186, 155, 153),
                    ),
                  )
                  : const Text(
                    '注册账号',
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

  Widget _buildLoginLink(BuildContext context) {
    return TextButton(
      onPressed: () => context.go('/login'),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 16),
          children: [
            const TextSpan(
              text: '已有账号？',
              style: TextStyle(color: Color.fromARGB(179, 59, 59, 59)),
            ),
            TextSpan(
              text: '立即登录',
              style: TextStyle(
                color: const Color.fromARGB(255, 255, 181, 97),
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

  void _submitForm(BuildContext context) async {
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
        context.go('/login');
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

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedGender;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0.5, -0.5),
            radius: 1.2,
            colors: [
              Color.fromARGB(80, 255, 209, 216),
              Color.fromARGB(80, 200, 230, 255),
            ],
            stops: [0.2, 1.0],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black87),
                  onPressed: () => context.pop(),
                ),
                const SizedBox(height: 16),
                Text(
                  '编辑个人信息',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 32),

                // 昵称
                _buildLabeledInput(
                  label: '昵称',
                  child: TextField(
                    controller: _nameController,
                    decoration: _inputDecoration('请输入昵称'),
                  ),
                ),
                const SizedBox(height: 20),

                // 性别
                _buildLabeledInput(
                  label: '性别',
                  child: DropdownButtonFormField<String>(
                    value: _selectedGender,
                    decoration: _inputDecoration('请选择性别'),
                    items: const [
                      DropdownMenuItem(value: '男', child: Text('男')),
                      DropdownMenuItem(value: '女', child: Text('女')),
                      DropdownMenuItem(value: '其他', child: Text('其他')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // 生日
                _buildLabeledInput(
                  label: '生日',
                  child: GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: TextFormField(
                        decoration: _inputDecoration('请选择生日'),
                        controller: TextEditingController(
                          text:
                              _selectedDate == null
                                  ? ''
                                  : DateFormat(
                                    'yyyy-MM-dd',
                                  ).format(_selectedDate!),
                        ),
                      ),
                    ),
                  ),
                ),
                const Spacer(),

                // 保存按钮
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(192, 250, 182, 197),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 30),
                    ),
                    onPressed: () async {
                      final name = _nameController.text.trim();
                      final gender = _selectedGender;
                      final birth = _selectedDate?.toIso8601String();

                      // ✅ 保存到 SharedPreferences
                      final prefs = await SharedPreferences.getInstance();
                      if (gender != null) {
                        await prefs.setString('gender', gender);
                      }
                      if (birth != null) {
                        await prefs.setString('birthday', birth);
                      }

                      print('保存: $name / $gender / $birth');
                      context.pop();
                    },
                    child: const Text('保存'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.black54),
      filled: true,
      fillColor: Colors.white.withOpacity(0.85),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.transparent),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.transparent),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: Color.fromARGB(160, 249, 141, 157),
          width: 2,
        ),
      ),
    );
  }

  Widget _buildLabeledInput({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
}

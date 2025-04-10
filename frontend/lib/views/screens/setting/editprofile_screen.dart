import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfileData(); // 初始化时加载数据
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    _birthdayController.text = prefs.getString('birthday') ?? '';
    _genderController.text = prefs.getString('gender') ?? '';
  }

  Future<void> _saveProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('birthday', _birthdayController.text);
    await prefs.setString('gender', _genderController.text);
    // Navigator.pop(context); // 返回设置页
    context.push('/setting');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('编辑个人信息')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _birthdayController,
              decoration: const InputDecoration(labelText: '生日（例如：2001-08-09）'),
            ),
            TextField(
              controller: _genderController,
              decoration: const InputDecoration(labelText: '性别（例如：女）'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveProfileData,
              child: const Text('保存'),
            ),
          ],
        ),
      ),
    );
  }
}

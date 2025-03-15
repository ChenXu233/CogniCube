import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../view_models/auth_view_model.dart'; // 新增引入认证视图模型

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationEnabled = true;
  bool _dataSyncEnabled = false;
  final String _aiName = "AI助手小智";

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context); // 新增：获取认证状态

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 140,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade400, Colors.purple.shade300],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.pop(),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              // 用户身份模块
              _buildUserIdentityCard(),
              const SizedBox(height: 24),

              // 个性化设置
              _buildDataCard(
                title: '对话偏好设置',
                children: [
                  _buildEditableItem(
                    icon: Icons.psychology,
                    title: 'AI名称',
                    value: _aiName,
                    onEdit: () => _showNameEditor(),
                  ),
                  _buildSwitchItem(
                    icon: Icons.notifications,
                    title: '新消息通知',
                    value: _notificationEnabled,
                    onChanged: (v) => setState(() => _notificationEnabled = v),
                  ),
                  _buildSwitchItem(
                    icon: Icons.cloud_sync,
                    title: '云端同步',
                    value: _dataSyncEnabled,
                    onChanged: (v) => setState(() => _dataSyncEnabled = v),
                  ),
                  _buildNavigationItem(
                    icon: Icons.history,
                    title: '对话历史',
                    onTap: () => context.push('/chat-history'),
                  ),
                ],
              ),
              
              // 新增：底部操作按钮
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: authViewModel.isAuthenticated 
                        ? Colors.red.shade400 
                        : Colors.blue.shade400,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      if (authViewModel.isAuthenticated) {
                        authViewModel.logout();
                        context.go('/login');
                      } else {
                        context.go('/login');
                      }
                    },
                    child: Text(
                      authViewModel.isAuthenticated ? '退出登录' : '立即登录',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
  Widget _buildUserIdentityCard() {
    return Transform.translate(
      offset: const Offset(0, -40),
      child: Center(
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundImage: NetworkImage('https://example.com/avatar.jpg'),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(Icons.edit, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text('AI探索者',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('user@aichat.com',
                style: TextStyle(color: Colors.grey.shade600)),
          ],
        ),
      ),
    );
  }

  Widget _buildDataCard({required String title, required List<Widget> children}) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, 
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue
                )),
            const Divider(height: 24),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDataItem(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 20),
          const SizedBox(width: 12),
          Text(title, style: const TextStyle(fontSize: 14)),
          const Spacer(),
          Text(value, 
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500
              )),
        ],
      ),
    );
  }

  Widget _buildEditableItem({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onEdit,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 20),
          const SizedBox(width: 12),
          Text(title, style: const TextStyle(fontSize: 14)),
          const Spacer(),
          Text(value, 
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
              )),
          IconButton(
            icon: Icon(Icons.edit, size: 18, color: Colors.blue.shade300),
            onPressed: onEdit,
          )
        ],
      ),
    );
  }

  Widget _buildSwitchItem({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 20),
          const SizedBox(width: 12),
          Text(title, style: const TextStyle(fontSize: 14)),
          const Spacer(),
          Switch(
            value: value,
            activeColor: Colors.blue,
            onChanged: onChanged,
          )
        ],
      ),
    );
  }

  Widget _buildNavigationItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: Colors.blue, size: 20),
            const SizedBox(width: 12),
            Text(title, style: const TextStyle(fontSize: 14)),
            const Spacer(),
            Icon(Icons.chevron_right, color: Colors.grey.shade400)
          ],
        ),
      ),
    );
  }

  void _showNameEditor() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('修改AI名称'),
        content: TextField(
          controller: TextEditingController(text: _aiName),
          decoration: InputDecoration(
            hintText: '输入新的AI名称',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              // 保存逻辑
              Navigator.pop(context);
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }
}
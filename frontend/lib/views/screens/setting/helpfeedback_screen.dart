import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// import 'package:intl/intl.dart';

// 帮助类型枚举
enum FeedbackType {
  general('一般问题'),
  feature('功能建议'),
  bug('错误报告'),
  other('其他');

  final String label;
  const FeedbackType(this.label);
}

// 常见问题数据模型
class FAQItem {
  final String question;
  final String answer;
  bool isExpanded;

  FAQItem(this.question, this.answer, [this.isExpanded = false]);
}

class HelpFeedbackScreen extends StatefulWidget {
  const HelpFeedbackScreen({super.key});

  @override
  State<HelpFeedbackScreen> createState() => _HelpFeedbackScreenState();
}

class _HelpFeedbackScreenState extends State<HelpFeedbackScreen> {
  final _feedbackController = TextEditingController();
  FeedbackType _selectedType = FeedbackType.general;
  final List<FAQItem> _faqs = [
    FAQItem("如何使用AI聊天功能？", "在首页点击聊天按钮即可开始与AI交流，它会引导您进行CBT练习。"),
    FAQItem("心理测评准确吗？", "我们的测评基于专业心理学量表开发，结果可作为自我认知的参考。"),
    FAQItem("专注目标如何工作？", "设定目标后，AI会定期提醒并帮助您分解任务步骤。"),
    FAQItem("数据隐私如何保障？", "所有对话数据都经过加密处理，严格遵守隐私保护条例。"),
  ];

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                // 返回按钮
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black87),
                  onPressed: () => context.pop(),
                ),
                const SizedBox(height: 16),

                // 主标题
                const Text(
                  '帮助与反馈',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 24),

                // 常见问题版块
                _buildFAQSections(),

                // 反馈表单
                Expanded(
                  child: SingleChildScrollView(child: _buildFeedbackForm()),
                ),

                // 联系信息
                _buildContactInfo(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFAQSections() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade100, width: 1),
      ),
      child: ExpansionPanelList(
        expansionCallback: (index, isExpanded) {
          setState(() {
            _faqs[index].isExpanded = !isExpanded;
          });
        },
        children:
            _faqs.map<ExpansionPanel>((item) {
              return ExpansionPanel(
                headerBuilder:
                    (context, isExpanded) => ListTile(
                      title: Text(
                        item.question,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                body: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                  child: Text(
                    item.answer,
                    style: TextStyle(color: Colors.grey.shade700, height: 1.4),
                  ),
                ),
                isExpanded: item.isExpanded,
              );
            }).toList(),
      ),
    );
  }

  Widget _buildFeedbackForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        const Text(
          '提交反馈',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 8,
          children:
              FeedbackType.values.map((type) {
                return ChoiceChip(
                  label: Text(type.label),
                  selected: _selectedType == type,
                  labelStyle: TextStyle(
                    color:
                        _selectedType == type ? Colors.white : Colors.black87,
                  ),
                  selectedColor: const Color(0xFFF28F9A),
                  backgroundColor: Colors.grey.shade200,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  onSelected:
                      (selected) => setState(() => _selectedType = type),
                );
              }).toList(),
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _feedbackController,
          maxLines: 5,
          minLines: 3,
          decoration: _inputDecoration('请详细描述您的建议或遇到的问题...'),
          style: const TextStyle(color: Colors.black87),
        ),
        const SizedBox(height: 32),
        ElevatedButton.icon(
          icon: const Icon(Icons.send, size: 20),
          label: const Text('提交反馈'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF90CAF9),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          onPressed: _handleSubmit,
        ),
      ],
    );
  }

  Widget _buildContactInfo() {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(height: 1),
          const SizedBox(height: 20),
          _buildContactItem(Icons.email, 'CogniCube@mindcare.com'),
          const SizedBox(height: 12),
          _buildContactItem(Icons.access_time, '在线客服：工作日 13:00-18:00'),
          const SizedBox(height: 12),
          _buildContactItem(Icons.info_outline, '版本号：1.0.1'),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey.shade600),
        const SizedBox(width: 12),
        Text(text, style: TextStyle(color: Colors.grey.shade700, fontSize: 14)),
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade600),
      filled: true,
      fillColor: Colors.white.withOpacity(0.9),
      contentPadding: const EdgeInsets.all(16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFF28F9A), width: 1.5),
      ),
    );
  }

  void _handleSubmit() {
    final feedback = _feedbackController.text.trim();

    if (feedback.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请输入反馈内容'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // 模拟提交成功
    _feedbackController.clear();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('反馈已提交，感谢您的支持！'),
        backgroundColor: Colors.green.shade400,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}

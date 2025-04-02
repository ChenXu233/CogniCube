import 'package:flutter/material.dart';
import '../../../../models/assessment_model.dart';

class TestsResultScreen extends StatelessWidget {
  final Assessment assessment;
  final int score;

  const TestsResultScreen({
    super.key,
    required this.assessment,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    final (String, Color, String) result = _calculateResult();

    return Scaffold(
      appBar: AppBar(
        title: Text('${assessment.title}结果'),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 评分卡片
            _buildScoreCard(result.$2),
            const SizedBox(height: 20),
            // 状态标签
            _buildStatusLabel(result.$1, result.$2),
            const SizedBox(height: 20),
            // 建议内容
            _buildRecommendation(result.$3),
            const Spacer(),
            // 操作按钮
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreCard(Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              '综合评分',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Text(
              '$score',
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: score / (assessment.type == 'phq9' ? 27 : 21),
              backgroundColor: Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusLabel(String status, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildRecommendation(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 15,
          height: 1.6,
          color: Colors.black87,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed:
              () => Navigator.popUntil(context, (route) => route.isFirst),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade800,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('返回首页'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('重新测试'),
        ),
      ],
    );
  }

  (String, Color, String) _calculateResult() {
    if (assessment.type == 'phq9') {
      return switch (score) {
        >= 20 => ('重度抑郁', Colors.red, '建议立即联系心理咨询师或精神科医生'),
        >= 15 => ('中重度抑郁', Colors.orange, '推荐使用认知重构工具，并考虑专业咨询'),
        >= 10 => ('中度抑郁', Colors.amber, '尝试情绪日记和呼吸放松练习'),
        >= 5 => ('轻度抑郁', Colors.yellow, '建议增加户外活动，使用CBT工具'),
        _ => ('无显著症状', Colors.green, '保持当前状态，定期自我评估'),
      };
    } else {
      return switch (score) {
        >= 15 => ('严重焦虑', Colors.red, '推荐进行渐进式肌肉放松训练'),
        >= 10 => ('中度焦虑', Colors.orange, '使用思维记录表管理担忧'),
        >= 5 => ('轻度焦虑', Colors.yellow, '推荐呼吸练习和情绪追踪'),
        _ => ('无显著焦虑', Colors.green, '保持健康作息'),
      };
    }
  }
}

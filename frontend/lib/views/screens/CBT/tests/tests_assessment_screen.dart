import 'package:flutter/material.dart';
import 'package:cognicube/views/screens/CBT/tests/tests_result_screen.dart';
import '../../../../data/assessment_data.dart';
import '../../../../models/assessment_model.dart';

class AssessmentScreen extends StatefulWidget {
  final String assessmentId;

  const AssessmentScreen({super.key, required this.assessmentId});

  @override
  State<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen> {
  late Assessment assessment;
  int _currentIndex = 0;
  final Map<int, int?> _answers = {};

  @override
  void initState() {
    super.initState();
    assessment = assessments.firstWhere((a) => a.id == widget.assessmentId);
  }

  void _selectAnswer(int? value) async {
    setState(() {
      _answers[_currentIndex] = value;
    });

    final isLast = _currentIndex == assessment.questions.length - 1;

    if (!isLast) {
      // 显示过渡动画页面（非最后一题）
      await Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const TransitionScreen(),
          transitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );

      setState(() {
        _currentIndex++;
      });
    } else {
      // 最后一题，直接跳转到结果页
      _showResult();
    }
  }

  void _showResult() {
    final score = _answers.values.fold<int>(
      0,
      (sum, value) => sum + (value ?? 0),
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) =>
                TestsResultScreen(assessment: assessment, score: score),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = assessment.questions[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(assessment.title),
        backgroundColor: const Color.fromARGB(255, 176, 141, 237),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              value: (_currentIndex + 1) / assessment.questions.length,
              backgroundColor: const Color(0xFFEDE7F6),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color.fromARGB(255, 115, 86, 165),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '第 ${_currentIndex + 1} 题（共 ${assessment.questions.length} 题）',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
            const SizedBox(height: 16),
            Text(
              question.text,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 24),
            Column(
              children:
                  question.options
                      .asMap()
                      .entries
                      .map(
                        (entry) => RadioListTile<int>(
                          title: Text(entry.value),
                          value: entry.key,
                          groupValue: _answers[_currentIndex],
                          onChanged: (value) => _selectAnswer(value),
                          activeColor: const Color.fromARGB(255, 176, 146, 228),
                        ),
                      )
                      .toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// 过渡页面
class TransitionScreen extends StatelessWidget {
  const TransitionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 300), () {
      Navigator.pop(context);
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            CircularProgressIndicator(
              color: Color.fromARGB(255, 176, 146, 228),
              strokeWidth: 4,
            ),
            SizedBox(height: 16),
            Text(
              '正在加载下一题...',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

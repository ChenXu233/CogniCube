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

  void _selectAnswer(int? value) {
    setState(() {
      _answers[_currentIndex] = value;
    });
  }

  void _nextQuestion() {
    if (_currentIndex < assessment.questions.length - 1) {
      setState(() => _currentIndex++);
    } else {
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
        backgroundColor: Color.fromARGB(255, 176, 141, 237),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              value: (_currentIndex + 1) / assessment.questions.length,
              backgroundColor: Color(0xFFEDE7F6),
              valueColor: AlwaysStoppedAnimation<Color>(
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
                          activeColor: Color.fromARGB(255, 176, 146, 228),
                        ),
                      )
                      .toList(),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _answers[_currentIndex] != null ? _nextQuestion : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 175, 145, 226),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                _currentIndex < assessment.questions.length - 1
                    ? '下一题'
                    : '查看结果',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

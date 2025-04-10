import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../data/assessment_data.dart';
import '../../../../models/assessment_model.dart';

class TestsScreen extends StatelessWidget {
  const TestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('心理自测量表'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/home', extra: {'pageIndex': 0});
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF0E6F6), // 淡粉紫
              Color(0xFFF9EEF3), // 粉白
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 100, 16, 24),
          child: ListView.separated(
            itemCount: assessments.length,
            separatorBuilder: (_, __) => const SizedBox(height: 24),
            itemBuilder: (context, index) {
              final assessment = assessments[index];
              return AssessmentCard(assessment: assessment);
            },
          ),
        ),
      ),
    );
  }
}

class AssessmentCard extends StatelessWidget {
  final Assessment assessment;

  const AssessmentCard({super.key, required this.assessment});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFF5F2F5), // 灰紫卡片背景
      elevation: 6,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => context.go('/cbt/tests/${assessment.id}'),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.bar_chart, color: const Color(0xFF9C6B9D), size: 36),
              const SizedBox(height: 14),
              Text(
                assessment.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF8C5C8D),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                assessment.description,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.touch_app, color: Color(0xFFCAA5D6), size: 18),
                  SizedBox(width: 6),
                  Text(
                    '点击卡片开始测试',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFFB288BA),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

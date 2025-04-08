import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../data/assessment_data.dart';
import '../../../../models/assessment_model.dart';

class TestsScreen extends StatelessWidget {
  const TestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 💜 顶部渐变背景色更柔和
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
              Color(0xFFF0E6F6), // 淡淡的粉紫
              Color(0xFFF9EEF3), // 淡粉白
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 100, 16, 24), // 🪄 全体下移美化
          child: ListView.separated(
            itemCount: assessments.length,
            separatorBuilder:
                (_, __) => const SizedBox(height: 24), // ✨ 卡片之间拉开距离
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
      color: const Color(0xFFF5F2F5), // ✨ 灰紫色卡片背景（提升高级感）
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
              Icon(
                Icons.bar_chart,
                color: const Color(0xFF9C6B9D), // 温柔紫图标
                size: 36,
              ),
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
              ElevatedButton.icon(
                onPressed: () => context.go('/cbt/tests/${assessment.id}'),
                icon: const Icon(Icons.arrow_forward_ios, size: 14),
                label: const Text('立即开始', style: TextStyle(fontSize: 14)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE2D7E9),
                  foregroundColor: const Color(0xFF774C8F),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

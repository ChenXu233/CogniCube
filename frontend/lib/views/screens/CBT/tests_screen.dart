import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../data/assessment_data.dart';
import '../../../models/assessment_model.dart';

class TestsScreen extends StatelessWidget {
  const TestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('心理自测量表'),
        backgroundColor: const Color.fromARGB(198, 238, 167, 208),
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.separated(
          itemCount: assessments.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final assessment = assessments[index];
            return AssessmentCard(assessment: assessment);
          },
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
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.blue.shade100.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.go('/cbt/tests/${assessment.id}'), // ✅ 确保路径正确
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                assessment.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 212, 138, 194),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                assessment.description,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

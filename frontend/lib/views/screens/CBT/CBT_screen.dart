import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CBTScreen extends StatelessWidget {
  final List<Map<String, dynamic>> features = [
    {'icon': Icons.mood, 'label': '情绪追踪', 'route': '/cbt/mood'},
    {'icon': Icons.checklist, 'label': '测试', 'route': '/cbt/tests'},
    {'icon': Icons.air, 'label': '深呼吸', 'route': '/breathings'},
    {'icon': Icons.self_improvement, 'label': '打坐', 'route': '/affirmations'},
    {'icon': Icons.emoji_events, 'label': '挑战', 'route': '/challenges'},
    {'icon': Icons.spa, 'label': '冥想', 'route': '/meditations'},
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView.separated(
          itemCount: features.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return _FeatureCard(
              icon: features[index]['icon'] as IconData,
              label: features[index]['label'] as String,
              routePath: features[index]['route'] as String,
            );
          },
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String routePath;

  const _FeatureCard({
    required this.icon,
    required this.label,
    required this.routePath,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go(routePath), // ✅ 确保传递完整路径
      child: SizedBox(
        height: 100,
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade200, width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 28, color: Colors.blue.shade800),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue.shade900,
                    ),
                  ),
                ),
                _StartButton(
                  onPressed: () => context.go(routePath),
                ), // ✅ 确保传递完整路径
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StartButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _StartButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonal(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.blue.shade100),
        foregroundColor: WidgetStatePropertyAll(Colors.blue.shade800),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      onPressed: onPressed,
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('开始'),
          SizedBox(width: 8),
          Icon(Icons.arrow_forward, size: 18),
        ],
      ),
    );
  }
}

// CBT_screen.dart
final List<Map<String, dynamic>> features = [
  {
    'icon': Icons.mood,
    'label': 'PHQ-9抑郁测试',
    'route': '/cbt/tests/phq-9', // 匹配动态路由格式
  },
  {'icon': Icons.checklist, 'label': 'GAD-7焦虑测试', 'route': '/cbt/tests/gad-7'},
];

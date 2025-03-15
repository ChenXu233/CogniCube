import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CBTScreen extends StatelessWidget {
  final List<Map<String, dynamic>> icons = [
    {'icon': Icons.mood, 'label': 'Mood Tracker', 'route': '/mood'},
    {'icon': Icons.book, 'label': 'Journal', 'route': '/journal'},
    {'icon': Icons.note, 'label': 'Notepad', 'route': '/notepad'},
    {'icon': Icons.checklist, 'label': 'Tests', 'route': '/tests'},
    {'icon': Icons.smart_toy, 'label': 'AI Advisor', 'route': '/ai'},
    {'icon': Icons.air, 'label': 'Breathings', 'route': '/breathings'},
    {
      'icon': Icons.self_improvement,
      'label': 'Affirmations',
      'route': '/affirmations',
    },
    {'icon': Icons.format_quote, 'label': 'Quotes', 'route': '/quotes'},
    {'icon': Icons.emoji_events, 'label': 'Challenges', 'route': '/challenges'},
    {'icon': Icons.spa, 'label': 'Meditations', 'route': '/meditations'},
    {'icon': Icons.headphones, 'label': 'Sounds', 'route': '/sounds'},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // 三列排列
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: icons.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              context.go(icons[index]['route']); // 点击跳转到指定路由
            },
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icons[index]['icon'],
                    size: 40,
                    color: Colors.green,
                  ),
                ),
                SizedBox(height: 8),
                Text(icons[index]['label'], style: TextStyle(fontSize: 14)),
              ],
            ),
          );
        },
      ),
    );
  }
}

// cbt_view_model.dart
import 'package:flutter/material.dart';

class CBTViewModel extends ChangeNotifier {
  List<CBTFeature> features = [];

  CBTViewModel() {
    _loadDefaultFeatures(); // 自主初始化数据
  }

  void _loadDefaultFeatures() {
    features = [
      CBTFeature(icon: Icons.mood, label: '情绪追踪', routePath: '/cbt/mood'),
      CBTFeature(
        icon: Icons.assessment,
        label: '认知训练',
        routePath: '/cbt/training',
      ),
    ];
  }
}

class CBTFeature {
  final IconData icon;
  final String label;
  final String routePath;

  const CBTFeature({
    required this.icon,
    required this.label,
    required this.routePath,
  });
}

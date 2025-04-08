import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../view_models/cbt_view_model.dart';
import '../../../utils/gradient_helper.dart';
import 'dart:ui' as ui;

class CBTScreen extends StatelessWidget {
  const CBTScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CBTViewModel(),
      child: _CBTScaffold(),
    );
  }
}

class _CBTScaffold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<CBTViewModel>();

    return Stack(
      children: [
        // 💜 底层渐变背景
        Container(decoration: BoxDecoration(gradient: createPrimaryGradient())),

        // 💜 模糊 + 半透明白滤镜（加了柔化背景效果）
        Positioned.fill(
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: const Color.fromARGB(150, 255, 255, 255)),
          ),
        ),

        // 主体内容
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 32,
              bottom: 16,
            ),
            child: ListView.separated(
              itemCount: viewModel.features.length,
              separatorBuilder: (_, __) => const SizedBox(height: 20),
              itemBuilder: (context, index) {
                final feature = viewModel.features[index];
                return _FancyFeatureCard(feature: feature);
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _FancyFeatureCard extends StatelessWidget {
  final CBTFeature feature;

  const _FancyFeatureCard({required this.feature});

  @override
  Widget build(BuildContext context) {
    final Color softPurple = const Color(0xFF9C89B8);
    final Color background = const Color.fromARGB(150, 255, 255, 255);

    // 💡 文案判断逻辑
    String subtitleText;
    String buttonText;
    String displayLabel = feature.label;

    if (feature.label == '情绪追踪') {
      subtitleText = '点击开始记录';
      buttonText = '立即开始';
    } else if (feature.label == '认知训练') {
      displayLabel = '心理测评';
      subtitleText = '点击开始测试';
      buttonText = '立即开始';
    } else {
      subtitleText = '点击开始对话';
      buttonText = '立即与我对话';
    }

    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: InkWell(
            onTap: () => context.go(feature.routePath),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(feature.icon, size: 36, color: softPurple),
                  const SizedBox(height: 12),
                  Text(
                    displayLabel,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: softPurple,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitleText,
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const Spacer(),
                  FilledButton.tonal(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        softPurple.withOpacity(0.15),
                      ),
                      foregroundColor: WidgetStatePropertyAll(softPurple),
                      padding: const WidgetStatePropertyAll(
                        EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    onPressed: () => context.go(feature.routePath),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(buttonText),
                        const SizedBox(width: 6),
                        const Icon(Icons.arrow_forward_ios, size: 14),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

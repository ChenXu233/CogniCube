// cbt_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../view_models/cbt_view_model.dart';
import '../../../utils/gradient_helper.dart';

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

    return Container(
      decoration: BoxDecoration(gradient: createPrimaryGradient()),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView.separated(
            itemCount: viewModel.features.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final feature = viewModel.features[index];
              return Card(
                elevation: 2,
                child: ListTile(
                  leading: _FeatureIcon(feature.icon),
                  title: Text(
                    feature.label,
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: _ActionButton(
                    onPressed: () => context.go(feature.routePath),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _FeatureIcon extends StatelessWidget {
  final IconData icon;

  const _FeatureIcon(this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: primaryColor),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _ActionButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonal(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(primaryColor.withOpacity(0.2)),
        foregroundColor: WidgetStatePropertyAll(primaryColor),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 16),
        ),
      ),
      onPressed: onPressed,
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('开始'),
          SizedBox(width: 4),
          Icon(Icons.arrow_forward, size: 16),
        ],
      ),
    );
  }
}

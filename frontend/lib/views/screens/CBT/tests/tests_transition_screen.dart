import 'package:flutter/material.dart';

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
              color: Color.fromARGB(255, 176, 141, 237),
            ),
            SizedBox(height: 16),
            Text(
              '加载下一题中...',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}

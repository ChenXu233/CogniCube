import 'package:flutter/material.dart';
import 'dart:async';

class CountdownTimer extends StatefulWidget {
  final Duration initialTime;
  final TextStyle? textStyle;

  const CountdownTimer({super.key, required this.initialTime, this.textStyle});

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Duration _remainingTime;
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.initialTime;
  }

  void _startTimer() {
    _stopwatch.start();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        final elapsed = _stopwatch.elapsed;
        _remainingTime = widget.initialTime - elapsed;
        if (_remainingTime.inSeconds <= 0) {
          _remainingTime = Duration.zero;
          _stopTimer();
        }
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _stopwatch.stop();
    _stopwatch.reset();
  }

  void _resetTimer() {
    setState(() {
      _remainingTime = widget.initialTime;
    });
    _stopTimer();
  }

  String _formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          _formatTime(_remainingTime),
          style:
              widget.textStyle ??
              const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                if (_timer?.isActive ?? false) {
                  _stopTimer();
                } else {
                  _startTimer();
                }
              },
              child: Text(_timer?.isActive ?? false ? '暂停' : '开始'),
            ),
            const SizedBox(width: 10),
            OutlinedButton(onPressed: _resetTimer, child: const Text('重置')),
          ],
        ),
      ],
    );
  }
}

// 使用示例
class TimerDemo extends StatelessWidget {
  const TimerDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('倒计时示例')),
      body: Center(
        child: CountdownTimer(
          initialTime: const Duration(minutes: 5),
          textStyle: const TextStyle(
            fontSize: 64,
            color: Colors.red,
            fontFamily: 'Digital',
          ),
        ),
      ),
    );
  }
}

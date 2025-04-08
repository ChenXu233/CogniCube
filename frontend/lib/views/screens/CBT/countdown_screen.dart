import 'package:flutter/material.dart';
import 'dart:async';

/// 倒计时组件，显示倒计时数字及控制按钮
class CountdownTimer extends StatefulWidget {
  final Duration initialTime;
  final TextStyle? textStyle;

  const CountdownTimer({Key? key, required this.initialTime, this.textStyle})
    : super(key: key);

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

/// 倒计时设置页面：用户可输入倒计时分钟数，然后点击开始按钮跳转到倒计时页面
class CountdownScreen extends StatefulWidget {
  const CountdownScreen({Key? key}) : super(key: key);

  @override
  _CountdownScreenState createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> {
  final TextEditingController _controller = TextEditingController();
  Duration _initialTime = const Duration(minutes: 5); // 默认5分钟

  void _startCountdown() {
    // 尝试将输入的字符串转换为整数，若失败则默认5分钟
    int minutes = int.tryParse(_controller.text) ?? 5;
    setState(() {
      _initialTime = Duration(minutes: minutes);
    });
    // 跳转到一个新的页面显示 CountdownTimer
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => Scaffold(
              appBar: AppBar(title: const Text('倒计时')),
              body: Center(
                child: CountdownTimer(
                  initialTime: _initialTime,
                  textStyle: const TextStyle(
                    fontSize: 64,
                    color: Colors.red,
                    fontFamily: 'Digital',
                  ),
                ),
              ),
            ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('设置倒计时')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: '输入倒计时的分钟数',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _startCountdown,
                child: const Text('开始倒计时'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:vibration/vibration.dart';

class CountdownScreen extends StatefulWidget {
  const CountdownScreen({super.key});

  @override
  _CountdownScreenState createState() => _CountdownScreenState();
}

class _CountdownScreenState extends State<CountdownScreen> {
  int _selectedMinutes = 5;
  int _selectedSeconds = 0;
  late Duration _remainingTime;
  Timer? _timer;
  Timer? _quoteTimer;
  bool _isRunning = false;
  int _quoteIndex = 0;

  final List<String> _quotes = [
    '🌱 每一次专注，都是成长的种子',
    '🌼 慢慢来，也没关系哦',
    '🌸 给自己一点时间，温柔前行',
    '🌞 小目标完成的那刻，阳光刚好',
    '🕊️ 放松呼吸，世界很温柔',
  ];

  final FixedExtentScrollController _minuteController =
      FixedExtentScrollController(initialItem: 5);
  final FixedExtentScrollController _secondController =
      FixedExtentScrollController();

  @override
  void initState() {
    super.initState();
    _remainingTime = Duration(
      minutes: _selectedMinutes,
      seconds: _selectedSeconds,
    );
    _startQuoteRotation();
  }

  void _startQuoteRotation() {
    _quoteTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        _quoteIndex = (_quoteIndex + 1) % _quotes.length;
      });
    });
  }

  void _startTimer() {
    setState(() => _isRunning = true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_remainingTime.inSeconds == 0) {
        _stopTimer();
        if (await Vibration.hasVibrator() ?? false) {
          Vibration.vibrate(duration: 500);
        }
        return;
      }
      setState(() {
        _remainingTime -= const Duration(seconds: 1);
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _remainingTime = Duration(
        minutes: _selectedMinutes,
        seconds: _selectedSeconds,
      );
    });
  }

  String _formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(duration.inMinutes)}:${twoDigits(duration.inSeconds.remainder(60))}";
  }

  Widget _buildPicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            const Text("分钟", style: TextStyle(fontSize: 16)),
            SizedBox(
              height: 120,
              width: 80,
              child: ListWheelScrollView.useDelegate(
                controller: _minuteController,
                itemExtent: 40,
                magnification: 1.2,
                useMagnifier: true,
                physics: const FixedExtentScrollPhysics(),
                onSelectedItemChanged: (value) {
                  _selectedMinutes = value;
                  _resetTimer();
                },
                childDelegate: ListWheelChildBuilderDelegate(
                  builder:
                      (context, index) => Center(
                        child: Text(
                          '$index',
                          style: const TextStyle(fontSize: 22),
                        ),
                      ),
                  childCount: 60,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 30),
        Column(
          children: [
            const Text("秒钟", style: TextStyle(fontSize: 16)),
            SizedBox(
              height: 120,
              width: 80,
              child: ListWheelScrollView.useDelegate(
                controller: _secondController,
                itemExtent: 40,
                magnification: 1.2,
                useMagnifier: true,
                physics: const FixedExtentScrollPhysics(),
                onSelectedItemChanged: (value) {
                  _selectedSeconds = value;
                  _resetTimer();
                },
                childDelegate: ListWheelChildBuilderDelegate(
                  builder:
                      (context, index) => Center(
                        child: Text(
                          '$index',
                          style: const TextStyle(fontSize: 22),
                        ),
                      ),
                  childCount: 60,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _quoteTimer?.cancel();
    _minuteController.dispose();
    _secondController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark
              ? const Color(0xFFF8F7F7)
              : const Color.fromARGB(255, 255, 244, 251),
      appBar: AppBar(
        title: const Text('治愈系倒计时'),
        backgroundColor: const Color.fromARGB(158, 188, 145, 240),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _formatTime(_remainingTime),
              style: const TextStyle(
                fontSize: 60,
                fontWeight: FontWeight.bold,
                fontFamily: 'Courier',
                color: Color.fromARGB(255, 170, 118, 250),
              ),
            ),
            const SizedBox(height: 20),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: Text(
                _quotes[_quoteIndex],
                key: ValueKey(_quoteIndex),
                style: const TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  color: Color.fromARGB(255, 154, 111, 255),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),
            if (!_isRunning) _buildPicker(),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _isRunning ? _stopTimer : _startTimer,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(153, 212, 167, 255),
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 20,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: Text(
                _isRunning ? '暂停' : '开始',
                style: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            if (!_isRunning && _remainingTime.inSeconds == 0)
              const Text(
                '🎉 时间到啦！辛苦了宝贝！',
                style: TextStyle(
                  fontSize: 22,
                  color: Color.fromARGB(255, 212, 140, 255),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

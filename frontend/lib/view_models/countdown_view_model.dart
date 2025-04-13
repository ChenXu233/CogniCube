import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CountdownItem {
  final String id;
  final int minutes;
  final String goal;
  bool isRunning = false;
  Duration remaining;

  CountdownItem({required this.id, required this.minutes, required this.goal})
    : remaining = Duration(minutes: minutes);

  Map<String, dynamic> toJson() => {'id': id, 'minutes': minutes, 'goal': goal};

  static CountdownItem fromJson(Map<String, dynamic> json) {
    return CountdownItem(
      id: json['id'],
      minutes: json['minutes'],
      goal: json['goal'],
    );
  }
}

class CountdownViewModel extends ChangeNotifier {
  final List<CountdownItem> _items = [];
  CountdownItem? _currentItem;
  Timer? _timer;
  bool _disposed = false;

  List<CountdownItem> get items => _items;
  CountdownItem? get currentItem => _currentItem;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final taskList = prefs.getStringList('tasks') ?? [];

    _items.clear();
    for (String taskJson in taskList) {
      final Map<String, dynamic> taskData = json.decode(taskJson);
      _items.add(CountdownItem.fromJson(taskData));
    }
    notifyListeners();
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final taskList = _items.map((e) => json.encode(e.toJson())).toList();
    await prefs.setStringList('tasks', taskList);
  }

  void addItem(int minutes, String goal) {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    _items.add(CountdownItem(id: id, minutes: minutes, goal: goal));
    _saveTasks();
    notifyListeners();
  }

  void startCountdown(CountdownItem item) {
    _currentItem = item;
    item.isRunning = true;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (item.remaining.inSeconds <= 0) {
        stopCountdown();
      } else {
        item.remaining -= const Duration(seconds: 1);
        notifyListeners();
      }
    });
  }

  void stopCountdown() {
    _timer?.cancel();
    _currentItem?.isRunning = false;
    _currentItem = null;
    _saveTasks();
    notifyListeners();
  }

  void togglePause() {
    if (_timer?.isActive ?? false) {
      _timer?.cancel();
      _currentItem?.isRunning = false;
    } else if (_currentItem != null) {
      startCountdown(_currentItem!);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _timer?.cancel();
    super.dispose(); // Don't forget to call super.dispose()!
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }
}

// CountdownPage with MouseRegion for hover effect
class CountdownPage extends StatefulWidget {
  const CountdownPage({super.key});

  @override
  State<CountdownPage> createState() => _CountdownPageState();
}

class _CountdownPageState extends State<CountdownPage> {
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _goalController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CountdownViewModel>(context);
    final current = vm.currentItem;

    return Scaffold(
      appBar: AppBar(
        title: const Text('治愈系倒计时'),
        backgroundColor: Colors.purple[100],
      ),
      backgroundColor: const Color(0xFFFDF7FB),
      body:
          current == null
              ? Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text('设置一个小目标 ✨', style: TextStyle(fontSize: 20)),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView(
                        children:
                            vm.items.map((item) {
                              return MouseRegion(
                                onEnter: (_) => setState(() {}),
                                onExit: (_) => setState(() {}),
                                child: Card(
                                  elevation: 4,
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ListTile(
                                    title: Text(item.goal),
                                    subtitle: Text('${item.minutes} 分钟'),
                                    trailing: const Icon(Icons.play_arrow),
                                    onTap: () => vm.startCountdown(item),
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                  ],
                ),
              )
              : CountdownRunningView(item: current),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddGoalDialog(context, vm),
        backgroundColor: Colors.purple,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddGoalDialog(BuildContext context, CountdownViewModel vm) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('设置小目标'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _timeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: '时间（分钟）',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _goalController,
                decoration: const InputDecoration(
                  labelText: '小目标描述',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final time = int.tryParse(_timeController.text);
                final goal = _goalController.text;
                if (time != null && goal.isNotEmpty) {
                  vm.addItem(time, goal);
                  _timeController.clear();
                  _goalController.clear();
                  Navigator.pop(context);
                }
              },
              child: const Text('添加'),
            ),
            TextButton(
              onPressed: () {
                _timeController.clear();
                _goalController.clear();
                Navigator.pop(context);
              },
              child: const Text('取消'),
            ),
          ],
        );
      },
    );
  }
}

// CountdownRunningView widget
class CountdownRunningView extends StatelessWidget {
  final CountdownItem item;

  const CountdownRunningView({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CountdownViewModel>(context);
    final totalSeconds = item.minutes * 60;
    final elapsedSeconds = totalSeconds - item.remaining.inSeconds;
    final percent = elapsedSeconds / totalSeconds;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('倒计时中...', style: TextStyle(fontSize: 22)),
        const SizedBox(height: 16),
        Text(
          '${item.remaining.inMinutes.toString().padLeft(2, '0')}:${(item.remaining.inSeconds % 60).toString().padLeft(2, '0')}',
          style: const TextStyle(fontSize: 48, color: Colors.deepPurple),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: LinearProgressIndicator(
            value: percent,
            backgroundColor: Colors.purple[50],
            color: Colors.purple,
            minHeight: 12,
          ),
        ),
        const SizedBox(height: 20),
        Text(item.goal, style: const TextStyle(fontSize: 18)),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () => vm.togglePause(),
          child: Text(item.isRunning ? '暂停' : '继续'),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () => vm.stopCountdown(),
          child: const Text('结束倒计时'),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../../view_models/countdown_view_model.dart';

class CountdownScreen extends StatelessWidget {
  const CountdownScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CountdownViewModel(),
      child: const CountdownPage(),
    );
  }
}

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home', extra: {'pageIndex': 0}),
        ),
        title: const Text('治愈系倒计时'),
        backgroundColor: Colors.purple[100],
      ),
      backgroundColor: const Color(0xFFFDF7FB),
      body:
          current == null
              ? Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('设置一个小目标 ✨', style: TextStyle(fontSize: 20)),
                    const SizedBox(height: 16),
                    Expanded(
                      child:
                          vm.items.isEmpty
                              ? const Center(
                                child: Text(
                                  '暂无小目标，点右下角加号添加吧 💖',
                                  style: TextStyle(fontSize: 16),
                                ),
                              )
                              : GridView.count(
                                crossAxisCount: 2,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 1.1,
                                children:
                                    vm.items.map((item) {
                                      return GestureDetector(
                                        onTap: () => vm.startCountdown(item),
                                        child: Card(
                                          elevation: 5,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          color: Colors.purple[50],
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.bubble_chart,
                                                  color: Colors.purple,
                                                  size: 32,
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  item.goal,
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.deepPurple,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  '${item.minutes} 分钟',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black54,
                                                  ),
                                                ),
                                              ],
                                            ),
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

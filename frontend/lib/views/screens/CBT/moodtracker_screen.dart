import 'package:flutter/material.dart';

class MoodTrackerScreen extends StatefulWidget {
  const MoodTrackerScreen({super.key});

  @override
  _MoodTrackerScreenState createState() => _MoodTrackerScreenState();
}

class _MoodTrackerScreenState extends State<MoodTrackerScreen> {
  int? selectedMood;
  final TextEditingController _noteController = TextEditingController();

  final List<Map<String, dynamic>> moods = [
    {'emoji': '😡', 'label': '愤怒', 'color': Colors.redAccent.shade100},
    {'emoji': '😟', 'label': '低落', 'color': Colors.orangeAccent.shade100},
    {'emoji': '😐', 'label': '一般', 'color': Colors.yellowAccent.shade100},
    {'emoji': '🙂', 'label': '开心', 'color': Colors.lightGreenAccent.shade100},
    {'emoji': '😄', 'label': '超棒', 'color': Colors.blueAccent.shade100},
  ];

  void _submitMood() {
    if (selectedMood == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('请先选择您的情绪！')));
      return;
    }

    String moodLabel = moods[selectedMood!]['label'];
    String note = _noteController.text;

    // ✅ 这里可以把情绪 & 记录保存到数据库
    print('已记录：情绪 - $moodLabel，日志 - $note');

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('已记录：$moodLabel')));

    setState(() {
      selectedMood = null;
      _noteController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('情绪追踪'),
        backgroundColor: Colors.pink.shade300,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '今天的心情如何？',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // 选择情绪
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(moods.length, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedMood = index;
                    });
                  },
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color:
                              selectedMood == index
                                  ? moods[index]['color']
                                  : Colors.grey.shade200,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          moods[index]['emoji'],
                          style: const TextStyle(fontSize: 28),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        moods[index]['label'],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color:
                              selectedMood == index
                                  ? Colors.pink.shade600
                                  : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),

            const SizedBox(height: 24),

            // 记录日志
            const Text(
              '想说点什么？',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _noteController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: '写下您的感受...',
                filled: true,
                fillColor: Colors.pink.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // 提交按钮
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink.shade400,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _submitMood,
                child: const Text('记录心情', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

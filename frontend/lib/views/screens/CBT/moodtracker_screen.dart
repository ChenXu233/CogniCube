import 'package:flutter/material.dart';

class MoodTrackerScreen extends StatefulWidget {
  const MoodTrackerScreen({super.key});

  @override
  _MoodTrackerScreenState createState() => _MoodTrackerScreenState();
}

class _MoodTrackerScreenState extends State<MoodTrackerScreen> {
  int? selectedMood;
  final TextEditingController _noteController = TextEditingController();

  // 调整情绪颜色为更温馨的色调
  final List<Map<String, dynamic>> moods = [
    {'emoji': '😡', 'label': '愤怒', 'color': Color(0xFFFFCCCC)}, // 淡红色
    {'emoji': '😟', 'label': '低落', 'color': Color(0xFFFFD699)}, // 淡橙色
    {'emoji': '😐', 'label': '一般', 'color': Color(0xFFFFF4C2)}, // 淡黄色
    {'emoji': '🙂', 'label': '开心', 'color': Color(0xFFCCE6CC)}, // 淡绿色
    {'emoji': '😄', 'label': '超棒', 'color': Color(0xFFCCE6FF)}, // 淡蓝色
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
        backgroundColor: Color(0xFFFFB6C1), // 浅粉色
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF0F5), Color(0xFFFFF8E1)], // 淡粉色到奶油色渐变
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '今天的心情如何？',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6D4C41),
                ), // 深棕色
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
                                    ? Color(0xFF6D4C41) // 深棕色
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
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6D4C41),
                ), // 深棕色
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _noteController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: '写下您的感受...',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8), // 半透明白色
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Color(0xFFFFB6C1),
                      width: 2,
                    ), // 浅粉色边框
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 提交按钮
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFFB6C1), // 浅粉色
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _submitMood,
                  child: const Text(
                    '记录心情',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

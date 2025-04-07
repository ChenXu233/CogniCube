import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'target_screen.dart';
import 'package:go_router/go_router.dart';

class MoodTrackerScreen extends StatefulWidget {
  const MoodTrackerScreen({super.key});

  @override
  _MoodTrackerScreenState createState() => _MoodTrackerScreenState();
}

class _MoodTrackerScreenState extends State<MoodTrackerScreen> {
  // ========== 修改后的音乐播放部分 ========== //
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _setupAudio(); // 修改初始化方法
  }

  Future<void> _setupAudio() async {
    // 添加状态监听
    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() => isPlaying = state == PlayerState.playing);
    });

    // 预加载音频源
    try {
      await _audioPlayer.setSource(AssetSource('music.mp3'));
      await _audioPlayer.resume(); // 改为 resume()
    } catch (e) {
      print("初始化音频失败: $e");
    }
  }

  void _toggleMusic() async {
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.resume(); // 恢复播放
    }
  }
  // ========== 修改结束 ========== //

  // 原有情绪跟踪部分
  int? selectedMood;
  final TextEditingController _noteController = TextEditingController();

  final List<Map<String, dynamic>> moods = [
    {'emoji': '😡', 'label': '愤怒', 'color': Color(0xFFFFCCCC)},
    {'emoji': '😟', 'label': '低落', 'color': Color(0xFFFFD699)},
    {'emoji': '😐', 'label': '一般', 'color': Color(0xFFFFF4C2)},
    {'emoji': '🙂', 'label': '开心', 'color': Color(0xFFCCE6CC)},
    {'emoji': '😄', 'label': '超棒', 'color': Color(0xFFCCE6FF)},
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
        backgroundColor: Color(0xFFFFB6C1),
        foregroundColor: Colors.white,
        leading: IconButton(
          // 自定义返回按钮
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Navigator.pushReplacement(
            //   // 替换当前路由更合适
            //   context,
            //   MaterialPageRoute(builder: (context) => TargetScreen()),
            // );
            context.go('/cbt');
          },
        ),
        actions: [
          // 保留音乐按钮
          IconButton(
            icon: Icon(
              isPlaying ? Icons.music_note : Icons.music_off,
              color: Colors.white,
            ),
            onPressed: _toggleMusic,
          ),
        ],
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF0F5), Color(0xFFFFF8E1)],
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
                ),
              ),
              const SizedBox(height: 16),
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
                                    ? Color(0xFF6D4C41)
                                    : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),
              const Text(
                '想说点什么？',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6D4C41),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _noteController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: '写下您的感受...',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFFFFB6C1), width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFFB6C1),
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

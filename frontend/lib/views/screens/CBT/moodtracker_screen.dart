import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:go_router/go_router.dart';

class MoodTrackerScreen extends StatefulWidget {
  const MoodTrackerScreen({super.key});

  @override
  _MoodTrackerScreenState createState() => _MoodTrackerScreenState();
}

class _MoodTrackerScreenState extends State<MoodTrackerScreen> {
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _setupAudio();
  }

  Future<void> _setupAudio() async {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() => isPlaying = state == PlayerState.playing);
    });

    try {
      await _audioPlayer.setSource(AssetSource('music.mp3'));
      await _audioPlayer.resume();
    } catch (e) {
      print("初始化音频失败: $e");
    }
  }

  void _toggleMusic() async {
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.resume();
    }
  }

  int? selectedMood;
  final TextEditingController _noteController = TextEditingController();

  final List<Map<String, dynamic>> moods = [
    {'emoji': '😡', 'label': '愤怒'},
    {'emoji': '😟', 'label': '低落'},
    {'emoji': '😐', 'label': '一般'},
    {'emoji': '🙂', 'label': '开心'},
    {'emoji': '😄', 'label': '超棒'},
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
    const Color softPurple = Color(0xFFE1D5E7);

    return Scaffold(
      appBar: AppBar(
        title: const Text('情绪追踪'),
        backgroundColor: Color(0xFFB39DDB),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/home', extra: {'pageIndex': 0}),
        ),
        actions: [
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
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8F4FF), Color(0xFFEBE1FA)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: ListView(
            children: [
              const Text(
                '亲爱的，今天的你感觉如何呢？',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF6A1B9A),
                ),
              ),
              const SizedBox(height: 22),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.spaceBetween,
                children: List.generate(moods.length, (index) {
                  final isSelected = selectedMood == index;
                  return GestureDetector(
                    onTap: () => setState(() => selectedMood = index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 80,
                      height: 100,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors:
                              isSelected
                                  ? [Color(0xFFD1C4E9), Color(0xFFB39DDB)]
                                  : [softPurple, softPurple],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow:
                            isSelected
                                ? [
                                  BoxShadow(
                                    color: Colors.deepPurple.withOpacity(0.2),
                                    blurRadius: 8,
                                    offset: const Offset(2, 4),
                                  ),
                                ]
                                : [],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            moods[index]['emoji'],
                            style: const TextStyle(fontSize: 30),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            moods[index]['label'],
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Color.fromARGB(150, 74, 20, 140),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 80),
              const Text(
                '想对自己说点什么吗？',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6A1B9A),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _noteController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: '写下你的心情...',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.85),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFFB39DDB),
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 80),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFB39DDB),
                    foregroundColor: Colors.white,
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
              const SizedBox(height: 32),
              const SizedBox(height: 12),
              const Center(
                child: Text(
                  '无论你现在的心情如何，都值得被温柔对待 💜',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF7B1FA2),
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../services/hitokoto.dart';
import '../../../models/hitokoto_model.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:collection/collection.dart';
import '../../../models/emotion_record_model.dart';
import '../../../services/emotion.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  int _currentWeatherIndex = 1; //根据天气数据的索引来显示不同的天气
  late AnimationController _gradientController;
  final List<String> _weatherData = ['晴天', '多云', '雨天'];
  // final List<String> _weatherImages = [
  //   // 'https://example.com/sunny.jpg',
  //   // 'https://example.com/cloudy.jpg',
  //   // 'https://example.com/rainy.jpg',
  // ];
  // 天气图标数据
  final List<IconData> _weatherIcons = [
    Icons.wb_sunny,
    Icons.cloud,
    Icons.beach_access,
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 1);
    _gradientController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _gradientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(color: Colors.transparent),
            ),
          ),
          Column(
            children: [
              const SafeArea(child: SizedBox.shrink()),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      // 调整后的天气区域
                      _buildWeatherHeader(primaryColor),
                      // 卡片区域
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: _buildAIChatCard(primaryColor),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: _buildDailySentenceCard(primaryColor),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        child: _buildEmotionChartCard(primaryColor),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherHeader(Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.only(top: 40, bottom: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              shape: BoxShape.circle,
              border: Border.all(
                color: primaryColor.withOpacity(0.2),
                width: 2,
              ),
            ),
            child: Icon(
              _weatherIcons[_currentWeatherIndex],
              color: primaryColor,
              size: 48, // 增大图标尺寸
            ),
          ),
          const SizedBox(width: 20),
          Text(
            _weatherData[_currentWeatherIndex],
            style: TextStyle(
              fontSize: 32, // 增大字体尺寸
              fontWeight: FontWeight.w600,
              color: primaryColor,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 新增的卡片构建方法
  Widget _buildEmotionChartCard(Color primaryColor) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Material(
        color: Colors.white.withOpacity(0.35),
        child: Container(
          constraints: const BoxConstraints(minHeight: 220, maxHeight: 260),
          padding: const EdgeInsets.all(24),
          child: FutureBuilder<List<EmotionRecord>>(
            future: EmotionApiService.getEmotionHistory(), // 假设已创建API服务
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildChartLoading(primaryColor);
              } else if (snapshot.hasError) {
                return _buildChartError(primaryColor);
              }
              return _buildEmotionChart(snapshot.data!, primaryColor);
            },
          ),
        ),
      ),
    );
  }

  // 图表加载状态
  Widget _buildChartLoading(Color primaryColor) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(color: primaryColor),
        const SizedBox(height: 16),
        Text("正在加载情绪数据...", style: TextStyle(color: primaryColor)),
      ],
    );
  }

  // 图表错误状态
  Widget _buildChartError(Color primaryColor) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.error_outline, color: primaryColor, size: 40),
        const SizedBox(height: 16),
        Text("数据加载失败", style: TextStyle(color: primaryColor)),
      ],
    );
  }

  // 构建图表组件
  Widget _buildEmotionChart(List<EmotionRecord> records, Color primaryColor) {
    final lineBars = _createChartLines(records, primaryColor);

    return LineChart(
      LineChartData(
        lineBarsData: lineBars,
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget:
                  (value, meta) => Text(
                    value.toInt().toString(),
                    style: TextStyle(color: primaryColor, fontSize: 12),
                  ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: _calculateInterval(records),
              getTitlesWidget: (value, meta) {
                final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                return Text(
                  '${date.month}/${date.day}',
                  style: TextStyle(color: primaryColor, fontSize: 12),
                );
              },
            ),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems:
                (items) =>
                    items.map((item) {
                      return LineTooltipItem(
                        '${item.barIndex == 0
                            ? 'Valence'
                            : item.barIndex == 1
                            ? 'Arousal'
                            : 'Intensity'}: ${item.y}',
                        TextStyle(color: Colors.white),
                      );
                    }).toList(),
          ),
        ),
        minX: records.first.time.millisecondsSinceEpoch.toDouble(),
        maxX: records.last.time.millisecondsSinceEpoch.toDouble(),
      ),
      // Removed duplicate lineTouchData parameter
    );
  }

  List<LineChartBarData> _createChartLines(
    List<EmotionRecord> records,
    Color primaryColor,
  ) {
    final sortedRecords = records.sortedBy((r) => r.time);

    return [
      // Valence 线
      LineChartBarData(
        spots:
            sortedRecords
                .map(
                  (r) => FlSpot(
                    r.time.millisecondsSinceEpoch.toDouble(),
                    r.valence,
                  ),
                )
                .toList(),
        color: primaryColor,
        barWidth: 2.5,
        isCurved: true,
        dotData: FlDotData(show: false),
        shadow: Shadow(color: primaryColor.withOpacity(0.3), blurRadius: 8),
      ),
      // Arousal 线
      LineChartBarData(
        spots:
            sortedRecords
                .map(
                  (r) => FlSpot(
                    r.time.millisecondsSinceEpoch.toDouble(),
                    r.arousal,
                  ),
                )
                .toList(),
        color: primaryColor.withOpacity(0.7),
        barWidth: 2,
        isCurved: true,
        dotData: FlDotData(show: false),
      ),
      // Intensity 线
      LineChartBarData(
        spots:
            sortedRecords
                .map(
                  (r) => FlSpot(
                    r.time.millisecondsSinceEpoch.toDouble(),
                    r.intensity_score,
                  ),
                )
                .toList(),
        color: primaryColor.withOpacity(0.4),
        barWidth: 1.5,
        isCurved: true,
        dotData: FlDotData(show: false),
      ),
    ];
  }

  double _calculateInterval(List<EmotionRecord> records) {
    if (records.isEmpty) return 1;
    final duration = records.last.time.difference(records.first.time);
    return duration.inDays > 7 ? 86400000 * 3 : 86400000; // 3天或1天间隔
  }

  Widget _buildAIChatCard(Color primaryColor) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Material(
        color: Colors.white.withOpacity(0.35),
        child: Container(
          constraints: const BoxConstraints(minHeight: 180, maxHeight: 220),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.chat_bubble_rounded,
                    color: primaryColor,
                    size: 36,
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "情绪助手",
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      InkWell(
                        onTap: () => context.push('/chat'),
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: primaryColor.withOpacity(0.3),
                              width: 1.2,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "开启对话",
                                style: TextStyle(
                                  color: primaryColor.withOpacity(0.9),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Icon(
                                Icons.arrow_forward_rounded,
                                color: primaryColor.withOpacity(0.9),
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDailySentenceCard(Color primaryColor) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Material(
        color: Colors.white.withOpacity(0.35),
        child: Container(
          constraints: const BoxConstraints(
            // 添加约束保持卡片高度一致
            minHeight: 180,
            maxHeight: 220,
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    // 修改图标
                    Icons.format_quote_rounded,
                    color: primaryColor,
                    size: 40,
                  ),
                ),
              ),
              Expanded(
                child: FutureBuilder<OneSentence>(
                  future: OneSentenceApiService.getDailySentence(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text(
                        '加载失败: ${snapshot.error}',
                        style: TextStyle(color: primaryColor),
                      );
                    } else {
                      final sentence = snapshot.data!;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            sentence.content,
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "—— ${sentence.origin}",
                            style: TextStyle(
                              color: primaryColor.withOpacity(0.8),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

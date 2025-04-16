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
                      SizedBox(height: 100),
                      // 卡片区域
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        child: _buildAIChatCard(primaryColor),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        child: _buildDailySentenceCard(primaryColor),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
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

  Widget _buildEmotionChartCard(Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.white.withOpacity(0.35),
          child: Container(
            constraints: const BoxConstraints(minHeight: 360, maxHeight: 400),
            child: FutureBuilder<List<EmotionRecord>>(
              future: EmotionApiService.getEmotionHistory(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildChartLoading(primaryColor);
                } else if (snapshot.hasError) {
                  print(snapshot.error);
                  return _buildChartError(primaryColor);
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          Icon(Icons.insights, color: primaryColor),
                          const SizedBox(width: 8),
                          Text(
                            '情绪趋势分析',
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // MODIFIED START: 添加滚动条容器
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: primaryColor.withOpacity(0.2),
                              width: 1.5,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _buildScrollableChart(
                            snapshot.data!,
                            primaryColor,
                          ),
                        ),
                      ),
                    ),
                    // MODIFIED END
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScrollableChart(
    List<EmotionRecord> records,
    Color primaryColor,
  ) {
    final ScrollController _scrollController = ScrollController();
    final chartWidth = records.isEmpty ? 0 : records.length * 60;

    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true, // 替代 isAlwaysShown（适用于新版本）
      thickness: 8,
      radius: const Radius.circular(4),
      // thumbColor: primaryColor.withOpacity(0.5), // 常态颜色
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            width: chartWidth.toDouble(),
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: _buildEmotionChart(records, primaryColor),
            ),
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
    return LineChart(
      LineChartData(
        lineBarsData: _createChartLines(records, primaryColor),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 0.2, // 修改5：Y轴间隔调整为0.2
              getTitlesWidget:
                  (value, meta) => Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Text(
                      value.toStringAsFixed(3), // 修改6：显示三位小数
                      style: TextStyle(color: primaryColor, fontSize: 10),
                    ),
                  ),
              reservedSize: 40,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: _calculateLabelInterval(
                records.length,
              ), // 修改7：使用新的间隔计算方法
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < records.length) {
                  final date = DateTime.fromMillisecondsSinceEpoch(
                    records[index].timestamp,
                  );
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}', // 修改8：优化日期格式
                      style: TextStyle(color: primaryColor, fontSize: 10),
                    ),
                  );
                }
                return const Text('');
              },
              reservedSize: 28,
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
                        '${_getMetricName(item.barIndex)}: ${item.y.toStringAsFixed(3)}', // 修改9：工具提示显示三位小数
                        TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }).toList(),
            fitInsideHorizontally: true,
            fitInsideVertically: true,
          ),
          touchSpotThreshold: 20, // 修改10：增大触摸区域
        ),
        minX: 0,
        maxX: (records.length - 1).toDouble(),
        minY: -1.0,
        maxY: 1.0, // 修改11：设置最大Y值为1.0
      ),
    );
  }

  // 辅助方法：获取指标名称
  String _getMetricName(int index) {
    switch (index) {
      case 0:
        return '愉悦度';
      case 1:
        return '激活度';
      case 2:
        return '强度';
      default:
        return '';
    }
  }

  double _calculateLabelInterval(int dataCount) {
    if (dataCount <= 10) return 1;
    if (dataCount <= 20) return 2;
    return dataCount / 10;
  }

  // 修改图表数据映射部分
  List<LineChartBarData> _createChartLines(
    List<EmotionRecord> records,
    Color primaryColor,
  ) {
    final sortedRecords = records.sortedBy((r) => r.timestamp);

    return [
      LineChartBarData(
        spots:
            sortedRecords
                .asMap()
                .entries
                .map(
                  (entry) => FlSpot(
                    entry.key.toDouble(), // 修改14：使用索引作为X坐标
                    entry.value.valence_score,
                  ),
                )
                .toList(),
        color: primaryColor,
        barWidth: 4, // 修改15：加粗线条宽度
        isCurved: true,
        dotData: FlDotData(show: false),
        shadow: Shadow(
          color: primaryColor.withOpacity(0.3),
          blurRadius: 12, // 修改16：增强阴影效果
          offset: const Offset(4, 4),
        ),
      ),
      LineChartBarData(
        spots:
            sortedRecords
                .asMap()
                .entries
                .map(
                  (entry) =>
                      FlSpot(entry.key.toDouble(), entry.value.dominance_score),
                )
                .toList(),
        color: primaryColor.withOpacity(0.7),
        barWidth: 3,
        isCurved: true,
        dotData: FlDotData(show: false),
      ),
      LineChartBarData(
        spots:
            sortedRecords
                .asMap()
                .entries
                .map(
                  (entry) =>
                      FlSpot(entry.key.toDouble(), entry.value.intensity_score),
                )
                .toList(),
        color: primaryColor.withOpacity(0.4),
        barWidth: 2,
        isCurved: true,
        dotData: FlDotData(show: false),
      ),
    ];
  }
  // double _calculateInterval(List<EmotionRecord> records) {
  //   if (records.isEmpty) return 1;

  //   // 将时间戳转换为DateTime对象
  //   final firstDate = DateTime.fromMillisecondsSinceEpoch(
  //     records.first.timestamp,
  //   );
  //   final lastDate = DateTime.fromMillisecondsSinceEpoch(
  //     records.last.timestamp,
  //   );

  //   final duration = lastDate.difference(firstDate);
  //   return duration.inDays > 7 ? 86400000 * 3 : 86400000;
  // }

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

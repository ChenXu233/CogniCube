import 'dart:math';
import 'package:flutter/material.dart';
import '../../utils/gradient_helper.dart';

class BallAnimationWidget extends StatefulWidget {
  const BallAnimationWidget({super.key});

  @override
  State<BallAnimationWidget> createState() => _BallAnimationWidgetState();
}

class _BallAnimationWidgetState extends State<BallAnimationWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late List<Ball> _balls;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // 初始化多个随机小球
    final screenSize = MediaQuery.of(context).size;
    _balls = List.generate(
      10,
      (index) => Ball(
        position: Offset(
          Random().nextDouble() * screenSize.width,
          Random().nextDouble() * screenSize.height,
        ),
        velocity: Offset(
          (Random().nextDouble() * 0.5 - 0.25), // 降低速度范围
          (Random().nextDouble() * 0.5 - 0.25),
        ),
        radius: Random().nextDouble() * 30 + 80,
        color: _generateSoftColor(),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Stack(
      children: [
        // 添加背景色层
        Container(color: const Color.fromARGB(255, 238, 209, 225)),
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, _) {
            return CustomPaint(
              painter: BallPainter(
                _balls,
                _animationController.value,
                screenSize,
              ),
              child: Container(),
            );
          },
        ),
      ],
    );
  }

  // 生成柔和的颜色
  Color _generateSoftColor() {
    final baseColors = [
      Colors.pink,
      const Color.fromARGB(255, 255, 67, 76),
      const Color.fromARGB(255, 225, 236, 125),
      Colors.orange,
      Colors.purple,
    ];
    return baseColors[Random().nextInt(baseColors.length)];
  }
}

// 定义小球类
class Ball {
  Offset position;
  Offset velocity;
  double radius;
  Color color;

  Ball({
    required this.position,
    required this.velocity,
    required this.radius,
    required this.color,
  });

  void move(Size screenSize, List<Ball> balls) {
    position += velocity;

    // 碰撞检测并反弹（屏幕边界）
    if (position.dx - radius < 0 || position.dx + radius > screenSize.width) {
      velocity = Offset(-velocity.dx, velocity.dy);
    }
    if (position.dy - radius < 0 || position.dy + radius > screenSize.height) {
      velocity = Offset(velocity.dx, -velocity.dy);
    }

    // // 检测与其他小球的碰撞
    // for (var other in balls) {
    //   if (other == this) continue;

    //   final distance = (position - other.position).distance;
    //   if (distance < radius + other.radius) {
    //     // 计算碰撞后的速度方向
    //     final normal = (position - other.position) / distance;
    //     final relativeVelocity = velocity - other.velocity;
    //     final speed = relativeVelocity.dot(normal);

    //     if (speed < 0) {
    //       velocity -= normal * speed;
    //       other.velocity += normal * speed;
    //     }
    //   }
    // }
  }
}

extension on Offset {
  double dot(Offset other) => dx * other.dx + dy * other.dy;
}

// 自定义画布绘制小球
class BallPainter extends CustomPainter {
  final List<Ball> balls;
  final double animationValue;
  final Size screenSize;

  BallPainter(this.balls, this.animationValue, this.screenSize);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    for (var ball in balls) {
      ball.move(size, balls); // 更新小球位置并处理碰撞

      // 使用渐变着色器填充小球，恢复虚化效果
      paint.shader = RadialGradient(
        center: const Alignment(0, 0),
        radius: 0.8,
        colors: [
          ball.color.withOpacity(0.8), // 中心颜色，带透明度
          ball.color.withOpacity(0.0), // 边缘颜色，完全透明
        ],
      ).createShader(
        Rect.fromCircle(center: ball.position, radius: ball.radius),
      );

      canvas.drawCircle(ball.position, ball.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

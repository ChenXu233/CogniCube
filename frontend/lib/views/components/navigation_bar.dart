import 'package:flutter/material.dart';
import 'dart:ui' as ui;

Widget buildStaticBlurNavigationBar(
  BuildContext context,
  int currentIndex,
  Function(int) onTap,
) {
  return ClipRect(
    child: BackdropFilter(
      filter: ui.ImageFilter.blur(sigmaX: 15, sigmaY: 15),
      child: Container(
        height:
            kBottomNavigationBarHeight + MediaQuery.of(context).padding.bottom,
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.3)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [            
            buildNavItem(Icons.apps, 0, currentIndex, onTap),
            buildNavItem(Icons.chat, 1, currentIndex, onTap),
            buildNavItem(Icons.insert_chart, 2, currentIndex, onTap),
            buildNavItem(Icons.person, 3, currentIndex, onTap),
          ],
        ),
      ),
    ),
  );
}

Widget buildNavItem(
  IconData icon,
  int index,
  int currentIndex,
  Function(int) onTap,
) {
  final isActive = currentIndex == index;
  return GestureDetector(
    onTap: () => onTap(index),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isActive ? Colors.white.withOpacity(0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        icon,
        color: isActive ? Colors.black : Colors.black87,
        size: 28,
      ),
    ),
  );
}

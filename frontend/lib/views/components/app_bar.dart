import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:ui' as ui;

Widget buildStaticBlurAppBar(
  BuildContext context,
  PageController pageController,
) {
  return ClipRect(
    child: BackdropFilter(
      filter: ui.ImageFilter.blur(sigmaX: 15, sigmaY: 15),
      child: Container(
        height: kToolbarHeight + MediaQuery.of(context).padding.top,
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        decoration: BoxDecoration(color: Colors.transparent),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.person, color: Colors.black),
              onPressed: () => context.push('/profile'),
            ),
            const Expanded(child: Center()),
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.black),
              onPressed: () => context.push('/setting'),
            ),
          ],
        ),
      ),
    ),
  );
}

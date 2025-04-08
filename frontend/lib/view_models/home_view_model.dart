import 'package:flutter/material.dart';

class HomeViewModel with ChangeNotifier {
  late final PageController _pageController;
  int _currentIndex = 0;

  HomeViewModel() {
    _pageController = PageController(initialPage: _currentIndex)
      ..addListener(_handlePageScroll);
  }

  PageController get pageController => _pageController;
  int get currentIndex => _currentIndex;

  void navigateToPage(int index) {
    if (_currentIndex == index) return;
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _handlePageScroll() {
    final newIndex = _pageController.page?.round() ?? _currentIndex;
    if (newIndex != _currentIndex) {
      _currentIndex = newIndex;
      notifyListeners(); // 触发UI更新
    }
  }

  void resetToHome() {
    if (_currentIndex == 0) return;
    _currentIndex = 0;
    _pageController.jumpToPage(0);
    notifyListeners();
  }

  @override
  void dispose() {
    _pageController
      ..removeListener(_handlePageScroll)
      ..dispose(); // 关键内存管理
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeViewModel with ChangeNotifier {
  late final PageController _pageController;
  int _currentIndex = 0; // CBT 为初始界面
  final SharedPreferences prefs;

  HomeViewModel({required this.prefs}) {
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

  void updateIsAdmin(bool b) {
    prefs.setBool('isAdmin', b);
    notifyListeners();
  }

  void navigateToCBT() => navigateToPage(1);

  void _handlePageScroll() {
    final newIndex = _pageController.page?.round() ?? _currentIndex;
    if (newIndex != _currentIndex) {
      _currentIndex = newIndex;
      notifyListeners();
    }
  }

  void resetToHome() {
    if (_currentIndex == 1) return;
    _currentIndex = 1;
    _pageController.jumpToPage(1);
    notifyListeners();
  }

  @override
  void dispose() {
    _pageController
      ..removeListener(_handlePageScroll)
      ..dispose();
    super.dispose();
  }
}

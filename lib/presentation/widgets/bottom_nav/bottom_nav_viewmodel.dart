import 'package:flutter/material.dart';

enum BottomNavTab { home, templates, myCvs, profile }

class BottomNavViewModel extends ChangeNotifier {
  BottomNavTab _currentTab = BottomNavTab.home;

  BottomNavTab get currentTab => _currentTab;

  void setTab(BottomNavTab tab) {
    if (_currentTab == tab) return;
    _currentTab = tab;
    notifyListeners();
  }

  String getTitleForTab(BottomNavTab tab) {
    switch (tab) {
      case BottomNavTab.home:
        return 'Home';
      case BottomNavTab.templates:
        return 'Templates';
      case BottomNavTab.myCvs:
        return 'My CVs';
      case BottomNavTab.profile:
        return 'Profile';
    }
  }

  IconData getIconForTab(BottomNavTab tab, bool isSelected) {
    switch (tab) {
      case BottomNavTab.home:
        return isSelected ? Icons.home : Icons.home_outlined;
      case BottomNavTab.templates:
        return isSelected ? Icons.grid_view : Icons.grid_view_outlined;
      case BottomNavTab.myCvs:
        return isSelected ? Icons.description : Icons.description_outlined;
      case BottomNavTab.profile:
        return isSelected ? Icons.person : Icons.person_outline;
    }
  }
}

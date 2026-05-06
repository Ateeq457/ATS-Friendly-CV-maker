import 'package:flutter/material.dart';

class RefreshService extends ChangeNotifier {
  static final RefreshService _instance = RefreshService._internal();
  factory RefreshService() => _instance;
  RefreshService._internal();

  void refreshCVs() {
    notifyListeners();
    debugPrint('🔄 RefreshService: CV list refresh triggered');
  }
}

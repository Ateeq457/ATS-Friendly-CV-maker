import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cv_data.dart';

class CVStorage {
  static const String _cvKey = 'cv_data';

  Future<void> saveCVData(CVData cvData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = jsonEncode(cvData.toJson());
      await prefs.setString(_cvKey, jsonString);
      debugPrint('CV data saved successfully');
    } catch (e) {
      debugPrint('Error saving CV data: $e');
      rethrow;
    }
  }

  Future<CVData?> loadCVData(String? id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_cvKey);
      if (jsonString == null) {
        debugPrint('No CV data found');
        return null;
      }
      return CVData.fromJson(jsonDecode(jsonString));
    } catch (e) {
      debugPrint('Error loading CV data: $e');
      return null;
    }
  }

  // ✅ ADDED: Clear CV data
  Future<void> clearCVData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_cvKey);
      debugPrint('CV data cleared successfully');
    } catch (e) {
      debugPrint('Error clearing CV data: $e');
      rethrow;
    }
  }
}

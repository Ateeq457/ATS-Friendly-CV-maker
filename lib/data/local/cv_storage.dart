import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cv_data.dart';

class CVStorage {
  static const String _cvKey = 'cv_data';

  Future<void> saveCVData(CVData cvData) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(cvData.toJson());
    await prefs.setString(_cvKey, jsonString);
  }

  Future<CVData?> loadCVData(String? id) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_cvKey);
    if (jsonString == null) return null;
    return CVData.fromJson(jsonDecode(jsonString));
  }
}

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cv_data_model.dart';

class CVStorage {
  static const String _key = 'cv_data';

  Future<void> saveCVData(CVDataModel cvData) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(cvData.toJson());
    await prefs.setString(_key, jsonString);
  }

  Future<CVDataModel?> loadCVData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) return null;
    final Map<String, dynamic> json = jsonDecode(jsonString);
    return CVDataModel.fromJson(json);
  }

  Future<void> clearCVData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}

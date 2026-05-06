// File: lib/data/local/cv_storage.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cv_data.dart';

class CVStorage {
  // ─────────────────────────────────────────────
  // Key helpers
  // ─────────────────────────────────────────────

  /// Key for a CVModel (the list card metadata)
  static String _modelKey(String id) => 'cv_$id';

  /// Key for CVData (the full form content)
  static String _dataKey(String id) => 'cv_data_$id';

  // ─────────────────────────────────────────────
  // CVModel (list card) — save / load / delete
  // ─────────────────────────────────────────────

  /// Save CVModel metadata (title, status, progress, lastEdited)
  Future<void> saveCV(CVModel cv) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_modelKey(cv.id), jsonEncode(cv.toJson()));
      debugPrint('✅ CVModel saved: ${cv.title} [${cv.id}]');
    } catch (e) {
      debugPrint('❌ saveCV error: $e');
      rethrow;
    }
  }

  /// ✅ Get a single CV by ID
  Future<CVModel?> getCV(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_modelKey(id));
      if (jsonString == null) {
        debugPrint('ℹ️ No CV found for id: $id');
        return null;
      }
      debugPrint('✅ CV loaded: $id');
      return CVModel.fromJson(jsonDecode(jsonString));
    } catch (e) {
      debugPrint('❌ getCV error: $e');
      return null;
    }
  }

  /// ✅ Get a single CV by ID (alias for getCV)
  Future<CVModel?> loadCV(String id) async {
    return getCV(id);
  }

  Future<void> printAllKeys() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      debugPrint('📦 All SharedPreferences keys:');
      for (final key in keys) {
        debugPrint('   - $key');
      }
    } catch (e) {
      debugPrint('Error printing keys: $e');
    }
  }

  /// Delete CVModel + its CVData in one call
  Future<void> deleteCV(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_modelKey(id)); // cv_${id}
      await prefs.remove(_dataKey(id)); // cv_data_${id}
      debugPrint('✅ CV fully deleted: $id');
    } catch (e) {
      debugPrint('❌ deleteCV error: $e');
      rethrow;
    }
  }

  /// Get all CVModels sorted by lastEdited desc
  Future<List<CVModel>> getAllCVs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      final List<CVModel> cvs = [];

      for (final key in keys) {
        // ✅ Only read CVModel keys (cv_xxx), not CVData keys (cv_data_xxx)
        if (RegExp(r'^cv_\d+$').hasMatch(key)) {
          final jsonString = prefs.getString(key);
          if (jsonString != null) {
            try {
              cvs.add(CVModel.fromJson(jsonDecode(jsonString)));
            } catch (e) {
              debugPrint('⚠️ Skipping corrupted CV [$key]: $e');
            }
          }
        }
      }

      cvs.sort((a, b) => b.lastEdited.compareTo(a.lastEdited));
      debugPrint('✅ getAllCVs: ${cvs.length} CVs loaded');
      return cvs;
    } catch (e) {
      debugPrint('❌ getAllCVs error: $e');
      return [];
    }
  }

  // ─────────────────────────────────────────────
  // CVData (full form content) — save / load
  // ─────────────────────────────────────────────

  /// Save full CVData content keyed by CV id
  Future<void> saveCVData(CVData cvData, String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_dataKey(id), jsonEncode(cvData.toJson()));
      debugPrint('✅ CVData saved: $id');
    } catch (e) {
      debugPrint('❌ saveCVData error: $e');
      rethrow;
    }
  }

  /// Load CVData for a specific CV id
  Future<CVData?> loadCVData(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_dataKey(id));
      if (jsonString == null) {
        debugPrint('ℹ️ No CVData found for id: $id');
        return null;
      }
      debugPrint('✅ CVData loaded: $id');
      return CVData.fromJson(jsonDecode(jsonString));
    } catch (e) {
      debugPrint('❌ loadCVData error: $e');
      return null;
    }
  }

  // ─────────────────────────────────────────────
  // One-time migration (run once on app start)
  // Clears the old broken 'cv_data' ghost key
  // ─────────────────────────────────────────────

  Future<void> migrateOldData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey('cv_data')) {
        await prefs.remove('cv_data');
        debugPrint('✅ Migrated: removed old cv_data ghost key');
      }
    } catch (e) {
      debugPrint('⚠️ Migration error (non-fatal): $e');
    }
  }
}

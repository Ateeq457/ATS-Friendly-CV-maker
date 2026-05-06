// File: lib/providers/cv_form_provider.dart

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/cv_data.dart';
import '../data/local/cv_storage.dart';

class CVFormProvider extends ChangeNotifier {
  final CVStorage _storage = CVStorage();

  // Configuration
  static const double READY_THRESHOLD = 0.85; // 85% = Ready to submit
  static const double IN_PROGRESS_THRESHOLD = 0.40; // 40% = In Progress

  // Core data
  CVData _cvData = CVData.empty();

  // State flags
  bool _isLoading = false;
  bool _isDirty = false;
  bool _isUserMarkedComplete = false; // ✅ Track user's explicit completion
  Timer? _autoSaveTimer;
  String? _currentCVId;

  // Getters
  CVData get cvData => _cvData;
  bool get isLoading => _isLoading;
  bool get isDirty => _isDirty;
  bool get isUserMarkedComplete => _isUserMarkedComplete;

  // ============ LOAD METHODS ============

  Future<void> loadCV(String? id) async {
    if (id == null) return;
    _currentCVId = id;
    _isLoading = true;
    notifyListeners();

    try {
      // Load CVData
      final loaded = await _storage.loadCVData(id);
      if (loaded != null) {
        _cvData = loaded;
        _isDirty = false;
        debugPrint('✅ CV loaded: $id');
      }

      // Load user's completion preference
      final cvModel = await _storage.getCV(id);
      if (cvModel != null) {
        _isUserMarkedComplete = cvModel.isUserCompleted ?? false;
        debugPrint('📌 User marked complete: $_isUserMarkedComplete');
      }
    } catch (e) {
      debugPrint('Error loading CV: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ============ FIELD UPDATES ============

  void updateField(String field, String value) {
    switch (field) {
      case 'fullName':
        _cvData.fullName = value;
        break;
      case 'title':
        _cvData.title = value;
        break;
      case 'email':
        _cvData.email = value;
        break;
      case 'phone':
        _cvData.phone = value;
        break;
      case 'location':
        _cvData.location = value;
        break;
      case 'summary':
        _cvData.summary = value;
        break;
      case 'linkedin':
        _cvData.linkedin = value;
        break;
      case 'github':
        _cvData.github = value;
        break;
    }

    // ✅ When user edits, reset the completed flag (if it was auto-set)
    if (_isUserMarkedComplete && _currentCVId != null) {
      _isUserMarkedComplete = false;
      debugPrint('🔄 Reset completed flag due to edits');
    }

    _markDirty();
    notifyListeners();
    _scheduleAutoSave();
  }

  // ============ BATCH UPDATES ============

  void updateExperiences(List<Experience> experiences) {
    _cvData.experiences = experiences;
    if (_isUserMarkedComplete) _isUserMarkedComplete = false;
    _markDirty();
    notifyListeners();
    _scheduleAutoSave();
  }

  void updateEducations(List<Education> educations) {
    _cvData.educations = educations;
    if (_isUserMarkedComplete) _isUserMarkedComplete = false;
    _markDirty();
    notifyListeners();
    _scheduleAutoSave();
  }

  void updateSkills(List<String> skills) {
    _cvData.skills = skills;
    if (_isUserMarkedComplete) _isUserMarkedComplete = false;
    _markDirty();
    notifyListeners();
    _scheduleAutoSave();
  }

  void updateLanguages(List<Language> languages) {
    _cvData.languages = languages;
    _markDirty();
    notifyListeners();
    _scheduleAutoSave();
  }

  void updateCertifications(List<Certification> certifications) {
    _cvData.certifications = certifications;
    _markDirty();
    notifyListeners();
    _scheduleAutoSave();
  }

  void updateProjects(List<Project> projects) {
    _cvData.projects = projects;
    _markDirty();
    notifyListeners();
    _scheduleAutoSave();
  }

  void updateSocialLinks(List<SocialLinkModel> socialLinks) {
    _cvData.socialLinks = socialLinks;
    _markDirty();
    notifyListeners();
    _scheduleAutoSave();
  }

  void updateCustomSections(List<CustomSectionModel> customSections) {
    _cvData.customSections = customSections;
    _markDirty();
    notifyListeners();
    _scheduleAutoSave();
  }

  // ============ INDIVIDUAL ITEM OPERATIONS ============

  void addExperience(Experience exp) {
    _cvData.experiences.add(exp);
    if (_isUserMarkedComplete) _isUserMarkedComplete = false;
    _markDirty();
    notifyListeners();
    _scheduleAutoSave();
  }

  void updateExperience(int index, Experience exp) {
    _cvData.experiences[index] = exp;
    if (_isUserMarkedComplete) _isUserMarkedComplete = false;
    _markDirty();
    notifyListeners();
    _scheduleAutoSave();
  }

  void removeExperience(int index) {
    _cvData.experiences.removeAt(index);
    if (_isUserMarkedComplete) _isUserMarkedComplete = false;
    _markDirty();
    notifyListeners();
    _scheduleAutoSave();
  }

  void addEducation(Education edu) {
    _cvData.educations.add(edu);
    if (_isUserMarkedComplete) _isUserMarkedComplete = false;
    _markDirty();
    notifyListeners();
    _scheduleAutoSave();
  }

  void updateEducation(int index, Education edu) {
    _cvData.educations[index] = edu;
    if (_isUserMarkedComplete) _isUserMarkedComplete = false;
    _markDirty();
    notifyListeners();
    _scheduleAutoSave();
  }

  void removeEducation(int index) {
    _cvData.educations.removeAt(index);
    if (_isUserMarkedComplete) _isUserMarkedComplete = false;
    _markDirty();
    notifyListeners();
    _scheduleAutoSave();
  }

  void addSkill(String skill) {
    if (skill.trim().isEmpty) return;
    if (!_cvData.skills.contains(skill.trim())) {
      _cvData.skills.add(skill.trim());
      if (_isUserMarkedComplete) _isUserMarkedComplete = false;
      _markDirty();
      notifyListeners();
      _scheduleAutoSave();
    }
  }

  void removeSkill(String skill) {
    _cvData.skills.remove(skill);
    if (_isUserMarkedComplete) _isUserMarkedComplete = false;
    _markDirty();
    notifyListeners();
    _scheduleAutoSave();
  }

  void addLanguage(Language lang) {
    _cvData.languages.add(lang);
    _markDirty();
    notifyListeners();
    _scheduleAutoSave();
  }

  void updateLanguage(int index, Language lang) {
    _cvData.languages[index] = lang;
    _markDirty();
    notifyListeners();
    _scheduleAutoSave();
  }

  void removeLanguage(int index) {
    _cvData.languages.removeAt(index);
    _markDirty();
    notifyListeners();
    _scheduleAutoSave();
  }

  void addCertification(Certification cert) {
    _cvData.certifications.add(cert);
    _markDirty();
    notifyListeners();
    _scheduleAutoSave();
  }

  void updateCertification(int index, Certification cert) {
    _cvData.certifications[index] = cert;
    _markDirty();
    notifyListeners();
    _scheduleAutoSave();
  }

  void removeCertification(int index) {
    _cvData.certifications.removeAt(index);
    _markDirty();
    notifyListeners();
    _scheduleAutoSave();
  }

  void addProject(Project proj) {
    _cvData.projects.add(proj);
    _markDirty();
    notifyListeners();
    _scheduleAutoSave();
  }

  void updateProject(int index, Project proj) {
    _cvData.projects[index] = proj;
    _markDirty();
    notifyListeners();
    _scheduleAutoSave();
  }

  void removeProject(int index) {
    _cvData.projects.removeAt(index);
    _markDirty();
    notifyListeners();
    _scheduleAutoSave();
  }

  void addSocialLink(SocialLinkModel link) {
    _cvData.socialLinks.add(link);
    _markDirty();
    notifyListeners();
    _scheduleAutoSave();
  }

  void updateSocialLink(int index, SocialLinkModel link) {
    _cvData.socialLinks[index] = link;
    _markDirty();
    notifyListeners();
    _scheduleAutoSave();
  }

  void removeSocialLink(int index) {
    _cvData.socialLinks.removeAt(index);
    _markDirty();
    notifyListeners();
    _scheduleAutoSave();
  }

  void addCustomSection(CustomSectionModel section) {
    _cvData.customSections.add(section);
    _markDirty();
    notifyListeners();
    _scheduleAutoSave();
  }

  void removeCustomSection(int index) {
    _cvData.customSections.removeAt(index);
    _markDirty();
    notifyListeners();
    _scheduleAutoSave();
  }

  void updateCustomSectionTitle(int index, String title) {
    _cvData.customSections[index].title = title;
    _markDirty();
    notifyListeners();
    _scheduleAutoSave();
  }

  void addCustomSectionEntry(int sectionIndex) {
    _cvData.customSections[sectionIndex].entries.add(
      CustomSectionEntry.empty(),
    );
    _markDirty();
    notifyListeners();
    _scheduleAutoSave();
  }

  void updateCustomSectionEntry(
    int sectionIndex,
    int entryIndex,
    String title,
    String description,
    String? date,
  ) {
    final entry = _cvData.customSections[sectionIndex].entries[entryIndex];
    entry.title = title;
    entry.description = description;
    entry.date = date;
    _markDirty();
    notifyListeners();
    _scheduleAutoSave();
  }

  void removeCustomSectionEntry(int sectionIndex, int entryIndex) {
    _cvData.customSections[sectionIndex].entries.removeAt(entryIndex);
    _markDirty();
    notifyListeners();
    _scheduleAutoSave();
  }

  // ============ AUTO-SAVE METHODS ============

  void _markDirty() {
    if (!_isDirty) {
      _isDirty = true;
    }
  }

  void _scheduleAutoSave() {
    _autoSaveTimer?.cancel();
    if (_isDirty) {
      _autoSaveTimer = Timer(const Duration(seconds: 2), () async {
        await _autoSave();
      });
    }
  }

  /// ✅ AUTO-SAVE: Only saves CVData, NEVER creates/updates CVModel
  Future<void> _autoSave() async {
    if (!_isDirty) return;

    try {
      final id =
          _currentCVId ?? DateTime.now().millisecondsSinceEpoch.toString();

      // ✅ ONLY save CVData, NOT CVModel
      await _storage.saveCVData(_cvData, id);
      _currentCVId = id;

      debugPrint(
        '🔄 Auto-saved CVData only (not in list | status unchanged): $id',
      );
    } catch (e) {
      debugPrint('❌ Auto-save error: $e');
    }
  }

  // ============ PROGRESS & STATUS METHODS ============

  /// ✅ Calculates real progress based on minimum required fields
  double calculateProgress() {
    final checks = <bool>[
      _cvData.fullName.trim().isNotEmpty,
      _cvData.email.trim().isNotEmpty,
      _cvData.phone.trim().isNotEmpty,
      _cvData.summary.trim().isNotEmpty,
      _cvData.educations.isNotEmpty,
      _cvData.skills.length >= 3, // ✅ Skills required (min 3)
    ];

    final filled = checks.where((e) => e).length;
    return filled / checks.length;
  }

  /// ✅ Returns display status based on progress and user preference
  String getDisplayStatus() {
    final progress = calculateProgress();

    // User explicitly marked as complete
    if (_isUserMarkedComplete) return "✓ Completed";

    // Auto-suggested status based on data
    if (progress >= READY_THRESHOLD) return "🎯 Ready to Submit";
    if (progress >= IN_PROGRESS_THRESHOLD) return "📝 In Progress";
    return "✏️ Draft";
  }

  /// ✅ Returns color for status display
  Color getStatusColor() {
    if (_isUserMarkedComplete) return Colors.green;

    final progress = calculateProgress();
    if (progress >= READY_THRESHOLD) return Colors.teal;
    if (progress >= IN_PROGRESS_THRESHOLD) return Colors.orange;
    return Colors.grey;
  }

  /// ✅ Checks if data meets minimum requirements
  ValidationResult validateData() {
    final errors = <String>[];
    final warnings = <String>[];

    // Required fields (cause errors)
    if (_cvData.fullName.trim().isEmpty) {
      errors.add('Full Name is required');
    }

    if (_cvData.email.trim().isEmpty) {
      errors.add('Email is required');
    } else if (!_isValidEmail(_cvData.email.trim())) {
      errors.add('Please enter a valid email address');
    }

    if (_cvData.phone.trim().isEmpty) {
      errors.add('Phone number is required');
    }

    if (_cvData.summary.trim().isEmpty) {
      errors.add('Professional Summary is required');
    } else if (_cvData.summary.trim().length < 50) {
      warnings.add('Professional Summary is too short (min 50 characters)');
    }

    if (_cvData.educations.isEmpty) {
      errors.add('Education is required — add your highest degree');
    }

    if (_cvData.skills.isEmpty) {
      errors.add('Skills are required (minimum 3)');
    } else if (_cvData.skills.length < 3) {
      errors.add('Add ${3 - _cvData.skills.length} more skill(s)');
    }

    // Optional but recommended (only warnings)
    if (_cvData.experiences.isEmpty) {
      warnings.add('Add work experience to strengthen your CV');
    }

    if (_cvData.projects.isEmpty) {
      warnings.add('Add projects to showcase your work');
    }

    return ValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
      warnings: warnings,
    );
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  // ============ MANUAL SAVE METHODS ============

  /// ✅ Save as Draft - Always saves as DRAFT regardless of data
  Future<bool> saveAsDraft() async {
    try {
      final id =
          _currentCVId ?? DateTime.now().millisecondsSinceEpoch.toString();

      final cvModel = CVModel(
        id: id,
        title: _cvData.fullName.isNotEmpty ? _cvData.fullName : 'Untitled CV',
        status: 'draft',
        progress: calculateProgress(),
        lastEdited: DateTime.now(),
        data: _cvData.toJson(),
        isUserCompleted: false, // ✅ User didn't mark as complete
        completedAt: null,
      );

      await _storage.saveCV(cvModel);
      await _storage.saveCVData(_cvData, id);

      _currentCVId = id;
      _isDirty = false;
      _isUserMarkedComplete = false;

      debugPrint('✅ Saved as DRAFT: ${cvModel.title}');
      return true;
    } catch (e) {
      debugPrint('❌ Error saving draft: $e');
      return false;
    }
  }

  /// ✅ Mark as Completed - User explicitly marks as complete
  Future<bool> markAsCompleted() async {
    try {
      final id =
          _currentCVId ?? DateTime.now().millisecondsSinceEpoch.toString();

      final cvModel = CVModel(
        id: id,
        title: _cvData.fullName.isNotEmpty ? _cvData.fullName : 'Untitled CV',
        status: 'completed',
        progress: calculateProgress(),
        lastEdited: DateTime.now(),
        data: _cvData.toJson(),
        isUserCompleted: true, // ✅ User explicitly marked
        completedAt: DateTime.now(),
      );

      await _storage.saveCV(cvModel);
      await _storage.saveCVData(_cvData, id);

      _currentCVId = id;
      _isDirty = false;
      _isUserMarkedComplete = true;

      debugPrint('✅ Marked as COMPLETED: ${cvModel.title}');
      return true;
    } catch (e) {
      debugPrint('❌ Error marking as completed: $e');
      return false;
    }
  }

  /// ✅ Force save (used by preview/exit) - Saves as auto-detected status
  Future<bool> forceSave() async {
    if (!_isDirty) return true;

    try {
      final id =
          _currentCVId ?? DateTime.now().millisecondsSinceEpoch.toString();

      final cvModel = CVModel(
        id: id,
        title: _cvData.fullName.isNotEmpty ? _cvData.fullName : 'Untitled CV',
        status: _isUserMarkedComplete ? 'completed' : 'draft',
        progress: calculateProgress(),
        lastEdited: DateTime.now(),
        data: _cvData.toJson(),
        isUserCompleted: _isUserMarkedComplete,
        completedAt: _isUserMarkedComplete ? DateTime.now() : null,
      );

      await _storage.saveCV(cvModel);
      await _storage.saveCVData(_cvData, id);

      _currentCVId = id;
      _isDirty = false;

      debugPrint('✅ Force saved: ${cvModel.title} (${cvModel.status})');
      return true;
    } catch (e) {
      debugPrint('❌ Error force saving: $e');
      return false;
    }
  }

  // ============ DISCARD / CANCEL METHODS ============

  void cancelAutoSave() {
    _autoSaveTimer?.cancel();
    _autoSaveTimer = null;
  }

  void resetDirtyState() {
    _isDirty = false;
  }

  Future<void> revertToLastSaved() async {
    if (_currentCVId == null) {
      _cvData = CVData.empty();
      _isUserMarkedComplete = false;
      _isDirty = false;
      notifyListeners();
      debugPrint('🗑️ Discarded new CV (no saved version)');
      return;
    }

    try {
      final savedData = await _storage.loadCVData(_currentCVId!);
      if (savedData != null) {
        _cvData = savedData;

        // Also reload completion status
        final cvModel = await _storage.getCV(_currentCVId!);
        _isUserMarkedComplete = cvModel?.isUserCompleted ?? false;

        _isDirty = false;
        notifyListeners();
        debugPrint('🗑️ Discarded changes, reverted to last saved version');
      } else {
        _cvData = CVData.empty();
        _isUserMarkedComplete = false;
        _isDirty = false;
        notifyListeners();
        debugPrint('🗑️ Discarded changes (no saved version found)');
      }
    } catch (e) {
      debugPrint('Error reverting CV: $e');
      _cvData = CVData.empty();
      _isUserMarkedComplete = false;
      _isDirty = false;
      notifyListeners();
    }
  }

  // ============ DUMMY DATA ============

  void fillDummyData() {
    _cvData = CVData.sample();
    _currentCVId = null;
    _isUserMarkedComplete = false;
    _isDirty = true;
    notifyListeners();
    _scheduleAutoSave();
    debugPrint('✅ Dummy data filled (Draft mode)');
  }

  // ============ DISPOSE ============

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    super.dispose();
  }
}

// Helper class for validation results
class ValidationResult {
  final bool isValid;
  final List<String> errors;
  final List<String> warnings;

  ValidationResult({
    required this.isValid,
    required this.errors,
    required this.warnings,
  });
}

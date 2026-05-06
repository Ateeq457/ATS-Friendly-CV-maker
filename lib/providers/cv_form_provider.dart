// File: lib/providers/cv_form_provider.dart

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/models/cv_data.dart';
import '../data/local/cv_storage.dart';

class CVFormProvider extends ChangeNotifier {
  final CVStorage _storage = CVStorage();

  // Core data
  CVData _cvData = CVData.empty();

  // State flags
  bool _isLoading = false;
  bool _isDirty = false;
  Timer? _autoSaveTimer;
  String? _currentCVId;

  // Getters
  CVData get cvData => _cvData;
  bool get isLoading => _isLoading;
  bool get isDirty => _isDirty;

  // ============ LOAD METHODS ============

  Future<void> loadCV(String? id) async {
    if (id == null) return;
    _currentCVId = id;
    _isLoading = true;
    notifyListeners();

    try {
      final loaded = await _storage.loadCVData(id);
      if (loaded != null) {
        _cvData = loaded;
        _isDirty = false;
        debugPrint('✅ CV loaded: $id');
      } else {
        debugPrint('⚠️ No CVData found for id: $id');
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

    _markDirty();
    notifyListeners();
    _scheduleAutoSave();
  }

  // ============ BATCH UPDATES ============

  void updateExperiences(List<Experience> experiences) {
    _cvData.experiences = experiences;
    _markDirty();
    notifyListeners();
    _scheduleAutoSave();
  }

  void updateEducations(List<Education> educations) {
    _cvData.educations = educations;
    _markDirty();
    notifyListeners();
    _scheduleAutoSave();
  }

  void updateSkills(List<String> skills) {
    _cvData.skills = skills;
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
    _markDirty();
    notifyListeners();
    _scheduleAutoSave();
  }

  void updateExperience(int index, Experience exp) {
    _cvData.experiences[index] = exp;
    _markDirty();
    notifyListeners();
    _scheduleAutoSave();
  }

  void removeExperience(int index) {
    _cvData.experiences.removeAt(index);
    _markDirty();
    notifyListeners();
    _scheduleAutoSave();
  }

  void addEducation(Education edu) {
    _cvData.educations.add(edu);
    _markDirty();
    notifyListeners();
    _scheduleAutoSave();
  }

  void updateEducation(int index, Education edu) {
    _cvData.educations[index] = edu;
    _markDirty();
    notifyListeners();
    _scheduleAutoSave();
  }

  void removeEducation(int index) {
    _cvData.educations.removeAt(index);
    _markDirty();
    notifyListeners();
    _scheduleAutoSave();
  }

  void addSkill(String skill) {
    if (skill.trim().isEmpty) return;
    if (!_cvData.skills.contains(skill.trim())) {
      _cvData.skills.add(skill.trim());
      _markDirty();
      notifyListeners();
      _scheduleAutoSave();
    }
  }

  void removeSkill(String skill) {
    _cvData.skills.remove(skill);
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

  // ============ CV STATUS METHODS ============

  Future<void> _autoSave() async {
    if (!_isDirty) return;

    try {
      final id =
          _currentCVId ?? DateTime.now().millisecondsSinceEpoch.toString();
      await _storage.saveCVData(_cvData, id);
      _currentCVId = id;
      debugPrint('🔄 Auto-saved CVData only (not in list): $id');
    } catch (e) {
      debugPrint('❌ Auto-save error: $e');
    }
  }

  // ============ CV STATUS METHODS ============
  // ✅ ADD THESE METHODS HERE

  bool _isCVComplete() {
    final data = _cvData;

    if (data.fullName.trim().isEmpty) return false;
    if (data.email.trim().isEmpty) return false;
    if (data.phone.trim().isEmpty) return false;
    if (data.summary.trim().isEmpty) return false;

    if (data.experiences.isEmpty) return false;
    if (data.educations.isEmpty) return false;
    if (data.skills.length < 3) return false;

    return true;
  }

  String _getCVStatus() {
    return _isCVComplete() ? 'completed' : 'draft';
  }

  // ============ MANUAL SAVE (Creates CVModel for list) ============

  Future<bool> saveDraft() async {
    try {
      final id =
          _currentCVId ?? DateTime.now().millisecondsSinceEpoch.toString();

      final cvModel = CVModel(
        id: id,
        title: _cvData.fullName.isNotEmpty ? _cvData.fullName : 'Untitled CV',
        status: _getCVStatus(), // ✅ Dynamic status (draft/completed)
        progress: calculateProgress(),
        lastEdited: DateTime.now(),
        data: _cvData.toJson(),
      );

      await _storage.saveCV(cvModel);
      await _storage.saveCVData(_cvData, id);

      _currentCVId = id;
      _isDirty = false;

      debugPrint('✅ Draft saved: ${cvModel.title} (Status: ${cvModel.status})');
      return true;
    } catch (e) {
      debugPrint('❌ Error saving draft: $e');
      return false;
    }
  }

  Future<void> forceSave() async {
    if (!_isDirty) return;

    try {
      final id =
          _currentCVId ?? DateTime.now().millisecondsSinceEpoch.toString();

      final cvModel = CVModel(
        id: id,
        title: _cvData.fullName.isNotEmpty ? _cvData.fullName : 'Untitled CV',
        status: _getCVStatus(), // ✅ Dynamic status
        progress: calculateProgress(),
        lastEdited: DateTime.now(),
        data: _cvData.toJson(),
      );

      await _storage.saveCV(cvModel);
      await _storage.saveCVData(_cvData, id);

      _currentCVId = id;
      _isDirty = false;
      debugPrint('✅ Force saved: ${cvModel.title} (Status: ${cvModel.status})');
    } catch (e) {
      debugPrint('❌ Error saving CV: $e');
      rethrow;
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
      _isDirty = false;
      notifyListeners();
      debugPrint('🗑️ Discarded new CV (no saved version)');
      return;
    }

    try {
      final savedData = await _storage.loadCVData(_currentCVId!);
      if (savedData != null) {
        _cvData = savedData;
        _isDirty = false;
        notifyListeners();
        debugPrint('🗑️ Discarded changes, reverted to last saved version');
      } else {
        _cvData = CVData.empty();
        _isDirty = false;
        notifyListeners();
        debugPrint('🗑️ Discarded changes (no saved version found)');
      }
    } catch (e) {
      debugPrint('Error reverting CV: $e');
      _cvData = CVData.empty();
      _isDirty = false;
      notifyListeners();
    }
  }

  // ============ DUMMY DATA ============

  void fillDummyData() {
    _cvData = CVData.sample();
    _currentCVId = null;
    _isDirty = true;
    notifyListeners();
    _scheduleAutoSave();
    debugPrint('✅ Dummy data filled');
  }

  // ============ PROGRESS CALCULATION ============

  double calculateProgress() {
    int filled = 0;
    int total = 0;

    if (_cvData.fullName.isNotEmpty) filled++;
    if (_cvData.email.isNotEmpty) filled++;
    if (_cvData.phone.isNotEmpty) filled++;
    if (_cvData.summary.isNotEmpty) filled++;

    filled += _cvData.experiences.length;
    filled += _cvData.educations.length;
    filled += _cvData.skills.length;
    filled += _cvData.languages.length;
    filled += _cvData.certifications.length;
    filled += _cvData.projects.length;

    total =
        7 +
        _cvData.experiences.length +
        _cvData.educations.length +
        _cvData.skills.length +
        _cvData.languages.length +
        _cvData.certifications.length +
        _cvData.projects.length +
        1;

    return total > 0 ? filled / total : 0.0;
  }

  // ============ DISPOSE ============

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    super.dispose();
  }
}

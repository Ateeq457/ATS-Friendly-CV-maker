import 'dart:async';
import 'package:flutter/material.dart';
import '../models/cv_data.dart';
import '../data/local/cv_storage.dart';
import '../utils/date_formatter.dart';

class CVFormProvider extends ChangeNotifier {
  final CVStorage _storage = CVStorage();

  CVData _cvData = CVData.empty();
  bool _isLoading = false;
  Timer? _debounceTimer;

  CVData get cvData => _cvData;
  bool get isLoading => _isLoading;

  Future<void> loadCV(String? id) async {
    if (id == null) return;
    _isLoading = true;
    notifyListeners();
    final loaded = await _storage.loadCVData(id);
    if (loaded != null) _cvData = loaded;
    _isLoading = false;
    notifyListeners();
  }

  void updateField(String field, String value) {
    switch (field) {
      case 'fullName':
        _cvData.fullName = value;
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
      case 'title':
        _cvData.title = value;
        break;
    }
    notifyListeners();
    _debouncedAutoSave();
  }

  void addExperience(Experience exp) {
    _cvData.experiences.add(exp);
    notifyListeners();
    _debouncedAutoSave();
  }

  void updateExperience(int index, Experience exp) {
    _cvData.experiences[index] = exp;
    notifyListeners();
    _debouncedAutoSave();
  }

  void removeExperience(int index) {
    _cvData.experiences.removeAt(index);
    notifyListeners();
    _debouncedAutoSave();
  }

  void addEducation(Education edu) {
    _cvData.educations.add(edu);
    notifyListeners();
    _debouncedAutoSave();
  }

  void updateEducation(int index, Education edu) {
    _cvData.educations[index] = edu;
    notifyListeners();
    _debouncedAutoSave();
  }

  void removeEducation(int index) {
    _cvData.educations.removeAt(index);
    notifyListeners();
    _debouncedAutoSave();
  }

  void addSkill(String skill) {
    if (skill.trim().isEmpty) return;
    if (!_cvData.skills.contains(skill.trim())) {
      _cvData.skills.add(skill.trim());
      notifyListeners();
      _debouncedAutoSave();
    }
  }

  void removeSkill(String skill) {
    _cvData.skills.remove(skill);
    notifyListeners();
    _debouncedAutoSave();
  }

  void addLanguage(Language lang) {
    _cvData.languages.add(lang);
    notifyListeners();
    _debouncedAutoSave();
  }

  void updateLanguage(int index, Language lang) {
    _cvData.languages[index] = lang;
    notifyListeners();
    _debouncedAutoSave();
  }

  void removeLanguage(int index) {
    _cvData.languages.removeAt(index);
    notifyListeners();
    _debouncedAutoSave();
  }

  void addCertification(Certification cert) {
    _cvData.certifications.add(cert);
    notifyListeners();
    _debouncedAutoSave();
  }

  void updateCertification(int index, Certification cert) {
    _cvData.certifications[index] = cert;
    notifyListeners();
    _debouncedAutoSave();
  }

  void removeCertification(int index) {
    _cvData.certifications.removeAt(index);
    notifyListeners();
    _debouncedAutoSave();
  }

  void addProject(Project proj) {
    _cvData.projects.add(proj);
    notifyListeners();
    _debouncedAutoSave();
  }

  void updateProject(int index, Project proj) {
    _cvData.projects[index] = proj;
    notifyListeners();
    _debouncedAutoSave();
  }

  void removeProject(int index) {
    _cvData.projects.removeAt(index);
    notifyListeners();
    _debouncedAutoSave();
  }

  void _debouncedAutoSave() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 800), () async {
      await _storage.saveCVData(_cvData);
    });
  }

  Future<void> forceSave() async {
    _debounceTimer?.cancel();
    await _storage.saveCVData(_cvData);
  }

  void fillDummyData() {
    _cvData = CVData.sample();
    notifyListeners();
    forceSave();
  }
}

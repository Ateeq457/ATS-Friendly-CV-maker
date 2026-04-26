import 'package:android_cv_maker/data/models/language_model.dart';
import 'package:android_cv_maker/data/models/certification_model.dart';
import 'package:android_cv_maker/data/models/project_model.dart';
import 'package:android_cv_maker/data/models/social_link_model.dart';
import 'package:android_cv_maker/data/models/custom_section_model.dart';
import 'package:flutter/material.dart';
import '../../data/models/cv_data_model.dart';
import '../../data/models/experience_model.dart';
import '../../data/models/education_model.dart';
import '../../data/repositories/cv_repository.dart';

class CreateCVViewModel extends ChangeNotifier {
  final CVRepository _repository = CVRepository();

  CVDataModel _cvData = CVDataModel.empty();
  bool _isLoading = false;
  bool _isSaving = false;
  String? _errorMessage;

  CVDataModel get cvData => _cvData;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get errorMessage => _errorMessage;

  CreateCVViewModel({dynamic selectedTemplate, CVDataModel? existingCVData}) {
    if (existingCVData != null) {
      _cvData = existingCVData;
    } else {
      _cvData = CVDataModel.empty();
    }
    loadCVData();
  }

  // ✅ Save only when called explicitly
  Future<void> saveCVData() async {
    if (_isSaving) return;

    _isSaving = true;
    _cvData.lastUpdated = DateTime.now();

    try {
      await _repository.saveCV(_cvData);
      print('CV saved successfully: ${_cvData.id}');
    } catch (e) {
      print('Save error: $e');
    } finally {
      _isSaving = false;
    }
  }

  Future<void> loadCVData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final loaded = await _repository.loadCV();
      if (loaded != null && _cvData.id == CVDataModel.empty().id) {
        _cvData = loaded;
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ========== ALL UPDATE METHODS (NO AUTO-SAVE) ==========

  void updatePersonalInfo({
    String? fullName,
    String? email,
    String? phone,
    String? address,
    String? summary,
  }) {
    if (fullName != null) _cvData.personalInfo.fullName = fullName;
    if (email != null) _cvData.personalInfo.email = email;
    if (phone != null) _cvData.personalInfo.phone = phone;
    if (address != null) _cvData.personalInfo.address = address;
    if (summary != null) _cvData.personalInfo.summary = summary;
    notifyListeners();
  }

  void addExperience() {
    _cvData.experiences.add(ExperienceModel.empty());
    notifyListeners();
  }

  void updateExperience(int index, ExperienceModel experience) {
    _cvData.experiences[index] = experience;
    notifyListeners();
  }

  void removeExperience(int index) {
    _cvData.experiences.removeAt(index);
    notifyListeners();
  }

  void addEducation() {
    _cvData.educations.add(EducationModel.empty());
    notifyListeners();
  }

  void updateEducation(int index, EducationModel education) {
    _cvData.educations[index] = education;
    notifyListeners();
  }

  void removeEducation(int index) {
    _cvData.educations.removeAt(index);
    notifyListeners();
  }

  void addSkill(String skill) {
    if (skill.trim().isEmpty) return;
    if (!_cvData.skills.contains(skill.trim())) {
      _cvData.skills.add(skill.trim());
      notifyListeners();
    }
  }

  void removeSkill(String skill) {
    _cvData.skills.remove(skill);
    notifyListeners();
  }

  void addLanguage() {
    _cvData.languages.add(LanguageModel.empty());
    notifyListeners();
  }

  void updateLanguage(int index, LanguageModel language) {
    _cvData.languages[index] = language;
    notifyListeners();
  }

  void removeLanguage(int index) {
    _cvData.languages.removeAt(index);
    notifyListeners();
  }

  void addCertification() {
    _cvData.certifications.add(CertificationModel.empty());
    notifyListeners();
  }

  void updateCertification(int index, CertificationModel certification) {
    _cvData.certifications[index] = certification;
    notifyListeners();
  }

  void removeCertification(int index) {
    _cvData.certifications.removeAt(index);
    notifyListeners();
  }

  void addProject() {
    _cvData.projects.add(ProjectModel.empty());
    notifyListeners();
  }

  void updateProject(int index, ProjectModel project) {
    _cvData.projects[index] = project;
    notifyListeners();
  }

  void removeProject(int index) {
    _cvData.projects.removeAt(index);
    notifyListeners();
  }

  void addSocialLink() {
    _cvData.socialLinks.add(SocialLinkModel.empty());
    notifyListeners();
  }

  void updateSocialLink(int index, SocialLinkModel socialLink) {
    _cvData.socialLinks[index] = socialLink;
    notifyListeners();
  }

  void removeSocialLink(int index) {
    _cvData.socialLinks.removeAt(index);
    notifyListeners();
  }

  void addCustomSection() {
    _cvData.customSections.add(CustomSectionModel.empty());
    notifyListeners();
  }

  void updateCustomSection(int index, CustomSectionModel customSection) {
    _cvData.customSections[index] = customSection;
    notifyListeners();
  }

  void removeCustomSection(int index) {
    _cvData.customSections.removeAt(index);
    notifyListeners();
  }

  void addCustomSectionEntry(int sectionIndex) {
    _cvData.customSections[sectionIndex].entries.add(
      CustomSectionEntry.empty(),
    );
    notifyListeners();
  }

  void updateCustomSectionEntry(
    int sectionIndex,
    int entryIndex,
    CustomSectionEntry entry,
  ) {
    _cvData.customSections[sectionIndex].entries[entryIndex] = entry;
    notifyListeners();
  }

  void removeCustomSectionEntry(int sectionIndex, int entryIndex) {
    _cvData.customSections[sectionIndex].entries.removeAt(entryIndex);
    notifyListeners();
  }

  void clearAll() async {
    _cvData = CVDataModel.empty();
    await _repository.clearCV();
    notifyListeners();
  }

  void fillDummyData() async {
    try {
      clearAll();
      final sample = await _repository.getSampleCV();
      _cvData = sample;
      notifyListeners();
      await saveCVData();
      print('Dummy data loaded');
    } catch (e) {
      print('Error loading dummy data: $e');
    }
  }
}

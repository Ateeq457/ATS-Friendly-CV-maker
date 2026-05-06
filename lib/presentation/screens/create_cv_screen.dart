// File: lib/presentation/screens/create_cv_screen.dart

import 'package:android_cv_maker/presentation/widgets/form/certifications_form.dart';
import 'package:android_cv_maker/presentation/widgets/form/custom_section_form.dart';
import 'package:android_cv_maker/presentation/widgets/form/education_form.dart';
import 'package:android_cv_maker/presentation/widgets/form/languages_form.dart';
import 'package:android_cv_maker/presentation/widgets/form/optimized_experience_section.dart';
import 'package:android_cv_maker/presentation/widgets/form/personal_info_form.dart';
import 'package:android_cv_maker/presentation/widgets/form/projects_form.dart';
import 'package:android_cv_maker/presentation/widgets/form/skills_form.dart';
import 'package:android_cv_maker/presentation/widgets/form/social_links_form.dart';
import 'package:android_cv_maker/services/refresh_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cv_form_provider.dart';
import '../../data/models/cv_data.dart';
import '../widgets/form/optimized_text_field.dart';
import 'preview_screen.dart';

class CreateCVScreen extends StatefulWidget {
  final String? initialCVId;
  final int? selectedTemplateIndex;

  const CreateCVScreen({
    super.key,
    this.initialCVId,
    this.selectedTemplateIndex,
  });

  @override
  State<CreateCVScreen> createState() => _CreateCVScreenState();
}

class _CreateCVScreenState extends State<CreateCVScreen>
    with WidgetsBindingObserver {
  late CVFormProvider _provider;
  bool _isSaving = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _provider = CVFormProvider();
    if (widget.initialCVId != null) {
      _provider.loadCV(widget.initialCVId);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _provider.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _provider.forceSave();
    }
  }

  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
    _focusNode.unfocus();
  }

  double calculateProgress(CVData data) {
    final checks = <bool>[
      data.fullName.isNotEmpty,
      data.email.isNotEmpty,
      data.phone.isNotEmpty,
      data.summary.isNotEmpty,
      data.educations.isNotEmpty, // ✅ Education is required
      data.skills.isNotEmpty,
      // ✅ Experience is optional for freshers - removed from core progress
      data.projects.isNotEmpty,
      data.languages.isNotEmpty,
      data.certifications.isNotEmpty,
    ];

    final filled = checks.where((e) => e).length;
    return filled / checks.length;
  }

  String getCVStatus(double progress) {
    if (progress >= 0.85) return "Ready";
    if (progress >= 0.40) return "In Progress";
    return "Draft";
  }

  Color getStatusColor(double progress) {
    if (progress >= 0.85) return Colors.green;
    if (progress >= 0.40) return Colors.orange;
    return Colors.grey;
  }

  ValidationResult _validateAllSections() {
    final cvData = _provider.cvData;
    final errors = <String>[];
    final warnings = <String>[];

    // ========== PERSONAL INFO VALIDATION ==========
    if (cvData.fullName.trim().isEmpty) {
      errors.add('• Full Name is required');
    } else if (cvData.fullName.trim().length < 3) {
      warnings.add('• Full Name should be at least 3 characters');
    }

    if (cvData.email.trim().isEmpty) {
      errors.add('• Email is required');
    } else if (!_isValidEmail(cvData.email.trim())) {
      errors.add('• Please enter a valid email address');
    }

    if (cvData.phone.trim().isEmpty) {
      errors.add('• Phone number is required');
    }

    if (cvData.summary.trim().isEmpty) {
      errors.add('• Professional Summary is required');
    } else if (cvData.summary.trim().length < 50) {
      warnings.add('• Professional Summary is too short (min 50 characters)');
    }

    // ========== EXPERIENCE VALIDATION (OPTIONAL - NO ERRORS) ==========
    // Experience is optional for freshers - only show warning if empty
    if (cvData.experiences.isEmpty) {
      warnings.add(
        '• Add work experience (or list internships/projects as experience)',
      );
    } else {
      // Validate each experience if present
      for (int i = 0; i < cvData.experiences.length; i++) {
        final exp = cvData.experiences[i];
        if (exp.jobTitle.trim().isEmpty) {
          warnings.add('• Experience #${i + 1}: Job Title is recommended');
        }
        if (exp.company.trim().isEmpty) {
          warnings.add('• Experience #${i + 1}: Company name is recommended');
        }
        if (exp.description.trim().isEmpty) {
          warnings.add('• Experience #${i + 1}: Description is recommended');
        } else if (exp.description.trim().length < 30) {
          warnings.add(
            '• Experience #${i + 1}: Add more details to description',
          );
        }
      }
    }

    // ========== EDUCATION VALIDATION (REQUIRED) ==========
    if (cvData.educations.isEmpty) {
      errors.add(
        '• Education is required — add your highest degree or current study',
      );
    } else {
      for (int i = 0; i < cvData.educations.length; i++) {
        final edu = cvData.educations[i];
        if (edu.degree.trim().isEmpty) {
          errors.add('• Education #${i + 1}: Degree is required');
        }
        if (edu.institution.trim().isEmpty) {
          errors.add('• Education #${i + 1}: Institution is required');
        }
      }
    }

    // ========== SKILLS VALIDATION ==========
    if (cvData.skills.isEmpty) {
      warnings.add('• Add at least 3 skills to showcase your expertise');
    } else if (cvData.skills.length < 3) {
      warnings.add('• Add ${3 - cvData.skills.length} more skills');
    }

    // ========== LANGUAGES VALIDATION ==========
    for (int i = 0; i < cvData.languages.length; i++) {
      final lang = cvData.languages[i];
      if (lang.name.trim().isEmpty) {
        errors.add('• Language #${i + 1}: Language name is required');
      }
      if (lang.proficiencyLevel.isEmpty) {
        errors.add('• Language #${i + 1}: Proficiency level is required');
      }
    }

    // ========== PROJECTS VALIDATION ==========
    for (int i = 0; i < cvData.projects.length; i++) {
      final proj = cvData.projects[i];
      if (proj.name.trim().isEmpty) {
        errors.add('• Project #${i + 1}: Project name is required');
      }
      if (proj.description.trim().isEmpty) {
        errors.add('• Project #${i + 1}: Description is required');
      }
    }

    // ========== CERTIFICATIONS VALIDATION ==========
    for (int i = 0; i < cvData.certifications.length; i++) {
      final cert = cvData.certifications[i];
      if (cert.name.trim().isEmpty) {
        errors.add('• Certification #${i + 1}: Certification name is required');
      }
    }

    // ========== SOCIAL LINKS VALIDATION ==========
    for (int i = 0; i < cvData.socialLinks.length; i++) {
      final link = cvData.socialLinks[i];
      if (link.platform.isEmpty) {
        errors.add('• Social Link #${i + 1}: Platform is required');
      }
      if (link.url.isEmpty) {
        errors.add('• Social Link #${i + 1}: URL is required');
      } else if (!_isValidUrl(link.url)) {
        warnings.add('• ${link.platform}: URL format may be invalid');
      }
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

  bool _isValidPhone(String phone) {
    final phoneRegex = RegExp(r'^[\+\d][\d\s\-\(\)]{8,20}$');
    return phoneRegex.hasMatch(phone);
  }

  bool _isValidUrl(String url) {
    final urlRegex = RegExp(
      r'^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$',
    );
    return urlRegex.hasMatch(url);
  }

  Future<bool> _showValidationDialog(
    ValidationResult result,
    CVData cvData,
  ) async {
    final shouldContinue = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              result.isValid ? Icons.check_circle : Icons.warning_amber_rounded,
              color: result.isValid ? Colors.green : Colors.orange,
            ),
            const SizedBox(width: 8),
            Text(result.isValid ? 'Ready to Preview' : 'Issues Found'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (result.errors.isNotEmpty) ...[
                const Text(
                  '❌ Required Fields Missing:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 8),
                ...result.errors.map(
                  (error) => Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 4),
                    child: Text(
                      error,
                      style: const TextStyle(fontSize: 13, color: Colors.red),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              if (result.warnings.isNotEmpty) ...[
                const Text(
                  '💡 Suggestions for Improvement:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 8),
                ...result.warnings.map(
                  (warning) => Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 4),
                    child: Text(
                      warning,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.orange,
                      ),
                    ),
                  ),
                ),
              ],
              const Divider(),
              Text(
                result.isValid
                    ? 'Your CV is ready for preview!'
                    : 'Please fix the required fields before preview.',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              // DELETE THIS LINE:
              if (cvData.experiences.isEmpty && result.isValid)
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    '💼 Tip: Add internships or projects as experience entries',
                    style: TextStyle(fontSize: 11, color: Colors.blue),
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Go Back'),
          ),
          if (result.isValid)
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Preview'),
            ),
        ],
      ),
    );
    return shouldContinue ?? false;
  }

  Future<bool> _onWillPop() async {
    if (!_provider.isDirty) return true;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Unsaved Changes'),
        content: const Text(
          'You have unsaved changes. What would you like to do?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await _provider.saveDraft();
              if (mounted) {
                context.read<RefreshService>().refreshCVs();
                Navigator.pop(context, true);
              }
            },
            child: const Text('Save Draft'),
          ),
          TextButton(
            onPressed: () {
              _provider.cancelAutoSave();
              _provider.resetDirtyState();
              _provider.revertToLastSaved();
              Navigator.pop(context, true);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Future<void> _saveDraft() async {
    setState(() => _isSaving = true);
    final success = await _provider.saveDraft();
    if (success && mounted) {
      context.read<RefreshService>().refreshCVs();
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? '✅ Draft saved!' : '❌ Failed to save'),
          backgroundColor: success ? Colors.green : Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
      setState(() => _isSaving = false);
    }
  }

  Future<void> _handlePreview() async {
    _dismissKeyboard();
    final validationResult = _validateAllSections();
    final cvData = _provider.cvData; // ✅ ADD THIS LINE

    if (!validationResult.isValid) {
      final shouldContinue = await _showValidationDialog(
        validationResult,
        cvData,
      );
      if (!shouldContinue) return;
    }
    await _showPreview(context, _provider);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: ChangeNotifierProvider.value(
        value: _provider,
        child: GestureDetector(
          onTap: _dismissKeyboard,
          behavior: HitTestBehavior.opaque,
          child: Scaffold(
            appBar: _buildAppBar(context),
            body: _buildBody(context),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Create CV'),
      centerTitle: true,
      elevation: 0,
      actions: [
        Consumer<CVFormProvider>(
          builder: (context, viewModel, child) {
            return IconButton(
              icon: const Icon(Icons.visibility_outlined),
              onPressed: _handlePreview,
              tooltip: 'Preview CV',
            );
          },
        ),
        Consumer<CVFormProvider>(
          builder: (context, viewModel, child) {
            return IconButton(
              icon: const Icon(Icons.auto_awesome),
              onPressed: () => _fillDummyData(context, viewModel),
              tooltip: 'Fill Dummy Data',
            );
          },
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Consumer<CVFormProvider>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final cvData = viewModel.cvData;
        final progress = calculateProgress(cvData);
        final status = getCVStatus(progress);
        final statusColor = getStatusColor(progress);

        return Column(
          children: [
            // Fixed Progress Bar
            Container(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                border: Border(
                  bottom: BorderSide(color: Colors.grey.withOpacity(0.1)),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${(progress * 100).toInt()}%',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey[200],
                      color: statusColor,
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${(progress * 100).toInt()}% Complete',
                    style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
            // Scrollable Form
            Expanded(
              child: GestureDetector(
                onTap: _dismissKeyboard,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      _buildPersonalInfoCard(context, cvData, viewModel),
                      OptimizedExperienceSection(
                        experiences: cvData.experiences,
                        onExperiencesChanged: (newExperiences) =>
                            viewModel.updateExperiences(newExperiences),
                      ),
                      OptimizedEducationForm(
                        educations: cvData.educations,
                        onEducationsChanged: (newEducations) =>
                            viewModel.updateEducations(newEducations),
                      ),
                      OptimizedSkillsForm(
                        skills: cvData.skills,
                        onSkillsChanged: (newSkills) =>
                            viewModel.updateSkills(newSkills),
                      ),
                      OptimizedLanguagesForm(
                        languages: cvData.languages,
                        onLanguagesChanged: (newLanguages) =>
                            viewModel.updateLanguages(newLanguages),
                      ),
                      OptimizedCertificationsForm(
                        certifications: cvData.certifications,
                        onCertificationsChanged: (newCertifications) =>
                            viewModel.updateCertifications(newCertifications),
                      ),
                      OptimizedProjectsForm(
                        projects: cvData.projects,
                        onProjectsChanged: (newProjects) =>
                            viewModel.updateProjects(newProjects),
                      ),
                      OptimizedSocialLinksForm(
                        socialLinks: cvData.socialLinks,
                        onSocialLinksChanged: (newSocialLinks) =>
                            viewModel.updateSocialLinks(newSocialLinks),
                      ),
                      OptimizedCustomSectionsForm(
                        sections: cvData.customSections,
                        onSectionsChanged: (newSections) =>
                            viewModel.updateCustomSections(newSections),
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ),
            // Fixed Bottom Save Button
            _buildBottomBar(context),
          ],
        );
      },
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  _dismissKeyboard();
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back, size: 18),
                label: const Text('Back'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: _isSaving ? null : _saveDraft,
                icon: _isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save, size: 18),
                label: Text(_isSaving ? 'Saving...' : 'Save Draft'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInfoCard(
    BuildContext context,
    CVData cvData,
    CVFormProvider viewModel,
  ) {
    final hasErrors =
        cvData.fullName.isEmpty ||
        cvData.email.isEmpty ||
        cvData.phone.isEmpty ||
        cvData.summary.isEmpty;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.withOpacity(0.2)),
      ),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.person_outline,
                    color: Theme.of(context).primaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Personal Information',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  if (hasErrors)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Required',
                        style: TextStyle(fontSize: 10, color: Colors.orange),
                      ),
                    ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 8),
              OptimizedTextField(
                initialValue: cvData.fullName,
                label: 'Full Name',
                hint: 'John Doe',
                prefixIcon: Icons.person,
                onChanged: (v) => viewModel.updateField('fullName', v),
              ),
              const SizedBox(height: 12),
              OptimizedTextField(
                initialValue: cvData.title,
                label: 'Professional Title',
                hint: 'Senior Flutter Developer',
                prefixIcon: Icons.title,
                onChanged: (v) => viewModel.updateField('title', v),
              ),
              const SizedBox(height: 12),
              OptimizedTextField(
                initialValue: cvData.email,
                label: 'Email',
                hint: 'john.doe@example.com',
                prefixIcon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                onChanged: (v) => viewModel.updateField('email', v),
              ),
              const SizedBox(height: 12),
              OptimizedTextField(
                initialValue: cvData.phone,
                label: 'Phone',
                hint: '+92 300 1234567',
                prefixIcon: Icons.phone,
                keyboardType: TextInputType.phone,
                onChanged: (v) => viewModel.updateField('phone', v),
              ),
              const SizedBox(height: 12),
              OptimizedTextField(
                initialValue: cvData.location,
                label: 'Location',
                hint: 'City, Country',
                prefixIcon: Icons.location_on,
                onChanged: (v) => viewModel.updateField('location', v),
              ),
              const SizedBox(height: 12),
              OptimizedTextField(
                initialValue: cvData.summary,
                label: 'Professional Summary',
                hint: 'Write a brief summary...',
                maxLines: 4,
                onChanged: (v) => viewModel.updateField('summary', v),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showPreview(
    BuildContext context,
    CVFormProvider viewModel,
  ) async {
    await viewModel.forceSave();
    if (!mounted) return;
    final templateIndex = widget.selectedTemplateIndex ?? 0;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PreviewScreen(
          cvData: viewModel.cvData,
          templateIndex: templateIndex,
        ),
      ),
    );
  }

  void _fillDummyData(BuildContext context, CVFormProvider viewModel) {
    _dismissKeyboard();
    viewModel.fillDummyData();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Dummy data filled successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
        ),
      );
    }
  }
}

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

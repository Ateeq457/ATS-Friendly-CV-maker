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

  Future<void> _saveAsDraft() async {
    setState(() => _isSaving = true);
    final success = await _provider.saveAsDraft();
    if (success && mounted) {
      context.read<RefreshService>().refreshCVs();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Draft saved successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
    if (mounted) setState(() => _isSaving = false);
  }

  Future<void> _markAsCompleted() async {
    setState(() => _isSaving = true);

    // Validate before marking as completed
    final validation = _provider.validateData();
    if (!validation.isValid) {
      await _showValidationDialog(
        validation.errors,
        validation.warnings,
        isCompletionCheck: true,
      );
      setState(() => _isSaving = false);
      return;
    }

    final success = await _provider.markAsCompleted();
    if (success && mounted) {
      context.read<RefreshService>().refreshCVs();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ CV marked as completed!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
    if (mounted) setState(() => _isSaving = false);
  }

  Future<void> _handlePreview() async {
    _dismissKeyboard();

    final validation = _provider.validateData();
    if (!validation.isValid) {
      final shouldContinue = await _showValidationDialog(
        validation.errors,
        validation.warnings,
      );
      if (!shouldContinue) return;
    }

    await _showPreview(context, _provider);
  }

  Future<bool> _showValidationDialog(
    List<String> errors,
    List<String> warnings, {
    bool isCompletionCheck = false,
  }) async {
    final shouldContinue = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              errors.isEmpty ? Icons.check_circle : Icons.warning_amber_rounded,
              color: errors.isEmpty ? Colors.green : Colors.orange,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              // ✅ ADD THIS - Prevents overflow
              child: Text(
                errors.isEmpty ? 'Almost Ready' : 'Required Fields Missing',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (errors.isNotEmpty) ...[
                const Text(
                  '❌ Please fix these required fields:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 12),
                ...errors.map(
                  (error) => Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '• ',
                          style: TextStyle(fontSize: 13, color: Colors.red),
                        ),
                        Expanded(
                          // ✅ ADD THIS
                          child: Text(
                            error,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              if (warnings.isNotEmpty) ...[
                const Text(
                  '💡 Suggestions to improve your CV:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 12),
                ...warnings.map(
                  (warning) => Padding(
                    padding: const EdgeInsets.only(left: 8, bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '• ',
                          style: TextStyle(fontSize: 13, color: Colors.orange),
                        ),
                        Expanded(
                          // ✅ ADD THIS
                          child: Text(
                            warning,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              if (errors.isEmpty && warnings.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    '✓ Your CV looks great!',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  errors.isNotEmpty
                      ? 'Please fix the required fields before continuing.'
                      : isCompletionCheck
                      ? 'Your CV meets the requirements. Mark as completed?'
                      : 'Your CV is ready for preview!',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
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
          if (errors.isEmpty)
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: Text(isCompletionCheck ? 'Mark Complete' : 'Preview'),
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
              await _provider.saveAsDraft();
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
        IconButton(
          icon: const Icon(Icons.visibility_outlined),
          onPressed: _handlePreview,
          tooltip: 'Preview CV',
        ),
        IconButton(
          icon: const Icon(Icons.auto_awesome),
          onPressed: () => _fillDummyData(context),
          tooltip: 'Fill Dummy Data',
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
        final progress = viewModel.calculateProgress();
        final status = viewModel.getDisplayStatus();
        final statusColor = viewModel.getStatusColor();

        return Column(
          children: [
            // Progress Bar with Status
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Draft',
                        style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                      ),
                      Text(
                        'Ready',
                        style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Form
            Expanded(
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
            // Bottom Action Buttons
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
              child: ElevatedButton.icon(
                onPressed: _isSaving ? null : _saveAsDraft,
                icon: _isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save, size: 18),
                label: Text(_isSaving ? 'Saving...' : 'Draft'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _isSaving ? null : _markAsCompleted,
                icon: _isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.check_circle, size: 18),
                label: Text(_isSaving ? 'Processing...' : 'Complete'),
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

  void _fillDummyData(BuildContext context) {
    _dismissKeyboard();
    _provider.fillDummyData();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Dummy data filled (Draft mode)'),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 1),
      ),
    );
  }
}

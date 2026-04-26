import 'package:android_cv_maker/data/models/custom_section_model.dart';
import 'package:android_cv_maker/presentation/screens/preview_screen.dart';
import 'package:android_cv_maker/presentation/widgets/form/custom_section_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/cv_data_model.dart';
import '../../data/models/template_model.dart';
import '../viewmodels/create_cv_viewmodel.dart';
import '../widgets/form/personal_info_form.dart';
import '../widgets/form/experience_form.dart';
import '../widgets/form/education_form.dart';
import '../widgets/form/skills_form.dart';
import '../widgets/form/languages_form.dart';
import '../widgets/form/certifications_form.dart';
import '../widgets/form/projects_form.dart';
import '../widgets/form/social_links_form.dart';
// import '../widgets/form/custom_sections_form.dart';
import '../../core/engine/cv_renderer.dart';
import '../../core/templates/template_config.dart';
import '../../services/pdf_export_service.dart';

class CreateCVScreen extends StatefulWidget {
  final TemplateModel? template;
  final CVDataModel? cvData;

  const CreateCVScreen({super.key, this.template, this.cvData});

  @override
  State<CreateCVScreen> createState() => _CreateCVScreenState();
}

class _CreateCVScreenState extends State<CreateCVScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CreateCVViewModel(
        selectedTemplate: widget.template,
        existingCVData: widget.cvData,
      ),
      child: Scaffold(appBar: _buildAppBar(context), body: _buildBody(context)),
    );
  }

  @override
  void dispose() {
    _saveOnExit();
    super.dispose();
  }

  Future<void> _saveOnExit() async {
    final viewModel = context.read<CreateCVViewModel>();
    await viewModel.saveCVData();
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Create CV'),
      centerTitle: false,
      actions: [
        Consumer<CreateCVViewModel>(
          builder: (context, viewModel, child) {
            return IconButton(
              icon: const Icon(Icons.visibility),
              onPressed: () => _showPreview(context, viewModel),
              tooltip: 'Preview CV',
            );
          },
        ),
        Consumer<CreateCVViewModel>(
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
    return Consumer<CreateCVViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              PersonalInfoForm(
                fullName: viewModel.cvData.personalInfo.fullName,
                email: viewModel.cvData.personalInfo.email,
                phone: viewModel.cvData.personalInfo.phone,
                address: viewModel.cvData.personalInfo.address,
                summary: viewModel.cvData.personalInfo.summary,
                onFullNameChanged: (value) =>
                    viewModel.updatePersonalInfo(fullName: value),
                onEmailChanged: (value) =>
                    viewModel.updatePersonalInfo(email: value),
                onPhoneChanged: (value) =>
                    viewModel.updatePersonalInfo(phone: value),
                onAddressChanged: (value) =>
                    viewModel.updatePersonalInfo(address: value),
                onSummaryChanged: (value) =>
                    viewModel.updatePersonalInfo(summary: value),
              ),
              ExperienceForm(
                experiences: viewModel.cvData.experiences,
                onAddExperience: viewModel.addExperience,
                onUpdateExperience: viewModel.updateExperience,
                onRemoveExperience: viewModel.removeExperience,
              ),
              const SizedBox(height: 16),
              EducationForm(
                educations: viewModel.cvData.educations,
                onAddEducation: viewModel.addEducation,
                onUpdateEducation: viewModel.updateEducation,
                onRemoveEducation: viewModel.removeEducation,
              ),
              const SizedBox(height: 16),
              SkillsForm(
                skills: viewModel.cvData.skills,
                onAddSkill: viewModel.addSkill,
                onRemoveSkill: viewModel.removeSkill,
              ),
              const SizedBox(height: 16),
              LanguagesForm(
                languages: viewModel.cvData.languages,
                onAddLanguage: viewModel.addLanguage,
                onUpdateLanguage: viewModel.updateLanguage,
                onRemoveLanguage: viewModel.removeLanguage,
              ),
              const SizedBox(height: 16),
              CertificationsForm(
                certifications: viewModel.cvData.certifications,
                onAdd: viewModel.addCertification,
                onUpdate: viewModel.updateCertification,
                onRemove: viewModel.removeCertification,
              ),
              const SizedBox(height: 16),
              ProjectsForm(
                projects: viewModel.cvData.projects,
                onAdd: viewModel.addProject,
                onUpdate: viewModel.updateProject,
                onRemove: viewModel.removeProject,
              ),
              const SizedBox(height: 16),
              SocialLinksForm(
                socialLinks: viewModel.cvData.socialLinks,
                onAdd: viewModel.addSocialLink,
                onUpdate: viewModel.updateSocialLink,
                onRemove: viewModel.removeSocialLink,
              ),
              const SizedBox(height: 16),
              CustomSectionsForm(
                sections: viewModel.cvData.customSections,
                onAddSection: viewModel.addCustomSection,
                onRemoveSection: viewModel.removeCustomSection,
                onUpdateSectionTitle: (index, title) {
                  final section = viewModel.cvData.customSections[index];
                  final updated = CustomSectionModel(
                    id: section.id,
                    title: title,
                    entries: section.entries,
                  );
                  viewModel.updateCustomSection(index, updated);
                },
                onAddEntry: (sectionIndex) =>
                    viewModel.addCustomSectionEntry(sectionIndex),
                onUpdateEntry:
                    (sectionIndex, entryIndex, title, description, date) {
                      final section =
                          viewModel.cvData.customSections[sectionIndex];
                      final entry = section.entries[entryIndex];
                      final updated = CustomSectionEntry(
                        id: entry.id,
                        title: title,
                        description: description,
                        date: date,
                      );
                      viewModel.updateCustomSectionEntry(
                        sectionIndex,
                        entryIndex,
                        updated,
                      );
                    },
                onRemoveEntry: viewModel.removeCustomSectionEntry,
              ),
              const SizedBox(height: 80),
            ],
          ),
        );
      },
    );
  }

  void _showPreview(BuildContext context, CreateCVViewModel viewModel) {
    final templateConfig = _getTemplateConfig(
      viewModel.cvData.selectedTemplateId,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PreviewScreen(cvData: viewModel.cvData, config: templateConfig),
      ),
    );
  }

  Future<void> _downloadPDF(
    BuildContext context,
    CreateCVViewModel viewModel,
  ) async {
    final templateConfig = _getTemplateConfig(
      viewModel.cvData.selectedTemplateId,
    );

    // Show loading
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Generating PDF...')));

    try {
      final fileName = viewModel.cvData.personalInfo.fullName.replaceAll(
        ' ',
        '_',
      );

      final file = await PDFExportService.generateAndSave(
        cvData: viewModel.cvData,
        config: templateConfig,
        context: context,
        fileName: fileName,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PDF saved: ${file.path.split('/').last}'),
          backgroundColor: Colors.green,
        ),
      );

      // Option to share
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('PDF Generated'),
          content: const Text('Your CV has been saved successfully!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                Navigator.pop(context);
                await PDFExportService.sharePdf(file);
              },
              icon: const Icon(Icons.share),
              label: const Text('Share'),
            ),
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  TemplateConfig _getTemplateConfig(String templateId) {
    switch (templateId) {
      case 'usa_classic':
        return TemplateConfig.usaClassic;
      case 'modern_professional':
        return TemplateConfig.modernProfessional;
      case 'freshers_one_page':
        return TemplateConfig.freshersOnePage;
      default:
        return TemplateConfig.usaClassic;
    }
  }

  void _fillDummyData(BuildContext context, CreateCVViewModel viewModel) {
    viewModel.fillDummyData();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Dummy data filled successfully!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 1),
      ),
    );
  }
}

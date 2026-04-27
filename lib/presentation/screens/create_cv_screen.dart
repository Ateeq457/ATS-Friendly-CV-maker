import 'package:android_cv_maker/core/templates/template_generator.dart';
import 'package:android_cv_maker/data/models/custom_section_model.dart';
import 'package:android_cv_maker/data/models/social_link_model.dart';
import 'package:android_cv_maker/models/cv_data.dart';
import 'package:android_cv_maker/presentation/screens/preview_screen.dart';
import 'package:android_cv_maker/presentation/widgets/form/custom_section_form.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cv_form_provider.dart';
import '../widgets/form/personal_info_form.dart';
import '../widgets/form/experience_form.dart';
import '../widgets/form/education_form.dart';
import '../widgets/form/skills_form.dart';
import '../widgets/form/languages_form.dart';
import '../widgets/form/certifications_form.dart';
import '../widgets/form/projects_form.dart';
import '../widgets/form/social_links_form.dart';
import 'all_templates_screen.dart';

class CreateCVScreen extends StatefulWidget {
  final String? initialCVId;

  const CreateCVScreen({super.key, this.initialCVId});

  @override
  State<CreateCVScreen> createState() => _CreateCVScreenState();
}

class _CreateCVScreenState extends State<CreateCVScreen> {
  @override
  void initState() {
    super.initState();
    // Load CV if editing existing
    Future.microtask(() {
      final provider = context.read<CVFormProvider>();
      if (widget.initialCVId != null) {
        provider.loadCV(widget.initialCVId);
      }
    });
  }

  @override
  void dispose() {
    _saveOnExit();
    super.dispose();
  }

  Future<void> _saveOnExit() async {
    final viewModel = context.read<CVFormProvider>();
    await viewModel.forceSave();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CVFormProvider(),
      child: Scaffold(appBar: _buildAppBar(context), body: _buildBody(context)),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Create CV'),
      centerTitle: false,
      actions: [
        Consumer<CVFormProvider>(
          builder: (context, viewModel, child) {
            return IconButton(
              icon: const Icon(Icons.visibility),
              onPressed: () => _showPreview(context, viewModel),
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

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Personal Info
              PersonalInfoForm(
                fullName: cvData.fullName,
                email: cvData.email,
                phone: cvData.phone,
                address: cvData.location,
                summary: cvData.summary,
                onFullNameChanged: (v) => viewModel.updateField('fullName', v),
                onEmailChanged: (v) => viewModel.updateField('email', v),
                onPhoneChanged: (v) => viewModel.updateField('phone', v),
                onAddressChanged: (v) => viewModel.updateField('location', v),
                onSummaryChanged: (v) => viewModel.updateField('summary', v),
              ),

              // Experience
              ExperienceForm(
                experiences: cvData.experiences,
                onAddExperience: () =>
                    viewModel.addExperience(Experience.empty()),
                onUpdateExperience: (index, exp) =>
                    viewModel.updateExperience(index, exp),
                onRemoveExperience: (index) =>
                    viewModel.removeExperience(index),
              ),
              const SizedBox(height: 16),

              // Education
              EducationForm(
                educations: cvData.educations,
                onAddEducation: () => viewModel.addEducation(Education.empty()),
                onUpdateEducation: (index, edu) =>
                    viewModel.updateEducation(index, edu),
                onRemoveEducation: (index) => viewModel.removeEducation(index),
              ),
              const SizedBox(height: 16),

              // Skills
              SkillsForm(
                skills: cvData.skills,
                onAddSkill: (skill) => viewModel.addSkill(skill),
                onRemoveSkill: (skill) => viewModel.removeSkill(skill),
              ),
              const SizedBox(height: 16),

              // Languages
              LanguagesForm(
                languages: cvData.languages,
                onAddLanguage: () => viewModel.addLanguage(Language.empty()),
                onUpdateLanguage: (index, lang) =>
                    viewModel.updateLanguage(index, lang),
                onRemoveLanguage: (index) => viewModel.removeLanguage(index),
              ),
              const SizedBox(height: 16),

              // Certifications
              CertificationsForm(
                certifications: cvData.certifications,
                onAdd: () => viewModel.addCertification(Certification.empty()),
                onUpdate: (index, cert) =>
                    viewModel.updateCertification(index, cert),
                onRemove: (index) => viewModel.removeCertification(index),
              ),
              const SizedBox(height: 16),

              // Projects
              ProjectsForm(
                projects: cvData.projects,
                onAdd: () => viewModel.addProject(Project.empty()),
                onUpdate: (index, proj) => viewModel.updateProject(index, proj),
                onRemove: (index) => viewModel.removeProject(index),
              ),
              const SizedBox(height: 16),

              // Social Links
              SocialLinksForm(
                socialLinks: cvData.socialLinks,
                onAdd: () => viewModel.addSocialLink(SocialLink.empty()),
                onUpdate: (index, link) =>
                    viewModel.updateSocialLink(index, link),
                onRemove: (index) => viewModel.removeSocialLink(index),
              ),
              const SizedBox(height: 16),

              // Custom Sections
              CustomSectionsForm(
                sections: cvData.customSections,
                onAddSection: () =>
                    viewModel.addCustomSection(CustomSection.empty()),
                onRemoveSection: (index) =>
                    viewModel.removeCustomSection(index),
                onUpdateSectionTitle: (index, title) =>
                    viewModel.updateCustomSectionTitle(index, title),
                onAddEntry: (sectionIndex) =>
                    viewModel.addCustomSectionEntry(sectionIndex),
                onUpdateEntry: (sectionIndex, entryIndex, title, desc, date) =>
                    viewModel.updateCustomSectionEntry(
                      sectionIndex,
                      entryIndex,
                      title,
                      desc,
                      date,
                    ),
                onRemoveEntry: (sectionIndex, entryIndex) => viewModel
                    .removeCustomSectionEntry(sectionIndex, entryIndex),
              ),
              const SizedBox(height: 80),
            ],
          ),
        );
      },
    );
  }

  void _showPreview(BuildContext context, CVFormProvider viewModel) async {
    // Save before preview
    await viewModel.forceSave();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PreviewScreen(
          cvData: viewModel.cvData,
          templateIndex: 0, // Default template
        ),
      ),
    );
  }

  void _fillDummyData(BuildContext context, CVFormProvider viewModel) {
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

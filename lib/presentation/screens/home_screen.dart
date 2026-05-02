// File: lib/presentation/screens/home_screen.dart
import 'package:android_cv_maker/data/models/cv_data.dart';
import 'package:android_cv_maker/presentation/screens/all_cvs_screen.dart';
import 'package:android_cv_maker/presentation/screens/all_templates_screen.dart';
import 'package:android_cv_maker/presentation/screens/create_cv_screen.dart';
import 'package:android_cv_maker/presentation/screens/template_preview_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/themes/theme_provider.dart';
import '../../core/constants/design_system.dart';
import '../../data/models/template_model.dart'; // ✅ ADDE

import '../widgets/home/home_app_bar.dart';
import '../widgets/home/hero_section.dart';
import '../widgets/home/template_carousel.dart';
import '../widgets/home/quick_start_steps.dart';
import '../widgets/home/benefits_section.dart';
import '../widgets/home/sample_cv_preview.dart';
import '../widgets/home/status_card.dart';
import '../widgets/home/continue_card.dart';
import '../widgets/home/recent_cvs_list.dart';
import '../widgets/home/recommended_templates_carousel.dart';
import '../widgets/home/section_header.dart';
import '../widgets/shared/bottom_sheet_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  void _refreshData() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final userCVs = CVModel.getSampleCVs();
    final hasCVs = userCVs.isNotEmpty;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: const HomeAppBar(),
      body: hasCVs
          ? _buildReturningUserView(context, userCVs)
          : _buildFirstTimeUserView(context),
      floatingActionButton: _buildSmartFAB(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  // ========== FIRST TIME USER VIEW ==========
  Widget _buildFirstTimeUserView(BuildContext context) {
    final popularTemplates = TemplateModel.getPopularTemplates();
    final benefits = TemplateModel.getBenefits();
    final quickSteps = TemplateModel.getQuickSteps();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeroSection(onCreateCV: () => _navigateToCreateCV(context)),
          const SizedBox(height: DesignSystem.paddingXLarge),
          TemplateCarousel(
            templates: popularTemplates,
            onTemplateTap: (template) =>
                _navigateToTemplateDetail(context, template),
            onPreviewTap: (template) => _previewTemplate(context, template),
            onSeeAll: () => _navigateToAllTemplates(context),
          ),
          const SizedBox(height: DesignSystem.paddingXXLarge),

          const SizedBox(height: DesignSystem.paddingXXLarge),
          SampleCVPreview(onViewSample: () => _showSampleCV(context)),
          const SizedBox(height: DesignSystem.paddingXLarge),
        ],
      ),
    );
  }

  // ========== RETURNING USER VIEW ==========
  Widget _buildReturningUserView(BuildContext context, List<CVModel> userCVs) {
    final drafts = userCVs.where((cv) => cv.status == 'draft').toList();
    final recentCVs = userCVs.take(3).toList();
    final recommendedTemplates = TemplateModel.getRecommendedTemplates();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(DesignSystem.paddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StatusCard(
            draftsCount: drafts.length,
            completedCount: userCVs.length - drafts.length,
          ),
          const SizedBox(height: 20),
          if (drafts.isNotEmpty) ...[
            ContinueCard(
              draft: drafts.first,
              onContinue: () => _navigateToEditCV(context, drafts.first),
            ),
            const SizedBox(height: 24),
          ],
          SectionHeader(
            title: 'Recent CVs',
            action: 'View all',
            onActionTap: () => _navigateToAllCVs(context),
          ),
          const SizedBox(height: 12),
          RecentCVsList(
            recentCVs: recentCVs,
            onCVTap: (cv) => _navigateToEditCV(context, cv),
            onEdit: (cv) => _navigateToEditCV(context, cv),
            onDelete: (cv) => _deleteCV(context, cv),
          ),
          const SizedBox(height: 28),
          SectionHeader(
            title: 'Recommended for You',
            action: 'See all',
            onActionTap: () => _navigateToAllTemplates(context),
          ),
          const SizedBox(height: 12),
          RecommendedTemplatesCarousel(
            templates: recommendedTemplates,
            onTemplateTap: (template) =>
                _navigateToTemplateDetail(context, template),
            onPreviewTap: (template) => _previewTemplate(context, template),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ========== FLOATING ACTION BUTTON ==========
  Widget _buildSmartFAB(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showCreateBottomSheet(context),
      child: const Icon(Icons.add),
      elevation: 0,
      tooltip: 'Create new CV',
    );
  }

  // ========== BOTTOM SHEET ==========
  void _showCreateBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(DesignSystem.radiusXLarge),
        ),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(DesignSystem.paddingXLarge),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              BottomSheetItem(
                icon: Icons.add,
                title: 'Create New CV',
                subtitle: 'Start from scratch',
                color: Theme.of(context).primaryColor,
                onTap: () {
                  Navigator.pop(context);
                  _navigateToCreateCV(context);
                },
              ),
              BottomSheetItem(
                icon: Icons.grid_view,
                title: 'Choose Template',
                subtitle: 'Browse all templates',
                color: Colors.green,
                onTap: () {
                  Navigator.pop(context);
                  _navigateToAllTemplates(context);
                },
              ),
              BottomSheetItem(
                icon: Icons.upload_file,
                title: 'Import CV',
                subtitle: 'Edit existing CV',
                color: Colors.orange,
                onTap: () {
                  Navigator.pop(context);
                  _navigateToImportCV(context);
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  // ========== DUPLICATE CV ==========
  void _duplicateCV(BuildContext context, CVModel cv) {
    setState(() {
      CVModel.duplicateCV(cv);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"${cv.title}" duplicated successfully'),
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ========== DELETE CV ==========
  void _deleteCV(BuildContext context, CVModel cv) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete CV'),
        content: Text('Are you sure you want to delete "${cv.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        CVModel.deleteCV(cv.id);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('"${cv.title}" deleted successfully'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  // ========== NAVIGATION METHODS ==========
  void _showSampleCV(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sample CV preview coming soon!')),
    );
  }

  void _navigateToCreateCV(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateCVScreen()),
    );
  }

  void _navigateToEditCV(BuildContext context, CVModel cv) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Edit ${cv.title} coming soon!')));
  }

  void _navigateToAllTemplates(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AllTemplatesScreen()),
    );
  }

  void _navigateToTemplateDetail(BuildContext context, TemplateModel template) {
    // ✅ FIXED: Don't pass template parameter
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Creating CV with ${template.name} template...'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateCVScreen()),
    );
  }

  void _navigateToImportCV(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Import CV feature coming soon!')),
    );
  }

  void _navigateToAllCVs(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AllCVsScreen()),
    );
    _refreshData();
  }

  void _previewTemplate(BuildContext context, TemplateModel template) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TemplatePreviewScreen(template: template),
      ),
    );
  }
}

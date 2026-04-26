import 'package:android_cv_maker/presentation/screens/template_preview_screen.dart';
import 'package:android_cv_maker/presentation/screens/create_cv_screen.dart'; // ✅ Add this import
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/design_system.dart';
import '../../data/models/template_model.dart';
import '../viewmodels/all_templates_viewmodel.dart';
import '../widgets/home/template_card.dart';

class AllTemplatesScreen extends StatefulWidget {
  const AllTemplatesScreen({super.key});

  @override
  State<AllTemplatesScreen> createState() => _AllTemplatesScreenState();
}

class _AllTemplatesScreenState extends State<AllTemplatesScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  void _dismissKeyboard() {
    if (_searchFocusNode.hasFocus) {
      _searchFocusNode.unfocus();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AllTemplatesViewModel(),
      child: GestureDetector(
        onTap: _dismissKeyboard,
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: _buildAppBar(context),
          body: Consumer<AllTemplatesViewModel>(
            builder: (context, viewModel, child) {
              return Column(
                children: [
                  _buildSearchBar(context, viewModel),
                  const SizedBox(height: 16),
                  Expanded(child: _buildContent(context, viewModel)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text(
        'All Templates',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      centerTitle: false,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.info_outline),
          onPressed: () => _showInfoDialog(context),
        ),
      ],
    );
  }

  Widget _buildSearchBar(
    BuildContext context,
    AllTemplatesViewModel viewModel,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: DesignSystem.paddingLarge,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(DesignSystem.radiusXLarge),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: TextField(
          controller: _searchController,
          focusNode: _searchFocusNode,
          textInputAction: TextInputAction.done,
          onEditingComplete: _dismissKeyboard,
          onChanged: (value) {
            viewModel.setSearchQuery(value);
          },
          decoration: InputDecoration(
            hintText: 'Search templates...',
            prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.clear, color: Colors.grey[500]),
                    onPressed: () {
                      _searchController.clear();
                      viewModel.clearSearch();
                    },
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, AllTemplatesViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (viewModel.errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              viewModel.errorMessage,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => viewModel.loadTemplates(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (viewModel.templates.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.grid_view_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              _searchController.text.isNotEmpty
                  ? 'No templates match "${_searchController.text}"'
                  : 'No templates found',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(DesignSystem.paddingLarge),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.80,
      ),
      itemCount: viewModel.templates.length,
      itemBuilder: (context, index) {
        final template = viewModel.templates[index];
        return TemplateCard(
          template: template,
          onTap: () => _navigateToCreateCV(context, template), // ✅ Updated
          onPreviewTap: () => _previewTemplate(context, template),
        );
      },
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Templates'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• All templates are ATS-friendly'),
            SizedBox(height: 8),
            Text('• Professionally designed for global jobs'),
            SizedBox(height: 8),
            Text('• One-click PDF export'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  void _previewTemplate(BuildContext context, TemplateModel template) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TemplatePreviewScreen(template: template),
      ),
    );
  }

  // ✅ Updated: Navigate to CreateCVScreen with template
  void _navigateToCreateCV(BuildContext context, TemplateModel template) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateCVScreen(template: template),
      ),
    );
  }
}

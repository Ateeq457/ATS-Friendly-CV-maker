// File: lib/presentation/screens/all_templates_screen.dart
import 'package:android_cv_maker/core/config/template_config.dart';
import 'package:android_cv_maker/presentation/screens/create_cv_screen.dart';
import 'package:android_cv_maker/presentation/screens/preview_screen.dart';
import 'package:flutter/material.dart';
import '../../core/constants/design_system.dart';
import '../../core/templates/template_generator.dart';
import '../widgets/home/template_card.dart';
import '../../data/models/cv_data.dart'; // ✅ CHANGED
import '../../data/models/template_model.dart'; // ✅ ADDED

class AllTemplatesScreen extends StatefulWidget {
  const AllTemplatesScreen({super.key});

  @override
  State<AllTemplatesScreen> createState() => _AllTemplatesScreenState();
}

class _AllTemplatesScreenState extends State<AllTemplatesScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  List<TemplateConfig> _templates = [];
  List<TemplateConfig> _filteredTemplates = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String? _errorMessage;

  // Sample CV data for preview
  final CVData _sampleCVData = CVData.sample();

  @override
  void initState() {
    super.initState();
    _loadTemplates();
  }

  void _dismissKeyboard() {
    if (_searchFocusNode.hasFocus) {
      _searchFocusNode.unfocus();
    }
  }

  void _loadTemplates() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final templates = TemplateGenerator.getAllTemplates();
      setState(() {
        _templates = templates;
        _filteredTemplates = templates;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _filterTemplates(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredTemplates = _templates;
      } else {
        _filteredTemplates = _templates
            .where(
              (t) => t.layoutStyle.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _dismissKeyboard,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: _buildAppBar(context),
        body: Column(
          children: [
            _buildSearchBar(),
            const SizedBox(height: 16),
            Expanded(child: _buildContent()),
          ],
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

  Widget _buildSearchBar() {
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
          onChanged: _filterTemplates,
          decoration: InputDecoration(
            hintText: 'Search templates...',
            prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.clear, color: Colors.grey[500]),
                    onPressed: () {
                      _searchController.clear();
                      _filterTemplates('');
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

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(_errorMessage!, style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadTemplates,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_filteredTemplates.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.grid_view_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isNotEmpty
                  ? 'No templates match "$_searchQuery"'
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
      itemCount: _filteredTemplates.length,
      itemBuilder: (context, index) {
        final template = _filteredTemplates[index];
        // Create a TemplateModel wrapper for the card
        final templateModel = TemplateModel(
          id: index.toString(),
          name: template.layoutStyle,
          tag: template.layoutStyle,
          icon: Icons.description,
          color: Color(
            int.parse('0xFF${template.primaryColor.replaceAll('#', '')}'),
          ),
        );
        return TemplateCard(
          template: templateModel,
          onTap: () => _navigateToCreateCV(context, index),
          onPreviewTap: () => _previewTemplate(context, index),
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

  void _previewTemplate(BuildContext context, int templateIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PreviewScreen(cvData: _sampleCVData, templateIndex: templateIndex),
      ),
    );
  }

  void _navigateToCreateCV(BuildContext context, int templateIndex) {
    // Store selected template index (you can use a provider or pass via constructor)
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CreateCVScreen(selectedTemplateIndex: templateIndex),
      ),
    );
  }
}

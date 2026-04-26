import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import '../models/template_model.dart';

class TemplateRepository {
  static List<TemplateModel>? _cachedTemplates;

  // Load all templates from assets
  Future<List<TemplateModel>> loadAllTemplates() async {
    if (_cachedTemplates != null) return _cachedTemplates!;

    try {
      final List<TemplateModel> templates = [];

      // Get list of template folders from assets
      final manifest = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = jsonDecode(manifest);

      // Find all template config files
      final templatePaths = manifestMap.keys
          .where(
            (path) =>
                path.contains('assets/templates/') &&
                path.contains('config.json'),
          )
          .toList();

      for (var path in templatePaths) {
        try {
          final folderName = path.split(
            '/',
          )[2]; // assets/templates/usa_classic/config.json
          final configString = await rootBundle.loadString(path);
          final config = jsonDecode(configString);

          templates.add(
            TemplateModel(
              id: folderName,
              name: config['name'] ?? folderName,
              tag: config['category'] ?? 'Template',
              category: _getCategory(config),
              color: _getColor(config['style']?['primaryColor'] ?? '#2C3E50'),
              icon: _getIcon(config['category'] ?? 'default'),
            ),
          );
        } catch (e) {
          print('Error loading template from $path: $e');
        }
      }

      // If no templates found, return default ones
      if (templates.isEmpty) {
        return _getDefaultTemplates();
      }

      _cachedTemplates = templates;
      return templates;
    } catch (e) {
      print('Error loading templates: $e');
      return _getDefaultTemplates();
    }
  }

  // Get popular templates
  Future<List<TemplateModel>> getPopularTemplates() async {
    final all = await loadAllTemplates();
    return all.take(4).toList();
  }

  // Get recommended templates
  Future<List<TemplateModel>> getRecommendedTemplates() async {
    final all = await loadAllTemplates();
    if (all.length > 4) {
      return all.skip(4).toList();
    }
    return [];
  }

  // Get template by ID
  Future<TemplateModel?> getTemplateById(String id) async {
    final all = await loadAllTemplates();
    try {
      return all.firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
  }

  String _getCategory(Map<String, dynamic> config) {
    final category = config['category'];
    if (category == 'ats' || category == 'popular') return 'popular';
    if (category == 'recommended') return 'recommended';
    return 'popular';
  }

  Color _getColor(String hexColor) {
    try {
      hexColor = hexColor.replaceAll('#', '');
      if (hexColor.length == 6) {
        return Color(int.parse('FF$hexColor', radix: 16));
      }
      return Colors.blue;
    } catch (e) {
      return Colors.blue;
    }
  }

  IconData _getIcon(String category) {
    switch (category) {
      case 'ats':
        return Icons.description;
      case 'modern':
        return Icons.work;
      case 'creative':
        return Icons.brush;
      default:
        return Icons.description;
    }
  }

  List<TemplateModel> _getDefaultTemplates() {
    return [
      TemplateModel(
        id: 'usa_classic',
        name: 'USA ATS Classic',
        tag: 'Most Popular',
        category: 'popular',
        color: Colors.blue,
        icon: Icons.description,
      ),
      TemplateModel(
        id: 'modern_executive',
        name: 'Modern Executive',
        tag: 'Professional',
        category: 'popular',
        color: Colors.purple,
        icon: Icons.work,
      ),
      TemplateModel(
        id: 'freshers_one_page',
        name: 'Freshers One-Page',
        tag: 'Best for Students',
        category: 'popular',
        color: Colors.green,
        icon: Icons.school,
      ),
    ];
  }
}

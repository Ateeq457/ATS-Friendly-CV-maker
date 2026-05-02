// File: lib/data/models/template_model.dart

import 'package:flutter/material.dart';

class TemplateModel {
  final String id;
  final String name;
  final String tag;
  final IconData icon;
  final Color color;
  final String description;
  final String previewImageUrl;

  const TemplateModel({
    required this.id,
    required this.name,
    required this.tag,
    required this.icon,
    required this.color,
    this.description = '',
    this.previewImageUrl = '',
  });

  // Factory method for popular templates
  static List<TemplateModel> getPopularTemplates() {
    return [
      const TemplateModel(
        id: 'classic',
        name: 'Classic',
        tag: 'ATS',
        icon: Icons.description,
        color: Color(0xFF1E88E5),
        description: 'Traditional format, ATS-friendly',
      ),
      const TemplateModel(
        id: 'modern',
        name: 'Modern',
        tag: 'Creative',
        icon: Icons.auto_awesome,
        color: Color(0xFF7C3AED),
        description: 'Clean design with sidebar',
      ),
      const TemplateModel(
        id: 'executive',
        name: 'Executive',
        tag: 'Premium',
        icon: Icons.workspace_premium,
        color: Color(0xFF10B981),
        description: 'For senior professionals',
      ),
    ];
  }

  // Factory method for recommended templates
  static List<TemplateModel> getRecommendedTemplates() {
    return [
      const TemplateModel(
        id: 'tech',
        name: 'Tech',
        tag: 'IT',
        icon: Icons.code,
        color: Color(0xFFEC4899),
        description: 'Perfect for developers',
      ),
      const TemplateModel(
        id: 'creative',
        name: 'Creative',
        tag: 'Design',
        icon: Icons.brush,
        color: Color(0xFFF59E0B),
        description: 'For designers & artists',
      ),
    ];
  }

  // Benefits data
  static List<BenefitModel> getBenefits() {
    return [
      BenefitModel(
        icon: Icons.rocket_launch,
        title: 'Fast',
        description: 'Create in minutes',
      ),
      BenefitModel(
        icon: Icons.verified,
        title: 'ATS-friendly',
        description: 'Get more interviews',
      ),
      BenefitModel(
        icon: Icons.download,
        title: 'Export PDF',
        description: 'One-click download',
      ),
      BenefitModel(
        icon: Icons.devices,
        title: 'Responsive',
        description: 'Works everywhere',
      ),
    ];
  }

  // Quick steps data
  static List<QuickStepModel> getQuickSteps() {
    return [
      QuickStepModel(
        icon: Icons.grid_view,
        title: 'Choose Template',
        description: 'Pick a design',
      ),
      QuickStepModel(
        icon: Icons.edit_note,
        title: 'Add Details',
        description: 'Fill your info',
      ),
      QuickStepModel(
        icon: Icons.visibility,
        title: 'Preview',
        description: 'See your CV',
      ),
      QuickStepModel(
        icon: Icons.download,
        title: 'Download',
        description: 'Get PDF',
      ),
    ];
  }
}

class BenefitModel {
  final IconData icon;
  final String title;
  final String description;

  BenefitModel({
    required this.icon,
    required this.title,
    required this.description,
  });
}

class QuickStepModel {
  final IconData icon;
  final String title;
  final String description;

  QuickStepModel({
    required this.icon,
    required this.title,
    required this.description,
  });
}

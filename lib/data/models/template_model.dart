import 'package:flutter/material.dart';

class TemplateModel {
  final String id;
  final String name;
  final String tag;
  final String category; // ✅ NEW: 'popular', 'recommended', 'all'
  final Color color;
  final IconData icon;

  TemplateModel({
    required this.id,
    required this.name,
    required this.tag,
    required this.category,
    required this.color,
    required this.icon,
  });

  static List<TemplateModel> getPopularTemplates() {
    return [
      TemplateModel(
        id: '1',
        name: 'USA ATS Classic',
        tag: 'Most Popular',
        category: 'popular',
        color: Colors.blue,
        icon: Icons.description,
      ),
      TemplateModel(
        id: '2',
        name: 'Modern Executive',
        tag: 'Professional',
        category: 'popular',
        color: Colors.purple,
        icon: Icons.work,
      ),
      TemplateModel(
        id: '3',
        name: 'Freshers One-Page',
        tag: 'Best for Students',
        category: 'popular',
        color: Colors.green,
        icon: Icons.school,
      ),
      TemplateModel(
        id: '4',
        name: 'Creative Designer',
        tag: 'Creative',
        category: 'popular',
        color: Colors.orange,
        icon: Icons.brush,
      ),
    ];
  }

  static List<TemplateModel> getRecommendedTemplates() {
    return [
      TemplateModel(
        id: '5',
        name: 'Software Engineer CV',
        tag: 'Based on your last',
        category: 'recommended',
        color: Colors.blue,
        icon: Icons.code,
      ),
      TemplateModel(
        id: '6',
        name: 'Tech Lead Profile',
        tag: 'Popular in Tech',
        category: 'recommended',
        color: Colors.purple,
        icon: Icons.leaderboard,
      ),
      TemplateModel(
        id: '7',
        name: 'Senior Developer',
        tag: 'Recommended',
        category: 'recommended',
        color: Colors.green,
        icon: Icons.developer_mode,
      ),
      TemplateModel(
        id: '8',
        name: 'Full Stack CV',
        tag: 'Trending',
        category: 'recommended',
        color: Colors.orange,
        icon: Icons.storage,
      ),
    ];
  }

  static List<QuickStepModel> getQuickSteps() {
    return [
      QuickStepModel(
        icon: Icons.grid_view,
        title: 'Choose Template',
        description: 'Select from 10+ designs',
      ),
      QuickStepModel(
        icon: Icons.edit_note,
        title: 'Fill Details',
        description: 'Add experience, education, skills',
      ),
      QuickStepModel(
        icon: Icons.download,
        title: 'Download PDF',
        description: 'Get ATS-ready PDF instantly',
      ),
    ];
  }

  static List<BenefitModel> getBenefits() {
    return [
      BenefitModel(
        icon: Icons.verified,
        title: 'ATS Optimized',
        description: 'Pass automated screening',
      ),
      BenefitModel(
        icon: Icons.people,
        title: 'Recruiter Friendly',
        description: 'Clean, professional layout',
      ),
      BenefitModel(
        icon: Icons.picture_as_pdf,
        title: 'One-click Export',
        description: 'PDF download instantly',
      ),
    ];
  }
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

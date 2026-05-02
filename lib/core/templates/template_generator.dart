// File: lib/core/templates/template_generator.dart

import 'package:flutter/material.dart';
import '../../data/models/template_model.dart';
import '../config/template_config.dart';

class TemplateGenerator {
  // Get all available templates
  static List<TemplateConfig> getAllTemplates() {
    return [
      _createClassicTemplate(),
      _createModernTemplate(),
      _createExecutiveTemplate(),
      _createTechTemplate(),
      _createCreativeTemplate(),
    ];
  }

  // Get template by ID
  static TemplateConfig getTemplateById(String id) {
    final templates = getAllTemplates();
    try {
      return templates.firstWhere(
        (t) => t.layoutStyle.toLowerCase().contains(id.toLowerCase()),
      );
    } catch (e) {
      // Return default template if not found
      return _createClassicTemplate();
    }
  }

  // Get template by index (for backward compatibility)
  static TemplateConfig getTemplateByIndex(int index) {
    final templates = getAllTemplates();
    if (index >= 0 && index < templates.length) {
      return templates[index];
    }
    return _createClassicTemplate();
  }

  // ============ PRIVATE TEMPLATE CREATORS ============

  static TemplateConfig _createClassicTemplate() {
    return const TemplateConfig(
      layoutStyle: 'single-column',
      sidebarWidth: 0,
      primaryColor: '#1E88E5',
      secondaryColor: '#1565C0',
      accentColor: '#FBBF24',
      backgroundColor: '#FFFFFF',
      surfaceColor: '#F5F5F5',
      textColor: '#111827',
      textLightColor: '#6B7280',
      headerBackgroundColor: '#1E88E5',
      sidebarBackgroundColor: '#F5F5F5',
      headingFont: 'Roboto',
      bodyFont: 'Roboto',
      headingSize: 24,
      subheadingSize: 18,
      bodySize: 14,
      smallSize: 12,
      photoStyle: 'circle',
      photoPosition: 'header',
      photoSize: 100,
      photoBorder: true,
      photoBorderColor: '#FFFFFF',
      headerStyle: 'centered',
      showContactInHeader: true,
      contactLayout: 'row',
      experienceStyle: 'list',
      skillsStyle: 'chips',
      educationStyle: 'list',
      certificationsStyle: 'list',
      spacingPreset: 'comfortable',
      sectionMargin: 24,
      itemMargin: 16,
      pagePadding: 40,
      showIcons: true,
      showDividers: true,
      showProficiencyLevels: false,
      showTechnologyTags: true,
    );
  }

  static TemplateConfig _createModernTemplate() {
    return const TemplateConfig(
      layoutStyle: 'sidebar-left',
      sidebarWidth: 280,
      primaryColor: '#7C3AED',
      secondaryColor: '#EC4899',
      accentColor: '#FBBF24',
      backgroundColor: '#F3F4F6',
      surfaceColor: '#FFFFFF',
      textColor: '#111827',
      textLightColor: '#6B7280',
      headerBackgroundColor: '#7C3AED',
      sidebarBackgroundColor: '#F9FAFB',
      headingFont: 'Poppins',
      bodyFont: 'Inter',
      headingSize: 26,
      subheadingSize: 18,
      bodySize: 14,
      smallSize: 12,
      photoStyle: 'rounded',
      photoPosition: 'sidebar',
      photoSize: 120,
      photoBorder: true,
      photoBorderColor: '#7C3AED',
      headerStyle: 'left-aligned',
      showContactInHeader: false,
      contactLayout: 'column',
      experienceStyle: 'timeline',
      skillsStyle: 'list',
      educationStyle: 'card',
      certificationsStyle: 'compact',
      spacingPreset: 'relaxed',
      sectionMargin: 32,
      itemMargin: 20,
      pagePadding: 32,
      showIcons: true,
      showDividers: true,
      showProficiencyLevels: true,
      showTechnologyTags: true,
    );
  }

  static TemplateConfig _createExecutiveTemplate() {
    return const TemplateConfig(
      layoutStyle: 'single-column',
      sidebarWidth: 0,
      primaryColor: '#10B981',
      secondaryColor: '#059669',
      accentColor: '#F59E0B',
      backgroundColor: '#FFFFFF',
      surfaceColor: '#F8FAFC',
      textColor: '#1E293B',
      textLightColor: '#64748B',
      headerBackgroundColor: '#10B981',
      sidebarBackgroundColor: '#F8FAFC',
      headingFont: 'Merriweather',
      bodyFont: 'Open Sans',
      headingSize: 28,
      subheadingSize: 20,
      bodySize: 15,
      smallSize: 13,
      photoStyle: 'circle',
      photoPosition: 'header',
      photoSize: 110,
      photoBorder: true,
      photoBorderColor: '#10B981',
      headerStyle: 'left-aligned',
      showContactInHeader: true,
      contactLayout: 'row',
      experienceStyle: 'detailed',
      skillsStyle: 'chips',
      educationStyle: 'detailed',
      certificationsStyle: 'list',
      spacingPreset: 'professional',
      sectionMargin: 28,
      itemMargin: 18,
      pagePadding: 48,
      showIcons: true,
      showDividers: false,
      showProficiencyLevels: false,
      showTechnologyTags: true,
    );
  }

  static TemplateConfig _createTechTemplate() {
    return const TemplateConfig(
      layoutStyle: 'two-column',
      sidebarWidth: 0,
      primaryColor: '#EC4899',
      secondaryColor: '#BE185D',
      accentColor: '#FBBF24',
      backgroundColor: '#0F172A',
      surfaceColor: '#1E293B',
      textColor: '#F8FAFC',
      textLightColor: '#94A3B8',
      headerBackgroundColor: '#EC4899',
      sidebarBackgroundColor: '#1E293B',
      headingFont: 'Space Grotesk',
      bodyFont: 'Inter',
      headingSize: 24,
      subheadingSize: 16,
      bodySize: 13,
      smallSize: 11,
      photoStyle: 'circle',
      photoPosition: 'header',
      photoSize: 90,
      photoBorder: true,
      photoBorderColor: '#EC4899',
      headerStyle: 'centered',
      showContactInHeader: true,
      contactLayout: 'grid',
      experienceStyle: 'compact',
      skillsStyle: 'chips',
      educationStyle: 'compact',
      certificationsStyle: 'compact',
      spacingPreset: 'compact',
      sectionMargin: 20,
      itemMargin: 12,
      pagePadding: 24,
      showIcons: true,
      showDividers: true,
      showProficiencyLevels: true,
      showTechnologyTags: true,
    );
  }

  static TemplateConfig _createCreativeTemplate() {
    return const TemplateConfig(
      layoutStyle: 'sidebar-right',
      sidebarWidth: 260,
      primaryColor: '#F59E0B',
      secondaryColor: '#D97706',
      accentColor: '#7C3AED',
      backgroundColor: '#FFFBEB',
      surfaceColor: '#FFFFFF',
      textColor: '#111827',
      textLightColor: '#6B7280',
      headerBackgroundColor: '#F59E0B',
      sidebarBackgroundColor: '#FEF3C7',
      headingFont: 'Playfair Display',
      bodyFont: 'Lato',
      headingSize: 30,
      subheadingSize: 20,
      bodySize: 14,
      smallSize: 12,
      photoStyle: 'rounded',
      photoPosition: 'sidebar',
      photoSize: 140,
      photoBorder: true,
      photoBorderColor: '#F59E0B',
      headerStyle: 'creative',
      showContactInHeader: false,
      contactLayout: 'column',
      experienceStyle: 'creative',
      skillsStyle: 'tag-cloud',
      educationStyle: 'card',
      certificationsStyle: 'badge',
      spacingPreset: 'relaxed',
      sectionMargin: 36,
      itemMargin: 24,
      pagePadding: 36,
      showIcons: true,
      showDividers: false,
      showProficiencyLevels: true,
      showTechnologyTags: true,
    );
  }
}

// ============ HTML GENERATOR FOR PREVIEW ============

class HtmlGenerator {
  static String generateResumeHtml(dynamic cvData, TemplateConfig config) {
    // Get name safely
    final name = _getSafeValue(cvData, 'fullName', 'Your Name');
    final title = _getSafeValue(cvData, 'title', 'Professional Title');
    final email = _getSafeValue(cvData, 'email', 'email@example.com');
    final phone = _getSafeValue(cvData, 'phone', '+00 000 0000');
    final summary = _getSafeValue(
      cvData,
      'summary',
      'Your professional summary here...',
    );

    return '''
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>$name - Resume</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: '${config.bodyFont}', Arial, sans-serif;
            background-color: #${config.backgroundColor.replaceAll('#', '')};
            color: #${config.textColor.replaceAll('#', '')};
            line-height: 1.6;
            padding: ${config.pagePadding}px;
        }
        
        .container {
            max-width: 1100px;
            margin: 0 auto;
            background: #${config.surfaceColor.replaceAll('#', '')};
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 10px 40px rgba(0,0,0,0.1);
        }
        
        .header {
            background: #${config.headerBackgroundColor.replaceAll('#', '')};
            color: white;
            padding: ${config.sectionMargin}px;
            text-align: ${config.headerStyle == 'centered' ? 'center' : 'left'};
        }
        
        .header h1 {
            font-family: '${config.headingFont}', serif;
            font-size: ${config.headingSize}px;
            margin-bottom: 8px;
        }
        
        .header p {
            font-size: ${config.subheadingSize}px;
            opacity: 0.9;
        }
        
        .contact-info {
            display: flex;
            flex-wrap: wrap;
            justify-content: ${config.headerStyle == 'centered' ? 'center' : 'flex-start'};
            gap: 20px;
            margin-top: 16px;
            font-size: ${config.smallSize}px;
        }
        
        .contact-info span {
            display: inline-flex;
            align-items: center;
            gap: 6px;
        }
        
        .content {
            padding: ${config.sectionMargin}px;
        }
        
        .section {
            margin-bottom: ${config.sectionMargin}px;
        }
        
        .section-title {
            font-family: '${config.headingFont}', serif;
            font-size: ${config.subheadingSize}px;
            font-weight: bold;
            color: #${config.primaryColor.replaceAll('#', '')};
            margin-bottom: ${config.itemMargin}px;
            padding-bottom: 8px;
            border-bottom: ${config.showDividers ? '2px solid #' + config.primaryColor.replaceAll('#', '') : 'none'};
        }
        
        .summary-text {
            font-size: ${config.bodySize}px;
            line-height: 1.6;
        }
        
        @media print {
            body {
                padding: 0;
            }
            .no-print {
                display: none;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>$name</h1>
            <p>$title</p>
            <div class="contact-info">
                <span>📧 $email</span>
                <span>📞 $phone</span>
            </div>
        </div>
        
        <div class="content">
            <div class="section">
                <h2 class="section-title">Professional Summary</h2>
                <div class="summary-text">$summary</div>
            </div>
        </div>
    </div>
    
    <div class="no-print" style="text-align: center; margin-top: 20px; padding: 20px;">
        <button onclick="window.print()" style="padding: 10px 20px; background: #${config.primaryColor.replaceAll('#', '')}; color: white; border: none; border-radius: 8px; cursor: pointer;">
            🖨️ Save as PDF
        </button>
    </div>
</body>
</html>
    ''';
  }

  static String _getSafeValue(dynamic data, String key, String defaultValue) {
    try {
      if (data == null) return defaultValue;
      if (data is Map) {
        return data[key]?.toString() ?? defaultValue;
      }
      // Try to access as property
      final value = data.toString();
      if (value.contains(key)) {
        // Simple fallback
        return defaultValue;
      }
      return defaultValue;
    } catch (e) {
      return defaultValue;
    }
  }
}

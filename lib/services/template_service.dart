// File: lib/services/template_service.dart

import 'package:flutter/services.dart';
import '../data/models/cv_data.dart';

class TemplateService {
  static const Map<int, String> templateFileMap = {
    0: 'assets/templates/classic.html',
    1: 'assets/templates/modern.html',
    2: 'assets/templates/executive.html',
    3: 'assets/templates/tech.html',
    4: 'assets/templates/creative.html',
  };

  static String getTemplatePath(int templateIndex) {
    return templateFileMap[templateIndex] ?? templateFileMap[0]!;
  }

  static Future<String> generateHTML(CVData cvData, int templateIndex) async {
    final templatePath = getTemplatePath(templateIndex);
    String html = await rootBundle.loadString(templatePath);

    html = _replaceSimplePlaceholders(html, cvData);
    html = _replaceExperiences(html, cvData.experiences);
    html = _replaceEducations(html, cvData.educations);
    html = _replaceSkills(html, cvData.skills);

    // ✅ Section-aware replacements
    html = _replaceLanguages(html, cvData.languages);
    html = _replaceCertifications(html, cvData.certifications);
    html = _replaceProjects(html, cvData.projects);

    html = _addDefaultZoom(html);

    return html;
  }

  static String _addDefaultZoom(String html) {
    if (html.contains('<body style=')) {
      return html.replaceFirst('<body style=', '<body style="zoom: 40%; "');
    }
    return html.replaceFirst('<body', '<body style="zoom: 40%;"');
  }

  static String _replaceSimplePlaceholders(String html, CVData cvData) {
    return html
        .replaceAll('{{fullName}}', _escapeHtml(cvData.fullName))
        .replaceAll('{{title}}', _escapeHtml(cvData.title))
        .replaceAll('{{email}}', _escapeHtml(cvData.email))
        .replaceAll('{{phone}}', _escapeHtml(cvData.phone))
        .replaceAll('{{location}}', _escapeHtml(cvData.location))
        .replaceAll('{{summary}}', _escapeHtml(cvData.summary));
  }

  static String _replaceExperiences(String html, List<Experience> experiences) {
    if (experiences.isEmpty) {
      return html.replaceAll(
        RegExp(r'{{#each experiences}}[\s\S]*?{{\/each}}'),
        '',
      );
    }

    String buffer = '';
    for (var exp in experiences) {
      final startDate = _formatDate(exp.startDate);
      final endDate = exp.isCurrent ? 'Present' : _formatDate(exp.endDate);

      buffer +=
          '''
      <div class="experience-item">
          <div class="experience-header">
              <div>
                  <span class="job-title">${_escapeHtml(exp.jobTitle)}</span>
                  <span class="company"> at ${_escapeHtml(exp.company)}</span>
              </div>
              <div class="date">$startDate - $endDate</div>
          </div>
          <div class="experience-description">${_escapeHtml(exp.description)}</div>
      </div>
      ''';
    }
    return html.replaceAll(
      RegExp(r'{{#each experiences}}[\s\S]*?{{\/each}}'),
      buffer,
    );
  }

  static String _replaceEducations(String html, List<Education> educations) {
    if (educations.isEmpty) {
      return html.replaceAll(
        RegExp(r'{{#each educations}}[\s\S]*?{{\/each}}'),
        '',
      );
    }

    String buffer = '';
    for (var edu in educations) {
      final startDate = _formatDate(edu.startDate);
      final endDate = edu.endDate != null
          ? _formatDate(edu.endDate!)
          : 'Present';
      final gpaHtml = edu.gpa != null
          ? '<div class="date">GPA: ${_escapeHtml(edu.gpa!)}</div>'
          : '';

      buffer +=
          '''
      <div class="education-item">
          <div class="degree">${_escapeHtml(edu.degree)}</div>
          <div class="institution">${_escapeHtml(edu.institution)}</div>
          <div class="date">$startDate - $endDate</div>
          $gpaHtml
      </div>
      ''';
    }
    return html.replaceAll(
      RegExp(r'{{#each educations}}[\s\S]*?{{\/each}}'),
      buffer,
    );
  }

  static String _replaceSkills(String html, List<String> skills) {
    if (skills.isEmpty) {
      return html.replaceAll(RegExp(r'{{#each skills}}[\s\S]*?{{\/each}}'), '');
    }

    String buffer = '';
    for (var skill in skills) {
      buffer += '<span class="skill-tag">${_escapeHtml(skill)}</span>\n';
    }
    return html.replaceAll(
      RegExp(r'{{#each skills}}[\s\S]*?{{\/each}}'),
      buffer,
    );
  }

  // ✅ UPDATED: Remove entire languages section if empty
  static String _replaceLanguages(String html, List<Language> languages) {
    if (languages.isEmpty) {
      // Remove the entire section block
      return html.replaceAll(
        RegExp(r'{{#section languages}}[\s\S]*?{{\/section languages}}'),
        '',
      );
    }

    String buffer = '';
    for (var lang in languages) {
      buffer +=
          '<span class="language-item">${_escapeHtml(lang.name)} - ${_escapeHtml(lang.proficiencyLevel)}</span>\n';
    }

    // Remove section tags and replace content
    return html
        .replaceAll('{{#section languages}}', '')
        .replaceAll('{{/section languages}}', '')
        .replaceAll(RegExp(r'{{#each languages}}[\s\S]*?{{\/each}}'), buffer);
  }

  // ✅ UPDATED: Remove entire certifications section if empty
  static String _replaceCertifications(
    String html,
    List<Certification> certifications,
  ) {
    if (certifications.isEmpty) {
      return html.replaceAll(
        RegExp(
          r'{{#section certifications}}[\s\S]*?{{\/section certifications}}',
        ),
        '',
      );
    }

    String buffer = '';
    for (var cert in certifications) {
      buffer +=
          '''
      <div class="certification-item">
          <div class="cert-name">${_escapeHtml(cert.name)}</div>
          <div class="cert-issuer">${_escapeHtml(cert.issuer)}</div>
      </div>
      ''';
    }

    return html
        .replaceAll('{{#section certifications}}', '')
        .replaceAll('{{/section certifications}}', '')
        .replaceAll(
          RegExp(r'{{#each certifications}}[\s\S]*?{{\/each}}'),
          buffer,
        );
  }

  // ✅ UPDATED: Remove entire projects section if empty
  static String _replaceProjects(String html, List<Project> projects) {
    if (projects.isEmpty) {
      return html.replaceAll(
        RegExp(r'{{#section projects}}[\s\S]*?{{\/section projects}}'),
        '',
      );
    }

    String buffer = '';
    for (var proj in projects) {
      buffer +=
          '''
      <div class="project-item">
          <div class="project-name">${_escapeHtml(proj.name)}</div>
          <div class="experience-description">${_escapeHtml(proj.description)}</div>
      </div>
      ''';
    }

    return html
        .replaceAll('{{#section projects}}', '')
        .replaceAll('{{/section projects}}', '')
        .replaceAll(RegExp(r'{{#each projects}}[\s\S]*?{{\/each}}'), buffer);
  }

  static String _escapeHtml(String text) {
    return text
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#39;');
  }

  static String _formatDate(DateTime? date) {
    if (date == null) return '';
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}

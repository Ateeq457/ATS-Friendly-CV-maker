import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../core/engine/cv_renderer.dart';
import '../core/templates/template_config.dart';
import '../data/models/cv_data_model.dart';

class PDFExportService {
  static Future<Uint8List> generatePdfFromWidget({
    required CVDataModel cvData,
    required TemplateConfig config,
    required BuildContext context,
  }) async {
    try {
      final pdf = pw.Document();
      final pageFormat = PdfPageFormat.a4;

      pdf.addPage(
        pw.MultiPage(
          pageFormat: pageFormat,
          margin: const pw.EdgeInsets.all(40),
          build: (pw.Context context) {
            return [
              // ========== HEADER ==========
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text(
                    cvData.personalInfo.fullName.toUpperCase(),
                    style: pw.TextStyle(
                      fontSize: 22,
                      fontWeight: pw.FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  pw.SizedBox(height: 6),
                  pw.Text(
                    'Flutter Developer | Frontend Engineer',
                    style: pw.TextStyle(
                      fontSize: 12,
                      color: PdfColors.grey700,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text(
                    '${cvData.personalInfo.phone} | ${cvData.personalInfo.email} | linkedin.com/in/ateeq-ur-rehman-7b866235b',
                    style: pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
                  ),
                  pw.SizedBox(height: 12),
                  pw.Divider(),
                ],
              ),

              // ========== PROFESSIONAL SUMMARY ==========
              if (cvData.personalInfo.summary.isNotEmpty) ...[
                pw.Text(
                  'PROFESSIONAL SUMMARY',
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.grey800,
                    letterSpacing: 0.5,
                  ),
                ),
                pw.SizedBox(height: 6),
                pw.Text(
                  cvData.personalInfo.summary,
                  style: pw.TextStyle(fontSize: 10, height: 1.4),
                ),
                pw.SizedBox(height: 20),
              ],

              // ========== TECHNICAL SKILLS ==========
              if (cvData.skills.isNotEmpty) ...[
                pw.Text(
                  'TECHNICAL SKILLS',
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.grey800,
                    letterSpacing: 0.5,
                  ),
                ),
                pw.SizedBox(height: 8),
                pw.Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: cvData.skills
                      .map(
                        (skill) => pw.Container(
                          padding: const pw.EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: pw.BoxDecoration(
                            color: PdfColors.grey100,
                            borderRadius: pw.BorderRadius.circular(4),
                          ),
                          child: pw.Text(
                            skill,
                            style: pw.TextStyle(fontSize: 9),
                          ),
                        ),
                      )
                      .toList(),
                ),
                pw.SizedBox(height: 20),
              ],

              // ========== PROFESSIONAL EXPERIENCE ==========
              if (cvData.experiences.isNotEmpty) ...[
                pw.Text(
                  'PROFESSIONAL EXPERIENCE',
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.grey800,
                    letterSpacing: 0.5,
                  ),
                ),
                pw.SizedBox(height: 10),
                ...cvData.experiences.map(
                  (exp) => pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        exp.jobTitle,
                        style: pw.TextStyle(
                          fontSize: 11,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 2),
                      pw.Text(
                        '${exp.companyName} — ${exp.isCurrent ? 'Onsite' : 'Remote'} *${_formatDate(exp.startDate)} -- ${exp.isCurrent ? 'Present' : _formatDate(exp.endDate)}*',
                        style: pw.TextStyle(
                          fontSize: 9,
                          color: PdfColors.grey600,
                          fontStyle: pw.FontStyle.italic,
                        ),
                      ),
                      pw.SizedBox(height: 6),
                      pw.Text(
                        exp.description,
                        style: pw.TextStyle(fontSize: 9, height: 1.4),
                      ),
                      pw.SizedBox(height: 14),
                    ],
                  ),
                ),
              ],

              // ========== PROJECTS ==========
              if (cvData.projects.isNotEmpty) ...[
                pw.Text(
                  'PROJECTS',
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.grey800,
                    letterSpacing: 0.5,
                  ),
                ),
                pw.SizedBox(height: 10),
                ...cvData.projects.map(
                  (project) => pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        project.name,
                        style: pw.TextStyle(
                          fontSize: 11,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        project.description,
                        style: pw.TextStyle(fontSize: 9, height: 1.4),
                      ),
                      if (project.technologies != null)
                        pw.Padding(
                          padding: const pw.EdgeInsets.only(top: 4),
                          child: pw.Text(
                            'Tech: ${project.technologies}',
                            style: pw.TextStyle(
                              fontSize: 8,
                              color: PdfColors.grey600,
                              fontStyle: pw.FontStyle.italic,
                            ),
                          ),
                        ),
                      pw.SizedBox(height: 12),
                    ],
                  ),
                ),
              ],

              // ========== EDUCATION ==========
              if (cvData.educations.isNotEmpty) ...[
                pw.Text(
                  'EDUCATION',
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.grey800,
                    letterSpacing: 0.5,
                  ),
                ),
                pw.SizedBox(height: 8),
                ...cvData.educations.map(
                  (edu) => pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        edu.degree,
                        style: pw.TextStyle(
                          fontSize: 11,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        edu.institution,
                        style: pw.TextStyle(
                          fontSize: 9,
                          color: PdfColors.grey700,
                        ),
                      ),
                      if (edu.grade != null)
                        pw.Text(
                          edu.grade!,
                          style: pw.TextStyle(
                            fontSize: 9,
                            color: PdfColors.grey600,
                          ),
                        ),
                      pw.SizedBox(height: 8),
                    ],
                  ),
                ),
              ],

              // ========== ACHIEVEMENTS / CERTIFICATIONS ==========
              if (cvData.certifications.isNotEmpty) ...[
                pw.Text(
                  'ACHIEVEMENTS',
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.grey800,
                    letterSpacing: 0.5,
                  ),
                ),
                pw.SizedBox(height: 8),
                ...cvData.certifications.map(
                  (cert) => pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('• ', style: pw.TextStyle(fontSize: 10)),
                      pw.Expanded(
                        child: pw.Text(
                          cert.name,
                          style: pw.TextStyle(fontSize: 9, height: 1.3),
                        ),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 20),
              ],
            ];
          },
        ),
      );

      return await pdf.save();
    } catch (e) {
      print('Error generating PDF: $e');
      rethrow;
    }
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

  static Future<File> savePdfToDevice(
    Uint8List pdfBytes,
    String fileName,
  ) async {
    final directory = await getApplicationDocumentsDirectory();
    final safeFileName = fileName.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_');
    final file = File('${directory.path}/$safeFileName.pdf');
    await file.writeAsBytes(pdfBytes);
    return file;
  }

  static Future<File> generateAndSave({
    required CVDataModel cvData,
    required TemplateConfig config,
    required BuildContext context,
    required String fileName,
  }) async {
    final pdfBytes = await generatePdfFromWidget(
      cvData: cvData,
      config: config,
      context: context,
    );
    return await savePdfToDevice(pdfBytes, fileName);
  }

  static Future<void> sharePdf(File pdfFile) async {
    await Share.shareXFiles([
      XFile(pdfFile.path),
    ], text: 'Check out my professional CV!');
  }
}

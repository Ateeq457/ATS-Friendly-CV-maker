import 'package:flutter/material.dart';
import '../../core/constants/design_system.dart';
import '../../data/models/template_model.dart';
import '../widgets/zoomable_image.dart';

class TemplatePreviewScreen extends StatefulWidget {
  final TemplateModel template;

  const TemplatePreviewScreen({super.key, required this.template});

  @override
  State<TemplatePreviewScreen> createState() => _TemplatePreviewScreenState();
}

class _TemplatePreviewScreenState extends State<TemplatePreviewScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.grey[50],
      appBar: _buildAppBar(context, isDark),
      body: ZoomableImage(maxScale: 4.0, child: _buildPreviewContent(context)),
      floatingActionButton: _buildFloatingUseButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, bool isDark) {
    return AppBar(
      title: Text(
        widget.template.name,
        style: TextStyle(color: isDark ? Colors.white : Colors.black87),
      ),
      centerTitle: true,
      backgroundColor: isDark
          ? Colors.black.withOpacity(0.8)
          : Colors.white.withOpacity(0.95),
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.close, color: isDark ? Colors.white : Colors.black87),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.share,
            color: isDark ? Colors.white : Colors.black87,
          ),
          onPressed: () => _shareTemplate(context),
        ),
        IconButton(
          icon: Icon(
            Icons.info_outline,
            color: isDark ? Colors.white : Colors.black87,
          ),
          onPressed: () => _showInfoDialog(context),
        ),
      ],
    );
  }

  Widget _buildPreviewContent(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.circular(DesignSystem.radiusLarge),
          border: Border.all(
            color: widget.template.color.withOpacity(isDark ? 0.5 : 0.3),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.3)
                  : Colors.black.withOpacity(0.08),
              blurRadius: 30,
              offset: const Offset(0, 10),
              spreadRadius: isDark ? 0 : 2,
            ),
            // ✅ Extra blurry shadow for white mode
            if (!isDark)
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 50,
                offset: const Offset(0, 15),
              ),
          ],
        ),
        child: Stack(
          children: [
            // Dummy CV Content
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: widget.template.color.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      widget.template.icon,
                      size: 40,
                      color: widget.template.color,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    height: 8,
                    color: widget.template.color.withOpacity(0.25),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 200,
                    height: 6,
                    color: widget.template.color.withOpacity(0.15),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    width: double.infinity,
                    height: 4,
                    color: isDark ? Colors.grey[700] : Colors.grey[300],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    height: 4,
                    color: isDark ? Colors.grey[700] : Colors.grey[300],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 180,
                    height: 4,
                    color: isDark ? Colors.grey[700] : Colors.grey[300],
                  ),
                ],
              ),
            ),
            // Template Tag Badge
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: widget.template.color,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: widget.template.color.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  widget.template.tag,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            // Instruction text at bottom
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.black.withOpacity(0.7)
                        : Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Pinch to zoom • Double tap to reset',
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? Colors.white70 : Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingUseButton(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            widget.template.color,
            widget.template.color.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(DesignSystem.radiusCircular),
        boxShadow: [
          BoxShadow(
            color: widget.template.color.withOpacity(0.4),
            blurRadius: isDark ? 20 : 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: FloatingActionButton.extended(
        onPressed: () => _useTemplate(context),
        icon: const Icon(Icons.check_circle, size: 22),
        label: const Text(
          'Use This Template',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }

  void _shareTemplate(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Share ${widget.template.name} coming soon!')),
    );
  }

  void _showInfoDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? Colors.grey[900] : Colors.white,
        title: Text(
          'About Template',
          style: TextStyle(color: isDark ? Colors.white : Colors.black87),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Template: ${widget.template.name}',
              style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
            ),
            const SizedBox(height: 8),
            Text(
              '• ATS-friendly format',
              style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
            ),
            Text(
              '• Recruiter approved',
              style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
            ),
            Text(
              '• One-click customization',
              style: TextStyle(color: isDark ? Colors.white70 : Colors.black54),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _useTemplate(BuildContext context) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Creating CV with ${widget.template.name} template...'),
        backgroundColor: Colors.green,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:zoom_widget/zoom_widget.dart';
import '../../core/engine/cv_renderer.dart';
import '../../core/templates/template_config.dart';
import '../../data/models/cv_data_model.dart';
import '../../services/pdf_export_service.dart';

class PreviewScreen extends StatefulWidget {
  final CVDataModel cvData;
  final TemplateConfig config;

  const PreviewScreen({super.key, required this.cvData, required this.config});

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  int _totalPages = 1;
  bool _isGeneratingPdf = false;
  double _zoomLevel = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: _buildAppBar(context),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('Preview - ${widget.config.name}'),
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.zoom_in),
          onPressed: () =>
              setState(() => _zoomLevel = (_zoomLevel + 0.25).clamp(0.5, 3.0)),
          tooltip: 'Zoom In',
        ),
        IconButton(
          icon: const Icon(Icons.zoom_out),
          onPressed: () =>
              setState(() => _zoomLevel = (_zoomLevel - 0.25).clamp(0.5, 3.0)),
          tooltip: 'Zoom Out',
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: _isGeneratingPdf
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.download),
          onPressed: _isGeneratingPdf ? null : () => _downloadPDF(context),
          tooltip: 'Download PDF',
        ),
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () => _sharePDF(context),
          tooltip: 'Share',
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        // Page counter
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            'Page ${_currentPage + 1} of $_totalPages',
            style: const TextStyle(fontSize: 14),
          ),
        ),
        // Zoomable A4 Page Container
        Expanded(
          child: Center(
            child: InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: Container(
                width: 400,
                height: 566, // A4 aspect ratio (210mm x 297mm ≈ 400 x 566)
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
                  children: _buildPages(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildPages() {
    // Split content into multiple A4 pages
    // For now, return single page with all content
    return [
      SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: CVRenderer(cvData: widget.cvData, config: widget.config),
      ),
    ];
  }

  Widget _buildBottomNavBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.first_page),
            onPressed: _currentPage > 0 ? () => _goToPage(0) : null,
          ),
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: _currentPage > 0 ? () => _previousPage() : null,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_currentPage + 1} / $_totalPages',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: _currentPage < _totalPages - 1
                ? () => _nextPage()
                : null,
          ),
          IconButton(
            icon: const Icon(Icons.last_page),
            onPressed: _currentPage < _totalPages - 1
                ? () => _goToPage(_totalPages - 1)
                : null,
          ),
        ],
      ),
    );
  }

  void _previousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _goToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _downloadPDF(BuildContext context) async {
    setState(() => _isGeneratingPdf = true);

    try {
      final fileName = widget.cvData.personalInfo.fullName.replaceAll(' ', '_');

      final file = await PDFExportService.generateAndSave(
        cvData: widget.cvData,
        config: widget.config,
        context: context,
        fileName: fileName,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PDF saved: ${file.path.split('/').last}'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isGeneratingPdf = false);
    }
  }

  Future<void> _sharePDF(BuildContext context) async {
    setState(() => _isGeneratingPdf = true);

    try {
      final fileName = widget.cvData.personalInfo.fullName.replaceAll(' ', '_');

      final file = await PDFExportService.generateAndSave(
        cvData: widget.cvData,
        config: widget.config,
        context: context,
        fileName: fileName,
      );

      await PDFExportService.sharePdf(file);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error sharing: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isGeneratingPdf = false);
    }
  }
}

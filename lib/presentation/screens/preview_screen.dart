// File: lib/presentation/screens/preview_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../data/models/cv_data.dart';
import '../../services/template_service.dart';

class PreviewScreen extends StatefulWidget {
  final CVData cvData;
  final int templateIndex;

  const PreviewScreen({
    super.key,
    required this.cvData,
    required this.templateIndex,
  });

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  late final WebViewController _controller;

  bool _isLoading = true;
  bool _isExporting = false;
  String? _html;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    _html = await TemplateService.generateHTML(
      widget.cvData,
      widget.templateIndex,
    );

    _html = _injectMeta(_html!);
    _html = _injectPrintCSS(_html!);

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            setState(() => _isLoading = false);
            _controller.runJavaScript('document.body.style.zoom="45%"');
          },
        ),
      )
      ..setBackgroundColor(Colors.white);

    await _controller.loadHtmlString(_html!);
  }

  String _injectMeta(String html) {
    if (html.contains('<meta name="viewport"')) return html;
    return html.replaceFirst(
      '<head>',
      '<head><meta name="viewport" content="width=device-width, initial-scale=1.0">',
    );
  }

  String _injectPrintCSS(String html) {
    const css = '''
    <style>
      @media print {
        body { zoom: 100%; margin:0; padding:0; }
        .no-print { display:none !important; }
        .resume-container { box-shadow:none; margin:0; }
      }
    </style>
    ''';

    return html.contains('</head>')
        ? html.replaceFirst('</head>', '$css</head>')
        : html;
  }

  // 🔥 MAIN EXPORT FLOW (NO SERVER - PROFESSIONAL UX)
  Future<void> _exportPDF() async {
    if (_html == null) return;

    setState(() => _isExporting = true);

    try {
      final dir = await getApplicationDocumentsDirectory();

      final fileName = '${widget.cvData.fullName.replaceAll(' ', '_')}.html';

      final file = File('${dir.path}/$fileName');

      await file.writeAsString(_html!);

      // 👇 UX delay (smooth feel)
      await Future.delayed(const Duration(milliseconds: 300));

      // 👇 Instruction dialog
      if (mounted) {
        await _showInstructionDialog();
      }

      // 🔥 OPEN FILE (BEST METHOD)
      final result = await OpenFilex.open(file.path);

      if (result.type != ResultType.done) {
        _showSnack("Could not open file", Colors.red);
      } else {
        _showSnack("Opened in browser", Colors.green);
      }
    } catch (e) {
      _showSnack(e.toString(), Colors.red);
    }

    setState(() => _isExporting = false);
  }

  // 🔥 CLEAN INSTRUCTION DIALOG
  Future<void> _showInstructionDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text("Save as PDF"),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Follow these steps:"),
              SizedBox(height: 12),
              Text("1️⃣ Tap menu (⋮)"),
              Text("2️⃣ Select Print"),
              Text("3️⃣ Choose Save as PDF"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Got it"),
            ),
          ],
        );
      },
    );
  }

  void _showSnack(String msg, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: color));
  }

  void _zoomIn() {
    _controller.runJavaScript(
      'document.body.style.zoom=(parseFloat(document.body.style.zoom||0.45)+0.1)',
    );
  }

  void _zoomOut() {
    _controller.runJavaScript(
      'document.body.style.zoom=(parseFloat(document.body.style.zoom||0.45)-0.1)',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        title: const Text("CV Preview"),
        centerTitle: true,
        actions: [
          IconButton(onPressed: _zoomIn, icon: const Icon(Icons.zoom_in)),
          IconButton(onPressed: _zoomOut, icon: const Icon(Icons.zoom_out)),
        ],
      ),

      body: Stack(
        children: [
          if (!_isLoading) WebViewWidget(controller: _controller),

          if (_isLoading)
            const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 12),
                  Text("Rendering your CV..."),
                ],
              ),
            ),
        ],
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(blurRadius: 10, color: Colors.black.withOpacity(0.05)),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Edit"),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: _isExporting ? null : _exportPDF,
                  icon: _isExporting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.picture_as_pdf),

                  label: Text(_isExporting ? "Preparing..." : "Export PDF"),

                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

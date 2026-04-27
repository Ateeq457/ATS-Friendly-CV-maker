import 'dart:io';

import 'package:android_cv_maker/models/cv_data.dart';

import 'package:android_cv_maker/core/config/template_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
  late final WebViewController _webViewController;
  bool _isLoading = true;
  bool _isGenerating = false;
  late TemplateConfig _templateConfig;

  @override
  void initState() {
    super.initState();
    _templateConfig = TemplateGenerator.getTemplateById(
      widget.templateIndex.toString(),
    );
    _initWebView();
  }

  Future<void> _initWebView() async {
    final html = HtmlGenerator.generateResumeHtml(
      widget.cvData,
      _templateConfig,
    );

    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            setState(() => _isLoading = false);
          },
          onWebResourceError: (error) {
            print('WebView error: ${error.description}');
            setState(() => _isLoading = false);
          },
        ),
      );

    await _webViewController.loadHtmlString(html);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text('Preview - ${_templateConfig.layoutStyle}'),
      centerTitle: true,
      actions: [
        IconButton(
          icon: _isGenerating
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.download),
          onPressed: _isGenerating ? null : () => _downloadHTML(),
          tooltip: 'Download HTML',
        ),
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () => _shareHTML(),
          tooltip: 'Share',
        ),
        IconButton(
          icon: const Icon(Icons.print),
          onPressed: () => _printCV(),
          tooltip: 'Print / Save as PDF',
        ),
      ],
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return WebViewWidget(controller: _webViewController);
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.2))),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back to Edit'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: ElevatedButton.icon(
                onPressed: _printCV,
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text('Save as PDF'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _downloadHTML() async {
    setState(() => _isGenerating = true);

    try {
      final html = HtmlGenerator.generateResumeHtml(
        widget.cvData,
        _templateConfig,
      );
      final directory = await getApplicationDocumentsDirectory();
      final fileName =
          '${widget.cvData.fullName.replaceAll(' ', '_')}_resume.html';
      final file = File('${directory.path}/$fileName');
      await file.writeAsString(html);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Saved: $fileName'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isGenerating = false);
    }
  }

  Future<void> _shareHTML() async {
    setState(() => _isGenerating = true);

    try {
      final html = HtmlGenerator.generateResumeHtml(
        widget.cvData,
        _templateConfig,
      );
      final directory = await getTemporaryDirectory();
      final fileName =
          '${widget.cvData.fullName.replaceAll(' ', '_')}_resume.html';
      final file = File('${directory.path}/$fileName');
      await file.writeAsString(html);

      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Check out my resume!',
        subject: widget.cvData.fullName,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isGenerating = false);
    }
  }

  Future<void> _printCV() async {
    setState(() => _isGenerating = true);

    try {
      final html = HtmlGenerator.generateResumeHtml(
        widget.cvData,
        _templateConfig,
      );

      // Create a temporary HTML file
      final directory = await getTemporaryDirectory();
      final fileName =
          '${widget.cvData.fullName.replaceAll(' ', '_')}_resume.html';
      final file = File('${directory.path}/$fileName');
      await file.writeAsString(html);

      // Share the file - user can open and print
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Open this file and press Ctrl+P (Cmd+P) to save as PDF',
        subject: '${widget.cvData.fullName} - Resume',
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'HTML file shared. Open and use browser print to save as PDF.',
          ),
          duration: Duration(seconds: 3),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() => _isGenerating = false);
    }
  }
}

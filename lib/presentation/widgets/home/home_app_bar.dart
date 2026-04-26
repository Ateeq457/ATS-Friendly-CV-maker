import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/themes/theme_provider.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return AppBar(
      title: const Text(
        'CV Builder Pro',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      centerTitle: false,
      actions: [
        IconButton(
          icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
          onPressed: () => themeProvider.toggleTheme(),
        ),
        IconButton(
          icon: const Icon(Icons.help_outline),
          onPressed: () => _showHelpDialog(context),
        ),
      ],
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('How to use CV Builder Pro'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('1. Choose a template'),
            SizedBox(height: 8),
            Text('2. Fill your details (Experience, Education, Skills)'),
            SizedBox(height: 8),
            Text('3. Preview your CV'),
            SizedBox(height: 8),
            Text('4. Download as PDF or Share'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

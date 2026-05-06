import 'package:android_cv_maker/data/local/cv_storage.dart';
import 'package:android_cv_maker/services/refresh_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/themes/theme_provider.dart';
import 'core/themes/app_theme.dart';
import 'presentation/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CVStorage().migrateOldData();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => RefreshService()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'CV Builder Pro',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.isDarkMode
                ? ThemeMode.dark
                : ThemeMode.light,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}

// main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:khetibari/screens/landing_page.dart';
import 'package:khetibari/services/data_service.dart';
import 'package:khetibari/services/marketplace_service.dart';
import 'package:khetibari/services/pest_identification_service.dart';
import 'package:khetibari/screens/firebase_init.dart';
import 'package:khetibari/screens/auth_wrapper.dart';
import 'package:khetibari/providers/language_provider.dart';
import 'package:khetibari/providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase on all platforms
  await FirebaseInitializer.init();

  // Initialize Hive (A2 requirement)
  await DataService.initialize();

  // Initialize marketplace mock data
  await MarketplaceService.initialize();

  // Initialize Pest Identification AI Service with Gemini API key
  // IMPORTANT: Use a dedicated Gemini API key from Google AI Studio
  // Get it from: https://aistudio.google.com/app/apikey
  // Firebase API key has limitations and won't work with Gemini
  const geminiApiKey =
      'AIzaSyBGv1lW5yn1go-r8v3RyhxAgt4OFfMCSBQ'; // Gemini API key configured
  PestIdentificationService.setApiKey(geminiApiKey);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LanguageProvider()..initialize(),
        ),
        ChangeNotifierProvider(
          create: (context) => ThemeProvider()..initialize(),
        ),
      ],
      child: Consumer2<ThemeProvider, LanguageProvider>(
        builder: (context, themeProvider, languageProvider, child) {
          return MaterialApp(
            title: 'Khetibari: HarvestGuard',
            debugShowCheckedModeBanner: false,
            theme: ThemeProvider.getLightTheme(),
            darkTheme: ThemeProvider.getDarkTheme(),
            themeMode:
                themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,

            // Start with LandingPage - users can navigate to Login/Signup from there
            home: const LandingPage(),

            routes: {
              '/landing': (context) => const LandingPage(),
              '/home': (context) => const AuthWrapper(), // Protected route
            },
          );
        },
      ),
    );
  }
}

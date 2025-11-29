// main.dart

import 'package:flutter/material.dart';
import 'package:khetibari/screens/landing_page.dart';
import 'package:khetibari/services/data_service.dart';
import 'package:khetibari/services/marketplace_service.dart';
import 'package:khetibari/screens/firebase_init.dart';
import 'package:khetibari/screens/auth_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase on all platforms
  await FirebaseInitializer.init();

  // Initialize Hive (A2 requirement)
  await DataService.initialize();

  // Initialize marketplace mock data
  await MarketplaceService.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Khetibari: HarvestGuard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Shonar Bangla', 
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 16.0),
          bodyMedium: TextStyle(fontSize: 14.0),
        ),
      ),

      // Start with LandingPage - users can navigate to Login/Signup from there
      home: const LandingPage(),

      routes: {
        '/landing': (context) => LandingPage(),
        '/home': (context) => const AuthWrapper(), // Protected route
      },
    );
  }
}

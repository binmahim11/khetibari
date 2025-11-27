// main.dart

import 'package:flutter/material.dart';
import 'package:khetibari/screens/landing_page.dart';
import 'package:khetibari/services/data_service.dart';
import 'package:khetibari/services/marketplace_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DataService.initialize(); // Initialize Hive for A2
  await MarketplaceService.initialize(); // Initialize marketplace with mock data
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Khetibari: HarvestGuard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Shonar Bangla', // Use a suitable Bangla font
        visualDensity: VisualDensity.adaptivePlatformDensity,
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: 16.0),
          bodyMedium: TextStyle(fontSize: 14.0),
        ),
      ),
      home: LandingPage(),
      // Define all routes here (if needed, or use MaterialPageRoute)
      routes: {
        '/landing': (context) => LandingPage(),
        // '/registration': (context) => RegistrationPage(),
        // '/scanner': (context) => ScannerPage(),
      },
    );
  }
}

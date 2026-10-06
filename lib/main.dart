import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'screens/welcome_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://gzsdsccapllttiznmkxr.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imd6c2RzY2NhcGxsdHRpem5ta3hyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODM3MzYyMTMsImV4cCI6MjA5OTMxMjIxM30.7YiDUwrupnMVp47WypaERm86R48yAVLSFzAySRVqGrI',
  );

  runApp(const AcademicAssistant());
}

class AcademicAssistant extends StatelessWidget {
  const AcademicAssistant({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Academic Assistant',

      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Poppins',

        primaryColor: const Color(0xFF6C63FF),

        scaffoldBackgroundColor: const Color(0xFFF8F8FF),

        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6C63FF),
        ),

        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF6C63FF),
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 0,
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF6C63FF),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 55),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(18),
              ),
            ),
          ),
        ),
      ),

      home: const WelcomeScreen(),
    );
  }
}
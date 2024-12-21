import 'package:dil_se_lottry/UI/SplashScreen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DilSeLottry',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: TextTheme(
          headlineLarge: GoogleFonts.inika(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
          headlineMedium: GoogleFonts.inika(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          bodyLarge: GoogleFonts.inika(fontSize: 18, color: Colors.white70),
          bodyMedium: GoogleFonts.inika(fontSize: 16, color: Colors.white70),
        )
      ),
      home: SplashScreen()
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black87,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Center(
              child: LottieBuilder.asset(
                height: 300,
                width: 300,
                'assets/lotties/loginLottie.json'
              ),
            ),
            Text(
              "Dil Se Login",
              style: GoogleFonts.ruthie(
                fontSize: 72,
                color: Colors.white
              ),
            )
            
          ],
        ),
      ),
    );
  }
}
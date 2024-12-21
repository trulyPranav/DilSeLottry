import 'package:dil_se_lottry/UI/Landing%20Screen/landing_screen.dart';
import 'package:dil_se_lottry/UI/LoginScreen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  leavingFunction(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? firstTime = prefs.getBool('firstTime');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen()
      )
    );
    if (firstTime == null || firstTime == true) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LandingScreen()),
      );
    }    
  }

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 5000), () {
      leavingFunction(context);
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey[200],
        child: Center(
          child: Lottie.asset(
            height: 200,
            width: 200,
            'assets/lotties/splashLottie.json'
          ),
        ),
      ),
    );
  }
}
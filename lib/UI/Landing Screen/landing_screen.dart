import 'package:dil_se_lottry/UI/Landing%20Screen/LandingCard/landing_card.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  final intokey = GlobalKey<IntroductionScreenState>();
  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      globalBackgroundColor: Colors.black87,
      key: intokey,
      pages: [
        PageViewModel(
          title: "",
          decoration: PageDecoration(bodyAlignment: Alignment.center),
          bodyWidget: landingCard(
            context,
            "Welcome to DilSeLottry",
            "DiSeLottry is a decentralised platform for Lottery Distribution, benefitting Lottery Vendors and Lottery Consumers alike"  
          )
        ),
        PageViewModel(
          title: "",
          decoration: PageDecoration(bodyAlignment: Alignment.center),
          bodyWidget: landingCard(
            context,
            "How DilSeLottry Works",
            "blah blah blah"
          )
        ),
        PageViewModel(
          title: "",
          decoration: PageDecoration(bodyAlignment: Alignment.center),
          bodyWidget: landingCard(
            context,
            "For Buyers and Sellers Alike!",
            "blah blah blah",
            extra: getStartButton(context)
          )
        )
      ],
      skip: Text(
        'Skip',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.amberAccent,
          fontSize: 16,
        ),
      ),
      done: Text(''),
      showNextButton: false,
      dotsDecorator: DotsDecorator(
        activeColor: Colors.amberAccent,
        size: Size(8.0, 8.0),
        color: Colors.white10,
      ),
      onDone: () => onIntroEnd(context),          
    );
  }
  Widget getStartButton(BuildContext context) {
    return Container(
      width: 250.00,
      padding: const EdgeInsets.fromLTRB(10, 32, 10, 0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black87,
            shape: const StadiumBorder(),
            elevation: 10
          ),
        onPressed: () => onIntroEnd(context),
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Get Started",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                width: 16,
              ),
              Icon(
                Icons.arrow_forward,
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
  }
}

void onIntroEnd(context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('firstTime', false);
  Navigator.of(context).pop();
}
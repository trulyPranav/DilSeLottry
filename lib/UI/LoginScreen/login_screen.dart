import 'dart:convert';

import 'package:dil_se_lottry/UI/BuyerScreen/buyer_screen.dart';
import 'package:dil_se_lottry/UI/SellerScreen/seller_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_animated_button/flutter_animated_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String api = "https://hft-backend.onrender.com/seller/generate-id";
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  String _userType = 'Buyer';
  bool _isBuyer = true;
  final List<Map<String, dynamic>> _userTypes = [
    {'label': 'Buyer', 'value': 'Buyer', 'icon': Icons.person},
    {'label': 'Vendor', 'value': 'Vendor', 'icon': Icons.store},
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black87,
        body: SingleChildScrollView(
          child: Column(
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
              ),
              TextField(
                keyboardType: TextInputType.text,
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20)
                  )
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20)
                  )
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              DropdownButtonFormField(
                items: _userTypes.map<DropdownMenuItem<String>>((userType) {
                  return DropdownMenuItem<String>(
                    value: userType['value'],
                    child: Row(
                      children: [
                        Icon(userType['icon'], color: Colors.blue),
                        SizedBox(width: 20),
                        Text(userType['label'], style: TextStyle(color: Colors.amberAccent, fontWeight: FontWeight.w600),),
                      ]
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _userType = newValue!;
                    _isBuyer = newValue == 'Buyer';
                  });
                },
                borderRadius: BorderRadius.circular(20),
                focusColor: Colors.black87,
                decoration: InputDecoration(
                  labelText: 'select role',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20)
                  )
                ),
              ),
              const SizedBox(
                height: 30
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AnimatedButton(
                    height: 50,
                    width: 170,
                    animationDuration: Durations.long1,
                    backgroundColor: Colors.black,
                    selectedTextColor: Colors.black,
                    transitionType: TransitionType.CENTER_LR_OUT,
                    animatedOn: AnimatedOn.onTap,
                    selectedBackgroundColor: Colors.white,
                    borderColor: Colors.white,
                    borderRadius: 20,
                    borderWidth: 1,
                    textStyle: GoogleFonts.inika(
                      color: Colors.white
                    ),
                    text: "Login",
                    onPress: (){
                      if(_isBuyer){
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const BuyerScreen())
                        );
                      } else {
                        fetchSellerID();
                      }
                    }
                  ),
                  AnimatedButton(
                    height: 50,
                    width: 170,
                    animationDuration: Durations.long1,
                    backgroundColor: Colors.black,
                    selectedTextColor: Colors.black,
                    transitionType: TransitionType.CENTER_LR_OUT,
                    animatedOn: AnimatedOn.onTap,
                    selectedBackgroundColor: Colors.white,
                    borderColor: Colors.white,
                    borderRadius: 20,
                    borderWidth: 1,
                    textStyle: GoogleFonts.inika(
                      color: Colors.white
                    ),
                    text: "Register",
                    onPress: (){}
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  Future<void> fetchSellerID() async {
    final uri = Uri.parse(api);
    try {
      final response = await http.get(uri);
      if(response.statusCode == 200){
        Map<String, dynamic> responseData = jsonDecode(response.body);
        String id = responseData['sellerId'];
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SellerScreen(qRSellerID: id))
        );
      } else {
        print("Request failed with Status: ${response.statusCode}");
      }
    } catch (e) {
      print(e);
    }
  }
}
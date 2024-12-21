import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:qr_flutter/qr_flutter.dart';

class SellerScreen extends StatefulWidget {
  final String qRSellerID;
  const SellerScreen({
    required this.qRSellerID,
    super.key
    });

  @override
  State<SellerScreen> createState() => _SellerScreenState();
}

class _SellerScreenState extends State<SellerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height : 30,
            ),
            Text(
              "Welcome ${widget.qRSellerID}",
              style: GoogleFonts.inika(
                fontSize: 32
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Center(
              child: QrImageView(
                backgroundColor: Colors.white,
                data: widget.qRSellerID,
                version: QrVersions.auto,
                size: 200.0,
              ),
            ),
            SizedBox(
              height: 40
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: (){},
                  child: Text("View Story")
                ),
                ElevatedButton(
                  onPressed: (){},
                  child: Text("View Lotteries")
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 0.0),
              child: Lottie.asset(
                height: 300,
                width: 300,
                'assets/lotties/helloLottie.json'
              ),
            )
          ],
        ),
      ),
    );
  }
}
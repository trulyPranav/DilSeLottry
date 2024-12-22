import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:dil_se_lottry/UI/BuyerScreen/LotteryScreen/lottery_screen.dart';
import 'package:dil_se_lottry/UI/BuyerScreen/qr.dart'; // Import QrCodeScanner

class BuyerScreen extends StatefulWidget {
  final dynamic buyerID;
  const BuyerScreen({
    required this.buyerID,
    super.key,
  });

  @override
  State<BuyerScreen> createState() => _BuyerScreenState();
}

class _BuyerScreenState extends State<BuyerScreen> {
  String api = "https://hft-backend.onrender.com/seller/";
  String? _result; // Store the result from the QR scan

  // Store the future for the API call
  Future<void>? _fetchLotteryFuture;

  void setResult(String result) {
    setState(() {
      _result = result; // Update the result state
    });

    // Trigger the API call when the result is updated
    if (_result != null) {
      setState(() {
        _fetchLotteryFuture = fetchSellerLotteries(); // Assign the future to trigger the UI update
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            Text(
              "Welcome: ${widget.buyerID}",
              style: GoogleFonts.inika(color: Colors.white, fontSize: 32),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => QrCodeScanner(setResult: setResult),
                    ),
                  );
                },
                child: const Text("Scan Vendor QR"),
              ),
            ),
            Center(
              child: Text(
                _result ?? "Scan a QR Code",
                style: GoogleFonts.inika(color: Colors.white, fontSize: 24),
              ),
            ),
            // Display loading spinner while waiting for API result
            if (_fetchLotteryFuture != null)
              FutureBuilder<void>(
                future: _fetchLotteryFuture, // Future from the fetchSellerLotteries function
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else {
                    return SizedBox.shrink(); // Hide once done
                  }
                },
              ),
          ],
        ),
      ),
    );
  }

  // Fetch seller lotteries based on the scanned result
  Future<void> fetchSellerLotteries() async {
    if (_result == null) return;

    String url = "$api$_result/lotteries"; // Use the _result value
    final uri = Uri.parse(url);

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        print(responseData); // Print response for debugging
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LotteryScreen(sellerID: _result, publicAddress: "0x51128dd5984ee44900e34f49b1b3697e39f02d20")),
        );
      } else {
        print('Error: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('API call failed: $e');
    }
  }
}

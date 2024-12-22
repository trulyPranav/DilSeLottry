import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:dil_se_lottry/Models/lottery_data.dart';

class LotteryDetailScreen extends StatefulWidget {
  final Lottery lottery;
  final String sellerID;
  final String publicAddress;
  const LotteryDetailScreen(
      {super.key, required this.lottery, required this.sellerID, required this.publicAddress});

  @override
  _LotteryDetailScreenState createState() => _LotteryDetailScreenState();
}

class _LotteryDetailScreenState extends State<LotteryDetailScreen> {
  bool _isLoading = true;
  List<String> _serialNumbers = [];
  late final int lotteryAmount;
  late final String lotteryUrl;
  @override
  void initState() {
    super.initState();
    lotteryAmount = widget.lottery.value;
    lotteryUrl = widget.lottery.url;
    _fetchSerialNumbers();
  }

  // Fetch serial numbers from the API
  Future<void> _fetchSerialNumbers() async {
    final lotteryId =
        widget.lottery.id; // Get the lottery id passed from the previous screen
    final url =
        "https://hft-backend.onrender.com/seller/${widget.sellerID}/lotteries/$lotteryId"; // Construct API URL
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> serials =
            data['message']; // Assuming the API response has a 'message' key

        setState(() {
          _serialNumbers =
              serials.map((serial) => serial['id'] as String).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Function to open the dialog with Pay/Deny options
  void _openPaymentDialog(String serial) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Payment Options",
            style: GoogleFonts.inika(color: Colors.black),
          ),
          content: Text(
            "Do you want to pay for the serial number $serial?",
            style: GoogleFonts.inika(color: Colors.black),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Deny"),
              onPressed: () {
                _denyPayment(serial);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Pay"),
              onPressed: () {
                _processPayment(serial, widget.publicAddress, widget.sellerID, lotteryUrl);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _denyPayment(String serial) {
    // final url =
    //     "https://hft-backend.onrender.com/seller/payment/failure";
    // http.post(Uri.parse(url)).then((response) {
    //   if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Payment denied for $serial")));
    //   } else {
    //     ScaffoldMessenger.of(context)
    //         .showSnackBar(SnackBar(content: Text("Failed to deny payment")));
    //   }
    // });
  }
void _processPayment(
    String serial,
    String publicAddress,
    String sellerID,
    String tokenURI,
  ) {
  final url = "https://hft-backend.onrender.com/seller/payment/success/nft-mint";

  // Prepare the payload data
  final Map<String, dynamic> payload = {
    'sellerId': sellerID,
    'tokenURI': tokenURI,
    'buyerPublicAddress': publicAddress,
  };

  // Send POST request with JSON body
  http
      .post(
    Uri.parse(url),
    headers: {
      'Content-Type': 'application/json', // Inform the server we're sending JSON
    },
    body: json.encode(payload), // Convert the map to JSON
  )
      .then((response) {
    if (response.statusCode == 200) {
      print(response.body);
      Map<String, dynamic> responseData = jsonDecode(response.body);
      String nft = responseData['msg'] ?? ''; // Safely handle the 'url'

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Payment processed for serial $serial")),
      );

      // Show success dialog with the NFT URL
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Payment Successful!",
              style: GoogleFonts.inika(color: Colors.black),
            ),
            content: Text(
              "NFT can be found at $nft",
              style: GoogleFonts.inika(color: Colors.black),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      // Handle error response (non-200 status code)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to process payment")),
      );
    }
  }).catchError((error) {
    // Handle errors like network issues
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("An error occurred: $error")),
    );
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lottery Detail")),
      body: _isLoading
          ? Center(
              child:
                  CircularProgressIndicator()) // Show loading spinner while fetching data
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Display enlarged image
                  Image.network(widget.lottery.image, fit: BoxFit.cover),
                  SizedBox(height: 20),
                  // Display serial numbers below the image
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Serial Numbers:",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87)),
                        SizedBox(height: 10),
                        ..._serialNumbers.map((serial) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: ElevatedButton(
                              child: Text(serial,
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black)),
                              onPressed: () {
                                _openPaymentDialog(
                                    serial); // Trigger the dialog when a serial number is clicked
                              },
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

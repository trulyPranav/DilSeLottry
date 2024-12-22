import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:dil_se_lottry/Models/lottery_data.dart';

class LotteryDetailScreen extends StatefulWidget {
  final Lottery lottery;
  final String sellerID;

  const LotteryDetailScreen(
      {super.key, required this.lottery, required this.sellerID});

  @override
  _LotteryDetailScreenState createState() => _LotteryDetailScreenState();
}

class _LotteryDetailScreenState extends State<LotteryDetailScreen> {
  bool _isLoading = true;
  List<String> _serialNumbers = [];
  late final int lotteryAmount;

  @override
  void initState() {
    super.initState();
    lotteryAmount = widget.lottery.value;
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
                _processPayment(serial);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Function to deny payment for a serial number
  void _denyPayment(String serial) {
    // Make API call to deny payment for the serial number
    final url =
        "https://hft-backend.onrender.com/deny-payment/$serial"; // Example deny URL
    http.post(Uri.parse(url)).then((response) {
      if (response.statusCode == 200) {
        // Handle success response
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Payment denied for $serial")));
      } else {
        // Handle error response
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Failed to deny payment")));
      }
    });
  }

  // Function to process payment for a serial number (custom logic)
  void _processPayment(String serial) {
    // Make API call to process payment for the serial number
    final url =
        "https://hft-backend.onrender.com/process-payment/$serial"; // Example payment URL
    http.post(Uri.parse(url)).then((response) {
      if (response.statusCode == 200) {
        // Handle success response
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Payment processed for $serial")));
      } else {
        // Handle error response
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Failed to process payment")));
      }
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

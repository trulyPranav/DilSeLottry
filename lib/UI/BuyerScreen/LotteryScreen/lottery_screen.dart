import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dil_se_lottry/Models/lottery_data.dart';

class LotteryScreen extends StatefulWidget {
  final String? sellerID;

  const LotteryScreen({
    required this.sellerID,
    super.key
  });
  @override
  _LotteryScreenState createState() => _LotteryScreenState();
}

class _LotteryScreenState extends State<LotteryScreen> {
  List<Lottery> _lotteries = []; // To store the list of lotteries
  bool _isLoading = true; // To handle the loading state
  String api = "https://hft-backend.onrender.com/seller/"; // Your API endpoint

  @override
  void initState() {
    super.initState();
    fetchLotteries(); // Fetch the lotteries when the screen is initialized
  }

  Future<void> fetchLotteries() async {
    try {
      final response = await http.get(Uri.parse("$api${widget.sellerID}/lotteries"));
      if (response.statusCode == 200) {
        // Parse the response body and create a list of Lottery objects
        List<dynamic> data = jsonDecode(response.body)["message"];
        setState(() {
          _lotteries = data.map((item) => Lottery.fromJson(item)).toList();
          _isLoading = false; // Once data is fetched, stop loading
        });
      } else {
        // Handle errors
        print("Failed to load lotteries: ${response.statusCode}");
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      // Handle any exceptions
      print("Error fetching lotteries: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lotteries")),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Show a loading spinner while fetching
          : ListView.builder(
              itemCount: _lotteries.length,
              itemBuilder: (context, index) {
                // Extract lottery data
                final lottery = _lotteries[index];
                return ListTile(
                  leading: Image.network(lottery.image), // Display the lottery image
                  title: Text(lottery.id), // Display the lottery id
                  subtitle: Text("Value: \$${lottery.value}"), // Display the value
                );
              },
            ),
    );
  }
}

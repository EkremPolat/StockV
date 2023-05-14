import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../image_viewer_widget.dart';
import '../loading_page.dart';

class PlotDisplayScreen extends StatefulWidget {
  final String symbol;
  final String intervalValue;
  final String intervalCode;
  final String startTime;
  final String endTime;

  const PlotDisplayScreen(
      {Key? key, required this.symbol, required this.intervalValue, required this.intervalCode, required this.startTime, required this.endTime})
      : super(key: key);

  @override
  _PlotDisplayScreenState createState() => _PlotDisplayScreenState();
}

class _PlotDisplayScreenState extends State<PlotDisplayScreen> {
  List<String> plots = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPlots(widget.symbol, widget.intervalValue, widget.intervalCode, widget.startTime, widget.endTime);
  }

  Future<void> fetchPlots(symbol, intervalValue, intervalCode, startTime, endTime) async {
    var url = 'http://192.168.43.136:8000/get-chart-patterns/rectangle/';
    var response = await http.post(
      Uri.parse(url),
      body: json.encode({'symbol': symbol, 'intervalValue': intervalValue, 'intervalCode': intervalCode, 'startTime': startTime, 'endTime': endTime}),
      headers: {
      "Content-Type": "application/json",
      },
    );
    if (response.statusCode == 200) {
      // Parse the JSON response
      final parsedResponse = json.decode(response.body);

      // Convert the dynamic list to a List<String> of plots
      List<String> fetchedPlots = List<String>.from(parsedResponse);

      setState(() {
        plots = fetchedPlots;
        isLoading = false;
      });
    } else {
      throw Exception('Failed to fetch plots');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isLoading ? null : AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        leadingWidth: 400,
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                Image.asset('images/black.png'),
              ],
            ),
          ],
        ),
      ),
      body: isLoading ? const LoadingScreen() : plots.isNotEmpty ? ListView.builder(
        itemCount: plots.length,
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImageViewerPage(
                      imageUrls: plots,
                      initialIndex: index,
                    ),
                  ),
                );
              },
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Image.memory(
                base64Decode(plots[index]),
                fit: BoxFit.contain,
              ),
            ),
          );
        },
      ) : const Text("No pattern is found!"),

    );
  }
}
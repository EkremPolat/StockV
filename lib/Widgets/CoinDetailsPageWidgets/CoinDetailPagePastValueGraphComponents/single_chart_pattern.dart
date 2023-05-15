import 'package:flutter/material.dart';
import 'dart:convert';

import '../../image_viewer_widget.dart';
import '../loading_page.dart';

class PlotDisplayScreen extends StatefulWidget {
  final List<String> plots;

  const PlotDisplayScreen(
      {Key? key, required this.plots})
      : super(key: key);

  @override
  _PlotDisplayScreenState createState() => _PlotDisplayScreenState();
}

class _PlotDisplayScreenState extends State<PlotDisplayScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: widget.plots.isNotEmpty ? ListView.builder(
        itemCount: widget.plots.length,
        itemBuilder: (context, index) {
          return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ImageViewerPage(
                      imageUrls: widget.plots,
                      initialIndex: index,
                    ),
                  ),
                );
              },
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Image.memory(
                base64Decode(widget.plots[index]),
                fit: BoxFit.contain,
              ),
            ),
          );
        },
      ) : const Text("No pattern is found!"),

    );
  }
}
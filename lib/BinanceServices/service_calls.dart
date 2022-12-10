import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:web_socket_channel/io.dart';

void main() {
  runApp(const MaterialApp(
      debugShowCheckedModeBanner: false, home: WebsocketDemo()));
}

class WebsocketDemo extends StatefulWidget {
  const WebsocketDemo({Key? key}) : super(key: key);

  @override
  State<WebsocketDemo> createState() => _WebsocketDemoState();
}

class _WebsocketDemoState extends State<WebsocketDemo> {
  final channel = IOWebSocketChannel.connect(
      'wss://stream.binance.com:9443/ws/btcusdt@trade');
  String btcUsdtPrice = "0";
  @override
  void initState() {
    super.initState();
    streamListener();
  }

  streamListener() {
    channel.stream.listen((message) {
      Map getData = jsonDecode(message);
      setState(() {
        btcUsdtPrice = getData['p'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "BTC/USDT Price",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 30, color: Colors.blue),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(
              btcUsdtPrice,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.blue),
            ),
          ),
        ],
      ),
    ));
  }
}

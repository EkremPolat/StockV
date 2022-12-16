import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

void main() {
  runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SingleEtfComponent(etfCode: "btc")));
}

class SingleEtfComponent extends StatefulWidget {
  final String etfCode;
  const SingleEtfComponent({Key? key, required this.etfCode}) : super(key: key);

  @override
  State<SingleEtfComponent> createState() =>
      _SingleEtfComponentState(IOWebSocketChannel.connect(
          'wss://stream.binance.com:9443/ws/${etfCode.toLowerCase()}usdt@trade',
          pingInterval: Duration(seconds: 5)));
}

class _SingleEtfComponentState extends State<SingleEtfComponent> {
  String etfPrice = "0";
  IOWebSocketChannel channel;

  _SingleEtfComponentState(this.channel);

  @override
  void initState() {
    super.initState();
    streamListener();
  }

  streamListener() {
    channel.stream.listen((message) {
      Map getData = jsonDecode(message);
      setState(() {
        etfPrice = getData['p'];
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
          Text(
            "${widget.etfCode.toUpperCase()}/USD Trade Price: \$${double.parse(etfPrice).toString()}",
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20, color: Colors.blue),
          ),
        ],
      ),
    ));
  }
}

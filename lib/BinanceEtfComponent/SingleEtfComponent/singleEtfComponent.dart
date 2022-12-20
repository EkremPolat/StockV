import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

class SingleEtfComponent extends StatefulWidget {
  final String etfCode;
  final String etfDailyChange;
  final int index;

  const SingleEtfComponent(
      {Key? key, required this.etfCode, required this.etfDailyChange, required this.index})
      : super(key: key);

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
      if (!mounted) return;
      setState(() {
        etfPrice = getData['p'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String iconName = "${widget.etfCode}.png";
    final double dailyChange = double.parse(widget.etfDailyChange);

    return Scaffold(
      backgroundColor: widget.index % 2 == 0 ? Colors.black12 : Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 100),
              const SizedBox(width: 30),
              Image(
                image: AssetImage('images/coin_icons/$iconName'),
                fit: BoxFit.cover,
                width: 25,
              ),
              const SizedBox(width: 20), // give it width
              SizedBox(
                width: 70,
                child: Text(
                  widget.etfCode.toUpperCase(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: "Brandon Grotesque",
                      fontSize: 20,
                      color: Colors.black),
                ),
              ),
              const SizedBox(width: 20), // give it width
              SizedBox(
                width: 100,
                child: Text(
                  double.parse(etfPrice).toString(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: "Brandon Grotesque",
                      fontSize: 20,
                      color: Colors.black),
                ),
              ),
              const SizedBox(width: 20),
              if(dailyChange > 0)
                SizedBox(
                  width: 100,
                  child: Text(
                    "  ${widget.etfDailyChange}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      fontFamily: "Brandon Grotesque",
                      color: Colors.green,
                    ),
                  ),
                ),
              if(dailyChange < 0)
                SizedBox(
                  width: 100,
                  child: Text(
                    widget.etfDailyChange,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: "Brandon Grotesque",
                      fontSize: 20,
                      color: Colors.red,
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}

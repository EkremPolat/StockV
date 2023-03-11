import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:web_socket_channel/io.dart';

List<Data> _data = [];

class Data {
  final DateTime time;
  final double etfPrice;

  Data(this.time, this.etfPrice);
}

class SingleEtfGraphComponent extends StatefulWidget {
  final String etfCode;

  const SingleEtfGraphComponent({Key? key, required this.etfCode})
      : super(key: key);

  @override
  State<SingleEtfGraphComponent> createState() =>
      SingleEtfGraphComponentState();
}

class SingleEtfGraphComponentState extends State<SingleEtfGraphComponent> {
  late IOWebSocketChannel _channel;

  @override
  void initState() {
    super.initState();
    _connectToWebSocket();
  }

  @override
  void dispose() {
    _closeWebSocket();
    super.dispose();
  }

  void _connectToWebSocket() {
    _channel = _globalWebSocket ??
        IOWebSocketChannel.connect(
            'wss://stream.binance.com:9443/ws/${widget.etfCode.toLowerCase()}usdt@trade');
    _channel.stream.listen((message) {
      Map getData = jsonDecode(message);
      if (!mounted) return;
      final now = DateTime.now();
      final etfPrice = getData['p'];
      setState(() {
        _data.add(Data(now, double.parse(etfPrice)));
        if (_data.length > 600) {
          _data.removeAt(0);
        }
      });
    }, onError: (error) {
      print('WebSocket error: $error');
      _reconnectToWebSocket();
    }, onDone: () {
      print('WebSocket closed');
      _reconnectToWebSocket();
    });
  }

  void _closeWebSocket() {
    if (_channel != null && _channel.sink != null) {
      _channel.sink.close();
    }
  }

  void _reconnectToWebSocket() async {
    await Future.delayed(const Duration(seconds: 5));
    if (mounted) {
      _closeWebSocket();
      _connectToWebSocket();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      child: SfCartesianChart(
        primaryXAxis: DateTimeAxis(),
        primaryYAxis: NumericAxis(),
        series: <ChartSeries>[
          LineSeries<Data, DateTime>(
            dataSource: _data,
            xValueMapper: (Data data, _) => data.time,
            yValueMapper: (Data data, _) => data.etfPrice,
          ),
        ],
      ),
    );
  }
}

// Global variable to store WebSocket instance
IOWebSocketChannel? _globalWebSocket;

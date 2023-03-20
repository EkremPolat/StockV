import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;

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
  late Timer _timer;

  final List<Data> _data = [];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      fetchEtfPrice();
    });
  }

  @override
  void dispose() {
    super.dispose();
    // Cancel the timer when the widget is disposed
    _timer.cancel();
  }

  Future<void> fetchEtfPrice() async {
    final response = await http.get(Uri.parse(
        'https://api.binance.com/api/v3/ticker/price?symbol=${widget.etfCode}USDT'));
    final data = jsonDecode(response.body);
    double etfUpdatedPrice = 0.0;
    if (data is Map && data.containsKey('price')) {
      etfUpdatedPrice = double.tryParse(data['price'] ?? '') ?? 0.0;
    }
    if (!mounted) return;
    final now = DateTime.now();
    setState(() {
      _data.add(Data(now, etfUpdatedPrice));
      if (_data.length > 100) {
        _data.removeAt(0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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

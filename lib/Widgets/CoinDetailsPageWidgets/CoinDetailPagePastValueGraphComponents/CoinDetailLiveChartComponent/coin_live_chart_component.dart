import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stockv/Models/coin.dart';
import 'package:stockv/Utilities/coin_graph_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;

class SingleEtfLiveChartComponent extends StatefulWidget {
  final Coin coin;

  const SingleEtfLiveChartComponent({Key? key, required this.coin})
      : super(key: key);

  @override
  State<SingleEtfLiveChartComponent> createState() =>
      SingleEtfLiveChartComponentState();
}

class SingleEtfLiveChartComponentState
    extends State<SingleEtfLiveChartComponent> {
  late Timer _timer;

  final List<EtfPriceData> _data = [];

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
        'https://api.binance.com/api/v3/ticker/price?symbol=${widget.coin.symbol}USDT'));
    final data = jsonDecode(response.body);
    double etfUpdatedPrice = 0.0;
    if (data is Map && data.containsKey('price')) {
      etfUpdatedPrice = double.tryParse(data['price'] ?? '') ?? 0.0;
    }
    if (!mounted) return;
    final now = DateTime.now();
    setState(() {
      _data.add(EtfPriceData(now, etfUpdatedPrice));
      if (_data.length > 100) {
        _data.removeAt(0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(46, 21, 157, 0.6),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              '${widget.coin.symbol}/USDT',
              style: const TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 400,
              child: SfCartesianChart(
                primaryXAxis: DateTimeAxis(),
                primaryYAxis: NumericAxis(),
                series: <ChartSeries>[
                  LineSeries<EtfPriceData, DateTime>(
                    dataSource: _data,
                    xValueMapper: (EtfPriceData data, _) => data.time,
                    yValueMapper: (EtfPriceData data, _) => data.etfPrice,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

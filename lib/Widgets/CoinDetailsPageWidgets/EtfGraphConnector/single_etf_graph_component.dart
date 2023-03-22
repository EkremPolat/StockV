import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stockv/Models/coin.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;

String coinVolume = '';
String coinLowestPrice = '';
String coinHighestPrice = '';

class Data {
  final DateTime time;
  final double etfPrice;

  Data(this.time, this.etfPrice);
}

class SingleEtfGraphComponent extends StatefulWidget {
  final Coin coin;

  const SingleEtfGraphComponent({Key? key, required this.coin})
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
    setState(() {
      coinVolume = '';
      coinLowestPrice = '';
      coinHighestPrice = '';
    });
    readCoinInfo();
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

  Future<void> readCoinInfo() async {
    final response = await http.get(Uri.parse(
        'https://api.binance.com/api/v3/ticker/24hr?symbol=${widget.coin.symbol}USDT'));
    final data = jsonDecode(response.body);
    setState(() {
      coinVolume = double.parse(data['volume']).toString();
      coinLowestPrice = double.parse(data['lowPrice']).toString();
      coinHighestPrice = double.parse(data['highPrice']).toString();
    });
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
      _data.add(Data(now, etfUpdatedPrice));
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '24 Hour Volume:',
                  style: TextStyle(fontSize: 25.0),
                ),
                Text(
                  coinVolume,
                  style: const TextStyle(fontSize: 25.0),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Highest Price:',
                  style: TextStyle(fontSize: 25.0),
                ),
                Text(
                  '$coinHighestPrice\$',
                  style: const TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Lowest Price:',
                  style: TextStyle(fontSize: 25.0),
                ),
                Text(
                  '$coinLowestPrice\$',
                  style: const TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                )
              ],
            ),
            SizedBox(
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
            )
          ],
        ),
      ),
    );
  }
}

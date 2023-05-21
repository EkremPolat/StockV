import 'package:flutter/material.dart';
import 'package:stockv/Models/coin_graph_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class FuturePriceGraph extends StatelessWidget {
  final List<EtfPriceData> etfPriceData;

  const FuturePriceGraph({Key? key, required this.etfPriceData})
      : super(key: key);

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
              'Future Price Predictions',
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
                    dataSource: etfPriceData,
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

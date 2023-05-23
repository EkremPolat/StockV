import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:stockv/Models/coin_graph_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import '../../../Models/coin.dart';

class FuturePriceGraph extends StatefulWidget {
  final List<EtfPriceData> etfPriceData;
  final Coin coin;

  const FuturePriceGraph(
      {Key? key, required this.etfPriceData, required this.coin})
      : super(key: key);

  @override
  State<FuturePriceGraph> createState() => _FuturePriceGraphState();
}

class _FuturePriceGraphState extends State<FuturePriceGraph> {
  @override
  Widget build(BuildContext context) {
    final length = widget.etfPriceData.length;
    List<Map<String, dynamic>> data = [
      {'x': widget.etfPriceData[0].time, 'y': widget.coin.price},
      {'x': widget.etfPriceData[length - 1].time, 'y': widget.coin.price},
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        leadingWidth: 200,
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
                SizedBox( child: Image.asset('images/black.png', width: 100,
                  height: 100,
                  )),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: FractionallySizedBox(
          widthFactor: 1,
          child: Container(
            color: const Color(0xff17212F),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Text(
                  '${widget.coin.symbol} Future Price Predictions',
                  style: const TextStyle(
                      fontSize: 27.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                FractionallySizedBox(
                  widthFactor: 0.96,
                    child: SfCartesianChart(
                    primaryXAxis: DateTimeAxis(
                        title: AxisTitle(
                            text: 'Date',
                            textStyle: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold)),
                        majorGridLines: const MajorGridLines(width: 0),
                        edgeLabelPlacement: EdgeLabelPlacement.shift,
                        dateFormat: DateFormat("MMM-dd"),
                        labelStyle: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    primaryYAxis: NumericAxis(
                      title: AxisTitle(
                          text: 'Price',
                          textStyle: const TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold)),
                      numberFormat:
                          NumberFormat.currency(symbol: '\$', decimalDigits: 0),
                      axisLine: const AxisLine(width: 0),
                      majorTickLines: const MajorTickLines(width: 0),
                      labelStyle: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    series: <ChartSeries>[
                      LineSeries<EtfPriceData, DateTime>(
                        dataSource: widget.etfPriceData,
                        xValueMapper: (EtfPriceData data, _) => data.time,
                        yValueMapper: (EtfPriceData data, _) => data.etfPrice,
                        color: Colors.blue,
                        // Customize line color
                        markerSettings: const MarkerSettings(
                          isVisible: true, // Show data point markers
                          color: Colors.blue, // Customize marker color
                        ),
                        name: 'Predicted Price',
                      ),
                      LineSeries<Map<String, dynamic>, DateTime>(
                        dataSource: data,
                        xValueMapper: (datum, _) => datum['x'],
                        yValueMapper: (datum, _) => datum['y'],
                        name: 'Current Price',
                      ),
                    ],
                      legend: Legend(
                        isVisible: true,
                        position: LegendPosition.top,
                        overflowMode: LegendItemOverflowMode.wrap,
                        textStyle: const TextStyle(color: Colors.white)
                      ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                FractionallySizedBox(
                  widthFactor: 0.92,
                  child: RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      text: 'This graph shows the prediction values of ',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: widget.coin.symbol,
                          style: const TextStyle(
                            color: Colors.green,
                            // Change the color of this part
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(
                          text: ' for the next 10 days.',
                          style: TextStyle(
                            color: Colors.white,
                            // Change the color of this part
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                DataTable(
                  headingTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  dataTextStyle: const TextStyle(color: Colors.white),
                  columns: const [
                    DataColumn(label: Text('Date')),
                    DataColumn(label: Text('Price (\$)')),
                    DataColumn(label: Text('Change (%)')),
                  ],
                  rows: List<DataRow>.generate(widget.etfPriceData.length,
                      (index) {
                    bool isOdd = index % 2 == 0;
                    Color color = isOdd ? Colors.indigo : Colors.white;
                    Color textColor = isOdd ? Colors.white : Colors.white;
                    double coinPrice = widget.coin.price;
                    Color changeColor = Colors.green;
                    if (coinPrice > widget.etfPriceData[index].etfPrice) {
                      changeColor = Colors.red;
                    }
                    double difference =
                        (coinPrice - widget.etfPriceData[index].etfPrice).abs();
                    double change = (100 * difference) / coinPrice;
                    return DataRow(
                      cells: [
                        DataCell(Text(
                          DateFormat('yyyy-MM-dd')
                              .format(widget.etfPriceData[index].time),
                          style: TextStyle(
                              color: textColor, fontWeight: FontWeight.bold),
                        )),
                        DataCell(Text(
                          widget.etfPriceData[index].etfPrice
                              .toStringAsFixed(2),
                          style: TextStyle(
                              color: textColor, fontWeight: FontWeight.bold),
                        )),
                        DataCell(Text(
                          change.toStringAsFixed(3),
                          style: TextStyle(
                              color: changeColor, fontWeight: FontWeight.bold),
                        )),
                      ],
                    );
                  }),
                ),
                const SizedBox(
                  height: 20,
                ),
                FractionallySizedBox(
                  widthFactor: 0.92,
                  child: RichText(
                    textAlign: TextAlign.justify,
                    text: const TextSpan(
                      text: 'Disclaimer: ',
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                      children: <TextSpan>[
                        TextSpan(
                          text:
                          'The predictive values are the predicted values produced using the ARIMA machine learning model. It is not an investment advice. There can be serious differences between the actual values and the predicted values!',
                          style: TextStyle(
                            color: Colors.white, // Change the color of this part
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

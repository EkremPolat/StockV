import 'package:flutter/material.dart';
import 'package:stockv/Models/coin_graph_data.dart';
import 'package:stockv/Utilities/past_coin_history_functions.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

List<EtfPriceData> _etfPriceData = [];

String intervalCode = 'm';
int intervalValue = 15;
Duration duration = const Duration(hours: 24);

const List<String> durationList = [
  'Last Hour',
  'Last Day',
  'Last Week',
  'Last Month',
  'Last Year'
];
String dropdownListValue = 'Last Day';

class SingleEtfPastValueGraphComponent extends StatefulWidget {
  final String etfCode;

  const SingleEtfPastValueGraphComponent({super.key, required this.etfCode});

  @override
  State<SingleEtfPastValueGraphComponent> createState() =>
      _SingleEtfPastValueGraphComponentState();
}

class _SingleEtfPastValueGraphComponentState
    extends State<SingleEtfPastValueGraphComponent> {
  @override
  void initState() {
    super.initState();
    fetchCoinHistory();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      children: [
        SizedBox(
          height: 50,
          child: DropdownButton(
            value: dropdownListValue,
            icon: const Icon(Icons.arrow_downward),
            elevation: 16,
            style: const TextStyle(
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold,
                fontSize: 25),
            underline: Container(
              height: 2,
              color: Colors.deepPurpleAccent,
            ),
            onChanged: (String? value) {
              setState(
                () {
                  if (value == 'Last Hour') {
                    setState(() {
                      dropdownListValue = value!;
                      duration = const Duration(hours: 1);
                      intervalCode = 'm';
                      intervalValue = 1;
                    });
                  } else if (value == 'Last Day') {
                    setState(() {
                      dropdownListValue = value!;
                      duration = const Duration(hours: 24);
                      intervalCode = 'm';
                      intervalValue = 15;
                    });
                  } else if (value == 'Last Week') {
                    setState(() {
                      dropdownListValue = value!;
                      duration = const Duration(days: 7);
                      intervalCode = 'h';
                      intervalValue = 4;
                    });
                  } else if (value == 'Last Month') {
                    setState(() {
                      dropdownListValue = value!;
                      duration = const Duration(days: 30);
                      intervalCode = 'h';
                      intervalValue = 12;
                    });
                  } else if (value == 'Last Year') {
                    setState(() {
                      dropdownListValue = value!;
                      duration = const Duration(days: 365);
                      intervalCode = 'w';
                      intervalValue = 1;
                    });
                  }
                  fetchCoinHistory();
                },
              );
            },
            items: durationList.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            }).toList(),
          ),
        ),
        SfCartesianChart(
          primaryXAxis: DateTimeAxis(),
          primaryYAxis: NumericAxis(),
          series: <ChartSeries>[
            LineSeries<EtfPriceData, DateTime>(
              dataSource: _etfPriceData,
              xValueMapper: (EtfPriceData data, _) => data.time,
              yValueMapper: (EtfPriceData data, _) => data.etfPrice,
            ),
          ],
        ),
      ],
    )));
  }

  Future<void> fetchCoinHistory() async {
    setState(() {
      _etfPriceData = [];
    });
    final newEtfPriceList = await fetchCoinValueHistory(
        widget.etfCode, intervalCode, intervalValue, duration);
    if(mounted) {
      setState(() {
        _etfPriceData = newEtfPriceList;
      });
    }
  }
}

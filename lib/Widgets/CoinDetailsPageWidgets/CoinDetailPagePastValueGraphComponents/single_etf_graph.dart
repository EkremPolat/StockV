import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:k_chart/flutter_k_chart.dart';
import 'package:stockv/Utilities/past_coin_history_functions.dart';

String etfCode = "";
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

  List<KLineEntity> _etfPriceData = [];
  @override
  void initState() {
    super.initState();
    fetchCoinHistory(widget.etfCode);
  }

  Future<void> fetchCoinHistory(etfCode) async {
    setState(() {
      _etfPriceData = [];
    });
    final newEtfPriceList = await fetchCoinValueHistory(
        etfCode, intervalCode, intervalValue, duration);
    if(mounted) {
      setState(() {
        _etfPriceData = newEtfPriceList.cast<KLineEntity>();
      });
    }
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
                          fetchCoinHistory(widget.etfCode);
                        },
                      );
                    },
                    items: durationList.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(value: value, child: Text(value));
                    }).toList(),
                  ),
                ),
                CandleChartComponentPage(etfPriceData: _etfPriceData),
              ],
            )));
  }

}

class CandleChartComponentPage extends StatefulWidget {
  List<KLineEntity> etfPriceData;
  CandleChartComponentPage({super.key, required this.etfPriceData});

  @override
  _CandleChartComponentState createState() => _CandleChartComponentState();
}

class _CandleChartComponentState extends State<CandleChartComponentPage> {
  MainState _mainState = MainState.MA;
  bool _volHidden = false;
  SecondaryState _secondaryState = SecondaryState.MACD;
  bool isLine = false;
  ChartStyle chartStyle = ChartStyle();
  ChartColors chartColors = ChartColors();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 700,
      child: Scaffold(
        backgroundColor: const Color(0xff17212F),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 450,
                width: double.infinity,
                child: KChartWidget(
                  widget.etfPriceData,
                  chartStyle,
                  chartColors,
                  isLine: isLine,
                  mainState: _mainState,
                  volHidden: _volHidden,
                  secondaryState: _secondaryState,
                  fixedLength: 2,
                  timeFormat: TimeFormat.YEAR_MONTH_DAY,
                  isTrendLine: false,
                ),
              ),
              buildButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButtons() {
    return Wrap(
      alignment: WrapAlignment.spaceEvenly,
      children: <Widget>[
        button("Insert Line", onPressed: () => isLine = true),
        button("Remove Line", onPressed: () => isLine = false),
        button("MA", onPressed: () => _mainState = MainState.MA),
        button("BOLL", onPressed: () => _mainState = MainState.BOLL),
        button("Remove Main State", onPressed: () => _mainState = MainState.NONE),
        button("MACD", onPressed: () => _secondaryState = SecondaryState.MACD),
        button("KDJ", onPressed: () => _secondaryState = SecondaryState.KDJ),
        button("RSI", onPressed: () => _secondaryState = SecondaryState.RSI),
        button("WR", onPressed: () => _secondaryState = SecondaryState.WR),
        button("Remove Secondary State", onPressed: () => _secondaryState = SecondaryState.NONE),
        button(_volHidden ? "Show Volume" : "Hide Volumw",
            onPressed: () => _volHidden = !_volHidden)
      ],
    );
  }

  Widget button(String text, {required VoidCallback onPressed}) {
    return ElevatedButton(
        onPressed: () {
          onPressed();
          setState(() {});
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff2E159D),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text(text));
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:k_chart/flutter_k_chart.dart';
import 'package:stockv/Utilities/past_coin_history_functions.dart';

class SingleEtfPastValueGraphComponent extends StatefulWidget {
  final String etfCode;
  final String intervalCode;
  final int intervalValue;
  final Duration duration;

  const SingleEtfPastValueGraphComponent({super.key, required this.etfCode, required this.intervalCode, required this.intervalValue, required this.duration});

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
    fetchCoinHistory(widget.etfCode, widget.intervalCode, widget.intervalValue, widget.duration);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> fetchCoinHistory(etfCode, intervalCode, intervalValue, duration) async {
    setState(() {
      _etfPriceData = [];
    });
    final response = await fetchCoinValueHistory(
        etfCode, intervalCode, intervalValue, duration);
    if(mounted) {
      setState(() {
        _etfPriceData = response[0].cast<KLineEntity>();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
              children: [
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
      height: 620,
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
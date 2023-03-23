import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:stockv/Utilities/coin_graph_data.dart';

Future<List<EtfPriceData>> fetchCoinValueHistory(String symbol,
    String intervalCode, int intervalValue, Duration duration) async {
  const String baseUrl = 'https://api.binance.com/api/v3';
  final List<EtfPriceData> etfPriceData = [];
  final int startTime =
      DateTime.now().subtract(duration).millisecondsSinceEpoch;
  final int endTime = DateTime.now().millisecondsSinceEpoch;
  final response = await http.get(Uri.parse(
      '$baseUrl/klines?symbol=${symbol}USDT&interval=$intervalValue$intervalCode&startTime=$startTime&endTime=$endTime'));

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    final List<double> values = data.map((e) => double.parse(e[1])).toList();
    final List<DateTime> times =
        data.map((e) => DateTime.fromMillisecondsSinceEpoch(e[0])).toList();
    for (int i = 0; i < values.length; i++) {
      etfPriceData.add(EtfPriceData(times[i], values[i]));
    }

    // now you have the list of values and times, which you can use to create a graph
  } else {
    throw Exception('Failed to load data');
  }

  return etfPriceData;
}

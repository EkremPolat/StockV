import 'package:http/http.dart' as http;
import 'package:k_chart/entity/k_line_entity.dart';
import 'dart:convert';

import '../Models/coin_graph_data.dart';

Future<List<KLineEntity>> fetchCoinValueHistory(String symbol,
    String intervalCode, int intervalValue, Duration duration) async {
  const String baseUrl = 'https://api.binance.com/api/v3';
  final int startTime =
      DateTime.now().subtract(duration).millisecondsSinceEpoch;
  final int endTime = DateTime.now().millisecondsSinceEpoch;
  final response = await http.get(Uri.parse(
      '$baseUrl/klines?symbol=${symbol}USDT&interval=$intervalValue$intervalCode&startTime=$startTime&endTime=$endTime'));

  if (response.statusCode == 200) {
    final parsedResponse = json.decode(response.body);
    List<CoinGraphData> coinGraphDataList = List<CoinGraphData>.from(parsedResponse.map((data) => CoinGraphData.fromJson(data)));
    List<KLineEntity> kLineEntityList = coinGraphDataList.map((coinGraphData) => coinGraphData.toKLineEntity()).toList();
    return kLineEntityList;

    // now you have the list of values and times, which you can use to create a graph
  } else {
    throw Exception('Failed to load data');
  }
}

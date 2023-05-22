import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stockv/Models/coin_graph_data.dart';

Future<List<EtfPriceData>> generatePredictions(String symbol,
    String intervalCode, int intervalValue, Duration duration) async {
  const url = 'http://10.0.2.2:8000/generate-predictions/';
  final request = http.Request('POST', Uri.parse(url));
  final int startTime =
      DateTime.now().subtract(duration).millisecondsSinceEpoch;
  final int endTime = DateTime.now().millisecondsSinceEpoch;
  request.headers["Content-Type"] = "application/json";
  request.body = json.encode({
    'symbol': symbol,
    'intervalValue': intervalValue,
    'intervalCode': intervalCode,
    'startTime': startTime,
    'endTime': endTime,
  });

  // Set a longer timeout duration (e.g., 30 seconds)
  final response = await http.Response.fromStream(
      await http.Client().send(request).timeout(const Duration(seconds: 30)));

  if (response.statusCode == 200) {
    final parsedResponse = json.decode(response.body);

    // Convert the dynamic list to a List<EtfPriceData>
    List<EtfPriceData> etfPriceData = [];
    DateTime currentDate = DateTime.now().add(Duration(days: 1));

    for (double price in parsedResponse) {
      etfPriceData.add(EtfPriceData(currentDate, price));
      currentDate = currentDate.add(Duration(days: 1));
    }

    return etfPriceData;
  } else {
    throw Exception('Failed to fetch predictions');
  }
}

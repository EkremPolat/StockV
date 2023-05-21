import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<String>> generatePredictions(
  String symbol,
  int intervalValue,
  String intervalCode,
  int startTime,
  int endTime,
) async {
  const url = 'http://10.0.2.2:8000/generate-predictions/';
  final request = http.Request('POST', Uri.parse(url));
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

    // Convert the dynamic list to a List<String> of plots
    List<String> fetchedPlot = List<String>.from(parsedResponse);
    return fetchedPlot;
  } else {
    throw Exception('Failed to fetch predictions');
  }
}

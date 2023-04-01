import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<String>> fetchBuySellPrices(String etfCode) async {
  final response = await http.get(
      Uri.parse('https://api.coinbase.com/v2/prices/$etfCode-USD/buy'),
      headers: {'Content-Type': 'application/json'});
  final data = jsonDecode(response.body)['data'];
  var buyPrice = '0';
  if(data != null) {
    buyPrice = data['amount'];
  }

  final response2 = await http.get(
      Uri.parse('https://api.coinbase.com/v2/prices/$etfCode-USD/sell'),
      headers: {'Content-Type': 'application/json'});
  final coinData = jsonDecode(response2.body)['data'];
  String amount = '0';
  if(coinData != null) {
    amount = coinData['amount'];
  }
  return [
    buyPrice.toString(),
    amount.toString()
  ];
}
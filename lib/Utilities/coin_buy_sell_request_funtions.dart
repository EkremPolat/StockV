import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<String>> fetchBuySellPrices(String etfCode) async {
  final response = await http.get(
      Uri.parse('https://api.coinbase.com/v2/prices/$etfCode-USD/buy'),
      headers: {'Content-Type': 'application/json'});
  final buyPrice = jsonDecode(response.body)['data']['amount'];

  final response2 = await http.get(
      Uri.parse('https://api.coinbase.com/v2/prices/BTC-USD/sell'),
      headers: {'Content-Type': 'application/json'});
  final sellPrice = jsonDecode(response2.body)['data']['amount'];
  return [
    '$etfCode Buy Price: \$$buyPrice',
    '$etfCode Sell Price: \$$sellPrice'
  ];
}

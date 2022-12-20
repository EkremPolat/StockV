import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stockv/BinanceEtfComponent/SingleEtfComponent/singleEtfComponent.dart';
import 'package:http/http.dart' as http;

var etfCodes = <String>{};
var etfDailyChanges = <String>{};

class MultipleEtfContainerState extends StatefulWidget {
  const MultipleEtfContainerState({super.key});

  @override
  _MultipleEtfContainerState createState() => _MultipleEtfContainerState();
}

class _MultipleEtfContainerState  extends State<MultipleEtfContainerState> {

  @override
  void initState() {
    super.initState();
    fetchCoins();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            for (var i = 0; i < etfCodes.length; i++)
              SizedBox(
                width: 400.0,
                height: 50.0,
                child: SingleEtfComponent(etfCode: etfCodes.elementAt(i),  etfDailyChange: etfDailyChanges.elementAt(i), index: i),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> fetchCoins() async {
    await fetchExchangeInfo();
  }
}

fetchExchangeInfo() async {
  final response =
      await http.get(Uri.parse('https://www.binance.com/api/v3/exchangeInfo'));
  final data = jsonDecode(response.body);
  final etfList = (data as Map)['symbols'];
  for (var symbol in etfList) {
    final tradeSymbol = (symbol as Map)['symbol'];
    final dailyChangeResponse = await http.get(Uri.parse("https://api.binance.com/api/v1/ticker/24hr?symbol=$tradeSymbol"));
    final dailyChangeData = jsonDecode(dailyChangeResponse.body);
    final dailyChange = dailyChangeData["priceChangePercent"];
    if (tradeSymbol.endsWith('USDT')) {
      final name = (symbol)['baseAsset'];

      final permissions = (symbol)['permissions'];
      if (permissions.contains("TRD_GRP_005")) {
        if (etfCodes.length < 16) {
          etfCodes.add(name);
          etfDailyChanges.add(dailyChange);
        }
      }
    }
  }
}

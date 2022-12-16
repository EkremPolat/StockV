import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stockv/BinanceEtfComponent/SingleEtfComponent/singleEtfComponent.dart';
import 'package:http/http.dart' as http;

var etfCodes = <String>{};

void main() async {
  await fetchExchangeInfos();
  print(etfCodes);
  runApp(const MaterialApp(
      debugShowCheckedModeBanner: false, home: MultipleEtfContainer()));
}

class MultipleEtfContainer extends StatelessWidget {
  const MultipleEtfContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            for (var etf in etfCodes)
              SizedBox(
                width: 400.0,
                height: 100.0,
                child: SingleEtfComponent(etfCode: etf),
              ),
          ],
        ),
      ),
    );
  }
}

fetchExchangeInfos() async {
  final response =
      await http.get(Uri.parse('https://www.binance.com/api/v3/exchangeInfo'));
  final data = jsonDecode(response.body);
  final etfList = (data as Map)['symbols'];
  for (var symbol in etfList) {
    final tradeSymbol = (symbol as Map)['symbol'];
    if (tradeSymbol.endsWith('USDT')) {
      final name = (symbol as Map)['baseAsset'];
      final permissions = (symbol as Map)['permissions'];
      print(name + ' ' + permissions.contains("TRD_GRP_005").toString());
      if (permissions.contains("TRD_GRP_005")) {
        if (etfCodes.length < 20) {
          etfCodes.add(name);
        }
      }
    }
  }
}

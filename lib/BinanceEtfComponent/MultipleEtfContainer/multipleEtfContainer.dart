import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stockv/BinanceEtfComponent/SingleEtfComponent/singleEtfComponent.dart';
import 'package:http/http.dart' as http;

List etfCodes = [];

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
    final name = (symbol as Map)['baseAsset'];
    if (etfCodes.length < 5) etfCodes.add(name);
  }
}

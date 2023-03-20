import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stockv/BinanceEtfComponent/SingleEtfComponent/single_etf_component.dart';
import 'package:http/http.dart' as http;

var etfCodes = <String>{
  'BTC',
  'ETH',
  'BNB',
  'LTC',
  'ADA',
  'XRP',
  'XLM',
  'TRX',
  'ETC',
  'ICX',
  'LINK',
  'HOT',
  'ZIL',
  'ZRX',
  'FET',
  'BAT',
  'CELR',
  'OMG',
  'ENJ',
  'MITH',
  'MATIC',
  'ATOM',
  'ALGO',
  'DOGE',
  'WIN',
  'MTL',
  'DENT',
  'MFT',
  'FUN',
  'CVC',
  'CHZ',
  'BAND',
  'BUSD',
  'XTZ',
  'REN',
  'NKN',
  'ARPA',
  'RLC',
  'BCH',
  'FTT',
  'OGN',
  'BNT',
  'STPT',
  'DATA',
  'SOL',
  'CHR',
  'MDT',
  'STMX',
  'KNC'
};
List<String> etfPrices = [
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0'
];
List<String> etfDailyChanges = [
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0',
  '0.0'
];
var itemCount = 0;

class MultipleEtfContainerState extends StatefulWidget {
  final Function(String) saveCoin;

  const MultipleEtfContainerState({Key? key, required this.saveCoin})
      : super(key: key);

  @override
  State<MultipleEtfContainerState> createState() =>
      _MultipleEtfContainerState();
}

class _MultipleEtfContainerState extends State<MultipleEtfContainerState> {
  @override
  void initState() {
    super.initState();
    fetchCoins();
  }

  void _updateStringList(List<String> newList) {
    setState(() {
      etfPrices = newList;
    });
  }

  void _saveCoin(String etfCode) {
    widget.saveCoin(etfCode);
  }

  @override
  Widget build(BuildContext context) {
    final etfCodesList = etfCodes.toList();

    return PageView.builder(
      itemCount: (itemCount / 12).ceil(),
      itemBuilder: (context, pageIndex) {
        final startIndex = pageIndex * 12;
        final endIndex = startIndex + 12;
        final pageEtfList = etfCodesList.sublist(
            startIndex, endIndex < itemCount ? endIndex : itemCount);
        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: pageEtfList.length,
          itemBuilder: (context, index) => SizedBox(
            width: 400.0,
            height: 50.0,
            child: SingleEtfComponent(
              updateStringList: _updateStringList,
              saveCoin: _saveCoin,
              etfCode: pageEtfList.elementAt(index),
              etfPrice: etfPrices[startIndex + index],
              etfDailyChange: etfDailyChanges[startIndex + index],
              index: startIndex + index,
            ),
          ),
        );
      },
    );
  }

  Future<void> fetchExchangeInfo() async {
    final etfRequests = <Future>[];
    final etfResponses = <String, dynamic>{};

    var counter = 0;

    for (var etfCode in etfCodes) {
      etfResponses[etfCode] = await http.get(Uri.parse(
          "https://api.binance.com/api/v1/ticker/24hr?symbol=${etfCode}USDT"));
      final dailyChangeData = jsonDecode(etfResponses[etfCode].body);
      final dailyChange = dailyChangeData["priceChangePercent"];
      setState(() {
        etfDailyChanges[counter] = dailyChange;
      });
      etfRequests.add(fetchEtfPrices(etfCode));
      counter++;

      await Future.wait(etfRequests);
    }
  }

  Future<void> fetchEtfPrices(String tradeSymbol) async {
    final priceResponse = await http.get(Uri.parse(
        'https://api.binance.com/api/v3/ticker/price?symbol=${tradeSymbol}USDT'));
    final priceData = jsonDecode(priceResponse.body);
    etfPrices.add(priceData['price']);
    if (mounted) {
      setState(() {
        itemCount = etfCodes.length;
      });
    }
  }

  Future<void> fetchCoins() async {
    await fetchExchangeInfo();
  }
}

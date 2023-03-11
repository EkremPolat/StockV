import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stockv/BinanceEtfComponent/SingleEtfComponent/singleEtfComponent.dart';
import 'package:http/http.dart' as http;

var etfCodes = <String>{};
List<String> etfPrices = [];
List<String> etfDailyChanges = [];
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
    final response = await http
        .get(Uri.parse('https://www.binance.com/api/v3/exchangeInfo'));
    final data = jsonDecode(response.body);
    final etfList = (data as Map)['symbols'];

    final etfRequests = <Future>[];
    final etfResponses = <String, dynamic>{};
    final newEtfCodes = <String>[];

    for (var symbol in etfList) {
      final tradeSymbol = (symbol as Map)['symbol'];
      if (tradeSymbol.endsWith('USDT') &&
          !etfResponses.containsKey(tradeSymbol)) {
        final name = (symbol)['baseAsset'];
        final permissions = (symbol)['permissions'];
        if (permissions.contains("TRD_GRP_005")) {
          etfResponses[tradeSymbol] = await http.get(Uri.parse(
              "https://api.binance.com/api/v1/ticker/24hr?symbol=$tradeSymbol"));
          final dailyChangeData = jsonDecode(etfResponses[tradeSymbol].body);
          final dailyChange = dailyChangeData["priceChangePercent"];
          newEtfCodes.add(name);
          etfDailyChanges.add(dailyChange);
          etfRequests.add(fetchEtfPrices(name));
        }
        if (newEtfCodes.length == 50) {
          break;
        }
      }

      if (mounted) {
        setState(() {
          etfCodes.addAll(newEtfCodes);
        });
      }

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

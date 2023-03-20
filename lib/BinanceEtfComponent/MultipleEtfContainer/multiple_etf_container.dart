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
      itemCount: (etfCodes.length / 12).ceil(),
      itemBuilder: (context, pageIndex) {
        final startIndex = pageIndex * 12;
        final endIndex = startIndex + 12;
        final pageEtfList = etfCodesList.sublist(startIndex,
            endIndex < etfCodes.length ? endIndex : etfCodes.length);
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

  Future<void> fetchCoins() async {
    //TODO: Back-end connection will be implemented.
  }
}

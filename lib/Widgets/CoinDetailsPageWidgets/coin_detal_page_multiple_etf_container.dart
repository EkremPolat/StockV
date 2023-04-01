import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stockv/BinanceEtfComponent/SingleEftListTile/single_eft_list_tile.dart';
import 'package:stockv/Models/coin.dart';
import 'package:stockv/Models/user.dart';
import 'package:stockv/Utilities/global_variables.dart';
import 'package:stockv/Utilities/http_request_functions.dart';

class CoinDetailPageMultipleEtfContainerState extends StatefulWidget {
  final User user;

  const CoinDetailPageMultipleEtfContainerState({Key? key, required this.user})
      : super(key: key);

  @override
  State<CoinDetailPageMultipleEtfContainerState> createState() =>
      _CoinDetailPageMultipleEtfContainerState();
}

class _CoinDetailPageMultipleEtfContainerState
    extends State<CoinDetailPageMultipleEtfContainerState> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (mounted) {
        fetchSavedCoins();
      }
    });
  }

  // ignore: todo
  //TODO: Graph counts and coins will be adjusted.
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: savedCoinList.length,
      itemBuilder: (context, index) {
        final coinValue = savedCoinList[index];
        final coinSymbol = coinValue.symbol;
        final coinIcon = 'images/coin_icons/$coinSymbol.png';

        return Card(
            elevation: 4.0,
            margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            child: CoinListTile(
              coinValue: coinValue,
              coinIcon: coinIcon,
              user: widget.user,
              fromHomePage: true,
            ));
      },
    );
  }

  Future<void> fetchSavedCoins() async {
    List<Coin> savedCoins = await fetchSavedCoinsFromDB(widget.user.id);
    if (mounted) {
      setState(() {
        savedCoinList = savedCoins;
      });
    }
  }
}

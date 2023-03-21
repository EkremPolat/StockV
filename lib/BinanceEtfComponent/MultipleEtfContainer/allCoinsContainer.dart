import 'dart:async';

import 'package:flutter/material.dart';

import '../../Models/Coin.dart';
import '../../Models/User.dart';
import '../../Utilities/HttpRequestFunctions.dart';
import '../SingleEftListTile/singleEftListTile.dart';

List<Coin> coinList = [];

class AllCoinsContainerState extends StatefulWidget {
  User user;
  AllCoinsContainerState({super.key, required this.user});

  @override
  State<AllCoinsContainerState> createState() =>
      _MultipleEtfContainerState();
}

class _MultipleEtfContainerState extends State<AllCoinsContainerState> {
  late Timer _timer;
  @override
  void initState() {
    super.initState();
    fetchCoins();

    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (mounted) {
        fetchCoins();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    // Cancel the timer when the widget is disposed
    _timer.cancel();
  }


  @override
  Widget build(BuildContext context) {

    return ListView.builder(
      itemCount: coinList.length,
      itemBuilder: (context, index) {
        final coinValue = coinList[index];
        final coinSymbol = coinValue.symbol;
        final coinIcon = 'images/coin_icons/$coinSymbol.png';

        return Card(
          elevation: 4.0,
          margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: CoinListTile(coinValue: coinValue, coinIcon: coinIcon, user: widget.user, fromHomePage: true)
        );
      },
    );
  }

  Future<void> fetchCoins() async {
    List<Coin> coins = await fetchCoinsFromDB();
    if(mounted) {
      setState(() {
        coinList = coins;
      });
    }
  }


}

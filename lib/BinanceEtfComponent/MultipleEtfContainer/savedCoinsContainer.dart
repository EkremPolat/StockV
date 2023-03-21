import 'dart:async';

import 'package:flutter/material.dart';

import '../../Models/Coin.dart';
import '../../Models/User.dart';
import '../../Utilities/HttpRequestFunctions.dart';
import '../../Utilities/SavedCoinList.dart';
import '../SingleEftListTile/singleEftListTile.dart';

class SavedCoinsContainerState extends StatefulWidget {
  User user;
  SavedCoinsContainerState({super.key, required this.user});

  @override
  State<SavedCoinsContainerState> createState() =>
      _SavedCoinsContainerState();
}

class _SavedCoinsContainerState extends State<SavedCoinsContainerState> {
  late Timer _timer;
  @override
  void initState() {
    super.initState();
    fetchSavedCoins();

    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (mounted) {
        fetchSavedCoins();
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
      itemCount: savedCoinList.length,
      itemBuilder: (context, index) {
        final coinValue = savedCoinList[index];
        final coinSymbol = coinValue.symbol;
        final coinIcon = 'images/coin_icons/$coinSymbol.png';

        return Card(
            elevation: 4.0,
            margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            child: CoinListTile(coinValue: coinValue, coinIcon: coinIcon, user: widget.user, fromHomePage: false)
        );
      },
    );
  }

  Future<void> fetchSavedCoins() async {
    List<Coin> savedCoins = await fetchSavedCoinsFromDB(widget.user.id);
    if(mounted) {
      setState(() {
        savedCoinList = savedCoins;
      });
    }
  }

}

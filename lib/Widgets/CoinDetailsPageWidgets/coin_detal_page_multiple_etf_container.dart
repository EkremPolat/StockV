import 'package:flutter/material.dart';
import 'package:stockv/BinanceEtfComponent/SingleEftListTile/singleEftListTile.dart';
import 'package:stockv/Models/Coin.dart';
import 'package:stockv/Utilities/http_request_functions.dart';
import 'package:stockv/Widgets/CoinDetailsPageWidgets/EtfGraphConnector/single_etf_graph_component.dart';

List<Coin> coinList = [];
bool showDetails = false;

class CoinDetailPageMultipleEtfContainerState extends StatefulWidget {
  final List<String> savedEtfCodes;

  const CoinDetailPageMultipleEtfContainerState(
      {Key? key, required this.savedEtfCodes})
      : super(key: key);

  @override
  State<CoinDetailPageMultipleEtfContainerState> createState() =>
      _CoinDetailPageMultipleEtfContainerState();
}

class _CoinDetailPageMultipleEtfContainerState
    extends State<CoinDetailPageMultipleEtfContainerState> {
  @override
  void initState() {
    super.initState();
    fetchCoins();
  }

  // ignore: todo
  //TODO: Graph counts and coins will be adjusted.
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: coinList.length < 6 ? coinList.length : 5,
      itemBuilder: (context, index) {
        final coinValue = coinList[index];
        final coinSymbol = coinValue.symbol;
        final coinIcon = 'images/coin_icons/$coinSymbol.png';

        return Card(
            elevation: 4.0,
            margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            child: CoinListTile(coinValue: coinValue, coinIcon: coinIcon));
      },
    );
  }

  Future<void> fetchCoins() async {
    List<Coin> coins = await fetchCoinsFromDB();
    if (mounted) {
      setState(() {
        coinList = coins;
      });
    }
  }
}

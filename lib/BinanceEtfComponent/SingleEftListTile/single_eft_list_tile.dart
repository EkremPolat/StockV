import 'package:flutter/material.dart';
import 'package:stockv/Widgets/CoinDetailsPageWidgets/CoinDetailPagePastValueGraphComponents/single_etf_detail_component.dart';
import '../../Models/user.dart';
import '../../Utilities/http_request_functions.dart';
import '../../Models/coin.dart';
import '../../Utilities/saved_coin_list.dart';

class CoinListTile extends StatefulWidget {
  final Coin coinValue;
  final String coinIcon;
  final User user;
  final bool fromHomePage;

  const CoinListTile(
      {super.key,
      required this.coinValue,
      required this.coinIcon,
      required this.user,
      required this.fromHomePage});

  @override
  State<CoinListTile> createState() => _CoinListTileState();
}

class _CoinListTileState extends State<CoinListTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: Image(
        image: AssetImage(widget.coinIcon),
        fit: BoxFit.cover,
        width: 25,
      ),
      title: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              widget.coinValue.name,
              style:
                  const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            width: 100,
            child: Text(
              '\$${widget.coinValue.price.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18.0),
            ),
          ),
        ],
      ),
      subtitle: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              widget.coinValue.symbol,
              style: const TextStyle(fontSize: 18.0),
            ),
          ),
          if (widget.coinValue.dailyChange > 0)
            SizedBox(
              width: 100,
              child: Text(
                widget.coinValue.dailyChange.toStringAsFixed(2),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.green,
                ),
              ),
            ),
          if (widget.coinValue.dailyChange < 0)
            SizedBox(
              width: 100,
              child: Text(
                widget.coinValue.dailyChange.toStringAsFixed(2),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.red,
                ),
              ),
            )
        ],
      ),
      trailing: widget.fromHomePage
          ? savedCoinList.map((e) => e.id).contains(widget.coinValue.id)
              ? IconButton(
                  icon: const Icon(Icons.star, color: Colors.yellow),
                  onPressed: () async {
                    setState(() {
                      savedCoinList.removeWhere(
                          (coin) => coin.id == widget.coinValue.id);
                    });
                    await removeSavedCoins(widget.coinValue.id);
                  },
                )
              : IconButton(
                  icon: const Icon(Icons.star_border),
                  onPressed: () async {
                    setState(() {
                      savedCoinList.add(Coin(
                          id: widget.coinValue.id,
                          name: widget.coinValue.name,
                          price: widget.coinValue.price,
                          dailyChange: widget.coinValue.dailyChange,
                          symbol: widget.coinValue.symbol));
                      savedCoinList.sort((a, b) => b.price.compareTo(a.price));
                    });
                    await addSavedCoins(widget.coinValue.id);
                  },
                )
          : const SizedBox(),
      onTap: () {
        setState(() {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      SingleEtfGraphComponent(coin: widget.coinValue)));
        });
      },
    );
  }

  Future<void> addSavedCoins(int coinId) async {
    await addSavedCoinsToUser(widget.user.id, coinId);
  }

  Future<void> removeSavedCoins(int coinId) async {
    await removeSavedCoinsFromUser(widget.user.id, coinId);
  }
}

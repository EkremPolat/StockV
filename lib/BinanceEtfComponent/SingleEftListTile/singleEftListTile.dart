import 'package:flutter/material.dart';
import 'package:stockv/Widgets/CoinDetailsPageWidgets/EtfGraphConnector/single_etf_graph_component.dart';

import '../../Models/Coin.dart';

class CoinListTile extends StatefulWidget {
  final Coin coinValue;
  final String coinIcon;

  const CoinListTile(
      {super.key, required this.coinValue, required this.coinIcon});

  @override
  State<CoinListTile> createState() => _CoinListTileState();
}

class _CoinListTileState extends State<CoinListTile> {
  bool isStarred = false;

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
      trailing: IconButton(
        icon: isStarred
            ? const Icon(Icons.star, color: Colors.yellow)
            : const Icon(Icons.star_border),
        onPressed: () {
          setState(() {
            isStarred = !isStarred;
          });
        },
      ),
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
}

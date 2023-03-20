import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:stockv/BinanceEtfComponent/MultipleEtfContainer/multiple_etf_container.dart';

class SingleEtfComponent extends StatefulWidget {
  final Function(List<String>) updateStringList;
  final Function(String) saveCoin;
  final String etfCode;
  final String etfPrice;
  final String etfDailyChange;
  final int index;

  const SingleEtfComponent(
      {Key? key,
      required this.updateStringList,
      required this.saveCoin,
      required this.etfCode,
      required this.etfPrice,
      required this.etfDailyChange,
      required this.index})
      : super(key: key);

  @override
  State<SingleEtfComponent> createState() => _SingleEtfComponentState();
}

class _SingleEtfComponentState extends State<SingleEtfComponent> {
  late Timer _timer;
  late String _assetImage = 'images/white.png';
  late String _etfPrice = widget.etfPrice;

  @override
  void initState() {
    super.initState();
    getAssetImage(widget.etfCode).then((assetImage) {
      setState(() {
        _assetImage = assetImage;
      });
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      fetchEtfPrice();
    });
  }

  @override
  void dispose() {
    super.dispose();
    // Cancel the timer when the widget is disposed
    _timer.cancel();
  }

  Future<void> fetchEtfPrice() async {
    final response = await http.get(Uri.parse(
        'https://api.binance.com/api/v3/ticker/price?symbol=${widget.etfCode}USDT'));
    final data = jsonDecode(response.body);
    double etfUpdatedPrice = 0.0;
    if (data is Map && data.containsKey('price')) {
      etfUpdatedPrice = double.tryParse(data['price'] ?? '') ?? 0.0;
    }
    if (mounted) {
      setState(() {
        _etfPrice = etfUpdatedPrice.toStringAsFixed(2);
      });
      List<String> newList = List.from(etfPrices); // Copy the existing list
      newList[widget.index] = etfUpdatedPrice
          .toStringAsFixed(2); // Modify the element at the given index
      widget.updateStringList(newList); // Update the parent state
    }
  }

  @override
  Widget build(BuildContext context) {
    double dailyChange;

    try {
      dailyChange = double.parse(widget.etfDailyChange);
      // use dailyChange variable
    } catch (e) {
      // handle error
      dailyChange = 0.0;
    }

    return PageStorage(
        bucket: PageStorageBucket(),
        child: Scaffold(
          backgroundColor:
              widget.index % 2 == 0 ? Colors.black12 : Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 100),
                  const SizedBox(width: 30),
                  Image(
                    image: AssetImage(_assetImage),
                    fit: BoxFit.cover,
                    width: 25,
                  ),
                  const SizedBox(width: 20), // give it width
                  SizedBox(
                    width: 70,
                    child: Text(
                      widget.etfCode.toUpperCase(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "Brandon Grotesque",
                          fontSize: 20,
                          color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 20), // give it width
                  SizedBox(
                    width: 100,
                    child: Text(
                      double.parse(_etfPrice).toString(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "Brandon Grotesque",
                          fontSize: 20,
                          color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 20),
                  if (dailyChange >= 0)
                    SizedBox(
                      width: 100,
                      child: Text(
                        "  ${widget.etfDailyChange}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          fontFamily: "Brandon Grotesque",
                          color: Colors.green,
                        ),
                      ),
                    ),
                  if (dailyChange < 0)
                    SizedBox(
                      width: 100,
                      child: Text(
                        widget.etfDailyChange,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "Brandon Grotesque",
                          fontSize: 20,
                          color: Colors.red,
                        ),
                      ),
                    )
                ],
              ),
            ),
          ),
        ));
  }
}

Future<String> getAssetImage(String etfCode) async {
  try {
    final imageData = await rootBundle.load('images/coin_icons/$etfCode.png');
    final imageProvider = MemoryImage(imageData.buffer.asUint8List());
    return 'images/coin_icons/$etfCode.png';
  } catch (_) {
    return 'images/white.png';
  }
}

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:stockv/Models/coin.dart';
import 'package:stockv/Models/has_crypto_data.dart';
import 'package:stockv/Models/user.dart';
import 'package:stockv/Utilities/coin_buy_sell_request_funtions.dart';
import 'package:stockv/Models/coin_graph_data.dart';
import 'package:stockv/Utilities/user_wallet_information_requests.dart';
import 'package:stockv/Widgets/CoinDetailsPageWidgets/CoinDetailPagePastValueGraphComponents/CoinDetailLiveChartComponent/coin_live_chart_component.dart';
import 'package:stockv/Widgets/CoinDetailsPageWidgets/CoinDetailPagePastValueGraphComponents/single_etf_past_value_graph_component.dart';
import 'package:http/http.dart' as http;

String coinVolume = '';
String coinLowestPrice = '';
String coinHighestPrice = '';

List<String> buySellPrices = ['', ''];

bool sellButtonDisabled = true;
int maxSellableAmount = 0;

class SingleEtfGraphComponent extends StatefulWidget {
  final User user;
  final Coin coin;

  const SingleEtfGraphComponent(
      {Key? key, required this.user, required this.coin})
      : super(key: key);

  @override
  State<SingleEtfGraphComponent> createState() =>
      SingleEtfGraphComponentState();
}

class SingleEtfGraphComponentState extends State<SingleEtfGraphComponent> {
  late Timer _timer;

  final List<EtfPriceData> _etfPriceData = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      buySellPrices = ['', ''];
      coinVolume = '';
      coinLowestPrice = '';
      coinHighestPrice = '';
      sellButtonDisabled = true;
      maxSellableAmount = 0;
    });
    readCoinInfo();
    fetchEtfBuySellPrices();
    fetchDoesUserHasCrypto();
    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      fetchEtfPrice();
    });
  }

  @override
  void dispose() {
    super.dispose();
    // Cancel the timer when the widget is disposed
    _timer.cancel();
  }

  Future<void> readCoinInfo() async {
    final response = await http.get(Uri.parse(
        'https://api.binance.com/api/v3/ticker/24hr?symbol=${widget.coin.symbol}USDT'));
    final data = jsonDecode(response.body);
    setState(() {
      coinVolume = double.parse(data['volume']).toString();
      coinLowestPrice = double.parse(data['lowPrice']).toString();
      coinHighestPrice = double.parse(data['highPrice']).toString();
    });
  }

  Future<void> fetchEtfBuySellPrices() async {
    List<String> data = await fetchBuySellPrices(widget.coin.symbol);
    setState(() {
      buySellPrices = data;
    });
  }

  Future<void> fetchDoesUserHasCrypto() async {
    HasCryptoData response =
        await hasCrypto(widget.user.id, widget.coin.symbol);
    setState(() {
      if (response.getHasCrypto() == true) {
        sellButtonDisabled = false;
        maxSellableAmount = response.getAmount();
      } else {
        sellButtonDisabled = true;
        maxSellableAmount = 0;
      }
    });
  }

  Future<void> fetchEtfPrice() async {
    final response = await http.get(Uri.parse(
        'https://api.binance.com/api/v3/ticker/price?symbol=${widget.coin.symbol}USDT'));
    final data = jsonDecode(response.body);
    double etfUpdatedPrice = 0.0;
    if (data is Map && data.containsKey('price')) {
      etfUpdatedPrice = double.tryParse(data['price'] ?? '') ?? 0.0;
    }
    if (!mounted) return;
    final now = DateTime.now();
    setState(() {
      _etfPriceData.add(EtfPriceData(now, etfUpdatedPrice));
      if (_etfPriceData.length > 100) {
        _etfPriceData.removeAt(0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              '${widget.coin.symbol}/USDT',
              style: const TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '24 Hour Volume:',
                  style: TextStyle(fontSize: 25.0),
                ),
                Text(
                  coinVolume,
                  style: const TextStyle(fontSize: 25.0),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Highest Price:',
                  style: TextStyle(fontSize: 25.0),
                ),
                Text(
                  '$coinHighestPrice\$',
                  style: const TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Lowest Price:',
                  style: TextStyle(fontSize: 25.0),
                ),
                Text(
                  '$coinLowestPrice\$',
                  style: const TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                )
              ],
            ),
            SizedBox(
              height: 400,
              child:
                  SingleEtfPastValueGraphComponent(etfCode: widget.coin.symbol),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SingleEtfLiveChartComponent(
                                    coin: widget.coin,
                                  )));
                    },
                    child: const Text(
                      'SEE LIVE CHART',
                    ))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  buySellPrices[0],
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.deepPurpleAccent),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  buySellPrices[1],
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Colors.deepPurpleAccent),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      showBuyCryptoDialog(context);
                      //TODO: Actual buying process will be implemented
                    },
                    child: const Text(
                      'BUY',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    )),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: sellButtonDisabled
                        ? null
                        : () {
                            showSellCryptoDialog(context);
                            //TODO: Actual selling process will be implemented
                          },
                    child: const Text(
                      'SELL',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }

  late BuildContext buyDialogContext;
  late BuildContext sellDialogContext;

  showBuyCryptoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        buyDialogContext = context;
        return SimpleDialog(
          children: <Widget>[
            const Text(
              'How much would you like to buy?',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.deepPurpleAccent),
            ),
            TextFormField(
              autofocus: true,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 18, color: Colors.black),
            )
          ],
        );
      },
    );
  }

  showSellCryptoDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          sellDialogContext = context;
          return SimpleDialog(
            children: <Widget>[
              const Text(
                'How much would you like to sell?',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.deepPurpleAccent),
              ),
              TextFormField(
                autofocus: true,
                keyboardType: TextInputType.number,
                style: const TextStyle(fontSize: 18, color: Colors.black),
              ),
            ],
          );
        });
  }
}

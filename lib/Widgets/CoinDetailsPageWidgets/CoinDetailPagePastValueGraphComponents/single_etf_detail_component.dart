import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:stockv/Models/coin.dart';
import 'package:stockv/Models/coin_graph_data.dart';
import 'package:stockv/Models/has_crypto_data.dart';
import 'package:stockv/Models/user.dart';
import 'package:stockv/Utilities/coin_buy_sell_request_funtions.dart';
import 'package:stockv/Utilities/future_predictions_functions.dart';
import 'package:stockv/Utilities/user_wallet_information_requests.dart';
import 'package:stockv/Widgets/CoinDetailsPageWidgets/CoinDetailPagePastValueGraphComponents/single_eft_sell_page.dart';
import 'package:stockv/Widgets/CoinDetailsPageWidgets/CoinDetailPagePastValueGraphComponents/single_etf_buy_page.dart';
import 'package:stockv/Widgets/CoinDetailsPageWidgets/CoinDetailPagePastValueGraphComponents/single_etf_future_price_predictions_page.dart';
import 'package:stockv/Widgets/CoinDetailsPageWidgets/CoinDetailPagePastValueGraphComponents/single_etf_graph.dart';
import 'package:http/http.dart' as http;
import '../loading_page.dart';
import 'detect_chart_patterns.dart';

String coinVolume = '';
String coinLowestPrice = '';
String coinHighestPrice = '';
String coinPrice = '';

List<String> buySellPrices = ['', ''];

bool sellButtonDisabled = true;
double maxSellableAmount = 0;

String etfCode = "";
String intervalCode = 'm';
int intervalValue = 15;
Duration duration = const Duration(hours: 24);

const List<String> durationList = ['15m', '1h', '4h', '1d', '1w', '1M'];
String dropdownListValue = '15m';

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
  bool isLoading = true;
  List<EtfPriceData> predictionList = [];

  @override
  void initState() {
    super.initState();
    fetchPredictions(widget.coin.symbol);
    setState(() {
      buySellPrices = ['', ''];
      coinVolume = '';
      coinLowestPrice = '';
      coinHighestPrice = '';
      coinPrice = '';
      sellButtonDisabled = true;
      maxSellableAmount = 0;
    });

    readCoinInfo();
    fetchEtfPrice();
    fetchEtfBuySellPrices();
    fetchDoesUserHasCrypto();

    _timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      fetchEtfPrice();
      fetchEtfBuySellPrices();
      fetchDoesUserHasCrypto();
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
      coinVolume = double.parse(data['volume']).toStringAsFixed(2);
      coinLowestPrice = double.parse(data['lowPrice']).toStringAsFixed(2);
      coinHighestPrice = double.parse(data['highPrice']).toStringAsFixed(2);
    });
  }

  Future<void> fetchEtfBuySellPrices() async {
    List<String> data = await fetchBuySellPrices(widget.coin.symbol);
    if (mounted) {
      setState(() {
        buySellPrices = data;
      });
    }
  }

  Future<void> fetchDoesUserHasCrypto() async {
    HasCryptoData response = await hasCrypto(widget.user.id, widget.coin.name);
    if (mounted) {
      setState(() {
        if (response.getHasCrypto() == true) {
          sellButtonDisabled = false;
          maxSellableAmount = response.getAmount();
        } else {
          sellButtonDisabled = true;
          maxSellableAmount = 0;
        }
        isLoading = false;
      });
    }
  }

  Future<void> fetchEtfPrice() async {
    final response = await http.get(Uri.parse(
        'https://api.binance.com/api/v3/ticker/price?symbol=${widget.coin.symbol}USDT'));
    final data = jsonDecode(response.body);
    double etfUpdatedPrice = 0.0;
    if (data is Map && data.containsKey('price')) {
      etfUpdatedPrice = double.tryParse(data['price'] ?? '') ?? 0.0;
      coinPrice = etfUpdatedPrice.toStringAsFixed(
          2); // Convert the price to a string and store it in coinPrice
    }
  }

  Future<void> fetchPredictions(etfCode) async {
    final response =
        await generatePredictions(etfCode, 'd', 1, const Duration(days: 365));
    if (mounted) {
      setState(() {
        predictionList = response;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const LoadingScreen();
    } else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurpleAccent,
          leadingWidth: 400,
          leading: Row(children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
            ),
            Image.asset('images/black.png'),
          ]),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              color: const Color(0xff17212F),
              // Set the background color to pink

              child: Column(
                children: [
                  Text(
                    '${widget.coin.symbol}/USDT',
                    style: const TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // New Text widget on the left side

                      const Expanded(
                        child: Text(
                          '24 Hour Volume:',
                          style: TextStyle(
                            fontSize: 14.0, // Adjust the font size as desired
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      const SizedBox(
                          width:
                              10), // Add a space of 10 pixels between the two texts
                      Text(
                        coinVolume,
                        style: const TextStyle(
                          fontSize: 14.0, // Adjust the font size as desired
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$$coinPrice',
                        style: const TextStyle(
                          fontSize: 30.0,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const Expanded(
                        child: Text(
                          'Highest Price:',
                          style: TextStyle(
                            fontSize: 14.0, // Adjust the font size as desired
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      const SizedBox(
                          width:
                              10), // Add a space of 10 pixels between the two texts
                      Text(
                        '\$$coinHighestPrice',
                        style: const TextStyle(
                          fontSize: 14.0, // Adjust the font size as desired
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${widget.coin.dailyChange >= 0 ? '+' : '-'}${widget.coin.dailyChange.toStringAsFixed(2)}%',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: widget.coin.dailyChange > 0
                              ? Colors.green
                              : widget.coin.dailyChange < 0
                                  ? Colors.red
                                  : Colors.white,
                        ),
                        textAlign: TextAlign.left,
                      ),

                      const Expanded(
                        child: Text(
                          'Lowest Price:',
                          style: TextStyle(
                            fontSize: 14.0, // Adjust the font size as desired
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      const SizedBox(
                          width:
                              10), // Add a space of 10 pixels between the two texts
                      Text(
                        '\$$coinLowestPrice',
                        style: const TextStyle(
                          fontSize: 14.0, // Adjust the font size as desired
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                  Column(children: [
                    SizedBox(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: durationList.map((String value) {
                          return Flexible(
                            flex: 1,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: dropdownListValue == value
                                    ? const Color.fromARGB(255, 13, 45, 75)
                                    : const Color.fromARGB(255, 60, 94, 125),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                minimumSize: const Size(55,
                                    25), // Adjust the width and height as desired
                              ),
                              onPressed: () {
                                setState(() {
                                  dropdownListValue = value;
                                  if (value == '15m') {
                                    duration = const Duration(hours: 24);
                                    intervalCode = 'm';
                                    intervalValue = 15;
                                  } else if (value == '1h') {
                                    duration = const Duration(days: 7);
                                    intervalCode = 'h';
                                    intervalValue = 1;
                                  } else if (value == '4h') {
                                    duration = const Duration(days: 7);
                                    intervalCode = 'h';
                                    intervalValue = 4;
                                  } else if (value == '1d') {
                                    duration = const Duration(days: 365);
                                    intervalCode = 'd';
                                    intervalValue = 1;
                                  } else if (value == '1w') {
                                    duration = const Duration(days: 365 * 10);
                                    intervalCode = 'w';
                                    intervalValue = 1;
                                  } else if (value == '1M') {
                                    duration = const Duration(days: 365 * 5);
                                    intervalCode = 'M';
                                    intervalValue = 1;
                                  }
                                });
                              },
                              child: Text(
                                value,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(
                      height: 600,
                      child: SingleEtfPastValueGraphComponent(
                        etfCode: widget.coin.symbol,
                        intervalValue: intervalValue,
                        duration: duration,
                        intervalCode: intervalCode,
                        key: ValueKey<String>(
                            dropdownListValue), // Add a key to force component update
                      ),
                    ),
                  ]),
                  const SizedBox(height: 15,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            '${widget.coin.symbol} Buy Price: \$${buySellPrices[0]}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.green,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            '${widget.coin.symbol} Sell Price: \$${buySellPrices[1]}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.red,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15,),
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
                                    builder: (context) => FuturePriceGraph(
                                          etfPriceData: predictionList,
                                        )));
                          },
                          child: const Text(
                            'SEE FUTURE VALUE PREDICTIONS',
                          ))
                    ],
                  ),
                  Column(
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
                                    builder: (context) => ChartPatternButtons(
                                          intervalCode: intervalCode,
                                          duration: duration,
                                          etfCode: widget.coin.symbol,
                                          intervalValue: intervalValue,
                                        )));
                          },
                          child: const Text(
                            'SEE CHART PATTERNS',
                          ))
                    ],
                  ),
                  const SizedBox(height: 15,),
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
                          setState(() {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CoinBuyComponent(
                                          user: widget.user,
                                          coin: widget.coin,
                                          coinBuyValue: buySellPrices[0],
                                        )));
                          });
                        },
                        child: const Text(
                          'BUY',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22),
                        )),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          disabledBackgroundColor: Colors.grey,
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),

                        onPressed: sellButtonDisabled
                            ? null
                            : () {
                                setState(() {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CoinSellComponent(
                                                user: widget.user,
                                                coin: widget.coin,
                                                maxSellableAmount:
                                                    maxSellableAmount,
                                                coinSellValue: buySellPrices[1],
                                              )));
                                });
                              },
                        child: const Text(
                          'SELL',
                          style: TextStyle(
                              color:Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
                        ),),
                  ],
                ),
                  const SizedBox(height: 15,),
              ],
            ),
          ),
        ),
      ),
      );
    }
  }
}

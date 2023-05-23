import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stockv/Utilities/global_variables.dart';

import '../../../Models/coin.dart';
import '../../../Models/transaction.dart';
import '../../../Models/user.dart';
import '../../../Models/wallet_coin.dart';
import '../../../Utilities/user_wallet_information_requests.dart';
import 'package:stockv/Widgets/rootpage_widget.dart';

class CoinSellComponent extends StatefulWidget {
  final User user;
  final Coin coin;
  final double maxSellableAmount;
  final String coinSellValue;

  const CoinSellComponent(
      {Key? key,
      required this.user,
      required this.coin,
      required this.maxSellableAmount,
      required this.coinSellValue})
      : super(key: key);

  @override
  State<CoinSellComponent> createState() => CoinSellComponentState();
}

class CoinSellComponentState extends State<CoinSellComponent> {
  int _secondsRemaining = 120;
  Timer? _timer;

  final TextEditingController _coinAmountValue = TextEditingController();
  final TextEditingController _coinPriceValue = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (timer) {
      setState(() {
        if (mounted) {
          if (_secondsRemaining < 1) {
            _timer?.cancel();
            Future.delayed(Duration.zero, () {
              _showWarningPopup(context);
            });
          } else {
            _secondsRemaining -= 1;
          }
        }
      });
    });
  }

  String get timerText {
    int minutes = (_secondsRemaining / 60).floor();
    int seconds = _secondsRemaining - (minutes * 60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
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
          child: FractionallySizedBox(
            widthFactor: 0.9,
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Text(
                  '${widget.coin.symbol}/USDT',
                  style: const TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        style:
                            const TextStyle(fontSize: 20, color: Colors.black),
                        children: <TextSpan>[
                          const TextSpan(text: 'Your Balance: '),
                          TextSpan(
                            text: '\$${widget.user.balance.toStringAsFixed(3)}',
                            style: const TextStyle(color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      timerText,
                      style: const TextStyle(fontSize: 20, color: Colors.red),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 20, color: Colors.black),
                      children: <TextSpan>[
                        const TextSpan(text: 'Your Coin Amount: '),
                        TextSpan(
                          text: widget.maxSellableAmount.toStringAsFixed(3),
                          style: const TextStyle(color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 20, color: Colors.black),
                      children: <TextSpan>[
                        const TextSpan(text: 'Coin Sell Price: '),
                        TextSpan(
                          text: '\$${widget.coinSellValue}',
                          style: const TextStyle(color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                    key: _formKey,
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      runSpacing: 10,
                      children: <Widget>[
                        TextFormField(
                          controller: _coinAmountValue,
                          enableSuggestions: false,
                          autocorrect: false,
                          validator: (val) {
                            if (val == null || double.tryParse(val) == null) {
                              return "Amount cannot be empty!";
                            } else if (double.parse(val) >
                                widget.maxSellableAmount) {
                              return "You do not have enough coin!";
                            }

                            return null;
                          },
                          onChanged: (text) {
                            if (text.isNotEmpty) {
                              setState(() {
                                double calculatedPrice = double.parse(text) *
                                    double.parse(widget.coinSellValue);
                                _coinPriceValue.text =
                                    calculatedPrice.toStringAsFixed(3);
                              });
                            }
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Amount",
                            labelStyle: const TextStyle(color: Colors.black),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                  color: Colors.deepPurpleAccent, width: 2),
                            ),
                            errorStyle: const TextStyle(fontSize: 16),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide:
                                  const BorderSide(color: Colors.red, width: 2),
                            ),
                          ),
                          style: const TextStyle(
                              fontSize: 20, color: Colors.black),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: _coinPriceValue,
                          enableSuggestions: false,
                          autocorrect: false,
                          keyboardType: TextInputType.number,
                          onChanged: (text) {
                            if (text.isNotEmpty) {
                              setState(() {
                                double calculatedAmount = double.parse(text) /
                                    double.parse(widget.coinSellValue);
                                _coinAmountValue.text =
                                    calculatedAmount.toStringAsFixed(3);
                              });
                            }
                          },
                          decoration: InputDecoration(
                            labelText: "Price (\$)",
                            labelStyle: const TextStyle(color: Colors.black),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                  color: Colors.deepPurpleAccent, width: 2),
                            ),
                            errorStyle: const TextStyle(fontSize: 16),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide:
                                  const BorderSide(color: Colors.red, width: 2),
                            ),
                          ),
                          style: const TextStyle(
                              fontSize: 20, color: Colors.black),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Column(
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurpleAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  // show the success popup immediately
                                  _showSuccessPopup(context);

                                  // run the async function in the background after a delay
                                  await saveSellingToDB(
                                      widget.user.id,
                                      widget.coin.name,
                                      double.parse(_coinAmountValue.text),
                                      double.parse(_coinPriceValue.text));
                                }
                              },
                              child: const Text(
                                "SELL",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              onPressed: () async {
                                setState(() {
                                  _coinAmountValue.text = widget.maxSellableAmount.toString();
                                  double price = widget.maxSellableAmount * double.parse(widget.coinSellValue);
                                  _coinPriceValue.text = price.toString();
                                });
                              },
                              child: const Text(
                                "SET ALL AMOUNT",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),

                      ],
                    )),
              ],
            ),
          ),
        ));
  }

  Future<void> saveSellingToDB(String userId, String coinName, double amount,
      double totalEarning) async {
    widget.user.balance =
        await sellCrypto(userId, coinName, amount, totalEarning);
    List<WalletCoin> userWallet = await getUserWallet(widget.user.id);
    List<Transaction> transactionList =
        await getUserTransactionHistory(widget.user.id);
    wallet = userWallet;
    transactions = transactionList;
  }

  void _showWarningPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Time is up!'),
          content: const Text('Your time has expired.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                      return RootPageState(user: widget.user, index: 0);
                  }));
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Icon(Icons.check_circle, color: Colors.green, size: 80),
          content: const Text(
            'Congratulations! Your transaction was successful.',
            style: TextStyle(fontSize: 20),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                      return RootPageState(user: widget.user, index: 3);
                  }));
              },
              child: const Text('OK', style: TextStyle(fontSize: 18)),
            ),
          ],
        );
      },
    );
  }
}

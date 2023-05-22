import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stockv/Utilities/global_variables.dart';

import '../../../Models/coin.dart';
import '../../../Models/transaction.dart';
import '../../../Models/user.dart';
import '../../../Models/wallet_coin.dart';
import '../../../Utilities/user_wallet_information_requests.dart';
import 'package:stockv/Widgets/rootpage_widget.dart';

class CoinBuyComponent extends StatefulWidget {
  final User user;
  final Coin coin;
  final String coinBuyValue;

  const CoinBuyComponent(
      {Key? key,
      required this.user,
      required this.coin,
      required this.coinBuyValue})
      : super(key: key);

  @override
  State<CoinBuyComponent> createState() => CoinBuyComponentState();
}

class CoinBuyComponentState extends State<CoinBuyComponent> {
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
                        const TextSpan(text: 'Coin Price: '),
                        TextSpan(
                          text: '\$${widget.coinBuyValue}',
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
                          onChanged: (text) {
                            if (text.isNotEmpty) {
                              setState(() {
                                double calculatedPrice = double.parse(text) *
                                    double.parse(widget.coinBuyValue);
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
                                    color: Colors.deepPurpleAccent, width: 2)),
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
                          validator: (val) {
                            if (val == null || double.tryParse(val) == null) {
                              return "Price cannot be empty!";
                            } else if (double.parse(val) >
                                widget.user.balance) {
                              return "You do not have enough balance!";
                            }

                            return null;
                          },
                          keyboardType: TextInputType.number,
                          onChanged: (text) {
                            if (text.isNotEmpty) {
                              setState(() {
                                double calculatedAmount = double.parse(text) /
                                    double.parse(widget.coinBuyValue);
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
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurpleAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _showSuccessPopup(context);
                              await savePurchaseToDB(
                                  widget.user.id,
                                  widget.coin.name,
                                  double.parse(_coinAmountValue.text),
                                  double.parse(_coinPriceValue.text));
                            }
                          },
                          child: const Text(
                            "BUY",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ));
  }

  Future<void> savePurchaseToDB(
      String userId, String coinName, double amount, double totalCost) async {
    widget.user.balance = await buyCrypto(userId, coinName, amount, totalCost);
    List<WalletCoin> userWallet = await getUserWallet(widget.user.id);
    wallet = userWallet;
    List<Transaction> transactionList = await getUserTransactionHistory(widget.user.id);
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

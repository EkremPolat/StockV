// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, avoid_print, prefer_const_literals_to_create_immutables
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stockv/Models/user.dart';
import 'package:stockv/Models/wallet_coin.dart';
import 'package:stockv/Utilities/user_wallet_information_requests.dart';

List<WalletCoin> wallet = [];

class WalletPageState extends StatefulWidget {
  final User user;

  const WalletPageState({super.key, required this.user});

  @override
  State<WalletPageState> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPageState> {
  late Timer _timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (mounted) {
        fetchUserWallet();
      }
    });
  }

  Future<void> fetchUserWallet() async {
    List<WalletCoin> userWallet = await getUserWallet(widget.user.id);
    if (mounted) {
      setState(() {
        wallet = userWallet;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalValue = wallet.fold(0, (sum, coin) => sum + coin.usdValue);
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color.fromRGBO(46, 21, 157, 1),
      body: Column(
        children: [
          SizedBox(
            height: 140,
            child: Container(
              color: Color.fromRGBO(46, 21, 157, 0.6),
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.21),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Total Balance',
                      style: TextStyle(
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: screenWidth * 0.02),
                    Text(
                      '\$${totalValue.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: screenWidth * 0.08,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
                gradient: LinearGradient(
                  colors: [Color.fromARGB(255, 255, 102, 0), Colors.orange],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: ListView.builder(
                itemCount: wallet.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 16.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  wallet[index].coinName,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                  ),
                                ),
                                Text(
                                  wallet[index].coinSymbol,
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  wallet[index].amount.toStringAsFixed(4),
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                  ),
                                ),
                                Text(
                                  '\$${wallet[index].usdValue.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        height: 1,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CoinData {
  final String name;
  final String symbol;
  final double amount;
  final double price;

  CoinData(this.name, this.symbol, this.amount, this.price);

  double get usdValue => amount * price;
}

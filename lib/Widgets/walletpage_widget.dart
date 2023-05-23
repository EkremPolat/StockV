import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stockv/Models/user.dart';
import 'package:stockv/Models/wallet_coin.dart';
import 'package:stockv/Utilities/user_wallet_information_requests.dart';

import '../Utilities/global_variables.dart';

class WalletPageState extends StatefulWidget {
  final User user;

  const WalletPageState({super.key, required this.user});

  @override
  State<WalletPageState> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPageState> {
  late Timer _timer;
  double changePercentage = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
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
        WalletCoin temp = WalletCoin(
          coinName: "US Dollar",
          coinSymbol: "USD",
          amount: 1,
          usdValue: widget.user.getCurrency(),
          dailyChange: 0
        );
        wallet.add(temp);
        wallet.sort((a, b) => (b.amount*b.usdValue).compareTo(a.amount * a.usdValue));
        changePercentage = calculateTotalChange(wallet);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalValue =
        wallet.fold(0, (sum, coin) => sum + (coin.usdValue * coin.amount));
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 20
          ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        'Total Assets',
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: screenWidth * 0.02),
                      Row(
                        children: [
                          Text(
                            '\$${(totalValue).toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: screenWidth * 0.08,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            ' (${changePercentage.toStringAsFixed(2)}%)',
                            style: TextStyle(
                              fontSize: 16.0,
                              color:
                                  changePercentage >= 0 ? Colors.green : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    width: screenWidth * 0.05,
                  ),
                ],
              ),
            ),

          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: wallet.length,
              itemBuilder: (BuildContext context, int index) {
                final coinSymbol = wallet[index].coinSymbol;
                final coinIcon = 'images/coin_icons/$coinSymbol.png';
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: coinSymbol == 'USD' ? Colors.green : Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: Image(
                        image: AssetImage(coinIcon),
                        fit: BoxFit.cover,
                        width: 35,
                      ),
                      title: Text(
                        wallet[index].coinName,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      subtitle: Text(
                        wallet[index].coinSymbol,
                        style: const TextStyle(
                          fontSize: 17.0,
                        ),
                      ),
                      trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (coinSymbol != 'USD')
                              Text(
                                wallet[index].amount.toStringAsFixed(2),
                                style: const TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                          Expanded(
                              child: Row(
                                mainAxisSize: MainAxisSize
                                    .min, // This makes the Row take up only as much space as needed
                                children: [
                                  Text(
                                    '\$${(wallet[index].usdValue * wallet[index].amount).toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  if (coinSymbol != 'USD')
                                    Text(
                                      ' (${wallet[index].dailyChange.toStringAsFixed(2)}%)',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        color: wallet[index].dailyChange >= 0
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ]),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

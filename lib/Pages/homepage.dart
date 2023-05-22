import 'package:flutter/material.dart';
import 'package:stockv/Widgets/rootpage_widget.dart';
import '../Models/coin.dart';
import '../../Models/user.dart';
import '../../Utilities/http_request_functions.dart';
import '../Models/transaction.dart';
import '../Models/wallet_coin.dart';
import '../Utilities/global_variables.dart';
import '../Utilities/user_wallet_information_requests.dart';
import '../Widgets/CoinDetailsPageWidgets/loading_page.dart';


class HomePage extends StatefulWidget {
  final User user;
  final int index;

  const HomePage({
    Key? key,
    required this.user,
    this.index = 0,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchCoins();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:
          isLoading ? const LoadingScreen() : RootPageState(user: widget.user),
      //TopNavBar(),
    );
  }

  Future<void> fetchCoins() async {
    List<Coin> coins = await fetchCoinsFromDB();
    List<Coin> savedCoins = await fetchSavedCoinsFromDB(widget.user.id);
    List<Transaction> transactionList = await getUserTransactionHistory(widget.user.id);
    List<WalletCoin> userWallet = await getUserWallet(widget.user.id);
    double userBalance = await getUserBalance(widget.user.id);
    if (mounted) {
      setState(() {
        coinList = coins;
        savedCoinList = savedCoins;
        transactions = transactionList;
        wallet = userWallet;
        widget.user.balance = userBalance;
        isLoading = false;
      });
    }
  }
}

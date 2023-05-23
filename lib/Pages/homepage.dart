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

void main() {
  User user = User(
      id: '49dede57-a704-47cd-b1ca-b16672f7aca6',
      fullName: 'Ekrem Polat',
      email: 'ekrempolat416@gmail.com');
  runApp(HomePage(user: user));
}

class HomePage extends StatefulWidget {
  final User user;
  const HomePage({super.key, required this.user});

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
      theme: ThemeData(
        fontFamily: 'Visby Round',
      ),
      debugShowCheckedModeBanner: false,
      home:
          isLoading ? const LoadingScreen() : RootPageState(user: widget.user),
      //TopNavBar(),
    );
  }

  Future<void> fetchCoins() async {
    List<Coin> coins = await fetchCoinsFromDB();
    List<Coin> savedCoins = await fetchSavedCoinsFromDB(widget.user.id);
    List<Transaction> transactionList =
        await getUserTransactionHistory(widget.user.id);
    List<WalletCoin> userWallet = await getUserWallet(widget.user.id);
    double userBalance = await getUserBalance(widget.user.id);
    if (mounted) {
      setState(() {
        coinList = coins;
        savedCoinList = savedCoins;
        transactions = transactionList;
        widget.user.balance = userBalance;

        wallet = userWallet;
        WalletCoin temp = WalletCoin(
            coinName: "US Dollar",
            coinSymbol: "USD",
            amount: widget.user.getCurrency(),
            usdValue: 1,
            dailyChange: 0
        );
        wallet.add(temp);
        wallet.sort((a, b) => (b.amount*b.usdValue).compareTo(a.amount * a.usdValue));

        isLoading = false;
      });
    }
  }
}

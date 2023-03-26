import 'package:flutter/material.dart';
import 'package:stockv/Widgets/rootpage_widget.dart';
import '../Models/coin.dart';
import '../../Models/user.dart';
import '../../Utilities/http_request_functions.dart';
import '../Utilities/saved_coin_list.dart';
import '../Widgets/CoinDetailsPageWidgets/loading_page.dart';



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
      debugShowCheckedModeBanner: false,
      home:
          isLoading ? const LoadingScreen() : RootPageState(user: widget.user),
      //TopNavBar(),
    );
  }

  Future<void> fetchCoins() async {
    List<Coin> coins = await fetchCoinsFromDB();
    List<Coin> savedCoins = await fetchSavedCoinsFromDB(widget.user.id);
    if (mounted) {
      setState(() {
        coinList = coins;
        savedCoinList = savedCoins;
        isLoading = false;
      });
    }
  }
}

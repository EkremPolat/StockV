import 'package:flutter/material.dart';
import 'package:stockv/Widgets/rootpage_widget.dart';

import '../Models/Coin.dart';
import '../Models/User.dart';
import '../Utilities/HttpRequestFunctions.dart';
import '../Utilities/SavedCoinList.dart';
import '../Widgets/CoinDetailsPageWidgets/loading_page.dart';

void main() {
  User user = User(id: 'cc3ec591-e9bc-4450-b969-018957a4ab12', email: 'ekrempolat416@gmail.oom');
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
      debugShowCheckedModeBanner: false,
      home: isLoading ? LoadingScreen() : RootPageState(user: widget.user),
      //TopNavBar(),
    );
  }

  Future<void> fetchCoins() async {
    List<Coin> coins = await fetchCoinsFromDB();
    List<Coin> savedCoins = await fetchSavedCoinsFromDB(widget.user.id);
    if(mounted) {
      setState(() {
        coinList = coins;
        savedCoinList = savedCoins;
        isLoading = false;
      });
    }
  }
}

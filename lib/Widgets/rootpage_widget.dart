import 'package:flutter/material.dart';
import 'package:stockv/Models/coin.dart';
import 'package:stockv/Utilities/Http_request_functions.dart';
import 'package:stockv/Utilities/global_variables.dart';
import 'package:stockv/Widgets/homepage_widget.dart';
import 'package:stockv/Widgets/coinspage_widget.dart';
import 'package:stockv/Widgets/premiumpage_widget.dart';
import 'package:stockv/Widgets/profilepage_widget.dart';
import 'package:stockv/Widgets/transactions_widget.dart';
import 'package:stockv/Widgets/walletpage_widget.dart';
import 'package:stockv/Widgets/CoinDetailsPageWidgets/CoinDetailPagePastValueGraphComponents/single_etf_detail_component.dart';

import '../Models/user.dart';

class RootPageState extends StatefulWidget {
  final User user;
  final int index;

  const RootPageState({
    Key? key,
    required this.user,
    this.index = 0,
  }) : super(key: key);

  
  @override
  State<RootPageState> createState() => _RootPageState();
}

class _RootPageState extends State<RootPageState> {
  // Bottom pages
  int index = 0;

  @override
  void initState() {
    super.initState();
    index = widget.index;  // Use the index passed from the RootPageState

  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePageState(user: widget.user),
      const PremiumPageState(),
      WalletPageState(user: widget.user),
      TransactionListPage(user: widget.user),
    ];

    return Scaffold(
      // Top Bar
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        leadingWidth: 200,
        leading: Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
          child: SizedBox( child: Image.asset('images/black.png')),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomSearch(
                  onCoinSelected: (selectedCoin) {
                    setState(() {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SingleEtfGraphComponent(
                                  user: widget.user, coin: selectedCoin)));
                      //index = 1;
                      //TODO: Custom search will be connected to save coins.
                      //_savedCoins.add(selectedCoin);
                    });
                    //Navigator.pop(context);
                  },
                ),
              );
            },
            /////////////////////////////
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ProfilePageState(user: widget.user)),
                );
              });
            },
            icon: const Icon(Icons.person_pin),
          ),
        ],
      ),

      body: pages[index],
      // Bottom Nav Bar
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Colors.deepPurpleAccent,
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 255, 255, 255)),
          ),
          
        ),
        child: NavigationBar(
          height: 60,
          backgroundColor: Colors.deepPurpleAccent,
          //Color.fromARGB(255, 33, 0, 104),
          selectedIndex: index,
          onDestinationSelected: (index) => setState(() => this.index = index),
          destinations:  [
            NavigationDestination(
                icon: Icon(
                  Icons.home,
                  color: index == 0 ? Colors.white : Colors.white.withOpacity(0.7),
                ),
                label: 'Home'),
            NavigationDestination(
                icon: Icon(
                  Icons.diamond_outlined,
                  color: index == 1 ? Colors.white : Colors.white.withOpacity(0.7),
                ),
                label: 'Premium'),
            NavigationDestination(
                icon: Icon(
                  Icons.wallet,
                  color: index == 2 ? Colors.white : Colors.white.withOpacity(0.7),
                ),
                label: 'Wallet'),
            NavigationDestination(
                icon: Icon(
                  Icons.currency_bitcoin,
                  color: index == 3 ? Colors.white : Colors.white.withOpacity(0.7),
                ),
                label: 'Transaction'),
          ],
        ),
      ),
    );
  }
}

class CustomSearch extends SearchDelegate {
  //List<String> allData = ['BTC', 'ETH', 'ADA', 'SAND', 'AVAX', 'MATIC'];
  List<Coin> allData = coinList;

  final Function(Coin) onCoinSelected;

  CustomSearch({required this.onCoinSelected});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Coin> matchQuery = [];
    for (var item in allData) {
      if (item.getSymbol().toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(item);
      }
    }

    return ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          var result = matchQuery[index];
          return GestureDetector(
            onTap: () {
              onCoinSelected(result);
            },
            child: ListTile(
              title: Text(result.getSymbol()),
            ),
          );
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Coin> matchQuery = [];
    for (var item in allData) {
      if (item.getSymbol().toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(item);
      }
    }
    return ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          var result = matchQuery[index];
          return GestureDetector(
            onTap: () {
              onCoinSelected(result);
            },
            child: ListTile(
              title: Text(result.getSymbol()),
            ),
          );
        });
  }
}

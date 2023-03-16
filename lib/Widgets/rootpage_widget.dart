// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, avoid_print, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:stockv/Widgets/homepage_widget.dart';
import 'package:stockv/Widgets/coinspage_widget.dart';
import 'package:stockv/Widgets/premiumpage_widget.dart';
import 'package:stockv/Widgets/profilepage_widget.dart';

import '../Models/User.dart';

List<String> _savedCoins = ['BTC', 'ETH'];

class RootPageState extends StatefulWidget {
  User user;

  RootPageState({super.key, required this.user});
  @override
  State<RootPageState> createState() => _RootPageState();
}

class _RootPageState extends State<RootPageState> {
  void _saveCoin(String etfCode) {
    setState(() {
      _savedCoins.add(etfCode);
    });
  }

  // Bottom pages
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePageState(saveCoin: _saveCoin),
      CoinsPageState(savedEtfCodes: _savedCoins),
      PremiumPageState(),
    ];

    return Scaffold(
      // Top Bar
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(46, 21, 157, 0.6),
        leadingWidth: 200,
        leading: Container(
          height: 5.0,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/black.png'),
            ),
            shape: BoxShape.rectangle,
          ),
        ),
        actions: [
          IconButton(
            /////////////////////////////
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomSearch(
                  onCoinSelected: (selectedCoin) {
                    setState(() {
                      index = 1;
                      _savedCoins.add(selectedCoin);
                    });
                    Navigator.pop(context);
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
          indicatorColor: Color.fromRGBO(46, 21, 157, 0.6),
          labelTextStyle: MaterialStateProperty.all(
            TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 255, 255, 255)),
          ),
        ),
        child: NavigationBar(
          height: 60,
          backgroundColor: Color.fromRGBO(46, 21, 157, 0.6),
          //Color.fromARGB(255, 33, 0, 104),
          selectedIndex: index,
          onDestinationSelected: (index) => setState(() => this.index = index),
          destinations: [
            NavigationDestination(
                icon: Icon(
                  Icons.home,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                label: 'Home'),
            NavigationDestination(
                icon: Icon(
                  Icons.currency_bitcoin,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                label: 'Coins'),
            NavigationDestination(
                icon: Icon(
                  Icons.diamond_outlined,
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                label: 'Premium'),
          ],
        ),
      ),
    );
  }
}

class CustomSearch extends SearchDelegate {
  List<String> allData = ['BTC', 'ETH', 'ADA', 'SAND', 'AVAX', 'MATIC'];

  final Function(String) onCoinSelected;

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
    throw UnimplementedError();
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
    List<String> matchQuery = [];
    for (var item in allData) {
      if (item.toLowerCase().contains(query.toLowerCase())) {
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
              title: Text(result),
            ),
          );
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    for (var item in allData) {
      if (item.toLowerCase().contains(query.toLowerCase())) {
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
              title: Text(result),
            ),
          );
        });
  }
}

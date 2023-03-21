import 'package:flutter/material.dart';
import 'package:stockv/Widgets/homepage_widget.dart';
import 'package:stockv/Widgets/coinspage_widget.dart';
import 'package:stockv/Widgets/premiumpage_widget.dart';
import 'package:stockv/Widgets/profilepage_widget.dart';
import 'package:stockv/Widgets/searchpage_widget.dart';

import '../Models/user.dart';

List<String> _savedCoins = ['BTC', 'ETH'];

class RootPageState extends StatefulWidget {
  final User user;

  const RootPageState({super.key, required this.user});
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
      const PremiumPageState(),
    ];

    return Scaffold(
      // Top Bar
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(46, 21, 157, 0.6),
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
            onPressed: () {
              setState(() {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SearchPageState()),
                );
              });
            },
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
          indicatorColor: const Color.fromRGBO(46, 21, 157, 0.6),
          labelTextStyle: MaterialStateProperty.all(
            const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 255, 255, 255)),
          ),
        ),
        child: NavigationBar(
          height: 60,
          backgroundColor: const Color.fromRGBO(46, 21, 157, 0.6),
          //Color.fromARGB(255, 33, 0, 104),
          selectedIndex: index,
          onDestinationSelected: (index) => setState(() => this.index = index),
          destinations: const [
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

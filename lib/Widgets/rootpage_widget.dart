// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, avoid_print, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:stockv/Widgets/homepage_widget.dart';
import 'package:stockv/Widgets/coinspage_widget.dart';
import 'package:stockv/Widgets/premiumpage_widget.dart';
import 'package:stockv/Widgets/profilepage_widget.dart';
import 'package:stockv/Widgets/searchpage_widget.dart';

import '../Models/User.dart';

class RootPageState extends StatefulWidget {
  User user;

  RootPageState({super.key, required this.user});
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPageState> {
  // Bottom pages
  int index = 0;
  final pages = [
    HomePageState(),
    CoinsPageState(),
    PremiumPageState(),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
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
              onPressed: () {
                setState(() {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchPageState()),
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
                    MaterialPageRoute(builder: (context) => ProfilePageState(user: widget.user)),
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
            onDestinationSelected: (index) =>
                setState(() => this.index = index),
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

// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, avoid_print, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:stockv/Widgets/homepage_widget.dart';
import 'package:stockv/Widgets/coinspage_widget.dart';
import 'package:stockv/Widgets/preminumpage_widget.dart';
import 'package:stockv/Widgets/profilepage_widget.dart';
import 'package:stockv/Widgets/searchpage_widget.dart';

class RootPageState extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPageState> {
  // Bottom pages
  int index = 0;
  final pages = [
    HomePageState(),
    CoinsPageState(),
    PreminumPageState(),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        // Top Bar
        appBar: AppBar(
          backgroundColor: Color(0xFF3213A4),
          leading: Icon(
            Icons.check,
            color: Color(0xFFFF7500),
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
                    MaterialPageRoute(builder: (context) => ProfilePageState()),
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
            indicatorColor: Color(0xFFFF7500),
            labelTextStyle: MaterialStateProperty.all(
              TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(255, 255, 255, 255)),
            ),
          ),
          child: NavigationBar(
            height: 60,
            backgroundColor:
                Color(0xFF3213A4), //Color.fromARGB(255, 33, 0, 104),
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
                  label: 'Preminum'),
            ],
          ),
        ),
      );
}
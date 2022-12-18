import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int index = 0;
  final pages = [
    Center(
      child: Text(
        'Home',
        style: TextStyle(fontSize: 72),
      ),
    ),
    Center(
      child: Text(
        'Coins',
        style: TextStyle(fontSize: 72),
      ),
    ),
    Center(
      child: Text(
        'Preminum',
        style: TextStyle(fontSize: 72),
      ),
    )
  ];
  @override
  Widget build(BuildContext context) => Scaffold(
        body: pages[index],
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
            indicatorColor: Colors.orange.shade800,
            labelTextStyle: MaterialStateProperty.all(
              TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(255, 255, 255, 255)),
            ),
          ),
          child: NavigationBar(
            height: 60,
            backgroundColor: Color.fromARGB(255, 33, 0, 104),
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

import 'package:flutter/material.dart';
import 'package:stockv/BinanceEtfComponent/MultipleEtfContainer/saved_coins_container.dart';
import 'package:stockv/Widgets/horizontal_drawer.dart';
import '../BinanceEtfComponent/MultipleEtfContainer/all_coins_container.dart';
import '../Models/user.dart';

class HomePageState extends StatefulWidget {
  final User user;
  const HomePageState({super.key, required this.user});

  @override
  State<HomePageState> createState() => _HomePageState();
}

class _HomePageState extends State<HomePageState> {
  int drawerIndex = 0;

  void _handleCallback(int value) {
    setState(() {
      drawerIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            children: [
              HorizontalDrawerMenuState(callback: _handleCallback),
              if (drawerIndex == 0)
                Expanded(child: SavedCoinsContainerState(user: widget.user)),
              if (drawerIndex == 1)
                Expanded(child: AllCoinsContainerState(user: widget.user)),
            ],
          ),
        ),
      ),
    );
  }
}

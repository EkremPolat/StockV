// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, avoid_print, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:stockv/BinanceEtfComponent/MultipleEtfContainer/savedCoinsContainer.dart';

import '../BinanceEtfComponent/MultipleEtfContainer/allCoinsContainer.dart';
import '../Models/User.dart';
import 'horizontal_drawer.dart';

class HomePageState extends StatefulWidget {
  User user;

  HomePageState({super.key, required this.user});
  
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
              HorizontalDrawerMenu(callback: _handleCallback),
              if(drawerIndex == 0)
                Expanded(child: AllCoinsContainerState(user: widget.user)),
              if(drawerIndex == 1)
                Expanded(child: SavedCoinsContainerState(user: widget.user)),

            ],
          ),
        ),
      ),
    );
  }
}

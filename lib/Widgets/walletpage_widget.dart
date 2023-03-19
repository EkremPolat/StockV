// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, avoid_print, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';

class WalletPageState extends StatefulWidget {
  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPageState> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Text(
            'Wallet',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
      );
}

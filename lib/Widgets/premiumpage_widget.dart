// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, avoid_print, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';

class PremiumPageState extends StatefulWidget {
  @override
  _PremiumPageState createState() => _PremiumPageState();
}

class _PremiumPageState extends State<PremiumPageState> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: AspectRatio(
          aspectRatio: 6 / 7,
          child: Image.asset(
            'images/premium.png',
          ),
        ),
        backgroundColor: Color(0xFFFFFFFF),
      );
}

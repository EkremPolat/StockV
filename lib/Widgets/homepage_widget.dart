// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, avoid_print, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';

import '../BinanceEtfComponent/MultipleEtfContainer/multipleEtfContainer.dart';

class HomePageState extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePageState> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: Column(
              children: [
                Text(
                  'COINS',
                  style: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Brandon Grotesque",
                    color: Colors.black,
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    const SizedBox(width: 22),
                    SizedBox(
                      width: 50,
                      child: Text(
                        'Icon',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Brandon Grotesque",
                          color: Colors.black,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 92,
                      child: Text(
                        'Symbol',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Brandon Grotesque",
                          color: Colors.black,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 128,
                      child: Text(
                        'Price (\$)',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Brandon Grotesque",
                          color: Colors.black,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 70,
                      child: Text(
                        '24H (%)',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Brandon Grotesque",
                          color: Colors.black,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Expanded(
                    child: MultipleEtfContainerState()
                ),
              ],
            ),
          ),
        ),
      );
}

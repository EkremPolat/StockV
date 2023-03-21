import 'package:flutter/material.dart';

import '../BinanceEtfComponent/MultipleEtfContainer/multipleEtfContainer.dart';

class HomePageState extends StatefulWidget {
  final Function(String) saveCoin;

  const HomePageState({Key? key, required this.saveCoin}) : super(key: key);

  @override
  State<HomePageState> createState() => _HomePageState();
}

class _HomePageState extends State<HomePageState> {
  void _saveCoin(String etfCode) {
    widget.saveCoin(etfCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            children: [
              const Text(
                'COINS',
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Brandon Grotesque",
                  color: Colors.black,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: const [
                  SizedBox(width: 22),
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
              const SizedBox(
                height: 10,
              ),
              Expanded(child: MultipleEtfContainerState(saveCoin: _saveCoin)),
            ],
          ),
        ),
      ),
    );
  }
}

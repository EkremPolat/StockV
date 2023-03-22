// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, avoid_print, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:stockv/Models/user.dart';
import 'package:stockv/Widgets/CoinDetailsPageWidgets/coin_detal_page_multiple_etf_container.dart';

class CoinsPageState extends StatefulWidget {
  final List<String> savedEtfCodes;
  final User user;

  const CoinsPageState(
      {Key? key, required this.savedEtfCodes, required this.user})
      : super(key: key);

  @override
  State<CoinsPageState> createState() => _CoinsPageState();
}

class _CoinsPageState extends State<CoinsPageState> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: CoinDetailPageMultipleEtfContainerState(
                savedEtfCodes: widget.savedEtfCodes, user: widget.user)));
  }
}

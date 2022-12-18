// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, avoid_print, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';

class SearchPageState extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPageState> {
  @override
  Widget build(BuildContext context) => Scaffold(
      body: Center(child: Text('Search', style: TextStyle(fontSize: 60))));
}

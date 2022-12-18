// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, avoid_print, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:stockv/Widgets/rootpage_widget.dart';

class ProfilePageState extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePageState> {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        actions: [],
        backgroundColor: Color(0xFF3213A4),
      ),
      body: Center(child: Text('Profile', style: TextStyle(fontSize: 60))));
}

import 'package:stockv/Pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:stockv/Widgets/bottomnavbar.dart';

void main() {
  runApp(BottomNavBarApp());
}

class BottomNavBarApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BottomNavBar(),
    );
  }
}

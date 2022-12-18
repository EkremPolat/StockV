import 'package:stockv/Pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:stockv/Widgets/bottomnavbar.dart';
import 'package:stockv/Widgets/topbar.dart';

void main() {
  runApp(HomePage());
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BottomNavBar(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:stockv/Widgets/rootpage_widget.dart';

void main() {
  runApp(HomePage());
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RootPageState(),
      //TopNavBar(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:stockv/Widgets/rootpage_widget.dart';

import '../Models/user.dart';

void main() {
  User user = User("test@gmail.com", "Test");
  runApp(HomePage(user: user));
}

class HomePage extends StatefulWidget {
  final User user;
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RootPageState(user: widget.user),
      //TopNavBar(),
    );
  }
}

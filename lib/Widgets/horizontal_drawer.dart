import 'package:flutter/material.dart';

class HorizontalDrawerMenuState extends StatefulWidget {
  final List<String> menuItems = ['Saved Coins', 'Home'];
  final Function(int) callback;

  HorizontalDrawerMenuState({super.key, required this.callback});

  @override
  State<HorizontalDrawerMenuState> createState() =>
      _HorizontalDrawerMenuState();
}

class _HorizontalDrawerMenuState extends State<HorizontalDrawerMenuState> {
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.menuItems.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              setState(() {
                pageIndex = index;
                widget.callback(pageIndex);
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              alignment: Alignment.center,
              child: Text(
                widget.menuItems[index],
                style: TextStyle(
                  color: pageIndex == index ? Colors.orange : Colors.black,
                  fontSize: 18,
                  decoration: TextDecoration.underline,
                  decorationStyle: TextDecorationStyle.solid,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

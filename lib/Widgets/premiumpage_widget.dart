// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, avoid_print, prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';

class PremiumPageState extends StatefulWidget {
  const PremiumPageState({super.key});

  @override
  State<PremiumPageState> createState() => _PremiumPageState();
}

class _PremiumPageState extends State<PremiumPageState> {
  @override
  Widget build(BuildContext context) => Scaffold(
          body: Center(
              child: SingleChildScrollView(
                  child: Column(
        children: <Widget>[
          Container(
            height: 120.0,
            width: 300.0,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/black.png'),
                fit: BoxFit.cover,
              ),
              shape: BoxShape.rectangle,
            ),
          ),
          Container(
              height: 300,
              margin: EdgeInsets.only(top: 50),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        "Free",
                        style: TextStyle(fontSize: 30),
                      ),
                      Container(
                          margin: EdgeInsets.only(bottom: 30),
                          child: Text(
                            "\$0.00/Month",
                            style: TextStyle(fontSize: 10),
                          )),
                      SizedBox(
                          width: 150,
                          child: Row(
                            children: const [
                              Icon(
                                Icons.done,
                                color: Color.fromARGB(255, 236, 198, 7),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  '\$1.000 limit on wallet',
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),

                                  softWrap: false,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis, // new
                                ),
                              ),
                            ],
                          )),
                      SizedBox(
                          width: 150,
                          child: Row(
                            children: const [
                              Icon(
                                Icons.done,
                                color: Color.fromARGB(255, 236, 198, 7),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  '\$0 extra monthly',
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),

                                  softWrap: false,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis, // new
                                ),
                              ),
                            ],
                          )),
                      SizedBox(
                          width: 150,
                          child: Row(
                            children: const [
                              Icon(
                                Icons.done,
                                color: Color.fromARGB(255, 236, 198, 7),
                              ),
                              SizedBox(width: 10), // give it width
                              Expanded(
                                child: Text(
                                  'Fundamental Algorithms (S)*',
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),

                                  softWrap: false,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis, // new
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Text(
                        "Premium",
                        style: TextStyle(fontSize: 30),
                      ),
                      Container(
                          margin: EdgeInsets.only(bottom: 30),
                          child: Text(
                            "\$9.99/Month",
                            style: TextStyle(fontSize: 10),
                          )),
                      SizedBox(
                          width: 150,
                          child: Row(
                            children: const [
                              Icon(
                                Icons.done,
                                color: Color.fromARGB(255, 236, 198, 7),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  '\$10.000 limit on wallet',
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),

                                  softWrap: false,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis, // new
                                ),
                              ),
                            ],
                          )),
                      SizedBox(
                          width: 150,
                          child: Row(
                            children: const [
                              Icon(
                                Icons.done,
                                color: Color.fromARGB(255, 236, 198, 7),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  '\$1.000 extra monthly',
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),

                                  softWrap: false,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis, // new
                                ),
                              ),
                            ],
                          )),
                      SizedBox(
                          width: 150,
                          child: Row(
                            children: const [
                              Icon(
                                Icons.done,
                                color: Color.fromARGB(255, 236, 198, 7),
                              ),
                              SizedBox(width: 10), // give it width
                              Expanded(
                                child: Text(
                                  'Fundamental Algorithms (S)*',
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),

                                  softWrap: false,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis, // new
                                ),
                              ),
                            ],
                          )),
                      Container(
                          width: 150,
                          margin: EdgeInsets.all(10),
                          child: Row(
                            children: const [
                              Icon(
                                Icons.done,
                                color: Color.fromARGB(255, 245, 189, 2),
                              ),
                              SizedBox(width: 10), // give it width
                              Expanded(
                                child: Text(
                                  'Additional Algorithms (S)**',
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),

                                  softWrap: false,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis, // new
                                ),
                              ),
                            ],
                          )),
                    ],
                  )
                ],
              )),
          Wrap(
            children: <Widget>[
              Container(
                width: 150,
                margin: EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff2E159D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    "Get Free",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Container(
                width: 150,
                margin: EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff2E159D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    "Get Premium",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ))));
}

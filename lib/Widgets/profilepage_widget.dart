// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, avoid_print, prefer_const_literals_to_create_immutables
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:stockv/Widgets/rootpage_widget.dart';
import 'package:stockv/Pages/homepage.dart';
import 'package:stockv/pages/login.dart';

class ProfilePageState extends StatefulWidget {
  int index = 2;
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePageState> {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePageState()),
                );
              });
            },
            icon: const Icon(Icons.person_pin),
          ),
        ],
        backgroundColor: Color(0xFF3213A4),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.all(30.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.black,
                    width: 3,
                  ),
                ),
                height: 200,
                width: 400,
                child: Column(
                  children: <Widget>[
                    Container(
                        height: 50,
                        margin: EdgeInsets.only(top: 30),
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                                color: Color.fromARGB(255, 14, 14, 14)),
                            children: [
                              WidgetSpan(
                                child: Icon(Icons.monetization_on_rounded),
                              ),
                            ],
                            text: "Current Amount",
                          ),
                        )),
                    Divider(
                      color: Colors.black38,
                      thickness: 3,
                      indent: 10,
                      endIndent: 10,
                    ),
                    Container(
                      height: 50,
                      width: 150,
                      child: ElevatedButton(
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
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage(
                                    )),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(30.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.black,
                    width: 3,
                  ),
                ),
                height: 450,
                width: 400,
                child: Column(
                  children: <Widget>[
                    Container(
                      child: TextField(
                        //    ...,other fields
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.email_sharp,
                            color: Color.fromARGB(255, 14, 14, 14),
                          ),
                          border: InputBorder.none,
                          labelText: "Email",
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.black38,
                      thickness: 3,
                      indent: 10,
                      endIndent: 10,
                    ),
                    Container(
                      child: TextField(
                        //    ...,other fields
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.person,
                            color: Color.fromARGB(255, 14, 14, 14),
                          ),
                          border: InputBorder.none,
                          iconColor: Color.fromARGB(255, 14, 14, 14),
                          labelText: "Full Name",
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.black38,
                      thickness: 3,
                      indent: 10,
                      endIndent: 10,
                    ),
                    Container(
                      child: TextField(
                        //    ...,other fields
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Color.fromARGB(255, 14, 14, 14),
                          ),
                          border: InputBorder.none,
                          iconColor: Color.fromARGB(255, 14, 14, 14),
                          labelText: "Old Password",
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.black38,
                      thickness: 3,
                      indent: 10,
                      endIndent: 10,
                    ),
                    Container(
                      child: TextField(
                        //    ...,other fields
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Color.fromARGB(255, 14, 14, 14),
                          ),
                          border: InputBorder.none,
                          iconColor: Color.fromARGB(255, 14, 14, 14),
                          labelText: "New Password",
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.black38,
                      thickness: 3,
                      indent: 10,
                      endIndent: 10,
                    ),
                    Container(
                      child: TextField(
                        //    ...,other fields
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Color.fromARGB(255, 14, 14, 14),
                          ),
                          border: InputBorder.none,
                          iconColor: Color.fromARGB(255, 14, 14, 14),
                          labelText: "New Password",
                        ),
                      ),
                    ),
                    Divider(
                      color: Colors.black38,
                      thickness: 3,
                      indent: 10,
                      endIndent: 10,
                    ),
                    Container(
                      height: 50,
                      width: 150,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff2E159D),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Text(
                          "Save",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
               Container(
                      height: 50,
                      width: 150,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 211, 9, 9),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Text(
                          "Log Out",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                             Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LoginScreen()),
                            );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ));
}
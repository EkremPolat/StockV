import 'package:flutter/material.dart';
import 'package:stockv/Pages/homepage.dart';

import 'package:stockv/pages/login.dart';
import '../Models/user.dart';
import '../Utilities/http_request_functions.dart';

class ProfilePageState extends StatefulWidget {
  final User user;

  const ProfilePageState({super.key, required this.user});

  @override
  State<ProfilePageState> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePageState> {
  User? user;

  TextEditingController? _emailController;
  TextEditingController? _namecontroller;
  final TextEditingController _oldpasswordController = TextEditingController();
  final TextEditingController _newpasswordController = TextEditingController();
  final TextEditingController _newpassword2Controller = TextEditingController();

  SnackBar failSnackBar(String text) {
    return SnackBar(
      backgroundColor: Colors.red,
      dismissDirection: DismissDirection.vertical,
      content: Text(text),
    );
  }

  final successSnackBar = const SnackBar(
    backgroundColor: Colors.green,
    dismissDirection: DismissDirection.vertical,
    content: Text('Successfully updated!'),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = widget.user;
    _emailController = TextEditingController(text: user?.getEmail());
    _namecontroller = TextEditingController(text: user?.getFullName());
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ProfilePageState(user: widget.user)),
                );
              });
            },
            icon: const Icon(Icons.person_pin),
          ),
        ],
        backgroundColor: const Color.fromRGBO(46, 21, 157, 0.6),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.fromLTRB(30, 0, 30, 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.black,
                    width: 3,
                  ),
                ),
                height: 175,
                width: 400,
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 30,
                      margin: const EdgeInsets.only(top: 30),
                      child: const Text(
                        "Current Amount",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      child: Text(
                        "\$${user?.getCurrency()}",
                        style:
                            const TextStyle(fontSize: 20, color: Colors.green),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      width: 150,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff2E159D),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          "Get Premium",
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return HomePage(user: widget.user);
                          }));
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(30, 0, 30, 10),
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
                    TextFormField(
                      validator: (val) =>
                          val!.isEmpty ? "E-mail is empty!" : null,
                      controller: _emailController,
                      enabled: false,
                      keyboardType: TextInputType.emailAddress,
                      //    ...,other fields
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.email_sharp,
                          color: Color.fromARGB(255, 14, 14, 14),
                        ),
                        border: InputBorder.none,
                        labelText: "Email",
                      ),
                    ),
                    const Divider(
                      color: Colors.black38,
                      thickness: 3,
                      indent: 10,
                      endIndent: 10,
                    ),
                    TextFormField(
                      validator: (val) =>
                          val!.isEmpty ? "Name is empty!" : null,
                      controller: _namecontroller,
                      //    ...,other fields
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.person,
                          color: Color.fromARGB(255, 14, 14, 14),
                        ),
                        border: InputBorder.none,
                        iconColor: Color.fromARGB(255, 14, 14, 14),
                        labelText: "Full Name",
                      ),
                    ),
                    const Divider(
                      color: Colors.black38,
                      thickness: 3,
                      indent: 10,
                      endIndent: 10,
                    ),
                    TextFormField(
                      validator: (val) =>
                          val!.isEmpty ? "Old password is empty!" : null,
                      controller: _oldpasswordController,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.name,
                      //    ...,other fields
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Color.fromARGB(255, 14, 14, 14),
                        ),
                        border: InputBorder.none,
                        iconColor: Color.fromARGB(255, 14, 14, 14),
                        labelText: "Old Password",
                      ),
                    ),
                    const Divider(
                      color: Colors.black38,
                      thickness: 3,
                      indent: 10,
                      endIndent: 10,
                    ),
                    TextFormField(
                      validator: (val) =>
                          val!.isEmpty ? "New password is empty!" : null,
                      controller: _newpasswordController,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.name,
                      //    ...,other fields
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Color.fromARGB(255, 14, 14, 14),
                        ),
                        border: InputBorder.none,
                        iconColor: Color.fromARGB(255, 14, 14, 14),
                        labelText: "New Password",
                      ),
                    ),
                    const Divider(
                      color: Colors.black38,
                      thickness: 3,
                      indent: 10,
                      endIndent: 10,
                    ),
                    TextFormField(
                      validator: (val) =>
                          val!.isEmpty ? "New password is empty!" : null,
                      controller: _newpassword2Controller,
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.name,
                      //    ...,other fields
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Color.fromARGB(255, 14, 14, 14),
                        ),
                        border: InputBorder.none,
                        iconColor: Color.fromARGB(255, 14, 14, 14),
                        labelText: "New Password",
                      ),
                    ),
                    const Divider(
                      color: Colors.black38,
                      thickness: 3,
                      indent: 10,
                      endIndent: 10,
                    ),
                    SizedBox(
                      height: 50,
                      width: 150,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff2E159D),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          "Save",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                          ),
                        ),
                        onPressed: () async {
                          if (_oldpasswordController.text.isNotEmpty) {
                            if (_newpasswordController.text ==
                                _newpassword2Controller.text) {
                              var response = await passwordChange(
                                  _namecontroller?.text,
                                  _emailController?.text,
                                  _oldpasswordController.text,
                                  _newpasswordController.text);
                              if (response != null) {
                                setState(() {
                                  user?.setFullName(response);
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(successSnackBar);
                                });
                              } else {
                                setState(() {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      failSnackBar("Something went wrong!"));
                                });
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  failSnackBar("Passwords do not match"));
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                failSnackBar("Old password cannot be empty!"));
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
                width: 150,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 211, 9, 9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    "Log Out",
                    style: TextStyle(color: Colors.white, fontSize: 17),
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

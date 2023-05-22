import 'package:flutter/material.dart';
import 'package:stockv/Pages/homepage.dart';
import 'package:stockv/Widgets/rootpage_widget.dart';
import 'package:stockv/Widgets/transactions_widget.dart';

import 'package:stockv/pages/login.dart';
import '../Models/user.dart';
import '../Utilities/http_request_functions.dart';

class ProfilePageState extends StatefulWidget {
  final User user;
  final int index;
  const ProfilePageState({super.key, required this.user, this.index = 2});

  @override
  State<ProfilePageState> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePageState> {
  TextEditingController? _emailController;
  TextEditingController? _nameController;
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _newPassword2Controller = TextEditingController();

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
    _emailController = TextEditingController(text: widget.user.getEmail());
    _nameController = TextEditingController(text: widget.user.getFullName());
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  bool isEditing = false;
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) => Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        leadingWidth: 400,
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                Image.asset('images/black.png'),
              ],
            ),
            IconButton(
              onPressed: () {
                // Open the drawer.
                _scaffoldKey.currentState?.openEndDrawer();
              },
              icon: const Icon(Icons.menu),
            ),
          ],
        ),
      ),
      endDrawer: Drawer(
        child: Column(
          children: [
            Container(
              height: 130,
              decoration: const BoxDecoration(
                color: Colors.deepPurpleAccent,
                image: DecorationImage(
                  image: AssetImage('images/black.png'),
                ),
              ),
              child: null,
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Transactions'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TransactionListPage(
                              user: widget.user,
                            )));
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                // Do something when the user taps on the Settings button.
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.fromLTRB(30, 30, 30, 30),
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
                        "Current Balance",
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
                        "\$${widget.user.getCurrency().toStringAsFixed(2)}",
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
                            return RootPageState(user: widget.user, index: 2);
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
                      controller: _nameController,
                      enabled: isEditing,
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
                    Visibility(
                        visible: _isVisible,
                        child: Column(children: <Widget>[
                          const Divider(
                            color: Colors.black38,
                            thickness: 3,
                            indent: 10,
                            endIndent: 10,
                          ),
                          TextFormField(
                            validator: (val) =>
                                val!.isEmpty ? "Old password is empty!" : null,
                            controller: _oldPasswordController,
                            obscureText: true,
                            enabled: isEditing,
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
                            controller: _newPasswordController,
                            obscureText: true,
                            enabled: isEditing,
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
                            controller: _newPassword2Controller,
                            obscureText: true,
                            enabled: isEditing,
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
                        ])),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: SizedBox(
                        height: 50,
                        width: 200,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff2E159D),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Text(
                            isEditing ? "Save" : "Change Password",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                            ),
                          ),
                          onPressed: () async {
                            if (isEditing) {
                              if (_oldPasswordController.text.isNotEmpty) {
                                if (_newPasswordController.text ==
                                    _newPassword2Controller.text) {
                                  var response = await passwordChange(
                                      _nameController?.text,
                                      _emailController?.text,
                                      _oldPasswordController.text,
                                      _newPasswordController.text);
                                  if (response != null) {
                                    setState(() {
                                      widget.user.setFullName(response);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(successSnackBar);
                                      _isVisible = false;
                                    });
                                  } else {
                                    setState(() {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(failSnackBar(
                                              "Something went wrong!"));
                                    });
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      failSnackBar("Passwords do not match"));
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    failSnackBar(
                                        "Old password cannot be empty!"));
                              }
                            } else {
                              setState(() {
                                _isVisible = true;
                                isEditing = true;
                              });
                            }
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(8.0), // Adjust the value as needed
                child: SizedBox(
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
              ),
            ],
          ),
        ),
      ));
}

import 'package:flutter/material.dart';

import '../Utilities/http_request_functions.dart';
import 'login.dart';

void main() {
  runApp(const SignUpScreen());
}

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: SignUpScreenHomeState());
  }
}

class SignUpScreenHomeState extends StatefulWidget {
  const SignUpScreenHomeState({super.key});

  @override
  State<SignUpScreenHomeState> createState() => _SignUpScreenHomeState();
}

class _SignUpScreenHomeState extends State<SignUpScreenHomeState> {
  dynamic warningMessage;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    //profileReference = usersReferences!.doc(uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('images/background.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Container(
            margin: const EdgeInsets.only(left: 20, right: 10),
            child: Center(
              child: Form(
                key: _formKey,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  runSpacing: 10,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                      child: SizedBox( height: 130, child: Image.asset('images/black.png'),),
                    ),
                    Column(
                      // replaced with column
                      children: [
                        const Text(
                          'SIGN UP',
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          validator: (val) {
                            if(val!.isEmpty) {
                              return "E-mail is empty!";
                            }
                            if(!val.contains("@")) {
                              return "Invalid email!";
                            }
                            return null;
                          },

                          controller: _emailController,
                          autofocus: true,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: "E-mail",
                            labelStyle: const TextStyle(color: Colors.black),
                            prefixIcon: const Icon(
                              Icons.account_circle_outlined,
                              color: Colors.black,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(color: Colors.black,
                                  width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                  width: 2
                              ),
                            ),
                          ),
                          style: const TextStyle(
                              fontSize: 18, color: Colors.black),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          validator: (val) =>
                              val!.isEmpty ? "Full Name is empty!" : null,
                          controller: _fullNameController,
                          autofocus: true,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            labelText: "Full Name",
                            labelStyle: const TextStyle(color: Colors.black),
                            prefixIcon: const Icon(
                              Icons.account_circle_outlined,
                              color: Colors.black,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(color: Colors.black, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                color: Colors.red,
                                  width: 2
                              ),
                            ),
                          ),
                          style: const TextStyle(
                              fontSize: 18, color: Colors.black),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          keyboardType: TextInputType.name,
                          validator: (val) =>
                              val!.isEmpty ? "Password is empty!" : null,
                          decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle: const TextStyle(color: Colors.black),
                            prefixIcon: const Icon(
                              Icons.vpn_key_outlined,
                              color: Colors.black,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                color: Colors.black,
                                  width: 2
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                    width: 2
                                )),
                          ),
                          style: const TextStyle(
                              fontSize: 18, color: Colors.black),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: true,
                          keyboardType: TextInputType.name,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Password is empty!";
                            }
                            if (val != _passwordController.text) {
                              return "Passwords do not match!";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: "Confirm Password",
                            labelStyle: const TextStyle(color: Colors.black),
                            prefixIcon: const Icon(
                              Icons.vpn_key_outlined,
                              color: Colors.black,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                color: Colors.black,
                                  width: 2
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 2
                                )),
                          ),
                          style: const TextStyle(
                              fontSize: 18, color: Colors.black),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurpleAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                showMyDialog(context);
                                var response = await register(
                                    _fullNameController.text,
                                    _emailController.text,
                                    _passwordController.text);
                                if (response) {
                                  setState(() {
                                    Navigator.pop(dialogContext);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginScreen()));
                                  });
                                } else {
                                  setState(() {
                                    Navigator.pop(dialogContext);
                                    warningMessage =
                                        "Email already exists!";
                                  });
                                }
                              }
                            },
                            child: const Text(
                              'SIGN UP',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "already a member?",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurpleAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginScreen()));
                            });
                          },
                          child: const Text(
                            "LOG IN",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        if (warningMessage != null)
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.red,
                                border: Border.all(color: Colors.black)),
                            child: ListTile(
                              title: Text(
                                warningMessage,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              leading: const Icon(Icons.error),
                              trailing: IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    setState(() {
                                      warningMessage = null;
                                    });
                                  }),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  late BuildContext dialogContext;

  showMyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        dialogContext = context;
        return SimpleDialog(
          children: <Widget>[
            const Text('Loading', textAlign: TextAlign.center),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 60,
              margin: const EdgeInsets.symmetric(horizontal: 110),
              child: const CircularProgressIndicator(),
            ),
          ],
        );
      },
    );
  }

/*Future<bool> userExists(String uid) async {
    return (await usersReferences!.where('uid', isEqualTo: uid).get())
        .docs
        .isEmpty;
  }*/
}

import 'package:flutter/material.dart';

void main() {
  runApp(LoginScreen());
}

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: LoginScreenHome());
  }
}

class LoginScreenHome extends StatefulWidget {
  const LoginScreenHome({super.key});

  @override
  _LoginScreenHomeState createState() => _LoginScreenHomeState();
}

class _LoginScreenHomeState extends State<LoginScreenHome> {
  dynamic warningMessage;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    //profileReference = usersReferences!.doc(uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
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
                  Column(
                    // replaced with column
                    children: [
                      const Text(
                        'Log In',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (val) =>
                            val!.isEmpty ? "E-mail is empty!" : null,
                        controller: _emailController,
                        autofocus: true,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: "E-mail",
                          labelStyle: const TextStyle(color: Colors.white),
                          prefixIcon: const Icon(
                            Icons.account_circle_outlined,
                            color: Colors.white,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                color: Colors.red,
                              )),
                        ),
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
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
                          labelStyle: const TextStyle(color: Colors.white),
                          prefixIcon: const Icon(
                            Icons.vpn_key_outlined,
                            color: Colors.white,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                color: Colors.red,
                              )),
                        ),
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onPressed: () async {
                            /*if (_formKey.currentState!.validate()) {
                                    showMyDialog(context);
                                    dynamic result = await loginProvider.signIn(
                                        _emailController.text.trim(),
                                        _passwordController.text.trim());

                                    if (result != null) {}
                                    else {
                                      setState(() {
                                        Navigator.pop(dialogContext);
                                        warningMessage =
                                            loginProvider.getErrorMessage();
                                      });
                                    }
                                  }*/
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            onPressed: () {
                              /*setState(() {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ForgotPasswordScreen()));
                                    });*/
                            },
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            onPressed: () {
                              /*setState(() {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SignUpScreen()));
                                    });*/
                            },
                            child: const Text(
                              "Don't have an account?",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
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

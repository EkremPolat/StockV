import 'package:flutter/material.dart';

void main() {
  runApp(const ForgotPasswordScreen());
}

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: ForgetPasswordScreenHome());
  }
}

class ForgetPasswordScreenHome extends StatefulWidget {
  const ForgetPasswordScreenHome({super.key});

  @override
  State<ForgetPasswordScreenHome> createState() =>
      _ForgetPasswordScreenHomeState();
}

class _ForgetPasswordScreenHomeState extends State<ForgetPasswordScreenHome> {
  dynamic warningMessage;
  final TextEditingController _emailController = TextEditingController();
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
                    Container(
                      height: 91.0,
                      width: 300.0,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('images/black.png'),
                          fit: BoxFit.cover,
                        ),
                        shape: BoxShape.rectangle,
                      ),
                    ),
                    Column(
                      // replaced with column
                      children: [
                        const Text(
                          'FORGOT PASSWORD',
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
                          validator: (val) =>
                              val!.isEmpty ? "E-mail is empty!" : null,
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
                              borderSide: const BorderSide(color: Colors.black),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: const BorderSide(
                                color: Colors.red,
                              ),
                            ),
                          ),
                          style: const TextStyle(
                              fontSize: 18, color: Colors.black),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff2E159D),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                warningMessage = "Mail sent successfully!";
                                /*Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ForgetPasswordScreen()));*/
                              });
                            },
                            child: const Text(
                              'SEND MAIL',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )),
                        const SizedBox(
                          height: 10,
                        ),
                        if (warningMessage != null)
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.green,
                                border: Border.all(color: Colors.black)),
                            child: ListTile(
                              title: Text(
                                warningMessage,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              leading: const Icon(Icons.thumb_up),
                              trailing: IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    setState(() {
                                      warningMessage = null;
                                    });
                                  }),
                            ),
                          ),
                        const SizedBox(
                          height: 20,
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
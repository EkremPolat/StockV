import 'dart:convert';
import 'package:http/http.dart' as http;

Future<bool> register(String fullName, String email, String password) async {
  var url = 'http://10.0.2.2:8000/signup/';
  var response = await http.post(
    Uri.parse(url),
    body: json
        .encode({'full_name': fullName, 'email': email, 'password': password}),
    headers: {
      "Content-Type": "application/json",
    },
  );
  print(response.statusCode);
  if (response.statusCode == 200) {
    //Or put here your next screen using Navigator.push() method
    return Future.value(true);
  } else {
    return Future.value(false);
  }
}

Future<bool> login(String email, String password) async {
  var url = 'http://10.0.2.2:8000/login/';
  var response = await http.post(
    Uri.parse(url),
    body: json.encode({'email': email, 'password': password}),
    headers: {
      "Content-Type": "application/json",
    },
  );
  print(response.statusCode);
  if (response.statusCode == 200) {
    //Or put here your next screen using Navigator.push() method
    return Future.value(true);
  } else {
    return Future.value(false);
  }
}

Future<bool> password_change(String fullName, String email, String old_password,
    String new_password) async {
  var url = 'http://10.0.2.2:8000/password-change/';
  print(new_password);
  var response = await http.put(
    Uri.parse(url),
    body: json.encode(
        {'full_name': fullName, 'email': email, 'password': new_password}),
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json",
    },
  );
  print(response.statusCode);
  if (response.statusCode == 200) {
    //Or put here your next screen using Navigator.push() method
    return Future.value(true);
  } else {
    return Future.value(false);
  }
}

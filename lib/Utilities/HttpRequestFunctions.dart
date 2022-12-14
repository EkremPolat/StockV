import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Models/User.dart';

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
  if (response.statusCode == 200) {
    //Or put here your next screen using Navigator.push() method
    return Future.value(true);
  } else {
    return Future.value(false);
  }
}

Future<User?> login(String email, String password) async {
  var url = 'http://10.0.2.2:8000/login/';
  var response = await http.post(
    Uri.parse(url),
    body: json.encode({'email': email, 'password': password}),
    headers: {
      "Content-Type": "application/json",
    },
  );
  if (response.statusCode == 200) {
    final userData = jsonDecode(response.body);
    String fullName = userData["full_name"];
    String email = userData["email"];
    User user = User(email, fullName);
    //Or put here your next screen using Navigator.push() method
    return Future.value(user);
  } else {
    return Future.value(null);
  }
}

Future<String?> passwordChange(String? fullName, String? email,
    String oldPassword, String? newPassword) async {
  var passwordVerificationURL = 'http://10.0.2.2:8000/verify-password/';
  var passwordVerificationResponse = await http.post(
    Uri.parse(passwordVerificationURL),
    body: json.encode({'email': email, 'password': oldPassword}),
    headers: {
      "Content-Type": "application/json",
    },
  );
  if (passwordVerificationResponse.statusCode == 200) {
    var url = 'http://10.0.2.2:8000/password-change/';
    dynamic response;
    if (newPassword != null && newPassword.isNotEmpty) {
      response = await http.patch(
        Uri.parse(url),
        body: json.encode(
            {'full_name': fullName, 'email': email, 'password': newPassword}),
        headers: {
          "Content-Type": "application/json",
        },
      );

    } else {
      response = await http.patch(
        Uri.parse(url),
        body: json.encode({'full_name': fullName, 'email': email}),
        headers: {
          "Content-Type": "application/json",
        },
      );
    }

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("data");
      print(data);
      return Future.value(data["full_name"]);
    } else {
      return Future.value(null);
    }
  } else {
    return Future.value(null);
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/user.dart';
import '../Models/coin.dart';

Future<bool> register(String fullName, String email, String password) async {
  var url = 'http://127.0.0.1:8000/signup/';
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
  var url = 'http://127.0.0.1:8000/login/';
  var response = await http.post(
    Uri.parse(url),
    body: json.encode({'email': email, 'password': password}),
    headers: {
      "Content-Type": "application/json",
    },
  );
  if (response.statusCode == 200) {
    final userData = jsonDecode(response.body);
    String id = userData["id"];
    String email = userData["email"];
    String fullName = userData["full_name"];
    User user = User(id: id, email: email, fullName: fullName);    //Or put here your next screen using Navigator.push() method
    return Future.value(user);
  } else {
    return Future.value(null);
  }
}

Future<String?> passwordChange(String? fullName, String? email,
    String oldPassword, String? newPassword) async {
  var passwordVerificationURL = 'http://127.0.0.1:8000/verify-password/';
  var passwordVerificationResponse = await http.post(
    Uri.parse(passwordVerificationURL),
    body: json.encode({'email': email, 'password': oldPassword}),
    headers: {
      "Content-Type": "application/json",
    },
  );
  if (passwordVerificationResponse.statusCode == 200) {
    var url = 'http://127.0.0.1:8000/password-change/';
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

Future<List<Coin>> fetchCoinsFromDB() async {
  var url = 'http://127.0.0.1:8000/coins/';
  var response = await http.get(
    Uri.parse(url),
  );
  if (response.statusCode == 200) {
    final coinList = (jsonDecode(response.body) as List)
        .map((json) => Coin.fromJson(json))
        .toList();

    coinList.sort((a, b) => b.price.compareTo(a.price));
    return coinList;
  } else {
    return Future.value([]);
  }
}

Future<List<Coin>> fetchSavedCoinsFromDB(String userID) async {
  var url = 'http://127.0.0.1:8000/saved-coins/$userID/';
  var response = await http.get(
    Uri.parse(url),
  );
  if (response.statusCode == 200) {
    final coinList = (jsonDecode(response.body) as List)
        .map((json) => Coin.fromJson(json))
        .toList();

    coinList.sort((a, b) => b.price.compareTo(a.price));
    return coinList;
  } else {
    return Future.value([]);
  }
}

Future<List<Coin>> addSavedCoinsToUser(String userId, int coinId) async {
  var url = 'http://127.0.0.1:8000/add-saved-coin/';
  var response = await http.post(
    Uri.parse(url),
    body: json.encode({'userId': userId, 'coinId': coinId}),
    headers: {
      "Content-Type": "application/json",
    },
  );
  if (response.statusCode == 200) {
    final coinList = (jsonDecode(response.body) as List)
        .map((json) => Coin.fromJson(json))
        .toList();

    coinList.sort((a, b) => b.price.compareTo(a.price));
    return Future.value(coinList);
  } else {
    return Future.value([]);
  }
}

Future<List<Coin>> removeSavedCoinsFromUser(String userId, int coinId) async {
  var url = 'http://127.0.0.1:8000/remove-saved-coin/';
  var response = await http.post(
    Uri.parse(url),
    body: json.encode({'userId': userId, 'coinId': coinId}),
    headers: {
      "Content-Type": "application/json",
    },
  );
  if (response.statusCode == 200) {
    final coinList = (jsonDecode(response.body) as List)
        .map((json) => Coin.fromJson(json))
        .toList();

    coinList.sort((a, b) => b.price.compareTo(a.price));
    return Future.value(coinList);
  } else {
    return Future.value([]);
  }
}

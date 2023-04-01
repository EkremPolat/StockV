import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:stockv/Models/has_crypto_data.dart';
import 'package:stockv/Models/transaction.dart';
import 'package:stockv/Models/wallet_coin.dart';

Future<List<WalletCoin>> getUserWallet(String userID) async {
  var url = 'http://10.0.2.2:8000/get-wallet/$userID/';
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    final wallet = (jsonDecode(response.body) as List)
        .map((json) => WalletCoin.fromJson(json))
        .toList();
    wallet.sort((a, b) => b.amount.compareTo(a.amount));
    return wallet;
  } else {
    return Future.value([]);
  }
}

Future<double> buyCrypto(
    String userId, String coinName, double amount, double totalCost) async {
  var url = 'http://10.0.2.2:8000/buy-crypto/';
  var response = await http.post(
    Uri.parse(url),
    body:
        json.encode({'userId': userId, 'coinName': coinName, 'amount': amount, 'cost' : totalCost}),
    headers: {
      "Content-Type": "application/json",
    },
  );
  if (response.statusCode == 200) {
    double balance = json.decode(response.body)['balance'];
    return Future.value(balance);
  } else {
    return Future.value(0);
  }
}

Future<HasCryptoData> hasCrypto(String userId, String coinName) async {
  const url = 'http://10.0.2.2:8000/has-crypto/';
  var response = await http.post(Uri.parse(url),
      body: json.encode({
        'userId': userId,
        'coinName': coinName,
      }),
      headers: {"Content-Type": "application/json"});
  if (response.statusCode == 200) {
    final transactionData = json.decode(response.body);
    return HasCryptoData(
        hasCrypto: transactionData['hasCrypto'],
        amount: transactionData['amount']);
  } else {
    return Future.value(HasCryptoData(hasCrypto: false, amount: 0));
  }
}

Future<double> sellCrypto(
    String userId, String coinName, double amount, double totalEarning) async {
  var url = 'http://10.0.2.2:8000/sell-crypto/';
  var response = await http.post(Uri.parse(url),
      body:
          json.encode({'userId': userId, 'coinName': coinName, 'amount': amount, 'totalEarnings' : totalEarning}),
      headers: {"Content-Type": "application/json"});
  if (response.statusCode == 200) {
    double balance = json.decode(response.body)['balance'];
    return Future.value(balance);
  } else {
    return Future.value(0);
  }
}

Future<List<Transaction>> getUserTransactionHistory (String userId) async {
  var url = 'http://10.0.2.2:8000/get-transaction-history/$userId/';
  var response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    final transactionHistory = (jsonDecode(response.body) as List)
        .map((json) => Transaction.fromJson(json))
        .toList();
    transactionHistory.sort((a, b) => b.date.compareTo(a.date));
    return Future.value(transactionHistory);
  } else {
    return Future.value([]);
  }
}

Future<double> getUserBalance(String userId) async {
  var url = 'http://10.0.2.2:8000/get-user-balance/$userId/';
  var response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    final balance = jsonDecode(response.body)['balance'];
    return Future.value(balance);
  } else {
    return Future.value(-1);
  }
}

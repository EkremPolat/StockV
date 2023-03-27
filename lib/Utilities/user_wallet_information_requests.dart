import 'dart:convert';

import 'package:stockv/Models/coin.dart';
import 'package:http/http.dart' as http;
import 'package:stockv/Models/has_crypto_data.dart';
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

Future<List<WalletCoin>> buyCrypto(
    String userId, String coinName, int amount) async {
  var url = 'http://10.0.2.2:8000/buy-crypto/';
  var response = await http.post(
    Uri.parse(url),
    body:
        json.encode({'userId': userId, 'coinName': coinName, 'amount': amount}),
    headers: {
      "Content-Type": "application/json",
    },
  );
  if (response.statusCode == 200) {
    final walletCoinList = (jsonDecode(response.body) as List)
        .map((json) => WalletCoin.fromJson(json))
        .toList();

    walletCoinList.sort((a, b) => b.amount.compareTo(a.amount));
    return Future.value(walletCoinList);
  } else {
    return Future.value([]);
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

Future<List<Coin>> sellCrypto(String userId, int coinId, int amount) async {
  var url = 'http://10.0.2.2:8000/sell-crypto/';
  var response = await http.post(Uri.parse(url),
      body: json.encode({'userId': userId, 'coinId': coinId, 'amount': amount}),
      headers: {"Content-Type": "application/json"});
  if (response.statusCode == 200) {
    final walletCoinList = (jsonDecode(response.body) as List)
        .map((json) => Coin.fromJson(json))
        .toList();
    walletCoinList.sort((a, b) => b.price.compareTo(a.price));
    return Future.value(walletCoinList);
  } else {
    return Future.value([]);
  }
}

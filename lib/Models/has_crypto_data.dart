class HasCryptoData {
  final bool hasCrypto;
  final double amount;

  HasCryptoData({required this.hasCrypto, required this.amount});

  bool getHasCrypto() {
    return hasCrypto;
  }

  double getAmount() {
    return amount;
  }

  factory HasCryptoData.fromJson(Map<String, dynamic> json) {
    return HasCryptoData(
        hasCrypto: json['hasCrypto'] as bool, amount: json['amount'] as double);
  }
}

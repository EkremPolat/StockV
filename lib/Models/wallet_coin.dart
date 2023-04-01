class WalletCoin {
  final String coinName;
  final String coinSymbol;
  final double amount;
  final double usdValue;

  WalletCoin(
      {required this.coinName,
      required this.coinSymbol,
      required this.amount,
      required this.usdValue});

  String getCoinName() {
    return coinName;
  }

  double getAmount() {
    return amount;
  }

  factory WalletCoin.fromJson(Map<String, dynamic> json) {
    return WalletCoin(
        coinName: json['coinName'] as String,
        coinSymbol: json['coinSymbol'] as String,
        amount: json['amount'],
        usdValue: json['usdValue'] as double);
  }
}

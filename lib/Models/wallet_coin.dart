class WalletCoin {
  final String coinName;
  final String coinSymbol;
  final double amount;
  final double usdValue;
  final double dailyChange;

  WalletCoin(
      {required this.coinName,
      required this.coinSymbol,
      required this.amount,
      required this.usdValue,
      required this.dailyChange});

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
        usdValue: json['usdValue'] as double,
        dailyChange: json['dailyChange'] as double
        );
  }
}
double calculateTotalChange(List<WalletCoin> wallet) {
  double totalAssetsToday = 0;
  double totalAssetsYesterday = 0;

  for (WalletCoin coin in wallet) {
    totalAssetsToday += coin.usdValue;
    double coinValueYesterday = coin.usdValue / ((coin.dailyChange / 100) + 1);
    totalAssetsYesterday += coinValueYesterday;
  }

  return ((totalAssetsToday - totalAssetsYesterday) / totalAssetsYesterday) * 100;
}

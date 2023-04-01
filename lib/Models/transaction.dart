class Transaction {
  String date = '';
  String coinName = "";
  double coinPrice = 0;
  double coinAmount = 0;
  bool sellingTransaction = false;

  Transaction({required this.date, required this.coinAmount, required this.coinPrice, required this.sellingTransaction ,required this.coinName});

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
        date: json['date'] as String,
        coinName: json['coinName'] as String,
        coinPrice: json['coinPrice'] as double,
        coinAmount: json['coinAmount'] as double,
        sellingTransaction: json['isSelling'] as bool
    );
  }
}

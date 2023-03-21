class Coin
{
  final int id;
  final String name;
  final double price;
  final double dailyChange;
  final String symbol;

  Coin({required this.id, required this.name, required this.price, required this.dailyChange, required this.symbol});

  int getId(){
    return id;
  }

  String getName(){
    return name;
  }

  double getPrice(){
    return price;
  }

  double getDailyChange(){
    return dailyChange;
  }

  String getSymbol(){
    return symbol;
  }

  factory Coin.fromJson(Map<String, dynamic> json) {
    return Coin(
      id: json['id'] as int,
      name: json['name'] as String,
      price: json['price'] as double,
      dailyChange: json['dailyChange'] as double,
      symbol: json['symbol'] as String
    );
  }
}
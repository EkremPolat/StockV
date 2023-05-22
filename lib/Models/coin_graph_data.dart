import 'package:k_chart/entity/k_line_entity.dart';

class CoinGraphData {
  int time;
  double open = 0;
  double high = 0;
  double low = 0;
  double close = 0;
  double amount = 0;
  double vol = 0;

  CoinGraphData.withPrice({required this.time, required this.close});

  CoinGraphData.withOHLC(
      {required this.time,
      required this.open,
      required this.high,
      required this.low,
      required this.close,
      required this.amount,
      required this.vol});

  factory CoinGraphData.fromJson(List<dynamic> json) {
    return CoinGraphData.withOHLC(
        time: json[0],
        open: double.parse(json[1]),
        high: double.parse(json[2]),
        low: double.parse(json[3]),
        close: double.parse(json[4]),
        amount: double.parse(json[5]),
        vol: double.parse(json[7]));
  }

  KLineEntity toKLineEntity() {
    return KLineEntity.fromCustom(
      open: open,
      high: high,
      low: low,
      close: close,
      vol: vol,
      amount: amount,
      time: time,
    );
  }
}

class EtfPriceData {
  final DateTime time;
  final double etfPrice;

  EtfPriceData(this.time, this.etfPrice);
}

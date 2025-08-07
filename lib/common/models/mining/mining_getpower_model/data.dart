import 'package:happy/common/index.dart';

class MiningGetpowerModelData {
  int? id;
  int? pid;
  String? symbol;
  int? date;
  String? datetime;
  String? name;
  double? open;
  double? high;
  double? low;
  double? close;
  double? lastClose;
  int? price2;
  int? price3;
  int? openInt;
  double? volume;
  double? amount;
  int? is1min;
  int? is5min;
  int? is15min;
  int? is30min;
  int? is1h;
  int? is2h;
  int? is4h;
  int? is6h;
  int? is12h;
  int? isDay;
  int? isWeek;
  int? isMonth;

  MiningGetpowerModelData({
    this.id,
    this.pid,
    this.symbol,
    this.date,
    this.datetime,
    this.name,
    this.open,
    this.high,
    this.low,
    this.close,
    this.lastClose,
    this.price2,
    this.price3,
    this.openInt,
    this.volume,
    this.amount,
    this.is1min,
    this.is5min,
    this.is15min,
    this.is30min,
    this.is1h,
    this.is2h,
    this.is4h,
    this.is6h,
    this.is12h,
    this.isDay,
    this.isWeek,
    this.isMonth,
  });

  factory MiningGetpowerModelData.fromJson(Map<String, dynamic> json) => MiningGetpowerModelData(
        id: DataUtils.toInt(json['id']),
        pid: DataUtils.toInt(json['pid']),
        symbol: DataUtils.toStr(json['Symbol']),
        date: DataUtils.toInt(json['Date']),
        datetime: DataUtils.toStr(json['datetime']),
        name: DataUtils.toStr(json['Name']),
        open: DataUtils.toDouble(json['Open']),
        high: DataUtils.toDouble(json['High']),
        low: DataUtils.toDouble(json['Low']),
        close: DataUtils.toDouble(json['Close']),
        lastClose: DataUtils.toDouble(json['LastClose']),
        price2: DataUtils.toInt(json['Price2']),
        price3: DataUtils.toInt(json['Price3']),
        openInt: DataUtils.toInt(json['Open_Int']),
        volume: DataUtils.toDouble(json['Volume']),
        amount: DataUtils.toDouble(json['Amount']),
        is1min: DataUtils.toInt(json['is_1min']),
        is5min: DataUtils.toInt(json['is_5min']),
        is15min: DataUtils.toInt(json['is_15min']),
        is30min: DataUtils.toInt(json['is_30min']),
        is1h: DataUtils.toInt(json['is_1h']),
        is2h: DataUtils.toInt(json['is_2h']),
        is4h: DataUtils.toInt(json['is_4h']),
        is6h: DataUtils.toInt(json['is_6h']),
        is12h: DataUtils.toInt(json['is_12h']),
        isDay: DataUtils.toInt(json['is_day']),
        isWeek: DataUtils.toInt(json['is_week']),
        isMonth: DataUtils.toInt(json['is_month']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'pid': pid,
        'Symbol': symbol,
        'Date': date,
        'datetime': datetime,
        'Name': name,
        'Open': open,
        'High': high,
        'Low': low,
        'Close': close,
        'LastClose': lastClose,
        'Price2': price2,
        'Price3': price3,
        'Open_Int': openInt,
        'Volume': volume,
        'Amount': amount,
        'is_1min': is1min,
        'is_5min': is5min,
        'is_15min': is15min,
        'is_30min': is30min,
        'is_1h': is1h,
        'is_2h': is2h,
        'is_4h': is4h,
        'is_6h': is6h,
        'is_12h': is12h,
        'is_day': isDay,
        'is_week': isWeek,
        'is_month': isMonth,
      };
}

import 'package:hive/hive.dart';

part 'rate_model.g.dart';

@HiveType(typeId: 1)
class RateModel {
  @HiveField(0)
  String base;

  @HiveField(1)
  String date;

  @HiveField(2)
  Map<String, double> rates;

  RateModel({required this.base, required this.date, required this.rates});
}

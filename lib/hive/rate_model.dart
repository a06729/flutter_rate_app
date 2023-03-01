import 'package:hive/hive.dart';

part 'rate_model.g.dart';

@HiveType(typeId: 1)
class RateModel {
  //환율 카드 정보를 저장하는 필드
  //현재까지는 카드위치 변경되었을때 저장하는 용도로 사용되는 필드
  @HiveField(0)
  List<Map<String, dynamic>> rates;

  RateModel({required this.rates});
}

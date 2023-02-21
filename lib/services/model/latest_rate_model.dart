class LatestRateModel {
  final String base;
  final Map<String, dynamic> rates;

  LatestRateModel.fromJson(Map<String, dynamic> json)
      : base = json['base'],
        rates = json['rates'];
}

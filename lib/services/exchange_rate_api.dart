import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class ExchangeRateApi {
  final String baseUrl =
      'https://nginx-nginx-r8xoo2mleehqmty.sel3.cloudtype.app/rate';

  Future getRateApi({required String baseCode, required String amount}) async {
    final Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    final url = Uri.parse('$baseUrl/$baseCode');
    final response = await http.get(url, headers: requestHeaders);

    if (response.statusCode == 200) {
      var logger = Logger(
        printer: PrettyPrinter(),
      );
      final Map<String, dynamic> map = jsonDecode(response.body);
      // final json = LatestRateModel.fromJson(map);
      logger.d("api 환율정보:$map");
      return map;
    }
  }
}

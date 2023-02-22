import 'dart:convert';
import 'package:http/http.dart' as http;

class ExchangeRateApi {
  final String baseUrl =
      'https://port-0-rate-api-server-r8xoo2mleehqmty.sel3.cloudtype.app/rate';

  Future getRateApi({required String baseCode, required String amount}) async {
    final Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    final url = Uri.parse('$baseUrl/$baseCode');
    final response = await http.get(url, headers: requestHeaders);

    if (response.statusCode == 200) {
      final Map<String, dynamic> map = jsonDecode(response.body);
      // final json = LatestRateModel.fromJson(map);
      return map;
    }
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class GptApi {
  final String baseUrl =
      'https://nginx-nginx-r8xoo2mleehqmty.sel3.cloudtype.app/gpt/chat';

  Future getChatApi({required String message}) async {
    final Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    final url = Uri.parse('$baseUrl/$message');
    final response = await http.post(url, headers: requestHeaders);

    if (response.statusCode == 200) {
      var logger = Logger(
        printer: PrettyPrinter(),
      );
      final Map<String, dynamic> dataMap =
          jsonDecode(utf8.decode(response.bodyBytes));
      // final json = LatestRateModel.fromJson(map);
      logger.d("chatGpt결과:${dataMap['content']}");
      return dataMap;
    } else {
      return null;
    }
  }
}

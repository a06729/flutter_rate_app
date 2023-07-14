import 'package:exchange_rate_app/common/social_type.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FireBaseAuthRemote {
  final String baseUrl = dotenv.get("SERVER_URL");

  Future createCustomToken(Map<String, dynamic> user) async {
    // final test = await http.get(Uri.parse("https://www.google.com/"));
    // print("test:${test.body}");
    if (SocialType.kakao.text == user['platform']) {
      final url = Uri.parse('$baseUrl/social/kakao/token');
      // print("user:${user}");
      final customTokenResponse = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(user),
      );
      return customTokenResponse.body;
    } else {
      final url = Uri.parse('$baseUrl/social/line/token');
      // print("user:${user}");
      final customTokenResponse = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(user),
      );

      return utf8.decode(customTokenResponse.bodyBytes);
    }
  }
}

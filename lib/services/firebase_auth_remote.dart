import 'package:http/http.dart' as http;
import 'dart:convert';

class FireBaseAuthRemote {
  final String baseUrl =
      'https://nginx-nginx-r8xoo2mleehqmty.sel3.cloudtype.app';

  Future createCustomToken(Map<String, dynamic> user) async {
    // final test = await http.get(Uri.parse("https://www.google.com/"));
    // print("test:${test.body}");
    final url = Uri.parse('$baseUrl/social/kakao/token');
    // print("user:${user}");
    final customTokenResponse = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(user),
    );

    return customTokenResponse.body;
  }
}

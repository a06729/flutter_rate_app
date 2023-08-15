import 'package:exchange_rate_app/common/social_type.dart';
import 'package:exchange_rate_app/services/logger_fn.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FireBaseAuthRemote {
  final String baseUrl = dotenv.get("SERVER_URL");

  Future createCustomToken(Map<String, dynamic> user) async {
    // final test = await http.get(Uri.parse("https://www.google.com/"));
    // print("test:${test.body}");
    if (SocialType.kakao.text == user['platform']) {
      //카카오 로그인
      final url = Uri.parse('$baseUrl/social/kakao/token');
      // print("user:${user}");
      final customTokenResponse = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(user),
      );
      logger.d("카카오톡 로그인 결과값:${utf8.decode(customTokenResponse.bodyBytes)}");
      return utf8.decode(customTokenResponse.bodyBytes);
    } else {
      //라인 로그인
      final url = Uri.parse('$baseUrl/social/line/token');
      // print("user:${user}");
      final customTokenResponse = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode(user),
      );
      logger.d("라인 로그인 결과값:${utf8.decode(customTokenResponse.bodyBytes)}");
      return utf8.decode(customTokenResponse.bodyBytes);
    }
  }

  //라인으로 로그인시 기존에 가입된 이메일이나 uid가 있는지 확인하는 함수
  Future checkExistUserLine(String uid) async {
    final url = Uri.parse('$baseUrl/social/line/existUser/$uid');
    // print("user:${user}");
    final customTokenResponse = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
    );
    return utf8.decode(customTokenResponse.bodyBytes);
  }

  //커스텀 토큰으로 만들어서 로그인한 플랫폼이 아닌
  //파이어 베이스에 지원하는 소셜로그인시 firebase db에 초기 유저값을 저장하기 위한 함수
  Future<void> initUserDataNonCustomToken(Map<String, dynamic> userJson) async {
    final url = Uri.parse('$baseUrl/social/initUserData');
    await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(userJson),
    );
  }

  Future<int> userCoinAmount(String? uid) async {
    final url = Uri.parse('$baseUrl/social/userCoinAmount/${uid}');
    final response = await http.post(
      url,
    );
    logger.d("response:${response.body}");
    final dataJson = json.decode(response.body);
    return dataJson['coin'];
  }
}

import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:exchange_rate_app/services/logger_fn.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
      final Map<String, dynamic> dataMap =
          jsonDecode(utf8.decode(response.bodyBytes));
      // final json = LatestRateModel.fromJson(map);
      logger.d("chatGpt결과:${dataMap['content']}");
      // await getStreamChatApi(message: message);
      // await getStreamChatApi(message: message);

      return dataMap;
    } else {
      return null;
    }
  }

  Future<Response<ResponseBody>> getStreamChatApi(
      {required String message}) async {
    String url = dotenv.get("SERVER_URL");
    Response<ResponseBody> rs = await Dio().post<ResponseBody>(
      "$url/gpt/chat/stream/$message",
      options: Options(headers: {
        "Accept": "text/event-stream",
        "Cache-Control": "no-cache",
      }, responseType: ResponseType.stream), // set responseType to `stream`
    );

    // StreamTransformer<Uint8List, List<int>> unit8Transformer =
    //     StreamTransformer.fromHandlers(
    //   handleData: (data, sink) {
    //     sink.add(List<int>.from(data));
    //   },
    // );

    // rs.data?.stream
    //     .transform(unit8Transformer)
    //     .transform(const Utf8Decoder())
    //     .transform(const LineSplitter())
    //     .listen((event) {
    //   // logger.d("gptStream:${event}");
    // });

    return rs;
  }
}

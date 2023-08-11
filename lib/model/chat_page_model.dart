import 'dart:async';
import 'package:dio/dio.dart';
import 'package:exchange_rate_app/services/gpt_api.dart';
import 'package:exchange_rate_app/widgets/model/message_model.dart';
import 'package:logger/logger.dart';

class ChatPageModel {
  var logger = Logger(
    printer: PrettyPrinter(),
  );

  dynamic _gptMessage = '';
  List<MessageModel> _messages = [];

  bool _gptLoding = false;

  //현재페이지
  int _currentPage = 1;

  // gpt 요청시 코인이 없으면 에러가 보내오는데
  // 코인이 있는지 없는지 판별하는 에러
  bool _gptRequestError = false;

  get gptMessage => _gptMessage;
  List<MessageModel> get messages => _messages;
  int get currentPage => _currentPage;
  bool get gptLoding => _gptLoding;
  bool get gptRequestError => _gptRequestError;

  set gptLoding(bool loding) => _gptLoding = loding;

  set currentPage(int currentPage) => _currentPage = currentPage;

  set messages(List<MessageModel> newMessages) => _messages = newMessages;

  // Future<Response<ResponseBody>> getGptStreamApi(String message) async {
  //   var streamRespons = await GptApi().getStreamChatApi(message: message);
  //   return streamRespons;
  // }

  Future<String> getGptApi(String message) async {
    _gptMessage = await GptApi()?.getChatApi(message: message);

    if (_gptMessage != null) {
      MessageModel messageModel = MessageModel(
          text: '${_gptMessage['content']}',
          dateTime: DateTime.now(),
          isSentByMe: false,
          newMassage: true);

      _messages.add(messageModel);

      return _gptMessage['content'];
    } else {
      MessageModel messageModel = MessageModel(
          text: '통신실패',
          dateTime: DateTime.now(),
          isSentByMe: false,
          newMassage: true);
      _messages.add(messageModel);
      return '통신실패';
    }
  }
}

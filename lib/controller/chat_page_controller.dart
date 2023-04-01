import 'package:exchange_rate_app/model/chat_page_model.dart';
import 'package:exchange_rate_app/widgets/model/message_model.dart';
import 'package:flutter/material.dart';

class ChatPageController extends ChangeNotifier {
  late final ChatPageModel _model;

  ChatPageController() {
    _model = ChatPageModel();
  }

  String get gptMessage => _model.gptMessage;
  List<MessageModel> get messages => _model.messages;

  void update() {
    notifyListeners();
  }

  Future<void> getGptApi(String message) async {
    MessageModel messageModel = MessageModel(
      text: message,
      dateTime: DateTime.now(),
      isSentByMe: false,
    );
    messages.add(messageModel);
    update();

    await _model.getGptApi(message);
    update();
  }
}

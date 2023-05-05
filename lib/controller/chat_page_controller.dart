import 'package:exchange_rate_app/db/app_db.dart';
import 'package:exchange_rate_app/model/chat_page_model.dart';
import 'package:exchange_rate_app/widgets/model/message_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;

class ChatPageController extends ChangeNotifier {
  late final ChatPageModel _model;
  // late AppDb _db;

  ChatPageController() {
    _model = ChatPageModel();
    // _db = AppDb();
  }

  String get gptMessage => _model.gptMessage;
  bool get gptLoding => _model.gptLoding;
  List<MessageModel> get messages => _model.messages;

  void update() {
    notifyListeners();
  }

  parseMessage(List<ChatMessageData> chatMssages) {
    chatMssages.forEach((element) {
      MessageModel messageModel = MessageModel(
        text: element.message,
        dateTime: element.messageDateTime,
        isSentByMe: element.myMessage,
      );
      messages.add(messageModel);
    });
  }

  void initMassage(List<ChatMessageData> chatMssages) {
    parseMessage(chatMssages);
    update();
    // compute(parseMessage, chatMssages).then(
    //   (value) {
    //     update();
    //   },
    // );
  }

  Future<String> getGptApi(String message) async {
    _model.gptLoding = true;
    MessageModel messageModel = MessageModel(
      text: message,
      dateTime: DateTime.now(),
      isSentByMe: true,
    );

    messages.add(messageModel);
    update();

    String gptMsg = await _model.getGptApi(message);

    //로딩 종료 업데이트
    _model.gptLoding = false;

    //gpt 메세지 sqllite에 저장
    // messageSave(gptMessage, false);
    update();

    return gptMsg;
  }
}

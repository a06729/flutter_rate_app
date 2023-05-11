import 'package:exchange_rate_app/db/app_db.dart';
import 'package:exchange_rate_app/model/chat_page_model.dart';
import 'package:exchange_rate_app/widgets/model/message_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;

class ChatPageController extends ChangeNotifier {
  late final ChatPageModel _model;
  AppDb? _appDb;

  ChatPageController() {
    _model = ChatPageModel();
  }

  String get gptMessage => _model.gptMessage;
  bool get gptLoding => _model.gptLoding;
  List<MessageModel> get messages => _model.messages;

  void initAppDb(AppDb db) {
    _appDb = db;
  }

  void update() {
    notifyListeners();
  }

  parseMessage(List<ChatMessageData> chatMssages) {
    for (var element in chatMssages) {
      MessageModel messageModel = MessageModel(
        text: element.message,
        dateTime: element.messageDateTime,
        isSentByMe: element.myMessage,
      );
      messages.add(messageModel);
    }
  }

  void initMassage(List<ChatMessageData> chatMssages) {
    parseMessage(chatMssages);
    update();
  }

  void saveUserMassage(String massage) {
    final ChatMessageCompanion entity;
    entity = ChatMessageCompanion(
      message: drift.Value(massage),
      myMessage: const drift.Value(true),
      messageDateTime: drift.Value(DateTime.now()),
    );
    _appDb?.saveMessage(entity);
  }

  void saveGptMassage(String massage) {
    final ChatMessageCompanion gptEntity;
    gptEntity = ChatMessageCompanion(
      message: drift.Value(massage),
      myMessage: const drift.Value(false),
      messageDateTime: drift.Value(DateTime.now()),
    );
    _appDb?.saveMessage(gptEntity);
  }

  void addMessage(message, isSentByMe) {
    MessageModel messageModel = MessageModel(
      text: message,
      dateTime: DateTime.now(),
      isSentByMe: isSentByMe,
    );
    messages.add(messageModel);
    update();
  }

  Future<void> getGptApi(String message) async {
    _model.gptLoding = true;

    //유제 메세지 화면에 업데이트
    addMessage(message, true);

    //유저 메세지 sqlite에 저장
    saveUserMassage(message);

    String gptMsg = await _model.getGptApi(message);

    //로딩 종료 업데이트
    _model.gptLoding = false;

    //gpt 메세지 sqllite에 저장
    saveGptMassage(gptMsg);

    update();
  }
}

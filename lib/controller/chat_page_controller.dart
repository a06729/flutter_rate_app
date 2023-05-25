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
  int get curruntPage => _model.currentPage;

  //db 초기화
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

  //ui가 처음그려질때 가져온 메세지값을 ui에 띄우기 위한 함수
  void initMassage(List<ChatMessageData> chatMssages) {
    //ui가 처음 그려질때의 값을 가져와서
    //parseMessage함수에서 반복문을 통해서
    //messages에 값을 더하기 위한 함수
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

  //다음페이지의 값을 가져오기위한 페이징 함수
  //ui업데이트까지 진행한다.
  void nextPage(int nextPage) async {
    //_model.currentPage에 nextPage를 넣으면서
    //초기값 1페이지에서 2페이지로 증가시키게 된다.
    //그값은 provider에 저장이된다.
    _model.currentPage = nextPage;

    //다음페이지의 메세지를 가져오는 변수
    List<ChatMessageData>? nextPageMessages =
        await _appDb?.getChatMessage(_model.currentPage);

    //다음페이지에서 가져온값이 null이아니면
    if (nextPageMessages!.isNotEmpty) {
      //다음페이지에서 가져온 메세지값을 저장하기 위한 변수
      List<MessageModel> nextMessage = [];

      for (var element in nextPageMessages) {
        MessageModel messageModel = MessageModel(
          text: element.message,
          dateTime: element.messageDateTime,
          isSentByMe: element.myMessage,
        );

        //다음페이지에 가져온 메세지값을 저장하기위한 변수
        nextMessage.add(messageModel);
      }

      //_model.messages의 기존 메세지에 다음페이지 값을 배열에 더하기위한 기능
      _model.messages = List.from(nextMessage)..addAll(messages);
    }
    update();
  }

  //gpt api의 값을 불러워서 ui에 반영하는 함수
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

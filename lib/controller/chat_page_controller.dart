import 'package:exchange_rate_app/db/app_db.dart';
import 'package:exchange_rate_app/model/chat_page_model.dart';
import 'package:exchange_rate_app/widgets/model/message_model.dart';
import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart' as drift;

//
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
  bool get gptRequestError => _model.gptRequestError;

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

  //로딩ui 스위치
  void gptLoddingSwitch(bool switchValue) {
    _model.gptLoding = switchValue;
    update();
  }

  //gpt api의 값을 불러워서 ui에 반영하는 함수
  // Future<void> getGptApi(String message) async {
  //   String text = "";
  //   int lastIndex = _model.messages.length;

  //   _model.gptLoding = true;

  //   //유제 메세지 화면에 업데이트
  //   addMessage(message, true);

  //   //유저 메세지 sqlite에 저장
  //   saveUserMassage(message);

  //   // String gptMsg = await _model.getGptApi(message);
  //   try {
  //     var streamData = await _model.getGptStreamApi(message);

  //     StreamTransformer<Uint8List, List<int>> unit8Transformer =
  //         StreamTransformer.fromHandlers(
  //       handleData: (data, sink) {
  //         sink.add(List<int>.from(data));
  //       },
  //     );
  //     streamData.data?.stream
  //         .transform(unit8Transformer)
  //         .transform(const Utf8Decoder())
  //         .transform(const LineSplitter())
  //         .listen((event) {
  //       logger.d("gptStream:$event");
  //       text = "$text$event\n";
  //       if (_model.messages[lastIndex + 1] == "") {
  //         MessageModel messageModel = MessageModel(
  //             text: text,
  //             dateTime: DateTime.now(),
  //             isSentByMe: false,
  //             newMassage: false);
  //         _model.messages[lastIndex + 1] = messageModel;
  //       } else {
  //         MessageModel messageModel = _model.messages.last;
  //         messageModel.text = text;
  //         _model.messages[lastIndex + 1] = messageModel;
  //       }
  //       update();
  //     }).onDone(() {
  //       // MessageModel messageModel = MessageModel(
  //       //     text: text,
  //       //     dateTime: DateTime.now(),
  //       //     isSentByMe: false,
  //       //     newMassage: true);

  //       // _model.messages.add(messageModel);
  //       //로딩 종료 업데이트
  //       _model.gptLoding = false;

  //       //gpt 메세지 sqllite에 저장
  //       saveGptMassage(text);

  //       update();
  //     });
  //   } on DioException catch (e) {
  //     //서버에서 403에러를 보내는 경우 코인이 부족하다는 것을 의미
  //     if (e.response?.statusCode == 403) {
  //       logger.d("에러 코드:${e.response?.statusCode}");
  //       logger.d("에러 코드:${e.message}");
  //       //채팅 페이지의 로딩을 종료
  //       _model.gptLoding = false;
  //       update();
  //       //결제화면으로 이동
  //       Get.toNamed("/purchasesPage");
  //     }
  //   }
  // }
}

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:exchange_rate_app/controller/chat_page_controller.dart';
import 'package:exchange_rate_app/controller/theam_controller.dart';
import 'package:exchange_rate_app/db/app_db.dart';
import 'package:exchange_rate_app/services/logger_fn.dart';
import 'package:exchange_rate_app/widgets/model/message_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart' hide Response;
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:exchange_rate_app/styles/chat_page_style.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final TextEditingController textFieldController;
  late MessageModel message;
  late ChatPageController chatPageController;
  late TheamController theamController;

  //스트림으로 ChatGpt 스트림 텍스트를 컨트롤하기 위한 변수
  late StreamController _requestStreamController;

  late String msg;

  final _scrollController = ScrollController();

  FocusNode textFildFocus = FocusNode();

  //GroupedListView의 스크롤시 작동하는 이벤트 함수
  _scrollListener() {
    if (_scrollController.position.atEdge) {
      //스크롤이 제일 위로 올라갔을때 반응한다.
      if (_scrollController.position.pixels != 0) {
        //chatPageController.curruntPage의 값을 1증가시킨다.
        //다음페이지로 증가시킨 값을 nextPage함수에 파라미터로 보낸다.
        int currentPage = chatPageController.curruntPage + 1;
        chatPageController.nextPage(currentPage);
      }
    }
  }

  //Dio라이브러리로 나의 서버에 ChatgptStream값을 요청하기 위한 함수
  Future<Response<ResponseBody>> getStreamChatApi(
      {required String message}) async {
    String url = dotenv.get("SERVER_URL");
    final User? userInstance = FirebaseAuth.instance.currentUser;

    Response<ResponseBody> rs = await Dio().post<ResponseBody>(
      "$url/gpt/chat/stream/$message",
      data: {
        "uid": userInstance?.uid,
        "email": userInstance?.email,
      },
      options: Options(
        headers: {
          "Accept": "text/event-stream",
          "Cache-Control": "no-store,no-cache,must-revalidate",
        },
        responseType: ResponseType.stream,
      ), // set responseType to `stream`
    );

    return rs;
  }

  //서버에서 ChatGptStream 방식으로 받기 위한 함수
  getGptApiStream(String message) async {
    //서버에서 받아온 chatGpt stream 텍스트를 저장하기 위한 변수
    String gptText = "";

    logger.d("입력한 메세지:$message");

    //gpt 로딩 ui 온
    chatPageController.gptLoddingSwitch(true);

    //유저가 메세지 입력한걸 가져오기 위한것
    MessageModel userMessageModel = MessageModel(
        text: message,
        dateTime: DateTime.now(),
        isSentByMe: true,
        newMassage: false);

    //컨트롤러의 messages변수에 최신 유저 채팅값 저장
    chatPageController.messages.add(userMessageModel);

    //Stream 컨트롤러에 최신 유저의 채팅 값을 ui에 표시하기 위한 것
    _requestStreamController.add(chatPageController.messages);

    //유저 메세지 sqlite에 저장
    chatPageController.saveUserMassage(message);

    try {
      //http stream으로 서버에 요청하는 함수
      var streamData = await getStreamChatApi(message: message);

      //chatPageController.messages의 리스트 마지막 인덱스 번호를 저장하기 위한 변수
      int lastIndex = 0;

      //서버에서 받아온 stream 텍스트를 겍체에 맞게 저장
      MessageModel responseModel = MessageModel(
          text: "",
          dateTime: DateTime.now(),
          isSentByMe: false,
          newMassage: false);

      //chatPageController.messages에 서버에서 받아온 gpt 값을 저장하기위해서
      //일단 text값이 비어진 상태로 일단 저장
      chatPageController.messages.add(responseModel);

      //위에서 chatPageController.messages에 값을 추가해서 그 추가한 값에서
      //리스트의 마지막 인덱스를 구함
      lastIndex = chatPageController.messages.length - 1;

      //utf8 변환을 위한 핸들러
      StreamTransformer<Uint8List, List<int>> unit8Transformer =
          StreamTransformer.fromHandlers(
        handleData: (data, sink) {
          sink.add(List<int>.from(data));
        },
      );

      streamData.data?.stream
          .transform(unit8Transformer)
          .transform(const Utf8Decoder())
          .transform(const LineSplitter())
          .listen((event) {
        logger.d("gptStream:$event");

        //gptText 변수에 스트림 텍스트를 최신화해서 저장
        gptText = "$gptText$event\n";

        //responseModel에 gptText 값으로 값을 저장
        responseModel.text = gptText;
        //마지막 인덱스가 gpt 채팅이므로 마지막 gpt값만 최신화해서 저장
        chatPageController.messages[lastIndex].text = gptText;

        //streambuilder에 값을 최신화 하기위해서 stream에 추가
        _requestStreamController.sink.add(chatPageController.messages);
      }).onDone(() {
        //로딩 ui 종료
        chatPageController.gptLoddingSwitch(false);
        //스트림 종료후 gpt메세지 저장
        chatPageController.saveGptMassage(gptText);
      });
    } on DioException catch (e) {
      //서버에서 403에러를 보내는 경우 코인이 부족하다는 것을 의미
      if (e.response?.statusCode == 403) {
        logger.d("에러 코드:${e.response?.statusCode}");
        logger.d("에러 코드:${e.message}");
        //채팅 페이지의 로딩을 종료
        chatPageController.gptLoddingSwitch(false);
        //결제화면으로 이동
        Get.toNamed("/purchasesPage");
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _requestStreamController = StreamController<List<MessageModel>>();
    textFieldController = TextEditingController();
    theamController = Provider.of<TheamController>(context, listen: false);
    _scrollController.addListener(_scrollListener);
    chatPageController =
        Provider.of<ChatPageController>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    textFieldController.dispose();
    textFildFocus.dispose();
    _scrollController.dispose();
    _requestStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => textFildFocus.unfocus(),
      child: Consumer<TheamController>(
        builder: (context, value, child) {
          return Scaffold(
            appBar: AppBar(
                backgroundColor: value.darkMod
                    ? ChatPageStyle.bgColorDark
                    : ChatPageStyle.bgColor),
            backgroundColor: value.darkMod
                ? ChatPageStyle.bgColorDark
                : ChatPageStyle.bgColor,
            resizeToAvoidBottomInset: true,
            body: SafeArea(
              child: Column(mainAxisSize: MainAxisSize.max, children: [
                chatArea(context),
                loadingWidget(),
                const SizedBox(
                  height: 5,
                ),
                messageBox(),
              ]),
            ),
          );
        },
      ),
    );
  }

  FutureBuilder<List<ChatMessageData>> chatArea(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<AppDb>(context, listen: false)
          .getChatMessage(chatPageController.curruntPage),
      // future: Provider.of<AppDb>(context, listen: false).initChatMessage(),
      builder: (context, snapshot) {
        final List<ChatMessageData>? chatMssages = snapshot.data;

        //db값 불러오는 로딩
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        //db불러올때 에러발생시 실행
        if (snapshot.hasError) {
          return Center(
            child: Text(snapshot.error.toString()),
          );
        }
        //db에 값이 null이 아니라면 실행
        if (chatMssages != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (chatPageController.messages.isEmpty) {
              // print(chatMssages);
              chatPageController.initMassage(chatMssages);
            }
          });
          return Expanded(
            child: Consumer<ChatPageController>(
              builder: (context, value, child) {
                return chatGroupedListViewStream(value);
              },
            ),
          );
        }
        //db값이 없을때 표시데는 글자
        return const Text("no Data");
      },
    );
  }

  //현재 사용x
  GroupedListView<MessageModel, DateTime> chatGroupedListView(
      ChatPageController value) {
    return GroupedListView<MessageModel, DateTime>(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      reverse: true,
      order: GroupedListOrder.DESC,
      controller: _scrollController,
      padding: const EdgeInsets.all(8),
      elements: value.messages,
      groupBy: (message) => DateTime(
        message.dateTime.year,
        message.dateTime.month,
        message.dateTime.day,
      ),
      groupHeaderBuilder: groupHeaderWidget,
      itemBuilder: (context, MessageModel message) => Align(
        alignment:
            message.isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Card(
          color: message.isSentByMe ? Colors.blueAccent : Colors.blueGrey,
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: message.isSentByMe
                ? Text(
                    message.text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  )
                : message.newMassage
                    ? AnimatedTextKit(
                        repeatForever: false,
                        displayFullTextOnTap: true,
                        onTap: () {
                          //새로운 메세지만 애니메이션 실행하고
                          //기존의 이미지면 애니메이션 실행 안하도록하는것
                          chatPageController.messages.last.newMassage = false;
                        },
                        animatedTexts: [
                          TyperAnimatedText(message.text,
                              speed: const Duration(milliseconds: 30),
                              textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              )),
                        ],
                        onFinished: () {
                          chatPageController.messages.last.newMassage = false;
                        },
                        totalRepeatCount: 1,
                      )
                    : Text(
                        message.text,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
          ),
        ),
      ),
    );
  }

  //스트림 방식으로 채팅 정보 표시하기 위한 위젯 (현재 사용중)
  Widget chatGroupedListViewStream(ChatPageController value) {
    return StreamBuilder(
        initialData: value.messages,
        stream: _requestStreamController.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GroupedListView<MessageModel, DateTime>(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              reverse: true,
              order: GroupedListOrder.DESC,
              controller: _scrollController,
              padding: const EdgeInsets.all(8),
              elements: snapshot.data,
              groupBy: (message) => DateTime(
                message.dateTime.year,
                message.dateTime.month,
                message.dateTime.day,
              ),
              groupHeaderBuilder: groupHeaderWidget,
              itemBuilder: (context, MessageModel message) => Align(
                alignment: message.isSentByMe
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Card(
                  color:
                      message.isSentByMe ? Colors.blueAccent : Colors.blueGrey,
                  elevation: 8,
                  child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        message.text,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      )),
                ),
              ),
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }

  //그룹핑 하는 날짜 기준으로 표시하는 헤더 위젯
  Widget groupHeaderWidget(MessageModel message) {
    return SizedBox(
      height: 40,
      child: Center(
          child: Card(
        color: Colors.red,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            DateFormat("yyyy-MM").format(message.dateTime),
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      )),
    );
  }

  Consumer<ChatPageController> loadingWidget() {
    return Consumer<ChatPageController>(
      builder: (context, value, child) {
        return Visibility(
          visible: value.gptLoding,
          child: const SizedBox(
            height: 50,
            child: LoadingIndicator(
              indicatorType: Indicator.ballPulseSync,
              colors: [Colors.blue, Colors.red, Colors.green],
              pathBackgroundColor: Colors.transparent,
              backgroundColor: Colors.transparent,
            ),
          ),
        );
      },
    );
  }

  Widget messageBox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              focusNode: textFildFocus,
              controller: textFieldController,
              textInputAction: TextInputAction.newline,
              maxLines: null,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(10),
                hintText: '텍스트 입력',
                enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      width: 1,
                      color: ChatPageStyle.chatInputBorderColor,
                    ),
                    borderRadius: BorderRadius.circular(10)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                      width: 3, color: ChatPageStyle.chatInputBorderColor),
                ),
              ),
            ),
          ),
        ),
        sendIcon(),
      ],
    );
  }

  //메세지 보내기 아이콘 그려주는 함수
  SizedBox sendIcon() {
    return SizedBox(
      width: 50,
      child: Consumer<ChatPageController>(
        builder: (context, value, child) {
          if (value.gptLoding) {
            //gpt 값을 받아오는동안 로딩 아이콘이 나오도록 한다
            return const SizedBox(
              width: 25,
              child: LoadingIndicator(
                indicatorType: Indicator.ballRotateChase,
                colors: [Colors.blue, Colors.red, Colors.green],
                pathBackgroundColor: Colors.transparent,
                backgroundColor: Colors.transparent,
              ),
            );
          } else {
            //서버로 메세지 입력값을 보내는 버튼
            return IconButton(
              onPressed: () async {
                msg = textFieldController.text;
                if (textFieldController.text != "") {
                  textFieldController.text = "";
                  FocusManager.instance.primaryFocus?.unfocus();
                  getGptApiStream(msg);
                }
              },
              icon: const Icon(Icons.send),
              iconSize: 35,
            );
          }
        },
      ),
    );
  }
}

import 'package:exchange_rate_app/controller/chat_page_controller.dart';
import 'package:exchange_rate_app/controller/theam_controller.dart';
import 'package:exchange_rate_app/db/app_db.dart';
import 'package:exchange_rate_app/widgets/model/message_model.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:hive_flutter/hive_flutter.dart';
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
  // StreamController<String> _responseStreamController =
  //     StreamController<String>();

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

  @override
  void initState() {
    // TODO: implement initState
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
    // _responseStreamController.close();
    super.dispose();
  }

  // void fetchStreamedResponse() async {
  //   String responseMessage = "";
  //   var logger = Logger(
  //     printer: PrettyPrinter(),
  //   );
  //   var url = 'http://10.0.2.2:8000/gpt/chat/stream/$msg';
  //   StreamTransformer<Uint8List, List<int>> unit8Transformer =
  //       StreamTransformer.fromHandlers(
  //     handleData: (data, sink) {
  //       sink.add(List<int>.from(data));
  //     },
  //   );
  //   Response<ResponseBody> rs = await Dio().post<ResponseBody>(
  //     url,
  //     options: Options(headers: {
  //       "Accept": "text/event-stream",
  //       "Cache-Control": "no-cache",
  //     }, responseType: ResponseType.stream), // set responseType to `stream`
  //   );

  //   rs.data?.stream
  //       .transform(unit8Transformer)
  //       .transform(const Utf8Decoder())
  //       .transform(const LineSplitter())
  //       .listen((data) {
  //     logger.d("streamData:$data");
  //     responseMessage = "$responseMessage$data\n";
  //     _responseStreamController.sink.add(responseMessage);
  //   }).onDone(() {
  //     _responseStreamController.close();
  //   });
  // }

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
                  groupHeaderBuilder: (MessageModel message) => SizedBox(
                    height: 40,
                    child: Center(
                        child: Card(
                      color: Colors.red,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          DateFormat.yMMM().format(message.dateTime),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )),
                  ),
                  itemBuilder: (context, MessageModel message) => Align(
                    alignment: message.isSentByMe
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Card(
                      color: message.isSentByMe
                          ? Colors.blueAccent
                          : Colors.blueGrey,
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
                                    animatedTexts: [
                                      TyperAnimatedText(message.text,
                                          speed:
                                              const Duration(milliseconds: 30),
                                          textStyle: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0,
                                          )),
                                    ],
                                    onFinished: () {
                                      chatPageController
                                          .messages.last.newMassage = false;
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
              },
            ),
          );
        }
        //db값이 없을때 표시데는 글자
        return const Text("no Data");
      },
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
                        width: 3, color: ChatPageStyle.chatInputBorderColor),
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
                  await chatPageController.getGptApi(msg);
                  // fetchStreamedResponse();
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

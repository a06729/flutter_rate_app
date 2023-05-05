import 'package:drift/drift.dart' as drift;
import 'package:exchange_rate_app/controller/chat_page_controller.dart';
import 'package:exchange_rate_app/controller/theam_controller.dart';
import 'package:exchange_rate_app/db/app_db.dart';
import 'package:exchange_rate_app/widgets/model/message_model.dart';
import 'package:flutter/material.dart';
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
  // late AppDb _db;
  @override
  void initState() {
    // TODO: implement initState
    textFieldController = TextEditingController();
    theamController = TheamController();
    chatPageController =
        Provider.of<ChatPageController>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    textFieldController.dispose();
    super.dispose();
  }

  //유저 메세지 sqllite에 저장
  void saveUserMassage(String massage) {
    final ChatMessageCompanion entity;
    entity = ChatMessageCompanion(
      message: drift.Value(massage),
      myMessage: const drift.Value(true),
      messageDateTime: drift.Value(DateTime.now()),
    );
    Provider.of<AppDb>(context, listen: false).saveMessage(entity);
  }

  void saveGptMassage(String massage) {
    final ChatMessageCompanion gptEntity;

    gptEntity = ChatMessageCompanion(
      message: drift.Value(massage),
      myMessage: const drift.Value(false),
      messageDateTime: drift.Value(DateTime.now()),
    );

    Provider.of<AppDb>(context, listen: false).saveMessage(gptEntity);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
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
                messageBox(),
                const SizedBox(
                  height: 15,
                )
              ]),
            ),
          );
        },
      ),
    );
  }

  FutureBuilder<List<ChatMessageData>> chatArea(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<AppDb>(context).getChatMessage(),
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
                      elevation: 8,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: message.isSentByMe
                            ? Text(message.text)
                            : message.newMassage
                                ? AnimatedTextKit(
                                    animatedTexts: [
                                      TyperAnimatedText(message.text),
                                    ],
                                    onFinished: () {
                                      setState(() {
                                        chatPageController
                                            .messages.last.newMassage = false;
                                      });
                                    },
                                    totalRepeatCount: 1,
                                  )
                                : Text(message.text),
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
          child: SizedBox(
            height: 50,
            child: const LoadingIndicator(
              indicatorType: Indicator.ballPulseSync,
              colors: [Colors.white],
              pathBackgroundColor: Colors.transparent,
              backgroundColor: Colors.transparent,
            ),
          ),
          visible: value.gptLoding,
        );
      },
    );
  }

  Padding messageBox() {
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              controller: textFieldController,
              textInputAction: TextInputAction.newline,
              maxLines: null,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(12),
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
          IconButton(
            onPressed: () async {
              final String msg = textFieldController.text;
              // final ChatMessageCompanion entity;
              // final ChatMessageCompanion gptEntity;

              if (textFieldController.text != "") {
                textFieldController.text = "";
                saveUserMassage(msg);
                // entity = ChatMessageCompanion(
                //   message: drift.Value(msg),
                //   myMssage: const drift.Value(true),
                //   messageDateTime: drift.Value(DateTime.now()),
                // );
                // Provider.of<AppDb>(context, listen: false).saveMessage(entity);

                String gptMsg = await chatPageController.getGptApi(msg);

                saveGptMassage(gptMsg);

                // gptEntity = ChatMessageCompanion(
                //   message: drift.Value(gptMsg),
                //   myMssage: const drift.Value(false),
                //   messageDateTime: drift.Value(DateTime.now()),
                // );

                // Provider.of<AppDb>(context, listen: false)
                //     .saveMessage(gptEntity);
              }
            },
            icon: const Icon(Icons.send),
            iconSize: 30,
          )
        ],
      ),
    );
  }
}

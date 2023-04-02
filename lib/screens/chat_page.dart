import 'package:exchange_rate_app/controller/chat_page_controller.dart';
import 'package:exchange_rate_app/controller/theam_controller.dart';
import 'package:exchange_rate_app/widgets/model/message_model.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:provider/provider.dart';
import 'package:exchange_rate_app/styles/chat_page_style.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final TextEditingController textFieldController;
  // late final GptApi gptApi;
  // List<MessageModel> messages = [];
  late MessageModel message;
  late ChatPageController chatPageController;
  late TheamController theamController;
  @override
  void initState() {
    // TODO: implement initState
    textFieldController = TextEditingController();
    theamController = TheamController();
    chatPageController =
        Provider.of<ChatPageController>(context, listen: false);
    // gptApi = GptApi();
    super.initState();
  }

  @override
  void dispose() {
    textFieldController.dispose();
    super.dispose();
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
                Expanded(
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
                                              chatPageController.messages.last
                                                  .newMassage = false;
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
                ),
                Padding(
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
                                    width: 3,
                                    color: ChatPageStyle.chatInputBorderColor),
                                borderRadius: BorderRadius.circular(10)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(width: 3, color: Colors.red),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          final String msg = textFieldController.text;
                          // final dynamic respMsg;
                          if (textFieldController.text != "") {
                            textFieldController.text = "";
                            await chatPageController.getGptApi(msg);
                          }
                        },
                        icon: const Icon(Icons.send),
                        iconSize: 30,
                      )
                    ],
                  ),
                ),
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
}

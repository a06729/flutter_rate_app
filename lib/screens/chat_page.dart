import 'package:exchange_rate_app/widgets/model/message_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final TextEditingController textFieldController;
  List<MessageModel> messages = [
    MessageModel(
      text: 'Yes sure!',
      dateTime: DateTime.now().subtract(Duration(minutes: 1)),
      isSentByMe: false,
    ),
    MessageModel(
      text: 'Yes sure!',
      dateTime: DateTime.now().subtract(Duration(minutes: 1)),
      isSentByMe: false,
    ),
    MessageModel(
      text: 'Yes sure!',
      dateTime: DateTime.now().subtract(Duration(minutes: 1)),
      isSentByMe: false,
    ),
    MessageModel(
      text: 'Yes sure!',
      dateTime: DateTime.now().subtract(Duration(minutes: 1)),
      isSentByMe: false,
    ),
  ].reversed.toList();

  @override
  void initState() {
    // TODO: implement initState
    textFieldController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(),
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Column(mainAxisSize: MainAxisSize.max, children: [
            Expanded(
              child: GroupedListView<MessageModel, DateTime>(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                reverse: true,
                order: GroupedListOrder.DESC,
                padding: const EdgeInsets.all(8),
                elements: messages,
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
                      child: Text(message.text),
                    ),
                  ),
                ),
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
                            borderSide:
                                const BorderSide(width: 3, color: Colors.red),
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide:
                              const BorderSide(width: 3, color: Colors.red),
                        ),
                      ),
                      onSubmitted: (text) {
                        final message = MessageModel(
                          text: text,
                          dateTime: DateTime.now(),
                          isSentByMe: true,
                        );
                        setState(() {
                          messages.add(message);
                        });
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (textFieldController.text != "") {
                        final message = MessageModel(
                          text: textFieldController.text,
                          dateTime: DateTime.now(),
                          isSentByMe: true,
                        );
                        setState(() {
                          messages.add(message);
                          textFieldController.text = "";
                        });
                      }
                    },
                    icon: const Icon(Icons.send),
                    iconSize: 30,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 15,
            )
          ]),
        ),
      ),
    );
  }
}

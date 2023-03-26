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
  Widget build(BuildContext context) {
    return Scaffold(
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
          Container(
            color: Colors.grey.shade300,
            child: TextField(
              autofocus: true,
              decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(12), hintText: '텍스트 입력'),
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
          )
        ]),
      ),
    );
  }
}

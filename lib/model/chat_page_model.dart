import 'package:exchange_rate_app/services/gpt_api.dart';
import 'package:exchange_rate_app/widgets/model/message_model.dart';
import 'package:logger/logger.dart';

class ChatPageModel {
  var logger = Logger(
    printer: PrettyPrinter(),
  );

  dynamic _gptMessage = '';
  final List<MessageModel> _messages = [];

  get gptMessage => _gptMessage;
  get messages => _messages;

  Future<void> getGptApi(String message) async {
    _gptMessage = await GptApi()?.getChatApi(message: message);

    if (_gptMessage != null) {
      MessageModel messageModel = MessageModel(
          text: '$_gptMessage',
          dateTime: DateTime.now(),
          isSentByMe: false,
          newMassage: true);
      _messages.add(messageModel);
    } else {
      MessageModel messageModel = MessageModel(
          text: '통신실패',
          dateTime: DateTime.now(),
          isSentByMe: false,
          newMassage: true);
      _messages.add(messageModel);
    }
  }
}

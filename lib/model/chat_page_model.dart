import 'package:exchange_rate_app/services/gpt_api.dart';
import 'package:exchange_rate_app/widgets/model/message_model.dart';
import 'package:logger/logger.dart';

class ChatPageModel {
  var logger = Logger(
    printer: PrettyPrinter(),
  );

  dynamic _gptMessage = '';
  final List<MessageModel> _messages = [];
  bool _gptLoding = false;

  get gptMessage => _gptMessage;
  get messages => _messages;
  bool get gptLoding => _gptLoding;

  set gptLoding(bool loding) => _gptLoding = loding;

  Future<String> getGptApi(String message) async {
    _gptMessage = await GptApi()?.getChatApi(message: message);

    if (_gptMessage != null) {
      MessageModel messageModel = MessageModel(
          text: '${_gptMessage['content']}',
          dateTime: DateTime.now(),
          isSentByMe: false,
          newMassage: true);

      _messages.add(messageModel);

      return _gptMessage['content'];
    } else {
      MessageModel messageModel = MessageModel(
          text: '통신실패',
          dateTime: DateTime.now(),
          isSentByMe: false,
          newMassage: true);
      _messages.add(messageModel);
      return '통신실패';
    }
  }
}

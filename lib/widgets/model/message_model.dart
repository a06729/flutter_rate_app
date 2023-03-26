class MessageModel {
  final String text;
  final DateTime dateTime;
  final bool isSentByMe;

  const MessageModel({
    required this.text,
    required this.dateTime,
    required this.isSentByMe,
  });
}

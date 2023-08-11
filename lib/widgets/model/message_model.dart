class MessageModel {
  String text;
  final DateTime dateTime;
  final bool isSentByMe;
  bool newMassage;

  MessageModel({
    required this.text,
    required this.dateTime,
    required this.isSentByMe,
    //옵션파라미터 하는법
    this.newMassage = false,
  });
}

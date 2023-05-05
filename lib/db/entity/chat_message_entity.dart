import 'package:drift/drift.dart';

class ChatMessage extends Table {
  IntColumn get id => integer().autoIncrement()();
  //메세지 저장 컬럼
  TextColumn get message => text()();
  //내가 보낸 메세지인지 상대가 보낸 메세지인지 확인
  BoolColumn get myMessage => boolean()();
  //메세지 저장된 시간 컬럼
  DateTimeColumn get messageDateTime => dateTime().named('date_time')();
}

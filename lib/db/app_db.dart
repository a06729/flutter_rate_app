import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:exchange_rate_app/db/entity/chat_message_entity.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
part 'app_db.g.dart';

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'chatMessage.splite'));

    return NativeDatabase(file);
  });
}

@DriftDatabase(tables: [ChatMessage])
class AppDb extends _$AppDb {
  AppDb() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<ChatMessageData>> getChatMessage(int pageNum) async {
    // final countResult = await select(chatMessage).get();

    //한 화면에 10개 항목을 보여주겠다.
    final pageSize = 10; // 페이지당 항목 수

    final offset = (pageNum - 1) * pageSize;

    // print(countResult.length);
    List<ChatMessageData> db_messages = await (select(chatMessage)
          ..orderBy([
            (t) => OrderingTerm(
                expression: t.messageDateTime, mode: OrderingMode.desc)
          ])
          ..limit(pageSize, offset: offset))
        .get();

    //db에서 가져온값을 순서를 반전시킨다.
    //반전 시키는 이유는 chat_page의 GroupedListView에서 한번더 반전시키기 때문에
    db_messages = List.from(db_messages.reversed);
    return db_messages;
  }

  Future<int> saveMessage(ChatMessageCompanion entity) async {
    return await into(chatMessage).insert(entity);
  }
}

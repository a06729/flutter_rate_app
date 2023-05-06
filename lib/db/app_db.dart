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

  Future<List<ChatMessageData>> getChatMessage() async {
    // List<ChatMessageData>? getMessage = await select(chatMessage).get();
    return await select(chatMessage).get();
  }

  Future<int> saveMessage(ChatMessageCompanion entity) async {
    return await into(chatMessage).insert(entity);
  }
}

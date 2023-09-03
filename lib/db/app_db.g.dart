// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_db.dart';

// ignore_for_file: type=lint
class $ChatMessageTable extends ChatMessage
    with TableInfo<$ChatMessageTable, ChatMessageData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChatMessageTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _messageMeta =
      const VerificationMeta('message');
  @override
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
      'message', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _myMessageMeta =
      const VerificationMeta('myMessage');
  @override
  late final GeneratedColumn<bool> myMessage = GeneratedColumn<bool>(
      'my_message', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("my_message" IN (0, 1))'));
  static const VerificationMeta _messageDateTimeMeta =
      const VerificationMeta('messageDateTime');
  @override
  late final GeneratedColumn<DateTime> messageDateTime =
      GeneratedColumn<DateTime>('date_time', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, message, myMessage, messageDateTime];
  @override
  String get aliasedName => _alias ?? 'chat_message';
  @override
  String get actualTableName => 'chat_message';
  @override
  VerificationContext validateIntegrity(Insertable<ChatMessageData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('message')) {
      context.handle(_messageMeta,
          message.isAcceptableOrUnknown(data['message']!, _messageMeta));
    } else if (isInserting) {
      context.missing(_messageMeta);
    }
    if (data.containsKey('my_message')) {
      context.handle(_myMessageMeta,
          myMessage.isAcceptableOrUnknown(data['my_message']!, _myMessageMeta));
    } else if (isInserting) {
      context.missing(_myMessageMeta);
    }
    if (data.containsKey('date_time')) {
      context.handle(
          _messageDateTimeMeta,
          messageDateTime.isAcceptableOrUnknown(
              data['date_time']!, _messageDateTimeMeta));
    } else if (isInserting) {
      context.missing(_messageDateTimeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChatMessageData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChatMessageData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      message: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}message'])!,
      myMessage: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}my_message'])!,
      messageDateTime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date_time'])!,
    );
  }

  @override
  $ChatMessageTable createAlias(String alias) {
    return $ChatMessageTable(attachedDatabase, alias);
  }
}

class ChatMessageData extends DataClass implements Insertable<ChatMessageData> {
  final int id;
  final String message;
  final bool myMessage;
  final DateTime messageDateTime;
  const ChatMessageData(
      {required this.id,
      required this.message,
      required this.myMessage,
      required this.messageDateTime});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['message'] = Variable<String>(message);
    map['my_message'] = Variable<bool>(myMessage);
    map['date_time'] = Variable<DateTime>(messageDateTime);
    return map;
  }

  ChatMessageCompanion toCompanion(bool nullToAbsent) {
    return ChatMessageCompanion(
      id: Value(id),
      message: Value(message),
      myMessage: Value(myMessage),
      messageDateTime: Value(messageDateTime),
    );
  }

  factory ChatMessageData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChatMessageData(
      id: serializer.fromJson<int>(json['id']),
      message: serializer.fromJson<String>(json['message']),
      myMessage: serializer.fromJson<bool>(json['myMessage']),
      messageDateTime: serializer.fromJson<DateTime>(json['messageDateTime']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'message': serializer.toJson<String>(message),
      'myMessage': serializer.toJson<bool>(myMessage),
      'messageDateTime': serializer.toJson<DateTime>(messageDateTime),
    };
  }

  ChatMessageData copyWith(
          {int? id,
          String? message,
          bool? myMessage,
          DateTime? messageDateTime}) =>
      ChatMessageData(
        id: id ?? this.id,
        message: message ?? this.message,
        myMessage: myMessage ?? this.myMessage,
        messageDateTime: messageDateTime ?? this.messageDateTime,
      );
  @override
  String toString() {
    return (StringBuffer('ChatMessageData(')
          ..write('id: $id, ')
          ..write('message: $message, ')
          ..write('myMessage: $myMessage, ')
          ..write('messageDateTime: $messageDateTime')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, message, myMessage, messageDateTime);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChatMessageData &&
          other.id == this.id &&
          other.message == this.message &&
          other.myMessage == this.myMessage &&
          other.messageDateTime == this.messageDateTime);
}

class ChatMessageCompanion extends UpdateCompanion<ChatMessageData> {
  final Value<int> id;
  final Value<String> message;
  final Value<bool> myMessage;
  final Value<DateTime> messageDateTime;
  const ChatMessageCompanion({
    this.id = const Value.absent(),
    this.message = const Value.absent(),
    this.myMessage = const Value.absent(),
    this.messageDateTime = const Value.absent(),
  });
  ChatMessageCompanion.insert({
    this.id = const Value.absent(),
    required String message,
    required bool myMessage,
    required DateTime messageDateTime,
  })  : message = Value(message),
        myMessage = Value(myMessage),
        messageDateTime = Value(messageDateTime);
  static Insertable<ChatMessageData> custom({
    Expression<int>? id,
    Expression<String>? message,
    Expression<bool>? myMessage,
    Expression<DateTime>? messageDateTime,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (message != null) 'message': message,
      if (myMessage != null) 'my_message': myMessage,
      if (messageDateTime != null) 'date_time': messageDateTime,
    });
  }

  ChatMessageCompanion copyWith(
      {Value<int>? id,
      Value<String>? message,
      Value<bool>? myMessage,
      Value<DateTime>? messageDateTime}) {
    return ChatMessageCompanion(
      id: id ?? this.id,
      message: message ?? this.message,
      myMessage: myMessage ?? this.myMessage,
      messageDateTime: messageDateTime ?? this.messageDateTime,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (myMessage.present) {
      map['my_message'] = Variable<bool>(myMessage.value);
    }
    if (messageDateTime.present) {
      map['date_time'] = Variable<DateTime>(messageDateTime.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChatMessageCompanion(')
          ..write('id: $id, ')
          ..write('message: $message, ')
          ..write('myMessage: $myMessage, ')
          ..write('messageDateTime: $messageDateTime')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDb extends GeneratedDatabase {
  _$AppDb(QueryExecutor e) : super(e);
  late final $ChatMessageTable chatMessage = $ChatMessageTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [chatMessage];
}

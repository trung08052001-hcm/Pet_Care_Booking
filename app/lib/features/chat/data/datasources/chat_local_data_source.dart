import 'package:app/core/local/hive_box_names.dart';
import 'package:app/core/local/hive_local_store.dart';
import 'package:app/features/chat/domain/entities/chat_attachment.dart';
import 'package:app/features/chat/domain/entities/chat_message.dart';
import 'package:app/features/chat/domain/entities/chat_message_sender.dart';

class ChatLocalDataSource {
  const ChatLocalDataSource(this._store);

  static const _conversationKey = 'chat_conversation';
  static const _messagesKey = 'chat_messages';
  static const _queueType = 'chat_message';

  final HiveLocalStore _store;

  Future<void> saveConversationId(String conversationId) {
    return _store.putMap(
      boxName: HiveBoxNames.appCache,
      key: _conversationKey,
      value: {'conversationId': conversationId},
    );
  }

  String? getCachedConversationId() {
    return _store.getMap(
      boxName: HiveBoxNames.appCache,
      key: _conversationKey,
    )?['conversationId'] as String?;
  }

  Future<void> saveMessages(List<ChatMessage> messages) {
    return _store.putMap(
      boxName: HiveBoxNames.appCache,
      key: _messagesKey,
      value: {
        'items': messages.map(_messageToJson).toList(),
        'updatedAt': DateTime.now().toIso8601String(),
      },
    );
  }

  List<ChatMessage> getCachedMessages() {
    final cache = _store.getMap(
      boxName: HiveBoxNames.appCache,
      key: _messagesKey,
    );
    final items = cache?['items'];
    if (items is! List) {
      return const [];
    }

    return items
        .whereType<Map<dynamic, dynamic>>()
        .map((item) => _messageFromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<void> upsertCachedMessage(ChatMessage message) async {
    final messages = [
      ...getCachedMessages().where((item) => item.id != message.id),
      message,
    ]..sort((a, b) => a.sentAt.compareTo(b.sentAt));

    await saveMessages(messages);
  }

  Future<void> replaceCachedMessage({
    required String localId,
    required ChatMessage remoteMessage,
  }) async {
    final messages = [
      ...getCachedMessages().where((item) => item.id != localId),
      remoteMessage,
    ]..sort((a, b) => a.sentAt.compareTo(b.sentAt));

    await saveMessages(messages);
  }

  Future<void> savePendingMessage(ChatMessage message) async {
    await _store.putMap(
      boxName: HiveBoxNames.syncQueue,
      key: message.id,
      value: {
        'type': _queueType,
        'message': _messageToJson(message),
        'createdAt': DateTime.now().toIso8601String(),
      },
    );
    await upsertCachedMessage(message);
  }

  List<ChatMessage> getPendingMessages() {
    return _store
        .values(HiveBoxNames.syncQueue)
        .where((item) => item['type'] == _queueType)
        .map((item) => item['message'])
        .whereType<Map<dynamic, dynamic>>()
        .map((item) => _messageFromJson(Map<String, dynamic>.from(item)))
        .toList()
      ..sort((a, b) => a.sentAt.compareTo(b.sentAt));
  }

  Future<void> deletePendingMessage(String localId) {
    return _store.delete(boxName: HiveBoxNames.syncQueue, key: localId);
  }

  Map<String, dynamic> _messageToJson(ChatMessage message) => {
        'id': message.id,
        'sender': message.sender.name,
        'text': message.text,
        'sentAt': message.sentAt.toIso8601String(),
        'attachments':
            message.attachments.map((attachment) => attachment.toJson()).toList(),
        'imageAttachmentTitle': message.imageAttachmentTitle,
        'isRead': message.isRead,
        'deliveryStatus': message.deliveryStatus.name,
      };

  ChatMessage _messageFromJson(Map<String, dynamic> json) {
    final senderName = json['sender']?.toString();
    final statusName = json['deliveryStatus']?.toString();
    final attachments = json['attachments'];

    return ChatMessage(
      id: (json['id'] ?? '').toString(),
      sender: senderName == ChatMessageSender.agent.name
          ? ChatMessageSender.agent
          : ChatMessageSender.user,
      text: (json['text'] ?? '').toString(),
      sentAt: DateTime.tryParse((json['sentAt'] ?? '').toString()) ??
          DateTime.now(),
      attachments: attachments is List
          ? attachments
              .whereType<Map<dynamic, dynamic>>()
              .map((item) => ChatAttachment.fromJson(
                    Map<String, dynamic>.from(item),
                  ))
              .toList()
          : const [],
      imageAttachmentTitle: json['imageAttachmentTitle']?.toString(),
      isRead: json['isRead'] == true,
      deliveryStatus: ChatMessageDeliveryStatus.values.firstWhere(
        (status) => status.name == statusName,
        orElse: () => ChatMessageDeliveryStatus.sent,
      ),
    );
  }
}

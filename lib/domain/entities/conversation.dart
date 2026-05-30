import 'contact.dart';

class Conversation {
  final String id;
  final Contact? otherUser;
  final String? lastMessageText;
  final DateTime? lastMessageTime;
  final int unreadCount;

  const Conversation({
    required this.id,
    this.otherUser,
    this.lastMessageText,
    this.lastMessageTime,
    this.unreadCount = 0,
  });
}

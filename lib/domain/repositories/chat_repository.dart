import '../entities/contact.dart';
import '../entities/conversation.dart';
import '../entities/message.dart';

abstract class ChatRepository {
  Future<List<Contact>> getUsers();
  Future<List<Conversation>> getConversations();
  Future<({String conversationId, Contact otherUser})> startConversation(String participantId);
  Future<List<Message>> getMessages(String conversationId);
  Future<Message> sendMessage(String conversationId, String text);
  Future<void> markAsRead(String conversationId);
  Future<void> sendTyping(String conversationId, {required bool isTyping});
}

import '../../domain/entities/contact.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_datasource.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource _remote;
  ChatRepositoryImpl(this._remote);

  @override
  Future<List<Contact>> getUsers() => _remote.getUsers();

  @override
  Future<List<Conversation>> getConversations() => _remote.getConversations();

  @override
  Future<({String conversationId, Contact otherUser})> startConversation(
          String participantId) =>
      _remote.startConversation(participantId);

  @override
  Future<List<Message>> getMessages(String conversationId) =>
      _remote.getMessages(conversationId);

  @override
  Future<Message> sendMessage(String conversationId, String text) =>
      _remote.sendMessage(conversationId, text);

  @override
  Future<void> markAsRead(String conversationId) =>
      _remote.markAsRead(conversationId);

  @override
  Future<void> sendTyping(String conversationId, {required bool isTyping}) =>
      _remote.sendTyping(conversationId, isTyping: isTyping);
}

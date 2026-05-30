import '../domain/entities/contact.dart';
import '../domain/entities/conversation.dart';

sealed class ChatState {
  const ChatState();
}

class ChatInitial extends ChatState {
  const ChatInitial();
}

class ChatLoading extends ChatState {
  const ChatLoading();
}

class ChatLoaded extends ChatState {
  final List<Conversation> conversations;
  final List<Contact> contacts;

  const ChatLoaded({required this.conversations, required this.contacts});
}

class ChatError extends ChatState {
  final String message;
  const ChatError(this.message);
}

class ChatConversationReady extends ChatState {
  final String conversationId;
  final String otherUserName;
  final String otherUserId;

  const ChatConversationReady({
    required this.conversationId,
    required this.otherUserName,
    required this.otherUserId,
  });
}

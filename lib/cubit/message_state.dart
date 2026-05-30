import '../domain/entities/message.dart';

sealed class MessageState {
  const MessageState();
}

class MessageInitial extends MessageState {
  const MessageInitial();
}

class MessageLoading extends MessageState {
  const MessageLoading();
}

class MessageLoaded extends MessageState {
  final List<Message> messages;
  final String myUserId;

  const MessageLoaded({required this.messages, required this.myUserId});
}

class MessageError extends MessageState {
  final String message;
  const MessageError(this.message);
}

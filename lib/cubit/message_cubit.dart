import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/entities/message.dart';
import '../domain/repositories/chat_repository.dart';
import '../services/pusher_service.dart';
import 'message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  final ChatRepository _repo;
  final PusherService _socket;
  final String myUserId;
  final String conversationId;
  List<Message> _messages = [];
  StreamSubscription<Map<String, dynamic>>? _sub;
  StreamSubscription<void>? _reconnectSub;

  MessageCubit({
    required ChatRepository repo,
    required PusherService socket,
    required this.myUserId,
    required this.conversationId,
  })  : _repo = repo,
        _socket = socket,
        super(const MessageInitial()) {
    _sub = _socket.newMessages.listen(_handleIncoming);
    _reconnectSub = _socket.reconnects.listen((_) => loadMessages());
  }

  void _handleIncoming(Map<String, dynamic> data) {
    final incomingConvId = data['conversationId']?.toString() ?? '';
    final senderId = data['senderId']?.toString() ?? '';
    if (incomingConvId != conversationId) return;
    if (senderId == myUserId) return;
    final msg = Message(
      id: data['id']?.toString() ?? '',
      senderId: senderId,
      text: data['text'] as String? ?? '',
      createdAt: DateTime.tryParse(data['createdAt']?.toString() ?? '') ?? DateTime.now(),
    );
    _messages = [..._messages, msg];
    if (!isClosed) emit(MessageLoaded(messages: _messages, myUserId: myUserId));
  }

  Future<void> loadMessages() async {
    if (isClosed) return;
    if (state is MessageInitial) emit(const MessageLoading());
    try {
      _messages = await _repo.getMessages(conversationId);
      if (isClosed) return;
      emit(MessageLoaded(messages: _messages, myUserId: myUserId));
    } catch (e) {
      if (isClosed) return;
      if (state is! MessageLoaded) {
        emit(MessageError(e.toString().replaceFirst('Exception: ', '')));
      }
    }
  }

  Future<void> sendMessage(String text) async {
    if (isClosed) return;
    try {
      final msg = await _repo.sendMessage(conversationId, text);
      _messages = [..._messages, msg];
      if (!isClosed) emit(MessageLoaded(messages: _messages, myUserId: myUserId));
    } catch (_) {}
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    await _reconnectSub?.cancel();
    return super.close();
  }
}

import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/entities/contact.dart';
import '../domain/entities/conversation.dart';
import '../domain/repositories/chat_repository.dart';
import '../services/notification_service.dart';
import '../services/pusher_service.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository _repo;
  final PusherService _pusher;
  final NotificationService _notification;
  StreamSubscription<Map<String, dynamic>>? _sub;
  List<Conversation> _conversations = [];
  List<Contact> _contacts = [];

  ChatCubit(this._repo, this._pusher, this._notification) : super(const ChatInitial()) {
    _sub = _pusher.newMessages.listen(_onNewMessage);
  }

  void _onNewMessage(Map<String, dynamic> data) {
    final senderName = data['senderName']?.toString() ?? 'Tin nhắn mới';
    final text = data['text']?.toString() ?? '';
    _notification.showMessage(senderName, text);
    _refreshConversations();
  }

  Future<void> load() async {
    emit(const ChatLoading());
    try {
      final results = await Future.wait([
        _repo.getConversations(),
        _repo.getUsers(),
      ]);
      if (isClosed) return;
      _conversations = results[0] as List<Conversation>;
      _contacts = results[1] as List<Contact>;
      emit(ChatLoaded(conversations: _conversations, contacts: _contacts));
    } catch (e) {
      if (isClosed) return;
      emit(ChatError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  Future<void> startConversation(String participantId) async {
    try {
      final (:conversationId, :otherUser) = await _repo.startConversation(participantId);
      emit(ChatConversationReady(
        conversationId: conversationId,
        otherUserName: otherUser.name,
        otherUserId: otherUser.id,
      ));
    } catch (e) {
      emit(ChatError(e.toString().replaceFirst('Exception: ', '')));
    }
  }

  void resetToLoaded() {
    emit(ChatLoaded(conversations: _conversations, contacts: _contacts));
  }

  Future<void> _refreshConversations() async {
    if (isClosed) return;
    try {
      final conversations = await _repo.getConversations();
      if (isClosed) return;
      _conversations = conversations;
      if (state is ChatLoaded) {
        emit(ChatLoaded(conversations: _conversations, contacts: _contacts));
      }
    } catch (_) {}
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}

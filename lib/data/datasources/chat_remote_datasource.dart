import 'package:dio/dio.dart';
import '../../core/error/app_exception.dart';
import '../../domain/entities/contact.dart';
import '../../domain/entities/conversation.dart';
import '../../domain/entities/message.dart';
import '../datasources/auth_local_datasource.dart';
import '../remote/chat_api.dart';

abstract class ChatRemoteDataSource {
  Future<List<Contact>> getUsers();
  Future<List<Conversation>> getConversations();
  Future<({String conversationId, Contact otherUser})> startConversation(String participantId);
  Future<List<Message>> getMessages(String conversationId);
  Future<Message> sendMessage(String conversationId, String text);
  Future<void> markAsRead(String conversationId);
  Future<void> sendTyping(String conversationId, {required bool isTyping});
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final ChatApi _api;
  final AuthLocalDataSource _localAuth;
  final Dio _dio;

  ChatRemoteDataSourceImpl(this._api, this._localAuth, this._dio);

  Future<String> _authHeader() async {
    final session = await _localAuth.getSession();
    if (session == null) throw AppException('Chưa đăng nhập');
    return 'Bearer ${session.$2}';
  }

  @override
  Future<List<Contact>> getUsers() async {
    try {
      final auth = await _authHeader();
      final dtos = await _api.getUsers(auth);
      return dtos.map((d) => Contact(id: d.id, name: d.name, email: d.email)).toList();
    } on DioException catch (e) {
      throw AppException(_extractMessage(e));
    }
  }

  @override
  Future<List<Conversation>> getConversations() async {
    try {
      final auth = await _authHeader();
      final dtos = await _api.getConversations(auth);
      return dtos.map((d) => Conversation(
            id: d.id,
            otherUser: d.otherUser != null
                ? Contact(id: d.otherUser!.id, name: d.otherUser!.name, email: d.otherUser!.email)
                : null,
            lastMessageText: d.lastMessage?.text,
            lastMessageTime: d.lastMessage?.createdAt,
            unreadCount: d.unreadCount,
          )).toList();
    } on DioException catch (e) {
      throw AppException(_extractMessage(e));
    }
  }

  @override
  Future<({String conversationId, Contact otherUser})> startConversation(
      String participantId) async {
    try {
      final auth = await _authHeader();
      final dto = await _api.startConversation(auth, {'participantId': participantId});
      return (
        conversationId: dto.id,
        otherUser: Contact(id: dto.otherUser.id, name: dto.otherUser.name, email: dto.otherUser.email),
      );
    } on DioException catch (e) {
      throw AppException(_extractMessage(e));
    }
  }

  @override
  Future<List<Message>> getMessages(String conversationId) async {
    try {
      final auth = await _authHeader();
      final dtos = await _api.getMessages(auth, conversationId);
      return dtos.map((d) => Message(id: d.id, senderId: d.senderId, text: d.text, createdAt: d.createdAt)).toList();
    } on DioException catch (e) {
      throw AppException(_extractMessage(e));
    }
  }

  @override
  Future<Message> sendMessage(String conversationId, String text) async {
    try {
      final auth = await _authHeader();
      final dto = await _api.sendMessage(auth, conversationId, {'text': text});
      return Message(id: dto.id, senderId: dto.senderId, text: dto.text, createdAt: dto.createdAt);
    } on DioException catch (e) {
      throw AppException(_extractMessage(e));
    }
  }

  @override
  Future<void> markAsRead(String conversationId) async {
    try {
      final auth = await _authHeader();
      await _dio.put(
        '/chat/conversations/$conversationId/read',
        options: Options(headers: {'Authorization': auth}),
      );
    } catch (_) {}
  }

  @override
  Future<void> sendTyping(String conversationId, {required bool isTyping}) async {
    try {
      final auth = await _authHeader();
      await _dio.post(
        '/chat/typing',
        data: {'conversationId': conversationId, 'isTyping': isTyping},
        options: Options(headers: {'Authorization': auth}),
      );
    } catch (_) {}
  }

  String _extractMessage(DioException e) {
    final data = e.response?.data;
    if (data is Map<String, dynamic> && data['error'] != null) {
      return data['error'] as String;
    }
    return 'Không kết nối được server.';
  }
}

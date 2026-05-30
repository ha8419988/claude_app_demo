import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'dto/chat_dto.dart';

part 'chat_api.g.dart';

@RestApi()
abstract class ChatApi {
  factory ChatApi(Dio dio, {String baseUrl}) = _ChatApi;

  @GET('/chat/users')
  Future<List<ContactDto>> getUsers(
    @Header('Authorization') String authorization,
  );

  @GET('/chat/conversations')
  Future<List<ConversationDto>> getConversations(
    @Header('Authorization') String authorization,
  );

  @POST('/chat/conversations')
  Future<ConversationCreatedDto> startConversation(
    @Header('Authorization') String authorization,
    @Body() Map<String, dynamic> body,
  );

  @GET('/chat/conversations/{id}/messages')
  Future<List<MessageDto>> getMessages(
    @Header('Authorization') String authorization,
    @Path('id') String conversationId,
  );

  @POST('/chat/conversations/{id}/messages')
  Future<MessageDto> sendMessage(
    @Header('Authorization') String authorization,
    @Path('id') String conversationId,
    @Body() Map<String, dynamic> body,
  );
}

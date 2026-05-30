class ContactDto {
  final String id;
  final String name;
  final String email;

  const ContactDto({required this.id, required this.name, required this.email});

  factory ContactDto.fromJson(Map<String, dynamic> json) => ContactDto(
        id: json['id'].toString(),
        name: json['name'] as String,
        email: json['email'] as String,
      );
}

class LastMessageDto {
  final String text;
  final DateTime createdAt;

  const LastMessageDto({required this.text, required this.createdAt});

  factory LastMessageDto.fromJson(Map<String, dynamic> json) => LastMessageDto(
        text: json['text'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

class ConversationDto {
  final String id;
  final ContactDto? otherUser;
  final LastMessageDto? lastMessage;
  final int unreadCount;

  const ConversationDto({
    required this.id,
    this.otherUser,
    this.lastMessage,
    this.unreadCount = 0,
  });

  factory ConversationDto.fromJson(Map<String, dynamic> json) => ConversationDto(
        id: json['id'].toString(),
        otherUser: json['otherUser'] != null
            ? ContactDto.fromJson(json['otherUser'] as Map<String, dynamic>)
            : null,
        lastMessage: json['lastMessage'] != null
            ? LastMessageDto.fromJson(json['lastMessage'] as Map<String, dynamic>)
            : null,
        unreadCount: json['unreadCount'] as int? ?? 0,
      );
}

class MessageDto {
  final String id;
  final String senderId;
  final String text;
  final DateTime createdAt;

  const MessageDto({
    required this.id,
    required this.senderId,
    required this.text,
    required this.createdAt,
  });

  factory MessageDto.fromJson(Map<String, dynamic> json) => MessageDto(
        id: json['id'].toString(),
        senderId: json['senderId'].toString(),
        text: json['text'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}

class ConversationCreatedDto {
  final String id;
  final ContactDto otherUser;

  const ConversationCreatedDto({required this.id, required this.otherUser});

  factory ConversationCreatedDto.fromJson(Map<String, dynamic> json) =>
      ConversationCreatedDto(
        id: json['id'].toString(),
        otherUser: ContactDto.fromJson(json['otherUser'] as Map<String, dynamic>),
      );
}

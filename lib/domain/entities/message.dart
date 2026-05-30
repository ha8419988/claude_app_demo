class Message {
  final String id;
  final String senderId;
  final String text;
  final DateTime createdAt;

  const Message({
    required this.id,
    required this.senderId,
    required this.text,
    required this.createdAt,
  });
}

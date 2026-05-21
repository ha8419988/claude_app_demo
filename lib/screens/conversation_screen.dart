import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ConversationScreen extends StatefulWidget {
  final String name;
  final String initial;
  final int avatarColor;

  const ConversationScreen({
    super.key,
    required this.name,
    required this.initial,
    required this.avatarColor,
  });

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final _inputController = TextEditingController();
  final _scrollController = ScrollController();

  static const _messages = [
    {
      'text': 'Xin chào! Chúng tôi xác nhận đặt phòng của bạn ngày 18 tháng 5.',
      'isMe': false,
      'time': '10:15 SA',
    },
    {
      'text': 'Phòng 204, nhận phòng lúc 2:00 CH. Chúc bạn có chuyến đi vui vẻ!',
      'isMe': false,
      'time': '10:15 SA',
    },
    {
      'text': 'Cảm ơn! Tôi có thể nhận phòng sớm hơn không?',
      'isMe': true,
      'time': '10:16 SA',
    },
    {
      'text': 'Chúng tôi sẽ cố gắng sắp xếp. Vui lòng thông báo giờ đến dự kiến.',
      'isMe': false,
      'time': '10:18 SA',
    },
    {
      'text': 'Tôi sẽ đến khoảng 11 giờ sáng.',
      'isMe': true,
      'time': '10:20 SA',
    },
  ];

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildInputBar(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.text),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Color(widget.avatarColor),
            child: Text(
              widget.initial,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.name,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
              const Text(
                'Online',
                style: TextStyle(fontSize: 11, color: AppColors.primaryGreen),
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert, color: AppColors.text),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: _messages.length,
      itemBuilder: (_, i) => _MessageBubble(data: _messages[i]),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.borderGrey)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: AppColors.textGrey),
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              controller: _inputController,
              style: const TextStyle(fontSize: 14, color: AppColors.text),
              decoration: InputDecoration(
                hintText: 'Nhập tin nhắn...',
                hintStyle: const TextStyle(fontSize: 14, color: AppColors.textGrey),
                filled: true,
                fillColor: AppColors.backgroundGrey,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          IconButton(
            icon: const Icon(Icons.send, color: AppColors.primary),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final Map<String, Object> data;

  const _MessageBubble({required this.data});

  @override
  Widget build(BuildContext context) {
    final isMe = data['isMe'] as bool;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (isMe) ...[
            Text(
              data['time'] as String,
              style: const TextStyle(fontSize: 11, color: AppColors.textLightGrey),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.done_all, size: 14, color: AppColors.primary),
            const SizedBox(width: 6),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isMe ? AppColors.primary : AppColors.backgroundGrey,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isMe ? 16 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 16),
                ),
              ),
              child: Text(
                data['text'] as String,
                style: TextStyle(
                  fontSize: 14,
                  color: isMe ? Colors.white : AppColors.text,
                  height: 1.4,
                ),
              ),
            ),
          ),
          if (!isMe) ...[
            const SizedBox(width: 6),
            Text(
              data['time'] as String,
              style: const TextStyle(fontSize: 11, color: AppColors.textLightGrey),
            ),
          ],
        ],
      ),
    );
  }
}

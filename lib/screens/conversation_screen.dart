import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/di/injection_container.dart';
import '../cubit/message_cubit.dart';
import '../cubit/message_state.dart';
import '../domain/repositories/chat_repository.dart';
import '../services/pusher_service.dart';
import '../theme/app_colors.dart';

class ConversationScreen extends StatefulWidget {
  final String conversationId;
  final String otherUserName;
  final String otherUserId;
  final String myUserId;
  final String token;

  const ConversationScreen({
    super.key,
    required this.conversationId,
    required this.otherUserName,
    required this.otherUserId,
    required this.myUserId,
    required this.token,
  });

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final _inputController = TextEditingController();
  final _scrollController = ScrollController();
  late final MessageCubit _cubit;
  StreamSubscription<Map<String, dynamic>>? _statusSub;
  StreamSubscription<Map<String, dynamic>>? _typingSub;
  bool _isOnline = false;
  DateTime? _lastSeen;
  bool _partnerTyping = false;
  Timer? _typingDebounce;
  Timer? _typingClearTimer;

  @override
  void initState() {
    super.initState();
    final pusher = sl<PusherService>();
    pusher.connect(widget.myUserId);
    _cubit = MessageCubit(
      repo: sl<ChatRepository>(),
      socket: pusher,
      myUserId: widget.myUserId,
      conversationId: widget.conversationId,
    );
    _cubit.loadMessages();
    _loadInitialStatus();
    sl<ChatRepository>().markAsRead(widget.conversationId);

    _statusSub = pusher.statusUpdates.listen((data) {
      if (data['userId']?.toString() != widget.otherUserId) return;
      if (!mounted) return;
      setState(() {
        _isOnline = data['isOnline'] as bool? ?? false;
        final raw = data['lastSeen']?.toString();
        _lastSeen = raw != null ? DateTime.tryParse(raw) : null;
      });
    });

    _typingSub = pusher.typingUpdates.listen((data) {
      if (data['conversationId']?.toString() != widget.conversationId) return;
      if (data['senderId']?.toString() != widget.otherUserId) return;
      if (!mounted) return;
      setState(() => _partnerTyping = data['isTyping'] as bool? ?? false);
      _typingClearTimer?.cancel();
      if (_partnerTyping) {
        _typingClearTimer = Timer(const Duration(seconds: 4), () {
          if (mounted) setState(() => _partnerTyping = false);
        });
      }
    });
  }

  Future<void> _loadInitialStatus() async {
    try {
      final dio = sl<Dio>();
      final res = await dio.get(
        '/chat/status/${widget.otherUserId}',
        options: Options(headers: {'Authorization': 'Bearer ${widget.token}'}),
      );
      if (!mounted) return;
      setState(() {
        _isOnline = res.data['isOnline'] as bool? ?? false;
        final raw = res.data['lastSeen']?.toString();
        _lastSeen = raw != null ? DateTime.tryParse(raw) : null;
      });
    } catch (_) {}
  }

  String get _statusText {
    if (_isOnline) return 'Online';
    if (_lastSeen == null) return 'Offline';
    final diff = DateTime.now().difference(_lastSeen!);
    if (diff.inMinutes < 1) return 'Vừa offline';
    if (diff.inMinutes < 60) return 'Hoạt động ${diff.inMinutes} phút trước';
    if (diff.inHours < 24) return 'Hoạt động ${diff.inHours} giờ trước';
    return 'Hoạt động ${diff.inDays} ngày trước';
  }

  void _sendTyping(String value) {
    _typingDebounce?.cancel();
    sl<ChatRepository>().sendTyping(widget.conversationId, isTyping: true);
    _typingDebounce = Timer(const Duration(seconds: 2), () {
      sl<ChatRepository>().sendTyping(widget.conversationId, isTyping: false);
    });
  }

  @override
  void dispose() {
    _statusSub?.cancel();
    _typingSub?.cancel();
    _typingClearTimer?.cancel();
    _typingDebounce?.cancel();
    _inputController.dispose();
    _scrollController.dispose();
    _cubit.close();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;
    _inputController.clear();
    await _cubit.sendMessage(text);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _buildAppBar(),
        body: Column(
          children: [
            Expanded(child: _buildMessageList()),
            _buildInputBar(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final initial = widget.otherUserName.isNotEmpty
        ? widget.otherUserName[0].toUpperCase()
        : '?';
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
            backgroundColor: AppColors.primary,
            child: Text(
              initial,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.otherUserName,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.text),
              ),
              Text(
                _statusText,
                style: TextStyle(
                  fontSize: 11,
                  color: _isOnline ? AppColors.primaryGreen : AppColors.textGrey,
                ),
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
    return BlocConsumer<MessageCubit, MessageState>(
      listener: (_, state) {
        if (state is MessageLoaded) _scrollToBottom();
      },
      builder: (_, state) {
        if (state is MessageLoading) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }
        if (state is MessageError) {
          return Center(
            child: Text(state.message, style: const TextStyle(color: AppColors.textGrey)),
          );
        }
        if (state is MessageLoaded) {
          if (state.messages.isEmpty) {
            return const Center(
              child: Text('Hãy bắt đầu cuộc trò chuyện!',
                  style: TextStyle(color: AppColors.textGrey, fontSize: 14)),
            );
          }
          return ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: state.messages.length,
            itemBuilder: (_, i) {
              final msg = state.messages[i];
              final isMe = msg.senderId == state.myUserId;
              return _MessageBubble(text: msg.text, isMe: isMe, time: _formatTime(msg.createdAt));
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildInputBar() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_partnerTyping)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 6, 0, 0),
            child: Text(
              '${widget.otherUserName} đang gõ...',
              style: const TextStyle(fontSize: 12, color: AppColors.textGrey, fontStyle: FontStyle.italic),
            ),
          ),
        Container(
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
                  textInputAction: TextInputAction.send,
                  onChanged: _sendTyping,
                  onSubmitted: (_) => _sendMessage(),
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
                onPressed: _sendMessage,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatTime(DateTime dt) {
    final h = dt.toLocal().hour.toString().padLeft(2, '0');
    final m = dt.toLocal().minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}

class _MessageBubble extends StatelessWidget {
  final String text;
  final bool isMe;
  final String time;

  const _MessageBubble({required this.text, required this.isMe, required this.time});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (isMe) ...[
            Text(time, style: const TextStyle(fontSize: 11, color: AppColors.textLightGrey)),
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
                text,
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
            Text(time, style: const TextStyle(fontSize: 11, color: AppColors.textLightGrey)),
          ],
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/di/injection_container.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../cubit/chat_cubit.dart';
import '../cubit/chat_state.dart';
import '../services/pusher_service.dart';
import '../domain/entities/contact.dart';
import '../domain/entities/conversation.dart';
import '../theme/app_colors.dart';
import 'conversation_screen.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) {
        final authState = ctx.read<AuthCubit>().state;
        final myUserId = authState is AuthAuthenticated ? authState.user.id : '';
        sl<PusherService>().connect(myUserId);
        return sl<ChatCubit>()..load();
      },
      child: const _ChatBody(),
    );
  }
}

class _ChatBody extends StatefulWidget {
  const _ChatBody();

  @override
  State<_ChatBody> createState() => _ChatBodyState();
}

class _ChatBodyState extends State<_ChatBody>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late TabController _tabController;
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() => _tabIndex = _tabController.index);
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<ChatCubit>().load();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tabController.dispose();
    super.dispose();
  }

  String _myUserId(BuildContext context) {
    final state = context.read<AuthCubit>().state;
    return state is AuthAuthenticated ? state.user.id : '';
  }

  String _myToken(BuildContext context) {
    final state = context.read<AuthCubit>().state;
    return state is AuthAuthenticated ? state.token : '';
  }

  void _openConversation(BuildContext context, String conversationId,
      String otherUserName, String otherUserId) {
    final chatCubit = context.read<ChatCubit>();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ConversationScreen(
          conversationId: conversationId,
          otherUserName: otherUserName,
          otherUserId: otherUserId,
          myUserId: _myUserId(context),
          token: _myToken(context),
        ),
      ),
    ).then((_) => chatCubit.load());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatCubit, ChatState>(
      listener: (context, state) {
        if (state is ChatConversationReady) {
          _openConversation(context, state.conversationId, state.otherUserName, state.otherUserId);
          context.read<ChatCubit>().resetToLoaded();
        } else if (state is ChatError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              _buildTabSwitcher(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _MessagesTab(onOpen: _openConversation),
                    const _ContactsTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabSwitcher() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Row(
        children: [
          _TabChip(
            label: 'Tin nhắn',
            active: _tabIndex == 0,
            onTap: () => _tabController.animateTo(0),
          ),
          const SizedBox(width: 8),
          _TabChip(
            label: 'Tìm bạn',
            active: _tabIndex == 1,
            onTap: () => _tabController.animateTo(1),
          ),
        ],
      ),
    );
  }
}

// ── Tab: Tin nhắn ───────────────────────────────────────────
class _MessagesTab extends StatelessWidget {
  final void Function(BuildContext, String, String, String) onOpen;
  const _MessagesTab({required this.onOpen});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        if (state is ChatLoading || state is ChatInitial) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }
        if (state is ChatError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(state.message, style: const TextStyle(color: AppColors.textGrey)),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => context.read<ChatCubit>().load(),
                  child: const Text('Thử lại'),
                ),
              ],
            ),
          );
        }
        final conversations = state is ChatLoaded ? state.conversations : <Conversation>[];
        if (conversations.isEmpty) {
          return const Center(
            child: Text('Chưa có cuộc trò chuyện nào',
                style: TextStyle(color: AppColors.textGrey, fontSize: 14)),
          );
        }
        return Stack(
          children: [
            RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () => context.read<ChatCubit>().load(),
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 4),
                itemCount: conversations.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, color: AppColors.borderGrey, indent: 72),
                itemBuilder: (_, i) {
                  final conv = conversations[i];
                  return _ConversationItem(
                    name: conv.otherUser?.name ?? 'Unknown',
                    preview: conv.lastMessageText ?? 'Bắt đầu cuộc trò chuyện...',
                    time: conv.lastMessageTime != null ? _relativeTime(conv.lastMessageTime!) : '',
                    unreadCount: conv.unreadCount,
                    onTap: () => onOpen(context, conv.id, conv.otherUser?.name ?? 'Unknown', conv.otherUser?.id ?? ''),
                  );
                },
              ),
            ),
            Positioned(
              right: 20,
              bottom: 20,
              child: FloatingActionButton(
                onPressed: () {},
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                child: const Icon(Icons.edit_square),
              ),
            ),
          ],
        );
      },
    );
  }

  String _relativeTime(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Vừa xong';
    if (diff.inMinutes < 60) return '${diff.inMinutes} phút';
    if (diff.inHours < 24) return '${diff.inHours} giờ';
    if (diff.inDays == 1) return 'Hôm qua';
    return '${diff.inDays} ngày';
  }
}

// ── Tab: Tìm bạn ────────────────────────────────────────────
class _ContactsTab extends StatelessWidget {
  const _ContactsTab();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        if (state is ChatLoading || state is ChatInitial) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }
        final contacts = state is ChatLoaded ? state.contacts : <Contact>[];
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                style: const TextStyle(fontSize: 14, color: AppColors.text),
                decoration: InputDecoration(
                  hintText: 'Tìm người dùng...',
                  hintStyle: const TextStyle(fontSize: 14, color: AppColors.textGrey),
                  prefixIcon: const Icon(Icons.search, color: AppColors.textGrey, size: 20),
                  filled: true,
                  fillColor: AppColors.backgroundGrey,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Người dùng (${contacts.length})',
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.text),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: contacts.isEmpty
                  ? const Center(
                      child: Text('Không có người dùng nào',
                          style: TextStyle(color: AppColors.textGrey)))
                  : RefreshIndicator(
                      color: AppColors.primary,
                      onRefresh: () => context.read<ChatCubit>().load(),
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: contacts.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (_, i) => _ContactCard(
                          contact: contacts[i],
                          onTap: () =>
                              context.read<ChatCubit>().startConversation(contacts[i].id),
                        ),
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }
}

// ── Shared widgets ───────────────────────────────────────────
class _TabChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _TabChip({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: active ? AppColors.primary : AppColors.borderGrey),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: active ? Colors.white : AppColors.textGrey,
          ),
        ),
      ),
    );
  }
}

class _ConversationItem extends StatelessWidget {
  final String name;
  final String preview;
  final String time;
  final int unreadCount;
  final VoidCallback onTap;

  const _ConversationItem({
    required this.name,
    required this.preview,
    required this.time,
    required this.unreadCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 26,
              backgroundColor: AppColors.primary,
              child: Text(initial,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(name,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.text)),
                      Text(time,
                          style: const TextStyle(fontSize: 12, color: AppColors.textLightGrey)),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(preview,
                      style: const TextStyle(fontSize: 13, color: AppColors.textGrey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            if (unreadCount > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  unreadCount > 99 ? '99+' : '$unreadCount',
                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  final Contact contact;
  final VoidCallback onTap;

  const _ContactCard({required this.contact, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final initial = contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '?';
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.borderGrey),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.primary.withValues(alpha: 0.12),
              child: Text(initial,
                  style: const TextStyle(
                      color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 18)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(contact.name,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.text)),
                  const SizedBox(height: 2),
                  Text(contact.email,
                      style: const TextStyle(fontSize: 12, color: AppColors.textGrey)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('Nhắn tin',
                  style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }
}

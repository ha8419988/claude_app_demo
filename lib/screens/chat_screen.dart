import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'conversation_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() => _tabIndex = _tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildTabSwitcher(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  _MessagesTab(),
                  _FindCompanionTab(),
                ],
              ),
            ),
          ],
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

class _TabChip extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _TabChip({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: active ? AppColors.primary : AppColors.borderGrey,
          ),
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

class _FindCompanionTab extends StatelessWidget {
  const _FindCompanionTab();

  static const _companions = [
    {
      'name': 'Sophie L.',
      'country': 'FR',
      'countryColor': 0xFF1565C0,
      'destination': 'Đà Nẵng',
      'dates': '15–20/06',
      'interests': 'Biển · Ẩm thực',
      'avatar': 'https://picsum.photos/seed/sophie/200/200',
    },
    {
      'name': 'James K.',
      'country': 'GB',
      'countryColor': 0xFF1565C0,
      'destination': 'Hội An',
      'dates': '18–25/06',
      'interests': 'Văn hoá · Local Food',
      'avatar': 'https://picsum.photos/seed/james/200/200',
    },
    {
      'name': 'Amara O.',
      'country': 'NG',
      'countryColor': 0xFF2D5A27,
      'destination': 'Phú Quốc',
      'dates': '20–28/06',
      'interests': 'Sang chảnh · Lặn biển',
      'avatar': 'https://picsum.photos/seed/amara/200/200',
    },
    {
      'name': 'Carlos M.',
      'country': 'BR',
      'countryColor': 0xFF2D5A27,
      'destination': 'Hà Nội',
      'dates': '22–30/06',
      'interests': 'Nhiếp ảnh · Bơi lội',
      'avatar': 'https://picsum.photos/seed/carlos/200/200',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextField(
            style: const TextStyle(fontSize: 14, color: AppColors.text),
            decoration: InputDecoration(
              hintText: 'Tìm bạn đồng hành...',
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
              'Gợi ý quanh bạn',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.text,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _companions.length + 1,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) {
              if (i == _companions.length) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Đang tìm thêm bạn đồng hành phù hợp...',
                        style: TextStyle(fontSize: 13, color: AppColors.textGrey),
                      ),
                    ],
                  ),
                );
              }
              return _CompanionCard(data: _companions[i]);
            },
          ),
        ),
      ],
    );
  }
}

class _CompanionCard extends StatelessWidget {
  final Map<String, Object> data;

  const _CompanionCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundImage: NetworkImage(data['avatar'] as String),
            backgroundColor: AppColors.cardPlaceholder,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      data['name'] as String,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Color(data['countryColor'] as int),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        data['country'] as String,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textGrey),
                    const SizedBox(width: 4),
                    Text(
                      '${data['destination']}  ·  ${data['dates']}',
                      style: const TextStyle(fontSize: 12, color: AppColors.textGrey),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.chat_bubble_outline, size: 14, color: AppColors.textGrey),
                    const SizedBox(width: 4),
                    Text(
                      data['interests'] as String,
                      style: const TextStyle(fontSize: 12, color: AppColors.textGrey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MessagesTab extends StatelessWidget {
  const _MessagesTab();

  static const _conversations = [
    {
      'name': 'TEG Hotel',
      'preview': 'Phòng của bạn đã sẵn sàng check-in...',
      'time': '2 phút',
      'initial': 'T',
      'avatarColor': 0xFF1565C0,
      'unread': true,
    },
    {
      'name': 'Nautilus Maldives',
      'preview': 'Chuyến đi của bạn đã được xác nhận!',
      'time': '1 giờ',
      'initial': 'N',
      'avatarColor': 0xFF00838F,
      'unread': true,
    },
    {
      'name': 'Erin-Ijesha Lodge',
      'preview': 'Cảm ơn bạn đã lưu trú, hãy để lại...',
      'time': 'Hôm qua',
      'initial': 'E',
      'avatarColor': 0xFF6A1B9A,
      'unread': false,
    },
    {
      'name': 'TravelSafe Support',
      'preview': 'Chúng tôi luôn sẵn sàng hỗ trợ bạn',
      'time': '3 ngày',
      'initial': 'S',
      'avatarColor': 0xFFE65100,
      'unread': false,
    },
    {
      'name': 'James K.',
      'preview': 'Bạn đã sẵn sàng cho chuyến đi chưa?',
      'time': '5 ngày',
      'initial': 'J',
      'avatarColor': 0xFF2D5A27,
      'unread': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 4),
          itemCount: _conversations.length,
          separatorBuilder: (_, __) => const Divider(
            height: 1,
            color: AppColors.borderGrey,
            indent: 72,
          ),
          itemBuilder: (_, i) => _ConversationItem(
            data: _conversations[i],
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ConversationScreen(
                  name: _conversations[i]['name'] as String,
                  initial: _conversations[i]['initial'] as String,
                  avatarColor: _conversations[i]['avatarColor'] as int,
                ),
              ),
            ),
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
  }
}

class _ConversationItem extends StatelessWidget {
  final Map<String, Object> data;
  final VoidCallback? onTap;

  const _ConversationItem({required this.data, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: Color(data['avatarColor'] as int),
            child: Text(
              data['initial'] as String,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      data['name'] as String,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.text,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          data['time'] as String,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textLightGrey,
                          ),
                        ),
                        if (data['unread'] as bool) ...[
                          const SizedBox(width: 6),
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  data['preview'] as String,
                  style: const TextStyle(fontSize: 13, color: AppColors.textGrey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }
}

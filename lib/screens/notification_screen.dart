import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class NotificationItem {
  final String message;
  final String time;
  final bool isRead;

  const NotificationItem({
    required this.message,
    required this.time,
    this.isRead = false,
  });
}

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  static const _items = [
    NotificationItem(
      message: 'お相手からメッセージが届きました！',
      time: '3時間前',
      isRead: false,
    ),
    NotificationItem(
      message: '明日のデート相手と時間が確定しました！',
      time: '10時間前',
      isRead: false,
    ),
    NotificationItem(
      message: 'デートまであと3日',
      time: '3日前',
      isRead: false,
    ),
    NotificationItem(
      message: 'プロフィールを入力してください',
      time: '2025/05/30',
      isRead: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _NotificationAppBar(),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: _items.length,
              itemBuilder: (context, index) =>
                  _NotificationListItem(item: _items[index]),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        bottom: 8,
        left: 15,
        right: 15,
      ),
      height: 40 + MediaQuery.of(context).padding.top,
      child: Row(
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: const SizedBox(
              width: 24,
              height: 24,
              child: Icon(
                Icons.keyboard_arrow_left,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          // Title centered
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'お知らせ',
                  style: GoogleFonts.notoSansJp(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.help_outline, color: Colors.white, size: 18),
              ],
            ),
          ),
          // Spacer to balance back button
          const SizedBox(width: 24),
        ],
      ),
    );
  }
}

class _NotificationListItem extends StatelessWidget {
  final NotificationItem item;

  const _NotificationListItem({required this.item});

  @override
  Widget build(BuildContext context) {
    final bool isUnread = !item.isRead;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        color: isUnread
            ? const Color(0xFFF2F2F2).withValues(alpha: 0.2)
            : Colors.white,
        border: const Border(
          bottom: BorderSide(color: AppColors.borderGrey),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              color: AppColors.borderGrey,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              'Logo',
              style: GoogleFonts.notoSansJp(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isUnread
                    ? AppColors.text.withValues(alpha: 0.2)
                    : AppColors.text,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.message,
                  style: GoogleFonts.notoSansJp(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isUnread
                        ? AppColors.text.withValues(alpha: 0.6)
                        : AppColors.text,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  item.time,
                  style: GoogleFonts.notoSansJp(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textLightGrey,
                    letterSpacing: -1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

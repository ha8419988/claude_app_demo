import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.greyBorder)),
      ),
      padding: const EdgeInsets.fromLTRB(15, 16, 15, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(onTap: () => onTap(0), child: _NavItem(icon: Icons.event, label: '予約', isActive: currentIndex == 0)),
          GestureDetector(onTap: () => onTap(1), child: _NavItem(icon: Icons.favorite_border, label: 'デート', hasBadge: true, isActive: currentIndex == 1)),
          GestureDetector(onTap: () => onTap(2), child: _NavItem(icon: Icons.article, label: 'レポート', isActive: currentIndex == 2)),
          GestureDetector(onTap: () => onTap(3), child: _NavItem(icon: Icons.notifications_none, label: 'お知らせ', hasBadge: true, isActive: currentIndex == 3)),
          GestureDetector(onTap: () => onTap(4), child: _NavItem(icon: Icons.person, label: 'マイページ', isActive: currentIndex == 4)),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final bool hasBadge;

  const _NavItem({
    required this.icon,
    required this.label,
    this.isActive = false,
    this.hasBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.gold : AppColors.text;
    return SizedBox(
      width: 55,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(icon, color: color, size: 28),
              if (hasBadge)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 8.17,
                    height: 8.17,
                    decoration: BoxDecoration(
                      color: AppColors.red,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.notoSansJp(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w400,
              height: 1.18, // 13px / 11px ≈ 1.18 — khớp Figma 13px text height
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class MyPageBody extends StatelessWidget {
  const MyPageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 32),
          const _AvatarSection(),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _StatsTabBar(),
                SizedBox(height: 24),
                _MenuList(),
              ],
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ─── Avatar Section ───────────────────────────────────────────────────────────

class _AvatarSection extends StatelessWidget {
  const _AvatarSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Avatar(),
        const SizedBox(height: 16),
        _NameRow(),
        const SizedBox(height: 8),
        _EditProfileLink(),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox(
        width: 70,
        height: 70,
        child: Stack(
          children: [
            CachedNetworkImage(
              imageUrl:
                  'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?w=140&h=140&fit=crop&crop=top',
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(color: const Color(0xFFD9D9D9)),
              errorWidget: (_, __, ___) =>
                  Container(color: const Color(0xFFD9D9D9)),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 20,
                color: AppColors.goldBadgeBg,
                alignment: Alignment.center,
                child: Text(
                  '高評価',
                  style: GoogleFonts.notoSansJp(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NameRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.workspace_premium,
            color: AppColors.primary, size: 24),
        const SizedBox(width: 8),
        Text(
          '23歳 その他',
          style: GoogleFonts.notoSansJp(
            color: AppColors.text,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 8),
        _HelpCircleGold(),
      ],
    );
  }
}

class _HelpCircleGold extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Color(0x1A000000), blurRadius: 2),
        ],
      ),
      child: const Icon(Icons.help, size: 13, color: AppColors.gold),
    );
  }
}

class _EditProfileLink extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'プロフィールを編集',
          style: GoogleFonts.notoSansJp(
            color: AppColors.text,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 2),
        const Icon(Icons.keyboard_arrow_right,
            color: AppColors.text, size: 24),
      ],
    );
  }
}

// ─── Stats Tab Bar ────────────────────────────────────────────────────────────

class _StatsTabBar extends StatelessWidget {
  const _StatsTabBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: _StatsTab(icon: Icons.star_border, label: '4.8', showAdd: true),
        ),
        SizedBox(width: 8),
        Expanded(
          child: _StatsTab(icon: Icons.alarm, label: '休憩中', showAdd: true),
        ),
        SizedBox(width: 8),
        Expanded(
          child: _StatsTab(
              icon: Icons.confirmation_number, label: '0枚', showAdd: true),
        ),
      ],
    );
  }
}

class _StatsTab extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool showAdd;

  const _StatsTab({
    required this.icon,
    required this.label,
    this.showAdd = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      color: AppColors.primary,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.notoSansJp(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (showAdd)
            const Icon(Icons.add_circle_outline,
                color: Colors.white, size: 18),
        ],
      ),
    );
  }
}

// ─── Menu List ────────────────────────────────────────────────────────────────

class _MenuList extends StatelessWidget {
  const _MenuList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _MenuItem(icon: Icons.article, label: '希望条件変更'),
        _MenuItem(icon: Icons.redeem, label: '友達招待'),
        _MenuItem(icon: Icons.help_outline, label: 'ヘルプ'),
        _MenuItem(icon: Icons.settings, label: 'アカウント'),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MenuItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.greyBorder),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.gold, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.notoSansJp(
                color: AppColors.gold,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Icon(Icons.keyboard_arrow_right,
              color: AppColors.greyArrow, size: 32),
        ],
      ),
    );
  }
}

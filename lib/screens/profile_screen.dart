import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/routes/app_routes.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../widgets/base_dialog.dart';
import '../theme/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const _avatarUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuBM_BIDIDRz96tgpTBWgEMMS0-5dLQ33R2wE2vgv2MqLueM1xozDgQOz030YuE-cFCGMBYRXH_oIAXoACZrfhw8slh87nSL7CC6VlqMUmo9XqLAakfbSOzsMK_ZQLwoQ79ibS3i39I3Y6OQlBbKSDKS0-_5zD8Om8Dz5Y7Et2vE_Jfxqnbkem9Uf9OyaRpLXntkLntJx1BFkRwWW-tQORskxeNHKz8-HjK35ims7rIlC7qD8vrxdvJWogY1P9s1ctl2-R_oVTi-5aIz';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 32),
        child: Column(
          children: [
            _buildProfileHeader(context),
            const SizedBox(height: 16),
            _buildMenuSection(context),
            const SizedBox(height: 16),
            _buildLogoutButton(context),
            const SizedBox(height: 16),
            const Text(
              'Vietnam Travel v2.4.0',
              style: TextStyle(fontSize: 11, color: AppColors.textLightGrey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 52, 20, 20),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 44,
                backgroundColor: AppColors.cardPlaceholder,
                child: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: _avatarUrl,
                    width: 88,
                    height: 88,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => Container(color: AppColors.cardPlaceholder),
                    errorWidget: (_, __, ___) => const Icon(Icons.person, size: 44, color: Colors.white),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(Icons.edit, size: 13, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Builder(builder: (context) {
            final state = context.watch<AuthCubit>().state;
            final name = state is AuthAuthenticated ? state.user.name : 'SheftyDesign';
            final email = state is AuthAuthenticated ? state.user.email : 'abisolasherif23@gmail.com';
            return Column(
              children: [
                Text(
                  name,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.text),
                ),
                const SizedBox(height: 3),
                Text(email, style: const TextStyle(fontSize: 13, color: AppColors.textGrey)),
              ],
            );
          }),
          const SizedBox(height: 20),
          _buildStats(),
        ],
      ),
    );
  }

  Widget _buildStats() {
    final stats = [
      {'value': '18', 'label': 'Chuyến đi'},
      {'value': '12', 'label': 'Quốc gia'},
      {'value': '4.9', 'label': 'Đánh giá'},
      {'value': '32', 'label': 'Bình luận'},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.backgroundGrey,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: List.generate(stats.length * 2 - 1, (i) {
          if (i.isOdd) {
            return Container(width: 1, height: 32, color: AppColors.borderGrey);
          }
          final s = stats[i ~/ 2];
          return Expanded(
            child: Column(
              children: [
                Text(
                  s['value']!,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.text),
                ),
                const SizedBox(height: 2),
                Text(
                  s['label']!,
                  style: const TextStyle(fontSize: 11, color: AppColors.textGrey),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Column(
        children: [
          _MenuItem(
            icon: Icons.receipt_long_outlined,
            iconBg: AppColors.blueLight,
            iconColor: AppColors.blue,
            title: 'Đơn đặt chỗ của tôi',
            badge: '3 chuyến sắp tới',
            badgeColor: AppColors.blue,
            badgeBg: AppColors.blueLight,
          ),
          _divider(),
          _MenuItem(
            icon: Icons.star_outline,
            iconBg: AppColors.yellowLight,
            iconColor: AppColors.yellow,
            title: 'Đánh giá của tôi',
            info: '12 bình luận đã viết',
          ),
          _divider(),
          _MenuItem(
            icon: Icons.credit_card_outlined,
            iconBg: AppColors.backgroundGreen,
            iconColor: AppColors.primaryGreen,
            title: 'Thanh toán',
            info: 'Visa ****4214',
          ),
          _divider(),
          _MenuItem(
            icon: Icons.notifications_outlined,
            iconBg: AppColors.orangeLight,
            iconColor: AppColors.orange,
            title: 'Thông báo',
            badge: '3 tin mới',
            badgeColor: Colors.white,
            badgeBg: AppColors.primary,
          ),
          _divider(),
          _MenuItem(
            icon: Icons.language_outlined,
            iconBg: AppColors.blueLight,
            iconColor: AppColors.blue,
            title: 'Ngôn ngữ',
            info: 'Tiếng Việt',
          ),
          _divider(),
          _MenuItem(
            icon: Icons.settings_outlined,
            iconBg: AppColors.backgroundGrey,
            iconColor: AppColors.textGrey,
            title: 'Cài đặt',
          ),
        ],
      ),
    );
  }

  Widget _divider() => const Divider(height: 1, indent: 60, color: AppColors.borderGrey);

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: OutlinedButton.icon(
          onPressed: () async {
            final confirmed = await showLogoutDialog(context);
            if (confirmed == true && context.mounted) {
              await context.read<AuthCubit>().logout();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (_) => false);
              }
            }
          },
          icon: const Icon(Icons.logout, color: AppColors.error, size: 18),
          label: const Text(
            'Đăng xuất',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.error),
          ),
          style: OutlinedButton.styleFrom(
            backgroundColor: const Color(0xFFFFF5F5),
            side: const BorderSide(color: Color(0xFFFFCDD2)),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String? info;
  final String? badge;
  final Color? badgeColor;
  final Color? badgeBg;

  const _MenuItem({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    this.info,
    this.badge,
    this.badgeColor,
    this.badgeBg,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.text),
              ),
            ),
            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: badgeBg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(badge!, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: badgeColor)),
              )
            else if (info != null)
              Text(info!, style: const TextStyle(fontSize: 13, color: AppColors.textGrey)),
            const SizedBox(width: 6),
            const Icon(Icons.arrow_forward_ios, size: 13, color: AppColors.textLightGrey),
          ],
        ),
      ),
    );
  }
}

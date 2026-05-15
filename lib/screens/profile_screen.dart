import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _notificationsEnabled = true;

  static const _green = Color(0xFF2D5A27);
  static const _textDark = Color(0xFF1A1A1A);
  static const _textGrey = Color(0xFF757575);
  static const _textLightGrey = Color(0xFF9E9E9E);
  static const _orange = Color(0xFFF2994A);
  static const _red = Color(0xFFE53935);

  static const _avatarUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuBM_BIDIDRz96tgpTBWgEMMS0-5dLQ33R2wE2vgv2MqLueM1xozDgQOz030YuE-cFCGMBYRXH_oIAXoACZrfhw8slh87nSL7CC6VlqMUmo9XqLAakfbSOzsMK_ZQLwoQ79ibS3i39I3Y6OQlBbKSDKS0-_5zD8Om8Dz5Y7Et2vE_Jfxqnbkem9Uf9OyaRpLXntkLntJx1BFkRwWW-tQORskxeNHKz8-HjK35ims7rIlC7qD8vrxdvJWogY1P9s1ctl2-R_oVTi-5aIz';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 32),
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 16),
            _buildMenuSection(),
            const SizedBox(height: 8),
            _buildLogoutButton(),
            const SizedBox(height: 20),
            _buildVersionText(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: const Color(0xFFCCDDD0),
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: _avatarUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                placeholder: (_, __) =>
                    Container(color: const Color(0xFFCCDDD0)),
                errorWidget: (_, __, ___) => const Icon(
                  Icons.person,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Builder(
            builder: (context) {
              final state = context.watch<AuthCubit>().state;
              final name = state is AuthAuthenticated ? state.user.name : '';
              final email = state is AuthAuthenticated ? state.user.email : '';
              return Column(
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: const TextStyle(fontSize: 13, color: _textGrey),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildBadge('Nhà thám hiểm',
                  bg: const Color(0xFFEAF2EA), color: _green),
              const SizedBox(width: 8),
              _buildBadge('12 Chuyến đi',
                  bg: const Color(0xFFF5F5F5), color: _textGrey),
            ],
          ),
          const SizedBox(height: 14),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: _green),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              minimumSize: const Size(0, 36),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'Chỉnh sửa',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: _green,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String label, {required Color bg, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: color),
      ),
    );
  }

  Widget _buildMenuSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildItineraryCard(),
          const SizedBox(height: 12),
          _buildReviewCard(),
          const SizedBox(height: 12),
          _buildNotificationCard(),
          const SizedBox(height: 12),
          _buildLanguageCard(),
        ],
      ),
    );
  }

  Widget _buildItineraryCard() {
    return _MenuCard(
      iconWidget: _IconBox(
        icon: Icons.calendar_today_outlined,
        bg: const Color(0xFFEAF2EA),
        color: _green,
      ),
      title: 'Lịch trình của tôi',
      description:
          'Xem lại các điểm đến đã lên kế hoạch và các chuyến đi đã hoàn thành.',
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF2EA),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              '3 hành trình sắp tới',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: _green),
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward_ios,
              size: 14, color: _textLightGrey),
        ],
      ),
    );
  }

  Widget _buildReviewCard() {
    return _MenuCard(
      iconWidget: _IconBox(
        icon: Icons.star_outline,
        bg: const Color(0xFFFFF8E1),
        color: _orange,
      ),
      title: 'Đánh giá',
      description: 'Chia sẻ trải nghiệm của bạn về các điểm đến.',
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          5,
          (_) => const Icon(Icons.star_outline,
              size: 16, color: Color(0xFFFFC107)),
        ),
      ),
    );
  }

  Widget _buildNotificationCard() {
    return _MenuCard(
      iconWidget: _IconBox(
        icon: Icons.notifications_outlined,
        bg: const Color(0xFFFFF3E0),
        color: _orange,
      ),
      title: 'Cài đặt thông báo',
      description: 'Ưu đãi, nhắc nhở lịch trình & tin tức du lịch.',
      trailing: Switch(
        value: _notificationsEnabled,
        activeColor: _green,
        onChanged: (v) => setState(() => _notificationsEnabled = v),
      ),
    );
  }

  Widget _buildLanguageCard() {
    return _MenuCard(
      iconWidget: _IconBox(
        icon: Icons.language_outlined,
        bg: const Color(0xFFE3F2FD),
        color: const Color(0xFF1565C0),
      ),
      title: 'Ngôn ngữ',
      description: 'Tiếng Việt',
      trailing: const Icon(Icons.arrow_forward_ios,
          size: 14, color: _textLightGrey),
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: OutlinedButton.icon(
          onPressed: () async {
                await context.read<AuthCubit>().logout();
                if (mounted) {
                  Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
                }
              },
          icon: const Icon(Icons.logout, color: _red, size: 18),
          label: const Text(
            'Đăng xuất',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: _red,
            ),
          ),
          style: OutlinedButton.styleFrom(
            backgroundColor: const Color(0xFFFFF5F5),
            side: const BorderSide(color: Color(0xFFFFCDD2)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVersionText() {
    return const Text(
      'Vietnam Explore v2.4.0',
      style: TextStyle(fontSize: 11, color: _textLightGrey),
      textAlign: TextAlign.center,
    );
  }
}

class _MenuCard extends StatelessWidget {
  final Widget iconWidget;
  final String title;
  final String description;
  final Widget trailing;

  const _MenuCard({
    required this.iconWidget,
    required this.title,
    required this.description,
    required this.trailing,
  });

  static const _textDark = Color(0xFF1A1A1A);
  static const _textGrey = Color(0xFF757575);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A2D5A27),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          iconWidget,
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: _textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(fontSize: 12, color: _textGrey),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          trailing,
        ],
      ),
    );
  }
}

class _IconBox extends StatelessWidget {
  final IconData icon;
  final Color bg;
  final Color color;

  const _IconBox({
    required this.icon,
    required this.bg,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: color, size: 22),
    );
  }
}

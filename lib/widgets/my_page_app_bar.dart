import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class MyPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyPageAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(40);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 40,
      backgroundColor: AppColors.primary,
      elevation: 0,
      leading: const Icon(
        Icons.keyboard_arrow_left,
        color: Colors.white,
        size: 24,
      ),
      centerTitle: true,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'マイページ',
            style: GoogleFonts.notoSansJp(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          _HelpCircleIcon(iconColor: AppColors.primary),
        ],
      ),
    );
  }
}

class _HelpCircleIcon extends StatelessWidget {
  final Color iconColor;

  const _HelpCircleIcon({required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 18,
      height: 18,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.help, size: 13, color: iconColor),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../core/routes/app_routes.dart';
import '../theme/app_colors.dart';

class BookingSuccessScreen extends StatelessWidget {
  final String propertyName;
  final String imageUrl;
  final DateTime checkIn;

  const BookingSuccessScreen({
    super.key,
    required this.propertyName,
    required this.imageUrl,
    required this.checkIn,
  });

  static const _months = [
    '', 'Th1', 'Th2', 'Th3', 'Th4', 'Th5', 'Th6',
    'Th7', 'Th8', 'Th9', 'Th10', 'Th11', 'Th12'
  ];

  String get _bookingDate =>
      '${checkIn.day.toString().padLeft(2, '0')} ${_months[checkIn.month]}, ${checkIn.year}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWarm,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
          child: Column(
            children: [
              _buildSuccessIcon(),
              const SizedBox(height: 24),
              _buildTypography(),
              const SizedBox(height: 16),
              _buildRefBadge(),
              const SizedBox(height: 32),
              _buildBookingCard(),
              const SizedBox(height: 32),
              _buildButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessIcon() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 130,
          height: 130,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
        ),
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.35),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(Icons.check, color: Colors.white, size: 48),
        ),
      ],
    );
  }

  Widget _buildTypography() {
    return Column(
      children: [
        const Text(
          'Chúc mừng!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: AppColors.text,
          ),
        ),
        const SizedBox(height: 10),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: const TextStyle(
                fontSize: 14, color: AppColors.textGrey, height: 1.6),
            children: [
              const TextSpan(text: 'Đơn đặt chỗ của bạn tại '),
              TextSpan(
                text: propertyName,
                style: const TextStyle(
                    fontWeight: FontWeight.w700, color: AppColors.text),
              ),
              const TextSpan(text: ' đã được xác nhận.'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRefBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.backgroundGrey,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'BOOKING REF: ',
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textGrey,
                letterSpacing: 0.5),
          ),
          Text(
            'TRV2025001',
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
                letterSpacing: 0.5),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard() {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              CachedNetworkImage(
                imageUrl: imageUrl,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                    height: 160, color: AppColors.cardPlaceholder),
                errorWidget: (_, __, ___) => Container(
                    height: 160, color: AppColors.cardPlaceholder),
              ),
              Container(
                height: 160,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, AppColors.overlayDark],
                    stops: [0.4, 1.0],
                  ),
                ),
              ),
              Positioned(
                bottom: 12,
                left: 14,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Ngày đặt',
                        style: TextStyle(
                            color: Colors.white70, fontSize: 11)),
                    Text(
                      _bookingDate,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: const [
                Icon(Icons.verified_user_outlined,
                    color: AppColors.textGrey, size: 18),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Bảo hiểm du lịch đã kích hoạt',
                    style:
                        TextStyle(fontSize: 13, color: AppColors.textGrey),
                  ),
                ),
                Icon(Icons.chevron_right,
                    color: AppColors.textGrey, size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.home,
              (_) => false,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: const StadiumBorder(),
              elevation: 0,
              textStyle: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w700),
            ),
            child: const Text('Về Trang Chủ'),
          ),
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            'Xem chi tiết đơn hàng',
            style: TextStyle(fontSize: 13, color: AppColors.textGrey),
          ),
        ),
      ],
    );
  }
}

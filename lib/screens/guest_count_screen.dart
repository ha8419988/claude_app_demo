import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'booking_review_screen.dart';

class GuestCountScreen extends StatefulWidget {
  final String propertyName;
  final String location;
  final String imageUrl;
  final String price;
  final DateTime checkIn;
  final DateTime checkOut;
  final int nights;

  const GuestCountScreen({
    super.key,
    required this.propertyName,
    required this.location,
    required this.imageUrl,
    required this.price,
    required this.checkIn,
    required this.checkOut,
    required this.nights,
  });

  @override
  State<GuestCountScreen> createState() => _GuestCountScreenState();
}

class _GuestCountScreenState extends State<GuestCountScreen> {
  int _rooms = 1;
  int _adults = 2;
  int _children = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWarm,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.text),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Số phòng & Khách',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.text),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildHero(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                    child: Column(
                      children: [
                        _CounterRow(
                          label: 'Phòng',
                          subtitle: 'Lựa chọn số lượng phòng nghỉ',
                          value: _rooms,
                          min: 1,
                          showBorder: true,
                          onChanged: (v) => setState(() => _rooms = v),
                        ),
                        _CounterRow(
                          label: 'Người lớn',
                          subtitle: 'Từ 13 tuổi trở lên',
                          value: _adults,
                          min: 1,
                          showBorder: true,
                          onChanged: (v) => setState(() => _adults = v),
                        ),
                        _CounterRow(
                          label: 'Trẻ em',
                          subtitle: 'Từ 0 đến 12 tuổi',
                          value: _children,
                          min: 0,
                          showBorder: false,
                          onChanged: (v) => setState(() => _children = v),
                        ),
                        const SizedBox(height: 24),
                        _buildInfoBox(),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildHero() {
    return SizedBox(
      height: 200,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: widget.imageUrl,
            fit: BoxFit.cover,
            placeholder: (_, __) =>
                Container(color: AppColors.cardPlaceholder),
            errorWidget: (_, __, ___) =>
                Container(color: AppColors.cardPlaceholder),
          ),
          Container(
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
            left: 20,
            bottom: 16,
            right: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Vietnam Travel',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.propertyName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: AppColors.textGrey, size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              'Số lượng khách tối đa trong một phòng có thể thay đổi tùy thuộc vào chính sách của từng resort.',
              style: TextStyle(
                  fontSize: 13, color: AppColors.textGrey, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(
          20, 12, 20, 12 + MediaQuery.of(context).padding.bottom),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.borderGrey)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton.icon(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BookingReviewScreen(
                propertyName: widget.propertyName,
                location: widget.location,
                imageUrl: widget.imageUrl,
                price: widget.price,
                checkIn: widget.checkIn,
                checkOut: widget.checkOut,
                nights: widget.nights,
                rooms: _rooms,
                adults: _adults,
                children: _children,
              ),
            ),
          ),
          icon: const Icon(Icons.arrow_forward),
          label: const Text('Tiếp tục'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            elevation: 0,
            textStyle: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}

class _CounterRow extends StatelessWidget {
  final String label;
  final String subtitle;
  final int value;
  final int min;
  final bool showBorder;
  final ValueChanged<int> onChanged;

  const _CounterRow({
    required this.label,
    required this.subtitle,
    required this.value,
    required this.min,
    required this.showBorder,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: showBorder
          ? const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.borderGrey)))
          : null,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.text)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textGrey)),
              ],
            ),
          ),
          Row(
            children: [
              _StepBtn(
                icon: Icons.remove,
                isPrimary: false,
                enabled: value > min,
                onTap: value > min ? () => onChanged(value - 1) : null,
              ),
              SizedBox(
                width: 36,
                child: Text(
                  '$value',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.text),
                ),
              ),
              _StepBtn(
                icon: Icons.add,
                isPrimary: true,
                enabled: value < 10,
                onTap: value < 10 ? () => onChanged(value + 1) : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepBtn extends StatelessWidget {
  final IconData icon;
  final bool isPrimary;
  final bool enabled;
  final VoidCallback? onTap;

  const _StepBtn({
    required this.icon,
    required this.isPrimary,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isPrimary && enabled
                ? AppColors.primary
                : AppColors.borderGrey,
          ),
          color: isPrimary && enabled
              ? AppColors.primary.withValues(alpha: 0.05)
              : Colors.transparent,
        ),
        child: Icon(
          icon,
          size: 20,
          color: isPrimary && enabled
              ? AppColors.primary
              : enabled
                  ? AppColors.text
                  : AppColors.textLightGrey,
        ),
      ),
    );
  }
}

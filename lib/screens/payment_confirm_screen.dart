import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'booking_success_screen.dart';
import 'payment_method_screen.dart';

class PaymentConfirmScreen extends StatelessWidget {
  final String propertyName;
  final String location;
  final String imageUrl;
  final String price;
  final DateTime checkIn;
  final DateTime checkOut;
  final int nights;
  final int rooms;
  final int adults;
  final int children;

  const PaymentConfirmScreen({
    super.key,
    required this.propertyName,
    required this.location,
    required this.imageUrl,
    required this.price,
    required this.checkIn,
    required this.checkOut,
    required this.nights,
    required this.rooms,
    required this.adults,
    required this.children,
  });

  static const _months = [
    '', 'Th1', 'Th2', 'Th3', 'Th4', 'Th5', 'Th6',
    'Th7', 'Th8', 'Th9', 'Th10', 'Th11', 'Th12'
  ];

  String _fmtDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')} ${_months[d.month]}, ${d.year}';

  String get _dateRange =>
      '${checkIn.day.toString().padLeft(2, '0')} ${_months[checkIn.month]}'
      ' – ${checkOut.day.toString().padLeft(2, '0')} ${_months[checkOut.month]}';

  int get _guests => adults + children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWarm,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: const Text(
          'Xác nhận thanh toán',
          style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.primary),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.primary),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildResortCard(),
                  const SizedBox(height: 28),
                  _sectionLabel('Chi tiết đặt phòng'),
                  const SizedBox(height: 12),
                  _buildDateRow(),
                  const SizedBox(height: 12),
                  _buildPriceBreakdown(),
                  const SizedBox(height: 28),
                  _sectionLabel('Phương thức thanh toán'),
                  const SizedBox(height: 12),
                  _buildPaymentMethod(context),
                  const SizedBox(height: 20),
                  const Text(
                    'Bằng việc nhấn Thanh toán, bạn đồng ý với các Điều khoản & Chính sách của Vietnam Travel.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 12, color: AppColors.textGrey, height: 1.5),
                  ),
                ],
              ),
            ),
          ),
          _buildBottomBar(context),
        ],
      ),
    );
  }

  Widget _buildResortCard() {
    return Container(
      padding: const EdgeInsets.all(12),
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
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              width: 88,
              height: 88,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(
                  width: 88, height: 88, color: AppColors.cardPlaceholder),
              errorWidget: (_, __, ___) => Container(
                  width: 88, height: 88, color: AppColors.cardPlaceholder),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'KHU NGHỈ DƯỠNG CAO CẤP',
                    style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  propertyName,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.text),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: 13, color: AppColors.textGrey),
                    const SizedBox(width: 3),
                    Expanded(
                      child: Text(
                        location,
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.textGrey),
                        overflow: TextOverflow.ellipsis,
                      ),
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

  Widget _sectionLabel(String text) {
    return Text(
      text.toUpperCase(),
      style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.textGrey,
          letterSpacing: 1.0),
    );
  }

  Widget _buildDateRow() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundGrey,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Ngày nhận phòng',
                    style:
                        TextStyle(fontSize: 11, color: AppColors.textGrey)),
                const SizedBox(height: 4),
                Text(
                  _fmtDate(checkIn),
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.text),
                ),
              ],
            ),
          ),
          const Icon(Icons.east, color: AppColors.textGrey, size: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text('Ngày trả phòng',
                    style:
                        TextStyle(fontSize: 11, color: AppColors.textGrey)),
                const SizedBox(height: 4),
                Text(
                  _fmtDate(checkOut),
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceBreakdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _PriceRow(label: 'Mỗi ngày', value: '${price}đ'),
                const SizedBox(height: 10),
                _PriceRow(label: 'Ngày', value: _dateRange),
                const SizedBox(height: 10),
                _PriceRow(label: 'Số đêm', value: '$nights đêm'),
                const SizedBox(height: 10),
                _PriceRow(label: 'Khách', value: '$_guests người'),
                const SizedBox(height: 10),
                _PriceRow(label: 'Số phòng', value: '$rooms phòng'),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(color: AppColors.borderGrey, height: 1),
                ),
                _PriceRow(
                    label: 'Tạm tính',
                    value: '${price}đ × $nights đêm'),
                const SizedBox(height: 10),
                const _PriceRow(label: 'Thuế & phí', value: '10%'),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.06),
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(14)),
            ),
            child: Row(
              children: [
                const Text(
                  'Tổng cộng',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.text),
                ),
                const Spacer(),
                Text(
                  '${price}đ × $nights đêm',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethod(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PaymentMethodScreen()),
      ),
      child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.backgroundGrey,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.borderGrey),
            ),
            child: const Icon(Icons.credit_card,
                color: AppColors.text, size: 22),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Visa •••• 4242',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text)),
                Text('Hết hạn 12/26',
                    style: TextStyle(
                        fontSize: 12, color: AppColors.textGrey)),
              ],
            ),
          ),
          const Icon(Icons.check_circle,
              color: AppColors.primary, size: 24),
        ],
      ),
    ));
  }

  Widget _buildBottomBar(BuildContext context) {
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
              builder: (_) => BookingSuccessScreen(
                propertyName: propertyName,
                imageUrl: imageUrl,
                checkIn: checkIn,
              ),
            ),
          ),
          icon: const Icon(Icons.lock),
          label: Text('Thanh toán · ${price}đ × $nights đêm'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            elevation: 0,
            textStyle: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;

  const _PriceRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 14, color: AppColors.textGrey)),
        const Spacer(),
        Text(value,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.text)),
      ],
    );
  }
}

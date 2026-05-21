import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum _Method { card, momo, zalopay, bank }

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  _Method _selected = _Method.card;

  final _cardNumberCtrl = TextEditingController();
  final _cardNameCtrl = TextEditingController();
  final _expiryCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();

  @override
  void dispose() {
    _cardNumberCtrl.dispose();
    _cardNameCtrl.dispose();
    _expiryCtrl.dispose();
    _cvvCtrl.dispose();
    super.dispose();
  }

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
          'Phương thức thanh toán',
          style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppColors.primary),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Phương thức thanh toán',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Vui lòng chọn phương thức thanh toán phù hợp nhất với bạn.',
                    style:
                        TextStyle(fontSize: 14, color: AppColors.textGrey),
                  ),
                  const SizedBox(height: 20),
                  _MethodOption(
                    selected: _selected == _Method.card,
                    iconWidget: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.backgroundGrey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.credit_card,
                          color: AppColors.primary, size: 24),
                    ),
                    title: 'Thẻ tín dụng / Ghi nợ',
                    subtitle: 'Visa, Mastercard, JCB',
                    onTap: () => setState(() => _selected = _Method.card),
                  ),
                  const SizedBox(height: 10),
                  _MethodOption(
                    selected: _selected == _Method.momo,
                    iconWidget: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFA50064),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text('M',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 22)),
                      ),
                    ),
                    title: 'Ví điện tử MoMo',
                    subtitle: 'Thanh toán nhanh qua ứng dụng MoMo',
                    onTap: () => setState(() => _selected = _Method.momo),
                  ),
                  const SizedBox(height: 10),
                  _MethodOption(
                    selected: _selected == _Method.zalopay,
                    iconWidget: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF008FE5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text('Z',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 22)),
                      ),
                    ),
                    title: 'Ví điện tử ZaloPay',
                    subtitle: 'Tiện lợi, an toàn qua Zalo',
                    onTap: () =>
                        setState(() => _selected = _Method.zalopay),
                  ),
                  const SizedBox(height: 10),
                  _MethodOption(
                    selected: _selected == _Method.bank,
                    iconWidget: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.backgroundGrey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.account_balance_outlined,
                          color: AppColors.primary, size: 24),
                    ),
                    title: 'Chuyển khoản ngân hàng',
                    subtitle: 'Chuyển khoản qua số tài khoản (VietQR)',
                    onTap: () => setState(() => _selected = _Method.bank),
                  ),
                  if (_selected == _Method.card) ...[
                    const SizedBox(height: 20),
                    _buildCardForm(),
                  ],
                ],
              ),
            ),
          ),
          _buildBottomBar(context),
        ],
      ),
    );
  }

  Widget _buildCardForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundGrey,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardField(
              controller: _cardNumberCtrl,
              label: 'Số thẻ',
              hint: '0000 0000 0000 0000',
              inputType: TextInputType.number),
          const SizedBox(height: 12),
          _CardField(
              controller: _cardNameCtrl,
              label: 'Tên trên thẻ',
              hint: 'NGUYEN VAN A',
              textCapitalization: TextCapitalization.characters),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _CardField(
                    controller: _expiryCtrl,
                    label: 'Ngày hết hạn',
                    hint: 'MM/YY',
                    inputType: TextInputType.number),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _CardField(
                    controller: _cvvCtrl,
                    label: 'CVC/CVV',
                    hint: '***',
                    obscure: true,
                    inputType: TextInputType.number),
              ),
            ],
          ),
        ],
      ),
    );
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
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            elevation: 0,
            textStyle: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.w700),
          ),
          child: const Text('Xác nhận'),
        ),
      ),
    );
  }
}

class _MethodOption extends StatelessWidget {
  final bool selected;
  final Widget iconWidget;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MethodOption({
    required this.selected,
    required this.iconWidget,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: 0.05)
              : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.borderGrey,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            iconWidget,
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.text)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.textGrey)),
                ],
              ),
            ),
            Icon(
              selected ? Icons.check_circle : Icons.circle_outlined,
              color: selected ? AppColors.primary : AppColors.borderGrey,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}

class _CardField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool obscure;
  final TextInputType inputType;
  final TextCapitalization textCapitalization;

  const _CardField({
    required this.controller,
    required this.label,
    required this.hint,
    this.obscure = false,
    this.inputType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textGrey)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: inputType,
          textCapitalization: textCapitalization,
          style: const TextStyle(fontSize: 14, color: AppColors.text),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
                fontSize: 14, color: AppColors.textLightGrey),
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: AppColors.borderGrey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: AppColors.borderGrey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                  color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

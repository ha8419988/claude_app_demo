import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/routes/app_routes.dart';
import '../cubit/auth_cubit.dart';
import '../theme/app_colors.dart';

class SelectGenderScreen extends StatefulWidget {
  const SelectGenderScreen({super.key});

  @override
  State<SelectGenderScreen> createState() => _SelectGenderScreenState();
}

class _SelectGenderScreenState extends State<SelectGenderScreen> {
  int? _selected;

  static const _genders = [
    (Icons.male, 'Nam'),
    (Icons.female, 'Nữ'),
    (Icons.transgender, 'Khác'),
    (Icons.do_not_disturb_on_outlined, 'Không muốn tiết lộ'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundWarm,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.text),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Text(
                'Chọn giới tính',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text),
              ),
              const SizedBox(height: 8),
              const Text(
                'Chọn lựa chọn mô tả bạn nhất. Điều này giúp chúng tôi cá nhân hóa gợi ý du lịch.',
                style: TextStyle(
                    fontSize: 14, color: AppColors.textGrey, height: 1.5),
              ),
              const SizedBox(height: 28),
              ...List.generate(_genders.length, (i) {
                final isSelected = _selected == i;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                    onTap: () => setState(() => _selected = i),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withValues(alpha: 0.08)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.borderGrey,
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(_genders[i].$1,
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.textGrey,
                              size: 22),
                          const SizedBox(width: 14),
                          Text(
                            _genders[i].$2,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.text,
                            ),
                          ),
                          const Spacer(),
                          if (isSelected)
                            const Icon(Icons.check_circle,
                                color: AppColors.primary, size: 20),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () async {
                    await context.read<AuthCubit>().completeProfile();
                    if (!context.mounted) return;
                    Navigator.pushNamedAndRemoveUntil(
                        context, AppRoutes.home, (_) => false);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                  child: const Text('Tiếp tục',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

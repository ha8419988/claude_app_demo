import 'package:flutter/material.dart';
import '../core/routes/app_routes.dart';
import '../theme/app_colors.dart';

class SetupProfileScreen extends StatefulWidget {
  const SetupProfileScreen({super.key});

  @override
  State<SetupProfileScreen> createState() => _SetupProfileScreenState();
}

class _SetupProfileScreenState extends State<SetupProfileScreen> {
  final _usernameController = TextEditingController();
  final _dobController = TextEditingController();
  final _occupationController = TextEditingController();
  final _bioController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _dobController.dispose();
    _occupationController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration({required String label, required IconData icon, bool alignHint = false}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AppColors.textGrey, fontSize: 14),
      prefixIcon: Icon(icon, color: AppColors.textGrey, size: 20),
      alignLabelWithHint: alignHint,
      contentPadding: const EdgeInsets.symmetric(vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.borderGrey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.borderGrey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      _dobController.text =
          '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
    }
  }

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
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
              context, AppRoutes.login, (r) => false),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Text(
                'Thiết lập hồ sơ',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.text),
              ),
              const SizedBox(height: 8),
              const Text(
                'Hãy cho chúng tôi biết thêm về bạn để cá nhân hóa hành trình khám phá Việt Nam.',
                style: TextStyle(
                    fontSize: 14, color: AppColors.textGrey, height: 1.5),
              ),
              const SizedBox(height: 28),
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 96,
                      height: 96,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: AppColors.borderGrey, width: 2),
                      ),
                      child: const Icon(Icons.person_outline,
                          color: AppColors.textGrey, size: 48),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(Icons.add_a_photo,
                            color: Colors.white, size: 14),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              TextFormField(
                controller: _usernameController,
                style: const TextStyle(fontSize: 15, color: AppColors.text),
                decoration: _inputDecoration(
                    label: 'Tên người dùng', icon: Icons.person_outline),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dobController,
                readOnly: true,
                style: const TextStyle(fontSize: 15, color: AppColors.text),
                decoration: _inputDecoration(
                    label: 'Ngày sinh',
                    icon: Icons.calendar_today_outlined),
                onTap: _pickDate,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _occupationController,
                style: const TextStyle(fontSize: 15, color: AppColors.text),
                decoration: _inputDecoration(
                    label: 'Nghề nghiệp', icon: Icons.work_outline),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _bioController,
                maxLines: 3,
                style: const TextStyle(fontSize: 15, color: AppColors.text),
                decoration: _inputDecoration(
                    label: 'Tiểu sử',
                    icon: Icons.edit_note_outlined,
                    alignHint: true),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                      context, AppRoutes.selectLanguage, (_) => false),
                  iconAlignment: IconAlignment.end,
                  icon: const Icon(Icons.chevron_right, size: 20),
                  label: const Text(
                    'Lưu thông tin',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(height: 28),
              const Center(
                child: Text(
                  '"Hành trình vạn dặm bắt đầu từ một bước chân"',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textGrey,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
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

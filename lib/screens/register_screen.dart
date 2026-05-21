import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/routes/app_routes.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../theme/app_colors.dart';
import '../widgets/base_dialog.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _passwordVisible = false;
  bool _confirmVisible = false;
  bool _agreed = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    Navigator.pushNamedAndRemoveUntil(
      context, AppRoutes.verifyEmail, (_) => false,
      arguments: _emailController.text.trim(),
    );
  }

  InputDecoration _inputDecoration(
      {String? hint, required IconData icon, Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.textGrey),
      prefixIcon: Icon(icon, color: AppColors.textGrey, size: 20),
      suffixIcon: suffix,
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
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
      errorStyle: const TextStyle(fontSize: 12, color: AppColors.error),
    );
  }

  void _goToLogin() {
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (r) => false);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (!context.mounted) return;
        if (state is AuthAuthenticated) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.verifyEmail,
            (_) => false,
            arguments: _emailController.text.trim(),
          );
        } else if (state is AuthError) {
          BaseDialog.show(
            context: context,
            type: DialogType.warning,
            title: 'Đăng ký thất bại',
            message: state.message,
            primaryButtonText: 'Thử lại',
            customIcon: Icons.error_outline_rounded,
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return Stack(
          children: [
            Scaffold(
              backgroundColor: AppColors.backgroundWarm,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                scrolledUnderElevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: AppColors.text),
                  onPressed: _goToLogin,
                ),
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        Center(
                          child: Column(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.primary.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.explore,
                                    color: AppColors.primary, size: 48),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Vietnam Travel',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.text),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Bắt đầu hành trình của bạn',
                                style: TextStyle(
                                    fontSize: 14, color: AppColors.textGrey),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),
                        _buildLabel('Họ tên'),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _nameController,
                          style: const TextStyle(
                              fontSize: 15, color: AppColors.text),
                          decoration: _inputDecoration(
                              hint: 'Nguyễn Văn A', icon: Icons.person_outline),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty)
                              return 'Vui lòng nhập họ tên';
                            if (v.trim().length < 2)
                              return 'Họ tên phải có ít nhất 2 ký tự';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildLabel('Email'),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(
                              fontSize: 15, color: AppColors.text),
                          decoration: _inputDecoration(
                              hint: 'example@email.com',
                              icon: Icons.mail_outline),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty)
                              return 'Vui lòng nhập email';
                            final emailRegex = RegExp(
                                r'^[\w.+-]+@[\w-]+\.[a-z]{2,}$',
                                caseSensitive: false);
                            if (!emailRegex.hasMatch(v.trim()))
                              return 'Email không hợp lệ';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildLabel('Mật khẩu'),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: !_passwordVisible,
                          style: const TextStyle(
                              fontSize: 15, color: AppColors.text),
                          decoration: _inputDecoration(
                            icon: Icons.lock_outline,
                            suffix: GestureDetector(
                              onTap: () => setState(
                                  () => _passwordVisible = !_passwordVisible),
                              child: Icon(
                                _passwordVisible
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: AppColors.textGrey,
                                size: 20,
                              ),
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty)
                              return 'Vui lòng nhập mật khẩu';
                            if (v.length < 6)
                              return 'Mật khẩu phải có ít nhất 6 ký tự';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildLabel('Xác nhận mật khẩu'),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _confirmController,
                          obscureText: !_confirmVisible,
                          style: const TextStyle(
                              fontSize: 15, color: AppColors.text),
                          decoration: _inputDecoration(
                            icon: Icons.shield_outlined,
                            suffix: GestureDetector(
                              onTap: () => setState(
                                  () => _confirmVisible = !_confirmVisible),
                              child: Icon(
                                _confirmVisible
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: AppColors.textGrey,
                                size: 20,
                              ),
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty)
                              return 'Vui lòng xác nhận mật khẩu';
                            if (v != _passwordController.text)
                              return 'Mật khẩu không khớp';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildAgreementRow(),
                        const SizedBox(height: 24),
                        _buildRegisterButton(isLoading),
                        const SizedBox(height: 24),
                        _buildDivider(),
                        const SizedBox(height: 20),
                        _buildSocialButtons(),
                        const SizedBox(height: 28),
                        _buildLoginRow(),
                        const SizedBox(height: 20),
                        const Center(
                          child: Text(
                            '© 2024 Vietnam Explore Travel. All rights reserved.',
                            style: TextStyle(
                                fontSize: 11, color: AppColors.textGrey),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (isLoading)
              const Opacity(
                opacity: 0.4,
                child: ModalBarrier(dismissible: false, color: Colors.black),
              ),
            if (isLoading)
              const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
          ],
        );
      },
    );
  }

  Widget _buildLabel(String text) => Text(text,
      style: const TextStyle(fontSize: 13, color: AppColors.textGrey));

  Widget _buildAgreementRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: Checkbox(
            value: _agreed,
            onChanged: (v) => setState(() => _agreed = v ?? false),
            activeColor: AppColors.primary,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: const TextSpan(
              text: 'Tôi đồng ý với các ',
              style: TextStyle(fontSize: 13, color: AppColors.textGrey),
              children: [
                TextSpan(
                    text: 'Điều khoản sử dụng',
                    style: TextStyle(
                        color: AppColors.primary, fontWeight: FontWeight.w600)),
                TextSpan(text: ' và '),
                TextSpan(
                    text: 'Chính sách bảo mật',
                    style: TextStyle(
                        color: AppColors.primary, fontWeight: FontWeight.w600)),
                TextSpan(text: '.'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterButton(bool isLoading) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.6),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 0,
        ),
        child: const Text(
          'Tạo tài khoản',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Row(
      children: [
        Expanded(child: Divider(color: AppColors.borderGrey, thickness: 1)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text('Hoặc đăng ký bằng',
              style: TextStyle(fontSize: 12, color: AppColors.textGrey)),
        ),
        Expanded(child: Divider(color: AppColors.borderGrey, thickness: 1)),
      ],
    );
  }

  Widget _buildSocialButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialIconButton(Icons.g_mobiledata, AppColors.googleRed),
        const SizedBox(width: 16),
        _buildSocialIconButton(Icons.apps, AppColors.facebookBlue),
      ],
    );
  }

  Widget _buildSocialIconButton(IconData icon, Color color) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppColors.borderGrey),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        minimumSize: const Size(56, 56),
        maximumSize: const Size(56, 56),
        padding: EdgeInsets.zero,
      ),
      child: Icon(icon, color: color, size: 28),
    );
  }

  Widget _buildLoginRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Bạn đã có tài khoản? ',
            style: TextStyle(fontSize: 14, color: AppColors.textGrey)),
        TextButton(
          onPressed: _goToLogin,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text('Đăng nhập',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        ),
      ],
    );
  }
}

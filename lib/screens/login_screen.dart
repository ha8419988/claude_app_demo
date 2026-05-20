import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
import '../theme/app_colors.dart';
import '../widgets/base_dialog.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'a@gmail.com');
  final _passwordController = TextEditingController(text: '123456');
  bool _passwordVisible = false;

  static const _textDark = AppColors.text;
  static const _textGrey = Color(0xFF9E9E9E);
  static const _borderGrey = Color(0xFFE8E0D8);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthCubit>().tryAutoLogin();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthCubit>().login(
          _emailController.text.trim(),
          _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.pushReplacementNamed(context, '/home');
        } else if (state is AuthError) {
          BaseDialog.show(
            context: context,
            type: DialogType.warning,
            title: 'Đăng nhập thất bại',
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
              backgroundColor: AppColors.background,
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 40),

                              // Logo
                              Center(child: _buildLogo()),
                              const SizedBox(height: 28),

                              // Title
                              const Center(
                                child: Text(
                                  'Chào mừng trở lại',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w700,
                                    color: _textDark,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Center(
                                child: Text(
                                  'Khám phá vẻ đẹp Việt Nam cùng chúng tôi',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: _textGrey,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 36),

                              // Email
                              _buildLabel('Email'),
                              const SizedBox(height: 8),
                              _buildEmailField(),
                              const SizedBox(height: 20),

                              // Password
                              _buildPasswordHeader(),
                              const SizedBox(height: 8),
                              _buildPasswordField(),
                              const SizedBox(height: 28),

                              // Login button
                              _buildLoginButton(isLoading),
                              const SizedBox(height: 28),

                              // Divider
                              _buildDivider(),
                              const SizedBox(height: 24),

                              // Social buttons
                              _buildSocialButtons(),
                              const SizedBox(height: 28),

                              // Sign up row
                              _buildSignUpRow(),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),

                      // Decorative mountains
                      const _MountainDecoration(),
                    ],
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

  Widget _buildLogo() {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            'assets/icon/app_icon.png',
            width: 64,
            height: 64,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Vietnam Travel',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: _textDark,
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) => Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: _textDark,
        ),
      );

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(fontSize: 15, color: _textDark),
      decoration: _inputDecoration(
        hint: 'email@example.com',
        icon: Icons.mail_outline_rounded,
      ),
      validator: (v) {
        if (v == null || v.trim().isEmpty) return 'Vui lòng nhập email';
        final emailRegex =
            RegExp(r'^[\w.+-]+@[\w-]+\.[a-z]{2,}$', caseSensitive: false);
        if (!emailRegex.hasMatch(v.trim())) return 'Email không hợp lệ';
        return null;
      },
    );
  }

  Widget _buildPasswordHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildLabel('Mật khẩu'),
        GestureDetector(
          onTap: () {},
          child: const Text(
            'Quên mật khẩu?',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: !_passwordVisible,
      style: const TextStyle(fontSize: 15, color: _textDark),
      decoration: _inputDecoration(
        icon: Icons.lock_outline_rounded,
        suffix: GestureDetector(
          onTap: () => setState(() => _passwordVisible = !_passwordVisible),
          child: Icon(
            _passwordVisible
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: _textGrey,
            size: 20,
          ),
        ),
      ),
      validator: (v) {
        if (v == null || v.isEmpty) return 'Vui lòng nhập mật khẩu';
        if (v.length < 6) return 'Mật khẩu phải có ít nhất 6 ký tự';
        return null;
      },
    );
  }

  InputDecoration _inputDecoration({
    String? hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: _textGrey, fontSize: 14),
      prefixIcon: Icon(icon, color: _textGrey, size: 20),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _borderGrey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _borderGrey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE53935)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE53935), width: 1.5),
      ),
      errorStyle: const TextStyle(fontSize: 12, color: Color(0xFFE53935)),
    );
  }

  Widget _buildLoginButton(bool isLoading) {
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
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        child: const Text(
          'Đăng nhập',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(
      children: [
        const Expanded(child: Divider(color: _borderGrey, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'HOẶC TIẾP TỤC VỚI',
            style: TextStyle(
              fontSize: 11,
              color: _textGrey.withValues(alpha: 0.8),
              letterSpacing: 0.5,
            ),
          ),
        ),
        const Expanded(child: Divider(color: _borderGrey, thickness: 1)),
      ],
    );
  }

  Widget _buildSocialButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _SocialIconButton(
          icon: Icons.g_mobiledata_rounded,
          iconColor: const Color(0xFFDB4437),
          onTap: () {},
        ),
        const SizedBox(width: 16),
        _SocialIconButton(
          icon: Icons.facebook_rounded,
          iconColor: const Color(0xFF1877F2),
          onTap: () {},
        ),
        const SizedBox(width: 16),
        _SocialIconButton(
          icon: Icons.apple,
          iconColor: Colors.black87,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildSignUpRow() {
    return Center(
      child: RichText(
        text: TextSpan(
          text: 'Chưa có tài khoản? ',
          style: const TextStyle(fontSize: 14, color: _textGrey),
          children: [
            WidgetSpan(
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/register'),
                child: const Text(
                  'Đăng ký ngay',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SocialIconButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const _SocialIconButton({
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE8E0D8)),
        ),
        child: Icon(icon, color: iconColor, size: 28),
      ),
    );
  }
}

class _MountainDecoration extends StatelessWidget {
  const _MountainDecoration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      width: double.infinity,
      child: CustomPaint(painter: _MountainPainter()),
    );
  }
}

class _MountainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE8E0D8)
      ..style = PaintingStyle.fill;

    // Left mountain
    final leftPath = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width * 0.12, size.height * 0.3)
      ..lineTo(size.width * 0.24, size.height)
      ..close();
    canvas.drawPath(leftPath, paint);

    // Center mountain (taller)
    final centerPath = Path()
      ..moveTo(size.width * 0.35, size.height)
      ..lineTo(size.width * 0.5, size.height * 0.1)
      ..lineTo(size.width * 0.65, size.height)
      ..close();
    canvas.drawPath(centerPath, paint);

    // Right mountain
    final rightPath = Path()
      ..moveTo(size.width * 0.72, size.height)
      ..lineTo(size.width * 0.84, size.height * 0.35)
      ..lineTo(size.width * 0.96, size.height)
      ..close();
    canvas.drawPath(rightPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

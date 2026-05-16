import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';
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

  static const _green = Color(0xFF2D5A27);
  static const _textDark = Color(0xFF1A1A1A);
  static const _textGrey = Color(0xFF757575);
  static const _borderGrey = Color(0xFFE0E0E0);

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
              backgroundColor: Colors.white,
              body: SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 48),
                        Center(child: _buildLogo()),
                        const SizedBox(height: 32),
                        const Text(
                          'Chào mừng trở lại',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: _textDark,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Khám phá vẻ đẹp Việt Nam cùng chúng tôi.',
                          style: TextStyle(fontSize: 14, color: _textGrey),
                        ),
                        const SizedBox(height: 32),
                        _buildLabel('Email'),
                        const SizedBox(height: 6),
                        _buildEmailField(),
                        const SizedBox(height: 16),
                        _buildPasswordHeader(),
                        const SizedBox(height: 6),
                        _buildPasswordField(),
                        const SizedBox(height: 24),
                        _buildLoginButton(isLoading),
                        const SizedBox(height: 24),
                        _buildDivider(),
                        const SizedBox(height: 20),
                        _buildSocialButtons(),
                        const SizedBox(height: 32),
                        _buildSignUpRow(),
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
                child: CircularProgressIndicator(color: Color(0xFF2D5A27)),
              ),
          ],
        );
      },
    );
  }

  Widget _buildLogo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(color: _green, shape: BoxShape.circle),
          child: const Icon(Icons.explore, color: Colors.white, size: 26),
        ),
        const SizedBox(height: 8),
        const Text(
          'Vietnam Explore',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: _textDark),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) =>
      Text(text, style: const TextStyle(fontSize: 13, color: _textGrey));

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(fontSize: 15, color: _textDark),
      decoration: _inputDecoration(hint: 'abc@gmail.com', icon: Icons.mail_outline),
      validator: (v) {
        if (v == null || v.trim().isEmpty) return 'Vui lòng nhập email';
        final emailRegex = RegExp(r'^[\w.+-]+@[\w-]+\.[a-z]{2,}$', caseSensitive: false);
        if (!emailRegex.hasMatch(v.trim())) return 'Email không hợp lệ';
        return null;
      },
    );
  }

  Widget _buildPasswordHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Mật khẩu', style: TextStyle(fontSize: 13, color: _textGrey)),
        GestureDetector(
          onTap: () {},
          child: const Text(
            'Quên mật khẩu?',
            style: TextStyle(fontSize: 13, color: _green, fontWeight: FontWeight.w500),
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
        icon: Icons.lock_outline,
        suffix: GestureDetector(
          onTap: () => setState(() => _passwordVisible = !_passwordVisible),
          child: Icon(
            _passwordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
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

  InputDecoration _inputDecoration({String? hint, required IconData icon, Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: _textGrey),
      prefixIcon: Icon(icon, color: _textGrey, size: 20),
      suffixIcon: suffix,
      contentPadding: const EdgeInsets.symmetric(vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _borderGrey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _borderGrey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: _green, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE53935)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
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
          backgroundColor: _green,
          foregroundColor: Colors.white,
          disabledBackgroundColor: _green.withValues(alpha: 0.6),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 0,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Đăng nhập',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward, size: 18),
          ],
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
            'Hoặc đăng nhập bằng',
            style: const TextStyle(fontSize: 12, color: _textGrey),
          ),
        ),
        const Expanded(child: Divider(color: _borderGrey, thickness: 1)),
      ],
    );
  }

  Widget _buildSocialButtons() {
    return Row(
      children: [
        Expanded(child: _buildSocialButton('Google', const Color(0xFFDB4437))),
        const SizedBox(width: 12),
        Expanded(child: _buildSocialButton('Facebook', const Color(0xFF1877F2))),
      ],
    );
  }

  Widget _buildSocialButton(String label, Color iconColor) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: _borderGrey),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            label == 'Google' ? Icons.g_mobiledata : Icons.facebook,
            color: iconColor,
            size: 22,
          ),
          const SizedBox(width: 8),
          Text(label,
              style: const TextStyle(
                  fontSize: 14, color: _textDark, fontWeight: FontWeight.w500)),
        ],
      ),
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
                      fontSize: 14, color: _green, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

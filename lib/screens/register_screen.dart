import 'package:flutter/material.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _passwordVisible = false;
  bool _confirmVisible = false;
  bool _agreed = false;

  static const _green = Color(0xFF2D5A27);
  static const _textDark = Color(0xFF1A1A1A);
  static const _textGrey = Color(0xFF757575);
  static const _borderGrey = Color(0xFFE0E0E0);

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text(
                'Vietnam Explore',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: _textDark,
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Tạo tài khoản mới',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: _textDark,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Chào mừng bạn gia nhập cộng đồng yêu du lịch Việt Nam.',
                style: TextStyle(fontSize: 14, color: _textGrey),
              ),
              const SizedBox(height: 28),
              _buildLabel('Họ tên'),
              const SizedBox(height: 6),
              _buildTextField(
                controller: _nameController,
                hint: 'Nguyễn Văn A',
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 16),
              _buildLabel('Email'),
              const SizedBox(height: 6),
              _buildTextField(
                controller: _emailController,
                hint: 'example@email.com',
                icon: Icons.mail_outline,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              _buildLabel('Mật khẩu'),
              const SizedBox(height: 6),
              _buildPasswordField(
                controller: _passwordController,
                visible: _passwordVisible,
                onToggle: () => setState(() => _passwordVisible = !_passwordVisible),
                icon: Icons.lock_outline,
              ),
              const SizedBox(height: 16),
              _buildLabel('Xác nhận mật khẩu'),
              const SizedBox(height: 6),
              _buildPasswordField(
                controller: _confirmController,
                visible: _confirmVisible,
                onToggle: () => setState(() => _confirmVisible = !_confirmVisible),
                icon: Icons.lock_reset_outlined,
              ),
              const SizedBox(height: 16),
              _buildAgreementRow(),
              const SizedBox(height: 24),
              _buildRegisterButton(),
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
                  style: TextStyle(fontSize: 11, color: _textGrey),
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

  Widget _buildLabel(String text) {
    return Text(text, style: const TextStyle(fontSize: 13, color: _textGrey));
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 15, color: _textDark),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: _textGrey),
        prefixIcon: Icon(icon, color: _textGrey, size: 20),
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
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required bool visible,
    required VoidCallback onToggle,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      obscureText: !visible,
      style: const TextStyle(fontSize: 15, color: _textDark),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: _textGrey, size: 20),
        suffixIcon: GestureDetector(
          onTap: onToggle,
          child: Icon(
            visible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: _textGrey,
            size: 20,
          ),
        ),
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
      ),
    );
  }

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
            activeColor: _green,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: const TextSpan(
              text: 'Tôi đồng ý với các ',
              style: TextStyle(fontSize: 13, color: _textGrey),
              children: [
                TextSpan(
                  text: 'Điều khoản sử dụng',
                  style: TextStyle(color: _green, fontWeight: FontWeight.w600),
                ),
                TextSpan(text: ' và '),
                TextSpan(
                  text: 'Chính sách bảo mật',
                  style: TextStyle(color: _green, fontWeight: FontWeight.w600),
                ),
                TextSpan(text: '.'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: _green,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 0,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Đăng ký', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Row(
      children: [
        Expanded(child: Divider(color: _borderGrey, thickness: 1)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text('Hoặc đăng ký bằng', style: TextStyle(fontSize: 12, color: _textGrey)),
        ),
        Expanded(child: Divider(color: _borderGrey, thickness: 1)),
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
          Text(label, style: const TextStyle(fontSize: 14, color: _textDark, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildLoginRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Đã có tài khoản? ',
          style: TextStyle(fontSize: 14, color: _textGrey),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: _green,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            elevation: 0,
          ),
          child: const Text(
            'Đăng nhập',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

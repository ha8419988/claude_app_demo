import 'package:flutter/material.dart';

/// Enum định nghĩa các loại dialog
enum DialogType {
  success,
  warning,
  confirm,
  info,
}

/// Base Dialog widget tái sử dụng cho toàn bộ ứng dụng Vietnam Explore.
///
/// Hỗ trợ các loại dialog: success, warning, confirm, info.
/// Mỗi loại có màu sắc, icon riêng biệt phù hợp với design system.
class BaseDialog extends StatelessWidget {
  final DialogType type;
  final String title;
  final String message;
  final String? primaryButtonText;
  final String? secondaryButtonText;
  final VoidCallback? onPrimaryPressed;
  final VoidCallback? onSecondaryPressed;
  final IconData? customIcon;
  final bool showCloseButton;
  final bool barrierDismissible;

  const BaseDialog({
    super.key,
    required this.type,
    required this.title,
    required this.message,
    this.primaryButtonText,
    this.secondaryButtonText,
    this.onPrimaryPressed,
    this.onSecondaryPressed,
    this.customIcon,
    this.showCloseButton = true,
    this.barrierDismissible = true,
  });

  // === Design System Colors ===
  static const _green = Color(0xFF2D5A27);
  static const _greenLight = Color(0xFFEAF2EA);
  static const _orange = Color(0xFFF2994A);
  static const _orangeLight = Color(0xFFFFF3E0);
  static const _red = Color(0xFFE53935);
  static const _redLight = Color(0xFFFFEBEE);
  static const _blue = Color(0xFF1565C0);
  static const _blueLight = Color(0xFFE3F2FD);
  static const _textDark = Color(0xFF1A1A1A);
  static const _textGrey = Color(0xFF757575);

  /// Hiển thị dialog với animation mượt mà
  static Future<T?> show<T>({
    required BuildContext context,
    required DialogType type,
    required String title,
    required String message,
    String? primaryButtonText,
    String? secondaryButtonText,
    VoidCallback? onPrimaryPressed,
    VoidCallback? onSecondaryPressed,
    IconData? customIcon,
    bool showCloseButton = true,
    bool barrierDismissible = true,
  }) {
    return showGeneralDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (context, animation, secondaryAnimation) {
        return BaseDialog(
          type: type,
          title: title,
          message: message,
          primaryButtonText: primaryButtonText,
          secondaryButtonText: secondaryButtonText,
          onPrimaryPressed: onPrimaryPressed,
          onSecondaryPressed: onSecondaryPressed,
          customIcon: customIcon,
          showCloseButton: showCloseButton,
          barrierDismissible: barrierDismissible,
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
          reverseCurve: Curves.easeInBack,
        );

        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ),
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.8, end: 1.0).animate(curvedAnimation),
            child: child,
          ),
        );
      },
    );
  }

  /// Lấy cấu hình màu sắc theo loại dialog
  _DialogConfig get _config {
    switch (type) {
      case DialogType.success:
        return _DialogConfig(
          iconColor: _green,
          iconBgColor: _greenLight,
          icon: customIcon ?? Icons.check_circle_outline_rounded,
          primaryBtnColor: _green,
          primaryBtnTextColor: Colors.white,
        );
      case DialogType.warning:
        return _DialogConfig(
          iconColor: _orange,
          iconBgColor: _orangeLight,
          icon: customIcon ?? Icons.warning_amber_rounded,
          primaryBtnColor: _red,
          primaryBtnTextColor: Colors.white,
        );
      case DialogType.confirm:
        return _DialogConfig(
          iconColor: _red,
          iconBgColor: _redLight,
          icon: customIcon ?? Icons.logout_rounded,
          primaryBtnColor: _red,
          primaryBtnTextColor: Colors.white,
        );
      case DialogType.info:
        return _DialogConfig(
          iconColor: _blue,
          iconBgColor: _blueLight,
          icon: customIcon ?? Icons.info_outline_rounded,
          primaryBtnColor: _green,
          primaryBtnTextColor: Colors.white,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = _config;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: double.infinity,
            constraints: const BoxConstraints(maxWidth: 340),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2D5A27).withValues(alpha: 0.12),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // === Nút đóng ===
                if (showCloseButton)
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8, right: 8),
                      child: _CloseButton(
                        onTap: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ),

                // === Icon ===
                Padding(
                  padding: EdgeInsets.only(
                    top: showCloseButton ? 0 : 28,
                    bottom: 16,
                  ),
                  child: _AnimatedIcon(
                    icon: config.icon,
                    iconColor: config.iconColor,
                    bgColor: config.iconBgColor,
                  ),
                ),

                // === Tiêu đề ===
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Be Vietnam Pro',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: _textDark,
                      height: 1.3,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // === Nội dung ===
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: _textGrey,
                      height: 1.5,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // === Các nút hành động ===
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  child: Column(
                    children: [
                      // Nút chính (Primary)
                      if (primaryButtonText != null)
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: onPrimaryPressed ??
                                () => Navigator.of(context).pop(true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: config.primaryBtnColor,
                              foregroundColor: config.primaryBtnTextColor,
                              elevation: 0,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              primaryButtonText!,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.2,
                              ),
                            ),
                          ),
                        ),

                      if (primaryButtonText != null &&
                          secondaryButtonText != null)
                        const SizedBox(height: 10),

                      // Nút phụ (Secondary)
                      if (secondaryButtonText != null)
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: OutlinedButton(
                            onPressed: onSecondaryPressed ??
                                () => Navigator.of(context).pop(false),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: _textDark,
                              side: BorderSide(
                                color: Colors.grey.shade300,
                                width: 1.2,
                              ),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              secondaryButtonText!,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// === Nút đóng dialog ===
class _CloseButton extends StatefulWidget {
  final VoidCallback onTap;

  const _CloseButton({required this.onTap});

  @override
  State<_CloseButton> createState() => _CloseButtonState();
}

class _CloseButtonState extends State<_CloseButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _isHovered = true),
      onTapUp: (_) => setState(() => _isHovered = false),
      onTapCancel: () => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: _isHovered
              ? const Color(0xFFF5F5F5)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.close_rounded,
          size: 20,
          color: _isHovered
              ? const Color(0xFF1A1A1A)
              : const Color(0xFF9E9E9E),
        ),
      ),
    );
  }
}

/// === Icon với animation pulse ===
class _AnimatedIcon extends StatefulWidget {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;

  const _AnimatedIcon({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
  });

  @override
  State<_AnimatedIcon> createState() => _AnimatedIconState();
}

class _AnimatedIconState extends State<_AnimatedIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    // Delay nhỏ để animation mượt hơn
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: widget.bgColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: widget.iconColor.withValues(alpha: 0.15),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          widget.icon,
          color: widget.iconColor,
          size: 32,
        ),
      ),
    );
  }
}

/// Cấu hình nội bộ cho mỗi loại dialog
class _DialogConfig {
  final Color iconColor;
  final Color iconBgColor;
  final IconData icon;
  final Color primaryBtnColor;
  final Color primaryBtnTextColor;

  const _DialogConfig({
    required this.iconColor,
    required this.iconBgColor,
    required this.icon,
    required this.primaryBtnColor,
    required this.primaryBtnTextColor,
  });
}

/// === Shortcut methods ===
/// Các hàm tiện ích để hiển thị dialog nhanh chóng.

/// Dialog xác nhận đăng xuất
Future<bool?> showLogoutDialog(BuildContext context) {
  return BaseDialog.show<bool>(
    context: context,
    type: DialogType.confirm,
    title: 'Đăng xuất?',
    message:
        'Bạn sẽ phải đăng nhập lại để truy cập vào các ưu đãi thành viên và lịch trình đã lưu.',
    primaryButtonText: 'Đăng xuất',
    secondaryButtonText: 'Hủy',
  );
}

/// Dialog thành công (ví dụ: đặt vé thành công)
Future<void> showSuccessDialog(
  BuildContext context, {
  required String title,
  required String message,
  String buttonText = 'Tuyệt vời!',
}) {
  return BaseDialog.show(
    context: context,
    type: DialogType.success,
    title: title,
    message: message,
    primaryButtonText: buttonText,
  );
}

/// Dialog cảnh báo (ví dụ: hủy vé)
Future<bool?> showWarningDialog(
  BuildContext context, {
  required String title,
  required String message,
  String primaryText = 'Xác nhận',
  String secondaryText = 'Hủy',
}) {
  return BaseDialog.show<bool>(
    context: context,
    type: DialogType.warning,
    title: title,
    message: message,
    primaryButtonText: primaryText,
    secondaryButtonText: secondaryText,
  );
}

/// Dialog thông tin
Future<void> showInfoDialog(
  BuildContext context, {
  required String title,
  required String message,
  String buttonText = 'Đã hiểu',
}) {
  return BaseDialog.show(
    context: context,
    type: DialogType.info,
    title: title,
    message: message,
    primaryButtonText: buttonText,
  );
}

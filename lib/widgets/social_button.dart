import 'package:flutter/material.dart';
import '../constants/colors.dart';

class SocialButton extends StatelessWidget {
  final Widget icon;
  final VoidCallback onTap;

  const SocialButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 72,
        height: 54,
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
            width: 1.2,
          ),
        ),
        alignment: Alignment.center,
        child: icon,
      ),
    );
  }

  static Widget google({required VoidCallback onTap}) {
    return SocialButton(
      onTap: onTap,
      icon: Image.network(
        'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/768px-Google_%22G%22_logo.svg.png',
        height: 22,
        width: 22,
        errorBuilder: (_, __, ___) => const Icon(Icons.g_mobiledata_rounded, size: 28, color: Colors.blue),
      ),
    );
  }

  static Widget apple({required VoidCallback onTap}) {
    return SocialButton(
      onTap: onTap,
      icon: const Icon(Icons.apple, size: 26),
    );
  }

  static Widget facebook({required VoidCallback onTap}) {
    return SocialButton(
      onTap: onTap,
      icon: const Icon(Icons.facebook, size: 26, color: Color(0xFF1877F2)),
    );
  }
}

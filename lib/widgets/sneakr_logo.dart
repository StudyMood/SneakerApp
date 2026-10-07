import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';

class SneakrLogo extends StatelessWidget {
  final double fontSize;
  final bool isDark;

  const SneakrLogo({
    super.key,
    this.fontSize = 32,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = isDark ? Colors.white : (theme.brightness == Brightness.dark ? Colors.white : AppColors.textPrimaryLight);

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: 'SNEAKE',
            style: GoogleFonts.inter(
              fontSize: fontSize,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
              color: textColor,
            ),
          ),
          TextSpan(
            text: 'R',
            style: GoogleFonts.inter(
              fontSize: fontSize,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
              color: AppColors.accent,
            ),
          ),
        ],
      ),
    );
  }
}

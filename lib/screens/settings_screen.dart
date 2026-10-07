import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  final bool showBackButton;

  const SettingsScreen({super.key, this.showBackButton = true});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  String _currentLanguage = 'English';

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text('Select Language', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
        children: ['English', 'Hindi', 'Spanish', 'French'].map((lang) {
          return SimpleDialogOption(
            onPressed: () {
              setState(() => _currentLanguage = lang);
              Navigator.of(ctx).pop();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Text(lang, style: GoogleFonts.inter(fontSize: 14)),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : Colors.white,
      appBar: AppBar(
        leading: widget.showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
        title: Text(
          'Settings',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : AppColors.textPrimaryLight,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          // Language
          _buildSettingsTile(
            icon: Icons.language_rounded,
            title: 'Language',
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _currentLanguage,
                  style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF767676)),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.chevron_right_rounded, size: 18, color: Color(0xFF8E8E93)),
              ],
            ),
            isDark: isDark,
            onTap: _showLanguageDialog,
          ),
          const SizedBox(height: 12),

          // Dark Mode Switch
          _buildSettingsTile(
            icon: Icons.dark_mode_outlined,
            title: 'Dark Mode',
            trailing: Switch.adaptive(
              value: isDark,
              activeColor: AppColors.primary,
              onChanged: (val) {
                themeProvider.toggleTheme(val);
              },
            ),
            isDark: isDark,
          ),
          const SizedBox(height: 12),

          // Notifications Switch
          _buildSettingsTile(
            icon: Icons.notifications_none_rounded,
            title: 'Notifications',
            trailing: Switch.adaptive(
              value: _notificationsEnabled,
              activeColor: AppColors.primary,
              onChanged: (val) {
                setState(() => _notificationsEnabled = val);
              },
            ),
            isDark: isDark,
          ),
          const SizedBox(height: 12),

          // Privacy Policy
          _buildSettingsTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            trailing: const Icon(Icons.chevron_right_rounded, size: 18, color: Color(0xFF8E8E93)),
            isDark: isDark,
            onTap: () {
              _showInfoDialog('Privacy Policy', 'Your privacy is essential to SNEAKER. All user credentials and payment sessions are encrypted.');
            },
          ),
          const SizedBox(height: 12),

          // Terms & Conditions
          _buildSettingsTile(
            icon: Icons.description_outlined,
            title: 'Terms & Conditions',
            trailing: const Icon(Icons.chevron_right_rounded, size: 18, color: Color(0xFF8E8E93)),
            isDark: isDark,
            onTap: () {
              _showInfoDialog('Terms & Conditions', 'By using the SNEAKER mobile application, you agree to our standard terms of service.');
            },
          ),
          const SizedBox(height: 12),

          // About App
          _buildSettingsTile(
            icon: Icons.info_outline_rounded,
            title: 'About App',
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'v1.0.0',
                  style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF767676)),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.chevron_right_rounded, size: 18, color: Color(0xFF8E8E93)),
              ],
            ),
            isDark: isDark,
            onTap: () {
              _showInfoDialog('About SNEAKER', 'SNEAKER App v1.0.0\nBuilt with Flutter & High-Fidelity Design System.\n\nStyle | Culture | Sneakers');
            },
          ),
        ],
      ),
    );
  }

  void _showInfoDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
        content: Text(content, style: GoogleFonts.inter(fontSize: 14)),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('OK')),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required Widget trailing,
    required bool isDark,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : const Color(0xFFEEEEEE),
        ),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF262626) : const Color(0xFFF0F0F2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 20,
            color: isDark ? Colors.white : AppColors.textPrimaryLight,
          ),
        ),
        title: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : AppColors.textPrimaryLight,
          ),
        ),
        trailing: trailing,
      ),
    );
  }
}

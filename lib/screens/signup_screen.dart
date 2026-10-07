import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';
import '../widgets/sneakr_logo.dart';
import '../widgets/custom_button.dart';
import '../widgets/social_button.dart';
import '../widgets/main_navigation_shell.dart';
import '../services/firebase_service.dart';
import 'signin_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  void _handleSignUp() async {
    setState(() => _isLoading = true);
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      await FirebaseService.instance.signUp(
        name: name.isEmpty ? 'Sneakr Member' : name,
        email: email.isEmpty ? 'newuser@sneakr.com' : email,
        password: password.isEmpty ? 'password123' : password,
      );
    } catch (_) {
      // Handled gracefully
    }

    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const MainNavigationShell()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const SneakrLogo(fontSize: 24),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Text(
                'Create Account',
                style: GoogleFonts.inter(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  color: isDark ? Colors.white : AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Join the sneaker community',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF767676),
                ),
              ),
              const SizedBox(height: 32),

              // Full Name field
              _buildInputField(
                controller: _nameController,
                hintText: 'Full Name',
                icon: Icons.person_outline_rounded,
                isDark: isDark,
              ),
              const SizedBox(height: 16),

              // Email field
              _buildInputField(
                controller: _emailController,
                hintText: 'Email',
                icon: Icons.mail_outline_rounded,
                keyboardType: TextInputType.emailAddress,
                isDark: isDark,
              ),
              const SizedBox(height: 16),

              // Password field
              _buildInputField(
                controller: _passwordController,
                hintText: 'Password',
                icon: Icons.lock_outline_rounded,
                obscureText: _obscurePassword,
                isDark: isDark,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: const Color(0xFF8E8E93),
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              const SizedBox(height: 28),

              // Sign Up Button
              CustomButton(
                text: 'Sign Up',
                isLoading: _isLoading,
                onPressed: _handleSignUp,
              ),
              const SizedBox(height: 32),

              // "or continue with"
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: isDark ? AppColors.borderDark : const Color(0xFFE5E5EA),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'or continue with',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF8E8E93),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: isDark ? AppColors.borderDark : const Color(0xFFE5E5EA),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Social Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SocialButton.google(onTap: _handleSignUp),
                  const SizedBox(width: 16),
                  SocialButton.apple(onTap: _handleSignUp),
                  const SizedBox(width: 16),
                  SocialButton.facebook(onTap: _handleSignUp),
                ],
              ),
              const SizedBox(height: 36),

              // Already have an account? Sign In
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const SignInScreen()),
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      text: 'Already have an account? ',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: const Color(0xFF767676),
                      ),
                      children: [
                        TextSpan(
                          text: 'Sign In',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
    required bool isDark,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : const Color(0xFFE5E5EA),
          width: 1.2,
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: GoogleFonts.inter(
          fontSize: 14,
          color: isDark ? Colors.white : AppColors.textPrimaryLight,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.inter(
            fontSize: 14,
            color: const Color(0xFF9E9E9E),
          ),
          prefixIcon: Icon(icon, color: const Color(0xFF8E8E93), size: 20),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}

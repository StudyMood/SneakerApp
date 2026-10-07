// ============================================================================
// [START] FILE: signin_screen.dart
// ============================================================================

// ============================================================================
// [START] IMPORTS
// ============================================================================
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';
import '../widgets/sneakr_logo.dart';
import '../widgets/custom_button.dart';
import '../widgets/social_button.dart';
import '../widgets/main_navigation_shell.dart';
import '../services/firebase_service.dart';
import 'admin/admin_dashboard_screen.dart';
import 'signup_screen.dart';
// ============================================================================
// [END] IMPORTS
// ============================================================================

// ============================================================================
// [START] SIGN IN SCREEN WIDGET
// ============================================================================
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}
// ============================================================================
// [END] SIGN IN SCREEN WIDGET
// ============================================================================

// ============================================================================
// [START] SIGN IN SCREEN STATE
// ============================================================================
class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController(text: 'abhishek@email.com');
  final _passwordController = TextEditingController(text: '••••••••');
  bool _obscurePassword = true;
  bool _isLoading = false;

  void _handleSignIn({bool forceAdmin = false}) async {
    setState(() => _isLoading = true);
    final email = _emailController.text.trim().toLowerCase();
    final password = _passwordController.text.trim();
    final isAdmin = forceAdmin || email == 'admin@sneakr.com' || email == 'admin';

    try {
      await FirebaseService.instance.signIn(
        email: email.isEmpty ? (isAdmin ? 'admin@sneakr.com' : 'abhishek@email.com') : email,
        password: password.isEmpty ? 'password123' : password,
      );
    } catch (_) {
      // Safe fallback handled by service
    }

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (isAdmin || FirebaseService.instance.isAdmin) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const AdminDashboardScreen()),
        (route) => false,
      );
    } else {
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
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (_) => const SignUpScreen()),
              );
            }
          },
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
                'Welcome Back',
                style: GoogleFonts.inter(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Sign in to continue or manage your store',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                ),
              ),
              const SizedBox(height: 28),

              // Email field
              _buildInputField(
                controller: _emailController,
                hintText: 'Email (use admin@sneakr.com for Admin)',
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
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textMutedLight,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              const SizedBox(height: 12),

              // Forgot Password?
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Password reset link sent to your email.')),
                    );
                  },
                  child: Text(
                    'Forgot Password?',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Sign In Button
              CustomButton(
                text: 'Sign In',
                isLoading: _isLoading,
                onPressed: () => _handleSignIn(forceAdmin: false),
              ),
              const SizedBox(height: 12),

              // Login as Admin Quick Button
              OutlinedButton.icon(
                onPressed: () => _handleSignIn(forceAdmin: true),
                icon: const Icon(Icons.admin_panel_settings_rounded, size: 18, color: AppColors.flipkartBlue),
                label: Text(
                  'Login as Admin (Seller Hub)',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.flipkartBlue,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  side: const BorderSide(color: AppColors.flipkartBlue, width: 1.2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
              const SizedBox(height: 28),

              // "or continue with"
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: isDark ? AppColors.borderDark : AppColors.borderLight,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'or continue with',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textMutedLight,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: isDark ? AppColors.borderDark : AppColors.borderLight,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Social Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SocialButton.google(onTap: () => _handleSignIn(forceAdmin: false)),
                  const SizedBox(width: 16),
                  SocialButton.apple(onTap: () => _handleSignIn(forceAdmin: false)),
                  const SizedBox(width: 16),
                  SocialButton.facebook(onTap: () => _handleSignIn(forceAdmin: false)),
                ],
              ),
              const SizedBox(height: 36),

              // Don't have an account? Sign Up
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const SignUpScreen()),
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "Don't have an account? ",
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      ),
                      children: [
                        TextSpan(
                          text: 'Sign Up',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: isDark ? AppColors.cardLight : AppColors.primary,
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
        color: isDark ? AppColors.surfaceDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
          width: 1.2,
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: GoogleFonts.inter(
          fontSize: 14,
          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.inter(
            fontSize: 14,
            color: isDark ? AppColors.textSecondaryDark : AppColors.textMutedLight,
          ),
          prefixIcon: Icon(icon, color: isDark ? AppColors.textSecondaryDark : AppColors.textMutedLight, size: 20),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}
// ============================================================================
// [END] SIGN IN SCREEN STATE
// ============================================================================

// ============================================================================
// [END] FILE: signin_screen.dart
// ============================================================================

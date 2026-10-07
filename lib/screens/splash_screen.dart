import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/sneakr_logo.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();

    _timer = Timer(const Duration(milliseconds: 2800), () {
      if (mounted) {
        _navigateToOnboarding();
      }
    });
  }

  void _navigateToOnboarding() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const OnboardingScreen(),
        transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: GestureDetector(
        onTap: _navigateToOnboarding,
        behavior: HitTestBehavior.opaque,
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 40),
                // Center Floating Sneaker + SNEAKER branding
                SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Floating dynamic tilted sneaker
                      Transform.rotate(
                        angle: -0.22,
                        child: Container(
                          height: 240,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Image.asset(
                            'assets/images/jordan_chicago.jpg',
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.sports_basketball,
                              size: 100,
                              color: Colors.white24,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 36),
                      // SNEAKER Logo
                      const SneakrLogo(fontSize: 42, isDark: true),
                      const SizedBox(height: 10),
                      // Tagline
                      Text(
                        'STEP INTO A BETTER YOU',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 4.0,
                          color: const Color(0xFF8E8E93),
                        ),
                      ),
                    ],
                  ),
                ),
                // Footer
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Text(
                    'Style   |   Culture   |   Sneakers',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.5,
                      color: const Color(0xFF555555),
                    ),
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

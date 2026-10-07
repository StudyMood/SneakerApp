import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';
import 'signup_screen.dart';
import 'signin_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      'title': 'Discover\nExclusive Sneakers',
      'subtitle': 'Explore the latest drops from\ntop brands around the world.',
      'image': 'assets/images/dunk_grey.jpg',
    },
    {
      'title': 'Your Style\nYour Story',
      'subtitle': 'Sneakers aren\'t just shoes,\nthey\'re a lifestyle.',
      'image': 'assets/images/jordan_chicago.jpg',
    },
  ];

  void _nextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const SignUpScreen()),
      );
    }
  }

  void _skip() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const SignInScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar with Skip
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _skip,
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF666666),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    ),
                    child: Text(
                      'Skip',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF555555),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _onboardingData.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final data = _onboardingData[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        // Title
                        Text(
                          data['title']!,
                          style: GoogleFonts.inter(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            height: 1.15,
                            letterSpacing: -0.5,
                            color: AppColors.textPrimaryLight,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Subtitle
                        Text(
                          data['subtitle']!,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            height: 1.4,
                            color: const Color(0xFF767676),
                          ),
                        ),
                        const Spacer(),
                        // Sneaker image on pedestal
                        Center(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Subtle shadow oval / pedestal
                              Positioned(
                                bottom: 10,
                                child: Container(
                                  width: 260,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.08),
                                        blurRadius: 28,
                                        spreadRadius: 8,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Showcase Sneaker
                              Transform.rotate(
                                angle: index == 0 ? -0.15 : -0.22,
                                child: Container(
                                  height: 280,
                                  padding: const EdgeInsets.all(12),
                                  child: Image.asset(
                                    data['image']!,
                                    fit: BoxFit.contain,
                                    errorBuilder: (_, __, ___) => const Icon(
                                      Icons.sports_basketball,
                                      size: 120,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Bottom Bar with Indicator & Circular Next Button
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, bottom: 28),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Indicators
                  Row(
                    children: List.generate(
                      _onboardingData.length,
                      (index) => GestureDetector(
                        onTap: () {
                          _pageController.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.only(right: 6),
                          height: 8,
                          width: _currentPage == index ? 24 : 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index ? AppColors.primary : const Color(0xFFD9D9D9),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Circular Next Button
                  GestureDetector(
                    onTap: _nextPage,
                    child: Container(
                      width: 58,
                      height: 58,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

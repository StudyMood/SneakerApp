// ============================================================================
// [START] FILE: top_items_slider.dart
// ============================================================================

import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../constants/colors.dart';
import '../data/mock_data.dart';
import '../models/sneaker.dart';
import '../screens/product_details_screen.dart';
import 'sneaker_image.dart';

// ============================================================================
// [START] DATA MODEL FOR TOP FEATURED SLIDES
// ============================================================================
class _TopSlideItem {
  final Sneaker sneaker;
  final String tag;
  final IconData tagIcon;
  final Color tagColor;
  final String title;
  final String subtitle;
  final List<Color> gradient;
  final Color glowColor;

  const _TopSlideItem({
    required this.sneaker,
    required this.tag,
    required this.tagIcon,
    required this.tagColor,
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.glowColor,
  });
}
// ============================================================================
// [END] DATA MODEL FOR TOP FEATURED SLIDES
// ============================================================================

// ============================================================================
// [START] TOP ITEMS SLIDER WIDGET (STATEFUL)
// ============================================================================
class TopItemsSlider extends StatefulWidget {
  const TopItemsSlider({super.key});

  @override
  State<TopItemsSlider> createState() => _TopItemsSliderState();
}
// ============================================================================
// [END] TOP ITEMS SLIDER WIDGET
// ============================================================================

// ============================================================================
// [START] TOP ITEMS SLIDER STATE (_TopItemsSliderState)
// ============================================================================
class _TopItemsSliderState extends State<TopItemsSlider>
    with SingleTickerProviderStateMixin {
  // --------------------------------------------------------------------------
  // [START] STATE VARIABLES & CONTROLLERS
  // --------------------------------------------------------------------------
  late final PageController _pageController;
  late final AnimationController _levitateController;
  int _currentPage = 0;
  Timer? _autoSlideTimer;
  bool _isHovered = false;
  double _tiltX = 0.0;
  double _tiltY = 0.0;
  late final List<_TopSlideItem> _slides;
  // --------------------------------------------------------------------------
  // [END] STATE VARIABLES & CONTROLLERS
  // --------------------------------------------------------------------------

  // --------------------------------------------------------------------------
  // [START] INIT STATE & TOP ITEMS CONFIGURATION
  // --------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);

    _levitateController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat(reverse: true);

    // Prepare top featured items from MockData by ID
    final sneakers = MockData.sneakers;
    final jordanChicago =
        sneakers.firstWhere((s) => s.id == 'snk-21', orElse: () => sneakers[0]);
    final airMax270 =
        sneakers.firstWhere((s) => s.id == 'snk-11', orElse: () => sneakers[0]);
    final jordan4Cement =
        sneakers.firstWhere((s) => s.id == 'snk-22', orElse: () => sneakers[0]);
    final dunkLow =
        sneakers.firstWhere((s) => s.id == 'snk-1', orElse: () => sneakers[0]);

    _slides = [
      // Slide 1: Air Jordan 1 Chicago
      _TopSlideItem(
        sneaker: jordanChicago,
        tag: 'TOP SELLER #1',
        tagIcon: Icons.local_fire_department_rounded,
        tagColor: AppColors.favoriteRed,
        title: 'AIR JORDAN 1\nRETRO HIGH OG',
        subtitle: '1985 Iconic Chicago Silhouette',
        gradient: const [
          Color(0xFF220D12),
          Color(0xFF141014),
          Color(0xFF1F1017),
        ],
        glowColor: AppColors.accentCrimson.withOpacity(0.4),
      ),
      // Slide 2: Nike Air Max 270
      _TopSlideItem(
        sneaker: airMax270,
        tag: 'MAX 3D COMFORT',
        tagIcon: Icons.bolt_rounded,
        tagColor: AppColors.accentCyan,
        title: 'NIKE AIR MAX\n270 TRIPLE AIR',
        subtitle: '32mm Visible Kinetic Air Heel',
        gradient: const [
          Color(0xFF091622),
          Color(0xFF0D121C),
          Color(0xFF0F2538),
        ],
        glowColor: AppColors.accentCyan.withOpacity(0.35),
      ),
      // Slide 3: Air Jordan 4 Retro
      _TopSlideItem(
        sneaker: jordan4Cement,
        tag: 'RETRO GRAIL',
        tagIcon: Icons.auto_awesome_rounded,
        tagColor: AppColors.statusPending,
        title: 'AIR JORDAN 4\nWHITE CEMENT',
        subtitle: 'Flight Support & Visible Sole Mesh',
        gradient: const [
          Color(0xFF241810),
          Color(0xFF151318),
          Color(0xFF1E1412),
        ],
        glowColor: AppColors.statusPending.withOpacity(0.32),
      ),
      // Slide 4: Nike Dunk Low
      _TopSlideItem(
        sneaker: dunkLow,
        tag: 'STREET TREND',
        tagIcon: Icons.trending_up_rounded,
        tagColor: AppColors.statusSuccess,
        title: 'NIKE DUNK LOW\nGREY FOG RETRO',
        subtitle: 'Padded Collar & Pivot Cupsole',
        gradient: const [
          Color(0xFF141926),
          Color(0xFF0F1218),
          Color(0xFF1B2433),
        ],
        glowColor: AppColors.accent.withOpacity(0.32),
      ),
    ];

    _startAutoSlide();
  }
  // --------------------------------------------------------------------------
  // [END] INIT STATE & TOP ITEMS CONFIGURATION
  // --------------------------------------------------------------------------

  // --------------------------------------------------------------------------
  // [START] AUTO-SLIDE & NAVIGATION CONTROLS
  // --------------------------------------------------------------------------
  void _startAutoSlide() {
    _autoSlideTimer?.cancel();
    _autoSlideTimer =
        Timer.periodic(const Duration(milliseconds: 5000), (timer) {
      if (!mounted || _isHovered) return;
      final nextPage = (_currentPage + 1) % _slides.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 650),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  void _goToPrevious() {
    final prevPage = (_currentPage - 1 + _slides.length) % _slides.length;
    _pageController.animateToPage(
      prevPage,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    );
  }

  void _goToNext() {
    final nextPage = (_currentPage + 1) % _slides.length;
    _pageController.animateToPage(
      nextPage,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    );
  }

  void _onPointerHover(PointerEvent details, BoxConstraints constraints) {
    final w = constraints.maxWidth;
    final h = 225.0;
    final dx = (details.localPosition.dx - (w / 2)) / (w / 2);
    final dy = (details.localPosition.dy - (h / 2)) / (h / 2);

    setState(() {
      _isHovered = true;
      _tiltY = dx.clamp(-1.0, 1.0) * 0.06;
      _tiltX = -dy.clamp(-1.0, 1.0) * 0.06;
    });
  }

  void _onPointerExit(PointerEvent details) {
    setState(() {
      _isHovered = false;
      _tiltX = 0.0;
      _tiltY = 0.0;
    });
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _pageController.dispose();
    _levitateController.dispose();
    super.dispose();
  }

  // --------------------------------------------------------------------------
  // [START] BUILD METHOD
  // --------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final currencyFormatter =
        NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    return LayoutBuilder(
      builder: (context, constraints) {
        return MouseRegion(
          onHover: (e) => _onPointerHover(e, constraints),
          onExit: _onPointerExit,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ============================================================
                    // [START] 3D SLIDER VIEWPORT (HEIGHT: 225px)
                    // ============================================================
                    Transform(
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.0012)
                        ..rotateX(_tiltX)
                        ..rotateY(_tiltY),
                      alignment: Alignment.center,
                      child: SizedBox(
                        height: 225,
                        child: Stack(
                          children: [
                            // --- [START] PageView Carousel Builder ---
                            PageView.builder(
                              controller: _pageController,
                              itemCount: _slides.length,
                              onPageChanged: (index) {
                                setState(() => _currentPage = index);
                              },
                              itemBuilder: (context, index) {
                                final slide = _slides[index];
                                final sneaker = slide.sneaker;

                                return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => ProductDetailsScreen(
                                            sneaker: sneaker),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: slide.gradient,
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(26),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.12),
                                        width: 1.2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.35),
                                          blurRadius: 22,
                                          offset: const Offset(0, 8),
                                        ),
                                        BoxShadow(
                                          color:
                                              slide.glowColor.withOpacity(0.18),
                                          blurRadius: 32,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(26),
                                      child: Stack(
                                        children: [
                                          // Ambient 3D background glow orb
                                          Positioned(
                                            right: -25,
                                            bottom: -25,
                                            child: Container(
                                              width: 230,
                                              height: 230,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                gradient: RadialGradient(
                                                  colors: [
                                                    slide.glowColor,
                                                    Colors.transparent,
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),

                                          // Watermark brand text behind shoe
                                          Positioned(
                                            right: 15,
                                            top: 10,
                                            child: Text(
                                              sneaker.brand.toUpperCase(),
                                              style: GoogleFonts.outfit(
                                                fontSize: 60,
                                                fontWeight: FontWeight.w900,
                                                letterSpacing: 4,
                                                color: Colors.white
                                                    .withOpacity(0.04),
                                              ),
                                            ),
                                          ),

                                          // Left Content Column (Tag, Title, Price, Shop Button)
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                22, 18, 145, 18),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                // Tag Pill
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10,
                                                      vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: slide.tagColor
                                                        .withOpacity(0.18),
                                                    borderRadius:
                                                        BorderRadius.circular(12),
                                                    border: Border.all(
                                                      color: slide.tagColor
                                                          .withOpacity(0.4),
                                                      width: 1,
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Icon(slide.tagIcon,
                                                          size: 13,
                                                          color: slide.tagColor),
                                                      const SizedBox(width: 5),
                                                      Text(
                                                        slide.tag,
                                                        style: GoogleFonts.inter(
                                                          fontSize: 10.5,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          letterSpacing: 0.6,
                                                          color: slide.tagColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                // Title & Subtitle
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      slide.title,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: GoogleFonts.outfit(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        height: 1.15,
                                                        letterSpacing: 0.4,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      slide.subtitle,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: GoogleFonts.inter(
                                                        fontSize: 11.5,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Colors.white70,
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                                // Price & Shop Now Button Row
                                                Row(
                                                  children: [
                                                    // Price badge
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          currencyFormatter
                                                              .format(sneaker
                                                                  .price),
                                                          style: GoogleFonts
                                                              .outfit(
                                                            fontSize: 17,
                                                            fontWeight:
                                                                FontWeight.w900,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            const Icon(
                                                                Icons
                                                                    .star_rounded,
                                                                size: 14,
                                                                color: AppColors
                                                                    .starYellow),
                                                            const SizedBox(
                                                                width: 2),
                                                            Text(
                                                              '${sneaker.rating} (${sneaker.reviewCount})',
                                                              style: GoogleFonts
                                                                  .inter(
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Colors
                                                                    .white60,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(width: 14),

                                                    // Shop Now Action Button
                                                    Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 14,
                                                          vertical: 8),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.white
                                                                .withOpacity(
                                                                    0.3),
                                                            blurRadius: 12,
                                                            offset:
                                                                const Offset(
                                                                    0, 3),
                                                          ),
                                                        ],
                                                      ),
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Text(
                                                            'Shop 3D',
                                                            style: GoogleFonts
                                                                .outfit(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w800,
                                                              color: Colors.black,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 4),
                                                          const Icon(
                                                              Icons
                                                                  .arrow_forward_rounded,
                                                              size: 14,
                                                              color:
                                                                  Colors.black),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),

                                          // Right Floating 3D Sneaker with Levitation
                                          Positioned(
                                            right: -8,
                                            top: 8,
                                            bottom: 8,
                                            child: IgnorePointer(
                                              child: AnimatedBuilder(
                                                animation: _levitateController,
                                                builder: (context, _) {
                                                  final float = math.sin(
                                                          _levitateController
                                                                  .value *
                                                              math.pi) *
                                                      7;
                                                  return Transform(
                                                    alignment: Alignment.center,
                                                    transform: Matrix4.identity()
                                                      ..setEntry(3, 2, 0.0014)
                                                      ..translate(
                                                          0.0, -float, 0.0)
                                                      ..rotateZ(-0.20 +
                                                          (float * 0.005))
                                                      ..rotateY(0.12),
                                                    child: SizedBox(
                                                      width: 200,
                                                      child: Center(
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.45),
                                                                blurRadius:
                                                                    22 + float,
                                                                offset: Offset(
                                                                    0,
                                                                    10 +
                                                                        float *
                                                                            0.5),
                                                              ),
                                                            ],
                                                          ),
                                                          child: SneakerImage(
                                                            imagePath:
                                                                sneaker.image,
                                                            fit: BoxFit.contain,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            // --- [END] PageView Carousel Builder ---

                            // --- [START] Desktop / Web Left & Right Arrow Buttons ---
                            if (kIsWeb || _isHovered) ...[
                              Positioned(
                                left: 10,
                                top: 0,
                                bottom: 0,
                                child: Center(
                                  child: InkWell(
                                    onTap: _goToPrevious,
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      width: 34,
                                      height: 34,
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.55),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Colors.white24, width: 1),
                                      ),
                                      child: const Icon(
                                          Icons.chevron_left_rounded,
                                          color: Colors.white,
                                          size: 20),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 10,
                                top: 0,
                                bottom: 0,
                                child: Center(
                                  child: InkWell(
                                    onTap: _goToNext,
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                      width: 34,
                                      height: 34,
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.55),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Colors.white24, width: 1),
                                      ),
                                      child: const Icon(
                                          Icons.chevron_right_rounded,
                                          color: Colors.white,
                                          size: 20),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            // --- [END] Desktop Left & Right Arrow Buttons ---
                          ],
                        ),
                      ),
                    ),
                    // ============================================================
                    // [END] SLIDER VIEWPORT
                    // ============================================================

                    const SizedBox(height: 10),

                    // ============================================================
                    // [START] SMOOTH DOT INDICATORS
                    // ============================================================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_slides.length, (index) {
                        final isActive = _currentPage == index;
                        return GestureDetector(
                          onTap: () {
                            _pageController.animateToPage(
                              index,
                              duration: const Duration(milliseconds: 450),
                              curve: Curves.easeOutCubic,
                            );
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            height: 6,
                            width: isActive ? 24 : 7,
                            decoration: BoxDecoration(
                              color: isActive
                                  ? AppColors.accentCyan
                                  : Colors.grey.withOpacity(0.35),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        );
                      }),
                    ),
                    // ============================================================
                    // [END] SMOOTH DOT INDICATORS
                    // ============================================================
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
// ============================================================================
// [END] FILE: top_items_slider.dart
// ============================================================================

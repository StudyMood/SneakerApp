// ============================================================================
// [START] FILE: categories_screen.dart
// ============================================================================

// ============================================================================
// [START] IMPORTS
// ============================================================================
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';
import '../data/mock_data.dart';
import '../widgets/sneaker_image.dart';
import 'product_list_screen.dart';
import 'search_screen.dart';
// ============================================================================
// [END] IMPORTS
// ============================================================================

// ============================================================================
// [START] CATEGORIES SCREEN WIDGET (STATELESS)
// ============================================================================
class CategoriesScreen extends StatelessWidget {
  final bool showBackButton;

  const CategoriesScreen({super.key, this.showBackButton = true});

  // --------------------------------------------------------------------------
  // [START] BUILD METHOD
  // --------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final categories = MockData.categories;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
        elevation: 0,
        leading: showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
        title: Text(
          'Categories',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      // ======================================================================
      // [START] CATEGORIES GRID (HALF-CARD PROPORTIONS MATCHING FLIPCARD)
      // ======================================================================
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1250),
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 250,
              mainAxisExtent: 315,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              return CategoryFlipCard(category: cat);
            },
          ),
        ),
      ),
      // ======================================================================
      // [END] CATEGORIES GRID
      // ======================================================================
    );
  }
  // --------------------------------------------------------------------------
  // [END] BUILD METHOD
  // --------------------------------------------------------------------------
}
// ============================================================================
// [END] CATEGORIES SCREEN WIDGET
// ============================================================================

// ============================================================================
// [START] CATEGORY FLIP CARD WIDGET (STATEFUL WITH 3D ROTATION)
// ============================================================================
class CategoryFlipCard extends StatefulWidget {
  final CategoryItem category;

  const CategoryFlipCard({
    super.key,
    required this.category,
  });

  @override
  State<CategoryFlipCard> createState() => _CategoryFlipCardState();
}
// ============================================================================
// [END] CATEGORY FLIP CARD WIDGET
// ============================================================================

// ============================================================================
// [START] CATEGORY FLIP CARD STATE
// ============================================================================
class _CategoryFlipCardState extends State<CategoryFlipCard>
    with SingleTickerProviderStateMixin {
  // --------------------------------------------------------------------------
  // [START] FLIP CONTROLLER & ANIMATION VARIABLES
  // --------------------------------------------------------------------------
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  bool _isFlippedToSpecs = false;
  // --------------------------------------------------------------------------
  // [END] FLIP CONTROLLER & ANIMATION VARIABLES
  // --------------------------------------------------------------------------

  // --------------------------------------------------------------------------
  // [START] INIT STATE
  // --------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _flipAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOutCubic),
    );

    _flipAnimation.addListener(() {
      if (_flipAnimation.value >= 0.5 && !_isFlippedToSpecs) {
        setState(() => _isFlippedToSpecs = true);
      } else if (_flipAnimation.value < 0.5 && _isFlippedToSpecs) {
        setState(() => _isFlippedToSpecs = false);
      }
    });
  }
  // --------------------------------------------------------------------------
  // [END] INIT STATE
  // --------------------------------------------------------------------------

  // --------------------------------------------------------------------------
  // [START] FLIP TOGGLE HELPER
  // --------------------------------------------------------------------------
  void _toggleFlip() {
    if (_flipController.isCompleted) {
      _flipController.reverse();
    } else {
      _flipController.forward();
    }
  }
  // --------------------------------------------------------------------------
  // [END] FLIP TOGGLE HELPER
  // --------------------------------------------------------------------------

  // --------------------------------------------------------------------------
  // [START] DISPOSE METHOD
  // --------------------------------------------------------------------------
  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }
  // --------------------------------------------------------------------------
  // [END] DISPOSE METHOD
  // --------------------------------------------------------------------------

  // --------------------------------------------------------------------------
  // [START] CATEGORY METADATA HELPER
  // --------------------------------------------------------------------------
  Map<String, dynamic> _getCategoryMetadata(String title) {
    switch (title.toLowerCase()) {
      case 'lifestyle':
        return {
          'tag': 'STREETWEAR ICON',
          'description': 'Everyday street comfort with classic low-top silhouettes, padded collars & versatile colorways.',
          'itemCount': '10 Sneakers',
          'startingPrice': 'From ₹6,499',
          'bestFor': 'Casual Wear & Daily Street Style',
          'keyTech': 'Lightweight Foam & Durable Cupsole',
          'popular': 'Dunk Low, Samba OG, AF1',
        };
      case 'running':
        return {
          'tag': 'MAX AIR RUN',
          'description': 'Engineered breathable mesh with high-rebound visible Air units built for daily miles & speed.',
          'itemCount': '10 Sneakers',
          'startingPrice': 'From ₹7,499',
          'bestFor': 'Road Running, Jogging & Cardio',
          'keyTech': '32mm Heel Max Air & Dual Density',
          'popular': 'Air Max 270, Ultraboost Light',
        };
      case 'basketball':
        return {
          'tag': 'COURT HERITAGE',
          'description': 'High-top ankle protection, encapsulated Air-Sole cushioning & circular pivot traction for the hardwood.',
          'itemCount': '10 Sneakers',
          'startingPrice': 'From ₹11,495',
          'bestFor': 'On-Court Play & High Ankle Support',
          'keyTech': 'Encapsulated Air-Sole & Full Leather',
          'popular': 'Air Jordan 1, Jordan 4 Retro',
        };
      case 'training':
        return {
          'tag': 'GYM & WORKOUT',
          'description': 'All-day stability, dual-density foam midsoles & multidirectional grip outsoles for heavy lifts & agility.',
          'itemCount': '10 Sneakers',
          'startingPrice': 'From ₹4,999',
          'bestFor': 'Gym, Cross-Training & HIIT',
          'keyTech': 'Lateral Stability Bands & Solid Grip',
          'popular': 'Metcon 9, Dropset 2, Fuse 2.0',
        };
      case 'skateboarding':
        return {
          'tag': 'BOARD READY',
          'description': 'Durable suede and leather overlays, vulcanized flex outsoles & cushioned tongues for optimal board feel.',
          'itemCount': '10 Sneakers',
          'startingPrice': 'From ₹5,999',
          'bestFor': 'Skate Sessions & Durable Grip',
          'keyTech': 'Padded Fat Tongue & Zoom Air',
          'popular': 'SB Dunk Low, Busenitz Pro',
        };
      case 'limited edition':
        return {
          'tag': 'EXCLUSIVE DROP',
          'description': 'Collector holy grails, premium hand-stitched leathers & iconic retro colorways released in limited quantities.',
          'itemCount': '10 Rare Grails',
          'startingPrice': 'From ₹38,999',
          'bestFor': 'Sneakerhead Collections & Resale',
          'keyTech': 'Numbered Editions & Vintage Patina',
          'popular': 'Travis Scott AJ1, Chunky Dunky',
        };
      default:
        return {
          'tag': 'PREMIUM LINE',
          'description': 'Curated sneaker styles crafted for performance, durability, and bold design aesthetic.',
          'itemCount': '10 Sneakers',
          'startingPrice': 'From ₹4,999',
          'bestFor': 'Daily Lifestyle & Style',
          'keyTech': 'Comfort Cushioning & Leather',
          'popular': 'Latest Sneaker Drops',
        };
    }
  }
  // --------------------------------------------------------------------------
  // [END] CATEGORY METADATA HELPER
  // --------------------------------------------------------------------------

  // --------------------------------------------------------------------------
  // [START] BUILD METHOD (ANIMATED BUILDER FOR 3D PERSPECTIVE)
  // --------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final meta = _getCategoryMetadata(widget.category.title);

    return AnimatedBuilder(
      animation: _flipAnimation,
      builder: (context, child) {
        final angle = _flipAnimation.value * pi;
        final transform = Matrix4.identity()
          ..setEntry(3, 2, 0.0015) // 3D perspective
          ..rotateY(angle);

        return Transform(
          transform: transform,
          alignment: Alignment.center,
          child: _isBackVisible
              // Back of Category Flip Card (Tech details & Specs)
              ? Transform(
                  transform: Matrix4.identity()..rotateY(pi),
                  alignment: Alignment.center,
                  child: _buildCardBack(isDark, meta),
                )
              // Front of Category Flip Card (Hero Image & Rich Info)
              : _buildCardFront(isDark, meta),
        );
      },
    );
  }

  bool get _isBackVisible => _isFlippedToSpecs;
  // --------------------------------------------------------------------------
  // [END] BUILD METHOD
  // --------------------------------------------------------------------------

  // ==========================================================================
  // [START] COMPONENT: FRONT SIDE OF CATEGORY FLIP CARD (MATCHING FLIPCARD)
  // ==========================================================================
  Widget _buildCardFront(bool isDark, Map<String, dynamic> meta) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderSubtleLight,
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ------------------------------------------------------------------
          // [START] TOP HALF: SNEAKER ITEM IMAGE & ACTION BADGES (HEIGHT: 165)
          // ------------------------------------------------------------------
          Stack(
            children: [
              // Image Canvas covering top half
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ProductListScreen(title: widget.category.title),
                    ),
                  );
                },
                child: Container(
                  height: 165,
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardGreyDark : AppColors.cardGreyLight,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(21),
                      topRight: Radius.circular(21),
                    ),
                  ),
                  child: Hero(
                    tag: 'category-item-${widget.category.title}',
                    child: SneakerImage(
                      imagePath: widget.category.image,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),

              // Flip Specs Button (Top Left)
              Positioned(
                top: 10,
                left: 10,
                child: GestureDetector(
                  onTap: _toggleFlip,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.black54 : Colors.white.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.flip_rounded,
                          size: 13,
                          color: isDark ? Colors.white70 : AppColors.textPrimaryLight,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Flip Specs',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white70 : AppColors.textPrimaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Category Icon Badge (Top Right)
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.black54 : Colors.white.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.06),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Icon(
                    widget.category.icon,
                    size: 16,
                    color: isDark ? Colors.white70 : AppColors.textPrimaryLight,
                  ),
                ),
              ),
            ],
          ),
          // ------------------------------------------------------------------
          // [END] TOP HALF: SNEAKER ITEM IMAGE
          // ------------------------------------------------------------------

          // ------------------------------------------------------------------
          // [START] BOTTOM HALF: CLEAN INFO AREA (MATCHING FLIPCARD)
          // ------------------------------------------------------------------
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Upper block: Tag + Rating, Title
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            (meta['tag'] as String).toUpperCase(),
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textMutedLight,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star_rounded, size: 14, color: AppColors.starYellow),
                              const SizedBox(width: 2),
                              Text(
                                '4.8',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.category.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                    ],
                  ),

                  // Lower block: Price + Circular Arrow Forward Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        meta['startingPrice'] as String,
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ProductListScreen(title: widget.category.title),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white : AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            size: 14,
                            color: isDark ? AppColors.primary : Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // ------------------------------------------------------------------
          // [END] BOTTOM HALF: CLEAN INFO AREA
          // ------------------------------------------------------------------
        ],
      ),
    );
  }
  // ==========================================================================
  // [END] COMPONENT: FRONT SIDE OF CATEGORY FLIP CARD
  // ==========================================================================

  // ==========================================================================
  // [START] COMPONENT: BACK SIDE OF CATEGORY FLIP CARD (3D SPECS)
  // ==========================================================================
  Widget _buildCardBack(bool isDark, Map<String, dynamic> meta) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardGreySubtleDark : AppColors.cardGreySubtleLight,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Header: Category Title + Flip Back Close Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '${widget.category.title} Specs',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
              ),
              IconButton(
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.close_rounded, size: 20),
                onPressed: _toggleFlip,
              ),
            ],
          ),
          const Divider(height: 8),

          // Specs List (Best For, Key Tech, Top Picks, Total Range)
          Column(
            children: [
              _buildSpecRow('Best For', meta['bestFor'] as String, isDark),
              const SizedBox(height: 5),
              _buildSpecRow('Key Tech', meta['keyTech'] as String, isDark),
              const SizedBox(height: 5),
              _buildSpecRow('Top Picks', meta['popular'] as String, isDark),
              const SizedBox(height: 5),
              _buildSpecRow('Range', meta['itemCount'] as String, isDark),
            ],
          ),

          // Quick Explore / Shop Collection CTA
          SizedBox(
            width: double.infinity,
            height: 38,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ProductListScreen(title: widget.category.title),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? Colors.white : AppColors.primary,
                foregroundColor: isDark ? AppColors.primary : Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(19)),
                padding: EdgeInsets.zero,
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Explore ${widget.category.title}',
                    style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(width: 5),
                  const Icon(Icons.arrow_forward_rounded, size: 14),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  // [START] HELPER: BUILD SPEC ROW
  // --------------------------------------------------------------------------
  Widget _buildSpecRow(String label, String value, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 70,
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textSecondaryDark : AppColors.textMutedLight,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
        ),
      ],
    );
  }
  // --------------------------------------------------------------------------
  // [END] HELPER: BUILD SPEC ROW
  // --------------------------------------------------------------------------
}
// ============================================================================
// [END] CATEGORY FLIP CARD STATE
// ============================================================================

// ============================================================================
// [END] FILE: categories_screen.dart
// ============================================================================

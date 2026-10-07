// ============================================================================
// [START] FILE: product_list_screen.dart
// ============================================================================

// ============================================================================
// [START] IMPORTS
// ============================================================================
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';
import '../data/mock_data.dart';
import '../models/sneaker.dart';
import '../widgets/sneaker_flip_card.dart';
// ============================================================================
// [END] IMPORTS
// ============================================================================

// ============================================================================
// [START] PRODUCT LIST SCREEN WIDGET (STATEFUL)
// ============================================================================
class ProductListScreen extends StatefulWidget {
  final String title;

  const ProductListScreen({super.key, this.title = 'Sneakers'});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}
// ============================================================================
// [END] PRODUCT LIST SCREEN WIDGET
// ============================================================================

// ============================================================================
// [START] PRODUCT LIST SCREEN STATE
// ============================================================================
class _ProductListScreenState extends State<ProductListScreen> {
  // --------------------------------------------------------------------------
  // [START] STATE VARIABLES
  // --------------------------------------------------------------------------
  String _selectedSubcategory = 'All';
  late List<String> _subcategories;
  // --------------------------------------------------------------------------
  // [END] STATE VARIABLES
  // --------------------------------------------------------------------------

  // --------------------------------------------------------------------------
  // [START] INIT STATE & DYNAMIC CHIPS
  // --------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    _initSubcategories();
  }

  void _initSubcategories() {
    // Generate context-aware filter chips based on current screen title
    final baseSneakers = _getBaseSneakers();
    final brands = baseSneakers.map((s) => s.brand).toSet().toList();

    if (widget.title.toLowerCase() == 'nike') {
      _subcategories = ['All', 'Air Max', 'Jordan', 'Dunk', 'Blazer'];
    } else if (brands.length > 1) {
      _subcategories = ['All', ...brands];
    } else {
      _subcategories = ['All', 'Jordan', 'Air Max', 'Dunk', 'Retro'];
    }
  }
  // --------------------------------------------------------------------------
  // [END] INIT STATE & DYNAMIC CHIPS
  // --------------------------------------------------------------------------

  // --------------------------------------------------------------------------
  // [START] FILTERING LOGIC
  // --------------------------------------------------------------------------
  List<Sneaker> _getBaseSneakers() {
    final titleLower = widget.title.trim().toLowerCase();

    // 1. Trending filter
    if (titleLower == 'trending' || titleLower == 'trending sneakers') {
      return MockData.sneakers.where((s) => s.isTrending).toList();
    }

    // 2. New drops filter
    if (titleLower == 'new drops') {
      return MockData.sneakers;
    }

    // 3. Category match (Lifestyle, Running, Basketball, Training, etc.)
    final categoryMatches = MockData.sneakers.where(
      (s) => s.category.toLowerCase() == titleLower,
    ).toList();
    if (categoryMatches.isNotEmpty) {
      return categoryMatches;
    }

    // 4. Brand match (Nike, Adidas, Puma, Jordan, etc.)
    final brandMatches = MockData.sneakers.where(
      (s) => s.brand.toLowerCase() == titleLower,
    ).toList();
    if (brandMatches.isNotEmpty) {
      return brandMatches;
    }

    // Default fallback
    return MockData.sneakers;
  }

  List<Sneaker> get _displayedSneakers {
    final base = _getBaseSneakers();
    if (_selectedSubcategory == 'All') {
      return base;
    }

    final query = _selectedSubcategory.toLowerCase();
    return base.where((s) {
      return s.name.toLowerCase().contains(query) ||
          s.brand.toLowerCase() == query ||
          s.category.toLowerCase() == query;
    }).toList();
  }
  // --------------------------------------------------------------------------
  // [END] FILTERING LOGIC
  // --------------------------------------------------------------------------

  // --------------------------------------------------------------------------
  // [START] FILTER & SORT BOTTOM SHEET
  // --------------------------------------------------------------------------
  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : AppColors.cardLight,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Filter & Sort',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.sort_rounded),
                title: Text(
                  'Price: Low to High',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                onTap: () {
                  setState(() {
                    MockData.sneakers.sort((a, b) => a.price.compareTo(b.price));
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.sort_rounded),
                title: Text(
                  'Price: High to Low',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                onTap: () {
                  setState(() {
                    MockData.sneakers.sort((a, b) => b.price.compareTo(a.price));
                  });
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.star_outline_rounded),
                title: Text(
                  'Top Rated',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                onTap: () {
                  setState(() {
                    MockData.sneakers.sort((a, b) => b.rating.compareTo(a.rating));
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
  // --------------------------------------------------------------------------
  // [END] FILTER & SORT BOTTOM SHEET
  // --------------------------------------------------------------------------

  // --------------------------------------------------------------------------
  // [START] TITLE FORMATTER HELPER
  // --------------------------------------------------------------------------
  String get _formattedTitle {
    final title = widget.title.trim();
    final lower = title.toLowerCase();
    if (lower == 'lifestyle' ||
        lower == 'running' ||
        lower == 'basketball' ||
        lower == 'training' ||
        lower == 'skateboarding') {
      return '$title Collection';
    }
    if (lower == 'limited edition') {
      return 'Limited Edition Drops';
    }
    if (lower == 'trending') {
      return 'Trending Sneakers';
    }
    if (lower == 'new drops') {
      return 'New Drops 2026';
    }
    if (lower == 'nike' || lower == 'adidas' || lower == 'puma' || lower == 'jordan') {
      return '$title Sneakers';
    }
    if (!lower.contains('collection') && !lower.contains('sneaker')) {
      return '$title Collection';
    }
    return title;
  }
  // --------------------------------------------------------------------------
  // [END] TITLE FORMATTER HELPER
  // --------------------------------------------------------------------------

  // --------------------------------------------------------------------------
  // [START] BUILD METHOD
  // --------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final sneakers = _displayedSneakers;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.backgroundLight,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        // ====================================================================
        // [START] DYNAMIC HEADING & ITEM COUNT SUBTITLE
        // ====================================================================
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _formattedTitle,
              style: GoogleFonts.inter(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.2,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  '${sneakers.length} ${sneakers.length == 1 ? "Sneaker" : "Sneakers"} Available',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textMutedLight,
                  ),
                ),
              ],
            ),
          ],
        ),
        // ====================================================================
        // [END] DYNAMIC HEADING & ITEM COUNT SUBTITLE
        // ====================================================================
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded),
            tooltip: 'Filter & Sort',
            onPressed: _showFilterSheet,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // ==================================================================
          // [START] SUBCATEGORY FILTER CHIPS
          // ==================================================================
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: _subcategories.map((sub) {
                final isSelected = _selectedSubcategory == sub;
                return GestureDetector(
                  onTap: () => setState(() => _selectedSubcategory = sub),
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (isDark ? AppColors.cardLight : AppColors.primary)
                          : (isDark ? AppColors.surfaceDark : AppColors.cardLight),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? (isDark ? AppColors.cardLight : AppColors.primary)
                            : (isDark ? AppColors.borderDark : AppColors.borderLight),
                      ),
                    ),
                    child: Text(
                      sub,
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? (isDark ? AppColors.primary : AppColors.cardLight)
                            : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          // ==================================================================
          // [END] SUBCATEGORY FILTER CHIPS
          // ==================================================================

          // ==================================================================
          // [START] RESULT INFO & FLIP HINT BAR
          // ==================================================================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Showing ${sneakers.length} ${sneakers.length == 1 ? "Item" : "Items"}',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textMutedLight,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      Icons.flip_rounded,
                      size: 13,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Flip card for specs',
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.textSecondaryDark : AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // ==================================================================
          // [END] RESULT INFO & FLIP HINT BAR
          // ==================================================================

          const SizedBox(height: 6),

          // ==================================================================
          // [START] RESPONSIVE FLIPCARD SNEAKER GRID (PROPER SIZING)
          // ==================================================================
          Expanded(
            child: sneakers.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off_rounded, size: 54, color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                        const SizedBox(height: 12),
                        Text(
                          'No sneakers found in this section',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textPrimaryLight,
                          ),
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1250),
                      child: GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 250,
                          mainAxisExtent: 315,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: sneakers.length,
                        itemBuilder: (context, index) {
                          final sneaker = sneakers[index];
                          return SneakerFlipCard(
                            sneaker: sneaker,
                            enableFlip: true,
                          );
                        },
                      ),
                    ),
                  ),
          ),
          // ==================================================================
          // [END] RESPONSIVE FLIPCARD SNEAKER GRID
          // ==================================================================
        ],
      ),
    );
  }
  // --------------------------------------------------------------------------
  // [END] BUILD METHOD
  // --------------------------------------------------------------------------
}
// ============================================================================
// [END] PRODUCT LIST SCREEN STATE
// ============================================================================

// ============================================================================
// [END] FILE: product_list_screen.dart
// ============================================================================

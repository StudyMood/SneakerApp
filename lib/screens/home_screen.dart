// ============================================================================
// [START] FILE: home_screen.dart
// ============================================================================
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../data/mock_data.dart';
import '../models/sneaker.dart';
import '../providers/notification_provider.dart';
import '../widgets/sneaker_flip_card.dart';
import '../widgets/sneaker_image.dart';
import '../widgets/top_items_slider.dart';
import 'notifications_screen.dart';
import 'product_details_screen.dart';
import 'product_list_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  final Function(int)? onTabSelected;

  const HomeScreen({super.key, this.onTabSelected});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  final List<String> _categories = [
    'All',
    'Men',
    'Women',
    'Sports',
    'Running',
    'Casual',
    'Jordan Retro',
  ];

  late final Sneaker _heroSneaker;

  @override
  void initState() {
    super.initState();
    final sneakers = MockData.sneakers;
    _heroSneaker = sneakers.firstWhere(
      (s) => s.id == 'snk-21',
      orElse: () => sneakers.first,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _showVoiceSearchModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F172A) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            border: Border.all(color: AppColors.glassDarkBorder, width: 1.5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Listening for Sneakers...',
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Say "Air Jordan 1", "Nike Dunk", or "Running Shoes"',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColors.textSecondaryDark,
                ),
              ),
              const SizedBox(height: 32),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const RadialGradient(
                    colors: [AppColors.accentCyan, AppColors.accent],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accentCyan.withOpacity(0.5),
                      blurRadius: 28,
                      spreadRadius: 6,
                    ),
                  ],
                ),
                child: const Icon(Icons.mic_rounded, color: Colors.white, size: 36),
              ),
              const SizedBox(height: 32),
              Wrap(
                spacing: 10,
                children: ['Air Jordan 1', 'Nike Air Max', 'Adidas Samba'].map((term) {
                  return ActionChip(
                    label: Text(term),
                    labelStyle: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      _searchController.text = term;
                      setState(() {});
                    },
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLocationPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F172A) : AppColors.cardLight,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border.all(color: AppColors.glassDarkBorder),
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
              const SizedBox(height: 18),
              Text(
                'Select Delivery Location',
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 14),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.location_on_rounded, color: AppColors.accent),
                ),
                title: Text(
                  'Indore, Madhya Pradesh - 452001',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                subtitle: Text(
                  '123 MG Road • Express 24h Delivery',
                  style: GoogleFonts.inter(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
                trailing: const Icon(Icons.check_circle_rounded, color: AppColors.accent),
                onTap: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final trendingSneakers = MockData.sneakers.where((s) => s.isTrending).toList();
    final searchQuery = _searchController.text.trim().toLowerCase();
    final isSearching = searchQuery.isNotEmpty;

    final searchResults = isSearching
        ? MockData.sneakers.where((s) {
            return s.name.toLowerCase().contains(searchQuery) ||
                s.brand.toLowerCase().contains(searchQuery) ||
                s.category.toLowerCase().contains(searchQuery);
          }).toList()
        : <Sneaker>[];

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: _showLocationPicker,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: isDark ? AppColors.glassDarkBorder : AppColors.borderLight,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.location_on_rounded, size: 16, color: AppColors.accentCyan),
                            const SizedBox(width: 6),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'DELIVER TO',
                                  style: GoogleFonts.inter(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.8,
                                    color: AppColors.textSecondaryDark,
                                  ),
                                ),
                                Text(
                                  'Indore, MP',
                                  style: GoogleFonts.outfit(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? Colors.white : AppColors.textPrimaryLight,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 4),
                            Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: isDark ? Colors.white70 : Colors.black54),
                          ],
                        ),
                      ),
                    ),

                    Text(
                      'SNEAKR',
                      style: GoogleFonts.outfit(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 3.5,
                        color: isDark ? Colors.white : AppColors.textPrimaryLight,
                      ),
                    ),

                    Row(
                      children: [
                        Consumer<NotificationProvider>(
                          builder: (context, notifProvider, _) {
                            final unread = notifProvider.unreadCount;
                            return IconButton(
                              icon: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isDark ? AppColors.glassDarkBorder : AppColors.borderLight,
                                      ),
                                    ),
                                    child: const Icon(Icons.notifications_none_rounded, size: 18),
                                  ),
                                  if (unread > 0)
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: AppColors.accentCyan,
                                          shape: BoxShape.circle,
                                        ),
                                        constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                                      ),
                                    ),
                                ],
                              ),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                                );
                              },
                            );
                          },
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () => widget.onTabSelected?.call(4),
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [AppColors.accentCyan, AppColors.accent],
                              ),
                            ),
                            child: const CircleAvatar(
                              radius: 17,
                              backgroundColor: Color(0xFF0B0F19),
                              child: Icon(Icons.person_rounded, size: 18, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Container(
                  height: 52,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(
                      color: isSearching ? AppColors.accentCyan : (isDark ? AppColors.glassDarkBorder : AppColors.borderLight),
                      width: isSearching ? 1.5 : 1.0,
                    ),
                    boxShadow: isSearching
                        ? [
                            BoxShadow(
                              color: AppColors.accentCyan.withOpacity(0.25),
                              blurRadius: 16,
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search_rounded, size: 22, color: AppColors.accentCyan),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          focusNode: _searchFocusNode,
                          onChanged: (_) => setState(() {}),
                          onSubmitted: (val) {
                            if (val.trim().isNotEmpty) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => SearchScreen(initialQuery: val.trim()),
                                ),
                              );
                            }
                          },
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isDark ? Colors.white : AppColors.textPrimaryLight,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search Nike, Jordan, Travis Scott...',
                            hintStyle: GoogleFonts.inter(
                              fontSize: 13.5,
                              color: isDark ? AppColors.textSecondaryDark : AppColors.textMutedLight,
                            ),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                        ),
                      ),
                      if (isSearching)
                        GestureDetector(
                          onTap: () {
                            _searchController.clear();
                            setState(() {});
                          },
                          child: const Icon(Icons.close_rounded, size: 18),
                        )
                      else ...[
                        IconButton(
                          icon: const Icon(Icons.mic_none_rounded, size: 21, color: AppColors.accent),
                          tooltip: 'Voice Search',
                          onPressed: _showVoiceSearchModal,
                        ),
                        IconButton(
                          icon: const Icon(Icons.tune_rounded, size: 20, color: AppColors.textSecondaryDark),
                          tooltip: 'Filters',
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => SearchScreen(initialQuery: _searchController.text.trim()),
                              ),
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              if (isSearching) ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Found ${searchResults.length} Match(es)',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : AppColors.textPrimaryLight,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                        child: const Text('Clear', style: TextStyle(color: AppColors.accentCyan)),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: searchResults.length,
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 250,
                      mainAxisExtent: 315,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemBuilder: (context, index) {
                      return SneakerFlipCard(
                        sneaker: searchResults[index],
                        enableFlip: true,
                      );
                    },
                  ),
                ),
              ] else ...[
                // Hero Spotlight Drop Sneaker
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => ProductDetailsScreen(sneaker: _heroSneaker),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isDark
                              ? [const Color(0xFF131D33), const Color(0xFF0F172A)]
                              : [const Color(0xFFFFFFFF), const Color(0xFFF1F5F9)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: isDark ? AppColors.glassDarkBorder : AppColors.borderLight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isDark
                                ? Colors.black.withOpacity(0.4)
                                : Colors.black.withOpacity(0.06),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Top Header
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: AppColors.accent.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: AppColors.accent.withOpacity(0.35)),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.flash_on_rounded, size: 14, color: AppColors.accentCyan),
                                      const SizedBox(width: 4),
                                      Text(
                                        'LIMITED DROP #01',
                                        style: GoogleFonts.outfit(
                                          fontSize: 10.5,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 1.0,
                                          color: AppColors.accentCyan,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: isDark ? Colors.white10 : Colors.black.withOpacity(0.06),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.star_rounded, size: 14, color: Color(0xFFFFB800)),
                                      const SizedBox(width: 3),
                                      Text(
                                        '${_heroSneaker.rating}',
                                        style: GoogleFonts.inter(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: isDark ? Colors.white : AppColors.textPrimaryLight,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Large Crisp Sneaker Showcase
                          Container(
                            height: 200,
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Text(
                                  _heroSneaker.brand.toUpperCase(),
                                  style: GoogleFonts.outfit(
                                    fontSize: 54,
                                    fontWeight: FontWeight.w900,
                                    color: (isDark ? Colors.white : Colors.black).withOpacity(0.04),
                                    letterSpacing: 6,
                                  ),
                                ),
                                Hero(
                                  tag: 'hero_spotlight_${_heroSneaker.id}',
                                  child: SneakerImage(
                                    imagePath: _heroSneaker.image,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Bottom Info & CTA
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _heroSneaker.brand.toUpperCase(),
                                        style: GoogleFonts.inter(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.accentCyan,
                                          letterSpacing: 1.0,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        _heroSneaker.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.outfit(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                          color: isDark ? Colors.white : AppColors.textPrimaryLight,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '₹${_heroSneaker.price.toStringAsFixed(0)}',
                                        style: GoogleFonts.outfit(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w800,
                                          color: const Color(0xFF10B981),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => ProductDetailsScreen(sneaker: _heroSneaker),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                                  label: Text(
                                    'VIEW DROP',
                                    style: GoogleFonts.outfit(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.accent,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                    elevation: 6,
                                    shadowColor: AppColors.accent.withOpacity(0.4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Category Pills
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Collections',
                        style: GoogleFonts.outfit(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: isDark ? Colors.white : AppColors.textPrimaryLight,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => widget.onTabSelected?.call(1),
                        child: Text(
                          'View All',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.accentCyan,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: _categories.map((cat) {
                      final isSelected = _selectedCategory == cat;
                      return GestureDetector(
                        onTap: () {
                          setState(() => _selectedCategory = cat);
                          if (cat != 'All') {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => ProductListScreen(title: cat),
                              ),
                            );
                          }
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.accent
                                : (isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9)),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.accentCyan
                                  : (isDark ? AppColors.glassDarkBorder : AppColors.borderLight),
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: AppColors.accent.withOpacity(0.4),
                                      blurRadius: 14,
                                    ),
                                  ]
                                : null,
                          ),
                          child: Text(
                            cat,
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              color: isSelected
                                  ? Colors.white
                                  : (isDark ? AppColors.textSecondaryDark : AppColors.textPrimaryLight),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 24),

                // Top Items Slider
                const TopItemsSlider(),
                const SizedBox(height: 28),

                // Trending Heat
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.local_fire_department_rounded, color: AppColors.favoriteRed, size: 22),
                          const SizedBox(width: 6),
                          Text(
                            'Trending Heat',
                            style: GoogleFonts.outfit(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: isDark ? Colors.white : AppColors.textPrimaryLight,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const ProductListScreen(title: 'Trending Heat'),
                            ),
                          );
                        },
                        child: Text(
                          'See All',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.accentCyan,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  height: 330,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    scrollDirection: Axis.horizontal,
                    itemCount: trendingSneakers.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 16),
                    itemBuilder: (context, index) {
                      return SneakerFlipCard(
                        sneaker: trendingSneakers[index],
                        width: 235,
                        height: 320,
                        enableFlip: true,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 30),

                // New Arrivals
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.auto_awesome_rounded, color: AppColors.accentCyan, size: 20),
                          const SizedBox(width: 6),
                          Text(
                            'New Arrivals',
                            style: GoogleFonts.outfit(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: isDark ? Colors.white : AppColors.textPrimaryLight,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const ProductListScreen(title: 'New Arrivals'),
                            ),
                          );
                        },
                        child: Text(
                          'See All',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.accentCyan,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: MockData.sneakers.take(6).length,
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 250,
                      mainAxisExtent: 310,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemBuilder: (context, index) {
                      return SneakerFlipCard(
                        sneaker: MockData.sneakers[index],
                        enableFlip: true,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
// ============================================================================
// [END] FILE: home_screen.dart
// ============================================================================

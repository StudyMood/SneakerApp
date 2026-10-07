import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../data/mock_data.dart';
import '../models/sneaker.dart';
import '../providers/wishlist_provider.dart';
import '../widgets/sneaker_image.dart';
import 'product_details_screen.dart';

class SearchScreen extends StatefulWidget {
  final String? initialQuery;

  const SearchScreen({super.key, this.initialQuery});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController _searchController;
  String _selectedTab = 'All';
  final List<String> _tabs = ['All', 'Products', 'Categories', 'Brands'];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery ?? '');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Sneaker> get _filteredSneakers {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      return MockData.sneakers;
    }
    return MockData.sneakers.where((s) {
      return s.name.toLowerCase().contains(query) ||
          s.brand.toLowerCase().contains(query) ||
          s.category.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currencyFormatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Search Bar Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Expanded(
                    child: Container(
                      height: 46,
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceDark : const Color(0xFFF3F3F5),
                        borderRadius: BorderRadius.circular(23),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Row(
                        children: [
                          const Icon(Icons.search_rounded, size: 20, color: Color(0xFF8E8E93)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              autofocus: false,
                              onChanged: (_) => setState(() {}),
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: isDark ? Colors.white : AppColors.textPrimaryLight,
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Search sneakers...',
                                border: InputBorder.none,
                                isDense: true,
                              ),
                            ),
                          ),
                          if (_searchController.text.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                _searchController.clear();
                                setState(() {});
                              },
                              child: const Icon(Icons.cancel_rounded, size: 18, color: Color(0xFF8E8E93)),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(50, 36),
                    ),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : AppColors.textPrimaryLight,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Filter Tabs Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: _tabs.map((tab) {
                  final isSelected = _selectedTab == tab;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedTab = tab),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? (isDark ? Colors.white : AppColors.primary)
                            : (isDark ? AppColors.surfaceDark : const Color(0xFFF3F3F5)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        tab,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? (isDark ? AppColors.primary : Colors.white)
                              : (isDark ? Colors.white70 : const Color(0xFF767676)),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 8),

            // Search Results List
            Expanded(
              child: _filteredSneakers.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off_rounded, size: 64, color: Colors.grey.withOpacity(0.4)),
                          const SizedBox(height: 12),
                          Text(
                            'No sneakers found for "${_searchController.text}"',
                            style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF767676)),
                          ),
                        ],
                      ),
                    )
                  : Consumer<WishlistProvider>(
                      builder: (context, wishlist, child) {
                        return ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          itemCount: _filteredSneakers.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final sneaker = _filteredSneakers[index];
                            final isFav = wishlist.isFavorite(sneaker.id);

                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => ProductDetailsScreen(sneaker: sneaker),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isDark ? AppColors.surfaceDark : const Color(0xFFFAFAFA),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isDark ? AppColors.borderDark : const Color(0xFFEEEEEE),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    // Thumbnail
                                    Container(
                                      width: 70,
                                      height: 70,
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: isDark ? const Color(0xFF161616) : const Color(0xFFF3F3F5),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: SneakerImage(
                                        imagePath: sneaker.image,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    const SizedBox(width: 14),

                                    // Info
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            sneaker.name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.inter(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              color: isDark ? Colors.white : AppColors.textPrimaryLight,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            currencyFormatter.format(sneaker.price),
                                            style: GoogleFonts.inter(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w800,
                                              color: isDark ? Colors.white : AppColors.textPrimaryLight,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Favorite Heart
                                    IconButton(
                                      icon: Icon(
                                        isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                        color: isFav ? AppColors.accent : const Color(0xFF8E8E93),
                                        size: 20,
                                      ),
                                      onPressed: () {
                                        wishlist.toggleWishlist(sneaker);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

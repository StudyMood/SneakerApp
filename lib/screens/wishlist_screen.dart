// ============================================================================
// [START] FILE: wishlist_screen.dart
// ============================================================================

// ============================================================================
// [START] IMPORTS
// ============================================================================
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../providers/wishlist_provider.dart';
import '../widgets/sneaker_image.dart';
import 'product_details_screen.dart';
// ============================================================================
// [END] IMPORTS
// ============================================================================

// ============================================================================
// [START] WISHLIST SCREEN WIDGET
// ============================================================================
class WishlistScreen extends StatelessWidget {
  final bool showBackButton;

  const WishlistScreen({super.key, this.showBackButton = true});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currencyFormatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

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
          'My Wishlist',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<WishlistProvider>(
        builder: (context, wishlist, child) {
          if (wishlist.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_outline_rounded,
                    size: 70,
                    color: isDark ? Colors.white24 : Colors.black12,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Your wishlist is empty',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Save your favorite sneakers to buy later',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textMutedLight,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            itemCount: wishlist.items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final sneaker = wishlist.items[index];

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
                    color: isDark ? AppColors.surfaceDark : AppColors.cardLight,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? AppColors.borderDark : AppColors.borderLight,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Thumbnail
                      Container(
                        width: 75,
                        height: 75,
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.cardGreyDark : AppColors.cardGreyLight,
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
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              currencyFormatter.format(sneaker.price),
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Red Heart Icon Button
                      IconButton(
                        icon: const Icon(
                          Icons.favorite_rounded,
                          color: AppColors.accent,
                          size: 22,
                        ),
                        onPressed: () {
                          wishlist.removeFromWishlist(sneaker.id);
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
    );
  }
}
// ============================================================================
// [END] WISHLIST SCREEN WIDGET
// ============================================================================

// ============================================================================
// [END] FILE: wishlist_screen.dart
// ============================================================================

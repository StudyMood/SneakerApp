// ============================================================================
// [START] FILE: cart_screen.dart
// ============================================================================
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../providers/cart_provider.dart';
import '../widgets/sneaker_image.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  final bool showBackButton;

  const CartScreen({super.key, this.showBackButton = true});

  void _showPromoDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: const BorderSide(color: AppColors.glassDarkBorder),
          ),
          title: Text(
            'Apply Promo Code',
            style: GoogleFonts.outfit(fontWeight: FontWeight.w700),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'e.g. SNEAKER20',
                  filled: true,
                  fillColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
                textCapitalization: TextCapitalization.characters,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: ['SNEAKER20', 'DISCOUNT20'].map((code) {
                  return ActionChip(
                    label: Text(code),
                    labelStyle: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700),
                    backgroundColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                    onPressed: () {
                      controller.text = code;
                    },
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final success = ctx.read<CartProvider>().applyPromoCode(controller.text);
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success ? 'Promo code applied: 20% OFF!' : 'Invalid Promo Code',
                    ),
                    backgroundColor: success ? AppColors.statusSuccess : AppColors.favoriteRed,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currencyFormatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: showBackButton
            ? IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                    shape: BoxShape.circle,
                    border: Border.all(color: isDark ? AppColors.glassDarkBorder : AppColors.borderLight),
                  ),
                  child: const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
                ),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
        title: Text(
          'Shopping Cart',
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : AppColors.textPrimaryLight,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          if (cart.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                      shape: BoxShape.circle,
                      border: Border.all(color: isDark ? AppColors.glassDarkBorder : AppColors.borderLight),
                    ),
                    child: Icon(
                      Icons.shopping_bag_outlined,
                      size: 64,
                      color: AppColors.accentCyan.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Your Cart is Empty',
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Explore the latest sneaker drops and add your favorites.',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.textSecondaryDark,
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  physics: const BouncingScrollPhysics(),
                  itemCount: cart.items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    final sneaker = item.sneaker;

                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF0F172A) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isDark ? AppColors.glassDarkBorder : AppColors.borderLight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Sneaker Thumbnail
                          Container(
                            width: 85,
                            height: 85,
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: SneakerImage(
                              imagePath: sneaker.image,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(width: 14),

                          // Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  sneaker.brand.toUpperCase(),
                                  style: GoogleFonts.inter(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.accentCyan,
                                    letterSpacing: 1.0,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  sneaker.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.outfit(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: isDark ? Colors.white : AppColors.textPrimaryLight,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        'UK ${item.size}',
                                        style: GoogleFonts.inter(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      currencyFormatter.format(sneaker.price),
                                      style: GoogleFonts.outfit(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.accentCyan,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Quantity Stepper Controls
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              IconButton(
                                visualDensity: VisualDensity.compact,
                                icon: const Icon(Icons.delete_outline_rounded, size: 20, color: AppColors.favoriteRed),
                                onPressed: () => cart.removeItem(item),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GestureDetector(
                                      onTap: () => cart.decrementQuantity(item),
                                      child: const Padding(
                                        padding: EdgeInsets.all(4),
                                        child: Icon(Icons.remove, size: 14),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                      child: Text(
                                        '${item.quantity}',
                                        style: GoogleFonts.outfit(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => cart.incrementQuantity(item),
                                      child: const Padding(
                                        padding: EdgeInsets.all(4),
                                        child: Icon(Icons.add, size: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Bottom Order Summary & Checkout Card
              Container(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A) : Colors.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                  border: Border.all(
                    color: isDark ? AppColors.glassDarkBorder : AppColors.borderLight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 24,
                      offset: const Offset(0, -6),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      // Promo Code Banner
                      GestureDetector(
                        onTap: () => _showPromoDialog(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: AppColors.accentCyan.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.discount_outlined, color: AppColors.accentCyan, size: 18),
                                  const SizedBox(width: 8),
                                  Text(
                                    cart.appliedPromo != null ? 'Promo Code: ${cart.appliedPromo}' : 'Have a Promo Code?',
                                    style: GoogleFonts.inter(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w600,
                                      color: isDark ? Colors.white : AppColors.textPrimaryLight,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                cart.appliedPromo != null ? 'Applied' : 'Apply',
                                style: GoogleFonts.outfit(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.accentCyan,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Order Summary Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'TOTAL AMOUNT',
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textSecondaryDark,
                                  letterSpacing: 0.8,
                                ),
                              ),
                              Text(
                                currencyFormatter.format(cart.total),
                                style: GoogleFonts.outfit(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.accentCyan,
                                ),
                              ),
                            ],
                          ),

                          // Checkout Button
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(builder: (_) => const CheckoutScreen()),
                              );
                            },
                            icon: const Icon(Icons.lock_outline_rounded, size: 18),
                            label: Text(
                              'CHECKOUT',
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.8,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accent,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                              elevation: 8,
                              shadowColor: AppColors.accent.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
// ============================================================================
// [END] FILE: cart_screen.dart
// ============================================================================

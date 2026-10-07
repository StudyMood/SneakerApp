// ============================================================================
// [START] FILE: product_details_screen.dart
// ============================================================================
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../data/mock_data.dart';
import '../models/sneaker.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';
import '../widgets/sneaker_image.dart';
import 'cart_screen.dart';
import 'checkout_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Sneaker sneaker;

  const ProductDetailsScreen({
    super.key,
    required this.sneaker,
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen>
    with SingleTickerProviderStateMixin {
  late Sneaker _currentSneaker;
  late int _selectedSize;
  int _selectedColorIndex = 0;
  late List<Sneaker> _colorVariants;
  final List<int> _allSizes = [6, 7, 8, 9, 10, 11, 12];

  late PageController _galleryPageController;
  int _currentImageIndex = 0;

  List<String> get _allImages {
    final list = <String>[];
    if (_currentSneaker.image.isNotEmpty) list.add(_currentSneaker.image);
    for (final img in _currentSneaker.galleryImages) {
      if (!list.contains(img) && img.isNotEmpty) {
        list.add(img);
      }
    }
    return list.isNotEmpty ? list : [_currentSneaker.image];
  }

  @override
  void initState() {
    super.initState();
    _currentSneaker = widget.sneaker;
    _galleryPageController = PageController();
    _selectedSize = _currentSneaker.sizes.isNotEmpty ? _currentSneaker.sizes.first : 8;

    final sameBrand = MockData.sneakers.where((s) => s.brand == _currentSneaker.brand).toList();
    _colorVariants = sameBrand.isNotEmpty ? sameBrand : MockData.sneakers.take(5).toList();
    if (!_colorVariants.any((s) => s.id == _currentSneaker.id)) {
      _colorVariants.insert(0, _currentSneaker);
    }
    _selectedColorIndex = _colorVariants.indexWhere((s) => s.id == _currentSneaker.id);
    if (_selectedColorIndex == -1) _selectedColorIndex = 0;
  }

  @override
  void dispose() {
    _galleryPageController.dispose();
    super.dispose();
  }

  void _showSizeGuide() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F172A) : Colors.white,
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
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Size Conversion Matrix (UK / IND / US / EU)',
                style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 14),
              Table(
                border: TableBorder.all(color: Colors.grey.withOpacity(0.2)),
                children: const [
                  TableRow(children: [
                    Padding(padding: EdgeInsets.all(8), child: Text('UK / IND', style: TextStyle(fontWeight: FontWeight.bold))),
                    Padding(padding: EdgeInsets.all(8), child: Text('US Men', style: TextStyle(fontWeight: FontWeight.bold))),
                    Padding(padding: EdgeInsets.all(8), child: Text('EU', style: TextStyle(fontWeight: FontWeight.bold))),
                    Padding(padding: EdgeInsets.all(8), child: Text('CM', style: TextStyle(fontWeight: FontWeight.bold))),
                  ]),
                  TableRow(children: [
                    Padding(padding: EdgeInsets.all(8), child: Text('7')),
                    Padding(padding: EdgeInsets.all(8), child: Text('7.5')),
                    Padding(padding: EdgeInsets.all(8), child: Text('40.5')),
                    Padding(padding: EdgeInsets.all(8), child: Text('25.5')),
                  ]),
                  TableRow(children: [
                    Padding(padding: EdgeInsets.all(8), child: Text('8')),
                    Padding(padding: EdgeInsets.all(8), child: Text('8.5')),
                    Padding(padding: EdgeInsets.all(8), child: Text('42')),
                    Padding(padding: EdgeInsets.all(8), child: Text('26.5')),
                  ]),
                  TableRow(children: [
                    Padding(padding: EdgeInsets.all(8), child: Text('9')),
                    Padding(padding: EdgeInsets.all(8), child: Text('9.5')),
                    Padding(padding: EdgeInsets.all(8), child: Text('43')),
                    Padding(padding: EdgeInsets.all(8), child: Text('27.5')),
                  ]),
                  TableRow(children: [
                    Padding(padding: EdgeInsets.all(8), child: Text('10')),
                    Padding(padding: EdgeInsets.all(8), child: Text('10.5')),
                    Padding(padding: EdgeInsets.all(8), child: Text('44.5')),
                    Padding(padding: EdgeInsets.all(8), child: Text('28.5')),
                  ]),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _addToCart() {
    context.read<CartProvider>().addItem(_currentSneaker, _selectedSize);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added ${_currentSneaker.name} (UK $_selectedSize) to cart'),
        backgroundColor: AppColors.accent,
        action: SnackBarAction(
          label: 'View Cart',
          textColor: Colors.white,
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const CartScreen(showBackButton: true)),
            );
          },
        ),
      ),
    );
  }

  void _buyNow() {
    context.read<CartProvider>().addItem(_currentSneaker, _selectedSize);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const CheckoutScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currencyFormatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);
    final originalPrice = _currentSneaker.price * 1.35;
    final wishlist = context.watch<WishlistProvider>();
    final isFav = wishlist.isFavorite(_currentSneaker.id);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
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
        ),
        title: Text(
          _currentSneaker.brand.toUpperCase(),
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            letterSpacing: 2,
            color: AppColors.accentCyan,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                shape: BoxShape.circle,
                border: Border.all(color: isDark ? AppColors.glassDarkBorder : AppColors.borderLight),
              ),
              child: Icon(
                isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                size: 18,
                color: isFav ? AppColors.favoriteRed : (isDark ? Colors.white70 : Colors.black54),
              ),
            ),
            onPressed: () => wishlist.toggleWishlist(_currentSneaker),
          ),
          Consumer<CartProvider>(
            builder: (context, cart, _) => Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                      shape: BoxShape.circle,
                      border: Border.all(color: isDark ? AppColors.glassDarkBorder : AppColors.borderLight),
                    ),
                    child: Icon(Icons.shopping_bag_outlined, size: 18, color: isDark ? Colors.white70 : Colors.black87),
                  ),
                  tooltip: 'Go to Cart',
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const CartScreen()),
                    );
                  },
                ),
                if (cart.totalItemCount > 0)
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                      child: Text(
                        '${cart.totalItemCount}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- 1. Smooth High-Resolution Sneaker Gallery Stage ---
                  _buildProductGallery(isDark),
                  const SizedBox(height: 20),

                  // --- 2. Title, Rating & Price Header ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _currentSneaker.category.toUpperCase(),
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.accentCyan,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _currentSneaker.name,
                              style: GoogleFonts.outfit(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: isDark ? Colors.white : AppColors.textPrimaryLight,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.accent.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star_rounded, size: 16, color: AppColors.starYellow),
                            const SizedBox(width: 4),
                            Text(
                              '${_currentSneaker.rating} (${_currentSneaker.reviewCount})',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Price Row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        currencyFormatter.format(_currentSneaker.price),
                        style: GoogleFonts.outfit(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: AppColors.accentCyan,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        currencyFormatter.format(originalPrice),
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          color: AppColors.textSecondaryDark,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.statusSuccess.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '25% OFF',
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: AppColors.statusSuccess,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // --- 3. Colorway Selector ---
                  Text(
                    'Colorway Editions',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 75,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _colorVariants.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final variant = _colorVariants[index];
                        final isSelected = variant.id == _currentSneaker.id;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _currentSneaker = variant;
                              _selectedColorIndex = index;
                              _currentImageIndex = 0;
                            });
                            if (_galleryPageController.hasClients) {
                              _galleryPageController.jumpToPage(0);
                            }
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 75,
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected ? AppColors.accentCyan : Colors.transparent,
                                width: 2,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: AppColors.accentCyan.withOpacity(0.35),
                                        blurRadius: 10,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: SneakerImage(
                              imagePath: variant.image,
                              fit: BoxFit.contain,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                  // --- 4. Size Selector ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Select Size (UK / IND)',
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : AppColors.textPrimaryLight,
                        ),
                      ),
                      GestureDetector(
                        onTap: _showSizeGuide,
                        child: Text(
                          'Size Guide',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.accentCyan,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _allSizes.map((size) {
                      final isSelected = _selectedSize == size;
                      final isAvailable = _currentSneaker.sizes.contains(size);

                      return GestureDetector(
                        onTap: () {
                          if (isAvailable) {
                            setState(() => _selectedSize = size);
                          }
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.accent
                                : (isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9)),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.accentCyan
                                  : (isDark ? AppColors.glassDarkBorder : AppColors.borderLight),
                              width: 1.2,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: AppColors.accent.withOpacity(0.4),
                                      blurRadius: 12,
                                    ),
                                  ]
                                : null,
                          ),
                          child: Opacity(
                            opacity: isAvailable ? 1.0 : 0.35,
                            child: Text(
                              'UK $size',
                              style: GoogleFonts.outfit(
                                fontSize: 13.5,
                                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                color: isSelected
                                  ? Colors.white
                                  : (isDark ? Colors.white70 : AppColors.textPrimaryLight),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  // --- 5. Tech Breakdown Cards ---
                  Text(
                    'Engineering & Materials',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0F172A) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDark ? AppColors.glassDarkBorder : AppColors.borderLight,
                      ),
                    ),
                    child: Column(
                      children: _currentSneaker.specs.entries.map((e) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                e.key,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: AppColors.textSecondaryDark,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                e.value,
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: isDark ? Colors.white : AppColors.textPrimaryLight,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // --- 6. Description ---
                  Text(
                    'Overview',
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _currentSneaker.description,
                    style: GoogleFonts.inter(
                      fontSize: 13.5,
                      height: 1.5,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),

          // --- 7. Floating Glassmorphic Sticky Bottom Bar ---
          Container(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xE60A0E1A) : Colors.white.withOpacity(0.95),
              border: Border(
                top: BorderSide(
                  color: isDark ? AppColors.glassDarkBorder : AppColors.borderLight,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 20,
                  offset: const Offset(0, -6),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _addToCart,
                      icon: const Icon(Icons.shopping_bag_outlined, size: 18),
                      label: Text(
                        'ADD TO CART',
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: isDark ? Colors.white : AppColors.textPrimaryLight,
                        side: BorderSide(
                          color: isDark ? AppColors.accentCyan : AppColors.primary,
                          width: 1.5,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _buyNow,
                      icon: const Icon(Icons.bolt_rounded, size: 20),
                      label: Text(
                        'BUY NOW',
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                        elevation: 8,
                        shadowColor: AppColors.accent.withOpacity(0.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGallery(bool isDark) {
    final images = _allImages;

    return Container(
      height: 360,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF131D33) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: isDark ? AppColors.glassDarkBorder : AppColors.borderLight,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.4)
                : Colors.black.withOpacity(0.06),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Watermark Brand
          Positioned.fill(
            child: Center(
              child: Text(
                _currentSneaker.brand.toUpperCase(),
                style: GoogleFonts.outfit(
                  fontSize: 68,
                  fontWeight: FontWeight.w900,
                  color: (isDark ? Colors.white : Colors.black).withOpacity(0.04),
                  letterSpacing: 6,
                ),
              ),
            ),
          ),

          // Swipeable Image View with Pinch-to-Zoom
          PageView.builder(
            controller: _galleryPageController,
            itemCount: images.length,
            onPageChanged: (idx) {
              setState(() => _currentImageIndex = idx);
            },
            itemBuilder: (context, idx) {
              return InteractiveViewer(
                minScale: 1.0,
                maxScale: 2.5,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 36.0),
                  child: Center(
                    child: SneakerImage(
                      imagePath: images[idx],
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              );
            },
          ),

          // Top Left Authentic Pill
          Positioned(
            top: 14,
            left: 14,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xCC0F172A) : const Color(0xCCFFFFFF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? AppColors.glassDarkBorder : AppColors.borderLight,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.verified_rounded, size: 13, color: AppColors.accent),
                  const SizedBox(width: 4),
                  Text(
                    '100% VERIFIED',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.6,
                      color: isDark ? Colors.white : AppColors.textPrimaryLight,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Top Right Count Pill
          Positioned(
            top: 14,
            right: 14,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${_currentImageIndex + 1} / ${images.length}',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // Bottom Angle Labels Bar
          Positioned(
            bottom: 12,
            left: 12,
            right: 12,
            child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(images.length, (idx) {
                    final isSelected = _currentImageIndex == idx;
                    final label = idx < _currentSneaker.angleLabels.length
                        ? _currentSneaker.angleLabels[idx]
                        : 'View ${idx + 1}';

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      child: GestureDetector(
                        onTap: () {
                          _galleryPageController.animateToPage(
                            idx,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOutCubic,
                          );
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.accent
                                : (isDark ? const Color(0xCC0F172A) : const Color(0xCCFFFFFF)),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.accent
                                  : (isDark ? Colors.white12 : Colors.black12),
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: AppColors.accent.withOpacity(0.35),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Text(
                            label,
                            style: GoogleFonts.inter(
                              fontSize: 10.5,
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              color: isSelected
                                  ? Colors.white
                                  : (isDark ? Colors.white70 : Colors.black87),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// ============================================================================
// [END] FILE: product_details_screen.dart
// ============================================================================

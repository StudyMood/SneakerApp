// ============================================================================
// [START] FILE: sneaker_flip_card.dart
// ============================================================================
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../models/sneaker.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';
import '../screens/product_details_screen.dart';
import 'sneaker_image.dart';

class SneakerFlipCard extends StatefulWidget {
  final Sneaker sneaker;
  final double? width;
  final double? height;
  final bool enableFlip;

  const SneakerFlipCard({
    super.key,
    required this.sneaker,
    this.width,
    this.height,
    this.enableFlip = true,
  });

  @override
  State<SneakerFlipCard> createState() => _SneakerFlipCardState();
}

class _SneakerFlipCardState extends State<SneakerFlipCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;
  bool _isBackVisible = false;

  // 3D Card Hover & Parallax Tilt State
  double _tiltX = 0.0;
  double _tiltY = 0.0;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );

    _flipAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOutCubic),
    );

    _flipAnimation.addListener(() {
      if (_flipAnimation.value >= 0.5 && !_isBackVisible) {
        setState(() => _isBackVisible = true);
      } else if (_flipAnimation.value < 0.5 && _isBackVisible) {
        setState(() => _isBackVisible = false);
      }
    });
  }

  void _flipCard() {
    if (!widget.enableFlip) return;
    if (_flipController.isCompleted) {
      _flipController.reverse();
    } else {
      _flipController.forward();
    }
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _onPointerHover(PointerEvent details, BoxConstraints constraints) {
    final w = constraints.maxWidth > 0 ? constraints.maxWidth : (widget.width ?? 220);
    final h = constraints.maxHeight > 0 ? constraints.maxHeight : (widget.height ?? 310);
    final dx = (details.localPosition.dx - (w / 2)) / (w / 2);
    final dy = (details.localPosition.dy - (h / 2)) / (h / 2);

    setState(() {
      _isHovered = true;
      _tiltY = dx.clamp(-1.0, 1.0) * 0.12;
      _tiltX = -dy.clamp(-1.0, 1.0) * 0.12;
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
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currencyFormatter =
        NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    return LayoutBuilder(
      builder: (context, constraints) {
        return MouseRegion(
          onHover: (e) => _onPointerHover(e, constraints),
          onExit: _onPointerExit,
          child: AnimatedBuilder(
            animation: _flipAnimation,
            builder: (context, child) {
              final flipAngle = _flipAnimation.value * math.pi;

              // Combined 3D Perspective + Hover Tilt Transform
              final transform = Matrix4.identity()
                ..setEntry(3, 2, 0.0012)
                ..rotateX(_tiltX)
                ..rotateY(flipAngle + _tiltY);

              return Transform(
                transform: transform,
                alignment: Alignment.center,
                child: _isBackVisible
                    ? Transform(
                        transform: Matrix4.identity()..rotateY(math.pi),
                        alignment: Alignment.center,
                        child: _buildCardBack(isDark, currencyFormatter),
                      )
                    : _buildCardFront(isDark, currencyFormatter),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildCardFront(bool isDark, NumberFormat currencyFormatter) {
    return Consumer<WishlistProvider>(
      builder: (context, wishlist, child) {
        final isFav = wishlist.isFavorite(widget.sneaker.id);

        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F172A) : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: _isHovered
                  ? AppColors.accentCyan.withOpacity(0.5)
                  : (isDark ? AppColors.glassDarkBorder : AppColors.borderLight),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.35 : 0.06),
                blurRadius: _isHovered ? 24 : 16,
                offset: Offset(0, _isHovered ? 10 : 6),
              ),
              if (_isHovered)
                BoxShadow(
                  color: AppColors.accentCyan.withOpacity(0.18),
                  blurRadius: 20,
                  spreadRadius: -2,
                ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              ProductDetailsScreen(sneaker: widget.sneaker),
                        ),
                      );
                    },
                    child: Container(
                      height: 165,
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF172033)
                            : const Color(0xFFF1F5F9),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(23),
                          topRight: Radius.circular(23),
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Dynamic Background Glow Orb on Hover
                          if (_isHovered)
                            Positioned(
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      AppColors.accentCyan.withOpacity(0.25),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ),

                          // 3D Floating Pop-out Sneaker Image
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            transform: Matrix4.identity()
                              ..translate(0.0, _isHovered ? -6.0 : 0.0)
                              ..scale(_isHovered ? 1.06 : 1.0),
                            child: Hero(
                              tag: 'sneaker-flip-${widget.sneaker.id}',
                              child: SneakerImage(
                                imagePath: widget.sneaker.image,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 3D Specs Quick Flip Button
                  if (widget.enableFlip)
                    Positioned(
                      top: 10,
                      left: 10,
                      child: GestureDetector(
                        onTap: _flipCard,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xCC000000)
                                : Colors.white.withOpacity(0.92),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.accentCyan.withOpacity(0.45),
                              width: 0.9,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.accentCyan.withOpacity(0.2),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.threed_rotation_rounded,
                                size: 13,
                                color: AppColors.accentCyan,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '3D SPECS',
                                style: GoogleFonts.outfit(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.6,
                                  color: AppColors.accentCyan,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                  // Favorite Button
                  Positioned(
                    top: 10,
                    right: 10,
                    child: InkWell(
                      onTap: () => wishlist.toggleWishlist(widget.sneaker),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xCC000000)
                              : Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isFav
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          size: 16,
                          color: isFav
                              ? AppColors.favoriteRed
                              : (isDark ? Colors.white70 : AppColors.textPrimaryLight),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Bottom Info Section
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.sneaker.brand.toUpperCase(),
                                style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.0,
                                  color: AppColors.accentCyan,
                                ),
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.star_rounded,
                                      size: 14, color: AppColors.starYellow),
                                  const SizedBox(width: 2),
                                  Text(
                                    '${widget.sneaker.rating}',
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: isDark
                                          ? Colors.white
                                          : AppColors.textPrimaryLight,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.sneaker.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.outfit(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? Colors.white
                                  : AppColors.textPrimaryLight,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            currencyFormatter.format(widget.sneaker.price),
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: AppColors.accentCyan,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => ProductDetailsScreen(
                                      sneaker: widget.sneaker),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(7),
                              decoration: BoxDecoration(
                                color: AppColors.accent,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.accent.withOpacity(0.4),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.arrow_forward_rounded,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCardBack(bool isDark, NumberFormat currencyFormatter) {
    return Container(
      width: widget.width,
      height: widget.height,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? AppColors.accentCyan.withOpacity(0.45)
              : AppColors.borderLight,
          width: 1.4,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentCyan.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.sneaker.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : AppColors.textPrimaryLight,
                  ),
                ),
              ),
              IconButton(
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.close_rounded, size: 20),
                onPressed: _flipCard,
              ),
            ],
          ),
          const Divider(height: 8),

          Column(
            children: widget.sneaker.specs.entries.take(4).map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${entry.key}: ',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondaryDark,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        entry.value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? Colors.white
                              : AppColors.textPrimaryLight,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                currencyFormatter.format(widget.sneaker.price),
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: AppColors.accentCyan,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<CartProvider>().addItem(
                        widget.sneaker,
                        widget.sneaker.sizes.isNotEmpty
                            ? widget.sneaker.sizes.first
                            : 8,
                      );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Added ${widget.sneaker.name} to cart'),
                      backgroundColor: AppColors.accent,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  'QUICK ADD',
                  style: GoogleFonts.outfit(
                      fontSize: 11, fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
// ============================================================================
// [END] FILE: sneaker_flip_card.dart
// ============================================================================

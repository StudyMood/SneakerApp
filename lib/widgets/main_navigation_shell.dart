// ============================================================================
// [START] FILE: main_navigation_shell.dart
// ============================================================================
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';
import '../screens/home_screen.dart';
import '../screens/categories_screen.dart';
import '../screens/wishlist_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/profile_screen.dart';

class MainNavigationShell extends StatefulWidget {
  final int initialIndex;

  const MainNavigationShell({super.key, this.initialIndex = 0});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cart = context.watch<CartProvider>();
    final wishlist = context.watch<WishlistProvider>();

    final screens = [
      HomeScreen(onTabSelected: _onTabSelected),
      const CategoriesScreen(showBackButton: false),
      const WishlistScreen(showBackButton: false),
      const CartScreen(showBackButton: false),
      const ProfileScreen(),
    ];

    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xE60A0E1A) : Colors.white.withOpacity(0.92),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: isDark ? AppColors.glassDarkBorder : AppColors.borderLight,
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.18),
              blurRadius: 30,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    index: 0,
                    icon: Icons.home_outlined,
                    activeIcon: Icons.home_rounded,
                    label: 'Home',
                    isDark: isDark,
                  ),
                  _buildNavItem(
                    index: 1,
                    icon: Icons.grid_view_outlined,
                    activeIcon: Icons.grid_view_rounded,
                    label: 'Catalog',
                    isDark: isDark,
                  ),
                  _buildNavItem(
                    index: 2,
                    icon: Icons.favorite_border_rounded,
                    activeIcon: Icons.favorite_rounded,
                    label: 'Wishlist',
                    badgeCount: wishlist.items.length,
                    isDark: isDark,
                  ),
                  _buildNavItem(
                    index: 3,
                    icon: Icons.shopping_bag_outlined,
                    activeIcon: Icons.shopping_bag_rounded,
                    label: 'Cart',
                    badgeCount: cart.totalItemCount,
                    isDark: isDark,
                  ),
                  _buildNavItem(
                    index: 4,
                    icon: Icons.person_outline_rounded,
                    activeIcon: Icons.person_rounded,
                    label: 'Profile',
                    isDark: isDark,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    int badgeCount = 0,
    required bool isDark,
  }) {
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () => _onTabSelected(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.accent.withOpacity(0.18)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: isSelected
              ? Border.all(color: AppColors.accentCyan.withOpacity(0.4), width: 1)
              : null,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isSelected ? activeIcon : icon,
                  size: 22,
                  color: isSelected
                      ? AppColors.accentCyan
                      : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
                ),
                if (isSelected) ...[
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : AppColors.textPrimaryLight,
                    ),
                  ),
                ],
              ],
            ),
            if (badgeCount > 0 && !isSelected)
              Positioned(
                right: -6,
                top: -6,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppColors.accentCyan,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                  child: Text(
                    '$badgeCount',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
// ============================================================================
// [END] FILE: main_navigation_shell.dart
// ============================================================================

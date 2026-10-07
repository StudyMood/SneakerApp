// ============================================================================
// [START] FILE: admin_dashboard_screen.dart
// ============================================================================

// ============================================================================
// [START] IMPORTS
// ============================================================================
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../../models/order.dart';
import '../../models/sneaker.dart';
import '../../providers/order_provider.dart';
import '../../providers/sneaker_provider.dart';
import '../../widgets/main_navigation_shell.dart';
import '../../widgets/sneaker_image.dart';
import '../../services/firebase_service.dart';
import '../signin_screen.dart';
// ============================================================================
// [END] IMPORTS
// ============================================================================

// ============================================================================
// [START] ADMIN DASHBOARD SCREEN WIDGET (STATEFUL)
// ============================================================================
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}
// ============================================================================
// [END] ADMIN DASHBOARD SCREEN WIDGET
// ============================================================================

// ============================================================================
// [START] ADMIN DASHBOARD SCREEN STATE
// ============================================================================
class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  // Navigation Section
  String _activeSection = 'overview'; // 'overview', 'sneakers', 'orders', 'categories'

  // Sneaker Filter States
  String _sneakerSearchQuery = '';
  String _selectedBrandFilter = 'All';
  String _selectedCategoryFilter = 'All';

  final NumberFormat _currencyFormatter =
      NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

  final TextEditingController _passcodeController = TextEditingController();
  String? _passcodeError;

  @override
  void dispose() {
    _passcodeController.dispose();
    super.dispose();
  }

  // --------------------------------------------------------------------------
  // [START] ADD SNEAKER DIALOG
  // --------------------------------------------------------------------------
  void _showAddSneakerDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final imageController = TextEditingController();
    final descController = TextEditingController();

    String selectedBrand = 'Nike';
    String selectedCategory = 'Lifestyle';
    final List<int> selectedSizes = [7, 8, 9, 10, 11];

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: isDark ? AppColors.surfaceDark : AppColors.cardLight,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.flipkartBlue.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add_box_rounded, color: AppColors.flipkartBlue, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Add New Sneaker',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                width: 500,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Sneaker Name
                      _buildDialogTextField(
                        label: 'Sneaker Model Name',
                        controller: nameController,
                        hint: 'e.g. Nike Air Max Plus "Sunset"',
                        isDark: isDark,
                      ),
                      const SizedBox(height: 12),

                      // Brand & Category Dropdowns
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Brand', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: isDark ? AppColors.cardGreyDark : AppColors.cardGreyLight,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: selectedBrand,
                                      isExpanded: true,
                                      dropdownColor: isDark ? AppColors.surfaceDark : AppColors.cardLight,
                                      items: ['Nike', 'Adidas', 'Puma', 'Jordan'].map((b) {
                                        return DropdownMenuItem(value: b, child: Text(b, style: GoogleFonts.inter(fontSize: 13)));
                                      }).toList(),
                                      onChanged: (val) {
                                        if (val != null) setDialogState(() => selectedBrand = val);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Category', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: isDark ? AppColors.cardGreyDark : AppColors.cardGreyLight,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: selectedCategory,
                                      isExpanded: true,
                                      dropdownColor: isDark ? AppColors.surfaceDark : AppColors.cardLight,
                                      items: ['Lifestyle', 'Running', 'Basketball', 'Training', 'Skateboarding', 'Limited Edition'].map((c) {
                                        return DropdownMenuItem(value: c, child: Text(c, style: GoogleFonts.inter(fontSize: 13)));
                                      }).toList(),
                                      onChanged: (val) {
                                        if (val != null) setDialogState(() => selectedCategory = val);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Price Field
                      _buildDialogTextField(
                        label: 'Price in INR (₹)',
                        controller: priceController,
                        hint: 'e.g. 14999',
                        keyboardType: TextInputType.number,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 12),

                      // Image URL Field
                      _buildDialogTextField(
                        label: 'Image URL or Asset Path',
                        controller: imageController,
                        hint: 'https://images.unsplash.com/... or assets/images/...',
                        isDark: isDark,
                      ),
                      const SizedBox(height: 12),

                      // Description
                      _buildDialogTextField(
                        label: 'Product Description',
                        controller: descController,
                        hint: 'Highlight key cushioning, materials, and silhouette history...',
                        maxLines: 2,
                        isDark: isDark,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: Text('Cancel', style: GoogleFonts.inter(color: isDark ? AppColors.textSecondaryDark : AppColors.textMutedLight)),
                ),
                ElevatedButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    final price = double.tryParse(priceController.text.trim()) ?? 9999.0;
                    final image = imageController.text.trim().isNotEmpty
                        ? imageController.text.trim()
                        : 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=800&auto=format&fit=crop&q=80';
                    final desc = descController.text.trim().isNotEmpty
                        ? descController.text.trim()
                        : 'Premium sneaker with state-of-the-art responsiveness and street luxury.';

                    if (name.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please enter a sneaker model name')),
                      );
                      return;
                    }

                    final newSneaker = Sneaker(
                      id: 'snk-${DateTime.now().millisecondsSinceEpoch}',
                      name: name,
                      brand: selectedBrand,
                      category: selectedCategory,
                      price: price,
                      rating: 4.8,
                      reviewCount: 1,
                      image: image,
                      galleryImages: [image],
                      angleLabels: ['Main View', 'Side Profile'],
                      specs: {
                        'Category': selectedCategory,
                        'Brand': selectedBrand,
                        'Origin': 'Authentic Brand Factory',
                      },
                      description: desc,
                      sizes: selectedSizes,
                      isTrending: false,
                    );

                    context.read<SneakerProvider>().addSneaker(newSneaker);
                    Navigator.of(dialogContext).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Added "$name" to Catalog successfully!'),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: AppColors.statusSuccess,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.flipkartBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Add Sneaker'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // --------------------------------------------------------------------------
  // [START] EDIT PRICE DIALOG
  // --------------------------------------------------------------------------
  void _showEditPriceDialog(Sneaker sneaker) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final priceController = TextEditingController(text: sneaker.price.toStringAsFixed(0));

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: isDark ? AppColors.surfaceDark : AppColors.cardLight,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'Update Price: ${sneaker.name}',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogTextField(
                label: 'New Price (₹)',
                controller: priceController,
                keyboardType: TextInputType.number,
                isDark: isDark,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final newPrice = double.tryParse(priceController.text.trim());
                if (newPrice != null && newPrice > 0) {
                  context.read<SneakerProvider>().updatePrice(sneaker.id, newPrice);
                  Navigator.of(dialogContext).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Updated price for ${sneaker.name} to ₹$newPrice'),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: AppColors.statusSuccess,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.flipkartBlue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDialogTextField({
    required String label,
    required TextEditingController controller,
    String? hint,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: GoogleFonts.inter(fontSize: 13),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(fontSize: 12, color: isDark ? AppColors.textSecondaryDark : AppColors.textMutedLight),
            filled: true,
            fillColor: isDark ? AppColors.cardGreyDark : AppColors.cardGreyLight,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.flipkartBlue, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAccessDeniedScreen(bool isDark) {
    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded,
              color: isDark ? Colors.white : AppColors.textPrimaryLight),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const MainNavigationShell()),
              (route) => false,
            );
          },
        ),
        title: Text(
          'Security Gate',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : AppColors.textPrimaryLight,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDark : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.3 : 0.06),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.admin_panel_settings_rounded,
                      size: 48,
                      color: AppColors.accent,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Admin Access Restricted',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'This portal is reserved strictly for store owners and inventory managers. Customer accounts cannot view or modify the backend catalog.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      height: 1.5,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _passcodeController,
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    style: GoogleFonts.inter(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: 'Enter Admin Passcode (e.g. admin123)',
                      hintStyle: GoogleFonts.inter(fontSize: 12.5, color: const Color(0xFF94A3B8)),
                      prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                      filled: true,
                      fillColor: isDark ? const Color(0xFF1A1A22) : const Color(0xFFF1F5F9),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: _passcodeError != null ? AppColors.accent : Colors.transparent,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: _passcodeError != null ? AppColors.accent : Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                  if (_passcodeError != null) ...[
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        _passcodeError!,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.accent,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final entered = _passcodeController.text.trim();
                        if (FirebaseService.instance.verifyAdminPasscode(entered)) {
                          setState(() {
                            _passcodeError = null;
                          });
                        } else {
                          setState(() {
                            _passcodeError = 'Invalid admin passcode. Access denied.';
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.flipkartBlue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        'Unlock Admin Portal',
                        style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const MainNavigationShell()),
                        (route) => false,
                      );
                    },
                    child: Text(
                      'Return to Customer Store',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // [START] BUILD METHOD
  // --------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Security Gate: Protect admin dashboard from unauthorized customers
    if (!FirebaseService.instance.isAdmin) {
      return _buildAccessDeniedScreen(isDark);
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth >= 850;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF1F3F6),
      appBar: isDesktop
          ? null
          : AppBar(
              backgroundColor: isDark ? AppColors.surfaceDark : AppColors.flipkartBlue,
              elevation: 0,
              iconTheme: const IconThemeData(color: Colors.white),
              title: Text(
                'Flipkart Seller Hub • Sneakr Admin',
                style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
              ),
              actions: [
                IconButton(
                  tooltip: 'Switch to Store',
                  icon: const Icon(Icons.storefront_rounded, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const MainNavigationShell()),
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
      drawer: isDesktop ? null : _buildMobileDrawer(isDark),
      body: SafeArea(
        child: isDesktop
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Flipkart Sidebar
                  SizedBox(
                    width: 270,
                    child: _buildSidebar(isDark),
                  ),
                  // Right Content Canvas
                  Expanded(
                    child: _buildContentPanel(isDark),
                  ),
                ],
              )
            : _buildContentPanel(isDark),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // [START] FLIPKART-STYLE LEFT SIDEBAR
  // --------------------------------------------------------------------------
  Widget _buildSidebar(bool isDark) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 0, 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Admin Header Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.flipkartYellow,
                  child: const Icon(Icons.admin_panel_settings_rounded, color: AppColors.primary, size: 26),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello,',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: isDark ? AppColors.textSecondaryDark : AppColors.textMutedLight,
                        ),
                      ),
                      Text(
                        'Store Admin',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 3),
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.flipkartBlue.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'SUPER ADMIN',
                          style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.flipkartBlue),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Sidebar Navigation Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _buildSidebarSectionTitle('STORE METRICS', isDark),
                _buildSidebarItem(
                  id: 'overview',
                  icon: Icons.dashboard_rounded,
                  title: 'Dashboard Overview',
                  isDark: isDark,
                ),

                const SizedBox(height: 8),
                _buildSidebarSectionTitle('CATALOG MANAGEMENT', isDark),
                _buildSidebarItem(
                  id: 'sneakers',
                  icon: Icons.inventory_2_rounded,
                  title: 'Manage Sneakers',
                  badgeText: '${context.watch<SneakerProvider>().totalSneakersCount}',
                  isDark: isDark,
                ),
                _buildSidebarItem(
                  id: 'categories',
                  icon: Icons.category_rounded,
                  title: 'Category Stock',
                  isDark: isDark,
                ),

                const SizedBox(height: 8),
                _buildSidebarSectionTitle('ORDERS & SALES', isDark),
                _buildSidebarItem(
                  id: 'orders',
                  icon: Icons.local_shipping_rounded,
                  title: 'Customer Orders',
                  badgeText: '${context.watch<OrderProvider>().orders.length}',
                  isDark: isDark,
                ),

                const Divider(height: 24),
                _buildSidebarSectionTitle('QUICK ACTIONS', isDark),
                ListTile(
                  dense: true,
                  leading: const Icon(Icons.storefront_rounded, color: AppColors.statusSuccess, size: 20),
                  title: Text(
                    'Switch to Store',
                    style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.statusSuccess),
                  ),
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const MainNavigationShell()),
                      (route) => false,
                    );
                  },
                ),
                ListTile(
                  dense: true,
                  leading: const Icon(Icons.logout_rounded, color: AppColors.accent, size: 20),
                  title: Text(
                    'Logout Admin',
                    style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.accent),
                  ),
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const SignInScreen()),
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileDrawer(bool isDark) {
    return Drawer(
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.cardLight,
      child: _buildSidebar(isDark),
    );
  }

  Widget _buildSidebarSectionTitle(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      child: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
          color: isDark ? AppColors.textSecondaryDark : AppColors.textMutedLight,
        ),
      ),
    );
  }

  Widget _buildSidebarItem({
    required String id,
    required IconData icon,
    required String title,
    String? badgeText,
    required bool isDark,
  }) {
    final isSelected = _activeSection == id;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: isSelected
            ? (isDark ? AppColors.cardGreyDark : const Color(0xFFF1F5FF))
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
        leading: Icon(
          icon,
          size: 20,
          color: isSelected ? AppColors.flipkartBlue : (isDark ? Colors.white70 : AppColors.textSecondaryLight),
        ),
        title: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected
                ? AppColors.flipkartBlue
                : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
          ),
        ),
        trailing: badgeText != null
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.flipkartBlue : (isDark ? AppColors.cardGreyDark : AppColors.cardGreyLight),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  badgeText,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.white : (isDark ? Colors.white70 : AppColors.textSecondaryLight),
                  ),
                ),
              )
            : null,
        onTap: () {
          setState(() => _activeSection = id);
          if (MediaQuery.of(context).size.width < 850) {
            Navigator.of(context).pop(); // Close mobile drawer
          }
        },
      ),
    );
  }

  // --------------------------------------------------------------------------
  // [START] RIGHT CONTENT PANEL
  // --------------------------------------------------------------------------
  Widget _buildContentPanel(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Header Bar with Live Search / Add Action
          _buildPanelHeader(isDark),
          const SizedBox(height: 16),

          // Active View Body
          Expanded(
            child: _buildActiveSectionView(isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildPanelHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Section Title & Breadcrumb
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getSectionHeaderTitle(),
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Admin Console • Live Store Sync',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textMutedLight,
                ),
              ),
            ],
          ),

          // Action Buttons
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: _showAddSneakerDialog,
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('Add Sneaker'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.flipkartBlue,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getSectionHeaderTitle() {
    switch (_activeSection) {
      case 'overview':
        return 'Store Performance Overview';
      case 'sneakers':
        return 'Sneakers Catalog Inventory';
      case 'orders':
        return 'Customer Orders & Shipments';
      case 'categories':
        return 'Category Inventory Levels';
      default:
        return 'Admin Dashboard';
    }
  }

  Widget _buildActiveSectionView(bool isDark) {
    switch (_activeSection) {
      case 'overview':
        return _buildOverviewTab(isDark);
      case 'sneakers':
        return _buildSneakersTab(isDark);
      case 'orders':
        return _buildOrdersTab(isDark);
      case 'categories':
        return _buildCategoriesTab(isDark);
      default:
        return _buildOverviewTab(isDark);
    }
  }

  // ==========================================================================
  // [START] TAB 1: OVERVIEW TAB
  // ==========================================================================
  Widget _buildOverviewTab(bool isDark) {
    final orderProv = context.watch<OrderProvider>();
    final sneakerProv = context.watch<SneakerProvider>();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top 4 Metric Cards
          LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth = constraints.maxWidth > 700 ? (constraints.maxWidth - 48) / 4 : (constraints.maxWidth - 16) / 2;
              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  _buildMetricCard(
                    title: 'TOTAL REVENUE',
                    value: _currencyFormatter.format(orderProv.totalRevenue),
                    change: '+18.4% vs last month',
                    icon: Icons.currency_rupee_rounded,
                    iconColor: AppColors.statusSuccess,
                    width: cardWidth,
                    isDark: isDark,
                  ),
                  _buildMetricCard(
                    title: 'TOTAL ORDERS',
                    value: '${orderProv.totalOrdersCount}',
                    change: '${orderProv.deliveredOrdersCount} Delivered',
                    icon: Icons.local_mall_rounded,
                    iconColor: AppColors.flipkartBlue,
                    width: cardWidth,
                    isDark: isDark,
                  ),
                  _buildMetricCard(
                    title: 'CATALOG SNEAKERS',
                    value: '${sneakerProv.totalSneakersCount}',
                    change: '0 Duplicates • 10/Category',
                    icon: Icons.check_circle_outline_rounded,
                    iconColor: AppColors.statusSuccess,
                    width: cardWidth,
                    isDark: isDark,
                  ),
                  _buildMetricCard(
                    title: 'TRENDING DROPS',
                    value: '${sneakerProv.trendingCount}',
                    change: 'Featured on Homepage',
                    icon: Icons.local_fire_department_rounded,
                    iconColor: AppColors.accent,
                    width: cardWidth,
                    isDark: isDark,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),

          // 2 Columns: Category Breakdown & Recent Orders
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category Breakdown Card
              Expanded(
                flex: 4,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDark : AppColors.cardLight,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Category Stock Distribution',
                        style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 16),
                      ...sneakerProv.categoryCounts.entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(entry.key, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600)),
                                  Text('${entry.value} Items', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.flipkartBlue)),
                                ],
                              ),
                              const SizedBox(height: 6),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: LinearProgressIndicator(
                                  value: (entry.value / 15).clamp(0.0, 1.0),
                                  minHeight: 7,
                                  backgroundColor: isDark ? AppColors.cardGreyDark : AppColors.cardGreyLight,
                                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.flipkartBlue),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Recent Orders Preview
              Expanded(
                flex: 6,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDark : AppColors.cardLight,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Recent Orders', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700)),
                          TextButton(
                            onPressed: () => setState(() => _activeSection = 'orders'),
                            child: const Text('View All'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ...orderProv.orders.take(3).map((order) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.cardGreyDark : AppColors.cardGreyLight,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.receipt_long_rounded, color: AppColors.flipkartBlue, size: 20),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Order ${order.id} • ${order.date}',
                                      style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      '${order.items.length} Sneaker(s) • ${_currencyFormatter.format(order.total)}',
                                      style: GoogleFonts.inter(fontSize: 12, color: isDark ? AppColors.textSecondaryDark : AppColors.textMutedLight),
                                    ),
                                  ],
                                ),
                              ),
                              _buildStatusBadge(order.status),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String change,
    required IconData icon,
    required Color iconColor,
    required double width,
    required bool isDark,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textMutedLight,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 18, color: iconColor),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            change,
            style: GoogleFonts.inter(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: AppColors.statusSuccess,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // [START] TAB 2: MANAGE SNEAKERS TAB (CRUD)
  // ==========================================================================
  Widget _buildSneakersTab(bool isDark) {
    final sneakerProv = context.watch<SneakerProvider>();
    var list = sneakerProv.sneakers;

    // Filter by Search Query
    if (_sneakerSearchQuery.isNotEmpty) {
      final q = _sneakerSearchQuery.toLowerCase();
      list = list.where((s) => s.name.toLowerCase().contains(q) || s.brand.toLowerCase().contains(q)).toList();
    }

    // Filter by Brand
    if (_selectedBrandFilter != 'All') {
      list = list.where((s) => s.brand.toLowerCase() == _selectedBrandFilter.toLowerCase()).toList();
    }

    // Filter by Category
    if (_selectedCategoryFilter != 'All') {
      list = list.where((s) => s.category.toLowerCase() == _selectedCategoryFilter.toLowerCase()).toList();
    }

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Column(
        children: [
          // Filter Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Search Input
                Expanded(
                  child: Container(
                    height: 42,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardGreyDark : AppColors.cardGreyLight,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search_rounded, size: 20, color: AppColors.textMutedLight),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            onChanged: (val) => setState(() => _sneakerSearchQuery = val.trim()),
                            decoration: const InputDecoration(
                              hintText: 'Search 60 sneakers by model or brand...',
                              hintStyle: TextStyle(fontSize: 13),
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Brand Filter
                Container(
                  height: 42,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardGreyDark : AppColors.cardGreyLight,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedBrandFilter,
                      dropdownColor: isDark ? AppColors.surfaceDark : AppColors.cardLight,
                      items: ['All', 'Nike', 'Adidas', 'Puma', 'Jordan'].map((b) {
                        return DropdownMenuItem(value: b, child: Text('Brand: $b', style: GoogleFonts.inter(fontSize: 13)));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedBrandFilter = val);
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Category Filter
                Container(
                  height: 42,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardGreyDark : AppColors.cardGreyLight,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedCategoryFilter,
                      dropdownColor: isDark ? AppColors.surfaceDark : AppColors.cardLight,
                      items: ['All', 'Lifestyle', 'Running', 'Basketball', 'Training', 'Skateboarding', 'Limited Edition'].map((c) {
                        return DropdownMenuItem(value: c, child: Text('Category: $c', style: GoogleFonts.inter(fontSize: 13)));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedCategoryFilter = val);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Sneakers List Table
          Expanded(
            child: list.isEmpty
                ? Center(
                    child: Text(
                      'No sneakers match current filters',
                      style: GoogleFonts.inter(color: AppColors.textMutedLight),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: list.length,
                    separatorBuilder: (_, __) => const Divider(height: 16),
                    itemBuilder: (context, index) {
                      final sneaker = list[index];
                      return Row(
                        children: [
                          // Sneaker Thumbnail
                          Container(
                            width: 60,
                            height: 60,
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.cardGreyDark : AppColors.cardGreyLight,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: SneakerImage(imagePath: sneaker.image, fit: BoxFit.contain),
                          ),
                          const SizedBox(width: 14),

                          // Sneaker Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: AppColors.flipkartBlue.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        sneaker.brand.toUpperCase(),
                                        style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.flipkartBlue),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: isDark ? AppColors.chipDark : AppColors.chipLight,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        sneaker.category,
                                        style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    if (sneaker.isTrending) ...[
                                      const SizedBox(width: 6),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppColors.accent.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          'TRENDING',
                                          style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.accent),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  sneaker.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ),

                          // Price & Quick Edit
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                _currencyFormatter.format(sneaker.price),
                                style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w800),
                              ),
                              InkWell(
                                onTap: () => _showEditPriceDialog(sneaker),
                                child: Text(
                                  'Edit Price',
                                  style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.flipkartBlue),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 14),

                          // Delete Action Button
                          IconButton(
                            icon: const Icon(Icons.delete_outline_rounded, color: AppColors.accent, size: 20),
                            tooltip: 'Delete Sneaker',
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Delete Sneaker?'),
                                  content: Text('Are you sure you want to remove "${sneaker.name}" from the catalog?'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, foregroundColor: Colors.white),
                                      onPressed: () {
                                        sneakerProv.deleteSneaker(sneaker.id);
                                        Navigator.of(ctx).pop();
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Deleted ${sneaker.name}')),
                                        );
                                      },
                                      child: const Text('Delete'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // [START] TAB 3: ORDERS MANAGEMENT TAB
  // ==========================================================================
  Widget _buildOrdersTab(bool isDark) {
    final orderProv = context.watch<OrderProvider>();
    final orders = orderProv.orders;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Customer Order Fulfillment (${orders.length} Total)',
                style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              Text(
                'Total Revenue: ${_currencyFormatter.format(orderProv.totalRevenue)}',
                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.statusSuccess),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1),

          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: orders.length,
              separatorBuilder: (_, __) => const Divider(height: 20),
              itemBuilder: (context, index) {
                final order = orders[index];
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardGreyDark : AppColors.cardGreyLight,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header: Order ID + Status Dropdown
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                order.id,
                                style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w800, color: AppColors.flipkartBlue),
                              ),
                              const SizedBox(width: 8),
                              Text('•  Date: ${order.date}', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMutedLight)),
                            ],
                          ),

                          // Live Status Changer Dropdown
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.surfaceDark : Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<OrderStatus>(
                                value: order.status,
                                isDense: true,
                                dropdownColor: isDark ? AppColors.surfaceDark : AppColors.cardLight,
                                items: OrderStatus.values.map((st) {
                                  return DropdownMenuItem(
                                    value: st,
                                    child: Text(
                                      st.name.toUpperCase(),
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w800,
                                        color: _getStatusColor(st),
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (newStatus) {
                                  if (newStatus != null) {
                                    orderProv.updateOrderStatus(order.id, newStatus);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Order ${order.id} marked as ${newStatus.name.toUpperCase()}'),
                                        duration: const Duration(seconds: 1),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Order Items
                      ...order.items.map((ci) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Container(
                                width: 38,
                                height: 38,
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: isDark ? AppColors.surfaceDark : Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: SneakerImage(imagePath: ci.sneaker.image, fit: BoxFit.contain),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  '${ci.sneaker.name} (UK ${ci.size}) x ${ci.quantity}',
                                  style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
                                ),
                              ),
                              Text(
                                _currencyFormatter.format(ci.sneaker.price * ci.quantity),
                                style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        );
                      }),
                      const Divider(height: 16),

                      // Footer: Address + Total + Payment
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Deliver to: ${order.address} • Pay via ${order.paymentMethod}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(fontSize: 11.5, color: isDark ? AppColors.textSecondaryDark : AppColors.textMutedLight),
                            ),
                          ),
                          Text(
                            'Total: ${_currencyFormatter.format(order.total)}',
                            style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.statusSuccess),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.delivered:
        return AppColors.statusSuccess;
      case OrderStatus.shipped:
        return AppColors.statusShipped;
      case OrderStatus.processing:
        return AppColors.flipkartBlue;
    }
  }

  Widget _buildStatusBadge(OrderStatus status) {
    Color bg;
    Color fg;
    String text;

    switch (status) {
      case OrderStatus.delivered:
        bg = AppColors.statusSuccess.withOpacity(0.12);
        fg = AppColors.statusSuccess;
        text = 'DELIVERED';
        break;
      case OrderStatus.shipped:
        bg = AppColors.statusShipped.withOpacity(0.12);
        fg = AppColors.statusShipped;
        text = 'SHIPPED';
        break;
      case OrderStatus.processing:
        bg = AppColors.flipkartBlue.withOpacity(0.12);
        fg = AppColors.flipkartBlue;
        text = 'PROCESSING';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w800, color: fg),
      ),
    );
  }

  // ==========================================================================
  // [START] TAB 4: CATEGORIES TAB
  // ==========================================================================
  Widget _buildCategoriesTab(bool isDark) {
    final sneakerProv = context.watch<SneakerProvider>();
    final categories = [
      {'title': 'Lifestyle', 'icon': Icons.style_rounded, 'desc': 'Streetwear casual low-top classics'},
      {'title': 'Running', 'icon': Icons.directions_run_rounded, 'desc': 'High-performance visible Air and Nitro cushioning'},
      {'title': 'Basketball', 'icon': Icons.sports_basketball_rounded, 'desc': 'Hardwood legends with high ankle support'},
      {'title': 'Training', 'icon': Icons.fitness_center_rounded, 'desc': 'Wide platforms and stability for gym and HIIT'},
      {'title': 'Skateboarding', 'icon': Icons.skateboarding_rounded, 'desc': 'Durable suede uppers and grippy vulcanized rubber'},
      {'title': 'Limited Edition', 'icon': Icons.auto_awesome_rounded, 'desc': 'Rare Grails, Virgil Abloh collabs, and collector drops'},
    ];

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 350,
        mainAxisExtent: 170,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final cat = categories[index];
        final title = cat['title'] as String;
        final icon = cat['icon'] as IconData;
        final desc = cat['desc'] as String;
        final count = sneakerProv.categoryCounts[title] ?? 10;

        return Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : AppColors.cardLight,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.flipkartBlue.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: AppColors.flipkartBlue, size: 22),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.statusSuccess.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$count Models Active',
                      style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.statusSuccess),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w800)),
                  const SizedBox(height: 2),
                  Text(
                    desc,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(fontSize: 11.5, color: isDark ? AppColors.textSecondaryDark : AppColors.textMutedLight),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
// ============================================================================
// [END] ADMIN DASHBOARD SCREEN STATE
// ============================================================================

// ============================================================================
// [END] FILE: admin_dashboard_screen.dart
// ============================================================================

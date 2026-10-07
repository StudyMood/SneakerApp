// ============================================================================
// [START] FILE: profile_screen.dart
// ============================================================================

// ============================================================================
// [START] IMPORTS
// ============================================================================
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../providers/wishlist_provider.dart';
import 'signin_screen.dart';
import 'orders_screen.dart';
import 'wishlist_screen.dart';
import 'settings_screen.dart';
import 'notifications_screen.dart';
import 'admin/admin_dashboard_screen.dart';
import '../services/firebase_service.dart';
// ============================================================================
// [END] IMPORTS
// ============================================================================

// ============================================================================
// [START] PROFILE SCREEN WIDGET (STATEFUL)
// ============================================================================
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}
// ============================================================================
// [END] PROFILE SCREEN WIDGET
// ============================================================================

// ============================================================================
// [START] PROFILE SCREEN STATE
// ============================================================================
class _ProfileScreenState extends State<ProfileScreen> {
  // --------------------------------------------------------------------------
  // [START] STATE VARIABLES & CONTROLLERS
  // --------------------------------------------------------------------------
  // Active Navigation Tab
  String _activeTab = 'profile_info'; // 'profile_info', 'addresses', 'upi', 'cards'

  // Edit Mode Toggles
  bool _isEditingPersonal = false;
  bool _isEditingEmail = false;
  bool _isEditingPhone = false;

  // Text Editing Controllers
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  // Gender Selection
  String _selectedGender = 'Male';

  // Profile Image Upload State (default is null so NO forced stock image is shown)
  Uint8List? _uploadedImageBytes;
  String? _selectedAvatarUrl;
  final ImagePicker _imagePicker = ImagePicker();
  // --------------------------------------------------------------------------
  // [END] STATE VARIABLES & CONTROLLERS
  // --------------------------------------------------------------------------

  // --------------------------------------------------------------------------
  // [START] INIT STATE
  // --------------------------------------------------------------------------
  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: 'Abhishek');
    _lastNameController = TextEditingController(text: 'Sharma');
    _emailController = TextEditingController(text: 'abhishek@email.com');
    _phoneController = TextEditingController(text: '+919115232642');
  }
  // --------------------------------------------------------------------------
  // [END] INIT STATE
  // --------------------------------------------------------------------------

  // --------------------------------------------------------------------------
  // [START] DISPOSE METHOD
  // --------------------------------------------------------------------------
  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
  // --------------------------------------------------------------------------
  // [END] DISPOSE METHOD
  // --------------------------------------------------------------------------

  // --------------------------------------------------------------------------
  // [START] IMAGE PICKER & UPLOAD METHODS
  // --------------------------------------------------------------------------
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() {
          _uploadedImageBytes = bytes;
          _selectedAvatarUrl = null;
        });

        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile photo uploaded successfully!'),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error uploading image: $e'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _removeProfileImage([bool closeDialog = false]) {
    setState(() {
      _uploadedImageBytes = null;
      _selectedAvatarUrl = null;
    });
    if (closeDialog && Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile photo removed'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showImageUploadModal() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Profile Photo Options',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : AppColors.textPrimaryLight,
                    ),
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Upload your photo from your device or capture a new photo with camera',
                style: GoogleFonts.inter(fontSize: 12.5, color: const Color(0xFF8E8E93)),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _pickImage(ImageSource.gallery),
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF26262B) : const Color(0xFFF4F5F8),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isDark ? AppColors.borderDark : const Color(0xFFE2E4E8),
                          ),
                        ),
                        child: Column(
                          children: [
                            const Icon(Icons.cloud_upload_rounded, size: 28, color: AppColors.accent),
                            const SizedBox(height: 8),
                            Text(
                              'Upload from Device',
                              style: GoogleFonts.inter(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white : AppColors.textPrimaryLight,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'JPG, PNG, WebP',
                              style: GoogleFonts.inter(fontSize: 10, color: const Color(0xFF8E8E93)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      onTap: () => _pickImage(ImageSource.camera),
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF26262B) : const Color(0xFFF4F5F8),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isDark ? AppColors.borderDark : const Color(0xFFE2E4E8),
                          ),
                        ),
                        child: Column(
                          children: [
                            const Icon(Icons.photo_camera_rounded, size: 28, color: Color(0xFF007AFF)),
                            const SizedBox(height: 8),
                            Text(
                              'Take Photo',
                              style: GoogleFonts.inter(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white : AppColors.textPrimaryLight,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Use Camera',
                              style: GoogleFonts.inter(fontSize: 10, color: const Color(0xFF8E8E93)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (_uploadedImageBytes != null || _selectedAvatarUrl != null) ...[
                const SizedBox(height: 20),
                Center(
                  child: TextButton.icon(
                    onPressed: _removeProfileImage,
                    icon: const Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.accent),
                    label: Text(
                      'Remove Custom Photo (Reset to Initials)',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.accent,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
  // --------------------------------------------------------------------------
  // [END] IMAGE PICKER & UPLOAD METHODS
  // --------------------------------------------------------------------------

  // --------------------------------------------------------------------------
  // [START] BUILD METHOD
  // --------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F0F12) : const Color(0xFFF1F3F6),
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
        elevation: 0,
        title: Text(
          'My Account',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.2,
            color: isDark ? Colors.white : AppColors.textPrimaryLight,
          ),
        ),
        centerTitle: false,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth > 780;

              if (isDesktop) {
                // ============================================================
                // [START] DESKTOP TWO-COLUMN PORTAL LAYOUT (MATCHING IMAGE 2)
                // ============================================================
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- LEFT SIDEBAR (WIDTH: 290px) ---
                      SizedBox(
                        width: 290,
                        child: Column(
                          children: [
                            _buildLeftHelloCard(isDark),
                            const SizedBox(height: 14),
                            _buildLeftSidebarMenu(isDark),
                          ],
                        ),
                      ),
                      const SizedBox(width: 18),

                      // --- RIGHT MAIN CONTENT PANEL ---
                      Expanded(
                        child: _buildRightContentPanel(isDark),
                      ),
                    ],
                  ),
                );
                // ============================================================
                // [END] DESKTOP TWO-COLUMN PORTAL LAYOUT
                // ============================================================
              } else {
                // ============================================================
                // [START] MOBILE RESPONSIVE STACKED LAYOUT
                // ============================================================
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildLeftHelloCard(isDark),
                      const SizedBox(height: 14),
                      _buildMobileTabChips(isDark),
                      const SizedBox(height: 14),
                      _buildRightContentPanel(isDark),
                      const SizedBox(height: 14),
                      _buildLeftSidebarMenu(isDark),
                    ],
                  ),
                );
                // ============================================================
                // [END] MOBILE RESPONSIVE STACKED LAYOUT
                // ============================================================
              }
            },
          ),
        ),
      ),
    );
  }
  // --------------------------------------------------------------------------
  // [END] BUILD METHOD
  // --------------------------------------------------------------------------

  // ==========================================================================
  // [START] LEFT SIDEBAR: HELLO USER CARD
  // ==========================================================================
  Widget _buildLeftHelloCard(bool isDark) {
    ImageProvider? imageProvider;
    if (_uploadedImageBytes != null) {
      imageProvider = MemoryImage(_uploadedImageBytes!);
    } else if (_selectedAvatarUrl != null) {
      imageProvider = NetworkImage(_selectedAvatarUrl!);
    }
    final hasCustomImage = imageProvider != null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? AppColors.borderDark : const Color(0xFFE5E7EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar with Camera Upload Badge
          GestureDetector(
            onTap: _showImageUploadModal,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: hasCustomImage
                      ? Colors.transparent
                      : (isDark ? const Color(0xFF2C303B) : const Color(0xFFEEF2F6)),
                  backgroundImage: imageProvider,
                  child: !hasCustomImage
                      ? Icon(
                          Icons.add_a_photo_outlined,
                          size: 20,
                          color: isDark ? Colors.white70 : const Color(0xFF6B7280),
                        )
                      : null,
                ),
                Positioned(
                  bottom: -2,
                  right: -2,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    child: const Icon(Icons.camera_alt_rounded, size: 10, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),

          // User Name & Greeting
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello,',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF8E8E93),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${_firstNameController.text} ${_lastNameController.text}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppColors.textPrimaryLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  // ==========================================================================
  // [END] LEFT SIDEBAR: HELLO USER CARD
  // ==========================================================================

  // ==========================================================================
  // [START] LEFT SIDEBAR: NAVIGATION MENU
  // ==========================================================================
  Widget _buildLeftSidebarMenu(bool isDark) {
    final wishlistCount = context.watch<WishlistProvider>().items.length;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? AppColors.borderDark : const Color(0xFFE5E7EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ------------------------------------------------------------------
          // [START] SECTION 1: MY ORDERS
          // ------------------------------------------------------------------
          ListTile(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const OrdersScreen()),
              );
            },
            leading: const Icon(Icons.inventory_2_rounded, size: 20, color: AppColors.accentCyan),
            title: Text(
              'MY ORDERS',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
                color: isDark ? Colors.white70 : const Color(0xFF878787),
              ),
            ),
            trailing: const Icon(Icons.chevron_right_rounded, size: 20, color: Color(0xFF878787)),
          ),
          const Divider(height: 1),
          // ------------------------------------------------------------------
          // [END] SECTION 1: MY ORDERS
          // ------------------------------------------------------------------

          // ------------------------------------------------------------------
          // [START] SECTION 2: ACCOUNT SETTINGS
          // ------------------------------------------------------------------
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
            child: Row(
              children: [
                const Icon(Icons.person_outline_rounded, size: 20, color: AppColors.accentCyan),
                const SizedBox(width: 12),
                Text(
                  'ACCOUNT SETTINGS',
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: isDark ? Colors.white70 : const Color(0xFF878787),
                  ),
                ),
              ],
            ),
          ),
          _buildSidebarSubItem(
            title: 'Profile Information',
            isSelected: _activeTab == 'profile_info',
            isDark: isDark,
            onTap: () => setState(() => _activeTab = 'profile_info'),
          ),
          _buildSidebarSubItem(
            title: 'Manage Addresses',
            isSelected: _activeTab == 'addresses',
            isDark: isDark,
            onTap: () => setState(() => _activeTab = 'addresses'),
          ),
          _buildSidebarSubItem(
            title: 'Settings & Security',
            isSelected: _activeTab == 'settings',
            isDark: isDark,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
          if (FirebaseService.instance.isAdmin)
            _buildSidebarSubItem(
              title: 'Admin Dashboard 🔑',
              isSelected: false,
              isDark: isDark,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AdminDashboardScreen()),
                );
              },
            ),
          const Divider(height: 1),
          // ------------------------------------------------------------------
          // [END] SECTION 2: ACCOUNT SETTINGS
          // ------------------------------------------------------------------

          // ------------------------------------------------------------------
          // [START] SECTION 3: PAYMENTS
          // ------------------------------------------------------------------
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
            child: Row(
              children: [
                const Icon(Icons.payment_rounded, size: 20, color: AppColors.accentCyan),
                const SizedBox(width: 12),
                Text(
                  'PAYMENTS',
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: isDark ? Colors.white70 : const Color(0xFF878787),
                  ),
                ),
              ],
            ),
          ),
          _buildSidebarSubItem(
            title: 'Saved UPI',
            isSelected: _activeTab == 'upi',
            isDark: isDark,
            onTap: () => setState(() => _activeTab = 'upi'),
          ),
          _buildSidebarSubItem(
            title: 'Saved Cards',
            isSelected: _activeTab == 'cards',
            isDark: isDark,
            onTap: () => setState(() => _activeTab = 'cards'),
          ),
          const Divider(height: 1),
          // ------------------------------------------------------------------
          // [END] SECTION 3: PAYMENTS
          // ------------------------------------------------------------------

          // ------------------------------------------------------------------
          // [START] SECTION 4: MY STUFF
          // ------------------------------------------------------------------
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
            child: Row(
              children: [
                const Icon(Icons.folder_shared_outlined, size: 20, color: AppColors.accentCyan),
                const SizedBox(width: 12),
                Text(
                  'MY STUFF',
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: isDark ? Colors.white70 : const Color(0xFF878787),
                  ),
                ),
              ],
            ),
          ),
          _buildSidebarSubItem(
            title: 'My Wishlist ($wishlistCount)',
            isSelected: false,
            isDark: isDark,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const WishlistScreen()),
              );
            },
          ),
          _buildSidebarSubItem(
            title: 'All Notifications',
            isSelected: false,
            isDark: isDark,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const NotificationsScreen()),
              );
            },
          ),
          const Divider(height: 1),
          // ------------------------------------------------------------------
          // [END] SECTION 4: MY STUFF
          // ------------------------------------------------------------------

          // ------------------------------------------------------------------
          // [START] SECTION 5: LOGOUT
          // ------------------------------------------------------------------
          ListTile(
            onTap: _showLogoutDialog,
            leading: const Icon(Icons.power_settings_new_rounded, size: 20, color: AppColors.accent),
            title: Text(
              'Logout',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.accent,
              ),
            ),
          ),
          // ------------------------------------------------------------------
          // [END] SECTION 5: LOGOUT
          // ------------------------------------------------------------------
        ],
      ),
    );
  }

  Widget _buildSidebarSubItem({
    required String title,
    required bool isSelected,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 10),
        color: isSelected
            ? (isDark ? const Color(0xFF1E2838) : const Color(0xFFF5F7FF))
            : Colors.transparent,
        child: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 13.5,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected
                ? AppColors.accentCyan
                : (isDark ? Colors.white70 : AppColors.textPrimaryLight),
          ),
        ),
      ),
    );
  }
  // ==========================================================================
  // [END] LEFT SIDEBAR: NAVIGATION MENU
  // ==========================================================================

  // ==========================================================================
  // [START] MOBILE HORIZONTAL TAB CHIPS
  // ==========================================================================
  Widget _buildMobileTabChips(bool isDark) {
    final tabs = [
      {'key': 'profile_info', 'label': 'Personal Info'},
      {'key': 'addresses', 'label': 'Addresses'},
      {'key': 'upi', 'label': 'Saved UPI'},
      {'key': 'cards', 'label': 'Saved Cards'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tabs.map((tab) {
          final isSelected = _activeTab == tab['key'];
          return GestureDetector(
            onTap: () => setState(() => _activeTab = tab['key'] as String),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF2874F0)
                    : (isDark ? AppColors.surfaceDark : Colors.white),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF2874F0)
                      : (isDark ? AppColors.borderDark : const Color(0xFFE5E7EB)),
                ),
              ),
              child: Text(
                tab['label'] as String,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
  // ==========================================================================
  // [END] MOBILE HORIZONTAL TAB CHIPS
  // ==========================================================================

  // ==========================================================================
  // [START] RIGHT MAIN CONTENT PANEL (SWITCHES ACCORDING TO TAB)
  // ==========================================================================
  Widget _buildRightContentPanel(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? AppColors.borderDark : const Color(0xFFE5E7EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: _buildActiveTabContent(isDark),
    );
  }

  Widget _buildActiveTabContent(bool isDark) {
    switch (_activeTab) {
      case 'addresses':
        return _buildAddressesContent(isDark);
      case 'upi':
        return _buildUpiContent(isDark);
      case 'cards':
        return _buildCardsContent(isDark);
      case 'profile_info':
      default:
        return _buildProfileInformationContent(isDark);
    }
  }
  // ==========================================================================
  // [END] RIGHT MAIN CONTENT PANEL
  // ==========================================================================

  // ==========================================================================
  // [START] PANEL VIEW: PROFILE INFORMATION (MATCHING FLIPKART EXACTLY)
  // ==========================================================================
  Widget _buildProfileInformationContent(bool isDark) {
    ImageProvider? imageProvider;
    if (_uploadedImageBytes != null) {
      imageProvider = MemoryImage(_uploadedImageBytes!);
    } else if (_selectedAvatarUrl != null) {
      imageProvider = NetworkImage(_selectedAvatarUrl!);
    }
    final hasCustomImage = imageProvider != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --------------------------------------------------------------------
        // [START] SUBSECTION 0: PROFILE PHOTO UPLOAD
        // --------------------------------------------------------------------
        Text(
          'Profile Photo',
          style: GoogleFonts.inter(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E2128) : const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? AppColors.borderDark : const Color(0xFFE5E7EB),
            ),
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: _showImageUploadModal,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: hasCustomImage
                          ? Colors.transparent
                          : (isDark ? const Color(0xFF2C303B) : const Color(0xFFEEF2F6)),
                      backgroundImage: imageProvider,
                      child: !hasCustomImage
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_a_photo_outlined,
                                  size: 24,
                                  color: isDark ? Colors.white70 : const Color(0xFF6B7280),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Upload',
                                  style: GoogleFonts.inter(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? Colors.white70 : const Color(0xFF6B7280),
                                  ),
                                ),
                              ],
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2874F0),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(Icons.edit_rounded, size: 12, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hasCustomImage ? 'Custom Photo Uploaded' : 'No Photo Uploaded',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : AppColors.textPrimaryLight,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Upload your profile photo from your phone or PC (PNG, JPG, WebP)',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF878787),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _pickImage(ImageSource.gallery),
                          icon: const Icon(Icons.upload_rounded, size: 16),
                          label: Text(
                            hasCustomImage ? 'Change Photo' : 'Upload Photo',
                            style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w700),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2874F0),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => _pickImage(ImageSource.camera),
                          icon: const Icon(Icons.photo_camera_rounded, size: 16),
                          label: Text(
                            'Camera',
                            style: GoogleFonts.inter(fontSize: 12.5, fontWeight: FontWeight.w600),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: isDark ? Colors.white : AppColors.textPrimaryLight,
                            side: BorderSide(
                              color: isDark ? AppColors.borderDark : const Color(0xFFD1D5DB),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                        if (hasCustomImage)
                          OutlinedButton.icon(
                            onPressed: () => _removeProfileImage(false),
                            icon: const Icon(Icons.delete_outline_rounded, size: 16, color: AppColors.accent),
                            label: Text(
                              'Remove',
                              style: GoogleFonts.inter(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: AppColors.accent,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.accent),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // --------------------------------------------------------------------
        // [START] SUBSECTION 1: PERSONAL INFORMATION
        // --------------------------------------------------------------------
        Row(
          children: [
            Text(
              'Personal Information',
              style: GoogleFonts.inter(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(width: 18),
            GestureDetector(
              onTap: () {
                setState(() {
                  if (_isEditingPersonal) {
                    _isEditingPersonal = false;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Personal Information updated successfully!'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  } else {
                    _isEditingPersonal = true;
                  }
                });
              },
              child: Text(
                _isEditingPersonal ? 'Save' : 'Edit',
                style: GoogleFonts.inter(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2874F0),
                ),
              ),
            ),
            if (_isEditingPersonal) ...[
              const SizedBox(width: 14),
              GestureDetector(
                onTap: () => setState(() => _isEditingPersonal = false),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF878787),
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 16),

        // First Name & Last Name Input Fields Side-by-Side
        Row(
          children: [
            Expanded(
              child: _buildStyledTextField(
                controller: _firstNameController,
                labelText: 'First Name',
                enabled: _isEditingPersonal,
                isDark: isDark,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStyledTextField(
                controller: _lastNameController,
                labelText: 'Last Name',
                enabled: _isEditingPersonal,
                isDark: isDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),

        // Your Gender Radio Selection
        Text(
          'Your Gender',
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF878787),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            _buildGenderRadio('Male', isDark),
            const SizedBox(width: 24),
            _buildGenderRadio('Female', isDark),
          ],
        ),
        // --------------------------------------------------------------------
        // [END] SUBSECTION 1: PERSONAL INFORMATION
        // --------------------------------------------------------------------

        const SizedBox(height: 36),

        // --------------------------------------------------------------------
        // [START] SUBSECTION 2: EMAIL ADDRESS
        // --------------------------------------------------------------------
        Row(
          children: [
            Text(
              'Email Address',
              style: GoogleFonts.inter(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(width: 18),
            GestureDetector(
              onTap: () {
                setState(() {
                  if (_isEditingEmail) {
                    _isEditingEmail = false;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Email updated successfully!'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  } else {
                    _isEditingEmail = true;
                  }
                });
              },
              child: Text(
                _isEditingEmail ? 'Save' : 'Edit',
                style: GoogleFonts.inter(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2874F0),
                ),
              ),
            ),
            if (_isEditingEmail) ...[
              const SizedBox(width: 14),
              GestureDetector(
                onTap: () => setState(() => _isEditingEmail = false),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF878787),
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: 380,
          child: _buildStyledTextField(
            controller: _emailController,
            labelText: 'Email Address',
            enabled: _isEditingEmail,
            isDark: isDark,
          ),
        ),
        // --------------------------------------------------------------------
        // [END] SUBSECTION 2: EMAIL ADDRESS
        // --------------------------------------------------------------------

        const SizedBox(height: 36),

        // --------------------------------------------------------------------
        // [START] SUBSECTION 3: MOBILE NUMBER
        // --------------------------------------------------------------------
        Row(
          children: [
            Text(
              'Mobile Number',
              style: GoogleFonts.inter(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(width: 18),
            GestureDetector(
              onTap: () {
                setState(() {
                  if (_isEditingPhone) {
                    _isEditingPhone = false;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Mobile Number updated successfully!'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  } else {
                    _isEditingPhone = true;
                  }
                });
              },
              child: Text(
                _isEditingPhone ? 'Save' : 'Edit',
                style: GoogleFonts.inter(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2874F0),
                ),
              ),
            ),
            if (_isEditingPhone) ...[
              const SizedBox(width: 14),
              GestureDetector(
                onTap: () => setState(() => _isEditingPhone = false),
                child: Text(
                  'Cancel',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF878787),
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: 380,
          child: _buildStyledTextField(
            controller: _phoneController,
            labelText: 'Mobile Number',
            enabled: _isEditingPhone,
            isDark: isDark,
          ),
        ),
        // --------------------------------------------------------------------
        // [END] SUBSECTION 3: MOBILE NUMBER
        // --------------------------------------------------------------------

        const SizedBox(height: 44),

        // --------------------------------------------------------------------
        // [START] SUBSECTION 4: FAQS SECTION
        // --------------------------------------------------------------------
        Text(
          'FAQs',
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'What happens when I update my email address (or mobile number)?',
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white70 : Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Your login email id (or mobile number) changes, likewise. You\'ll receive all account updates on your new credentials.',
          style: GoogleFonts.inter(
            fontSize: 12.5,
            height: 1.4,
            color: const Color(0xFF878787),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'What happens to my existing SNEAKER account when I update my details?',
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white70 : Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Updating your email or mobile number does not affect your previous orders, wishlist grails, or active sneakers shipments.',
          style: GoogleFonts.inter(
            fontSize: 12.5,
            height: 1.4,
            color: const Color(0xFF878787),
          ),
        ),
        const SizedBox(height: 28),

        // Deactivate Account Link
        GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Account deactivation requested. Our team will verify via OTP.'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          child: Text(
            'Deactivate Account',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF2874F0),
            ),
          ),
        ),
        // --------------------------------------------------------------------
        // [END] SUBSECTION 4: FAQS SECTION
        // --------------------------------------------------------------------
      ],
    );
  }

  Widget _buildStyledTextField({
    required TextEditingController controller,
    required String labelText,
    required bool enabled,
    required bool isDark,
  }) {
    return TextField(
      controller: controller,
      enabled: enabled,
      style: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: isDark ? Colors.white : AppColors.textPrimaryLight,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: GoogleFonts.inter(
          fontSize: 13,
          color: const Color(0xFF878787),
        ),
        filled: true,
        fillColor: enabled
            ? (isDark ? const Color(0xFF1E1E24) : Colors.white)
            : (isDark ? const Color(0xFF18181D) : const Color(0xFFF9FAFB)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(
            color: isDark ? AppColors.borderDark : const Color(0xFFE0E0E0),
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(
            color: isDark ? AppColors.borderDark.withOpacity(0.5) : const Color(0xFFEEEEEE),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFF2874F0), width: 1.5),
        ),
      ),
    );
  }

  Widget _buildGenderRadio(String value, bool isDark) {
    final isSelected = _selectedGender == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedGender = value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
            size: 19,
            color: isSelected ? const Color(0xFF2874F0) : const Color(0xFF878787),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isDark ? Colors.white : AppColors.textPrimaryLight,
            ),
          ),
        ],
      ),
    );
  }
  // ==========================================================================
  // [END] PANEL VIEW: PROFILE INFORMATION
  // ==========================================================================

  // ==========================================================================
  // [START] PANEL VIEW: MANAGE ADDRESSES
  // ==========================================================================
  Widget _buildAddressesContent(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Manage Addresses',
              style: GoogleFonts.inter(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.white : AppColors.textPrimaryLight,
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Add New Address form opened')),
                );
              },
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text('ADD A NEW ADDRESS'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2874F0),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                elevation: 0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Default Address Card
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E24) : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDark ? AppColors.borderDark : const Color(0xFFE5E7EB),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'HOME',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF878787),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Abhishek Sharma',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '+91 9115232642',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '123 MG Road, Near Central Mall, South Tukoganj, Indore, Madhya Pradesh - 452001',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  height: 1.4,
                  color: const Color(0xFF878787),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  // ==========================================================================
  // [END] PANEL VIEW: MANAGE ADDRESSES
  // ==========================================================================

  // ==========================================================================
  // [START] PANEL VIEW: SAVED UPI
  // ==========================================================================
  Widget _buildUpiContent(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Saved UPI IDs',
          style: GoogleFonts.inter(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E24) : const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: isDark ? AppColors.borderDark : const Color(0xFFE5E7EB)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.account_balance_wallet_rounded, color: Color(0xFF2874F0), size: 24),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'abhishek@upi',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : AppColors.textPrimaryLight,
                        ),
                      ),
                      Text(
                        'Verified Primary UPI ID',
                        style: GoogleFonts.inter(fontSize: 11, color: Colors.green),
                      ),
                    ],
                  ),
                ],
              ),
              const Icon(Icons.check_circle_rounded, color: Colors.green, size: 20),
            ],
          ),
        ),
      ],
    );
  }
  // ==========================================================================
  // [END] PANEL VIEW: SAVED UPI
  // ==========================================================================

  // ==========================================================================
  // [START] PANEL VIEW: SAVED CARDS
  // ==========================================================================
  Widget _buildCardsContent(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Saved Credit & Debit Cards',
          style: GoogleFonts.inter(
            fontSize: 17,
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : AppColors.textPrimaryLight,
          ),
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E24) : const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: isDark ? AppColors.borderDark : const Color(0xFFE5E7EB)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.credit_card_rounded, color: Color(0xFF2874F0), size: 24),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'HDFC Bank Visa Card ending in 4092',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : AppColors.textPrimaryLight,
                        ),
                      ),
                      Text(
                        'Expires 08/2028',
                        style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF878787)),
                      ),
                    ],
                  ),
                ],
              ),
              const Icon(Icons.verified_rounded, color: Color(0xFF2874F0), size: 20),
            ],
          ),
        ),
      ],
    );
  }
  // ==========================================================================
  // [END] PANEL VIEW: SAVED CARDS
  // ==========================================================================

  // --------------------------------------------------------------------------
  // [START] LOGOUT DIALOG HELPER
  // --------------------------------------------------------------------------
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Logout',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
        content: const Text('Are you sure you want to sign out from your SNEAKER account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const SignInScreen()),
                (route) => false,
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
  // --------------------------------------------------------------------------
  // [END] LOGOUT DIALOG HELPER
  // --------------------------------------------------------------------------
}
// ============================================================================
// [END] PROFILE SCREEN STATE
// ============================================================================

// ============================================================================
// [END] FILE: profile_screen.dart
// ============================================================================

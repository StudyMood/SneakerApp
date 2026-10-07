// ============================================================================
// [START] FILE: order_tracking_screen.dart
// ============================================================================
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/order.dart';
import '../providers/order_provider.dart';
import '../widgets/main_navigation_shell.dart';
import '../widgets/sneaker_image.dart';

class OrderTrackingScreen extends StatefulWidget {
  final OrderItem order;
  final bool isNewOrder;

  const OrderTrackingScreen({
    super.key,
    required this.order,
    this.isNewOrder = false,
  });

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.92, end: 1.08).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _showCallingDialog(BuildContext context, String name, String phone) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Color(0xFF1E1E22),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 4, 231, 78).withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person,
                  color: Color(0xFF110000),
                  size: 38,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                name,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Sneakr Express Delivery Partner • $phone',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: const Color(0xFF9CA3AF),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white70,
                        side: const BorderSide(color: Colors.white24),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: const Color(0xFF10B981),
                            content: Text(
                              'Dialing $name ($phone)...',
                              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.phone_rounded, size: 18),
                      label: const Text('Call Now'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  void _cycleNextStatus(OrderItem currentOrder, OrderProvider orderProvider) {
    OrderStatus next;
    if (currentOrder.status == OrderStatus.processing) {
      next = OrderStatus.shipped;
    } else if (currentOrder.status == OrderStatus.shipped) {
      next = OrderStatus.delivered;
    } else {
      next = OrderStatus.processing;
    }
    orderProvider.updateOrderStatus(currentOrder.id, next);
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter =
        NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    return Consumer<OrderProvider>(
      builder: (context, orderProvider, _) {
        // Find current order in provider to react to real-time status changes
        final liveOrder = orderProvider.orders.firstWhere(
          (o) => o.id == widget.order.id,
          orElse: () => widget.order,
        );

        final status = liveOrder.status;

        // Dynamic ETA and status subtitle
        String etaText;
        String etaSub;
        double progressFraction;

        switch (status) {
          case OrderStatus.processing:
            etaText = '25 Minutes';
            etaSub = 'Order Placed';
            progressFraction = 0.22;
            break;
          case OrderStatus.shipped:
            etaText = '10 Minutes';
            etaSub = 'Out for Delivery';
            progressFraction = 0.68;
            break;
          case OrderStatus.delivered:
            etaText = 'Delivered';
            etaSub = 'Delivered to your hands';
            progressFraction = 1.0;
            break;
        }

        return Scaffold(
          backgroundColor: const Color(0xFF0F0F11),
          appBar: AppBar(
            backgroundColor: const Color(0xFF0F0F11),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () {
                if (widget.isNewOrder) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const MainNavigationShell()),
                    (route) => false,
                  );
                } else {
                  Navigator.of(context).pop();
                }
              },
            ),
            title: Text(
              liveOrder.id.isNotEmpty ? liveOrder.id : 'BH-1003',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
                color: Colors.white,
              ),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.sync_rounded,
                  color: Colors.white70,
                  size: 22,
                ),
                tooltip: 'Simulate Next Status',
                onPressed: () => _cycleNextStatus(liveOrder, orderProvider),
              ),
              const SizedBox(width: 4),
            ],
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.isNewOrder)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF10B981).withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle_rounded,
                            color: Color(0xFF10B981),
                            size: 18,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Order placed successfully! Live tracking is active.',
                              style: GoogleFonts.inter(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF10B981),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // ============================================================
                // 1. TOP COPPER ESTIMATED ARRIVAL BANNER
                // ============================================================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFB35427),
                          Color(0xFFC76935),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFB35427).withOpacity(0.35),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Estimated Arrival',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.white.withOpacity(0.85),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              etaText,
                              style: GoogleFonts.inter(
                                fontSize: 26,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              etaSub,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                        ScaleTransition(
                          scale: status != OrderStatus.delivered
                              ? _pulseAnimation
                              : const AlwaysStoppedAnimation(1.0),
                          child: Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.22),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withOpacity(0.35),
                                width: 1.5,
                              ),
                            ),
                            child: const Icon(
                              Icons.electric_moped_rounded,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                // ============================================================
                // 2. DELIVERY PARTNER CARD & LIVE ROUTE PROGRESS
                // ============================================================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFF18181C),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: const Color(0xFF282830),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Courier Row
                        Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: const Color(0xFFB35427).withOpacity(0.2),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFFB35427).withOpacity(0.4),
                                ),
                              ),
                              child: const Icon(
                                Icons.person,
                                color: Color(0xFFE27C42),
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Vikram Singh',
                                    style: GoogleFonts.inter(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Sneakr Express Rider ★ 4.9',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: const Color(0xFF9CA3AF),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () => _showCallingDialog(
                                context,
                                'Vikram Singh',
                                '+91 98765 43210',
                              ),
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF10B981).withOpacity(0.15),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFF10B981).withOpacity(0.3),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.phone_rounded,
                                  color: Color(0xFF10B981),
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        // Route Progress Track Container
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 14),
                          decoration: BoxDecoration(
                            color: const Color(0xFF101014),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF222228),
                            ),
                          ),
                          child: Column(
                            children: [
                              // Route Track with icons
                              _buildRouteTracker(progressFraction, status),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // ============================================================
                // 3. ORDER TIMELINE SECTION
                // ============================================================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Order Timeline',
                    style: GoogleFonts.inter(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF18181C),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: const Color(0xFF282830),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        _buildTimelineStep(
                          stepNumber: 1,
                          title: 'Order Placed',
                          subtitle: 'Received at Sneakr fulfillment hub',
                          isCompleted: true,
                          isActive: status == OrderStatus.processing,
                          isLast: false,
                        ),
                        _buildTimelineStep(
                          stepNumber: 2,
                          title: 'Accepted',
                          subtitle: 'Assigned to authentication team',
                          isCompleted: true,
                          isActive: false,
                          isLast: false,
                        ),
                        _buildTimelineStep(
                          stepNumber: 3,
                          title: 'Preparing',
                          subtitle: 'Authenticating sneaker & quality check',
                          isCompleted: status == OrderStatus.shipped ||
                              status == OrderStatus.delivered,
                          isActive: status == OrderStatus.processing,
                          isLast: false,
                        ),
                        _buildTimelineStep(
                          stepNumber: 4,
                          title: 'Ready',
                          subtitle: 'Quality tested & sealed in premium box',
                          isCompleted: status == OrderStatus.shipped ||
                              status == OrderStatus.delivered,
                          isActive: false,
                          isLast: false,
                        ),
                        _buildTimelineStep(
                          stepNumber: 5,
                          title: 'Out for Delivery',
                          subtitle: 'Handed over to delivery rider',
                          isCompleted: status == OrderStatus.delivered,
                          isActive: status == OrderStatus.shipped,
                          isLast: false,
                        ),
                        _buildTimelineStep(
                          stepNumber: 6,
                          title: 'Delivered',
                          subtitle: 'Delivered safely to your hands',
                          isCompleted: status == OrderStatus.delivered,
                          isActive: status == OrderStatus.delivered,
                          isLast: true,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // ============================================================
                // 4. ORDER SUMMARY SECTION
                // ============================================================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Order Summary',
                    style: GoogleFonts.inter(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFF18181C),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: const Color(0xFF282830),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Items list
                        if (liveOrder.items.isNotEmpty)
                          ...liveOrder.items.map((cartItem) {
                            final snk = cartItem.sneaker;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Row(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF101014),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: SneakerImage(
                                      imagePath: snk.image,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${cartItem.quantity}× ${snk.name}',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.inter(
                                            fontSize: 13.5,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          'Size: UK ${cartItem.size} • ${snk.brand}',
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            color: const Color(0xFF9CA3AF),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    currencyFormatter
                                        .format(cartItem.totalPrice),
                                    style: GoogleFonts.inter(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          })
                        else
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Text(
                              'Sneaker Item',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),

                        const Divider(color: Color(0xFF282830), height: 24),

                        // Delivery Address
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.location_on_outlined,
                              size: 18,
                              color: Color(0xFFE27C42),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                liveOrder.address.isNotEmpty
                                    ? liveOrder.address
                                    : 'Default Address, Home Delivery',
                                style: GoogleFonts.inter(
                                  fontSize: 12.5,
                                  color: const Color(0xFFD1D5DB),
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // Payment Method
                        Row(
                          children: [
                            const Icon(
                              Icons.payment_outlined,
                              size: 18,
                              color: Color(0xFF10B981),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Payment: ${liveOrder.paymentMethod} (Paid)',
                              style: GoogleFonts.inter(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFFD1D5DB),
                              ),
                            ),
                          ],
                        ),

                        const Divider(color: Color(0xFF282830), height: 24),

                        // Grand Total Paid
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Grand Total Paid',
                              style: GoogleFonts.inter(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              currencyFormatter.format(liveOrder.total),
                              style: GoogleFonts.inter(
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                                color: const Color(0xFF10B981),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // Helper note / Simulate hint
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      'Tip: Tap the sync icon at top right to simulate live status change (Processing ➔ Shipped ➔ Delivered)',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 11.5,
                        color: Colors.white38,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 36),
              ],
            ),
          ),
        );
      },
    );
  }

  // ==========================================================================
  // ROUTE PROGRESS VISUALIZER
  // ==========================================================================
  Widget _buildRouteTracker(double progress, OrderStatus status) {
    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final trackWidth = constraints.maxWidth - 50; // space between icons
            final scooterLeft = (trackWidth * progress).clamp(0.0, trackWidth);

            return Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.centerLeft,
              children: [
                // Background Track Line
                Container(
                  height: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF282830),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Active Colored Track Line
                Container(
                  height: 4,
                  width: (trackWidth * progress).clamp(0.0, trackWidth) + 12,
                  margin: const EdgeInsets.only(left: 24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFB35427),
                        Color(0xFFE27C42),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Left: Warehouse / Store icon
                Positioned(
                  left: 0,
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: const Color(0xFFB35427).withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFB35427),
                        width: 1.5,
                      ),
                    ),
                    child: const Icon(
                      Icons.inventory_2_rounded,
                      color: Color(0xFFE27C42),
                      size: 14,
                    ),
                  ),
                ),

                // Right: Destination House icon
                Positioned(
                  right: 0,
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF10B981),
                        width: 1.5,
                      ),
                    ),
                    child: const Icon(
                      Icons.home_rounded,
                      color: Color(0xFF10B981),
                      size: 15,
                    ),
                  ),
                ),

                // Moving Scooter icon
                Positioned(
                  left: scooterLeft + 12,
                  child: ScaleTransition(
                    scale: status != OrderStatus.delivered
                        ? _pulseAnimation
                        : const AlwaysStoppedAnimation(1.0),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE27C42),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFE27C42).withOpacity(0.5),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.two_wheeler_rounded,
                        color: Colors.white,
                        size: 14,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Sneakr Hub',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF9CA3AF),
              ),
            ),
            Text(
              status == OrderStatus.delivered
                  ? 'Delivered'
                  : 'On the Way (Live)',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: status == OrderStatus.delivered
                    ? const Color(0xFF10B981)
                    : const Color(0xFFE27C42),
              ),
            ),
            Text(
              'Your Home',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF9CA3AF),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ==========================================================================
  // TIMELINE STEP BUILDER
  // ==========================================================================
  Widget _buildTimelineStep({
    required int stepNumber,
    required String title,
    required String subtitle,
    required bool isCompleted,
    required bool isActive,
    required bool isLast,
  }) {
    Color indicatorBg;
    Color indicatorBorder;
    Widget indicatorChild;

    if (isCompleted) {
      indicatorBg = const Color(0xFFB35427);
      indicatorBorder = const Color(0xFFB35427);
      indicatorChild = const Icon(
        Icons.check_rounded,
        size: 14,
        color: Colors.white,
      );
    } else if (isActive) {
      indicatorBg = const Color(0xFFB35427).withOpacity(0.2);
      indicatorBorder = const Color(0xFFE27C42);
      indicatorChild = Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(
          color: Color(0xFFE27C42),
          shape: BoxShape.circle,
        ),
      );
    } else {
      indicatorBg = Colors.transparent;
      indicatorBorder = const Color(0xFF4B5563);
      indicatorChild = Text(
        '$stepNumber',
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF9CA3AF),
        ),
      );
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Indicator column with line
          Column(
            children: [
              Container(
                width: 24,
                height: 24,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: indicatorBg,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: indicatorBorder,
                    width: 1.5,
                  ),
                ),
                child: indicatorChild,
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: isCompleted
                        ? const Color(0xFFB35427)
                        : const Color(0xFF282830),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),
          // Text Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight:
                          isActive || isCompleted ? FontWeight.w700 : FontWeight.w500,
                      color: isCompleted || isActive
                          ? Colors.white
                          : const Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: isCompleted || isActive
                          ? const Color(0xFF9CA3AF)
                          : const Color(0xFF4B5563),
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
}
// ============================================================================
// [END] FILE: order_tracking_screen.dart
// ============================================================================

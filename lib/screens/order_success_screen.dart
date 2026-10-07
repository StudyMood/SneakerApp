import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../models/order.dart';
import '../providers/order_provider.dart';
import '../widgets/custom_button.dart';
import '../widgets/main_navigation_shell.dart';
import 'orders_screen.dart';
import 'order_tracking_screen.dart';

class OrderSuccessScreen extends StatefulWidget {
  final OrderItem? order;

  const OrderSuccessScreen({super.key, this.order});

  @override
  State<OrderSuccessScreen> createState() => _OrderSuccessScreenState();
}

class _OrderSuccessScreenState extends State<OrderSuccessScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // Green Checkmark Badge
              ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: const BoxDecoration(
                    color: Color(0xFF28A745),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x3328A745),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 54,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Headline
              Text(
                'Order Placed\nSuccessfully!',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  height: 1.25,
                  color: isDark ? Colors.white : AppColors.textPrimaryLight,
                ),
              ),
              const SizedBox(height: 12),

              // Subtitle
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Thank you for shopping with SNEAKER.\nYour order will be delivered soon.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                    color: const Color(0xFF767676),
                  ),
                ),
              ),
              const Spacer(),

              // Primary: Track Order
              CustomButton(
                text: 'Track Order',
                onPressed: () {
                  final targetOrder = widget.order ??
                      context.read<OrderProvider>().latestOrder;

                  if (targetOrder != null) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => OrderTrackingScreen(
                          order: targetOrder,
                          isNewOrder: true,
                        ),
                      ),
                    );
                  } else {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const OrdersScreen()),
                    );
                  }
                },
              ),
              const SizedBox(height: 16),

              // Secondary: Continue Shopping
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const MainNavigationShell()),
                    (route) => false,
                  );
                },
                child: Text(
                  'Continue Shopping',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : AppColors.textPrimaryLight,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../models/order.dart';
import '../providers/order_provider.dart';
import '../widgets/sneaker_image.dart';
import 'order_tracking_screen.dart';

class OrdersScreen extends StatelessWidget {
  final bool showBackButton;

  const OrdersScreen({super.key, this.showBackButton = true});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currencyFormatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : Colors.white,
      appBar: AppBar(
        leading: showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
        title: Text(
          'My Orders',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : AppColors.textPrimaryLight,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          final orders = orderProvider.orders;

          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inventory_2_outlined,
                    size: 70,
                    color: isDark ? Colors.white24 : Colors.black12,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No orders placed yet',
                    style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            itemCount: orders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final order = orders[index];
              final firstItem = order.items.isNotEmpty ? order.items.first : null;
              final sneaker = firstItem?.sneaker;

              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => OrderTrackingScreen(order: order),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceDark : const Color(0xFFFAFAFA),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? AppColors.borderDark : const Color(0xFFEEEEEE),
                      ),
                    ),
                    child: Row(
                      children: [
                        // Sneaker Thumbnail
                        Container(
                          width: 75,
                          height: 75,
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF161616) : const Color(0xFFF3F3F5),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: sneaker != null
                              ? SneakerImage(
                                  imagePath: sneaker.image,
                                  fit: BoxFit.contain,
                                )
                              : const Icon(Icons.inventory_2_outlined, color: Colors.grey),
                        ),
                        const SizedBox(width: 14),

                        // Order Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                sneaker != null ? sneaker.name : 'Sneaker Order ${order.id}',
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
                                currencyFormatter.format(order.total),
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: isDark ? Colors.white : AppColors.textPrimaryLight,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    order.date,
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: const Color(0xFF8E8E93),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '• Tap to track',
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFFB35427),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Status Badge & Chevron
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _buildStatusBadge(order.status),
                            const SizedBox(height: 8),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 13,
                              color: isDark ? Colors.white38 : Colors.black26,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildStatusBadge(OrderStatus status) {
    Color textColor;

    switch (status) {
      case OrderStatus.delivered:
        textColor = const Color(0xFF28A745);
        break;
      case OrderStatus.shipped:
        textColor = const Color(0xFF495057);
        break;
      case OrderStatus.processing:
        textColor = const Color(0xFF007AFF);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: textColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status == OrderStatus.delivered
            ? 'Delivered'
            : status == OrderStatus.shipped
                ? 'Shipped'
                : 'Processing',
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: textColor,
        ),
      ),
    );
  }
}

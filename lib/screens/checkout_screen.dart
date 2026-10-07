import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../constants/colors.dart';
import '../providers/cart_provider.dart';
import '../providers/order_provider.dart';
import '../widgets/custom_button.dart';
import 'order_tracking_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPaymentMethod = 'UPI';
  String _address = '123 MG Road, Indore, MP - 452001';
  final String _name = 'Abhishek Sharma';
  String _phone = '+91 9876543210';
  bool _isProcessing = false;

  void _editAddress() {
    final addrController = TextEditingController(text: _address);
    final phoneController = TextEditingController(text: _phone);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Edit Shipping Address', style: GoogleFonts.inter(fontWeight: FontWeight.w700)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: addrController,
              decoration: const InputDecoration(labelText: 'Address'),
              maxLines: 2,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _address = addrController.text;
                _phone = phoneController.text;
              });
              Navigator.of(ctx).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _handlePayment(double total) {
    setState(() => _isProcessing = true);
    final cart = context.read<CartProvider>();

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        // Place order in OrderProvider
        final newOrder = context.read<OrderProvider>().placeOrder(
              items: cart.items,
              total: total,
              address: _address,
              paymentMethod: _selectedPaymentMethod,
            );

        // Clear cart
        cart.clearCart();

        setState(() => _isProcessing = false);

        // Navigate directly to Live Order Tracking Screen (Coffee shop style)
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => OrderTrackingScreen(
              order: newOrder,
              isNewOrder: true,
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currencyFormatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);
    final cart = context.watch<CartProvider>();
    final payAmount = cart.total > 0 ? cart.total : 27998.0;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Checkout',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : AppColors.textPrimaryLight,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Shipping Address Header
                  Text(
                    'Shipping Address',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Shipping Address Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.surfaceDark : const Color(0xFFFAFAFA),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? AppColors.borderDark : const Color(0xFFEEEEEE),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _name,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white : AppColors.textPrimaryLight,
                              ),
                            ),
                            InkWell(
                              onTap: _editAddress,
                              child: const Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Icon(Icons.edit_outlined, size: 18, color: Color(0xFF767676)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _address,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: const Color(0xFF767676),
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _phone,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: const Color(0xFF767676),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Payment Method Header
                  Text(
                    'Payment Method',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Payment Option 1: UPI
                  _buildPaymentOption(
                    title: 'UPI',
                    subtitle: 'Pay with any UPI app',
                    icon: Icons.account_balance_wallet_outlined,
                    value: 'UPI',
                    isDark: isDark,
                  ),
                  const SizedBox(height: 12),

                  // Payment Option 2: Credit / Debit Card
                  _buildPaymentOption(
                    title: 'Credit / Debit Card',
                    subtitle: 'Visa, Mastercard, RuPay',
                    icon: Icons.credit_card_outlined,
                    value: 'Credit / Debit Card',
                    isDark: isDark,
                  ),
                  const SizedBox(height: 12),

                  // Payment Option 3: Cash on Delivery
                  _buildPaymentOption(
                    title: 'Cash on Delivery',
                    subtitle: 'Pay at your doorstep',
                    icon: Icons.payments_outlined,
                    value: 'Cash on Delivery',
                    isDark: isDark,
                  ),
                ],
              ),
            ),
          ),

          // Bottom Bar - Pay Button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : Colors.white,
              border: Border(
                top: BorderSide(
                  color: isDark ? AppColors.borderDark : const Color(0xFFEEEEEE),
                ),
              ),
            ),
            child: SafeArea(
              child: CustomButton(
                text: 'Pay ${currencyFormatter.format(payAmount)}',
                isLoading: _isProcessing,
                onPressed: () => _handlePayment(payAmount),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required String value,
    required bool isDark,
  }) {
    final isSelected = _selectedPaymentMethod == value;

    return GestureDetector(
      onTap: () {
        setState(() => _selectedPaymentMethod = value);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : const Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? (isDark ? Colors.white : AppColors.primary)
                : (isDark ? AppColors.borderDark : const Color(0xFFEEEEEE)),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF242424) : const Color(0xFFF0F0F2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 22,
                color: isDark ? Colors.white : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : AppColors.textPrimaryLight,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xFF767676),
                    ),
                  ),
                ],
              ),
            ),
            Radio<String>(
              value: value,
              groupValue: _selectedPaymentMethod,
              activeColor: isDark ? Colors.white : AppColors.primary,
              onChanged: (val) {
                if (val != null) {
                  setState(() => _selectedPaymentMethod = val);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
